// orch-agent drain 시험(개선안 20261123121302_SELF, 2026-11-23). 실제 Claude 호출 없음
//   agentRules 밖 R12 사건 = '에이전트 담당 아님' 기록 1건(종전 무기록 건너뜀) · 다시 넣어도 1건 · 사건은 열림 유지
//   장부 순환(개선안 20261124093730_SELF, L4 단계 원장 20261124000718_VISION 단계 3): orch-selfcheck.js worklistCycle → orch-worklist.js tick → 진단 1회 → noteDiag
//     2026-11-24 00:00:24 S13|U3|idleInc 4건(20261123_115110_R12_ALL 729분 등, 조치 기록 0건) 재현 = 진단 간격 안에는 넘기지 않고, 간격 60분이 차면 진단 1회와 사건마다 기록 1건, 바로 다음 tick 은 0회
//   need-user 계약(개선안 20261126103110_SELF, L4 단계 원장 20261124000718_VISION 단계 4): S7 need-user 4건 표본 = 담당 사용자 1건, VMO 3건 · tick 이 VMO 담당을 다시 열어 넘김 · 끄기 = 종전
//   사용: node test/t_orch_worklist.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };

if (process.argv[3] === '--cycle') { // orch-selfcheck worklistCycle + 실제 orch-worklist(사건·개선안·에이전트 모듈은 가짜, Claude 호출 없음)
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wl-cycle-')); const vibeDir = path.join(root, '.vibe');
  fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
  const hj = path.join(root, 'tools', 'Harness', 'harness.json'); const setCfg = o => fs.writeFileSync(hj, JSON.stringify({ orch: Object.assign({ worklistDueMin: 60, selfDiagGapMin: 60, agentRules: ['R1'] }, o) }));
  setCfg({});
  const p = { root, vibeDir }; const MIN = 60000; const T = Date.parse('2026-11-24T00:00:24+09:00');
  const AGES = { '20261123_115110_R12_ALL': 729, '20261123_141335_R12_ALL_3': 587, '20261123_161917_R12_ALL': 461, '20261123_171236_R12_ALL': 408 };
  const incs = Object.entries(AGES).map(([id, m]) => ({ id, rule: 'R12', status: 'open', title: `${id} 시험`, ms: T - m * MIN, actions: [] }));
  const watch = { list: () => incs, get: id => incs.find(i => i.id === id) || null, update: (id, patch, act) => { const i = incs.find(x => x.id === id); if (!i) return false; if (patch) Object.assign(i, patch); if (act) i.actions.push(Object.assign({ at: new Date().toISOString() }, act)); return true; } };
  const WL = require(path.join(dir, 'orch-worklist')); WL.init({ paths: () => p, mods: { 'orch-watch': watch, 'orch-improve': { list: () => [] }, 'orch-agent': { status: () => ({ busy: false, on: true }) }, 'orch-ledger': null, 'orch-ladder': null } });
  const SC = require(path.join(dir, 'orch-selfcheck')); SC.init({ paths: () => p, vmDir: dir, timer: false, incidents: false, autoSync: false });
  let calls = []; const diag = async (manual, o) => { calls.push(o && o.incidents); return { ok: true, added: 0, dups: 0 }; };
  const tagged = i => i.actions.filter(a => String(a.what || '').startsWith(WL.TAG)).length;
  (async () => {
    // 1) 마지막 진단 59분 전 = 진단 간격 안 → 넘기지 않음(기다리는 사유 '진단 간격')
    let r = await SC.worklistCycle({ now: T, worklist: WL, diagnose: diag, lastDiagMs: T - 59 * MIN, chainBusy: false });
    chk('cycle: 진단 간격 60분 안 = 진단 0회, 기록 0건', calls.length === 0 && incs.every(i => tagged(i) === 0), JSON.stringify(r.items.map(i => i.wait)));
    chk('cycle: 4건 모두 장부에 담당 자가진단 진단', r.items.filter(i => i.owner === 'selfdiag').length === 4);
    // 2) 1분 뒤 간격 60분 참 → 진단 1회(사건 4건 묶음) + 사건마다 기록 1건
    r = await SC.worklistCycle({ now: T + MIN, worklist: WL, diagnose: diag, lastDiagMs: T - 59 * MIN, chainBusy: false });
    chk('cycle: 간격이 차면 진단 1회에 사건 4건', calls.length === 1 && (calls[0] || []).length === 4, JSON.stringify(calls));
    chk('cycle: 사건마다 조치 기록 1건', r.noted === 4 && incs.every(i => tagged(i) === 1), JSON.stringify(incs.map(i => tagged(i))));
    // 3) 바로 다음 tick(1분 뒤) = 기록 뒤 시한 60분 안 → 진단 0회 추가
    r = await SC.worklistCycle({ now: T + 2 * MIN, worklist: WL, diagnose: diag, lastDiagMs: T + MIN, chainBusy: false });
    chk('cycle: 다음 tick 진단 추가 0회, 기록 1건 유지', calls.length === 1 && incs.every(i => tagged(i) === 1));
    // 4) 진단 보류(에이전트 바쁨) = 기록 남기지 않음
    const inc5 = { id: 'T_busy_R12', rule: 'R12', status: 'open', title: '보류 시험', ms: T, actions: [] }; incs.push(inc5);
    r = await SC.worklistCycle({ now: T + 3 * MIN, worklist: WL, diagnose: async () => ({ busy: true }), lastDiagMs: T - 120 * MIN, chainBusy: false });
    chk('cycle: 진단 보류면 조치 기록 0건', r.noted === 0 && tagged(inc5) === 0 && (r.diagIds || []).join() === 'T_busy_R12', JSON.stringify(r.diagIds));
    // 5) 끄기 = 종전 경로
    setCfg({ worklistEnabled: false }); r = await SC.worklistCycle({ now: T + 200 * MIN, worklist: WL, diagnose: diag, lastDiagMs: 0, chainBusy: false });
    chk('cycle: worklistEnabled false = 장부 순환 안 함', r && r.off === true && calls.length === 1);
    try { SC.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
    console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
  })().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
  return;
}

if (process.argv[3] === '--contract') { // need-user 계약(개선안 20261126103110_SELF, L4 단계 원장 20261124000718_VISION 단계 4). 사건 4건 = 2026-11-24 S7 need-user 4건 표본(원인 글은 사건 파일 발췌)
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wl-contract-')); const vibeDir = path.join(root, '.vibe');
  fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
  const hj = path.join(root, 'tools', 'Harness', 'harness.json'); const setCfg = o => fs.writeFileSync(hj, JSON.stringify({ orch: Object.assign({ worklistDueMin: 60, selfDiagGapMin: 60 }, o) }));
  setCfg({});
  const p = { root, vibeDir }; const MIN = 60000; const T = Date.parse('2026-11-24T00:00:24+09:00');
  const A = (m, what) => ({ at: new Date(T - m * MIN).toISOString(), by: 'VMO', what });
  const incs = [
    { id: '20261120_094734_R5_SCP0028', rule: 'R5', status: 'need-user', ms: T - 86 * 60 * MIN, title: 'R5', actions: [A(86 * 60 - 4, 'Claude 조치 — 사용자 확인 필요 · 원인 engine: VM 감시기 판정 경합. orch-state.js:58 sweep()')], agent: { cause_class: 'engine', cause: 'VM 감시기 판정 경합. orch-state.js:58 sweep() 이 하위 PID 소멸을 보자마자 사라진 실행으로 옮김', next_for_user: '' } },
    { id: '20261120_094237_R3_SSP0005', rule: 'R3', status: 'need-user', ms: T - 86 * 60 * MIN, title: 'R3', actions: [A(86 * 60 - 5, 'Claude 조치 — 사용자 확인 필요 · 원인 engine: tools/VibeManager/orch-watch.js:108')], agent: { cause_class: 'engine', cause: 'R3 기준 통계 키가 화면 구분 없이 단계 키만 써서(tools/VibeManager/orch-watch.js:108)', next_for_user: '' } },
    { id: '20261120_104237_R7_ALL', rule: 'R7', status: 'need-user', ms: T - 85 * 60 * MIN, title: 'R7', actions: [A(85 * 60 - 1, 'Claude 종료 분류 응답 중 종료. stderr 와 로그 확인')] },
    { id: '20261120_201206_R5_SCP0028', rule: 'R5', status: 'need-user', ms: T - 76 * 60 * MIN, title: 'R5', actions: [A(76 * 60 - 8, 'Claude 조치 중단, 사용자 확인 필요 · 원인 engine: diff_verify.py 호출 #47 · 수정 2개 파일 · 허용 범위 밖 파일 변경 1개: tools/VibeManager/CHANGELOG.md')], agent: { cause_class: 'engine', cause: 'diff_verify.py 호출 #47 이 AS-IS MSSQL 세션 55 에서 997초째 끝나지 않음(tools/DbConn/dbconn.py:93)', next_for_user: '실행 중인 SCP0028 CheckList 를 멈추고 다시 실행할지 결정 필요' } },
  ];
  const enq = []; const watch = { list: () => incs, get: id => incs.find(i => i.id === id) || null, update: (id, patch, act) => { const i = incs.find(x => x.id === id); if (!i) return false; if (patch) Object.assign(i, patch); if (act) i.actions.push(Object.assign({ at: new Date(T).toISOString() }, act)); return true; } };
  const WL = require(path.join(dir, 'orch-worklist')); WL.init({ paths: () => p, mods: { 'orch-watch': watch, 'orch-improve': { list: () => [], get: id => (id === '20261120_DONE_INC' ? { id, status: 'applied' } : id === '20261124_X_SELF' ? { id, status: 'pending' } : null) }, 'orch-agent': { status: () => ({ busy: false, on: true, enabled: true }), enqueue: (id, m, extra) => { enq.push({ id, extra }); return true; } }, 'orch-ledger': null, 'orch-ladder': null } });
  const own = w => Object.fromEntries(w.items.map(i => [i.id, i.owner]));
  let w = WL.build({ now: T, lastDiagMs: 0 }); let o = own(w);
  chk('contract: S7 need-user 4건 담당 사용자 또는 VMO', incs.every(i => o[i.id] === 'user' || o[i.id] === 'vmo'), JSON.stringify(o));
  chk('contract: 원인 VM 코드(orch-state.js, orch-watch.js) 2건 = VMO, 다음 행동 fix 개선안 생성', o['20261120_094734_R5_SCP0028'] === 'vmo' && o['20261120_094237_R3_SSP0005'] === 'vmo' && w.items.filter(i => i.next === 'fix 개선안 생성').length === 2);
  chk('contract: 사용자 행동 기록 없음(R7) = VMO, 원인 확인 이어 감', o['20261120_104237_R7_ALL'] === 'vmo' && w.items.find(i => i.id === '20261120_104237_R7_ALL').next === '원인 확인 이어 감');
  chk('contract: 사용자 행동 기록 있음 + 원인 VM 코드 아님 = 사용자, 기다리는 사유에 행동 표시', o['20261120_201206_R5_SCP0028'] === 'user' && /^사용자 확인: 실행 중인 SCP0028/.test(w.items.find(i => i.id === '20261120_201206_R5_SCP0028').wait));
  const r = WL.tick({ now: T, lastDiagMs: 0 });
  chk('contract: tick = VMO 담당 3건 다시 열고 에이전트에 계약 지시와 함께 넘김 · 사용자 담당 1건은 그대로', enq.length === 3 && enq.every(e => e.extra.includes('need-user 계약')) && incs.filter(i => i.status === 'open').length === 3 && incs.find(i => i.id === '20261120_201206_R5_SCP0028').status === 'need-user', JSON.stringify({ enq: enq.map(e => e.id), handed: r.handed }));
  chk('contract: 넘긴 사건마다 장부 기록 1건(다음 행동 포함)', incs.filter(i => i.actions.some(a => /need-user 계약\(.*다음 행동/.test(a.what))).length === 3);
  const pr = { id: 'P_R5', rule: 'R5', status: 'need-user', ms: T, title: 'p', proposal: '20261124_X_SELF', actions: [], agent: { cause_class: 'engine', cause: 'orch-watch.js', next_for_user: '' } }; incs.push(pr);
  w = WL.build({ now: T, lastDiagMs: 0 }); { const it = w.items.find(i => i.id === 'P_R5'); chk('contract: 개선안 붙은 need-user = VMO, 기다리는 사유 개선안 진행', it.owner === 'vmo' && /개선안 20261124_X_SELF 진행/.test(it.wait)); }
  pr.proposal = '20261120_DONE_INC'; w = WL.build({ now: T, lastDiagMs: 0 }); { const it = w.items.find(i => i.id === 'P_R5'); chk('contract: 붙은 개선안 반영 끝(applied) = VMO, 기다리는 사유 없음, 다음 행동 확인 뒤 닫기', it.owner === 'vmo' && !it.wait && it.next === '개선안 결과 확인 뒤 사건 닫기', JSON.stringify(it)); }
  chk('contract: 기록 글의 허용 범위 밖 CHANGELOG.md 부기는 원인으로 읽지 않음(201206 = 사용자)', WL.needUserContract(incs.find(i => i.id === '20261120_201206_R5_SCP0028')).owner === 'user');
  setCfg({ needUserContract: false }); incs.forEach(i => { i.status = 'need-user'; }); o = own(WL.build({ now: T, lastDiagMs: 0 }));
  chk('contract: needUserContract false = 종전(규칙 담당 에이전트, 코드 조치)', o['20261120_094734_R5_SCP0028'] === 'agent' && o['20261120_104237_R7_ALL'] === 'code', JSON.stringify(o));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
}

if (process.argv[3] === '--drain') { // 실제 orch-watch + orch-agent(R12 는 Claude 까지 가지 않음)
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'wl-drain-')); const vibeDir = path.join(root, '.vibe');
  fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: true, agentRules: ['R1'] } }));
  const p = { root, vibeDir, claude: 'none', claudeModel: '' };
  const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
  watch.init(p, { noReloadSweep: true }); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [], restoreDelayMs: 600000 });
  (async () => {
    const inc = watch.raise('R12', { screen: '', sig: 'R12|S13|U13|t', key: 'S13', title: 'VM 자가진단 S13 시험', evidence: {} });
    await new Promise(r => setTimeout(r, 400)); agent.enqueue(inc.id, false); await new Promise(r => setTimeout(r, 400));
    const acts = (watch.get(inc.id) || {}).actions || [];
    chk('drain: agentRules 밖 R12 = 담당 아님 기록 1건(종전 0건)', acts.filter(a => /^에이전트 담당 아님/.test(a.what)).length === 1, JSON.stringify(acts));
    { const h = (watch.get(inc.id) || {}); chk('drain: 담당 밖 R12 = handler by selfdiag, ref 빈 값, progressAt 기록(개선안 20261126183041_SELF)', h.handler && h.handler.by === 'selfdiag' && h.handler.ref === '' && !!h.progressAt, JSON.stringify(h.handler)); }
    agent.enqueue(inc.id, false); await new Promise(r => setTimeout(r, 400));
    chk('drain: 다시 넣어도 담당 아님 기록은 1건 유지', ((watch.get(inc.id) || {}).actions || []).filter(a => /^에이전트 담당 아님/.test(a.what)).length === 1);
    chk('drain: 사건은 열림 유지', (watch.get(inc.id) || {}).status === 'open');
    try { agent.dispose(); } catch { } try { watch.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
    console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
  })().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
  return;
}

