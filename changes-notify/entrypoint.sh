#!/bin/bash

set -eu

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

CHANGES=($(cat ~/files.json | jq -r '.[]' ))
BRANCH=$(cd /github/workspace && git rev-parse --abbrev-ref HEAD)
COMMIT=$(cd /github/workspace && git log -n 1 --pretty=format:%H -- ${1})
ORG=$(git config --get remote.origin.url | sed -e "s/.*github.com.\(.*\)\/\(.*\)/\1/")
REPO=$(cd /github/workspace && basename `git rev-parse --show-toplevel`)
REMOTE=$(cd /github/workspace && git config --get remote.origin.url)
FILE_URL="https://github.com/${ORG}/${REPO}/tree/${BRANCH}/${1}"
COMMIT_URL="https://github.com/${ORG}/${REPO}/commit/${COMMIT}"
MESSAGE="Hello, I have detected a change in \`${REPO}\`/\`${1}\` and thought I should warn you! \nBoop Beep I am a robot!"

for change in ${CHANGES[@]}; do
  if [[ "$change" = "$1" ]]; then
    slack chat send \
      --actions '{"type": "button", "style": "primary", "text": "Last Commit to this File", "url": "${COMMIT_URL"}, {"type": "button", "style": "secondary", "text": "Link to File", "url": "${FILE_URL}"' \
      --author 'DATABOT' \
      --channel '$2' \
      --color bad \
      --fields '{"title": "Github Action: changed-notify", "short": false}' \
      --text '${MESSAGE}'
  fi
done

