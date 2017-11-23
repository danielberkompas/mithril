# How To

The following guides will help you solve common architectural problems.

---

## Authorization

Most applications revolve around users and what they can and can't do.
While each application is different in this regard, there are common 
patterns.

### Project Setup

If your application has users, you should pass the `--accounts` option
to Mithril's project generator.

```bash
$ mix gen mithril my_app --accounts --ecto postgres --email
```

This will generate an `Accounts` domain in your `my_app` logic app, with
support for:

- User registration (email/password)
- Login with email/password (creates unique, expiring tokens)
- Forgot password

### Authentication

Mithril's `Accounts` domain uses token authentication. A client app
submits credentials it received from a human, and receives a unique,
expiring `token` back.

```elixir
Accounts.create_login_token("my@email.com", "password")
# => {:ok, "uJHr9+dfj4fNj8cGk8EUCQ==", %Accounts.User{...}}
```

The client app is responsible to store this `token` and pass it in subsequent
calls to domain functions.

- A **Phoenix** client might store the `token` in the **cookie session**
- A **GraphQL/REST** client might give the `token` to a mobile app to store

### Identifying Users

Each domain function that needs to identify a user must take a `token` as one
of its arguments.

```elixir
# only some users can create pages
MyApp.CMS.create_page(token, params)
```

It's easy to do this with a simple extra function head for `create_page/2`:

```elixir
# Extra function head translates token into a user_id by calling into
# the `Accounts` domain. If this fails, the function will return whatever
# error `Accounts.get_user_by_token/1` returned.
def create_page(token, params) when is_binary(token) do
  with {:ok, %{id: user_id}} = Accounts.get_user_by_token(token) do
    create_page(user_id, params)
  end
end

# Only the `token` version of this function should be called by a client
# app, but we still have a `user_id` version for other domains to use and
# to make the function easier to test.
def create_page(user_id, params) when is_integer(user_id) do
  # Actually perform the operation
end
```

### Authorizing Actions

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

def create_page(user_id, params) do
  with :ok <- authorize(:create_page, user_id) do
    # create the page
  end
end
```

If you want a DSL for this, you can build one with [Decorator](https://github.com/arjan/decorator).

### Benefits

This approach to authorization has several benefits.

1. **Security**
    - Because the logic app both identifies users and enforces permission rules, 
      we can be very confident that those rules are _always applied_.
    - Client logins can be revoked by the logic app. For example, when a user
      changes their password in the mobile app, we can easily revoke all web
      sessions for that user.

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

### FAQ

#### 1. **Why can't client apps pass `user_id`?**

  You might be tempted to store `user_id` in your Phoenix session, and pass this to domain
  functions instead of a token. This reduces the amount of code in your domain modules
  because you don't have to translate tokens into `user_id`s.

  **Why it's bad**: It makes your client Phoenix app control how long a user stays logged in, via the
  time-to-live on the Phoenix session cookie.

  - The logic app can't expire or revoke the session, it must rely on the client

  - The logic app is no longer in control of an important business concern: session duration

  - The client app is telling the logic who is logged in, which means that the client
    can impersonate anyone.

#### 2. **Why can't we use Plug or Absinthe Middleware for authorization?**

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

#### 3. **Doesn't this approach couple all my domains to my `Accounts` domain?**

  Yes, it does. Each domain which needs to enforce permissions relies on 
  `Accounts.get_user_by_token` to convert tokens into user ids. This coupling can be 
  reduced by adding a protocol to your domain:

  ```elixir
  defprotocol MyApp.CMS.Identity do
     @spec identify_user(MyApp.CMS.UserProtocol.t) :: {:ok, integer} | {:error, term}
     def identify_user(identifier)
  end
  ```

  Since tokens are binaries, you can implement this protocol for tokens by implementing
  it for binaries. This implementation is where you call out to 
  `Accounts.get_user_by_token(token)`:

  ```elixir
  # Implements protocol for tokens
  defimpl MyApp.CMS.Identity, for: Binary do
    alias MyApp.Accounts

    def identify_user(token) do
       with {:ok, %{id: user_id}} <- Accounts.get_user_by_token(token) do
         {:ok, user_id}
       end
    end
  end
  ```

  You should implement it for `Integer` too, in case when you're given a user ID rather 
  than a token.

  ```elixir
  defimpl MyApp.CMS.Identity, for: Integer do
     def identify_user(id), do: {:ok, id}
  end
  ```

  Then, instead of extra function heads, you can rely on your protocol to convert
  parameters into user IDs.

  ```elixir
  alias MyApp.CMS.Identity
  import MyApp.CMS.Authorization

  def create_page(user_identifier, params) do
     with {:ok, user_id} <- Identity.identify_user(user_identifier),
          :ok <- authorize(:create_page, user_id) do
        # Create the page
     end
  end
  ```

  In this approach, you only reference `Accounts` from your `Identity` protocol
  implementation, which makes it easier to change and creates less coupling.

---

## Dependent Domains

Domains will inevitably depend on each other. By depending on other domains,
each domain is able to focus on only the things it cares about, and reduce code
duplication.

However, there are some basic rules of thumb to keep in mind when making domains
depend on one another.

### 1. Keep the Dependency One-Way

If Domain A relies on Domain B, Domain B must not also rely on Domain A.

![One-way dependencies are good](_images/one_way_dependency.svg)

![Two-way dependencies are bad](_images/two_way_dependency.svg)

If two domains _must_ rely on each other, this is a hint that they should be 
merged into a single domain. They obviously are tightly coupled together, and 
therefore should be one entity.

#### Examples

- **GOOD**: `Accounts` calls the `Notifications` domain to send notifications to an 
  email address, passing the email address as an argument.

- **BAD**: `Accounts` calls the `Notifications` domain to send notifications to a
  `user_id`. `Notifications` queries `Accounts` for the email address to use.

### 2. Reduce Coupling When Possible

Decoupled domains are easier to reuse in other projects or extract to libraries. 
It's always a balancing act because decoupling domains always comes with a little
more overhead and formality.

There are several ways to reduce coupling between domains. 

#### [Protocols](https://hexdocs.pm/elixir/Kernel.html#defprotocol/2)

Instead of relying on a data type from another domain directly, your domain can expose a
data protocol which is then _implemented_ for the foreign data type. Your domain's true 
dependency is then _on the protocol_, not on the data format returned by another domain.

See the [Authorization FAQ](/how-to?id=_3-doesn39t-this-approach-couple-all-my-domains-to-my-accounts-domain)
for an example.

#### [Behaviours](https://hexdocs.pm/elixir/behaviours.html)

A domain that relies on other domains to perform actions can define a `Behaviour` instead
of calling those domains directly. See [the Callback Pattern](/how-to?id=callback-pattern) 
for an example.

The domain is really then relying _on the behaviour_, not other domains. The behaviour just
happens to be implemented in such a way as to call other domains.

---

## If-This-Then-That

Many applications have if-this-then-that logic which crosses domains. 
For example:

- When a status is changed, add it to an activity feed
- When someone visits a page, increment a page view counter

In the activity feed example, you might have two domains:

- `Issues`: Handles submitting and storing bug reports.
- `Activities`: Provides activity feeds

The simplest way to do this is just to have `Issues` call `Activities`
when the status changes.

```elixir
Activities.create_activity("issue", issue.id, %{...})
```

This works well when:

- You have only one subscriber to this event, `Activities`
- The subscriber is within the `my_app` logic application, not a client app

However, when you have multiple subscribers or you need to do something
in a client app (like send a Websocket message), a different pattern is
required.

### Callback Pattern

The callback pattern allows your domain to notify multiple other domains and
client applications about an event.

Define a `MyDomain.Callback` module in your domain folder. This module is a 
[Behaviour](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html#behaviours)
which defines what a subscriber module do your domain's events must look like.

In the activity feed example, this might look like:

```elixir
# lib/my_app/issues/callback.ex
defmodule MyApp.Issues.Callback do
  # Mithril generates this callback module into your application
  use MyApp.Callback

  @type id :: integer
  @type attrs :: map

  # Define what functions each subscriber must implement, and their
  # type signature with typespecs. Limit the data which is passed as
  # much as possible to keep the subscribers lean.
  #
  # Avoid passing Ecto structs, if possible.
  @doc """
  You can document each callback, and you should. Describe when it will be
  called and what the arguments represent.
  """
  @callback issue_created(id, attrs) :: :ok | no_return

  @doc "..."
  @callback issue_updated(id, attrs) :: :ok | no_return
