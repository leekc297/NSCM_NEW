// 개선안 20261120005532_INC: VM 시작 전 실행이 같은 화면·label 로 다시 실행됐으면 사라진 실행(R5) 사건 대신 proc.gone 기록만 · proc.start 화면 ID 빈 값 = 명령 끝 화면 ID
//   사용: node test/t_orch_watch_gone.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wgone-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch')); const ev = require(path.join(dir, 'orch-events'));
w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
const emitted = []; ev.on(e => { if (e && e.type === 'proc.gone') emitted.push(e); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const DEAD = 999961; const DEAD2 = 999953; const now = Date.now(); const label = 'CheckList 수행 · 🔎 CheckList 체인 1단계';
// events.jsonl:49 와 같은 모양(screen 빈 값 · 명령 끝 SSP0005) · 주인 PID 없음 · 4시간 전
st.apply({ ms: now - 4 * 3600000, type: 'proc.start', src: 'vm', pid: DEAD, cmd: 'python C:\\Projects\\NSCM\\tools\\Harness/verify/checklist_run.py SSP0005', wb: 4, screen: '', label, procId: 6, childPid: DEAD + 1, log: 'a.log' });
// 같은 화면 다시 실행(14분 전) · 끝(1분 전)
st.apply({ ms: now - 14 * 60000, type: 'proc.start', src: 'vm', pid: DEAD2, cmd: 'python C:\\Projects\\NSCM\\tools\\Harness/verify/checklist_run.py SSP0005', wb: 4, screen: 'SSP0005', label, procId: 2, childPid: DEAD2 + 1, log: 'b.log' });
st.apply({ ms: now - 60000, type: 'proc.end', src: 'vm', pid: DEAD2, wb: 4, screen: 'SSP0005', label, procId: 2, exit: 0 });
chk('명령 끝 화면 ID 추출', st.screenFromCmd('python x/checklist_run.py SSP0005') === 'SSP0005' && st.screenFromCmd('python x/run.py') === '');
w.tick();
const r5 = got.filter(x => x.rule === 'R5');
chk('R5 사건 0건(알림 포함)', r5.length === 0, JSON.stringify(got.map(x => [x.rule, x.title])));
chk('proc.gone 1건', emitted.length === 1, JSON.stringify(emitted));
chk("proc.gone screen 'SSP0005'", emitted[0] && emitted[0].screen === 'SSP0005', emitted[0] && emitted[0].screen);
// 대조: 더 늦은 실행이 없는 지난 실행은 종전대로 알림(창 다시 로드로 끊긴 실행)
st.apply({ ms: now - 3 * 3600000, type: 'proc.start', src: 'vm', pid: DEAD, cmd: 'python x/checklist_run.py SCP0028', wb: 5, screen: '', label, procId: 7, childPid: DEAD + 2, log: 'c.log' });
w.tick();
chk('더 늦은 실행 없음 = 종전 알림 1건 · proc.gone 추가 없음', got.filter(x => x.rule === 'R5' && x.notice).length === 1 && emitted.length === 1, JSON.stringify(got.map(x => [x.rule, x.title])));
// 개선안 20261120103659_SELF: 사라진 대기의 대기 시간 = 마지막 생존 확인 시각까지(VM 이 꺼져 있던 시간을 더하지 않음)
(async () => {
  ev.init(p.vibeDir); const wg = []; ev.on(e => { if (e && e.type === 'wait.gone') wg.push(e); });
  const child = require('child_process').spawn(process.execPath, ['-e', 'setTimeout(()=>{},60000)'], { stdio: 'ignore', windowsHide: true });
  const t0 = Date.now() - 600000;
  st.apply({ ms: t0, type: 'wait.start', src: 'py', pid: child.pid, kind: 'admit', screen: 'TST0101', why: 'alive then gone' });
  w.tick(); const seenAt = Date.now();
  await new Promise(r => { child.once('exit', r); child.kill(); });
  await new Promise(r => setTimeout(r, 1500));
  w.tick();
  const a = wg.find(e => e.screen === 'TST0101');
  chk('살아 있다 사라진 대기 sec_wait = 마지막 생존 확인까지', a && a.sec_wait >= 599 && a.sec_wait <= Math.round((seenAt - t0) / 1000) + 1 && a.sec_upper >= a.sec_wait + 1 && a.seen_ms && a.seen_ms <= seenAt, JSON.stringify(a));
  // VM 재시작 직후 이미 없는 대기 = 살아 있는 것을 못 봤으므로 sec_wait null · 상한만 남김
  st.apply({ ms: Date.now() - 7200000, type: 'wait.start', src: 'py', pid: 999943, kind: 'dbwin', screen: 'TST0102', why: 'dead before restart' });
  w.tick();
  const b = wg.find(e => e.screen === 'TST0102');
  chk('재시작 직후 이미 없는 대기 sec_wait null · sec_upper 7200 근처', b && b.sec_wait === null && b.seen_ms === null && b.sec_upper >= 7199, JSON.stringify(b));
  // 집계: goneSec 는 sec_wait 만 더하고 null 은 goneUnknown 으로 센다
  const agent = require(path.join(dir, 'orch-agent')); const im = require(path.join(dir, 'orch-improve')); agent.paths = () => p;
  const d = im.digest(1); const wd = d.waits.find(x => x.kind === 'dbwin'); const wa = d.waits.find(x => x.kind === 'admit');
  chk('집계 dbwin gone 1 · goneSec 0 · goneUnknown 1', wd && wd.gone === 1 && wd.goneSec === 0 && wd.goneUnknown === 1, JSON.stringify(wd));
  chk('집계 admit gone 1 · goneSec = sec_wait · goneUnknown 0', wa && wa.gone === 1 && wa.goneSec === a.sec_wait && wa.goneUnknown === 0, JSON.stringify(wa));
  w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
