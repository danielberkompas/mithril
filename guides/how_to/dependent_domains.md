# Dependent Domains

Domains will inevitably depend on each other. By depending on other domains,
each domain is able to focus on only the things it cares about, and reduce code
duplication.

However, there are some basic rules of thumb to keep in mind when making domains
depend on one another.

### 1. Keep the Dependency One-Way

If Domain A relies on Domain B, Domain B must not also rely on Domain A.

![One-way dependencies are good](assets/one_way_dependency.svg)

![Two-way dependencies are bad](assets/two_way_dependency.svg)

If two domains _must_ rely on each other, this is a hint that they should be 
merged into a single domain. They obviously are tightly coupled together, and 
therefore should be one entity.

#### Examples

- **GOOD**: `Accounts` calls the `Notifications` domain to send notifications to an 
  email address, passing the email address as an argument.

- **BAD**: `Accounts` calls the `Notifications` domain to send notifications to a
  `user_id`. `Notifications` queries `Accounts` for the email address to use.

### 2. Reduce Coupling When Possible

Decoupled domains are easier to reuse in other projects or extract to libraries. 
It's always a balancing act because decoupling domains always comes with a little
more overhead and formality.

There are several ways to reduce coupling between domains. 

#### [Protocols](https://hexdocs.pm/elixir/Kernel.html#defprotocol/2)

Instead of relying on a data type from another domain directly, your domain can expose a
data protocol which is then _implemented_ for the foreign data type. Your domain's true 
dependency is then _on the protocol_, not on the data format returned by another domain.

See ["Identifying Users"](authorization.html#identifying-users-in-other-domains) for an example.

#### [Behaviours](https://hexdocs.pm/elixir/behaviours.html)

A domain that relies on other domains to perform actions can define a `Behaviour` instead
of calling those domains directly. See [the Callback Pattern](if_this_then_that.html#callback-pattern) 
for an example.

The domain is really then relying _on the behaviour_, not other domains. The behaviour just
happens to be implemented in such a way as to call other domains.
