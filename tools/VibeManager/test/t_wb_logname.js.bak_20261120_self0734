// spawnStream 로그 이름 = 시각_화면ID_procId_라벨 — 같은 초에 시작한 실행 3건이 로그 파일을 공유하지 않는지(개선안 20261120005819_INC)
//   사용: node test/t_wb_logname.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wblog-')); const vibeDir = path.join(root, '.vibe');
const p = { root, vibeDir, extDir: dir, node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  const wbm = require(path.join(dir, 'workbench'));
  const echoJs = path.join(root, 'echo.js'); fs.writeFileSync(echoJs, 'console.log(process.argv[2] || "")'); // shell 실행이라 node 경로 공백·인용부호 없이 스크립트 파일로
  const ids = ['SCP0005', 'SCP0014', 'SCP0028']; const logs = {};
  const runs = ids.map(id => { const wb = wbm.createRunner(api, { id, quiet: true, sink: m => { const mm = m && m.type === 'out' && /로그 (\S+\.log)/.exec(m.text); if (mm) logs[id] = mm[1]; } });
    return wb.spawnStream(p, 'node', [echoJs, id], {}, 'task', 'CheckList 검증(한글 라벨)'); });
  const codes = await Promise.all(runs);
  chk('3건 종료코드 0', codes.every(c => c === 0), codes.join(','));
  const names = ids.map(id => logs[id] || '');
  chk('3건 로그 이름 기록', names.every(Boolean), names.join(' | '));
  chk('3건 로그 이름 서로 다름', new Set(names).size === 3);
  for (const id of ids) {
    const f = logs[id] ? path.join(root, logs[id]) : '';
    chk(`${id} 로그 이름에 화면 ID`, path.basename(f).includes(`_${id}_`), path.basename(f));
    const txt = f && fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : '';
    chk(`${id} 로그 내용 = 자기 출력만`, txt.includes(id) && ids.filter(x => x !== id).every(x => !txt.includes(x)), JSON.stringify(txt.trim()));
  }
  const wb1 = wbm.createRunner(api, { id: 'SSP0014', quiet: true }); const two = [];
  wb1.sink = m => { const mm = m && m.type === 'out' && /로그 (\S+\.log)/.exec(m.text); if (mm) two.push(mm[1]); };
  await Promise.all([1, 2].map(() => wb1.spawnStream(p, 'node', [echoJs], {}, 'task', 'same')));
  chk('같은 창 같은 라벨 2건도 이름 다름', two.length === 2 && two[0] !== two[1], two.join(' | '));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('ERROR', e && e.stack || e); process.exit(1); });
