# <%= @project_name_camel_case %>API

A GraphQL API for <%= @project_name_camel_case %>, based on [Absinthe](http://absinthe-graphql.org).

`<%= @project_name_camel_case %>Web.Router` mounts the API schema for HTTP clients.

## Rules

- <%= @project_name_camel_case %>API is a _client_ of <%= @project_name_camel_case %>. Only call <%= @project_name_camel_case %>'s public interface.
- Do not use `absinthe_ecto`. Instead, load associations using `<%= @project_name_camel_case %>API.Schema.Assoc.assoc/2`.
