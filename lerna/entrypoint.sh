#!/bin/bash -l

alias git=hub

echo "HOME is ${HOME}"

function add_key() {
  mkdir -p ${THE_HOME}/.ssh
  chmod 700 ${THE_HOME}/.ssh
  echo "${KNOTELBUILD_SSH_KEY}" > ${THE_HOME}/.ssh/id_rsa
  rm -f ${THE_HOME}/.ssh/id_rsa.pub
  chmod 600 ${THE_HOME}/.ssh/id_rsa
  ssh-keyscan github.com >> ${THE_HOME}/.ssh/known_hosts
  chmod 600 ${THE_HOME}/.ssh/known_hosts
  cat ${THE_HOME}/.ssh/id_rsa | tail -c 37
  cat ${THE_HOME}/.ssh/id_rsa | wc -l
}

export THE_HOME=/root
add_key
export THE_HOME=/github/home
add_key


mknod -m 666 /dev/tty c 5 0  || true

git config --global user.email "build@knotel.com"
git config --global user.name 'Action Bronson'

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
git remote set-url origin $NEW_URL

if [ $(git cat-file -p $(git rev-parse HEAD) | grep parent | wc -l) = 1 ]; then
  echo "Not a merge commit... Pulling latest."
  #or do a git pull?
  cd /github/workspace
  git clean -f
  git pull
  git checkout master -f
  git config --global push.default current
  git clean -f
  git pull
  echo "Pulled newest changes."
  #check again after a pull for the newest commit
  if [ $(git cat-file -p $(git rev-parse HEAD) | grep parent | wc -l) = 1 ]; then
    echo "Still seeing the last commit as not a merge commit. Exiting. Please report this issue."
    exit 1
  else
    LAST_COMMIT=$(git log -1 --pretty=%s)
    if [ ${LAST_COMMIT} == "Publish" ]; then
      echo "last commit was publish"
      exit 78
    else
    #run the lerna publish workflow
    echo "Getting output of what's changed from lerna."
    lerna changed --json > ~/changed.json
    echo "Saved output to workspace in ~/changed.json"
    echo "Changed:"
    cat ~/changed.json
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
    fi
  fi
  LAST_COMMIT=$(git log -1 --pretty=%s)
  if [ ${LAST_COMMIT} == "Publish" ]; then
    echo "last commit was publish"
    exit 78
  fi
else
  echo "Last commit is a merge. Starting Lerna workflow."
  echo "Getting output of what's changed from lerna."
  lerna changed --json > ~/changed.json
  echo "Saved output to workspace in ~/changed.json"
  echo "Changed:"
  cat ~/changed.json

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
  #lerna publish minor --yes
fi
