import * as io from '@actions/io';
import fs = require('fs');
import os = require('os');
import path = require('path');

const toolDir = path.join(__dirname, 'runner', 'tools');
const tempDir = path.join(__dirname, 'runner', 'temp');

process.env['AGENT_TOOLSDIRECTORY'] = toolDir;
process.env['RUNNER_TOOL_CACHE'] = toolDir;
process.env['RUNNER_TEMP'] = tempDir;

import {installAndUseSlack} from '../src/install';

describe('find-slack', () => {
  beforeAll(async () => {
    await io.rmRF(toolDir);
    await io.rmRF(tempDir);
  });

  afterAll(async () => {
    try {
      await io.rmRF(toolDir);
      await io.rmRF(tempDir);
    } catch {
      console.log('Failed to remove test directories');
    }
  }, 100000);

  it('Uses version of ruby installed in cache', async () => {
    const slackPath: string = path.join(toolDir, 'slack', os.arch());
    await io.mkdirP(slackPath);
    fs.writeFileSync(`${slackPath}.complete`, 'hello');
    // This will throw if it doesn't find it in the cache (because no such version exists)
    await find-slack();
  });

  it('find-slack throws if cannot find any version of slack', async () => {
    let thrown = false;
    try {
      await find-slack('9.9.9');
    } catch {
      thrown = true;
    }
    expect(thrown).toBe(true);
  });

  it('findslackbin adds slack bin to PATH', async () => {
    const slackPath: string = path.join(toolDir, 'slack', os.arch());
    await io.mkdirP(slackDir);
    fs.writeFileSync(`${slackDir}.complete`, 'hello');
    await findSlackVersion();
    const binDir = path.join(slackDir, 'bin');
    console.log(`binDir: ${binDir}`);
    console.log(`PATH: ${process.env['PATH']}`);
    expect(process.env['PATH']!.startsWith(`${binDir}`)).toBe(true);
  });
});
