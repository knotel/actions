#!/bin/bash -l

set -x

git config --global user.name 'Action Bronson'
git config --global user.email 'product@knotel.com'



#slack chat send \
#  --actions ${actions} \
#  --author ${author} \
#  --author-icon ${author_icon} \
#  --author-link ${author-link} \
#  --channel ${channel} \
#  --color ${color} \ #  --fields ${fields} \
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

if [ "$BOOTSTRAP" = true ]; then
  cd /github/workspace
  lerna boostrap --concurrency=2
fi

if [ "$REMINDER" = true ]; then
  cd /github/workspace
  LERNA_CHANGED="\`\`\`"
  LERNA_CHANGED+=$(cd /github/workspace && lerna changed -la)
  LERNA_CHANGED+="\`\`\`"
  /bin/slack chat send \
    --author 'GABot' \
    --channel $CHANNEL \
    --color "${COLOR}" \
    --pretext "${PRETEXT}" \
    --footer 'Brought to you by Github Actions!' \
    --text "${LERNA_CHANGED}"
fi

if ["$CHANGED" = true]; then
  cd /github/workspace
  lerna changed --json > ~/changed.json
  cat ~/changed.json
fi

if [ "$PUBLISH" = true ]; then
  cd /github/workspace
  echo "Disabling Branch Protections! :try-not-to-cry:" | /bin/slack chat send --channel $CHANNEL --color "${COLOR}"
  curl --request DELETE \
    --url https://api.github.com/repos/knotel/mono/branches/master/protection/required_pull_request_reviews \
    --header 'accept: application/vnd.github.luke-cage-preview+json' \
    --header 'authorization: token $GITHUB_TOKEN' \
    --header 'content-type: application/json'
  LERNA_CHANGED=$(cd /github/workspace && lerna changed -la)
  PRETEXT="These packages are about to published to npm!:"
  echo ${LERNA_CHANGED} | /bin/slack chat send --channel $CHANNEL --pretext "${PRETEXT}" --color "${COLOR}"
  cd /github/workspace
  lerna publish minor --yes
  /bin/slack chat send --channel $CHANNEL --text "Done publishing! :fire:" --color good
  /bin/slack chat send --channel $CHANNEL --text "Enabling Branch Protections! :try-not-to-cry-party:" --color "${COLOR}"
  curl https://api.github.com/repos/knotel/mono/branches/master \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.luke-cage-preview+json" \
      -X PATCH \
      -d '{
        "protection": {
          "enabled": true,
          "required_status_checks": {
            "enforcement_level": "everyone",
            "contexts": [
              "default"
            ]
          }
        }
      }'
fi

