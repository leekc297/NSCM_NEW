// 2026-11-23 개선안 20261120183740_VISION(L4 개념 재정립 · 문서 .vibe/orch/vision/concept_20261120_L4_useraxis_vmoCadence.md): 열린 일 장부.
//   종전: VMO 는 새 사건, 새 점검 실패, 새 반영 실패에 1번 반응하고 이미 열린 일은 하루 1회 진단 전까지 다시 보지 않았다
//     (2026-11-20 18:27 result.json U3 조치 기록 없는 열린 사건 10건 174~209분 · R12 는 agentRules 밖이라 에이전트가 건너뜀).
//   지금: 자가진단 tick(10분 · selfLightMin)마다 열린 일 전부(열린 사건, 자동 반영 대기 개선안, 반영 실패 안)를 이 장부 하나에서 본다.
//     일마다 담당 1개와 시한(worklistDueMin 60분)을 둔다. 시한 안에 조치 기록이나 기다리는 사유가 없으면 담당에게 다시 넘기고 그 사실을 일에 기록한다.
//   담당: R12 = 자가진단 진단(selfdiag) · agentRules 규칙 = 에이전트(agent) · R6 R7 R8 R9 = 코드 조치(code, 에이전트 대기열이 codeAction 먼저 실행)
//     · 자동 반영 대상 개선안 = 자동 반영(autoapply) · 반영 실패 안 = 실패 진단(repair) · 승인 대상 = 사용자(user) · 그 밖 = 담당 없음(none, 막힘으로 표시)
//   기다리는 사유: 조치 중, 에이전트 대기열, 에이전트 꺼짐, 시간당 상한, 관찰 모드, 진단 간격, 사용자 확인, 승인 대기, 실행 중 작업이 읽는 도구, 반영 중
//   다시 넘김은 일마다 worklistMaxHandoff(3)번까지. 넘긴 뒤에도 진척이 없으면 막힘(stuck)으로 두고 사용자 지적 감지기 U3(vmoCadence)가 알린다.
//   호출(개선안 20261124093730_SELF, L4 단계 원장 20261124000718_VISION 단계 3): orch-selfcheck.js worklistCycle 이 selfLightMin 분마다와 새 사건이 생긴 tick 에 tick 을 부르고,
//     diagIds 가 있으면 자가진단 진단 1회 뒤 noteDiag 로 사건마다 조치 기록 1건을 남긴다. 장부가 켜져 있으면 새 사건 진단(selfDiagOnFail)도 이 경로만 쓴다
//   끄기: harness.json orch.worklistEnabled false = 종전 반응 경로(새 사건 + 반영 1건 뒤 tick 종료)
//   기록: .vibe/orch/worklist.json(최근 장부 · 화면 표시) · handoff 횟수는 같은 파일 handoffs
'use strict';
const dfmt = require('./date-fmt'); // 2026-11-23 사용자: VM 일자 = Windows 일자 형식
const fs = require('fs');
const path = require('path');
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { /* 오류 기록 모듈 없음 */ }
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

