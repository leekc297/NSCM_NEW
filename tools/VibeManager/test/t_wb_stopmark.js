// 중지로 끝난 실행 = why '중지됨', 같은 초에 시작한 체인 2개의 로그 이름이 다름(개선안 20261120042556_INC)
//   사용: node test/t_wb_stopmark.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wbstop-')); const vibeDir = path.join(root, '.vibe');
const p = { root, vibeDir, extDir: dir, node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  const wbm = require(path.join(dir, 'workbench'));
  const sm = wbm._stopMarkOf;
  chk('판정: 종료코드 0 = 중지 아님', sm(0, true, '', false) === '');
  chk('판정: 중지 표시 = 중지됨(사용자 지시)', sm(1, true, '[FAIL] SsoUserModal ssoUserYn', true) === '중지됨(사용자 지시)');
  chk('판정: 표시 없음, exit 1, 마지막 줄 진행 = 중지됨', /^중지됨/.test(sm(1, false, '[3/12] 시나리오 실행 중...', false)));
  chk('판정: 표시 없음, exit 1, 마지막 줄 [FAIL] = 실패', sm(1, false, '[FAIL] SsoUserModal ssoUserYn', true) === '');
  chk('판정: 표시 없음, exit 2, 마지막 줄 진행 = 실패', sm(2, false, '진행 3/12', false) === '');

  // 같은 초에 시작한 체인 2개(화면 SCP0005, SSP0005) 로그 이름
  const echoJs = path.join(root, 'echo.js'); fs.writeFileSync(echoJs, 'console.log(process.argv[2] || "")');
  const logs = {}; const ids = ['SCP0005', 'SSP0005'];
  await Promise.all(ids.map(id => wbm.createRunner(api, { id, quiet: true, sink: m => { const mm = m && m.type === 'out' && /로그 (\S+\.log)/.exec(m.text); if (mm) logs[id] = mm[1]; } })
    .spawnStream(p, 'node', [echoJs, id], {}, 'task', 'CheckList 검증')));
  chk('같은 초 체인 2개 로그 이름 다름', !!logs.SCP0005 && !!logs.SSP0005 && logs.SCP0005 !== logs.SSP0005, `${logs.SCP0005} | ${logs.SSP0005}`);

  // 중지 단추(stopAll)로 끝난 실행: 로그에 [FAIL] 줄이 있어도 why = 중지됨
  const longJs = path.join(root, 'long.js'); fs.writeFileSync(longJs, 'console.log("[FAIL] SsoUserModal ssoUserYn"); console.log("[1/80] 시나리오 실행 중..."); setTimeout(() => { }, 60000);');
  const msgs = []; const wb = wbm.createRunner(api, { id: 'SCP0028', quiet: true, sink: m => msgs.push(m) });
  const pr = wb.spawnStream(p, 'node', [longJs], {}, 'task', 'CheckList 검증');
  await new Promise(r => setTimeout(r, 1500)); wb.stopAll();
  const code = await Promise.race([pr, new Promise(r => setTimeout(() => r('timeout'), 20000))]);
  chk('중지한 실행 종료', code !== 'timeout' && code !== 0, String(code));
  const f = wb._lastFail || {};
  chk('중지한 실행 why = 중지됨', /^중지됨/.test(f.why || ''), f.why);
  chk('중지한 실행 원인에 [FAIL] 줄 안 씀', !String(f.why || '').includes('SsoUserModal'));
  chk('실패 알림(✖) 없음', !msgs.some(m => m && /✖ .*실패/.test(m.text || '')));

  // 표시 없는 [FAIL] 종료 = 종전대로 실패
  const failJs = path.join(root, 'fail.js'); fs.writeFileSync(failJs, 'console.log("[FAIL] files.csv current 변형 없음"); process.exit(1);');
  const wb2 = wbm.createRunner(api, { id: 'SSP0014', quiet: true });
  const c2 = await wb2.spawnStream(p, 'node', [failJs], {}, 'task', 'CheckList 검증');
  chk('[FAIL] 종료 = 실패 원인 유지', c2 === 1 && wb2._lastFail && wb2._lastFail.src === 'mark' && wb2._lastFail.why.includes('files.csv'), wb2._lastFail && wb2._lastFail.why);

  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('ERROR', e && e.stack || e); process.exit(1); });
