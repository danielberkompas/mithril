# Why These Conventions?

Mithril's core idea is to **decouple logic from protocol concerns**, such as
HTTP or websockets. Instead of mixing our business logic with our frameworks,
we put them in plain Elixir modules in a separate OTP application.

This idea was spearheaded by the `Phoenix` core team in Phoenix 1.3 with
"Contexts". (Mithril calls them [Domains](/domains.html)) Mithril expands on
this idea and aims to explain how to do it in practice.

Mithril gains two benefits from this approach:

- A flexible client architecture
- A flexible backend architecture

## Flexible Client Architecture

When your logic is separate from your frameworks, you can easily layer any
protocol or interface on top of the same logic core. This greatly increases
the scalability and lifetime of the server.

Any of the following architectures (and more) can easily be built using
Mithril conventions.

#### 1. Server-Rendered HTML

The Phoenix app renders the HTML interface by calling functions from the logic
app. The logic app handles the business logic, and Phoenix concerns itself
only with client concerns like HTML rendering.

![Example 1.0](assets/example_1.0.svg)

#### 2. Server-Rendered HTML + Mobile

When your application also needs to support a mobile app, the separation between
Phoenix and the logic app really shines. 

To support the mobile app, we simply add an API app to handle GraphQL. The
new GraphQL app calls into the same logic app functions that the Phoenix app
uses to render the HTML interface, ensuring that both protocols behave
consistently.

We then can mount the GraphQL app's router inside our Phoenix app to serve
the API.

![Example 2.0](assets/example_2.0.svg)

#### 3. SPA + Mobile

A single-page app will have less need for Phoenix. In this architecture, you have
a bare-bones Phoenix app which simply mounts the GraphQL API app's router.

The Phoenix app could also serve the front-end SPA code, or it could be hosted
separately.

![Example 3.0](assets/example_3.0.svg)

## Flexible Backend Architecture

The backend of a Mithril application is also flexible. Let's take the server-rendered
HTML example above and look at how it might scale over time, with small refactorings.

#### Version 1.0

In version 1.0, the app consists of two OTP apps: a logic app and a Phoenix app.

![](assets/example_1.0.svg)

#### Version 1.1

In version 1.1, we extract parts of the domains to their own library OTP apps in the
apps/ directory, either for reuse in other projects or to make the logic application
more focused.

Nothing changes from the perspective of the Phoenix app: it calls the same domains
as before and knows nothing about the refactor.

![](assets/example_1.1.svg)

#### Version 1.2

In version 1.2, we break up the logic application into multiple smaller applications.
Each major domain becomes its own OTP app, with its own dependencies.

The Phoenix app continues to call into the new apps, with only minor refactoring
needed to point it at the right app.

![](assets/example_1.2.svg)

#### Version 1.3

In version 1.3, we break up the umbrella application and host the OTP apps independently
on separate hardware. Very little needs to change, because Elixir OTP apps can call each
other over the network in much the same way that they can call each other on the same
machine.

!> You may have to switch hosting providers in order to give all your
   servers network access to each other.

![](assets/example_1.3.svg)

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