end
```

Each domain or client app that needs to subscribe to these events defines a 
subscriber module:

```elixir
# lib/my_app/activities/event_handler.ex
defmodule MyApp.Activities.EventHandler do
  @behaviour MyApp.Issues.Callback

  def issue_created(issue_id, attrs) do
    # add activity item to appropriate feed
  end

  def issue_updated(issue_id, attrs) do
    # add activity item to appropriate feed
  end
end

# apps/my_app_web/callback.ex
defmodule MyAppWeb.Callback do
  @behaviour MyApp.Issues.Callback

  alias MyAppWeb.Endpoint

  # Broadcast a websocket message on the "issues" channel
  def issue_created(issue_id, attrs) do
    Endpoint.broadcast("issues", "issue_created", %{id: issue_id, attrs: attrs})
  end

  # Broadcast a websocket message on the "issues" channel
  def issue_updated(issue_id, attrs) do
    Endpoint.broadcast("issues", "issue_updated", %{id: issue_id, attrs: attrs})
  end
end
```

You can inject subscriber modules into the `MyApp.Issues.Callback` via 
configuration.

```elixir
# Other domain modules should be added to the callback module's internal 
# subscribers list so that they can't be accidentally disabled.
defmodule MyApp.Issues.Callback do
  use MyApp.Callback, modules: [MyApp.Activities.EventHandler]
end

# Modules in client apps can be injected via configuration:
config :my_app, MyApp.Issues.Callback,
  modules: [
    MyAppWeb.Callback
  ]
```

Finally, within the `Issues` domain, you call `execute` to send the notifications
at the appropriate times. This will call the given function on all the subscriber
modules with the provided args.

```elixir
alias MyApp.Issues.Callback

# On success, within Issues.create_issue
Callback.execute(:issue_created, [issue.id, changes])

# On success, within Issues.update_issue
Callback.execute(:issue_updated, [issue.id, changes])
```

This approach has many benefits:

- Subscribers can be added at will, without updating `Issues`.
- `Issues` provides an _explicit contract_ for subscribers in `Issues.Callback`.
  If the contract changes, the compiler will throw warnings about subscribers
  that don't adhere to the new contract.

---
