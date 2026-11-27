// 개선안 20261126214604_REVIEW_2: 무거운 점검 도중 VM 파일이 바뀌면 그 회차 S1~S4 실패는 사건(R12)으로 올리지 않고 stale 로 남김
//   임시 폴더에서만 파일을 만든다. 사용: node test/t_orch_selfcheck_stale.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'stale-')); const vibeDir = path.join(root, '.vibe'); const vmd = path.join(root, 'tools', 'VibeManager'); const inst = path.join(root, 'installed');
const mk = (f, s) => { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s, 'utf8'); }; const NL = String.fromCharCode(10);
mk(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false } }));
mk(path.join(vmd, 'good.js'), 'module.exports = 1;' + NL);
mk(path.join(vmd, 'bad.js'), 'function broken( {' + NL);
mk(path.join(vmd, 'package.json'), JSON.stringify({ name: 'x' }));
for (const f of ['good.js', 'bad.js', 'package.json']) mk(path.join(inst, f), fs.readFileSync(path.join(vmd, f), 'utf8'));
const p = { root, vibeDir, extDir: inst };
const watch = require(path.join(dir, 'orch-watch')); const sc = require(path.join(dir, 'orch-selfcheck'));
watch.init(p, {}); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const r12 = () => watch.list().filter(x => x.rule === 'R12').length;
const hist = () => fs.readFileSync(path.join(vibeDir, 'orch', 'selfcheck', 'history.jsonl'), 'utf8').trim().split(NL).map(l => JSON.parse(l));
(async () => {
  // 1) 점검 시작 직후(지문을 잰 뒤) good.js 를 바꿈 → 끝난 뒤 지문 다름
  const pr = sc.run(['S1'], '시험 stale');
  const t = new Date(Date.now() + 5000); fs.writeFileSync(path.join(vmd, 'good.js'), 'module.exports = 2;' + NL); fs.utimesSync(path.join(vmd, 'good.js'), t, t);
  let r = await pr;
  chk('지문 바뀐 회차: S1 실패는 판정됨(bad.js)', r.checks.S1.status === 'fail', JSON.stringify(r.checks.S1.items.map(i => i.key)));
  chk('지문 바뀐 회차: res.stale true · R12 사건 0건', r.stale === true && r12() === 0 && r.newIncidents.length === 0, JSON.stringify({ stale: r.stale, r12: r12() }));
  chk('history.jsonl 에 stale 남김', hist().slice(-1)[0].stale === true);
  // 2) 파일 변경 없는 회차 → 종전대로 사건
  r = await sc.run(['S1'], '시험 같은 지문');
  chk('지문 같은 회차: stale 없음 · R12 사건 1건(종전대로)', !r.stale && r12() === 1 && r.newIncidents.length === 1, JSON.stringify({ stale: r.stale, r12: r12() }));
  chk('history.jsonl 지문 같은 회차 = stale 필드 없음', hist().slice(-1)[0].stale === undefined);
  // 3) gate 는 지문이 바뀐 회차를 최대 2번 다시 돌리고 결과에 stale 을 넘김
  const src = fs.readFileSync(path.join(dir, 'orch-selfcheck.js'), 'utf8');
  chk('gate: stale 이면 최대 2번 다시 잼 · 결과 stale', src.includes('res.stale && k < 2; k++') && src.includes('stale: !!res.stale'));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
