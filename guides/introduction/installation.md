# Installation

Mithril works best with a pre-release version of Elixir: `1.6.0-dev`.

You can install it using [kiex](https://github.com/taylor/kiex) like so:

```sh
$ kiex install master # Install Elixir 1.6.0 from Elixir's master branch
$ kiex default master # use Elixir 1.6 by default on command line
$ kiex use master     # use Elixir 1.6 in this terminal session
$ mix local.hex --force # Install hex, the package manager
```

You can then install Mithril:

```sh
$ mix archive.install hex mix_generator
$ mix archive.install hex mix_templates
$ git clone git@github.com:infinitered/mithril.git
$ mix template.install mithril
```

## Updating Mithril

Because Mithril is still in alpha, you should always update it before
starting a new project to ensure you get the latest version.

To update Mithril, simply pull down from the repo and reinstall the 
template. 

```sh
$ cd where-you-put-mithril/
$ git checkout master
$ git pull
$ mix template.uninstall mithril
$ mix template.install .
```
