const request = require('./request')

const { GITHUB_SHA, GITHUB_EVENT_PATH, GITHUB_TOKEN, GITHUB_WORKSPACE } = process.env
console.log(process.env)
const event = require(GITHUB_EVENT_PATH)
const { repository } = event
const {
  owner: { login: owner }
} = repository
const { name: repo } = repository

const checkName = 'ESLint check'

const headers = {
  'Content-Type': 'application/json',
  Accept: 'application/vnd.github.antiope-preview+json',
  Authorization: `Bearer ${GITHUB_TOKEN}`,
  'User-Agent': 'eslint-action'
}

async function createCheck() {
  const body = {
    name: checkName,
    head_sha: GITHUB_SHA,
    status: 'in_progress',
    started_at: new Date()
  }

  const { data } = await request(`https://api.github.com/repos/${owner}/${repo}/check-runs`, {
    method: 'POST',
    headers,
    body
  })
  const { id } = data
  return id
}

function eslint() {
  const eslint = require('eslint')

  const cli = new eslint.CLIEngine()
  const report = cli.executeOnFiles(['.'])
  // fixableErrorCount, fixableWarningCount are available too
  const { results, errorCount, warningCount } = report

  const levels = ['', 'warning', 'failure']

  const annotations = []
  for (const result of results) {
    const { filePath, messages } = result
    const path = filePath.substring(GITHUB_WORKSPACE.length + 1)
    for (const msg of messages) {
      const { line, severity, ruleId, message } = msg
      const annotationLevel = levels[severity]
      annotations.push({
        path,
        start_line: line,
        end_line: line,
        annotation_level: annotationLevel,
        message: `[${ruleId}] ${message}`
      })
    }
  }

  const pages = chunk(annotations, 50)

  return {
      conclusion: errorCount > 0 ? 'failure' : 'success',
      output: {
        title: checkName,
        summary: `${errorCount} error(s), ${warningCount} warning(s) found`,
      },
      pages,
    }
}

async function updateCheck(id, conclusion, output, pages) {
  console.log('inside updateCheck: ', pages[0])

  for (const page of pages) {

    output.annotations = page

    const body = {
      name: checkName,
      head_sha: GITHUB_SHA,
      status: 'completed',
      completed_at: new Date(),
      conclusion,
      output,
    }

    await request(`https://api.github.com/repos/${owner}/${repo}/check-runs/${id}`, {
      method: 'PATCH',
      headers,
      body
    })
  }
}

function exitWithError(err) {
  console.error('Error', err.stack)
  if (err.data) {
    console.error(err.data)
  }
  process.exit(1)
}

function chunk(array, size) {
  const chunked_arr = [];
  let copied = [...array]; // ES6 destructuring
  const numOfChild = Math.ceil(copied.length / size); // Round up to the nearest integer
  for (let i = 0; i < numOfChild; i++) {
    chunked_arr.push(copied.splice(0, size));
  }
  return chunked_arr;
}

async function run() {
  const id = await createCheck()
  try {
    const { conclusion, output, pages } = eslint()
    console.log(output.summary)
    await updateCheck(id, conclusion, output, pages)
    if (conclusion === 'failure') {
      process.exit(78)
    }
  } catch (err) {
    await updateCheck(id, 'failure')
    exitWithError(err)
  }
}

run().catch(exitWithError)
