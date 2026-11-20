// orch-state.js: 시작 전에 파일에 있던 옛 사건을 다시 읽지 않는지, 주인이 죽은 대기를 R4 로 올리지 않는지 확인
//   사용: node test/t_orch_state_old.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'stold-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { waitMaxSec: 1 } }));
const f = path.join(p.vibeDir, 'orch', 'events.jsonl'); const old = Date.now() - 1800000;
const line = o => JSON.stringify(o) + '\n';
// 시작 전에 이미 있던 줄: 살아 있는 프로세스의 대기 1건 + 죽은 프로세스의 대기 1건
fs.writeFileSync(f, line({ at: 'x', ms: old, type: 'wait.start', src: 'py', pid: process.pid, kind: 'dbwin', screen: 'OLD0001', why: 'old alive' }) + line({ at: 'x', ms: old, type: 'wait.start', src: 'py', pid: 999999, kind: 'dbwin', screen: 'OLD0002', why: 'old dead' }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
(async () => {
  await sleep(2600);
  chk('시작 전 줄은 읽지 않음', st.snapshot().waits.length === 0, JSON.stringify(st.snapshot().waits));
  // 시작 뒤에 들어온 줄: 죽은 프로세스의 30분 된 대기(끝 사건 없이 종료) → R4 로 올리지 않는다
  fs.appendFileSync(f, line({ at: 'x', ms: old, type: 'wait.start', src: 'py', pid: 999998, kind: 'dbwin', screen: 'NEW0001', why: 'dead waiter' }));
  // 살아 있는 프로세스의 대기 → R4
  fs.appendFileSync(f, line({ at: 'x', ms: old, type: 'wait.start', src: 'py', pid: process.pid, kind: 'admit', screen: 'NEW0002', why: 'alive waiter' }));
  await sleep(2600); w.tick();
  chk('죽은 프로세스의 대기 = R4 아님', !got.some(x => x.rule === 'R4' && x.screen === 'NEW0001'), got.map(x => x.rule + ':' + x.screen).join(','));
  chk('살아 있는 프로세스의 대기 = R4', got.some(x => x.rule === 'R4' && x.screen === 'NEW0002'));
  { const g = fs.readFileSync(f, 'utf8').trim().split(String.fromCharCode(10)).map(l => JSON.parse(l)).filter(e => e.type === 'wait.gone');
    chk('사라진 대기 = wait.gone 사건 1건(종류 · 화면 · PID · 경과 초)', g.length === 1 && g[0].kind === 'dbwin' && g[0].screen === 'NEW0001' && g[0].waiter_pid === 999998 && g[0].sec_wait >= 1790, JSON.stringify(g)); }
  chk('상황판 대기 목록에 죽은 프로세스 없음', st.snapshot().waits.every(x => x.screen !== 'NEW0001'), JSON.stringify(st.snapshot().waits.map(x => x.screen)));
  w.dispose(); st.dispose(); await sleep(100); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
