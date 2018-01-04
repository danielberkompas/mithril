# How To

The following guides will help you solve common architectural problems.

---

## Architect Domains

Designing your application around [domains](/conventions?id=domains) can 
be difficult at first. This guide will help you get started.

#### 1. Break down the spec into _actions_

Take your **functional spec** or **visual design** and do a brainstorming
session. For each screen or page, identify each action the screen allows or
requires, for example:

- "List products"
- "View product"
- "Update company profile"
- "Count page views"
- "Export CSV of tracking data"
- "Render chart of page views over time"

Think in terms of _verbs_, not nouns. Focus on what the app _does_, not what
it is made of.

#### 2. Group the actions into _domains_

Once you have your complete list of actions in a file or up on a board, start
grouping related actions together. These "buckets" of related actions become
your domains.

**Be careful with your names**. Avoid generic, meaningless names like "Admin"
for your domains. Instead, use a name that summarizes the feature, for example:

- **Inventory**
  - "List products"
  - "View product"
- **Profiles**
  - "Update company profile"
- **Reports**
  - "Count page views"
  - "Export CSV of tracking data"
  - "Render chart of page views over time"


#### 3. Convert the actions into _functions_

Next, think about each action and convert it into a function. Describe what
arguments it takes and what it returns. This will also force you to think 
about the _types_ (nouns) that your application needs.

Fill in any functions, types, or domains that you know you'll need to make
the domains you outlined work. In this case, we discovered that we needed a
"Companies" domain:

- **Companies**
  - Types
    - `Company`: name
  - Actions
    - `create_company(params)`: creates a company
- **Inventory**
  - Types
    - `Product`: name, sku, quantity in stock, company
  - Functions
    - `list_products(company_id)`: Returns a list of products for the given 
      `company_id`.
    - `get_product(product_id)`: Returns a product by its ID.
- **Profiles**
  - Types
    - `Profile`: company_id, address, bio
  - Functions
    - `create_profile(company_id, params)`: Creates a profile for a given 
      company.
    - `get_profile(company_id)`: Gets a profile for a given company.
    - `update_profile(profile, params)`: Updates a profile.
- **Reports**
  - Types:
    - `PageView`: metadata
  - Functions
    - `page_view_count(company_id)`: returns page view count for a given
      company.
    - `export(:page_views, company_id, :csv)`: Exports CSV of page views
      for a given company
    - `page_view_series(company_id, start, end)`: Returns a series of
      page view data that can be plotted to a chart.

#### 4. Add OTP where beneficial

Thanks to Erlang, Elixir has access to an amazing set of OTP conventions
and libraries built into the language. At this point, now that you know
the public API of your domains, examine each domain to decide where you
need OTP features.

!> OTP will limit your deployment options, because your app will be
   stateful. You'll need more fine-grained control over your deployed
   instances, and they will need network access to each other.

##### Types
Don't assume that your domain types must be structs or be backed by a 
database table.

Most domain types can be represented as [GenServers][genserver], and 
collections can be represented as [Supervision][supervisor] trees. This
can be helpful in some cases, though definitely not all.

