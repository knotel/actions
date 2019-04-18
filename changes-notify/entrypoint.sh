#!/bin/bash -l

set -o xtrace
set -eu
set -o pipefail

# $1 = file to look against
# $2 = slack channel to notify

#slack chat send \
#  --actions ${actions} \
#  --author ${author} \
#  --author-icon ${author_icon} \
#  --author-link ${author-link} \
#  --channel ${channel} \
#  --color ${color} \
#  --fields ${fields} \
#  --footer ${footer} \
#  --footer-icon ${footer-icon} \
#  --image '${image}' \
#  --pretext '${pretext}' \
#  --text '${slack-text}' \
#  --time ${time} \
#  --title ${title} \
#  --title-link ${title-link}

# ${title-link}  = 'https://github.com/knotel/actions/lerna'
# ${fields}      = '{"title": "Environment", "value": "snapshot", "short": true}'
# ${channel}     = '#channel'
# ${author-link} = 'https://github.com/knotel/actions/lerna'
# ${fields}      = '{"title": "Environment", "value": "snapshot", "short": true}'
# ${author-link} = 'https://github.com/rockymadden/slack-cli'
# ${author-icon} = 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png'
# ${footer-icon} = 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png'
# ${actions}     = '{"type": "button", "style": "primary", "text": "See results", "url": "http://example.com"}'
# ${image}       = "https://assets-cdn.github.com/images/modules/logos_page/Octocat.png"

if [ ! -f ~/services.json ]; then
  echo "Services File does not exist."
  echo "Please install the changes action at https://github.com/Knotel/actions/changes"
  echo "You will need to install dependencies before running this action."
  exit 1
else
  CHANGES=($(cat ~/files.json | jq -r '.[]' ))
  BRANCH=$(cd /github/workspace && git rev-parse --abbrev-ref HEAD)
  COMMIT=$(cd /github/workspace && git log -n 1 --pretty=format:%H)
  ORG=$(cd /github/workspace && git config --get remote.origin.url | sed -e "s/.*github.com.\(.*\)\/\(.*\)/\1/")
  REPO=$(cd /github/workspace && basename `git rev-parse --show-toplevel`)
  REMOTE=$(cd /github/workspace && git config --get remote.origin.url)
  FILE_URL="https://github.com/${ORG}/${REPO}/tree/${BRANCH}/${1}"
  COMMIT_URL="https://github.com/${ORG}/${REPO}/commit/${COMMIT}"
  MESSAGE="Hello, I have detected a change in \`${ORG}\`/\`${REPO}\`/\`${1}\` and thought I should warn you! \nBoop Beep I am a robot!"
  ACTIONS="{\"type\": \"button\", \"style\": \"primary\", \"text\": \"See Last Commit\", \"url\": \""
  ACTIONS+="${COMMIT_URL}"
  ACTIONS+="\"}"
  ACTIONS+=",{\"type\": \"button\", \"style\": \"secondary\", \"text\": \"Link to File\", \"url\": \""
  ACTIONS+="${FILE_URL}"
  ACTIONS+="\"}"


  echo "Arg 1: ${1}"
  echo
  echo "Arg 2: ${2}"
  echo

  for change in ${CHANGES[@]}; do
    if [[ "$change" = "$1" ]]; then
      echo "Sending Slack Notification!"
      slack chat send \
        --actions "${ACTIONS}" \
        --author 'GABot' \
        --channel "$2" \
        --color bad \
        --footer 'Brought to you by Github Actions!' \
        --text "${MESSAGE}" \
        --title "File changes detected!"
    fi
  done
fi
