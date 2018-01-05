# Cross-Domain Ecto Relationships
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