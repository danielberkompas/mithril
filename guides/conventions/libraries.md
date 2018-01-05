# Libraries

The `apps/` directory is a perfect incubator for new Elixir libraries. If a piece
of logic or client application code could be reused in other projects, it can make
sense to extract that code to a library in `apps/`.

```bash
$ cd apps/
$ mix new my_library
```

You can then copy code over to `apps/my_library` and update the dependencies of the
apps that rely on it:

```elixir
def deps do
  [
    {:my_library, in_umbrella: true}
  ]
end
```

When the library is mature, it should be extracted to its own repository and published
to Hex. Then, all you'll need to do is update your deps again:

```elixir
def deps do
  [
    {:my_library, ">= 0.0.0"}
  ]
end
```

