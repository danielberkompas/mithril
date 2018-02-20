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

It will also generate the necessary Phoenix controllers in `my_app_web`
for login and forgot password.

## Authentication

The `Accounts` domain uses token authentication. A client app
submits credentials it received from a human, and receives a unique,
expiring `token` back.

```elixir
Accounts.tokenize({"my@email.com", "password"})
# => {:ok, %Accounts.Token{token: "uJHr9+dfj4fNj8cGk8EUCQ=="}}
```

The client app is responsible to store this `token` in its session, and use
it to identify the user _on each request_.

- A **Phoenix** app will store the `token` in its **cookie session**. It will
  populate `conn.assigns.current_user` by calling `Accounts.authenticate/2`
  with the token.

- A **GraphQL/REST** app will give the `token` to its clients to store. It will
  populate the `context.current_user` by calling `Accounts.authenticate/2`.

**IMPORTANT**: Client apps _may not_ store the ID of the current user in
any storage system that persists between requests. They must store _only_ the
token. This allows the logic app to revoke sessions at will by invalidating
tokens.

## Authorizing Actions

Each domain is expected to implement its own permissions logic. The best way
to do this is to create a private `Authorization` module in your domain.

```elixir
defmodule MyApp.CMS.Authorization do
  def authorize(:create_page, user_id) do
    # Decide whether user can create the page or not,
    # return :ok or {:error, :unauthorized}
  end
end
```

It's okay for this `Authorization` module to call other domains. The important
thing is that all the authorization logic for the domain is in one place.

Your domain functions should call this `Authorization` module to authorize
user actions:

```elixir
import MyApp.CMS.Authorization

def create_page(user_id, params) do
  with :ok <- authorize(:create_page, user_id) do
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

3. **Documentation**
    - The permission rules for each domain (and each function) are clearly documented 
      in that domain's `Authorization` module. This makes them easier to reason about.

4. **Testing**
    - Each permission rule can be tested by simply calling a function. No complex
      middleware setup is required.

## FAQ

### 1. **Why can't client apps store `user_id` in the session?**

You might be tempted to store `user_id` in your Phoenix session, instead of validating the token
on each request.

**Why it's bad**: It makes your client app control how long a user stays logged in, via the
time-to-live on the storage system you're using. This prevents the logic app from being
able to expire or revoke sessions.

### 2. **Why not use `Plug` or `Absinthe.Middleware` for permission checking?**

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