const DEF = { worklistEnabled: true, worklistDueMin: 60, worklistMaxHandoff: 3, selfDiagGapMin: 60, needUserContract: true, agentRules: ['R1', 'R2', 'R3', 'R4', 'R5', 'R10', 'R11', 'R13', 'R14'] };
// 개선안 20261126103110_SELF(L4 단계 원장 20261124000718_VISION 단계 4, 흡수한 안 20261124000237_VISION): need-user 계약.
//   종전: need-user 사건은 규칙 담당(에이전트, 코드 조치)으로 장부에 오르고 기다리는 사유 '사용자 확인'으로 멈춤(2026-11-24 S7 need-user 4건 76~86시간).
//   지금: 사용자 행동이 기록된 사건(agent.next_for_user)만 담당 사용자. 원인이 VM, VMO 코드인 사건과 사용자 행동 기록이 없는 사건은 담당 VMO 로 두고,
//     시한을 넘기면 사건을 다시 열어 담당 경로(R12 = 자가진단 진단, 그 밖 = 에이전트)에 fix 개선안 지시와 함께 넘긴다. 개선안이 붙은 사건 = 담당 VMO, 기다리는 사유 '개선안 진행'
//   끄기: harness.json orch.needUserContract false = 종전(규칙 담당 + '사용자 확인')
const VM_CODE_RE = /tools[\\/]VibeManager|\borch-[a-z-]+\.js|\b(workbench|job-runner|chain-runner|extension|server-svc)\.js|VM 감시기|VMO 코드/;
const CONTRACT_NOTE = 'need-user 계약: 원인이 VM, VMO 코드(tools/VibeManager)면 need-user 로 끝내지 말고 status proposal 로 fix 개선안을 낸다. 사용자에게 넘길 때는 next_for_user 에 사용자가 할 행동을 적는다. 둘 다 아니면 원인 확인을 이어 간다';
const CODE_RULES = ['R6', 'R7', 'R8', 'R9'];
const OWNER_KO = { selfdiag: '자가진단 진단', agent: '에이전트', code: '코드 조치', autoapply: '자동 반영', repair: '반영 실패 진단', user: '사용자', vmo: 'VMO', none: '담당 없음' }; // vmo = L4 단계 원장 남은 단계, need-user 계약으로 VMO 가 이어 가는 사건
// 개선안 20261124000718_VISION: L4 단계 원장(orch-ladder planSteps)의 남은 단계 = 열린 일(kind plan-step, 담당 vmo, 시한 = 단계 준비 시각 + worklistDueMin · 관찰 단계는 관찰 끝 시각).
//   시한을 넘기고 기다리는 사유가 없으면 다음 행동(하위 안 생성 또는 관찰 판정, orch-ladder planDue)을 1회 실행하고 다시 넘김 횟수를 남긴다
const TAG = '열린 일 장부';

let getPaths = null; let opts = {};
const P = () => getPaths();
const file = () => path.join(P().vibeDir, 'orch', 'worklist.json');
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f + '.t', JSON.stringify(v, null, 1), 'utf8'); try { fs.renameSync(f + '.t', f); } catch { fs.copyFileSync(f + '.t', f); try { fs.unlinkSync(f + '.t'); } catch { } } return true; } catch (e) { errlog.note('orch-worklist', 'writeJson', e); return false; } };
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const mod = n => { if (opts.mods && n in opts.mods) return opts.mods[n]; try { return require(`./${n}`); } catch (e) { errlog.note('orch-worklist', `require ${n}`, e); return null; } };
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); return Object.assign({}, DEF, (h && h.orch) || {}); }
const tms = s => { const v = Date.parse(String(s || '')); return Number.isFinite(v) ? v : 0; };
const lastAt = arr => (arr || []).reduce((m, h) => Math.max(m, tms(h && h.at)), 0);

function ownerOfIncident(inc, c) { if (inc.rule === 'R12') return 'selfdiag'; if ((c.agentRules || []).includes(inc.rule)) return 'agent'; if (CODE_RULES.includes(inc.rule)) return 'code'; return 'none'; }
/** need-user 사건의 담당(계약). 반환 { owner: 'user'|'vmo', why, next, wait } */
//   원인 글 = agent.cause(결과 JSON 이 없을 때만 마지막 기록). 기록 글의 '허용 범위 밖 파일 변경: tools/VibeManager/CHANGELOG.md' 같은 부기를 원인으로 읽지 않음
//   getProp(id) = 개선안 조회(선택). 개선안이 끝난 상태(반영, 반려 등)면 기다리는 사유 없이 VMO 가 확인 뒤 닫기를 이어 감
function needUserContract(inc, getProp) {
  const ag = (inc && inc.agent) || {}; const acts = (inc && inc.actions) || [];
  const userAct = String(ag.next_for_user || '').trim(); const cause = inc && inc.agent ? String(ag.cause || '') : String((acts[acts.length - 1] || {}).what || '');
  if (inc && inc.proposal) {
    let ps = ''; try { const p = getProp ? getProp(inc.proposal) : null; ps = p ? String(p.status || '') : ''; } catch { ps = ''; }
    if (ps && !/^(pending|approved|applying|apply-failed)$/.test(ps)) return { owner: 'vmo', why: `개선안 ${inc.proposal} ${ps}`, next: '개선안 결과 확인 뒤 사건 닫기', wait: '' };
    return { owner: 'vmo', why: `개선안 ${inc.proposal} 로 이어 감`, next: `개선안 ${inc.proposal} 반영`, wait: `개선안 ${inc.proposal} 진행` };
  }
  if (VM_CODE_RE.test(cause) && ag.cause_class !== 'env' && ag.cause_class !== 'screen') return { owner: 'vmo', why: '원인이 VM, VMO 코드', next: 'fix 개선안 생성', wait: '' };
  if (userAct) return { owner: 'user', why: '사용자 행동 기록 있음', next: userAct.slice(0, 200), wait: `사용자 확인: ${userAct.slice(0, 80)}` };
  return { owner: 'vmo', why: '사용자 행동 기록 없음', next: '원인 확인 이어 감', wait: '' };
}

