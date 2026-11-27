// L4 단계 원장 시험(개선안 20261124000718_VISION · 문서 .vibe/orch/vision/concept_20261124_L4_useraxis_vmoCadence.md). 실제 Claude 호출 없음
//   v1 20261120183740_VISION(승인된 L4), 20261124000237_VISION(같은 축 승인 대기) → 원장 1건, 같은 축 L4 재진단 0건
//   v2 1차 안 verify 4번 = 관찰 항목, 반영 게이트 = 1~3번
//   v3 남은 단계 = orch-worklist 열린 일, 시한 60분 넘김 → 다음 행동 1회
//   개선안 원문(verify, targets, evidence 의 묶음과 문서)과 개념 문서 단계 줄은 2026-11-24 .vibe/orch 에서 옮겨 적음
//   사용: node test/t_orch_plans.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'plans-')); const vibeDir = path.join(root, '.vibe'); const od = path.join(vibeDir, 'orch');
const W = (rel, v) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, typeof v === 'string' ? v : JSON.stringify(v)); return f; };
const H = o => W('tools/Harness/harness.json', { repairScope: 'DB_ONLY', orch: Object.assign({ ladderMaxPerDay: 10, worklistDueMin: 60, worklistMaxHandoff: 3, observeHours: 24, agentEnabled: false }, o || {}) });
H();
const p = { root, vibeDir, claude: 'none', claudeModel: '' };
const ev = require(path.join(dir, 'orch-events')); const loc = ms => ev.nowLocal(ms); const now = Date.now();

// ── 원문(2026-11-24 .vibe/orch/proposals) ──
const P1 = { id: '20261120183740_VISION', source: 'vision', status: 'pending', level: 'L4', impact: 'core', title: '개념 재정립: VMO 진단·조치 주기를 열린 일 장부 순환으로',
  targets: ['tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/orch-agent.js', 'tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/orchestra.js', 'tools/VibeManager/orch-worklist.js(신규)', 'tools/Harness/harness.json', 'tools/VibeManager/test/t_orch_worklist.js(신규)'],
  verify: '1) 재현 시험: 사건 줄 20261120_145605_R12_ALL·20261120_153113_R12_ALL 을 넣고 시한 60분 경과 시 진단 호출 1회, 조치 기록 1건 · 2) U3·U5·U7 표본 시험(t_orch_usercheck.js) 통과 · 3) node tools/VibeManager/test/run_all.js 전체 통과 · 4) 실가동 24시간 동안 result.json S13|U3|idleInc 0건',
  evidence: 'R12 열린 사건 10건 174~209분 · 진단 사다리 묶음 L4|useraxis|vmoCadence · 문서 .vibe/orch/vision/concept_20261120_L4_useraxis_vmoCadence.md', history: [] };
const P2 = { id: '20261124000237_VISION', source: 'vision', status: 'pending', level: 'L4', impact: 'core', title: '개념 재정립: VMO 진행 = 상태 전이, need-user 계약',
  targets: ['tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/orch-agent.js', 'tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/orch-worklist.js', 'tools/VibeManager/orch-ladder.js', 'tools/VibeManager/orch-events.js', 'tools/VibeManager/orchestra.js', 'tools/VibeManager/test/t_orch_worklist.js', 'tools/VibeManager/test/t_orch_usercheck.js', 'tools/Harness/harness.json'],
  verify: "1) 재현 시험: 사건 줄 20261123_171236_R12_ALL, 20261123_115110_R12_ALL 에 '담당 아님' 기록만 넣고 60분 경과 → U3 fail 유지, 자가진단 진단 호출 1회 · 2) 재현 시험: 20261120_094734_R5_SCP0028, 20261120_094237_R3_SSP0005 사건 줄 → need-user 아님, fix 개선안 2건 생성 · 3) 재현 시험: 20261120_201206_R5_SCP0028(실행 끝남) → 확인 기록 뒤 닫힘 · 4) node tools/VibeManager/test/run_all.js 통과 · 실가동 관찰은 반영 뒤 첫 Overall Review 판정으로 확인하고 개선안 검증 항목에 넣지 않음",
  before_after: '진행 = 상태 전이, need-user 계약', evidence: 'orch-worklist.js 호출 0건 · 진단 사다리 묶음 L4|purpose|VMO가10분간격으로열린문제를진단조치함 · 문서 .vibe/orch/vision/concept_20261124_L4_purpose_VMO_10_.md', history: [] };