?> See the excellent talk ["Selling Food with Elixir"](https://www.youtube.com/watch?v=fkDhU-2NWJ8)
   from ElixirConf 2016 for an example of how this works in the real 
   world, and why you would do it.

?> See the [LearnElixir.tv](https://www.learnelixir.tv) episode
   ["Applications"](https://www.learnelixir.tv/episodes/16-applications) for
   an example of how to build a todo list with [GenServer][genserver].

?> See the [Elixir OTP Guide](https://elixir-lang.org/getting-started/mix-otp/agent.html)
   starting at "Agent" for a walkthrough on how to use OTP.

[supervisor]: https://hexdocs.pm/elixir/Supervisor.html

##### Realtime or Concurrent
Anything that needs to be done in realtime, where multiple subscribers
or people are looking at it simultaneously, could probably benefit from
[GenServer][genserver] and supervision trees.

[genserver]: https://hexdocs.pm/elixir/GenServer.html

##### Background Tasks
Any cron-like operation that needs to happen on a regular basis can easily
be done with a [GenServer][genserver].

##### Unreliable 3rd Parties

Whenever you must rely on third parties who are unreliable, your app can benefit
from wrapping those third parties with a [supervision tree][supervisor].

##### State Machines

Use [GenServer][genserver]
or [gen_statem](http://www.erlang.org/doc/man/gen_statem.html).

?> **Example A**:
   Tracking students to and from school, in realtime.
  
?> **Example B**:
   Multiplayer board game, where each player has a turn.
  
?> **Example C**:
   Bank accounts; depositing/withdrawing money. 

#### 5. Add persistence

In contrast with "The Rails Way", it's only here at the end that you should
think about persistence. Only now, when you have the domains, functions, and
OTP supervision tree laid out do you really know what kind of persistence
your app needs.

### Conclusion

You now have a set of well-scoped domains, with all their types, public
functions, and persistence defined. From here, you can move on to:

- Implement the domains
- Layer on a GraphQL API
- Layer on an HTML interface with Phoenix

---

## Authorization

Most applications revolve around users and what they can and can't do.
While each application is different in this regard, there are common 
patterns.

### Project Setup

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
OTP app.

### Authentication

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

### Identifying Users in Other Domains

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

def create_page(identity, params) do
  with {:ok, user_id} <- Identity.user_id(identity),
       :ok <- authorize(:create_page, user_id) do
    # create the page
  end
end
```

### Benefits

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

See ["Identifying Users"](/how-to?id=identifying-users-in-other-domains) for an example.

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

## Internationalization

Elixir has excellent internationalization support via the [Gettext][gettext]
library. To use it with your Mithril project, call the Mithril generator with
the `--gettext` option.

```bash
$ mix gen mithril intl --gettext
```

Read the [Gettext docs][gettext] for details on how it works.

### Where to Translate

Translations are _interface_ concerns, and therefore belong in client applications
like your Phoenix app or GraphQL app. Your logic application should return atoms
like `:not_found` or `:unauthorized`, and leave translation up to the client.

```elixir
{:error, :not_found}
{:error, :unauthorized}
```

### How to Translate

It's important to bear in mind how the _translator_ will interact with your
Gettext files. When you add a string to the application, you're going to send
over a blank or partially filled out Gettext file to a translator.

The translator will use his own Gettext software to open up the file and will
see an interface much like this:

![Gettext Translator Interface](_images/gettext_translator.png)

The translator needs to see the English string as the key for the translation
so that they know how to translate it. This means that you should use full,
English strings everywhere, not shorthand, because the string you pass in
becomes the key for the translation.

```elixir
# Good
put_flash(conn, :error, gettext("Record not found!"))

# Bad
put_flash(conn, :error, gettext("not_found"))
```

If you find yourself reusing the same or similar strings, then extract those
parts to a shared module or [fallback controller](https://hexdocs.pm/phoenix/1.3.0/Phoenix.Controller.html#action_fallback/1).

```elixir
defmodule MyAppWeb.ErrorMessages do
  import MyAppWeb.Gettext

  def not_found do
    gettext("Record not found!")
  end
end

# Usage
import MyAppWeb.ErrorMessages

put_flash(conn, :error, not_found())
```

### Software to Recommend

Most translators will be familiar with the `.po` file format that Gettext uses,
and already have their favorite software. However, if this is not the case, you
can recommend the following software options:

- [POEdit](https://poedit.net/) (MacOS app)
- [POEditor](https://poeditor.com) (Online SaaS)

[gettext]: https://hexdocs.pm/gettext/

---

## Testing

You should focus your automated test suite on the following areas.

### 1. Domain Public Interfaces

You should thoroughly test the public interface of each domain in your logic app,
including edge cases.

!> However, _it is not important_ to write tests on the private modules and internal 
   workings of each domain. In fact, this can be counter-productive, because it makes
   it harder to refactor the internals of a domain.

### 2. Client Application Public Interfaces

It isn't enough to test your domains. You also need to test that your client
applications are providing usable public interfaces. Just because your domains work
doesn't mean your client interfaces call the domains correctly.

!> You don't have to test each client interface for all edge cases, because edge 
   cases are mainly tested on the domains. As long as your domains are well-tested, 
   "smoke screen" tests are enough for your client interfaces.

In your `Phoenix` client app, your public interfaces are Phoenix controllers,
HTML templates, and websocket channels. To test these, you'll need:

- Controller tests
- Channel tests
- In-browser tests (via Hound and Chromedriver) for critical flows

In your `GraphQL` client app, your public interfaces are mutations, queries,
and subscriptions. Accordingly, you'll need:

- Query tests
- Mutation tests
- Subscription tests

### Regressions

When a bug occurs in production, and you fix it, you should write a test to prevent
that bug from occuring again. Where you put the regression test depends on the source of 
the bug.

For **domain logic bugs**, write the test in the domain's public interface test file.

For **client interface bugs**, such as when the client calls a domain with incorrect
arguments, write the test in the client interface's test file.