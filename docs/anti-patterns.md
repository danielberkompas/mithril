# Anti-Patterns

You must avoid the following patterns in your Mithril application.

---

## Global User Module

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
Profiles.get_profile(user_id)
```

Also, you should only pass `user_id` to other domain functions, not the
entire user struct.

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

---

## Cross-Domain Ecto Relationships
This anti-pattern manifests when you create an Ecto relationship between
a schema in the current domain and a schema in a different domain.

```elixir
defmodule MyApp.DomainA.MySchema do
  use Ecto.Schema

  schema "my_table" do
    has_many :other_schema, MyApp.DomainB.OtherSchema
  end
end
```

Instead, you should define a public function on `DomainB` to get related 
data for your schema.

```elixir
DomainB.list_other_schemas(my_schema_id)
```

### Why

Creating an Ecto relationship between domain schemas creates a dependency between 
them. It makes Domain A rely on Domain B's internal data storage logic, tightly
coupling both domains to that logic.

It encourages you to use implicit data fetching logic via `Repo.preload`
instead of explicit calls with public contracts.

This makes it much harder to refactor Domain A or Domain B's persistence
later on, which in turn **reduces the scalability** of your app.