# Mithril Blueprint

An architecture in a box for a backend server. See the presentation in `presentation/` for more details.

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

## Usage

### Base

The base configuration is _extremely_ minimalistic.

```sh
$ mix gen mithril my_app
$ cd my_app/
$ bin/setup
```

### Kitchen Sink

This will generate an app with a kitchen sink of features, including account support and a GraphQL API:

```sh
$ mix gen mithril my_app --ecto postgres --email --accounts --assets --asset-bundler webpack --api graphql --html slim
$ cd my_app/
$ bin/setup
```