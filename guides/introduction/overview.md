# Mithril

> An Elixir architecture in a box for a backend server.

Mithril provides a foundation for a long-lived, maintainable, and
highly scalable backend server.

## Technologies Used

| Name                                                             | Optional | Purpose                        |
| ---------------------------------------------------------------- | -------- | ------------------------------ |
| [Elixir](https://elixir-lang.org)                                | No       | Backend programming language   |
| [Authority](https://github.com/infinitered/authority)            | Yes      | Authentication library         |
| [Absinthe](https://absinthe-graphql.org)                         | Yes      | GraphQL APIs (for mobile apps) |
| [Phoenix](https://phoenixframework.org)                          | Yes      | HTTP/Websocket support         |
| [Webpack](https://webpack.js.org/) / [Brunch](http://brunch.io/) | Yes      | Front-end assets (JS/CSS)      |

## Why

While mobile apps are taking over the world, they usually require
a backend. Businesses rely on their backends, and rarely have budget
or the desire to rewrite them.

It is therefore very important that the backend be reliable and
scalable without rewrites. Mithril uses [Elixir](https://elixir-lang.org)
for reliability and scalability, and a set of conventions to ensure
that the backend server is maintainable over the long term.

None of these conventions are "new" to the Elixir community. Mithril
simply explains existing tools and demonstrates best practices for
building scalable Elixir applications. _Mithril is not a framework_, it's 
a name for a set of conventions.