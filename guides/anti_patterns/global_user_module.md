# Global User Module

```elixir
defmodule MyApp.Accounts.User do
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :skype, :string
    field :email, :string
    field :encrypted_password, :string
  end
end
```

This anti-pattern manifests in two ways:

1. Adding fields to `Accounts.User` that are not authentication-related
2. Passing the full `Accounts.User` to other domains' functions

The solution is to move all non-authentication fields to a `Profiles`
domain:

```elixir
defmodule MyApp.Profiles.Profile do
  schema "profiles" do
    field :user_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :skype, :string
  end
end
```

Whenever you need profile information, fetch it using a `Profiles` domain
function.

```elixir
Profiles.get_profile(user_id) # Or an Accounts.Token struct
```

Pass either a raw `user_id` or `Accounts.Token` struct (as described in the
[Authorization guide](authorization.html)), not the full user.

### Why

Global user modules become a dangerous form of global state. Everything
in the application begins to rely on them. A change to the user potentially
affects everything in the application.

By limiting the user to only authentication-related fields, and only
passing user_id instead of the whole user, you get several benefits:

- Each domain can handle its user-related data internally, instead of
  relying on it coming in from outside. This allows great flexibility
  within each domain.

- Refactoring any domain is easy, because only `user_id` is shared. You
  can change anything about how authentication is done, and nothing
  will break.

See ["What's wrong with a global User module?"](https://medium.com/appunite-edu-collection/whats-wrong-with-a-global-user-module-ed7ed013a519)
for more details.

