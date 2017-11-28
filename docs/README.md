# Mithril

> An Elixir architecture in a box for a backend server.

Mithril provides a foundation for a long-lived, maintainable, and
highly scalable backend server.

## Technologies Used {docsify-ignore}

| Name                                                             | Optional | Purpose                        |
| ---------------------------------------------------------------- | -------- | ------------------------------ |
| [Elixir](https://elixir-lang.org)                                | No       | Backend programming language   |
| [Phoenix](https://phoenixframework.org)                          | Yes      | HTTP/Websocket support         |
| [Absinthe](https://absinthe-graphql.org)                         | Yes      | GraphQL APIs (for mobile apps) |
| [Webpack](https://webpack.js.org/) / [Brunch](http://brunch.io/) | Yes      | Front-end assets (JS/CSS)      |

## Why {docsify-ignore}

While mobile apps are taking over the world, they usually require
a backend. Businesses rely on their backends, and rarely have budget
or the desire to rewrite them.

It is therefore very important that the backend be reliable and
scalable without rewrites. Mithril uses [Elixir](https://elixir-lang.org)
for reliability and scalability, and a set of conventions to ensure
that the backend server is maintainable over the long term.

None of these conventions are "new" to the Elixir community. Mithril
simply explains existing tools and demonstrates best practices for
building scalable Elixir applications. Mithril is _not code_, it's a
name for a set of conventions.

Read more about:

- [Mithril's project generator](/getting-started)
- [Mithril's conventions](/conventions)

## How Mithril Scales

Mithril's core idea is to **decouple logic from protocol concerns**. This idea
was originally spearheaded by the Phoenix core team in Phoenix 1.3, and
Mithril aims to explain and demonstrate how to actually do it. 

In Mithril, your logic application is a separate OTP application from your
protocol applications. It contains everything that makes your app unique,
such as:

1. Permissions
2. Logic
3. Data Types
4. Persistence

The client applications, like Phoenix, only contain code that is peculiar
to the protocol they implement, like HTTP or Websockets. They rely completely
on the logic app for decision making.

This decoupling allows Mithril servers to have both:

- A flexible client architecture
- A flexible backend architecture

### Flexible Client Architecture

Because the logic is decoupled from the protocol and client interface, you
can easily layer any protocol or interface on top of the same logic core. This
greatly increases the scalability and lifetime of the server.

Any of the following architectures (and more) can easily be built on top of
a Mithril logic app.

#### 1. Server-Rendered HTML

The Phoenix app renders the HTML interface by calling into the logic app.

![Example 1.0](_images/example_1.0.svg)

#### 2. Server-Rendered HTML + Mobile

An application with a server-rendered HTML interface _and_ a mobile application. 
To support the mobile application, we simply add an API app to handle GraphQL, 
and plug it into our existing Phoenix app.

The new GraphQL app calls into the same logic app functions that the Phoenix app 
uses to render the HTML interface, ensuring that both protocols behave consistently.

![Example 2.0](_images/example_2.0.svg)

#### 3. SPA + Mobile

An application with a React single-page interface, and a mobile application. In 
this case, the Phoenix app only exists to mount our GraphQL API.

The SPA code could be hosted separately or served by Phoenix, depending on your
preferences.

![Example 3.0](_images/example_3.0.svg)

### Flexible Backend Architecture

The backend of a Mithril application is also flexible. Let's take the server-rendered
HTML example above and look at how it might scale over time, with small refactorings.

#### Version 1.0

In version 1.0, the app consists of two OTP apps: a logic app and a Phoenix app.

![](_images/example_1.0.svg)

#### Version 1.1

In version 1.1, we extract parts of the domains to their own library OTP apps in the
apps/ directory, either for reuse in other projects or to make the logic application
more focused.

Nothing changes from the perspective of the Phoenix app: it calls the same domains
as before and knows nothing about the refactor.

![](_images/example_1.1.svg)

#### Version 1.2

In version 1.2, we break up the logic application into multiple smaller applications.
Each major domain becomes its own OTP app, with its own dependencies.

The Phoenix app continues to call into the new apps, with only minor refactoring
needed to point it at the right app.

![](_images/example_1.2.svg)

#### Version 1.3

In version 1.3, we break up the umbrella application and host the OTP apps independently
on separate hardware. Very little needs to change, because Elixir OTP apps can call each
other over the network in much the same way that they can call each other on the same
machine.

!> You may have to switch hosting providers in order to give all your
   servers network access to each other.

![](_images/example_1.3.svg)

#### Conclusion

At each step along the way, no logic had to be rewritten. The logic remained
the same, despite major changes to the client interface and backend architecture.
This is why Mithril conventions offer so much value: a backend built with them will
be very flexible and therefore long-lived.

Business owners want long-lived backend servers. They never want to rewrite, and they're
tired of hearing that they should from each new developer they hire.
Likewise, developers are tired of working on "legacy" backends which don't scale well
and are hard to work with.

With Mithril's conventions, we can align the interests of both developers and business 
owners to provide effective software that is also good value for money.