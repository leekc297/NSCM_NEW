// 재개 때 끊긴 실행의 남은 프로세스 정리 시험(2026-11-20 19:08 실측: 다시 로드 뒤 run_verify·Playwright 고아가 남아 재개 실행이 잠금 대기)
//   사용: node test/t_reap_orphans.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'reap-')); const p = { root, vibeDir: path.join(root, '.vibe') };
const wb = require(path.join(dir, 'workbench'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const alive = pid => { try { process.kill(pid, 0); return true; } catch (e) { return e.code === 'EPERM'; } };
const sleep = t => new Promise(r => setTimeout(r, t));
(async () => {
  if (process.platform !== 'win32') { console.log('SKIP win32 전용'); process.exit(0); }
  // 단계 프로세스(cmd) → node 자식 → node 손자. cmd 를 먼저 끝내 고아를 만든다(다시 로드로 VM·cmd 가 사라진 상태)
  const gpid = path.join(root, 'g.pid');
  const kid = `const cp=require('child_process');const g=cp.spawn(process.execPath,['-e','setTimeout(()=>{},60000)'],{stdio:'ignore'});require('fs').writeFileSync(${JSON.stringify(gpid)},String(process.pid)+' '+g.pid);setTimeout(()=>{},60000);`;
  const t0 = Date.now(); const c = cp.spawn(`"${process.execPath}" -e "${kid.replace(/"/g, '\\"')}"`, { shell: true, stdio: 'ignore' });
  for (let i = 0; i < 50 && !fs.existsSync(gpid); i++) await sleep(100);
  const [kpid, gp] = fs.readFileSync(gpid, 'utf8').trim().split(' ').map(Number);
  chk('준비: 자식·손자 실행 중', alive(kpid) && alive(gp), `${kpid} ${gp}`);
  cp.spawnSync('taskkill', ['/PID', String(c.pid), '/F']); await sleep(500); // cmd 만 끝냄(트리 아님)
  chk('준비: cmd 없음 · 자식 고아로 남음', !alive(c.pid) && alive(kpid) && alive(gp));
  // 기록 주인 VM 이 살아 있으면(다른 창이 돌리는 중) 건드리지 않음
  const live = wb._reapOrphans(p, { runId: 'T_1', screen: 'TST0001', ownerPid: process.ppid || 4, pids: [{ pid: c.pid, ms: t0 }] });
  chk('주인 VM 살아 있음 = 정리 안 함', live.length === 0 && alive(kpid));
  const r = wb._reapOrphans(p, { runId: 'T_1', screen: 'TST0001', ownerPid: 999999, pids: [{ pid: c.pid, ms: t0 }] });
  await sleep(500);
  chk('주인 VM 없음 = 남은 자식·손자 종료', !alive(kpid) && !alive(gp), JSON.stringify(r));
  chk('정리 결과 2개 이상(node)', r.length >= 2 && r.every(x => /node/i.test(x.name)), JSON.stringify(r));
  const ev = fs.readFileSync(path.join(p.vibeDir, 'orch', 'events.jsonl'), 'utf8');
  chk('사건 proc.reap 기록', /"type":"proc.reap"/.test(ev));
  // 기록 시각보다 먼저 생긴 프로세스(PID 재사용)는 건드리지 않음
  const old = cp.spawn(process.execPath, ['-e', 'setTimeout(()=>{},20000)'], { stdio: 'ignore' }); await sleep(300);
  const r2 = wb._reapOrphans(p, { runId: 'T_2', ownerPid: 999999, pids: [{ pid: old.pid, ms: Date.now() + 60000 }] });
  chk('생성 시각이 다르면(PID 재사용) 정리 안 함', r2.length === 0 && alive(old.pid));
  try { old.kill(); } catch { }
  chk('pids 없는 기록 = 정리 안 함', wb._reapOrphans(p, { runId: 'T_3', ownerPid: 999999 }).length === 0);
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