// 개념 문서 단계 줄(concept_20261120_L4_useraxis_vmoCadence.md:54-57 원문) + 관찰 단계 시험용 1줄(단계 5, 원문에 없음)
W('.vibe/orch/vision/concept_20261120_L4_useraxis_vmoCadence.md', ['# 개념 재정립', '## 전환',
  '- 단계 1: 장부를 읽기 전용으로 만들고 10분마다 일, 담당, 마지막 조치 시각, 시한 초과 여부만 기록한다. 확인 = 18:27 result.json 의 R12 10건이 시한 초과로 잡힘.',
  '- 단계 2: 시한 초과 일을 담당에게 다시 넘긴다. 확인 = 재현 시험(실제 사건 줄 20261120_145605_R12_ALL 을 넣고 60분 뒤 진단 호출 1회).',
  "- 단계 3: :539·:540 조건을 장부 기준으로 바꾸고, 무기록 건너뛰기를 '담당 아님' 기록으로 바꾼다. 확인 = test/run_all.js 전체 통과, U3·U5·U7 표본 시험 통과.",
  '- 단계 4: vmoCadence 를 장부의 시한 초과 건수로 판정한다. 확인 = 실가동 하루 동안 조치 기록 없는 열린 사건 120분 초과 0건(result.json S13|U3).',
  '- 단계 5(관찰): 효력 시작 뒤 observeHours 동안 S13|U3|idleInc 0건.'].join('\n'));

// 가짜 개선안 저장소(orch-improve 의 list/get/save/add/effectiveMsOf 만)
const store = {}; const put = x => { store[x.id] = JSON.parse(JSON.stringify(x)); };
put(P1); put(P2);
let seq = 0;
const improve = { list: () => Object.values(store), get: id => (store[id] ? JSON.parse(JSON.stringify(store[id])) : null), save: x => { store[x.id] = JSON.parse(JSON.stringify(x)); return x; },
  add: (o, src) => { const dup = Object.values(store).find(x => x.sig === o.sig && /^(pending|approved|applying|applied|rejected)$/.test(x.status)); if (dup) return { dup: dup.id, status: dup.status }; const id = `SUB${++seq}`; store[id] = Object.assign({ id, status: 'pending', source: src, history: [] }, o); return { id }; },
  effectiveMsOf: x => Number(x.appliedMs) || null };
let calls = 0;
const agent = { withLock: (k, fn) => fn(), say() { }, lastJsonBlock: () => ({ summary: 's', doc: '# 개념 재정립', proposal: { title: '개념 재정립: 다시', impact: 'core', evidence: 'x', targets: ['tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/orch-worklist.js'], before_after: 'a', verify: 'v', rollback: 'r', sig: 'again' } }), runClaude: async () => { calls++; return { ok: true, text: '', log: 'x.log', ms: 1 }; } };
const L = require(path.join(dir, 'orch-ladder'));
const WL = require(path.join(dir, 'orch-worklist'));
WL.init({ paths: () => p, mods: { 'orch-watch': null, 'orch-improve': improve, 'orch-agent': null, 'orch-ledger': null } });
L.init({ paths: () => p, improve, agent, ledger: { ready: () => true, init() { }, stats: () => null }, history: { stats: () => ({}) }, selfcheck: { hotLoaded: () => ({}) }, worklist: WL });

