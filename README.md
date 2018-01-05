# Mithril

> An Elixir architecture-in-a-box for a backend server.

Mithril provides a foundation for a long-lived, maintainable, and highly
scalable backend server. It uses Elixir for reliability and scalability, and
a set of conventions to ensure that the backend server is maintainable over
the long term.

None of these conventions are "new" to the Elixir community. Mithril simply
explains existing tools and demonstrates best practices for building scalable
Elixir applications. _Mithril is not a framework_, it's a project generator
and a name for a set of architecture conventions.

## Technologies Used

| Name                                                             | Optional | Purpose                        |
| ---------------------------------------------------------------- | -------- | ------------------------------ |
| [Elixir](https://elixir-lang.org)                                | No       | Backend programming language   |
| [Phoenix](https://phoenixframework.org)                          | Yes      | HTTP/Websocket support         |
| [Absinthe](https://absinthe-graphql.org)                         | Yes      | GraphQL APIs (for mobile apps) |
| [Webpack](https://webpack.js.org/) / [Brunch](http://brunch.io/) | Yes      | Front-end assets (JS/CSS)      |

## Install

Mithril works best with a pre-release version of Elixir: `1.6.0-rc.0`.

You can install it using [kiex](https://github.com/taylor/kiex) like so:

```sh
$ kiex install 1.6.0-rc.0 # Install Elixir 1.6.0 from Elixir's master branch
$ kiex default 1.6.0-rc.0 # use Elixir 1.6 by default on command line
$ kiex use 1.6.0-rc.0     # use Elixir 1.6 in this terminal session
$ mix local.hex --force   # Install hex, the package manager
```

You can then install Mithril:

```sh
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ git clone git@github.com:infinitered/mithril.git
$ mix template.install mithril
```

## Premium Support

[Infinite Red](https://infinite.red) offers premium support for this library and general web &
mobile app design/development services. Get in touch [here](https://infinite.red/contact) or email us at [hello@infinite.red](mailto:hello@infinite.red).

![Infinite Red Logo](https://infinite.red/images/infinite_red_logo_colored.png)