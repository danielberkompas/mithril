# Internationalization

Elixir has excellent internationalization support via the [Gettext][gettext]
library. To use it with your Mithril project, call the Mithril generator with
the `--gettext` option.

```bash
$ mix gen mithril intl --gettext
```

Read the [Gettext docs][gettext] for details on how it works.

## Where to Translate

Translations are _interface_ concerns, and therefore belong in client applications
like your Phoenix app or GraphQL app. Your logic application should return atoms
like `:not_found` or `:unauthorized`, and leave translation up to the client.

```elixir
{:error, :not_found}
{:error, :unauthorized}
```

## How to Translate

It's important to bear in mind how the _translator_ will interact with your
Gettext files. When you add a string to the application, you're going to send
over a blank or partially filled out Gettext file to a translator.

The translator will use his own Gettext software to open up the file and will
see an interface much like this:

![Gettext Translator Interface](assets/gettext_translator.png)

The translator needs to see the English string as the key for the translation
so that they know how to translate it. This means that you should use full,
English strings everywhere, not shorthand, because the string you pass in
becomes the key for the translation.

```elixir
# Good
put_flash(conn, :error, gettext("Record not found!"))

# Bad
put_flash(conn, :error, gettext("not_found"))
```

If you find yourself reusing the same or similar strings, then extract those
parts to a shared module or [fallback controller](https://hexdocs.pm/phoenix/1.3.0/Phoenix.Controller.html#action_fallback/1).

```elixir
defmodule MyAppWeb.ErrorMessages do
  import MyAppWeb.Gettext

  def not_found do
    gettext("Record not found!")
  end
end

# Usage
import MyAppWeb.ErrorMessages

put_flash(conn, :error, not_found())
```

## Software to Recommend

Most translators will be familiar with the `.po` file format that Gettext uses,
and already have their favorite software. However, if this is not the case, you
can recommend the following software options:

- [POEdit](https://poedit.net/) (MacOS app)
- [POEditor](https://poeditor.com) (Online SaaS)

[gettext]: https://hexdocs.pm/gettext/

