#!/bin/bash -l

alias git=hub

set -x
echo "${KNOTELBUILD_SSH_KEY}" > $HOME/.ssh/id_rsa

git config --global user.email "build@knotel.com"
git config --global user.name 'Action Bronson'

if [ $(git cat-file -p $(git rev-parse HEAD) | grep parent | wc -l) = 1 ]; then
  echo "Not a merge commit... Pulling latest."
  #or do a git pull?
  cd /github/workspace
  REPO_URL=`git remote -v | grep -m1 '^origin' | sed -Ene's#.*(https://[^[:space:]]*).*#\1#p'`
  if [ -z "$REPO_URL" ]; then
    echo "-- ERROR:  Could not identify Repo url."
    echo "   It is possible this repo is already using SSH instead of HTTPS."
    exit
  fi

  USER=`echo $REPO_URL | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
  if [ -z "$USER" ]; then
    echo "-- ERROR:  Could not identify User."
    exit
  fi

  REPO=`echo $REPO_URL | sed -Ene's#https://github.com/([^/]*)/(.*).git#\2#p'`
  if [ -z "$REPO" ]; then
    echo "-- ERROR:  Could not identify Repo."
    exit
  fi

  NEW_URL="git@github.com:$USER/$REPO.git"
  echo "Changing repo url from "
  echo "  '$REPO_URL'"
  echo "      to "
  echo "  '$NEW_URL'"
  echo ""

  CHANGE_CMD="git remote set-url origin $NEW_URL"
  `$CHANGE_CMD`

  echo "Success"

  git pull
  if [ $(git log -1 --pretty=%s) == "Publish" ]; then
    echo "last commit was publish"
    exit 78
  fi
else
  echo "Last commit is a merge. Starting Lerna workflow."
  # $(git log -1 --pretty=%s) to get the title of the last commit.
  # We want to check if the last one is `Publish`, as that's the title
  # that Lerna gives the publish commit.

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
  lerna changed --json > ~/changed.json
  cat ~/changed.json

  cd /github/workspace
  LERNA_CHANGED="\`\`\`"
  LERNA_CHANGED=$(cd /github/workspace && lerna changed -la)
  LERNA_CHANGED+="\`\`\`"
  PRETEXT="The following packages have had a minor version bump."
  /bin/slack chat send \
    --author 'Action Bronson' \
    --channel $CHANNEL  \
    --pretext "${PRETEXT}" \
    --color "${COLOR}" \
    --text "${LERNA_CHANGED}"

  cd /github/workspace
  lerna publish minor --yes
fi
