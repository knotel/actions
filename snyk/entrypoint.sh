#!/bin/bash -l

# pwd here is /github/workspace
# We're expecting the json files generated by the Changes Action to be in the ${GITHUB_WORKSPACE} home directory

if [ ! -f ${GITHUB_WORKSPACE}/services.json ]; then
  echo "Services File does not exist."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  echo "You will need to install dependencies before running this action."
  exit 1
else
  CHANGES=($(cat ${GITHUB_WORKSPACE}/services.json | jq -r '@sh'))
  for service in ${CHANGES[@]}; do
    #if the service starts with a dot, don't run snyk tests
    if [[ ${service:1:1} == "." ]]; then
      echo "Skipping Running Snyk in $service. (Hidden Folder)"
      echo
    else
      cd /github/workspace
      cd ${service:1:${#service}-2}
      echo "Running Snyk for Service: $service"
      snyk test
      echo
    fi
  done
fi