// 같은 축 지적 3건(L4|useraxis|vmoCadence) + 같은 목적 어긋남 3회(L4|purpose|VMO가10분간격으로열린문제를진단조치함)
W('tools/VibeManager/user_checks.json', { items: ['U3', 'U5', 'U7'].map((id, k) => ({ id, at: loc(now - (k + 1) * 3600000).slice(0, 16).replace('T', ' '), quote: `지적 ${id}`, detector: 'vmoCadence', status: 'active' })) });
['20261121_120359', '20261122_140538', '20261123_145412'].forEach(n => W(`.vibe/orch/vision/${n}.json`, { at: n, purposes: [{ purpose: 'VMO 가 10분 간격으로 열린 문제를 진단, 조치함', verdict: '어긋남', evidence: 'x' }] }));
W('.vibe/orch/selfcheck/result.json', { ms: now, checks: {} });
// 진단 이력(종전 3회)
W('.vibe/orch/ladder.json', { day: '', dayRuns: 0, bundles: { 'L4|useraxis|vmoCadence': { key: 'L4|useraxis|vmoCadence', runs: [{ at: '2026-11-20T18:37:40+09:00', ms: now - 4 * 86400000, proposal: '20261120183740_VISION' }, { at: '2026-11-22T00:02:10+09:00', ms: now - 2 * 86400000, proposal: '' }] }, 'L4|purpose|VMO가10분간격으로열린문제를진단조치함': { key: 'L4|purpose|VMO가10분간격으로열린문제를진단조치함', runs: [{ at: '2026-11-24T00:02:37+09:00', ms: now - 2 * 86400000, proposal: '20261124000237_VISION' }] } } });

