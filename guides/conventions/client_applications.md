# Client Applications

`my_app_api` and `my_app_web` are considered _client applications_ of `my_app`.
They exist solely to give `my_app` the ability to speak HTTP or GraphQL or
whatever other protocol `my_app` needs to speak to the outside world.

Think of these apps as _translators_. In human language, the concepts, 
ideas and actions that we communicate are the same; the language we speak is just
a protocol for communicating those things.

Likewise, `my_app` contains the concepts and actions, and these client 
applications act as translators for those concepts and actions for a protocol
like HTTP or GraphQL.

There are two rules of thumb with regard to client applications:

1. **Translator Only**. They must only _wrap_ `my_app`. All business logic concerns
   must be handled by `my_app`, with the client app only providing translation.

2. **Client Only**. `my_app` must be unaware of the client app's existence, and not
   rely on a client app to do anything but translate.
