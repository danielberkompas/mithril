# Conventions

## Project Structure

Mithril applications are Elixir [Umbrella](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html#umbrella-projects)
apps. The code is organized into several [OTP apps](https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html#understanding-applications)
in the `apps/` directory.


```bash
my_app/
├── README.md
├── apps
│   ├── my_app     # Business logic ("Domains"), persistence
│   └── my_app_api # GraphQL API
│   └── my_app_web # Phoenix Endpoint
├── bin
│   ├── reset      # Resets and rebuilds the project
│   ├── setup      # Sets up all dependencies
│   ├── test       # Runs tests like they would run on CI
│   └── update     # Updates the project (for mobile devs)
├── config
├── mix.exs
└── mix.lock
```

Each app has specific, isolated responsibilities.

- `my_app` A pure Elixir app which handles **logic** and **persistence**, with 
  few dependencies.
- `my_app_api` [Client] The API for the project. (Usually GraphQL) Calls into 
  `my_app`'s logic.
- `my_app_web` [Client] Tiny Phoenix app which mounts the API and calls into 
  `my_app`'s logic.

## Domains

Within `my_app`, logic is divided between _domains_. Each domain contains the 
logic to support a specific feature or group of _closely-related_ features.

For example, you might have an `Accounts` domain to handle user registration,
forgot password, and login. Such a domain would have the following structure:

```bash
lib
└── my_app
    └── accounts         # Each domain gets a folder in lib/
        ├── accounts.ex  # MyApp.Accounts module providing the public interface
        └── user.ex      # Ecto schema representing a user
```

The `accounts/accounts.ex` file defines `MyApp.Accounts`, which is the public
interface for this domain. It is important to document this module well, 
including [typespecs](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html).

```elixir
defmodule MyApp.Accounts do
  @moduledoc """
  Describe what this domain is for...
  """

  @doc """
  Document the create_user function...
  """
  @spec create_user(map) :: 
    {:ok, MyApp.Accounts.User.t} | 
    {:error, Ecto.Changeset.t}
  def create_user(params) do
    # create a user here
  end
end
```

Domains can contain other internal modules, but _**only the public interface can
be called from outside the domain**_. This gives the domain complete flexibility
on its internals going forward.

- Each domain handles its own persistence _internally_.
- Domains may call other domains' public interfaces. But _be careful_:
  - Carefully consider whether the domains should be separate
  - Document the relationship between the two domains

## Client Applications

`my_app_api` and `my_app_web` are considered _client applications_ of `my_app`.
They exist solely to give `my_app` the ability to speak HTTP or GraphQL or
whatever other protocol `my_app` needs to speak to the outside world.

Think of these apps as _translators_. In human language, the concepts, 
ideas and actions that we communicate are the same; the language we speak is just
a protocol for communicating those things.

Likewise, `my_app` contains the concepts and actions, and these client 
applications act as translators for those concepts and actions for a protocol
like HTTP or GraphQL.

There are two rules of thumb with regard to client applications:

1. **Translator Only**. They must only _wrap_ `my_app`. All business logic concerns
   must be handled by `my_app`, with the client app only providing translation.

2. **Client Only**. `my_app` must be unaware of the client app's existence, and not
   rely on a client app to do anything but translate.

## Libraries

The `apps/` directory is a perfect incubator for new Elixir libraries. If a piece
of logic or client application code could be reused in other projects, it can make
sense to extract that code to a library in `apps/`.

```bash
$ cd apps/
$ mix new my_library
```

You can then copy code over to `apps/my_library` and update the dependencies of the
apps that rely on it:

```elixir
def deps do
  [
    {:my_library, in_umbrella: true}
  ]
end
```

When the library is mature, it should be extracted to its own repository and published
to Hex. Then, all you'll need to do is update your deps again:

```elixir
def deps do
  [
    {:my_library, ">= 0.0.0"}
  ]
end
```