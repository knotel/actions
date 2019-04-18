# An action to detect file changes and send a slack notification

To use:

1) Be sure you've chained this action after `knotel/actions/changes@dev`
2) Have a slack token checked into the action as a secret `SLACK_CLI_TOKEN`
3) Give two args when calling this action, the filepath, and the slack channel.

Example: `/db/schema.rb #alerts`

4) Make sure that the slack user is invited to the channel you're trying post to

Next, add the actions to your workflow!

Example:
```
workflow "Notify us of changes" {
  resolves = [
    "Changes",
    "Changes-notify",
  ]
  on = "push"
}

action "Changes" {
  uses = "knotel/actions/changes@dev"
  secrets = ["GITHUB_TOKEN"]
}

action "Changes-notify" {
  uses = "knotel/actions/changes-notify@dev"
  args = "db/schema.rb #schema-alerts"
  secrets = ["GITHUB_TOKEN", "SLACK_CLI_TOKEN"]
  needs = ["Changes"]
}
```
