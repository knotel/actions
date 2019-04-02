#!/bin/bash -l

set -eu

echo "RUNNING LS!"
echo
ls
echo
echo "LS OVER!!!"

echo "CATTING services.json!"
echo
cat ~/services.json
echo
echo "CATTING OVER!!!"

if [ ! -f services.json ]; then
  echo "Services File does not exist."
  exit 1
else
  CHANGES=($(cat ~/services.json | jq -r '@sh'))
  for service in ${CHANGES[@]}; do
    #if the service starts with a dot, don't run snyk tests
    if [[ ${service:1:1} == "." ]]; then
      echo "Skipping Running Snyk in $service"
      echo
    else
      cd ~/
      cd ${service:1:${#service}-2}
      echo "Running Yarn Setup!"
      yarn
      echo
      echo "Running Snyk for Service: $service"
      snyk test
      echo
    fi
  done
fi


