#!/bin/bash -l

set -e

# We're expecting the json files generated by the Changes Action to be in the ~ home directory

if [ ! -f ~/services.json ]; then
  echo "Services File does not exist."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  echo "You will need to install dependencies before running this action."
  exit 1
else
  CHANGES=`cat ~/services.json | jq -r '@sh'`
  for service in ${CHANGES[@]}; do
    #if the service starts with a dot, don't run Jest tests
    if [ ${service:1:1} == "." ]; then
      echo "Skipping Running Jest in $service. (Hidden Folder)"
      echo
    else
      cd /github/workspace
      cd ${service:1:${#service}-2}
      echo "Running Jest for Service: $service"
      $JEST_CMD $* --ci --testLocationInResults --json --outputFile=report.json &> /dev/null
      cat report.json | /usr/bin/jest-action
      echo
    fi
  done
fi
