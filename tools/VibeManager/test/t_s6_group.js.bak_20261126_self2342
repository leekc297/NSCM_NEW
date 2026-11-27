// orch-selfcheck.js S6 미확인 추적 묶음 요약(개선안 20261126180321_VISION)
//   임시 이력 원장(종류 5가지 문장)으로 info.groups 건수, items 첫 줄 요약, 상태 변경 0건을 본다
//   사용: node test/t_s6_group.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const Module = require('module');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 's6grp-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false } }));
fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
const day = n => { const d = new Date(Date.now() - n * 86400000); return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`; };
// 창 로드 기록: 1일 전 항목 뒤(지금 1시간 전)
fs.writeFileSync(path.join(vibeDir, 'orch', 'activations.jsonl'), JSON.stringify({ ms: Date.now() - 3600000 }) + '\n');
const entries = [
  { id: 'c1', date: day(1), time: '09:00', title: '창 로드 뒤 확인', unverified: ['창 다시 로드 뒤 실화면 확인'] }, // loaded
  { id: 'c2', date: day(0), time: '23:59', title: '창 로드 대기', unverified: ['VS Code 화면 확인 필요'] }, // reload(로드 기록이 앞)
  { id: 'c3', date: day(10), time: '10:00', title: '실측', unverified: ['CheckList 실측 미실행'] }, // unrun · 7일 넘음
  { id: 'c4', date: day(9), time: '10:00', title: '승인', unverified: ['사용자 승인 대기'] }, // approval · 7일 넘음
  { id: 'c5', date: day(2), time: '10:00', title: '그 밖', unverified: ['설치 폴더 비교 남음'] }, // etc
];
const histF = path.join(dir, 'orch-history.js'); const fake = new Module(histF); fake.filename = histF; fake.loaded = true;
fake.exports = { stats: () => ({}), list: () => ({ items: entries }) }; require.cache[histF] = fake;
const p = { root, vibeDir, extDir: path.join(root, 'installed') };
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  const unvF = path.join(vibeDir, 'orch', 'selfcheck', 'unverified.json'); const before = fs.existsSync(unvF) ? fs.readFileSync(unvF, 'utf8') : '';
  const res = await sc.run(['S6'], '시험'); const s6 = res.checks.S6;
  const g = s6.info.groups || {};
  chk('groups 종류별 1건씩', g.loaded === 1 && g.reload === 1 && g.unrun === 1 && g.approval === 1 && g.etc === 1, JSON.stringify(g));
  chk('7일 넘은 건수 2', g.over7 === 2, String(g.over7));
  chk('items 첫 줄 = 묶음 요약', s6.items[0] && /^묶음 요약 5건/.test(s6.items[0].what) && /창 로드 뒤 화면 확인만 남음 1건\(일괄 확인 단추로 처리\)/.test(s6.items[0].detail), JSON.stringify(s6.items[0]));
  chk('요약 뒤 열린 행 5줄', s6.items.length === 6, String(s6.items.length));
  chk('count = 열린 행 수', s6.count === 5, String(s6.count));
  const after = fs.existsSync(unvF) ? fs.readFileSync(unvF, 'utf8') : '';
  chk('상태 변경 0건(unverified.json 그대로)', before === after);
  // 순수 함수: 열린 행 0건
  const z = sc._s6Group([]); chk('열린 항목 0건 문장', /열린 항목 0건/.test(z.line), z.line);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e && e.stack); process.exit(1); });
