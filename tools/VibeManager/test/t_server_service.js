// server-service.js · orch-state.js 동작 시험 — 실행마다 빈 포트를 받아 임시 node 서버만 띄우고 끈다(8080·5173 은 상태만 읽는다)
//   2026-11-19 22:5x: 고정 포트 5599 → 빈 포트. 시험 2개가 같은 때 돌면(VMO 주기 점검 S2 + 명령줄 실행 · 개선안 반영 게이트) 한쪽이 '포트 5599 사용 중' · '종료 뒤 상태 up' 으로 실패했다(사건 20261119_225004_R12_ALL)
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const notes = [];
const vs = { window: { createStatusBarItem: () => ({ show() { }, dispose() { } }), showInformationMessage: (m) => { notes.push('info: ' + m); return Promise.resolve(); }, showWarningMessage: (m) => { notes.push('warn: ' + m); return Promise.resolve(); }, showErrorMessage: (m) => { notes.push('err: ' + m); return Promise.resolve(); } }, StatusBarAlignment: { Left: 1 }, ThemeColor: function (n) { this.n = n; }, commands: { executeCommand: () => { } } };
const orig = Module._load; Module._load = function (req, ...r) { return req === 'vscode' ? vs : orig.call(this, req, ...r); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..')); let PORT = 0;
const freePort = () => new Promise((res, rej) => { const s = require('net').createServer(); s.unref(); s.on('error', rej); s.listen(0, '127.0.0.1', () => { const n = s.address().port; s.close(() => res(n)); }); });
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'svc-')); const p = { root, vibeDir: path.join(root, '.vibe') };
const srvJs = path.join(root, 'srv.js');
const writeSrv = () => fs.writeFileSync(srvJs, `const http=require('http');console.log('booting');setTimeout(()=>{http.createServer((q,s)=>{console.log('req '+q.url);s.end('ok')}).listen(${PORT},'127.0.0.1',()=>console.log('Started TestApp in 0.3 seconds'));},300);`);
const sleep = ms => new Promise(r => setTimeout(r, ms));
const load = () => { for (const k of Object.keys(require.cache)) if (/server-service|orch-events|orch-state/.test(k)) delete require.cache[k]; return { svc: require(path.join(dir, 'server-service')), st: require(path.join(dir, 'orch-state')) }; };
(async () => {
  PORT = await freePort(); writeSrv(); console.log('시험 포트', PORT);
  let ok = true; const chk = (name, cond, extra) => { console.log(cond ? 'PASS' : 'FAIL', name, extra || ''); if (!cond) ok = false; };
  let { svc, st } = load(); const got = []; svc.subscribe(m => got.push(m)); st.init(p);
  const it = { cmd: `node "${srvJs}"`, ready: 'Started TestApp in ([\\d.]+) seconds', port: PORT, readyTimeoutSec: 20, expectProc: 'node|cmd' };
  const r = await svc.start(p, it, root, 'TEST SRV');
  chk('기동 완료 판정', r && r.ok, JSON.stringify(r));
  chk('서버 등록', svc.isRunning('TEST SRV'));
  chk('로그 파일 이어 읽기', got.some(m => m.type === 'out' && /booting/.test(m.text)) && got.some(m => m.type === 'out' && /Started TestApp/.test(m.text)));
  chk('server 메시지', got.some(m => m.type === 'server' && m.ok === true));
  await svc.pollOnce(); await sleep(300);
  const s1 = svc.stateList().find(x => x.port === PORT);
  chk('상태 측정 up · VM 소유', s1 && s1.state === 'up' && s1.owner === 'vm', JSON.stringify(s1));
  const reg = JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'servers.json'), 'utf8'));
  chk('등록부 기록', reg.length === 1 && reg[0].port === PORT && reg[0].ready === true);
  const snap = st.snapshot();
  chk('상태 모음: 서버는 실행 중 목록에서 제외', snap.procs.length === 0, JSON.stringify(snap.procs));
  chk('부하 측정값', snap.load.memFreeMB > 0);
  // 창 다시 로드 흉내: 모듈을 새로 읽어도 서버가 살아 있고 다시 붙는지
  svc.dispose(false);
  ({ svc, st } = load()); const got2 = []; svc.subscribe(m => got2.push(m)); svc.init(p);
  await sleep(400);
  chk('다시 붙기', svc.isRunning('TEST SRV'), svc.snapshot('svc').map(x => x.text.trim()).join(' | ').slice(0, 160));
  require('http').get({ host: '127.0.0.1', port: PORT, path: '/after-reload' }, x => x.resume());
  await sleep(1800);
  chk('다시 붙은 뒤 새 로그 수신', got2.some(m => m.type === 'out' && /after-reload/.test(m.text)));
  // 측정이 진행 중일 때 다시 부르면: 그 측정이 끝난 뒤 새로 한 번 잰다(2026-11-19 23:5x 정정 · 종전에는 바로 돌아가 옛 상태가 남음)
  { let firstDone = false; const first = svc.pollOnce().then(() => { firstDone = true; }); await svc.pollOnce(); chk('측정 중 재호출 = 진행 중 측정이 끝난 뒤 새로 잼(옛 상태로 바로 돌아가지 않음)', firstDone === true); await first; }
  const sr = await svc.stop(p, it, 'TEST SRV');
  chk('종료', sr && sr.ok, JSON.stringify(sr));
  const inflight = svc.pollOnce(); await svc.pollOnce(); await inflight; // 진행 중 측정과 겹쳐 불러도 종료 뒤 상태를 잰다
  const s2 = svc.stateList().find(x => x.port === PORT);
  chk('종료 뒤 상태 down', s2 && s2.state === 'down', JSON.stringify(s2));
  chk('종료 뒤 등록 해제', !svc.isRunning('TEST SRV'));
  const be = svc.stateList().find(x => x.port === 8080), fe = svc.stateList().find(x => x.port === 5173);
  console.log('현재 실제 서버 상태(읽기만): BE', be && be.state, be && be.owner, '| FE', fe && fe.state, fe && fe.owner);
  const evs = fs.readFileSync(path.join(p.vibeDir, 'orch', 'events.jsonl'), 'utf8').trim().split('\n').map(x => JSON.parse(x).type);
  console.log('사건:', evs.join(', '));
  svc.dispose(false); st.dispose();
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
