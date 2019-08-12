#!/bin/bash -l

set -e

if [ -n "$NPM_TOKEN" ]; then
  # Respect NPM_CONFIG_USERCONFIG if it is provided, default to $GITHUB_WORKSPACE/.npmrc
  NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG-"$GITHUB_WORKSPACE/.npmrc"}"
  NPM_REGISTRY_URL="${NPM_REGISTRY_URL-registry.npmjs.org}"

  # Allow registry.npmjs.org to be overridden with an environment variable
  printf "//%s/:_authToken=%s" "$NPM_REGISTRY_URL" "$NPM_TOKEN" > "$NPM_CONFIG_USERCONFIG"
  chmod 0600 "$NPM_CONFIG_USERCONFIG"
fi

# pwd here is /github/workspace
# We're expecting the json files generated by the Changes Action to be in the ${GITHUB_WORKSPACE} directory
if [ ! -f ${GITHUB_WORKSPACE}/services.json ]; then
  echo "Services File does not exist. Exiting."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  exit 1
else
  cd /github/workspace
  #yarn
  CHANGES=($(cat ${GITHUB_WORKSPACE}/services.json | jq -r '@sh'))
  for service in ${CHANGES[@]}; do
    #if the service starts with a dot, don't run snyk tests
    if [[ ${service:1:1} == "." ]]; then
      echo "Skipping running in $service. (Hidden Folder)"
      echo
    else
      cd /github/workspace
      if [[ -d ${service:1:${#service}-2} ]]; then
        echo "${service:1:${#service}-2} is a directory"
        echo "Moving to ${service:1:${#service}-2}"
        cd ${service:1:${#service}-2}
        echo "Current yarn cache dir is:"
        yarn cache dir
        yarn config set cache-folder .yarn
        echo "New yarn cache dir is:"
        yarn cache dir
        echo "Running yarn $* inside of $(pwd)"
        yarn install --frozen-lockfile --force --no-lockfile
      elif [[ -f ${service:1:${#service}-2} ]]; then
        echo "${service:1:${#service}-2} is a file"
        echo "Exiting loop!"
      else
        echo "${service:1:${#service}-2} is not valid"
        exit 1
      fi
    fi
  done
fi