(async () => {
  // 대조: 원장 끄기 = 종전 재진단(시험이 차이를 가려내는지)
  H({ l4PlanEnabled: false }); calls = 0;
  const keys0 = L.scan().filter(b => b.level === 'L4').map(b => b.key).sort();
  chk('준비: 같은 축 L4 묶음 2개가 올림 후보', keys0.includes('L4|useraxis|vmoCadence') && keys0.includes('L4|purpose|VMO가10분간격으로열린문제를진단조치함'), keys0.join(','));
  const ladBak = fs.readFileSync(path.join(od, 'ladder.json'), 'utf8'); const storeBak = JSON.stringify(store);
  const t0 = await L.tick(); chk('대조(l4PlanEnabled false): L4 재진단 2건(종전 동작)', calls === 2 && t0.ran.filter(r => r.level === 'L4').length === 2, `calls ${calls}`);
  fs.writeFileSync(path.join(od, 'ladder.json'), ladBak); for (const k of Object.keys(store)) delete store[k]; Object.assign(store, JSON.parse(storeBak));

  // v1
  H(); calls = 0;
  const pl = L.planFromProposal('20261120183740_VISION', { by: '시험' });
  chk('v1 승인된 L4 안 → 원장(문서 단계 5개 + 흡수 단계 1개, 관찰 단계 1개)', pl && pl.steps.length === 6 && pl.steps.filter(s => s.observe).length === 1, pl && JSON.stringify(pl.steps.map(s => [s.n, s.observe])));
  chk('v1 원장 안 상태 planned', improve.get('20261120183740_VISION').status === 'planned');
  const p2 = improve.get('20261124000237_VISION');
  chk('v1 같은 축 승인 대기 안 20261124000237_VISION = 원장 단계로 흡수(superseded)', p2.status === 'superseded' && p2.absorbedInto === '20261120183740_VISION', `${p2.status} ${p2.absorbedInto}`);
  const plans = L.readPlans(); const open = Object.values(plans.plans).filter(x => x.status === 'open');
  chk('v1 원장 1건, 흡수 1건, 묶음 key 2개', Object.keys(plans.plans).length === 1 && open.length === 1 && open[0].absorbed.length === 1 && open[0].keys.length === 2, JSON.stringify(open.map(x => [x.id, x.absorbed, x.keys])));
  chk('v1 흡수한 안은 관찰 단계 앞 새 단계', open[0].steps.map(s => s.n).join(',') === '1,2,3,4,6,5' && open[0].steps[4].absorbed === '20261124000237_VISION', open[0].steps.map(s => s.n).join(','));
  chk('v1 같은 안 다시 승인해도 원장 1건', L.planFromProposal('20261120183740_VISION').id === pl.id && Object.keys(L.readPlans().plans).length === 1);
  const t1 = await L.tick({ manual: true });
  chk('v1 같은 축 L4 재진단 0건(진단 AI 호출 0)', calls === 0 && t1.ran.filter(r => r.level === 'L4').length === 0, `calls ${calls} ran ${JSON.stringify(t1.ran)}`);
  chk('v1 두 묶음 = 원장 진행만 기록', (t1.planned || []).length === 2 && t1.planned.every(x => x.plan === pl.id), JSON.stringify(t1.planned));
  const lad = JSON.parse(fs.readFileSync(path.join(od, 'ladder.json'), 'utf8'));
  chk('v1 묶음 원장 표시(statusLabel)', /원장/.test(lad.bundles['L4|useraxis|vmoCadence'].statusLabel || '') && lad.bundles['L4|purpose|VMO가10분간격으로열린문제를진단조치함'].plan === pl.id);
  chk('원장 진행: 단계 1 하위 안 생성(fix, 자동 반영 대상 source self)', (t1.plan.created || []).length === 1 && store[t1.plan.created[0]].impact === 'fix' && store[t1.plan.created[0]].source === 'self' && store[t1.plan.created[0]].plan === pl.id, JSON.stringify(t1.plan));
  // 새 L4 진단 결과가 같은 대상이면 흡수
  chk('진단 결과 L4 안이 같은 대상이면 원장 흡수', L.openPlanFor({ key: 'L4|purpose|새목적', proposals: [], targets: ['tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/orch-worklist.js', 'tools/VibeManager/orch-agent.js'] }) != null);
  chk('공용 파일(harness.json, orchestra.js)만 겹치는 L4 안은 흡수 안 함', L.openPlanFor({ key: 'L4|purpose|다른목적', proposals: [], targets: ['tools/Harness/harness.json', 'tools/VibeManager/orchestra.js', 'tools/VibeManager/orch-selfcheck.js'] }) == null);

  // v2
  const A = require(path.join(dir, 'orch-agent')); A.init({ paths: () => p, serverSvc: null, loadQuick: () => [], restoreDelayMs: 600000 });
  const IMP = require(path.join(dir, 'orch-improve')); const V = require(path.join(dir, 'orch-verify'));
  const vs = IMP.verifyItems(P1, { gated: false });
  chk('v2 1차 안 verify 4번 = 관찰 항목', JSON.stringify(vs.observe) === '[4]' && vs.items[3].observe === true && vs.items[3].when === 'later', JSON.stringify(vs.items.map(x => [x.n, x.when, !!x.observe])));
  chk('v2 반영 게이트가 실행할 항목 = 1~3번', JSON.stringify(vs.gate) === '[1,2,3]', JSON.stringify(vs.gate));
  const pl2 = V.promptLines(vs.items).join('\n');
  chk('v2 반영 지시문: 4번은 지금 실행하지 않음', /v4 \(반영 뒤 확인\(지금 실행하지 않음\), 관찰 항목/.test(pl2) && /v1 \(반영할 때 실행\)/.test(pl2));
  const j = V.judge(vs.items, { verify_items: [{ n: 1, result: 'pass' }, { n: 2, result: 'pass' }, { n: 3, result: 'pass' }] }, { gated: false });
  chk('v2 1~3번 통과면 합격(4번 결과 없어도 반영 실패 아님)', j.verified === true && j.post.some(x => x.n === 4), JSON.stringify({ v: j.verified, why: j.why }));
  const vs3 = IMP.verifyItems({ verify: '1) 재현 시험 test/t_orch_plans.js 원장 1건 2) node tools/VibeManager/test/run_all.js 대상 시험 PASS 3) 관찰: 효력 시작 뒤 observeHours 동안 result.json S13|U3|idleInc 0건' }, { gated: false });
  chk("v2 '관찰:' 항목도 관찰로 분류(종전 분류기 = 반영할 때 실행)", JSON.stringify(vs3.observe) === '[3]' && V.items(vs3.items.map(x => x.text).join(' '), {}).length >= 1 && V.classify('3) 관찰: 효력 시작 뒤 observeHours 동안 result.json S13|U3|idleInc 0건').when === 'apply', JSON.stringify(vs3.items.map(x => [x.n, x.when])));
  H({ l4PlanEnabled: false });
  chk('v2 대조(l4PlanEnabled false): 관찰 분류 없음(종전)', IMP.verifyItems(P1, { gated: false }).observe.length === 0);
  H();

  // v3: 남은 단계 = 열린 일, 시한 넘김 → 다음 행동 1회
  const all = L.readPlans(); const ppl = all.plans[pl.id];
  ppl.steps[0].status = 'applied'; ppl.steps[0].proposal = 'SUB1'; ppl.steps[1].readyMs = now - 61 * 60000; fs.writeFileSync(path.join(od, 'vision', 'plans.json'), JSON.stringify(all));
  const items = WL.planItems({ ladder: L }, now);
  chk('v3 남은 단계 = 열린 일(담당 vmo, 시한 = 준비 + 60분)', items.length === 5 && items.every(i => i.owner === 'vmo' && i.kind === 'plan-step') && items[0].dueMs === now - 60000 && items[0].overdue && items.slice(1).every(i => i.wait === '앞 단계 진행 중'), JSON.stringify(items.map(i => [i.id, i.wait, i.overdue])));
  const b0 = Object.keys(store).length;
  const r1 = WL.planTick({ ladder: L, now });
  chk('v3 시한 60분 넘김 → 다음 행동(하위 안 생성) 1회', r1.acted.length === 1 && r1.acted[0].ok && Object.keys(store).length === b0 + 1, JSON.stringify(r1.acted));
  const r2 = WL.planTick({ ladder: L, now: now + 60000 });
  chk('v3 다시 돌려도 추가 행동 0(하위 안 있음 = 기다리는 사유)', r2.acted.length === 0 && Object.keys(store).length === b0 + 1 && /하위 안 SUB\d+ pending/.test(r2.items[0].wait), JSON.stringify(r2.items[0]));
  const wj = JSON.parse(fs.readFileSync(path.join(od, 'worklist.json'), 'utf8'));
  chk('v3 장부 기록(planItems · planHandoffs 1번)', Array.isArray(wj.planItems) && Object.values(wj.planHandoffs || {}).some(h => h.n === 1));
  const all2 = L.readPlans(); all2.plans[pl.id].steps[2].readyMs = now - 10 * 60000; // 시한 안
  const notDue = WL.planItems({ ladder: L }, now).find(i => i.step === 3); chk('v3 시한 전 단계 = 행동 없음', !notDue || !notDue.overdue || notDue.wait);

  // 원장 진행: 하위 안 반영 → 다음 단계 · 관찰 단계 시작 · 관찰 판정 실패면 L4 진단 다시 허용
  const al = L.readPlans(); const q = al.plans[pl.id];
  for (const s of q.steps) if (!s.observe) { s.status = 'applied'; s.effMs = now - 3600000; if (store[s.proposal]) Object.assign(store[s.proposal], { status: 'applied', appliedMs: now - 3600000 }); } fs.writeFileSync(path.join(od, 'vision', 'plans.json'), JSON.stringify(al));
  L.planProgress(now); const s5 = L.readPlans().plans[pl.id].steps.find(s => s.observe);
  chk('관찰 단계: 앞 단계 효력 뒤 시작(observeHours 24)', s5.status === 'observing' && s5.hours === 24 && s5.endMs - s5.startMs === 24 * 3600000);
  W('.vibe/orch/selfcheck/result.json', { ms: now, checks: { S13: { ms: now, items: [{ key: 'S13|U3|idleInc|x', level: 'fail', ms: now + 1000 }] } } });
  L.planProgress(s5.endMs + 1); const s5b = L.readPlans().plans[pl.id].steps.find(s => s.observe);
  chk('관찰 판정: 관찰 시작 뒤 S13|U3|idleInc fail 1건 = observe-fail', s5b.status === 'observe-fail' && s5b.observed.n === 1, JSON.stringify(s5b.observed));
  chk('관찰 실패 원장 = 같은 축 L4 진단 다시 허용', L.openPlanFor({ key: 'L4|useraxis|vmoCadence' }) === null);

  // 흡수 단계 = 변경 글에 안 id 가 있는 남은 단계(확인 글에만 id 가 나오는 끝난 단계 제외). 2026-11-24 실제 원장 생성 때 단계 1 로 잘못 붙던 결함 재현
  //   단계 줄 = concept_20261124_L4_useraxis_vmoCadence.md 전환 절 원문
  { const ap = L.readPlans(); ap.plans[pl.id].status = 'done'; fs.writeFileSync(path.join(od, 'vision', 'plans.json'), JSON.stringify(ap));
    store['20261124000237_VISION'] = JSON.parse(JSON.stringify(P2));
    W('.vibe/orch/vision/concept_20261124_L4_useraxis_vmoCadence.md', ['## 전환',
      '- 단계 1: 원장 파일과 orch-ladder.js 검사만 넣음. 확인 = 같은 축 L4|useraxis|vmoCadence, L4|purpose|... 재진단 0건 시험, 20261120183740_VISION 과 20261124000237_VISION 이 원장 1건으로 묶임.',
      '- 단계 2: orch-improve.js verify 분리와 관찰 열린 일. 확인 = 20261120183740_VISION verify 4번이 관찰 항목으로 분류되고 반영 게이트가 1~3번만 봄(재현 시험).',
      '- 단계 3: 원장 남은 단계로 하위 안 생성. 1번째 하위 안 = orch-worklist.js 연결(selfcheck worklistCycle, U3 장부). 확인 = t_orch_worklist.js 전체 PASS, 20261123_115110_R12_ALL 등 4건 사건 줄 재현 시 60분 뒤 진단 1회와 조치 기록 1건.',
      '- 단계 4: 20261124000237_VISION 내용(상태 전이 진행, need-user 계약) 하위 안. 확인 = S7 need-user 4건이 담당 사용자 또는 VMO 로 장부에 오름.',
      '- 단계 5: 관찰. 확인 = 효력 시작 뒤 observeHours 동안 S13|U3|idleInc 0건, S13|U3|stuckProp 시한 초과 0건.'].join('\n'));
    put({ id: '20261124000718_VISION', source: 'vision', status: 'applying', level: 'L4', impact: 'core', title: '개념 재정립: VMO 진단·조치 주기 3차', targets: ['tools/VibeManager/orch-improve.js', 'tools/VibeManager/orch-ladder.js', 'tools/VibeManager/orch-worklist.js', 'tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/orch-agent.js', 'tools/VibeManager/orchestra.js', 'tools/Harness/harness.json', 'tools/VibeManager/test/t_orch_plans.js(신규)', '.vibe/orch/vision/plans.json(신규)'], evidence: '진단 사다리 묶음 L4|useraxis|vmoCadence · 문서 .vibe/orch/vision/concept_20261124_L4_useraxis_vmoCadence.md', history: [] });
    const q3 = L.planFromProposal('20261124000718_VISION', { doneSteps: [1, 2], keepStatus: true });
    chk('흡수 단계 = 단계 4(변경 글에 id), 단계 1(확인 글에만 id, 끝난 단계) 아님', q3 && q3.steps.find(s => s.absorbed === '20261124000237_VISION').n === 4 && !q3.steps[0].absorbed && q3.steps.length === 5, q3 && JSON.stringify(q3.steps.map(s => [s.n, s.status, s.absorbed || ''])));
    chk('keepStatus = 반영 중인 원장 안 상태 그대로', store['20261124000718_VISION'].status === 'applying');
    chk('단계 3 하위 안 대상 = orch-worklist.js, orch-selfcheck.js, t_orch_worklist.js', (() => { L.planProgress(now); const s3 = L.readPlans().plans['20261124000718_VISION'].steps[2]; const t = (store[s3.proposal] || {}).targets || []; return t.includes('tools/VibeManager/orch-worklist.js') && t.includes('tools/VibeManager/orch-selfcheck.js') && t.includes('tools/VibeManager/test/t_orch_worklist.js'); })()); }

  try { A.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
