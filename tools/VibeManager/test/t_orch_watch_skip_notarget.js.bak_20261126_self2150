// 개선안 20261120005146_INC: CheckList 실패 상세에 'TO-BE 화면 미개발이면 CheckList 대상 아님'이 있으면 사건(R1 · R2)을 만들지 않음 · 다른 상세는 종전대로 R1 다음 R2
//   사용: node test/t_orch_watch_skip_notarget.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'notgt-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
w.init(p, { noReloadSweep: true }); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const NOTGT = "[tobe_index] TO-BE 화면 소스·인덱스 FAIL: nscm-fe 에서 SCP9999 를 쓰는 화면 폴더를 찾지 못함 — TO-BE 화면 미개발이면 CheckList 대상 아님";
let run = 0;
const fail = (screen, why) => w.onEvent({ ms: Date.now(), type: 'step.end', wb: `J${++run}:${screen}`, runId: `R${run}`, no: 1, screen, status: 'FAIL', name: '1. CheckList 수행', task: 'S8.checklistRun', exit: 6, chainLabel: 'CheckList', why });
fail('SCP9999', NOTGT); fail('SCP9999', NOTGT);
chk('대상 아님 상세 2회 = 사건 0건', got.length === 0, JSON.stringify(got.map(x => [x.rule, x.screen])));
chk('대상 아님 상세 = 사건 파일 0건', w.list(50).length === 0, String(w.list(50).length));
const hist = (() => { try { return JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'sig_history.json'), 'utf8')); } catch { return {}; } })();
chk('대상 아님 상세 = 반복 집계에 넣지 않음', !Object.values(hist).some(a => a.some(x => x.screen === 'SCP9999')), JSON.stringify(hist));
fail('SCP0005', '로그인 실패 exit 6'); fail('SCP0005', '로그인 실패 exit 6');
chk('다른 상세 = R1 다음 R2', got.length === 2 && got[0].rule === 'R1' && got[1].rule === 'R2', JSON.stringify(got.map(x => [x.rule, x.screen])));
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
