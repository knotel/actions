# An action to detect file changes and send a slack notification

To use:

1) Be sure you've chained this action after `knotel/actions/changes@dev`
2) Have a slack token checked into the action as a secret
3) Give two args when calling this action, the filepath, and the slack channel.
