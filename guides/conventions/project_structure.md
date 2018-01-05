# Project Structure

Mithril applications are Elixir [Umbrella](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html#umbrella-projects)
apps. The code is organized into several [OTP apps](https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html#understanding-applications)
in the `apps/` directory.


```bash
my_app/
├── README.md
├── apps
│   ├── my_app     # Business logic ("Domains"), persistence
│   └── my_app_api # GraphQL API
│   └── my_app_web # Phoenix Endpoint
├── bin
│   ├── reset      # Resets and rebuilds the project
│   ├── setup      # Sets up all dependencies
│   ├── test       # Runs tests like they would run on CI
│   └── update     # Updates the project (for mobile devs)
├── config
├── mix.exs
└── mix.lock
```

Each app has specific, isolated responsibilities.

- `my_app` A pure Elixir app which handles **logic** and **persistence**, with 
  few dependencies.
- `my_app_api` [Client] The API for the project. (Usually GraphQL) Calls into 
  `my_app`'s logic.
- `my_app_web` [Client] Tiny Phoenix app which mounts the API and calls into 
  `my_app`'s logic.
