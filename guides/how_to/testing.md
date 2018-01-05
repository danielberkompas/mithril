# Testing

You should focus your automated test suite on the following areas.

### 1. Domain Public Interfaces

You should thoroughly test the public interface of each domain in your logic app,
including edge cases.

!> However, _it is not important_ to write tests on the private modules and internal 
   workings of each domain. In fact, this can be counter-productive, because it makes
   it harder to refactor the internals of a domain.

### 2. Client Application Public Interfaces

It isn't enough to test your domains. You also need to test that your client
applications are providing usable public interfaces. Just because your domains work
doesn't mean your client interfaces call the domains correctly.

!> You don't have to test each client interface for all edge cases, because edge 
   cases are mainly tested on the domains. As long as your domains are well-tested, 
   "smoke screen" tests are enough for your client interfaces.

In your `Phoenix` client app, your public interfaces are Phoenix controllers,
HTML templates, and websocket channels. To test these, you'll need:

- Controller tests
- Channel tests
- In-browser tests (via Hound and Chromedriver) for critical flows

In your `GraphQL` client app, your public interfaces are mutations, queries,
and subscriptions. Accordingly, you'll need:

- Query tests
- Mutation tests
- Subscription tests

### Regressions

When a bug occurs in production, and you fix it, you should write a test to prevent
that bug from occuring again. Where you put the regression test depends on the source of 
the bug.

For **domain logic bugs**, write the test in the domain's public interface test file.

For **client interface bugs**, such as when the client calls a domain with incorrect
arguments, write the test in the client interface's test file.