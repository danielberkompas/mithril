# <%= @project_name_camel_case %>

The Elixir backend for <%= @project_name_camel_case %>.

## About <%= @project_name_camel_case %>

TODO: Briefly describe what <%= @project_name_camel_case %> does

## Scripts

<dl>
  <dt>bin/setup</dt>
  <dd>
    Bash script that sets up the project, its dependencies, seeds, and runs 
    <code>bin/test</code> to verify everything is working. You should run this 
    script on the CI server.
  </dd>
  <dt>bin/test</dt>
  <dd>
    Bash script which runs all the tests for the project. For example: credo,
    dialyzer, <code>compile --warnings-as-errors</code>, run tests.
  </dd>
  <dt>bin/update</dt>
  <dd>
    Bash script which <code>git pull</code>s, updates dependencies, runs 
    migrations, etc. It makes it easy to pull down and update everything.
  </dd>
  <dt>bin/reset</dt>
  <dd>
    Bash script which resets everything and reruns <code>bin/setup</code> 
    again.
  </dd>
  <dt>mix docs</dt>
  <dd>
    Generates ExDoc documentation for the project.
  </dd>
</dl>

## Architecture

<%= @project_name_camel_case %> uses the
[Mithril](https://github.com/infinitered/mithril) code organization
conventions.

- `apps/<%= @project_name %>` contains the business logic for the application.
  See its README and docs for details on its public API.
<%= if assigns[:api] == "graphql" do %>- `apps/<%= @project_name %>_api` provides a GraphQL API.<% end %>
- `apps/<%= @project_name %>_web` contains a simple Phoenix application, which
  wraps the business logic from `apps/<%= @project_name %>`.

TODO: describe other apps

<%= if assigns[:deploy] == "heroku" do %>
## Deployment

<%= @project_name_camel_case %> is intended to be deployed to Heroku. 

```bash
$ heroku apps:create <%= @project_name %> --remote production
```

You will need to add the following buildpacks to your Heroku app:

```bash
$ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir
$ heroku buildpacks:add https://github.com/gjaldon/phoenix-static-buildpack
```

Read the docs on each buildpack here:

- [Elixir Buildpack](https://github.com/HashNuke/heroku-buildpack-elixir)
- [Phoenix Static Buildpack](https://github.com/gjaldon/phoenix-static-buildpack)

<%= if assigns[:ecto] == "postgres" do %>
Create a database for your app:

``bash
$ heroku addons:create heroku-postgresql:hobby-dev
```
<% end %>

Add a `SECRET_KEY_BASE` environment variable:

```bash
$ heroku config:set SECRET_KEY_BASE=`mix phx.gen.secret`
```

Once your Heroku app is configured, simply deploy:

```bash
$ git push heroku master
$ heroku run mix ecto.migrate
```
<% end %>