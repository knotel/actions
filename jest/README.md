# Github Action for Jest (with Annotations)

This Action runs your [Jest](https://github.com/facebook/jest) test suite and adds annotations to the Github check the action is run in.

![Annotation Example](screenshot.png)

## Usage

```hcl
workflow "Tests" {
  on = "push"
  resolves = ["Jest"]
}

action "Dependencies" {
  uses = "Knotel/actions/yarn@master"
  args = "install"
}

action "Jest" {
  uses = "knotel/actions/jest@master"
  secrets = ["GITHUB_TOKEN"]
  args = ""
  needs = ["Dependencies"]
}
```

### Secrets

* `GITHUB_TOKEN` - **Required**. Required to add annotations to the check that is executing the Github action.

### Environment variables

* `JEST_CMD` - **Optional**. The path the Jest command - defaults to `./node_modules/.bin/jest`.
(not needed for the mono-repo style run)

#### Example

To run Jest, use the Github repo:

```hcl
action "Jest" {
  uses = "knotel/actions/jest@master"
  secrets = ["GITHUB_TOKEN"]
  args = ""
}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

Container images built with this project include third party materials. View license information for [Node.js](https://github.com/nodejs/node/blob/master/LICENSE), [Node.js Docker project](https://github.com/nodejs/docker-node/blob/master/LICENSE), [Jest](https://github.com/facebook/jest/blob/master/LICENSE), [Go](https://golang.org/LICENSE), [google/go-github](https://github.com/google/go-github/blob/master/LICENSE) or [ldez/ghactions](https://github.com/ldez/ghactions/blob/master/LICENSE). As with all Docker images, these likely also contain other software which may be under other licenses. It is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
