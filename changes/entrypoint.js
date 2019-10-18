const github = require('@actions/github')
const axios = require('axios')

const token = process.env.GITHUB_TOKEN;

const octokit = new github.GitHub(token);

const fs = require('fs');

const FILES          = [];
const FILES_MODIFIED = [];
const FILES_ADDED    = [];
const FILES_DELETED  = [];

const SERVICES = []

async function getCommit (commitHash) {
  const { data: { files }} = await axios.get(`https://api.github.com/repos/knotel/mono/commits/${commitHash}`, {
    auth: {
      username: process.env.GITHUB_ACTOR,
      password: token
    }
  })
  files.forEach(file => {
    if (file.status === 'modified') {
      FILES.push(file.filename)
      FILES_MODIFIED.push(file.filename)
    } else if (file.status === 'added') {
      FILES.push(file.filename)
      FILES_ADDED.push(file.filename)
    } else if (file.status === 'removed') {
      FILES_DELETED.push(file.filename)
    }
    let path_segments = file.filename.split('/')
    let service_name = path_segments[0]
    if (path_segments[1] !== undefined) {
      service_name += "/" + path_segments[1]
      if (!SERVICES.includes(service_name)) SERVICES.push(service_name)
    }
  })
}

function writeJSON() {
  // TODO: async read and write. Also maybe print out sour json rather than reading it
  const { GITHUB_WORKSPACE } = process.env
  fs.writeFileSync(`${GITHUB_WORKSPACE}/services.json`, JSON.stringify(SERVICES), 'utf-8');
  fs.writeFileSync(`${GITHUB_WORKSPACE}/files.json`, JSON.stringify(FILES), 'utf-8');
  fs.writeFileSync(`${GITHUB_WORKSPACE}/files_modified.json`, JSON.stringify(FILES_MODIFIED), 'utf-8');
  fs.writeFileSync(`${GITHUB_WORKSPACE}/files_added.json`, JSON.stringify(FILES_ADDED), 'utf-8');
  fs.writeFileSync(`${GITHUB_WORKSPACE}/files_deleted.json`, JSON.stringify(FILES_DELETED), 'utf-8');

  console.log(fs.readFileSync(`${GITHUB_WORKSPACE}/services.json`, {encoding: 'utf-8'}))
  console.log(fs.readFileSync(`${GITHUB_WORKSPACE}/files.json`, {encoding: 'utf-8'}))
  console.log(fs.readFileSync(`${GITHUB_WORKSPACE}/files_modified.json`, {encoding: 'utf-8'}))
  console.log(fs.readFileSync(`${GITHUB_WORKSPACE}/files_added.json`, {encoding: 'utf-8'}))
  console.log(fs.readFileSync(`${GITHUB_WORKSPACE}/files_deleted.json`, {encoding: 'utf-8'}))

}


async function runAction () {
  // TODO: get all commits commits. Should be able to find all commits
  console.log('======CONTEXT PAYLOAD======')
  console.log(JSON.stringify(github.context.payload, null, 2))
  if (github.context.payload.commits) {
    await Promise.all(github.context.payload.commits.filter(commit => commit.distinct).map(commit => getCommit(commit.id)))
    writeJSON()
    process.exit(0)
  } else {
    throw new Error('No commits in context payload')
  }
}

runAction()
