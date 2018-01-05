# Designing Domains

Designing your application around [domains](domains.html) can 
be difficult at first. This guide will help you get started.

### 1. Break down the spec into _actions_

Take your **functional spec** or **visual design** and do a brainstorming
session. For each screen or page, identify each action the screen allows or
requires, for example:

- "List products"
- "View product"
- "Update company profile"
- "Count page views"
- "Export CSV of tracking data"
- "Render chart of page views over time"

Think in terms of _verbs_, not nouns. Focus on what the app _does_, not what
it is made of.

### 2. Group the actions into _domains_

Once you have your complete list of actions in a file or up on a board, start
grouping related actions together. These "buckets" of related actions become
your domains.

**Be careful with your names**. Avoid generic, meaningless names like "Admin"
for your domains. Instead, use a name that summarizes the feature, for example:

- **Inventory**
  - "List products"
  - "View product"
- **Profiles**
  - "Update company profile"
- **Reports**
  - "Count page views"
  - "Export CSV of tracking data"
  - "Render chart of page views over time"


### 3. Convert the actions into _functions_

Next, think about each action and convert it into a function. Describe what
arguments it takes and what it returns. This will also force you to think 
about the _types_ (nouns) that your application needs.

Fill in any functions, types, or domains that you know you'll need to make
the domains you outlined work. In this case, we discovered that we needed a
"Companies" domain:

- **Companies**
  - Types
    - `Company`: name
  - Actions
    - `create_company(params)`: creates a company
- **Inventory**
  - Types
    - `Product`: name, sku, quantity in stock, company
  - Functions
    - `list_products(company_id)`: Returns a list of products for the given 
      `company_id`.
    - `get_product(product_id)`: Returns a product by its ID.
- **Profiles**
  - Types
    - `Profile`: company_id, address, bio
  - Functions
    - `create_profile(company_id, params)`: Creates a profile for a given 
      company.
    - `get_profile(company_id)`: Gets a profile for a given company.
    - `update_profile(profile, params)`: Updates a profile.
- **Reports**
  - Types:
    - `PageView`: metadata
  - Functions
    - `page_view_count(company_id)`: returns page view count for a given
      company.
    - `export(:page_views, company_id, :csv)`: Exports CSV of page views
      for a given company
    - `page_view_series(company_id, start, end)`: Returns a series of
      page view data that can be plotted to a chart.

### 4. Add OTP where beneficial

Thanks to Erlang, Elixir has access to an amazing set of OTP conventions
and libraries built into the language. At this point, now that you know
the public API of your domains, examine each domain to decide where you
need OTP features.

!> OTP will limit your deployment options, because your app will be
   stateful. You'll need more fine-grained control over your deployed
   instances, and they will need network access to each other.

#### Types
Don't assume that your domain types must be structs or be backed by a 
database table.

Most domain types can be represented as [GenServers][genserver], and 
collections can be represented as [Supervision][supervisor] trees. This
can be helpful in some cases, though definitely not all.

?> See the excellent talk ["Selling Food with Elixir"](https://www.youtube.com/watch?v=fkDhU-2NWJ8)
   from ElixirConf 2016 for an example of how this works in the real 
   world, and why you would do it.

?> See the [LearnElixir.tv](https://www.learnelixir.tv) episode
   ["Applications"](https://www.learnelixir.tv/episodes/16-applications) for
   an example of how to build a todo list with [GenServer][genserver].

?> See the [Elixir OTP Guide](https://elixir-lang.org/getting-started/mix-otp/agent.html)
   starting at "Agent" for a walkthrough on how to use OTP.

[supervisor]: https://hexdocs.pm/elixir/Supervisor.html

#### Realtime or Concurrent
Anything that needs to be done in realtime, where multiple subscribers
or people are looking at it simultaneously, could probably benefit from
[GenServer][genserver] and supervision trees.

[genserver]: https://hexdocs.pm/elixir/GenServer.html

#### Background Tasks
Any cron-like operation that needs to happen on a regular basis can easily
be done with a [GenServer][genserver].

#### Unreliable 3rd Parties

Whenever you must rely on third parties who are unreliable, your app can benefit
from wrapping those third parties with a [supervision tree][supervisor].

#### State Machines

Use [GenServer][genserver]
or [gen_statem](http://www.erlang.org/doc/man/gen_statem.html).

?> **Example A**:
   Tracking students to and from school, in realtime.
  
?> **Example B**:
   Multiplayer board game, where each player has a turn.
  
?> **Example C**:
   Bank accounts; depositing/withdrawing money. 

### 5. Add persistence

In contrast with "The Rails Way", it's only here at the end that you should
think about persistence. Only now, when you have the domains, functions, and
OTP supervision tree laid out do you really know what kind of persistence
your app needs.

### Conclusion

You now have a set of well-scoped domains, with all their types, public
functions, and persistence defined. From here, you can move on to:

- Implement the domains
- Layer on a GraphQL API
- Layer on an HTML interface with Phoenix

