// External Dependencies
const fs          = require('fs');
const { Toolkit } = require('actions-toolkit');

const tools       = new Toolkit;
const { payload } = tools.context;
const commits     = payload.commits.filter(c => c.distinct);

const FILES          = [];
const FILES_MODIFIED = [];
const FILES_ADDED    = [];
const FILES_DELETED  = [];

const tmp_services = []
commits.forEach(commit => {
    FILES.push(...commit.modified, ...commit.added);
    FILES_MODIFIED.push(...commit.modified);
    FILES_ADDED.push(...commit.added);
    FILES_DELETED.push(...commit.removed);
    for (let i = 0 , len = commit.added.length; i < len; i++) {
      let path_segments = commit.added[i].split('/')
      const service_name = path_segments[0]
      path_segments.shift()
      const service_file_path = path_segments.join('/')
      tmp_services.push(service_name);
    }
    for (let i = 0 , len = commit.removed.length; i < len; i++) {
      let path_segments = commit.removed[i].split('/')
      const service_name = path_segments[0]
      path_segments.shift()
      const service_file_path = path_segments.join('/')
      tmp_services.push(service_name);
    }
    for (let i = 0 , len = commit.modified.length; i < len; i++) {
      let path_segments = commit.modified[i].split('/')
      const service_name = path_segments[0]
      path_segments.shift()
      const service_file_path = path_segments.join('/')
      tmp_services.push(service_name);
    }
});

const SERVICES = tmp_services.filter((v, i, a) => a.indexOf(v) === i); 

fs.writeFileSync(`${process.env.HOME}/services.json`, JSON.stringify(SERVICES), 'utf-8');
fs.writeFileSync(`${process.env.HOME}/files.json`, JSON.stringify(FILES), 'utf-8');
fs.writeFileSync(`${process.env.HOME}/files_modified.json`, JSON.stringify(FILES_MODIFIED), 'utf-8');
fs.writeFileSync(`${process.env.HOME}/files_added.json`, JSON.stringify(FILES_ADDED), 'utf-8');
fs.writeFileSync(`${process.env.HOME}/files_deleted.json`, JSON.stringify(FILES_DELETED), 'utf-8');

console.log(fs.readFile(`${process.env.HOME}/services.json`))
console.log(fs.readFile(`${process.env.HOME}/files.json`))
console.log(fs.readFile(`${process.env.HOME}/files_modified.json`))
console.log(fs.readFile(`${process.env.HOME}/files_added.json`))
console.log(fs.readFile(`${process.env.HOME}/files_deleted.json`))


process.exit(0);
