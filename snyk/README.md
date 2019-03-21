# snyk-action
Knotel's github action to run Snyk tests and output to the PR in a mono-repo.

## How to Use

1. Add Action
2. Enter `knotel/actions/snyk@master`
3. Add Secret named `SNYK_TOKEN`
4. Go to your [Snyk Account Settings](https://app.snyk.io/account) and get your API token value
5. Enter the value of the token you copied from Snyk as the secret in the GitHub Action
