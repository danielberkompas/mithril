# Domains

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

### Recommendations

1. Domains can contain other internal modules, but _**you should only call the public 
   interface functions from outside the domain**_. This gives the domain complete 
   flexibility on its internals going forward.

2. Each domain handles its own persistence _internally_.

3. Domains _may_ call other domains' public interfaces. But _be careful_! If
   two domains are closely connected, that might be hint they should be a single
   domain.
