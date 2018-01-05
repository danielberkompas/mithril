# Authorization

Most applications revolve around users and what they can and can't do.
While each application is different in this regard, there are common 
patterns.

## Project Setup

If your application has users, you can pass the `--accounts` option
to Mithril's project generator.

```bash
$ mix gen mithril my_app --accounts --ecto postgres --email
```

This will generate an `Accounts` domain based on
[Authority](https://github.com/infinitered/authority) in your `my_app` logic
app, with support for:

- User registration (email/password)
- Login with email/password (creates unique, expiring tokens)
- Forgot password

It will also generate the necessary Phoenix controllers in your `my_app_web`
OTP app for login and forgot password.

## Authentication

The `Accounts` domain uses token authentication. A client app
submits credentials it received from a human, and receives a unique,
expiring `token` back.

```elixir
Accounts.tokenize({"my@email.com", "password"})
# => {:ok, %Accounts.Token{token: "uJHr9+dfj4fNj8cGk8EUCQ=="}}
```

The client app is responsible to store this `token` and pass it in subsequent
calls to domain functions.

- A **Phoenix** client will store the `token` in the **cookie session** (See
  the generated `MyAppWeb.Session` module for how to do this)
- A **GraphQL/REST** client might give the `token` to a mobile app to store

## Identifying Users in Other Domains

Each domain function that needs to identify a user must take an
`Accounts.Token` as one of its arguments.

```elixir
# only some users can create pages
MyApp.CMS.create_page(token, params)
```

It must then convert that token to a user ID. The simplest way to do this is
to just call `Accounts.authenticate` from your function.

```elixir
def create_page(token, params) do
  with {:ok, %{user: %{id: user_id}}} <- Accounts.authenticate(token) do
    # Create a page if the user_id is allowed to do so
  end
end
```

Or, you can isolate all the calls to `Accounts` into a protocol, named
`Identity`.

```elixir
defprotocol MyApp.CMS.Identity do
  @spec user_id(any) :: {:ok, user_id} | {:error, term}
  def user_id(identity)
end

# Support plain integer User IDs for convenience in tests
defimpl MyApp.CMS.Identity, for: Integer do
  def user_id(id) do
    {:ok, id}
  end
end

# Support `Accounts.Token` structs
defimpl MyApp.CMS.Identity, for: MyApp.Accounts.Token do
  def user_id(token) do
    with {:ok, %{id: id} <- MyApp.Accounts.authenticate(token) do
      {:ok, id}
    end
  end
end
```

This helps DRY up your logic, especially if you have many functions which
all need to do the same thing.

```elixir
def create_page(identity, params) do
  with {:ok, user_id} <- Identity.user_id(identity) do
    # Decide whether the user_id is allowed to create the page
  end
end
```

It also has the added benefit that it's easy to extend the domain to accept
other structs, as long as a user_id can be deduced from them.

## Authorizing Actions

Each domain is expected to implement its own permissions logic. The best way
to do this is to create a private `Authorization` module in your domain.

```elixir
defmodule MyApp.CMS.Authorization do
  def authorize(:create_page, user_id) do
    # Decide whether user can create the page or not,
    # return :ok or {:error, :not_authorized}
  end
end
```

It's okay for this `Authorization` module to call other domains. The important
thing is that all the authorization logic for the domain is in one place.

Your domain functions should call this `Authorization` module to authorize
user actions:

```elixir
import MyApp.CMS.Authorization

def create_page(identity, params) do
  with {:ok, user_id} <- Identity.user_id(identity),
       :ok <- authorize(:create_page, user_id) do
    # create the page
  end
end
```

## Benefits

This approach to authorization has several benefits.

1. **Security**
    - Because the logic app both identifies users and enforces permission rules, 
      we can be very confident that those rules are _always applied_.
    - Client logins can be revoked by the logic app. For example, when a user
      changes their password in the mobile app, we can easily revoke all web
      sessions for that user by removing or invalidating tokens.

2. **Simplicity**
    - All client apps use the same authentication method: tokens.
    - Client apps are much simpler. They only have to pass parameters and tokens
      around rather than concerning themselves with authorization.

3. **Documentation**
    - The permission rules for each domain (and each function) are clearly documented 
      in that domain's `Authorization` module. This makes them easier to reason about.

4. **Testing**
    - Each permission rule can be tested by simply calling a function. No complex
      middleware setup required.

## FAQ

### 1. **Why can't client apps pass `user_id`?**

You might be tempted to store `user_id` in your Phoenix session, and pass this to domain
functions instead of a token. This reduces the amount of code in your domain modules
because you don't have to translate tokens into `user_id`s.

**Why it's bad**: It makes your client Phoenix app control how long a user stays logged in, via the
time-to-live on the Phoenix session cookie.

- The logic app can't expire or revoke the session, it must rely on the client

- The logic app is no longer in control of an important business concern: session duration

- The client app is telling the logic who is logged in, which means that the client
  can impersonate anyone.

### 2. **Why can't we use Plug or Absinthe Middleware for authorization?**

It's tempting to use Plug or Absinthe Middleware to require certain permissions on
actions, because it seems to DRY up your code.

**Why it's bad**: It creates an implicit dependency between your logic functions and
the middleware.

- The dependency is _implicit_ and undocumented. When permissions checks are spread
  throughout many plugs, pipelines, or middleware, it becomes very difficult to see 
  what users can do what actions.

- The client app and the logic become _tightly coupled_, because the client app is
  enforcing the permissions, which are a core business logic concern. The logic and
  the client become inseparable.

  - This makes it hard to create new client apps. You have to painstakingly reproduce
    the middleware from your first client in your second client, because the backend
    logic app doesn't enforce permissions.

- Permissions are _difficult to test_, because you have to set up and run a middleware
  pipeline to apply them. This results in _security bugs_.

In contrast, when you follow the guidelines above, your permission logic will be
explicit, well documented, decoupled from your client apps, and easily testable.

