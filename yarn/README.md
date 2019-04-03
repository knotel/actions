# GitHub Action for Yarn

This is an Action for [yarn](https://yarnpkg.com/en/) that enables arbitrary actions with the `yarn` command-line client, including testing packages and publishing to a registry, based on a mono-repo, with the [changes action](https://github.com/Knotel/actions/) being ran first to detect which projects you're working within.

## Usage

An example workflow to build, test, and publish an npm package to the default public registry follows:

```hcl
workflow "Build, Test, and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Build" {
  uses = "Knotel/actions/yarn@master"
  args = "install"
}

action "Test" {
  needs = "Build"
  uses = "Knotel/actions/yarn@master"
  args = "test"
}

# Filter for a new tag
action "Tag" {
  needs = "Test"
  uses = "Knotel/actions/yarn@master"
  args = "tag"
}

action "Publish" {
  needs = "Tag"
  uses = "Knotel/actions/yarn@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
```