/** 열린 일 목록을 만든다(파일을 고치지 않음). x = { now, lastDiagMs, autoEligible(p) → { ok, kind }, chainBusy, touchesRunTools(p), applying } */
function build(x) {
  const c = cfg(); const now = x.now || Date.now(); const dueMs = c.worklistDueMin * 60000; const items = [];
  const watch = mod('orch-watch'); const imp = mod('orch-improve'); const agent = mod('orch-agent'); const lg = mod('orch-ledger');
  let ag = { unavailable: true }; try { if (agent && agent.status) ag = agent.status() || ag; } catch { ag = { unavailable: true }; /* 에이전트 init 전(VMO 시작 직후, 단독 시험) = 기다리는 사유 '에이전트 준비 전'. 오류 기록에 남기지 않음(S5 R12 사건이 생김) */ }
  const queued = new Set((readJson(path.join(P().vibeDir, 'orch', 'agent_queue.json'), []) || []).map(q => q && q.id).filter(Boolean));
  let incs = []; try { incs = watch ? watch.list(400) : []; } catch (e) { errlog.note('orch-worklist', 'incidents', e); }
  const diagNext = (x.lastDiagMs || 0) + c.selfDiagGapMin * 60000;
  for (const inc of incs) {
    if (!inc || inc.notice || !/^(open|acting|need-user)$/.test(inc.status || '')) continue;
    let owner = ownerOfIncident(inc, c); const acts = inc.actions || []; const last = Math.max(inc.ms || 0, lastAt(acts));
    let wait = ''; let next = ''; let contract = '';
    if (inc.status === 'need-user' && c.needUserContract !== false) { const k = needUserContract(inc, id => (imp && imp.get ? imp.get(id) : null)); owner = k.owner; wait = k.wait; next = k.next; contract = k.why; }
    else if (inc.status === 'need-user') wait = '사용자 확인';
    else if (owner === 'agent' || owner === 'code') {
      if (ag.unavailable) wait = '에이전트 준비 전';
      else if (ag.current === inc.id) wait = '조치 중';
      else if (queued.has(inc.id)) wait = '에이전트 대기열';
      else if (ag.on === false || (owner === 'agent' && ag.enabled === false)) wait = '에이전트 꺼짐(agentEnabled)';
      else if (owner === 'agent' && ag.maxPerHour && ag.perHour >= ag.maxPerHour) wait = `시간당 상한 ${ag.perHour}/${ag.maxPerHour}건`;
      else { let ob = false; try { ob = !!(lg && lg.observing && lg.observing(inc.rule)); } catch { ob = false; } if (ob) wait = `${inc.rule} 관찰 모드`; }
    } else if (owner === 'selfdiag') {
      if (x.diagRunning) wait = '진단 중';
      else if (ag.unavailable) wait = '에이전트 준비 전';
      else if (ag.busy) wait = '에이전트가 다른 일 처리 중';
      else if (now < diagNext) wait = `진단 간격 ${c.selfDiagGapMin}분(다음 ${nowLocal(diagNext).slice(11, 16)})`;
    }
    // 자가진단 사건이 아직 진단에 넘어간 적이 없으면 바로 시한(종전 새 사건 반응과 같은 시점). 나머지는 마지막 조치 기록 + 시한
    const handed = acts.some(a => String(a.what || '').startsWith(TAG));
    const due = owner === 'selfdiag' && !handed ? (inc.ms || 0) : last + dueMs;
    const it = { id: inc.id, kind: 'incident', rule: inc.rule, title: String(inc.title || '').slice(0, 120), status: inc.status, owner, lastMs: last, dueMs: due, wait, overdue: now >= due };
    if (next) { it.next = next; it.contract = contract; }
    items.push(it);
  }
  let props = []; try { props = imp ? imp.list() : []; } catch (e) { errlog.note('orch-worklist', 'proposals', e); }
  const elig = p => { try { return x.autoEligible ? x.autoEligible(p) : { ok: false }; } catch { return { ok: false }; } };
  for (const p of props) {
    if (!p || !/^(pending|apply-failed|approved|applying)$/.test(p.status || '')) continue;
    const e = elig(p); const last = Math.max(p.ms || 0, p.autoMs || 0, lastAt(p.history)); let owner = 'user', wait = '';
    if (/^(approved|applying)$/.test(p.status)) { owner = e.ok && e.kind === 'code' ? 'autoapply' : 'user'; wait = '반영 중'; }
    else if (p.status === 'pending') {
      if (!(e.ok && e.kind === 'code')) { owner = e.ok && e.kind === 'delete' ? 'autoapply' : 'user'; if (owner === 'user') wait = '사용자 승인 대기'; }
      else { owner = 'autoapply'; if (x.applying) wait = '반영 중'; else if (p.autoWaitMs && p.autoWaitMs > now) wait = `반영 대기(${nowLocal(p.autoWaitMs).slice(11, 16)})`; else if (x.chainBusy && x.touchesRunTools && x.touchesRunTools(p)) wait = p.waitNote || '실행 중인 작업이 읽는 검증 도구 대상'; else if (!p.autoTried) wait = '자동 반영 대기열'; }
    } else { // apply-failed
      if (!(e.ok && e.kind === 'code') || p.reason) { owner = 'user'; wait = '사용자 판단(승인 대상 또는 반려 사유 있음)'; }
      else { owner = 'repair'; if (p.needsUser || (p.repair && p.repair.decision === 'stop')) wait = '사용자 확인(자동 해결 중단)'; else if (!p.repair) wait = '반영 실패 진단 대기열'; }
    }
    items.push({ id: p.id, kind: 'proposal', rule: p.source || '', title: String(p.title || '').slice(0, 120), status: p.status, owner, lastMs: last, dueMs: last + dueMs, wait, overdue: now >= last + dueMs });
  }
  for (const it of planItems(x, now)) items.push(it);
  return { at: nowLocal(now), ms: now, dueMin: c.worklistDueMin, items };
}
/** L4 단계 원장의 남은 단계 → 열린 일. x.ladder = orch-ladder 모듈(없으면 require) */
function planItems(x, now) {
  const lad = (x && x.ladder) || mod('orch-ladder'); if (!lad || typeof lad.planSteps !== 'function') return [];
  let st = []; try { st = lad.planSteps(now) || []; } catch (e) { errlog.note('orch-worklist', 'planSteps', e); }
  return st.map(s => ({ id: `plan:${s.plan}:${s.n}`, kind: 'plan-step', plan: s.plan, step: s.n, rule: 'L4plan', title: String(s.title || '').slice(0, 120), status: s.status, owner: 'vmo', next: s.next, proposal: s.proposal, lastMs: s.readyMs, dueMs: s.dueMs, wait: s.wait, overdue: now >= s.dueMs }));
}
/** 단계 열린 일 1건의 다음 행동 1회. hand = 다시 넘김 기록(고침) */
function planHand(it, hand, c, now, x) {
  const h = hand[it.id] || { n: 0 }; if (h.n >= c.worklistMaxHandoff) { it.stuck = `다시 넘김 ${h.n}번 뒤에도 시한 안 진척 없음`; return { stuck: it.stuck }; }
  const lad = (x && x.ladder) || mod('orch-ladder'); let r = { ok: false, why: '진단 사다리 모듈 없음' };
  try { if (lad && lad.planDue) r = lad.planDue(it.plan, it.step) || r; } catch (e) { errlog.note('orch-worklist', `planDue ${it.id}`, e); r = { ok: false, why: e.message }; }
  hand[it.id] = { n: h.n + 1, lastMs: now, owner: 'vmo', what: `${TAG}: 시한 ${c.worklistDueMin}분 넘김. 다음 행동 '${it.next}' 실행(${h.n + 1}번째): ${r.ok ? (r.id || r.why || '실행') : `못 함 ${r.why}`}` };
  it.handed = h.n + 1; return { acted: { id: it.id, next: it.next, ok: !!r.ok, result: r.id || r.why || '' } };
}
/** 단계 열린 일만 돈다(진단 사다리 tick 에서 부름. 장부 전체 순환 tick 연결 전에도 남은 단계에 담당과 시한이 있게). 반환 { items, acted, stuck } */
function planTick(x) {
  const c = cfg(); if (c.worklistEnabled === false) return { off: true };
  const now = (x && x.now) || Date.now(); const items = planItems(x, now); const prev = readJson(file(), {}); const hand = Object.assign({}, prev.planHandoffs || {});
  const live = new Set(items.map(i => i.id)); for (const k of Object.keys(hand)) if (!live.has(k)) delete hand[k];
  const acted = [], stuck = [];
  for (const it of items) { if (!it.overdue || it.wait) continue; const r = planHand(it, hand, c, now, x); if (r.acted) acted.push(r.acted); if (r.stuck) stuck.push({ id: it.id, why: r.stuck }); }
  const cur = readJson(file(), {}); writeJson(file(), Object.assign({}, cur, { planItems: items, planHandoffs: hand, planAt: nowLocal(now) }));
  if (orchEv && (acted.length || stuck.length)) { try { orchEv.emit('worklist.plan', { acted: acted.length, stuck: stuck.length }); } catch { /* 기록만 */ } }
  return { items, acted, stuck };
}

