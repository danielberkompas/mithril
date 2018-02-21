# Generating Your Project

It's easy to generate a project with Mithril's code generator.

```sh
$ mix gen mithril <project-name> [options]
```

By default, Mithril will generate an extremely plain, bare-bones umbrella
application. Use the options below to add functionality.

### Options

* `--accounts`: Generates a token-based authentication domain. Requires
  the following options to be included to work properly: `--ecto`,
  `--email`. See their documentation below.

* `--api [type]`: Generates an API app. Supported types:

  * `graphql`: A GraphQL API using [Absinthe](https://absinthe-graphql.org)

* `--assets`: Generates the Phoenix app with an asset pipeline for javascript and css.

* `--asset-bundler [bundler]` The asset bundler to use for the asset pipeline. Supported options:

  * `brunch`
  * `webpack`

* `--ci [type]`: The CI server you intend to use. Supported options:

  * `semaphore`: Generates configuration for [Semaphore](https://semaphoreci.com).
  * `travis`: Generates configuration for [Travis](https://travis-ci.org/).

* `--deploy [host]`: The host you intend to serve your Mithril application from.

  * `heroku`: Generates configuration for [Heroku](https://heroku.com)

* `--ecto [adapter]`: Include Ecto for persistence. Supported adapters:

  * `postgres`

* `--email`: Generate email notification domain using [Swoosh](https://github.com/swoosh/swoosh).

* `--gettext`: Generates internationalization support using [Gettext](https://github.com/elixir-lang/gettext).

* `--html [template-lang]`: Generates HTML-related files in the Phoenix app, such as views, controllers, and templates.
  Supported template languages:

  * `eex`
  * `slim` via [Slime](http://slime-lang.com/)

* `--integration [library]`: Generates in-browser integration test supporting files and a sample test.

  * [`hound`](https://hex.pm/packages/hound)

* `--sass-syntax [syntax]`: The variant of [Sass](http://sass-lang.com) syntax to use if you have an asset pipeline. Supported options:

  * `sass`
  * `scss`

* `--websockets`: Generates needed files for websocket support in both the Phoenix and GraphQL API apps (if you have one).
