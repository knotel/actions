import * as core from '@actions/core';
const exec = require('@actions/exec');
const tc = require('@actions/tool-cache');

async function run() {
  try {
    await exec.exec('node index.js');
    const myInput = core.getInput('myInput');
    core.debug(`Hello ${myInput}`);
  } catch (error) {
    core.setFailed(error.message);
  }
}

installAndUseHub();
run();
