// workbench.js verifyStep 의 fileExists + fresh 시험(P6) — 예전 파일로는 통과하지 않고 이번 단계가 만든 파일만 통과
//   사용: node test/t_verify_fresh.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = process.argv[2] || path.join(__dirname, '..'); const wb = require(path.join(dir, 'workbench'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'vfy-')); const p = { root, genDir: path.join(root, 'Doc', 'gen') };
const f = path.join(root, 'Doc', 'verify', 'TST0001', 'unverified_triage.json'); fs.mkdirSync(path.dirname(f), { recursive: true });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const v = (fresh, since) => wb.verifyStep(p, { type: 'fileExists', fresh, file: '${root}/Doc/verify/${id}/unverified_triage.json', _since: since }, 'TST0001');
let r = v(true, Date.now()); chk('파일 없음 = 실패', !r.ok, r.why);
fs.writeFileSync(f, '{}'); const old = new Date(Date.now() - 3600000); fs.utimesSync(f, old, old);
r = v(true, Date.now() - 1000); chk('1시간 전 파일 + fresh = 실패', !r.ok && /갱신되지 않음/.test(r.why) && r.from === 'run', r.why);
r = v(false, Date.now() - 1000); chk('fresh 없는 종전 정의는 그대로 통과', r.ok, r.why);
fs.writeFileSync(f, '{"a":1}'); r = v(true, Date.now() - 1000); chk('이번에 만든 파일 + fresh = 통과', r.ok, r.why);
fs.rmSync(root, { recursive: true, force: true }); console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
