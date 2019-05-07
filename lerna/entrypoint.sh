#!/bin/bash -l

set -x

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
    --footer 'Brought to you by Github Actions!' \
    --text "${LERNA_CHANGED}"

fi

if [ "$PUBLISH" = true ]; then
  cd /github/workspace
  LERNA_CHANGED=$(cd /github/workspace && lerna changed -la)
  PRETEXT="These packages are about to published to npm!:"
  echo ${LERNA_CHANGED} | /bin/slack chat send --channel $CHANNEL --pretext "${PRETEXT}" --color "${COLOR}"
  cd /github/workspace
  lerna publish minor --yes
  echo "Done publishing!" | /bin/slack chat send --channel $CHANNEL --color good
fi

