import * as core from '@actions/core';
const exec = require('@actions/exec');
const tc = require('@actions/tool-cache');

const myOutput = '';
const myError = '';

//RUN wget "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" && chmod +x slack

async function installAndUseSlack() {
  try {
    const slackPath = await tc.downloadTool('https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack');
    const slackExtractedFolder = await tc.extractTar(slackPath, '/bin');
    const cachedPath = await tc.cacheDir(slackExtractedFolder, 'slack');
    core.addPath(cachedPath);

  } catch (error) {
    core.setFailed(error.message);
  }
}

async function installAndUseJQ() {
  try {
    const jqPath = await tc.downloadTool('http://stedolan.github.io/jq/download/linux64/jq');
    const jqExtractedFolder = await tc.extractTar(jqPath, '/bin');
    const cachedPath = await tc.cacheDir(jqExtractedFolder, 'jq', '2.11.2');
    core.addPath(cachedPath);

  } catch (error) {
    core.setFailed(error.message);
  }
}

async function installAndUseHub() {
  try {
    const hubPath = await tc.downloadTool('https://github.com/github/hub/releases/download/v2.11.2/hub-linux-amd64-2.11.2.tgz');
    const hubExtractedFolder = await tc.extractTar(hubPath, '/bin');
    const cachedPath = await tc.cacheDir(hubExtractedFolder, 'hub', '2.11.2');
    core.addPath(cachedPath);

  } catch (error) {
    core.setFailed(error.message);
  }
}
installAndUseHub();
installAndUseSlack();
installAndUseJQ();
