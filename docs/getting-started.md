# Getting Started

## Installation

Mithril works best with a pre-release version of Elixir: `1.6.0-dev`.

You can install it using [kiex](https://github.com/taylor/kiex) like so:

```sh
$ kiex install master # Install Elixir 1.6.0 from Elixir's master branch
$ kiex default master # use Elixir 1.6 by default on command line
$ kiex use master     # use Elixir 1.6 in this terminal session
$ mix local.hex --force # Install hex, the package manager
```

You can then install Mithril:

```sh
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ git clone git@github.com:infinitered/mithril.git
$ mix template.install mithril
```

## Updating Mithril

Because Mithril is still in alpha, you should always update it before
starting a new project to ensure you get the latest version.

To update Mithril, simply pull down from the repo and reinstall the 
template. 

```sh
$ cd where-you-put-mithril/
$ git checkout master
$ git pull
$ mix template.uninstall mithril
$ mix template.install .
```

## Generating Your Project

```sh
$ mix gen mithril <project-name> [options]
```

### Options

- `--accounts`: Generates a token-based authentication domain. Requires 
  the following options to be included to work properly: `--ecto`, 
  `--email`. See their documentation below.

- `--api [type]`: Generates an API app. Supported types:
  - `graphql`: A GraphQL API using [Absinthe](https://absinthe-graphql.org)

- `--assets`: Generates the Phoenix app with an asset pipeline for javascript and css.

- `--asset-bundler [bundler]` The asset bundler to use for the asset pipeline. Supported options:
  - `brunch`
  - `webpack`

- `--ci [type]`: The CI server you intend to use. Supported options:
  - `semaphore`: Generates configuration for [Semaphore](https://semaphoreci.com).

- `--ecto [adapter]`: Include Ecto for persistence. Supported adapters:
  - `postgres`

- `--email`: Generate email notification domain using [Swoosh](https://github.com/swoosh/swoosh).

- `--gettext`: Generates internationalization support using [Gettext](https://github.com/elixir-lang/gettext).

- `--html [template-lang]`: Generates HTML-related files in the Phoenix app, such as views, controllers, and templates.
  Supported template languages:
  - `eex`
  - `slim` via [Slime](http://slime-lang.com/)

- `--sass-syntax [syntax]`: The variant of [Sass](http://sass-lang.com) syntax to use if you have an asset pipeline. Supported options:
  - `sass`
  - `scss`

- `--websockets`: Generates needed files for websocket support in both the Phoenix and GraphQL API apps (if you have one).

## Running Your Project

Mithril will generate a setup script for your project, so getting your project running is easy:

```bash
$ cd project-name/
$ bin/setup
# Tons of commands later...
$ mix phx.server
```