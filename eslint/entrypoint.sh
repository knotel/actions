#!/bin/bash -l
set -e

# pwd here is /github/workspace
# We're expecting the json files generated by the Changes Action to be in the ${HOME} home directory

if [ ! -f ${HOME}/services.json ]; then
  echo "Services File does not exist."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  echo "You will need to install dependencies before running this action."
  exit 1
else
  CHANGES=($(cat ${HOME}/services.json | jq -r '@sh'))
  for service in ${CHANGES[@]}; do
    #if the service starts with a dot, don't run snyk tests
    if [[ ${service:1:1} == "." ]]; then
      echo "Skipping running in $service. (Hidden Folder)"
      echo
    else
      cd /github/workspace
      cd ${service:1:${#service}-2} || continue
      if [ -f package.json ]; then
        echo "Running eslint $* inside of ${service:1:${#service}-2}"
        node /action/run.js
        echo
      else
        echo "No package.json file"
        echo "Not a lintable service. Exiting Netural."
        exit 78
      fi
    fi
  done
fi
