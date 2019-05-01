#!/bin/bash -l

# set -o xtrace
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
  ACTIONS="{\"type\": \"button\", \"style\": \"primary\", \"text\": \"See Last Commit\", \"url\": \""
  ACTIONS+="${COMMIT_URL}"
  ACTIONS+="\"}"

  # See if expected files were changed.
  EXPECTED_CHANGES_ARR=($EXPECTED_CHANGES)
  NOTIFY_FILES=()
  for change in "${CHANGES[@]}"; do
    if (printf '%s\n' "${EXPECTED_CHANGES_ARR[@]}" | grep -xq $change); then
      NOTIFY_FILES+=("$change")
    fi
  done

  # Get list of projects where expected files were changed.
  PROJECTS=()
  for file in "${NOTIFY_FILES[@]}"; do
    PROJECTS+="(cut -d'/' -f2 <<<'$file')"
  done

  echo "--- Files ---"
  for file in "${NOTIFY_FILES[@]}"; do
    echo " - $file"
  done

  echo "--- Projects ---"
  for project in "${PROJECTS[@]}"; do
    echo " - $project"
  done

  # send single slack notification with full list of file changes.
  if [ ${#NOTIFY_FILES[@]} -gt 0 ]; then

    for file in ${NOTIFY_FILES[@]}; do
      MESSAGE+="\n- ${file}"
    done

    echo "Sending Slack Notification!"
    slack chat send \
      --actions "${ACTIONS}" \
      --author 'GABot' \
      --channel "$1" \
      --color bad \
      --footer 'Brought to you by Github Actions!' \
      --text "${MESSAGE}\n" \
      --title "${TITLE}"
  fi

fi
