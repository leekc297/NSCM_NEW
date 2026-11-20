// VM 밖에서 띄운 BE 로그(2026-11-20 사용자 지적 'FE, BE LOG 에 아무것도 찍히지 않음'): VM 이 띄운 BE 가 아니면 nscm-be/logs/nscm.log 를 지금 끝에서부터 따라 읽어 BE Log 에 보임
//   · 시작 전 내용은 보내지 않음 · server_guard 로그는 기동 머리줄(====)만 · 너무 빨리 쌓이면 건너뜀 안내 1줄
//   사용: node test/t_server_belog.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => k === 'window' ? { createStatusBarItem: () => ({ show() { }, hide() { }, dispose() { } }) } : k === 'StatusBarAlignment' ? { Left: 1, Right: 2 } : new Proxy(function () { }, { get: () => function () { } }) });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'belog-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const app = W('nscm-be/logs/nscm.log', '11:00:00 INFO 시작 전 줄\n'); const guard = W('Doc/e2e/logs/_server_8080.log', '==== 기동 이전 머리줄\n');
fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
const ss = require(path.join(dir, 'server-service'));
(async () => {
  ss.init({ root, vibeDir }); await sleep(900);
  fs.appendFileSync(app, '11:31:52 INFO /SSP0014/main/SEARCH/call-proc 조회\n'); fs.appendFileSync(guard, 'gradle 출력 줄\n==== 2026-11-20 server_guard 기동\n');
  await sleep(1800);
  const be = ss.snapshot('be').map(x => String(x.text).trim());
  chk('BE 파일 로그 새 줄이 BE Log 에 보임', be.some(t => /SSP0014\/main\/SEARCH/.test(t)), JSON.stringify(be));
  chk('시작 전 내용은 보내지 않음', !be.some(t => /시작 전 줄|기동 이전 머리줄/.test(t)));
  chk('server_guard 로그는 기동 머리줄만(중복 방지)', be.some(t => /^==== 2026-11-20 server_guard 기동/.test(t)) && !be.some(t => /gradle 출력 줄/.test(t)));
  fs.appendFileSync(app, 'x'.repeat(9 * 1048576) + '\n11:40:00 INFO 마지막 줄\n'); await sleep(2500);
  const be2 = ss.snapshot('be').map(x => String(x.text).trim());
  chk('8MB 넘게 밀리면 건너뜀 안내 1줄 + 마지막 줄 보임', be2.some(t => /MB 건너뜀\(원문 nscm\.log\)/.test(t)) && be2.some(t => /마지막 줄/.test(t)), JSON.stringify(be2.slice(-3).map(t => t.slice(0, 60))));
  try { ss.dispose(false); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
