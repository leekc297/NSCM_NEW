// 큰 그림 점검(Overall Review · orch-vision.js, 2026-11-20) 시험
//   주기 = 환경설정 일수(기본 1) · 적용 여부(미적용 = 주기 점검 안 함, 단추 점검은 됨) · 결과 → 개선안 source vision · 자동 반영 대상 아님(visionAutoApply false)
//   사용: node test/t_orch_vision.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'vision-')); const vibeDir = path.join(root, '.vibe'); const mem = path.join(root, 'mem');
for (const d of [path.join(vibeDir, 'orch'), path.join(root, 'tools', 'Harness'), mem]) fs.mkdirSync(d, { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
fs.writeFileSync(path.join(mem, 'feedback_vmo_self_heal_restart_20261120.md'), 'VMO 목적 = 화면이 안 열리면 스스로 원인·해결·다시 실행');
fs.writeFileSync(path.join(mem, 'feedback_other.md'), '관계없는 메모리');
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const added = []; let setting = { visionEnabled: true, visionEveryDays: 1 }; let prompt = '';
const agent = { withLock: async (id, fn) => fn(), say: () => { }, lastJsonBlock: t => JSON.parse(t), runClaude: async p => { prompt = p; return { ok: true, code: 0, log: 'v.log', text: JSON.stringify({ summary: '요약', purposes: [{ purpose: '스스로 복구', verdict: '맞음', evidence: 'R13' }, { purpose: 'CheckList 30분', verdict: '어긋남', evidence: '136분' }], proposals: [{ title: '안1', evidence: '근거', targets: ['tools/Harness/verify/run_verify.py'] }, { title: '근거 없는 안' }] }) }; } };
const mods = { 'orch-agent': agent, 'orch-improve': { list: () => [], add: (o, src) => { added.push({ o, src }); return { id: 'V' + added.length }; }, digest: () => ({ events: 1 }) }, 'orch-selfcheck': { result: () => ({ checks: {} }) }, 'orch-watch': { list: () => [] }, 'orch-usercheck': { pendingPrompts: () => [] } };
const v = require(path.join(dir, 'orch-vision'));
v.init({ paths: () => ({ root, vibeDir }), vmDir: dir, memDir: mem, planFile: path.join(root, 'none.md'), mods, noTimer: true, settings: () => setting });
(async () => {
  chk('이력 없음 + 적용 = 점검 대상', v.due());
  setting = { visionEnabled: false, visionEveryDays: 1 }; chk('미적용 = 주기 점검 안 함', !v.due());
  const r0 = await v.run(false); chk('미적용 + 주기 실행 = 건너뜀', r0.skipped === '꺼짐', JSON.stringify(r0));
  const r = await v.run(true); chk('미적용이어도 단추 점검은 실행', r.ok && r.added === 1, JSON.stringify(r));
  chk('근거 없는 안은 등록 안 함 · 출처 vision', added.length === 1 && added[0].src === 'vision');
  chk('프롬프트에 목적 메모리(feedback_vmo_*) 포함, 다른 메모리 제외', /스스로 원인/.test(prompt) && !/관계없는 메모리/.test(prompt));
  chk('프롬프트에 사용자 지적 원장 포함', /U9 .*중지 뒤에도/.test(prompt));
  const m = v.meta(); chk('결과 기록: 목적 2건 · 어긋남 1', m.purposes.length === 2 && /어긋남 1/.test(m.lastResult), m.lastResult);
  chk('미적용이면 다음 점검 없음', m.enabled === false && !m.nextAt);
  setting = { visionEnabled: true, visionEveryDays: 2 }; chk('적용 + 방금 점검 = 대상 아님', !v.due());
  const mf = path.join(vibeDir, 'orch', 'vision', 'meta.json'); const mj = JSON.parse(fs.readFileSync(mf, 'utf8'));
  mj.lastMs = Date.now() - 1.5 * 86400000; fs.writeFileSync(mf, JSON.stringify(mj)); chk('2일 주기 · 1.5일 지남 = 대상 아님', !v.due());
  mj.lastMs = Date.now() - 2.1 * 86400000; fs.writeFileSync(mf, JSON.stringify(mj)); chk('2일 주기 · 2.1일 지남 = 대상', v.due());
  setting = { visionEnabled: true, visionEveryDays: 0 }; chk('일수 0 이하 = 1일로 봄', v.meta().everyDays === 1);
  // 자동 반영 대상 판정(orch-selfcheck.autoEligible)
  const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => ({ root, vibeDir }), vmDir: dir, timer: false, incidents: false });
  const pr = { source: 'vision', targets: ['tools/VibeManager/orch-watch.js'], title: '안' };
  chk('vision 안 = 자동 반영 대상 아님(visionAutoApply false)', sc.autoEligible(pr).ok === false && /승인/.test(sc.autoEligible(pr).why));
  // 2026-11-20 사용자 지시 '버그성이나 시스템 관련 항목은 권장안으로 · 사용자승인은 VM 근간 로직 변경 때만': impact fix = 자동, core = 승인
  chk('vision 안 impact fix = 권장안으로 자동 반영', sc.autoEligible(Object.assign({}, pr, { impact: 'fix' })).ok === true);
  chk('vision 안 impact core = 사용자 승인', sc.autoEligible(Object.assign({}, pr, { impact: 'core' })).ok === false && /근간/.test(sc.autoEligible(Object.assign({}, pr, { impact: 'core' })).why));
  chk('self 안이라도 impact core = 사용자 승인', sc.autoEligible({ source: 'self', self: true, impact: 'core', targets: ['tools/VibeManager/orch-watch.js'], title: '안' }).ok === false);
  chk('impact fix 라도 자동 범위 밖(FE) = 사용자 승인', sc.autoEligible({ source: 'vision', impact: 'fix', targets: ['nscm-fe/apps/web/src/a.tsx'], title: '안' }).ok === false);
  const imp = require(path.join(dir, 'orch-improve'));
  chk('지시문 구분 기준에 core·fix 정의', /core = VM 근간 로직 변경/.test(imp.IMPACT_RULE) && /fix = 결함 수정/.test(imp.IMPACT_RULE));
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { visionAutoApply: true } }));
  chk('visionAutoApply true 면 VM 코드 대상 자동 반영 가능', sc.autoEligible(pr).ok === true);
  chk('같은 대상 self 안 = 종전대로 자동', sc.autoEligible(Object.assign({}, pr, { source: 'self' })).ok === true);
  // 개선안 20261126155824_SELF(L4 원장 20261125000242_VISION 단계 2): CheckList 시간 목적 = 효력 뒤 1판 실측으로만 판정(checklistEffect · 지시문 1-2)
  { const E = Date.parse('2026-11-23T15:58:21+09:00'); const M = 60000; const P0 = { id: '20261123000419_VISION', status: 'applied', appliedMs: E, needsReload: false };
    const imp2 = Object.assign({}, mods['orch-improve'], { get: id => (id === P0.id ? P0 : null), effectiveMsOf: p => p.appliedMs });
    let evs = [ // events.jsonl:2001 형식 = 효력 전 SCP0028 309.5분 체인(runId 없음)
      { type: 'chain.end', chain: 'checklist', chainLabel: 'CheckList', screen: 'SCP0028', ms: E - 3600000, ms_run: 18571542 }];
    const reinit = () => v.init({ paths: () => ({ root, vibeDir }), vmDir: dir, memDir: mem, planFile: path.join(root, 'none.md'), mods: Object.assign({}, mods, { 'orch-improve': imp2 }), noTimer: true, settings: () => setting, events: () => evs });
    reinit(); const e0 = v.checklistEffect({}); const p1 = v.buildPrompt({ visionMaxPerRun: 8 });
    chk('효력 전 표본만 = runsAfter 0건 · 실측 대기 · effAt 있음', e0.runsAfter.length === 0 && /실측 대기/.test(e0.note) && /^2026-11-23T15:58/.test(e0.effAt) && e0.targetMin === 30, JSON.stringify(e0));
    chk('지시문: 1-2 규칙 줄 · 입력 필드 checklistEffect, runsAfter', /1-2\. 목적 "CheckList 화면 1개 10분, 길어야 30분"/.test(p1) && /"checklistEffect"/.test(p1) && /"runsAfter"/.test(p1));
    evs = evs.concat([
      { type: 'step.end', runId: 'r1', status: 'OK', stepKey: 'S8.checklistRun:--docs', ms: E + 25 * M }, { type: 'chain.end', chain: 'checklist', screen: 'SSP0020', runId: 'r1', ms: E + 50 * M, ms_run: 50 * M },
      { type: 'step.end', runId: 'r2', status: 'FAIL', stepKey: 'S8.checklistRun:--docs', ms: E + 75 * M }, { type: 'step.end', runId: 'r2', status: 'OK', name: '문서 작성', task: 'S8.checklistRun', ms: E + 140 * M }, { type: 'chain.end', chainLabel: 'CheckList 다시', screen: 'SCP0104', runId: 'r2', ms: E + 160 * M, ms_run: 100 * M },
      { type: 'chain.end', chain: 'usermanual', screen: 'X', runId: 'r3', ms: E + 170 * M, ms_run: 5 * M },
      { type: 'chain.end', chain: 'checklist', screen: 'DMF0005', ms: E + 200 * M, ms_run: 20 * M }]);
    const e1 = v.checklistEffect({ checklistTargetMin: 30 }); const by = Object.fromEntries(e1.runsAfter.map(r => [r.screen, r]));
    chk('효력 뒤 CheckList 3건만(효력 전, 다른 체인 제외)', e1.runsAfter.length === 3 && !by.SCP0028 && !by.X, JSON.stringify(e1.runsAfter));
    chk('1판 소요: r1 25분 · r2 = 첫 성공 문서 단계 80분(실패 단계 제외) · runId 없음 = null · chainMin', by.SSP0020.firstDocMin === 25 && by.SSP0020.chainMin === 50 && by.SCP0104.firstDocMin === 80 && by.DMF0005.firstDocMin === null && by.DMF0005.chainMin === 20 && !e1.note, JSON.stringify(by));
    P0.status = 'pending'; delete P0.appliedMs; const e2 = v.checklistEffect({});
    chk('기준 안 효력 없음 = effAt 빈 값 · runsAfter 0건 · 사유', e2.effAt === '' && e2.runsAfter.length === 0 && /상태 pending/.test(e2.note), JSON.stringify(e2));
    chk('기준 안 없음 = 사유', /기준 개선안 없음/.test(v.checklistEffect({ checklistEffectProposal: '20990101000000_VISION' }).note));
    // 개선안 20261126173842_SELF(단계 6): 1판 단계별 분 · 단계 밖 분 · 동시 실행 · 예산 초과 단계. 표본 = events.jsonl:4301,4309 SCP0028_1795535760315(11-25 00:56 시작, 1판 79.8분) + run_timing 측정 기록(단계 밖 37.9분) + 문서 기록(3.0분)
    P0.status = 'applied'; P0.appliedMs = E; const S0 = Date.parse('2026-11-25T00:56:00+09:00'); const fd = Math.round(79.8 * M);
    const rt = path.join(root, 'Doc', 'verify', 'SCP0028'); fs.mkdirSync(rt, { recursive: true });
    fs.writeFileSync(path.join(rt, 'run_timing.json'), JSON.stringify([{ run_at: '2026-11-21 01:52:30', wall_min: 3.3, stage_min: { docs: 3.1 } }, { run_at: '2026-11-25 00:56:02', wall_min: 74.5, unattributed_min: 37.9, stage_min: { pre: 2.6, facts: 4.1, static: 1.1, eg: 6.1, diff: 16.0, post: 6.7 } }, { run_at: '2026-11-25 02:12:40', wall_min: 3.0, unattributed_min: 1.1, stage_min: { docs: 1.9 } }]));
    evs = [{ type: 'step.end', runId: 'SCP0028_1795535760315', status: 'OK', stepKey: 'checklist:2:--docs', ms: S0 + fd }, { type: 'chain.end', chain: 'checklist', screen: 'SCP0028', runId: 'SCP0028_1795535760315', ms: S0 + 143 * M, ms_run: 143 * M },
      { type: 'chain.end', chain: 'checklist', screen: 'SCP0005', runId: 'x1', ms: S0 + 140 * M, ms_run: 140 * M }, { type: 'chain.end', chain: 'checklist', screen: 'SSP0014', runId: 'x2', ms: S0 + 141 * M, ms_run: 141 * M }, { type: 'chain.end', chain: 'checklist', screen: 'X', runId: 'x3', ms: S0 - 10 * M, ms_run: 5 * M }];
    const e3 = v.checklistEffect({ checklistStageBudget: { diff: 8, eg: 8, post: 10 } }); const r28 = e3.runsAfter.find(r => r.screen === 'SCP0028');
    chk('단계 6: 1판 79.8분 · 단계 밖 37.9분 · 문서 기록 3.0분은 1판 길이로 읽지 않음 · 단계 2건 기록', r28 && r28.firstDocMin === 79.8 && r28.outsideMin === 37.9 && r28.docsMin === 3 && r28.timingRecords === 2 && r28.stageMin.diff === 16 && r28.stageMin.docs === 1.9 && !('docs' in r28.stageMin && r28.stageMin.docs === 3.1), JSON.stringify(r28));
    chk('단계 6: 단계 밖 비율 47.5% · 동시 실행 2건(구간 밖 체인 제외) · 예산 초과 단계 diff', r28.outsidePct === 47.5 && r28.concurrent === 2 && r28.overBudget.join() === 'diff' && e3.budget.diff === 8, JSON.stringify({ pct: r28.outsidePct, con: r28.concurrent, ob: r28.overBudget }));
    chk('단계 6: 예산 없음 = overBudget 빈 목록 · budget null', v.checklistEffect({}).runsAfter.find(r => r.screen === 'SCP0028').overBudget.length === 0 && v.checklistEffect({}).budget === null);
    chk('단계 6: 지시문 1-2 에 단계 밖 비율 10 기준과 대체안 조건', /outsidePct\(1판 구간 중 단계 밖 시간 비율\)가 10 보다 크면/.test(v.buildPrompt({ visionMaxPerRun: 8 })) && /ledger_diff\.py 차이 0건/.test(v.buildPrompt({ visionMaxPerRun: 8 }))); }
  try { sc.dispose(); } catch { } v.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
