// VM 밖에서 띄운 BE·FE 로그(2026-11-20 사용자 지적 'FE, BE LOG 에 아무것도 찍히지 않음' · 지시 'BE LOG, FE LOG 켜고/꺼는 버턴, BE 는 필요할때만')
//   · 기본 BE · FE 모두 꺼짐(2026-11-20 사용자 지시) = 로그 파일을 읽지 않음 · FE 켜면 _server_5173.log 최근 부분부터
//   · BE 켜면 nscm-be/logs/nscm.log 최근 부분부터(잘린 첫 줄 버림) · server_guard 로그는 기동 머리줄(====)만 · 너무 빨리 쌓이면 건너뜀 안내 1줄 · 다시 끄면 읽기 멈춤
//   사용: node test/t_server_belog.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => k === 'window' ? { createStatusBarItem: () => ({ show() { }, hide() { }, dispose() { } }) } : k === 'StatusBarAlignment' ? { Left: 1, Right: 2 } : new Proxy(function () { }, { get: () => function () { } }) });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'belog-')); const vibeDir = path.join(root, '.vibe');
const BE = ['nscm', 'be'].join('-');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const app = W(`${BE}/logs/nscm.log`, 'x'.repeat(300 * 1024) + 'A잘린줄의뒷부분\n11:00:00 INFO 최근 줄 1\n'); const guard = W('Doc/e2e/logs/_server_8080.log', '==== 기동 이전 머리줄\n');
const feg = W('Doc/e2e/logs/_server_5173.log', '==== FE 머리줄\n');
fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
const txt = k => require(path.join(dir, 'server-service')).snapshot(k).map(x => String(x.text).trim());
const ss = require(path.join(dir, 'server-service'));
(async () => {
  ss.init({ root, vibeDir }); await sleep(900);
  chk('기본값: BE · FE 모두 꺼짐', JSON.stringify(ss.logOnState()) === JSON.stringify({ be: false, fe: false }), JSON.stringify(ss.logOnState()));
  fs.appendFileSync(app, '11:31:52 INFO 꺼진 동안 줄\n'); fs.appendFileSync(feg, '  VITE v6 ready\n'); await sleep(1500);
  chk('BE 꺼짐 = BE 로그 안 읽음', txt('be').length === 0, JSON.stringify(txt('be')));
  chk('FE 꺼짐 = FE 로그 안 읽음', txt('fe').length === 0, JSON.stringify(txt('fe')));
  ss.setLogOn('fe', true); await sleep(1500);
  chk('FE 켜면 최근 부분부터 vite 줄 보임', txt('fe').some(t => /VITE v6 ready/.test(t)), JSON.stringify(txt('fe')));
  ss.setLogOn('be', true); await sleep(1500);
  const be = txt('be');
  chk('BE 켜면 최근 부분부터(꺼진 동안 줄 포함)', be.some(t => /최근 줄 1/.test(t)) && be.some(t => /꺼진 동안 줄/.test(t)), JSON.stringify(be.slice(-4)));
  chk('중간부터 읽을 때 잘린 첫 줄은 버림', !be.some(t => /잘린줄의뒷부분|^x+$/.test(t)));
  fs.appendFileSync(app, '11:40:00 INFO /SSP0014/main/SEARCH/call-proc 조회\n'); fs.appendFileSync(guard, 'gradle 출력 줄\n==== 2026-11-20 server_guard 기동\n'); await sleep(1500);
  const be2 = txt('be');
  chk('켠 뒤 새 줄 보임', be2.some(t => /SSP0014\/main\/SEARCH/.test(t)));
  chk('server_guard 로그는 기동 머리줄만(중복 방지)', be2.some(t => /^==== 2026-11-20 server_guard 기동/.test(t)) && !be2.some(t => /gradle 출력 줄/.test(t)));
  fs.appendFileSync(app, 'y'.repeat(9 * 1048576) + '\n11:41:00 INFO 마지막 줄\n'); await sleep(5000);
  const be3 = txt('be');
  chk('8MB 넘게 밀리면 건너뜀 안내 1줄 + 마지막 줄 보임', be3.some(t => /MB 건너뜀\(원문 nscm\.log\)/.test(t)) && be3.some(t => /마지막 줄/.test(t)), JSON.stringify(be3.slice(-2).map(t => t.slice(0, 50))));
  ss.setLogOn('be', false); const n0 = txt('be').length; fs.appendFileSync(app, '11:42:00 INFO 끈 뒤 줄\n'); await sleep(1500);
  chk('다시 끄면 읽기 멈춤', txt('be').length === n0 && !txt('be').some(t => /끈 뒤 줄/.test(t)));
  chk('알 수 없는 로그 이름 = 무시', ss.setLogOn('xx', true) === false);
  try { ss.dispose(false); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
