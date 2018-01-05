# Admin Domain
This anti-pattern manifests when you choose a non-descriptive name for a
domain, like `Admin`.

The solution is to break the domain down into separate, well-named domains
for its component features. Often, the functions that were in the `Admin`
domain can go into existing domains.

### Caveat

You can still have "Admin" namespaces in your client applications that call
into your domains. This is fine because "Admin" really describes a place
or collection of screens. These are interface concerns which are properly
within the scope of a client app.

### Why

`Admin` is not a feature. "Admin" is a user role, or a set of screens
within your application that let users with that role interact with
certain features. Domains should not be named for user roles or places,
they should be named after _features_.

When you have an `Admin` domain, you mix interface concerns (how features
are grouped together and presented to the user visually) with the actual
domain logic of the application. 

`Admin` will become a "god" domain, because it has no clear scope or
limitation on what functions it should contain. Over time, it will fill up
with a mess of unrelated functions and types.

