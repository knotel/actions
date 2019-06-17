#!/bin/bash -l

alias git=hub

set -x
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
echo "${KNOTELBUILD_SSH_KEY}" > $HOME/.ssh/id_rsa
rm -f $HOME/.ssh/id_rsa.pub
chmod 600 $HOME/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> $HOME/.ssh/known_hosts
chmod 600 $HOME/.ssh/known_hosts
mknod -m 666 /dev/tty c 5 0
cat $HOME/.ssh/id_rsa | tail -c 9

git config --global user.email "build@knotel.com"
git config --global user.name 'Action Bronson'

cat $HOME/.ssh/id_rsa | tail -c 9

cd /github/workspace

NEW_URL="git@github.com:$USER/$REPO.git"
git remote set-url origin $NEW_URL

if [ $(git cat-file -p $(git rev-parse HEAD) | grep parent | wc -l) = 1 ]; then
  echo "Not a merge commit... Pulling latest."
  #or do a git pull?
  cd /github/workspace
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

  #cd /github/workspace
  #LERNA_CHANGED="\`\`\`"
  #LERNA_CHANGED=$(cd /github/workspace && lerna changed -la)
  #LERNA_CHANGED+="\`\`\`"
  #PRETEXT="The following packages have had a minor version bump."
  #/bin/slack chat send \
  #  --author 'Action Bronson' \
  #  --channel $CHANNEL  \
  #  --pretext "${PRETEXT}" \
  #  --color "${COLOR}" \
  #  --text "${LERNA_CHANGED}"

  cd /github/workspace
  lerna publish minor --yes
fi