// drain 은 자식 프로세스로 돌림(실제 모듈 상태를 이 프로세스와 섞지 않음)
const ch = cp.spawnSync(process.execPath, [__filename, dir, '--drain'], { encoding: 'utf8', timeout: 60000, windowsHide: true });
for (const ln of String(ch.stdout || '').split(/\r?\n/)) if (/^(PASS|FAIL) /.test(ln)) console.log(ln);
chk('drain 자식 시험 통과', ch.status === 0, String(ch.stderr || '').slice(-400));
const cy = cp.spawnSync(process.execPath, [__filename, dir, '--cycle'], { encoding: 'utf8', timeout: 60000, windowsHide: true });
for (const ln of String(cy.stdout || '').split(/\r?\n/)) if (/^(PASS|FAIL) /.test(ln)) console.log(ln);
chk('장부 순환 자식 시험 통과', cy.status === 0, String(cy.stderr || '').slice(-400));
const ct = cp.spawnSync(process.execPath, [__filename, dir, '--contract'], { encoding: 'utf8', timeout: 60000, windowsHide: true });
for (const ln of String(ct.stdout || '').split(/\r?\n/)) if (/^(PASS|FAIL) /.test(ln)) console.log(ln);
chk('need-user 계약 자식 시험 통과', ct.status === 0, String(ct.stderr || '').slice(-400));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
