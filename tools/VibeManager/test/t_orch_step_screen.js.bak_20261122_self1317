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
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
