"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const core = __importStar(require("@actions/core"));
const exec = require('@actions/exec');
const tc = require('@actions/tool-cache');
const myOutput = '';
const myError = '';
//RUN wget "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" && chmod +x slack
function installAndUseSlack() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const slackPath = yield tc.downloadTool('https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack');
            const slackExtractedFolder = yield tc.extractTar(slackPath, '/bin');
            const cachedPath = yield tc.cacheDir(slackExtractedFolder, 'slack');
            core.addPath(cachedPath);
        }
        catch (error) {
            core.setFailed(error.message);
        }
    });
}
function installAndUseJQ() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const jqPath = yield tc.downloadTool('http://stedolan.github.io/jq/download/linux64/jq');
            const jqExtractedFolder = yield tc.extractTar(jqPath, '/bin');
            const cachedPath = yield tc.cacheDir(jqExtractedFolder, 'jq', '2.11.2');
            core.addPath(cachedPath);
        }
        catch (error) {
            core.setFailed(error.message);
        }
    });
}
function installAndUseHub() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const hubPath = yield tc.downloadTool('https://github.com/github/hub/releases/download/v2.11.2/hub-linux-amd64-2.11.2.tgz');
            const hubExtractedFolder = yield tc.extractTar(hubPath, '/bin');
            const cachedPath = yield tc.cacheDir(hubExtractedFolder, 'hub', '2.11.2');
            core.addPath(cachedPath);
        }
        catch (error) {
            core.setFailed(error.message);
        }
    });
}
function run() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            yield exec.exec('node index.js');
            const myInput = core.getInput('myInput');
            core.debug(`Hello ${myInput}`);
        }
        catch (error) {
            core.setFailed(error.message);
        }
    });
}
installAndUseHub();
run();
