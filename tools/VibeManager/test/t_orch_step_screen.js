// 개선안 20261120094734_INC: R3 단계 지연 통계를 단계|화면 키로 나눔
//   SSP0005 표본 3개(9119/9595/9394초) 뒤 12408초 = R3 없음, 20000초 = R3 · 다른 화면 표본은 섞이지 않음
//   사용: node test/t_orch_step_screen.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'stepscr-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
w.init(p, { noReloadSweep: true }); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
let run = 0;
const step = (screen, sec) => w.onEvent({ ms: Date.now(), type: 'step.end', wb: `J${++run}:${screen}`, runId: `R${run}`, no: 1, screen, status: 'OK', name: '1. CheckList 수행', task: 'S8.checklistRun', ms_run: sec * 1000, chainLabel: 'CheckList', actor: 'script' });
const r3 = () => got.filter(x => x.rule === 'R3');
// 다른 화면 짧은 표본 3개(종전 키였다면 SSP0005 의 기준을 끌어내림)
step('SCP0028', 5767); step('SSP0014', 6058); step('SCP0005', 8206);
for (const s of [9119, 9595, 9394]) step('SSP0005', s);
chk('표본 쌓는 동안 R3 없음', r3().length === 0, JSON.stringify(r3().map(x => x.title)));
step('SSP0005', 12408);
chk('SSP0005 12408초 = R3 없음', r3().length === 0, JSON.stringify(r3().map(x => x.title)));
step('SSP0005', 20000);
chk('SSP0005 20000초 = R3 1건', r3().length === 1 && r3()[0].screen === 'SSP0005', JSON.stringify(r3().map(x => [x.screen, x.sig, x.title])));
chk('R3 서명 = 단계|화면', r3().length === 1 && r3()[0].sig === 'R3|S8.checklistRun|SSP0005', r3()[0] && r3()[0].sig);
const stats = JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'step_stats.json'), 'utf8'));
chk('통계 키 화면별 분리', Array.isArray(stats['S8.checklistRun|SSP0005']) && Array.isArray(stats['S8.checklistRun|SCP0028']) && !stats['S8.checklistRun'], JSON.stringify(Object.keys(stats)));
// 개선안 20261122130655_REVIEW_3: 6단계 문서 생성(--docs) 표본을 1단계 측정 표본과 나눔
//   통계를 비운 뒤 SCP0028 측정 3953초 3건 + --docs 200초 1건 → 측정 키 표본 3개, 문서 생성 키 표본 1개, R3 0건
fs.writeFileSync(path.join(p.vibeDir, 'orch', 'step_stats.json'), '{}');
const r3Before = r3().length;
for (const s of [3953, 3953, 3953]) step('SCP0028', s);
w.onEvent({ ms: Date.now(), type: 'step.end', wb: `J${++run}:SCP0028`, runId: `R${run}`, no: 18, screen: 'SCP0028', status: 'OK', name: '6. 문서 생성', task: 'S8.checklistRun', stepKey: 'S8.checklistRun:--docs', ms_run: 200 * 1000, chainLabel: 'CheckList', actor: 'script' });
const st2 = JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'step_stats.json'), 'utf8'));
const scp = st2['S8.checklistRun|SCP0028'] || [], docs = st2['S8.checklistRun:--docs|SCP0028'] || [];
chk('측정 키 표본에 문서 생성 200초 없음', scp.length === 3 && scp.every(x => x === 3953000), JSON.stringify(scp));
chk('문서 생성 키 표본 1개', docs.length === 1 && docs[0] === 200000, JSON.stringify(docs));
chk('--docs 추가 뒤 R3 0건', r3().length === r3Before, JSON.stringify(r3().slice(r3Before).map(x => x.title)));
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
