# Mithril

[![Build Status](https://semaphoreci.com/api/v1/projects/39401688-bc0e-4d65-85b0-075dd293d2c7/1625736/badge.svg)](https://semaphoreci.com/ir/mithril)

> An Elixir architecture-in-a-box for a backend server. Supports GraphQL, Authority authentication, and more.

Mithril provides a foundation for a long-lived, maintainable, and highly
scalable backend server. It uses Elixir for reliability and scalability, and
a set of conventions to ensure that the backend server is maintainable over
the long term.

Mithril is not a framework. It has two parts:

1. **Project Generator**: A project generator which sets up your project
   with good defaults and architecture.

2. **Conventions**: A set of conventions described in the Mithril
   documentation. None of these conventions are new to the Elixir community.
   Mithril simply explains existing tools and demonstrates best practices.

See [the documentation](https://hexdocs.pm/mithril) for details.

## Libraries Supported

Other than Elixir, Mithril does not dictate your technology choices.
However, the project generator can generate projects with support for
any of the libraries listed below.

| Name                                                             | Optional | Purpose                        |
| ---------------------------------------------------------------- | -------- | ------------------------------ |
| [Authority](https://github.com/infinitered/authority)            | Yes      | Authentication library         |
| [Absinthe](https://absinthe-graphql.org)                         | Yes      | GraphQL APIs (for mobile apps) |
| [Phoenix](https://phoenixframework.org)                          | Yes      | HTTP/Websocket support         |
| [Webpack](https://webpack.js.org/) / [Brunch](http://brunch.io/) | Yes      | Front-end assets (JS/CSS)      |
| [Hound](https://hex.pm/packages/hound)                           | Yes      | In-browser integration tests   |

## Install

Mithril works best with Elixir 1.6. You can install Mithril like so:

```sh
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ mix template.install hex mithril
```

You can then generate your project:

```sh
$ mix gen mithril my_app [options]
```

See [the documentation](https://hexdocs.pm/mithril) for details on available options.