/** 10분 주기에서 부른다. 시한을 넘기고 기다리는 사유가 없는 일을 담당에게 다시 넘긴다.
 *  반환 { off } | { items, diagIds: [자가진단 진단에 넘길 사건 id], handed: [{id, owner}], stuck: [{id, why}] }
 *  자가진단 진단 호출은 부르는 쪽(orch-selfcheck tick)이 diagIds 가 있을 때 1회 하고 noteDiag 로 사건마다 기록 1건을 남긴다 */
function tick(x) {
  const c = cfg(); if (c.worklistEnabled === false) return { off: true };
  const now = (x && x.now) || Date.now(); const w = build(Object.assign({}, x, { now }));
  const prev = readJson(file(), {}); const hand = Object.assign({}, prev.handoffs || {}); const live = new Set(w.items.map(i => i.id));
  for (const k of Object.keys(hand)) if (!live.has(k)) delete hand[k];
  const watch = mod('orch-watch'); const imp = mod('orch-improve'); const agent = mod('orch-agent');
  const diagIds = [], handed = [], stuck = [];
  for (const it of w.items) {
    if (!it.overdue || it.wait) continue;
    const h = hand[it.id] || { n: 0 };
    if (it.owner === 'none') { it.stuck = `담당 없음(규칙 ${it.rule} 담당 표에 없음)`; stuck.push({ id: it.id, why: it.stuck }); continue; }
    if (it.owner === 'user' || (it.owner === 'vmo' && it.kind !== 'incident')) continue; // vmo(단계 원장) = planTick 이 다음 행동과 다시 넘김 횟수(planHandoffs)를 맡음
    if (h.n >= c.worklistMaxHandoff) { it.stuck = `다시 넘김 ${h.n}번 뒤에도 시한 안 진척 없음`; stuck.push({ id: it.id, why: it.stuck }); continue; }
    const mins = Math.round((now - it.lastMs) / 60000); const what = `${TAG}: 마지막 기록 뒤 ${mins}분(시한 ${c.worklistDueMin}분) 동안 조치 기록과 기다리는 사유 없음. 담당(${OWNER_KO[it.owner]})에게 다시 넘김(${h.n + 1}번째)`;
    try {
      if (it.owner === 'selfdiag') { diagIds.push(it.id); }
      else if (it.owner === 'vmo') { // need-user 계약: 담당 VMO 사건 = 다시 열고 담당 경로에 넘김(R12 = 자가진단 진단, 그 밖 = 에이전트)
        if (!watch) continue; const vw = `${what}. need-user 계약(${it.contract || ''}), 다음 행동 '${it.next || ''}'`;
        if (it.rule === 'R12') { watch.update(it.id, { status: 'open' }, { by: 'VMO', grade: 'A', what: vw }); diagIds.push(it.id); }
        else { if (!agent) continue; watch.update(it.id, { status: 'open' }, { by: 'VMO', grade: 'A', what: vw }); agent.enqueue(it.id, false, `${TAG}: ${CONTRACT_NOTE}`); }
      }
      else if (it.owner === 'agent' || it.owner === 'code') { if (!watch || !agent) continue; watch.update(it.id, it.status === 'acting' ? { status: 'open' } : null, { by: 'VMO', grade: 'A', what }); agent.enqueue(it.id, false, `${TAG}: 시한 넘겨 다시 넘김. 이번 조치 결과(조치, 담당 아님, 기다림 사유)를 사건에 기록할 것`); }
      else if (it.owner === 'autoapply' || it.owner === 'repair') {
        const cur = imp && imp.get(it.id); if (!cur) continue;
        if (it.owner === 'autoapply') cur.autoTried = false; // 시도 표시가 남아 다시 집지 않던 안을 다시 대기로
        else if (cur.repair && cur.repair.decision === 'retry') cur.repair = null; // 새 반영 실패가 없어 다시 진단되지 않던 '다시 시도' 안을 다시 진단 대상으로
        (cur.history = cur.history || []).push({ at: nowLocal(now), by: 'VMO', what }); imp.save(cur);
      }
      hand[it.id] = { n: h.n + 1, lastMs: now, owner: it.owner }; it.handed = h.n + 1; if (it.owner !== 'selfdiag' && !(it.owner === 'vmo' && it.rule === 'R12')) handed.push({ id: it.id, owner: it.owner });
    } catch (e) { errlog.note('orch-worklist', `handoff ${it.id}`, e); it.stuck = `다시 넘김 실패: ${e.message}`; stuck.push({ id: it.id, why: it.stuck }); }
  }
  const counts = { open: w.items.length, overdue: w.items.filter(i => i.overdue).length, waiting: w.items.filter(i => i.wait).length, handed: handed.length + diagIds.length, stuck: stuck.length };
  writeJson(file(), Object.assign({}, w, { handoffs: hand, counts, lastHand: handed.length || diagIds.length ? nowLocal(now) : (prev.lastHand || '') }));
  if (orchEv && (counts.handed || counts.stuck)) { try { orchEv.emit('worklist', counts); } catch { /* 기록만 */ } }
  return { items: w.items, diagIds, handed, stuck, counts };
}

