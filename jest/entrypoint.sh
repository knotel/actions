#!/bin/bash -l
# We're expecting the json files generated by the Changes Action to be in the ~ home directory
if [ ! -f ~/services.json ]; then
  echo "Services File does not exist."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  echo "You will need to install dependencies before running this action."
  exit 1
else
  cat ~/services.json
  CHANGES=`cat ~/services.json | jq -r '@sh'`
  for service in ${CHANGES[@]}; do
    #${service:1:${#service}-2} is shorthand for removing the single quotes around the service dir
    PROJECT=$(basename ${service:1:${#service}-2})
    #$PROJECT is the name of the project, IE "atlas"
    if [ ${service:1:1} == "." ]; then
      #if the service starts with a dot, don't run Jest tests
      echo "Skipping Running Jest in $service. (Hidden Folder)"
      echo
    else
      cd /github/workspace
      cd ${service:1:${#service}-2}
      if [ ! -f /usr/bin/jest-action ]; then
        echo "Error! /usr/bin/jest-action File does not exist!"
      else
        echo "Running Jest for Service: $service"
        $JEST_CMD $* --passWithNoTests & JESTPID1=$!
        wait $JESTPID1
        echo "jest process id ${JESTPID1} finished running in ${service:1:${#service}-2}"
        sleep 2
        cd /github/workspace/coverage/${PROJECT}
        cat jest-results.json | /usr/bin/jest-action
      fi
    fi
  done
fi
