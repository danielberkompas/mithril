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

To update Mithril, simply pull down from the repo and reinstall the 
template. 

```sh
$ cd where-you-put-mithril/
$ git checkout master
$ git pull
$ mix template.uninstall mithril
$ mix template.install .
```
