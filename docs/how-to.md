# How To

The following guides will help you solve common architectural problems.

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