# Installation

Mithril works best with Elixir 1.6. You can install Mithril like so:

```sh
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ mix template.install hex mithril
```

## Updating Mithril

Because Mithril is still in alpha, you should always update it before
starting a new project to ensure you get the latest version.

```sh
$ mix template.uninstall mithril
$ mix template.install hex mithril
```
