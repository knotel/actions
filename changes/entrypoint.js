const github = require('@actions/github')

const token = process.env.GITHUB_TOKEN;

const octokit = new github.GitHub(token);
const context = github.context;

//context here is example.json
const fs = require('fs');

console.log(context)
const commits = context.payload.commits.filter(c => c.distinct);

const FILES          = [];
const FILES_MODIFIED = [];
const FILES_ADDED    = [];
const FILES_DELETED  = [];

const tmp_services = []
console.log(JSON.stringify(commits, null, 2))
try {
  commits.forEach(commit => {
    console.log(JSON.stringify(commit, null, 2))
    FILES.push(...commit.modified, ...commit.added);
    FILES_MODIFIED.push(...commit.modified);
    FILES_ADDED.push(...commit.added);
    FILES_DELETED.push(...commit.removed);
    for (let i = 0 , len = commit.added.length; i < len; i++) {
      let path_segments = commit.added[i].split('/')
      let service_name = path_segments[0]
      if (path_segments[1] !== undefined) {
        service_name += "/" + path_segments[1]
        path_segments.shift()
        const service_file_path = path_segments.join('/')
        tmp_services.push(service_name);
      }
    }
    for (let i = 0 , len = commit.removed.length; i < len; i++) {
      let path_segments = commit.removed[i].split('/')
      let service_name = path_segments[0]
      if (path_segments[1] !== undefined) {
        service_name += "/" + path_segments[1]
        path_segments.shift()
        const service_file_path = path_segments.join('/')
        tmp_services.push(service_name);
      }
    }
    for (let i = 0 , len = commit.modified.length; i < len; i++) {
      let path_segments = commit.modified[i].split('/')
      let service_name = path_segments[0]
      if (path_segments[1] !== undefined) {
        service_name += "/" + path_segments[1]
        path_segments.shift()
        const service_file_path = path_segments.join('/')
        tmp_services.push(service_name);
      }
    }
  });
} catch (e) {
  console.log('Oh no something went wrong in iterating over commits', JSON.stringify(e, null, 2))
}

try {
  console.log('RUNNING TEMPORARY DEPLOY HACK')
  // TEMPORARY HACK TO DEPLOY
  FILES.push('frontend/atlas/src/App.jsx')
  FILES_MODIFIED.push('frontend/atlas/src/App.jsx')
  for (let i = 0 , len = FILES_MODIFIED.length; i < len; i++) {
    let path_segments = FILES_MODIFIED[i].split('/')
    let service_name = path_segments[0]
    if (path_segments[1] !== undefined) {
      service_name += "/" + path_segments[1]
      path_segments.shift()
      const service_file_path = path_segments.join('/')
      tmp_services.push(service_name);
    }
  }
} catch (e) {
  console.log('Oh no something went wrong in deploy hack', JSON.stringify(e, null, 2))
}

const SERVICES = tmp_services.filter((v, i, a) => a.indexOf(v) === i); 

fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/services.json`, JSON.stringify(SERVICES), 'utf-8');
fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/files.json`, JSON.stringify(FILES), 'utf-8');
fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/files_modified.json`, JSON.stringify(FILES_MODIFIED), 'utf-8');
fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/files_added.json`, JSON.stringify(FILES_ADDED), 'utf-8');
fs.writeFileSync(`${process.env.GITHUB_WORKSPACE}/files_deleted.json`, JSON.stringify(FILES_DELETED), 'utf-8');

console.log(fs.readFileSync(`${process.env.GITHUB_WORKSPACE}/services.json`, {encoding: 'utf-8'}))
console.log(fs.readFileSync(`${process.env.GITHUB_WORKSPACE}/files.json`, {encoding: 'utf-8'}))
console.log(fs.readFileSync(`${process.env.GITHUB_WORKSPACE}/files_modified.json`, {encoding: 'utf-8'}))
console.log(fs.readFileSync(`${process.env.GITHUB_WORKSPACE}/files_added.json`, {encoding: 'utf-8'}))
console.log(fs.readFileSync(`${process.env.GITHUB_WORKSPACE}/files_deleted.json`, {encoding: 'utf-8'}))

process.exit(0);