/** 자가진단 진단을 부른 뒤 넘긴 사건마다 조치 기록 1건을 남긴다. text = 진단 결과 요약 */
function noteDiag(ids, text, x) {
  const watch = mod('orch-watch'); if (!watch || !ids || !ids.length) return 0; const c = cfg(); const now = (x && x.now) || Date.now(); let n = 0;
  for (const id of ids) { const inc = watch.get(id); if (!inc) continue; const mins = Math.round((now - Math.max(inc.ms || 0, lastAt(inc.actions))) / 60000); if (watch.update(id, inc.status === 'acting' ? { status: 'open' } : null, { by: 'VMO', grade: 'A', what: `${TAG}: 마지막 기록 뒤 ${mins}분(시한 ${c.worklistDueMin}분). 담당(${OWNER_KO.selfdiag})에게 넘김. 진단 결과 ${String(text || '').slice(0, 300)}` })) n++; }
  return n;
}

/** 화면 표시용 요약(파일만 읽음) */
function summary() {
  const w = readJson(file(), null); if (!w) return null;
  const items = (w.items || []).filter(i => i.overdue || i.wait || i.stuck).slice(0, 30).map(i => ({ id: i.id, kind: i.kind, rule: i.rule, owner: i.owner, ownerKo: OWNER_KO[i.owner] || i.owner, due: dfmt.fmtDT(i.dueMs), wait: i.wait || '', stuck: i.stuck || '', overdue: !!i.overdue, title: i.title, next: i.next || '' }));
  return { at: w.at, ms: w.ms, dueMin: w.dueMin, counts: w.counts || {}, lastHand: w.lastHand || '', items };
}
function ready() { return !!getPaths; }
/** o = { paths: () => ({ root, vibeDir }), mods?: { 'orch-watch', 'orch-improve', 'orch-agent', 'orch-ledger' } } */
function init(o) { getPaths = o.paths; opts = o || {}; }
module.exports = { init, ready, build, tick, noteDiag, summary, ownerOfIncident, needUserContract, planItems, planTick, OWNER_KO, DEF, TAG, CONTRACT_NOTE };
