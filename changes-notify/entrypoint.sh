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
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  COMMIT=$(git log -n 1 --pretty=format:%H)
  ORG=$(git config --get remote.origin.url | sed -e "s/.*github.com.\(.*\)\/\(.*\)/\1/")
  REPO=$(basename $(git remote get-url origin) .git)
  REMOTE=$(git config --get remote.origin.url)
  COMMIT_URL="https://github.com/${ORG}/${REPO}/commit/${COMMIT}"
  # TODO: This should be an environment variable, to customize the message text.
  #MESSAGE="Hello, I have detected a change in \`${ORG}\`/\`${REPO}\`/\`${1}\` and thought I should warn you! \nBoop Beep I am a robot!"
  ACTIONS="{\"type\": \"button\", \"style\": \"primary\", \"text\": \"See Last Commit\", \"url\": \""
  ACTIONS+="${COMMIT_URL}"
  ACTIONS+="\"}"

  echo "Arg 1: ${1}"
  echo
  echo "Arg 2: ${2}"
  echo

  NOTIFY_FILES=()
  for change in ${CHANGES[@]}; do
    if [[ $(printf "_[%s]_" "${EXPECTED_CHANGES[@]}") =~ .*_\[$change\]_.* ]]; then
      NOTIFY_FILES+=("$change")
    fi
  done
  # if change in expected changes, add to list.
  # fi
  # send single slack notification with full list of file changes.
  if [ ${#NOTIFY_FILES[@]} -gt 0 ]; then

    for file in ${NOTIFY_FILES[@]}; do
      MESSAGE+="\n- ${file}"
    done
    echo "Sending Slack Notification!"
    slack chat send \
      --actions "${ACTIONS}" \
      --author 'GABot' \
      --channel "$2" \
      --color bad \
      --footer 'Brought to you by Github Actions!' \
      --text "${MESSAGE}\n" \
      --title "File changes detected!"
  fi

fi
