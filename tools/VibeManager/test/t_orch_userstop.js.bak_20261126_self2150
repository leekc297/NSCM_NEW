// 화면 단위 사용자 중지(2026-11-20): 에이전트 대화가 중지를 지시받은 화면의 실행 끝은 실패 사건(R1 · R2 · R11)을 만들지 않음 · 다른 화면과 기간 지난 뒤는 종전대로 사건
//   사용: node test/t_orch_userstop.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ustop-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const now = Date.now();
const end = (screen, wb) => { w.onEvent({ ms: Date.now(), type: 'step.end', wb, screen, status: 'FAIL', name: '1. CheckList 수행', task: 'S8.checklistRun', exit: 1, chainLabel: 'CheckList' }); w.onEvent({ ms: Date.now(), type: 'chain.end', wb, screen, ok: false, chain: 'checklist', chainLabel: 'CheckList', claudeRan: 0, scriptRan: 1, failNo: 1 }); };
w.markUserStop(['scp0028', 'SSP0014'], now + 60000, '에이전트 대화');
chk('표시한 화면 = 사용자 중지 · 다른 화면 아님', w.userStopped('J1:SCP0028', 'SCP0028') && w.userStopped('', 'ssp0014') && !w.userStopped('J1:SCP0005', 'SCP0005'));
end('SCP0028', 'J1:SCP0028'); end('SSP0014', 'J1:SSP0014');
chk('중지 지시 화면의 실패 끝 = 사건 0건', got.length === 0, JSON.stringify(got.map(x => [x.rule, x.screen])));
end('SCP0005', 'J1:SCP0005');
chk('다른 화면 실패 = 종전대로 사건', got.some(x => x.screen === 'SCP0005'), JSON.stringify(got.map(x => [x.rule, x.screen])));
w.markUserStop(['SCP0028'], now - 1, '지난 표시'); got.length = 0; end('SCP0028', 'J2:SCP0028');
chk('기간 지난 뒤 = 종전대로 사건', got.some(x => x.screen === 'SCP0028'), JSON.stringify(got.map(x => [x.rule, x.screen])));
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
