// 창 다시 로드로 끊긴 실행 = 알림 1건(사건 아님 · 에이전트 조치 없음) · 지금 VMO 가 띄운 실행이 끝 기록 없이 사라지면 종전대로 R5 사건(2026-11-20)
//   사용: node test/t_orch_reloadcut.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'rcut-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const DEAD = 999971; const now = Date.now();
// 이전 확장 호스트(DEAD)가 띄운 체인 2개 · 프로세스 1개 = 창 로드로 끊김
const EV = [
  { ms: now - 600000, type: 'chain.start', src: 'vm', pid: DEAD, wb: 1, screen: 'SCP0005', runId: 'r1', chainLabel: 'CheckList', steps: 3 },
  { ms: now - 500000, type: 'chain.start', src: 'vm', pid: DEAD, wb: 2, screen: 'SSP0014', runId: 'r2', chainLabel: 'CheckList', steps: 3 },
  { ms: now - 400000, type: 'proc.start', src: 'vm', pid: DEAD, wb: 3, screen: 'DMF0042', label: 'S8.verify', procId: 7, childPid: DEAD + 1, log: 'x.log' },
];
for (const e of EV) st.apply(Object.assign({}, e));
w.tick();
const notes = got.filter(x => x.notice); const r5 = got.filter(x => x.rule === 'R5' && !x.notice);
chk('끊긴 실행 3건 = 알림 1건(해결 상태) · R5 사건 0건', notes.length === 1 && notes[0].status === 'resolved' && /끊긴 실행 3건/.test(notes[0].title) && r5.length === 0, JSON.stringify(got.map(x => [x.rule, x.status, x.title])));
chk('알림 내용에 화면 3개', ['SCP0005', 'SSP0014', 'DMF0042'].every(s => notes[0].detail.includes(s)), notes[0] && notes[0].detail);
// 개선안 20261126214604_REVIEW: 다음 VM 시작 때 같은 events(시작 기록 + 알림 때 남긴 run.cut)를 다시 재생해도 알림은 1건
{
  const evFile = path.join(p.vibeDir, 'orch', 'events.jsonl'); let lines = []; try { lines = fs.readFileSync(evFile, 'utf8').split(/\r?\n/).filter(Boolean).map(l => JSON.parse(l)); } catch { lines = []; }
  const cuts = lines.filter(e => e.type === 'run.cut'); const replay = EV.concat(cuts);
  for (const e of replay) st.apply(Object.assign({}, e)); w.tick();
  const n2 = got.filter(x => x.notice).length;
  chk('같은 events 를 두 번 재생해도 알림 1건', cuts.length === 1 && cuts[0].runs.length === 3 && n2 === 1, `run.cut ${cuts.length}줄 · 항목 ${cuts[0] ? cuts[0].runs.length : 0} · 알림 ${n2}건`);
}
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
