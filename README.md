# Mithril Blueprint

An architecture in a box for a backend server with an API. (Usually consumed by a mobile application.)

## Installation

```bash
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ mix template.install github infinitered/mithril
```

## Options

### Base

The base configuration is _extremely_ minimalistic.

```sh
$ mix gen mithril my_app
```

### Kitchen Sink

This will generate an app with a kitchen sink of features, including account support and a GraphQL API:

```sh
$ mix gen mithril my_app --ecto postgres --email --accounts --assets --asset-bundler webpack --api graphql --html slim
```