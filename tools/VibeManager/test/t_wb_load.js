// workbench.js · extension.js 가 vscode 모의 모듈로 로드되는지(최상위 실행 오류 없음) 확인
const Module = require('module'); const path = require('path');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load;
Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = process.argv[2];
for (const f of ['orch-events.js', 'workbench.js', 'extension.js']) {
  try { const m = require(path.join(dir, f)); console.log('LOAD_OK', f, Object.keys(m).slice(0, 12).join(',')); }
  catch (e) { console.log('LOAD_FAIL', f, e.message); process.exitCode = 1; }
}
