[
  inputs: [
    "apps/*/{lib,config,test}/**/*.{ex,exs}",
    "apps/*/mix.exs"
  ],
  locals_without_parens: [
    <%= if assigns[:api] == "graphql" do %>
    # GraphQL
    description: 1,
    import_fields: 1,
    import_types: 1,
    field: 2,
    arg: 2,
    resolve: 1,
    <% end %>
    <%= if assigns[:ecto] do %>

    # Ecto
    add: 2,
    create: 1,
    create: 2,
    belongs_to: 2,
    <% end %>

    # Phoenix
    action_fallback: 1,
    plug: 2,
    plug: 1,
    pipe_through: 1,
    get: 3,
    post: 3,
    patch: 3,
    put: 3,
    forward: 3,
    resources: 2,
    resources: 3,
    <%= if assigns[:accounts] do %>

    # Internal custom functions
    assert_login_required: 1
    <% end %>
  ]
]