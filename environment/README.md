# GitHub Action for Replacing Environment configs in k8s

This is an Action for Mono repos to update environment configs to the newest commit ref, utilizing the [changes action](https://github.com/Knotel/actions/) which needs to be ran first to detect which projects you're working within.

## Usage

An example workflow to update your configurations in `REPO/environment/ENV.yaml`:

```hcl
workflow "Update Env Configs" {
  on = "push"
  resolves = ["Update env.yaml"]
}

action "Update env.yaml" {
  uses = "Knotel/actions/environment@dev"
  args = "dev.yaml"
  secrets = ["GITHUB_TOKEN", "SSH_KEY"]
  needs = ["Get Changes!"]
}

action "Get Changes!" {
  uses = "knotel/actions/changes@dev"
  secrets = ["GITHUB_TOKEN"]
}

```

### Secrets

* `GITHUB_TOKEN` - **Required**. Required to run the Github Action.
* `SSH_KEY` - **Required**. Required to push the newest changes to the config back to the repo.

### Arguments

Your argument should be the name of the yaml file you want to edit in the `/environments/` folder of your repo.
