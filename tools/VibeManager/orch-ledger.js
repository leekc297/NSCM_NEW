// orch-ledger.js — VMO 개입 장부 · 사후 검증 · 오판 자동 처리 · 관찰 모드(2026-11-20 플랜 vm-ui-snug-mountain J1~J3)
//   사용자 지시: "VMO 가 자기 오판을 스스로 알아내는 판단을 잘 하기 위해서" · 사고 = 16:06:50 R14 가 재개된 SCP0028 CheckList 를 '중지 뒤 계속 실행'으로 오판해 멈춤
//   ① 장부 .vibe/orch/interventions.jsonl: VMO 가 사용자 작업·시스템 상태에 손댄 일 1건 = 1줄. 개입 전제(premise)를 기계가 다시 확인할 수 있는 값으로 적는다
//   ② 사후 검증: checkDelayMin 뒤 전제를 사건 기록 말고 다른 원천(실행 ID 의 시작 시각, 프로세스, 사건 목록, 개선안 상태)으로 다시 확인 → ok | false(오판) | noeffect(효과 없음) | unknown
//   ③ 오판 확정: 피해 복구(재개 기록 되살림 · 사건 다시 열기) → 원 사건 falsePositive → 사건 R15 → 개선안(self · fix) → 그 규칙 관찰 모드(사건은 올리되 개입 안 함)
//      관찰 모드 해제 = 그 개선안이 반영 완료(게이트 통과)되면 자동, 또는 사용자
//   실행을 다시 시작하지는 않는다(재개 가능 상태로 되돌리기까지)
'use strict';
const fs = require('fs'); const path = require('path');
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { /* 오류 기록 모듈 없음 */ }
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }
const DEF = { ledgerEnabled: true, checkDelayMin: 3, userReactMin: 15, observeAfterFalse: 1, interventionDays: 7, ledgerKeepDays: 30, checkGiveUpMin: 120 };
const KIND_KO = { stop: '실행 중지', kill: '프로세스 종료', requeue: '다시 실행', pause: '작업 일시 중지', lockdel: '잠금 삭제', server: '서버 재기동', revert: '파일 되돌림', apply: '개선안 자동 반영', delete: '생성물 삭제', resolve: '사건 자동 해결' };
const VERDICT_KO = { ok: '맞음', false: '오판', noeffect: '효과 없음', unknown: '미확인', 'n/a': '검증 대상 아님' };
// 오판 개선안의 대상 파일(규칙 판정 코드가 있는 곳)
const RULE_FILE = { R13: 'tools/VibeManager/orch-heal.js', R14: 'tools/VibeManager/orch-watch.js', R6: 'tools/VibeManager/orch-agent.js', R7: 'tools/VibeManager/orch-agent.js', R9: 'tools/VibeManager/orch-agent.js', R2: 'tools/VibeManager/orch-agent.js', reload: 'tools/VibeManager/orch-watch.js', lock: 'tools/VibeManager/orch-watch.js' };
let getPaths = null; let D = {}; let seq = 0; let modeCache = null; let modeMt = -1;
const P = () => getPaths();
const orchDir = () => path.join(P().vibeDir, 'orch');
const file = () => path.join(orchDir(), 'interventions.jsonl');
const modeFile = () => path.join(orchDir(), 'rule_mode.json');
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
function cfg() { let h = {}; try { h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); } catch { h = {}; } return Object.assign({}, DEF, (h && h.orch) || {}); }
const mod = n => { if (D[n]) return D[n]; try { return require(`./${n}`); } catch (e) { errlog.note('orch-ledger', `require ${n}`, e); return null; } };
const watchM = () => D.watch || mod('orch-watch'); const stateM = () => D.state || mod('orch-state');

function init(o) { if (o.paths) getPaths = o.paths; for (const k of ['watch', 'state', 'improve', 'jobRunner', 'serverSvc', 'events']) if (o[k]) D[k] = o[k]; if (o.reset) D = {}; modeCache = null; modeMt = -1; } // 여러 모듈이 불러도 먼저 준 의존 값은 유지
const ready = () => !!getPaths;
function readAll() { const out = []; try { for (const ln of fs.readFileSync(file(), 'utf8').split(/\r?\n/)) { if (!ln.trim()) continue; try { out.push(JSON.parse(ln)); } catch { /* 깨진 줄 건너뜀 */ } } } catch { /* 장부 없음 */ } return out; }
function writeAll(rows) { const keep = Date.now() - cfg().ledgerKeepDays * 86400000; const txt = rows.filter(r => (r.ms || 0) >= keep).map(r => JSON.stringify(r)).join('\n'); try { fs.mkdirSync(orchDir(), { recursive: true }); fs.writeFileSync(file(), txt ? txt + '\n' : '', 'utf8'); } catch (e) { errlog.note('orch-ledger', 'writeAll', e); } }

/** 2026-11-20 사용자 지시 'vmo 가 보완 후 작업재개 나 재실행을 하지 않는 것이 기본 · 환경설정에서 재수행여부 · default 수행없음':
 *  harness.json orch.rerunAfterFix = 'none'(기본 · 보완까지만) | 'rerun'(보완 뒤 작업 재개 또는 재실행). VM 환경설정 🔁 VMO 보완 뒤 재수행 이 바꾼다. 부를 때마다 읽는다 */
// 2026-11-20 17:2x 사용자 변경: '재수행을 초기값으로 · 보완 후 재수행했는데 다시 오류가 발생하면 2번까지는 재수행 · 3번째에도 오류면 이 작업은 재수행 하지 않음'
//   기본 = 재수행(값이 'none' 일 때만 수행 없음). 한도 = orch.rerunMax(기본 2) · 작업·화면마다 VMO 가 다시 돌린 횟수(job-runner s.healed)
function hcfg(root) { try { const r = root || (getPaths && getPaths().root); if (!r) return {}; const h = readJson(path.join(r, 'tools', 'Harness', 'harness.json'), {}); return (h && h.orch) || {}; } catch { return {}; } }
function rerunAllowed(root) { return hcfg(root).rerunAfterFix !== 'none'; }
function rerunMax(root) { const v = Number(hcfg(root).rerunMax); return Number.isFinite(v) && v >= 0 ? v : 2; }
const RERUN_NOTE = '재수행 설정 = 수행 없음 · VM 환경설정 🔁 VMO 보완 뒤 재수행';
/** 개입 1건 기록. o = { kind, rule, inc, screen, job, runId, target, by, premise, undo }. 반환 = 장부 ID(꺼져 있으면 '') */
function note(o) {
  try {
    if (!ready() || cfg().ledgerEnabled === false || !o || !o.kind) return '';
    const ms = Date.now(); const d = new Date(ms); const t = x => String(x).padStart(2, '0');
    const id = `I${d.getFullYear()}${t(d.getMonth() + 1)}${t(d.getDate())}_${t(d.getHours())}${t(d.getMinutes())}${t(d.getSeconds())}_${++seq}`;
    const row = { id, at: nowLocal(ms), ms, kind: o.kind, rule: o.rule || '', inc: o.inc || '', screen: String(o.screen || '').toUpperCase(), job: o.job || '', runId: o.runId || '', target: o.target == null ? '' : String(o.target).slice(0, 200), by: o.by || 'VMO', premise: o.premise || {}, undo: o.undo || null,
      check: { dueMs: ms + cfg().checkDelayMin * 60000, verdict: CHECKERS[o.kind] ? '' : 'n/a' } };
    fs.mkdirSync(orchDir(), { recursive: true }); fs.appendFileSync(file(), JSON.stringify(row) + '\n', 'utf8');
    if (orchEv) { try { orchEv.emit('vmo.intervene', { id, kind: row.kind, rule: row.rule, inc: row.inc, screen: row.screen, job: row.job, by: row.by }); } catch { /* 사건 기록 실패는 장부에 영향 없음 */ } }
    return id;
  } catch (e) { errlog.note('orch-ledger', 'note', e); return ''; }
}

// ── 사후 검증 ── 반환 { v, why } 또는 null(아직 판정할 수 없음 · 다음 tick 에 다시)
const runStartMs = runId => { const m = /_(\d{12,})(?:_|$)/.exec(String(runId || '')); return m ? Number(m[1]) : 0; }; // 실행 ID = <화면>_<체인 시작 ms>
const CHECKERS = {
  stop(row, x) {
    const pm = row.premise || {}; const stopMs = Number(pm.stopMs) || 0; let startMs = runStartMs(pm.runId || row.runId);
    const cs = x.events.find(e => e.type === 'chain.start' && e.runId === (pm.runId || row.runId)); if (cs && cs.ms) startMs = cs.ms;
    if (!stopMs || !startMs) return { v: 'unknown', why: `중지 시각 또는 체인 시작 시각을 알 수 없음(runId ${pm.runId || row.runId || '-'})` };
    if (startMs > stopMs + 2000) return { v: 'false', why: `멈춘 체인 ${pm.runId || row.runId} 은 중지(${nowLocal(stopMs).slice(11, 19)}) 뒤 ${nowLocal(startMs).slice(11, 19)} 에 시작한 새 실행(재개 · 다시 실행). '중지된 체인이 계속 실행' 전제가 틀림` };
    return { v: 'ok', why: `체인 시작 ${nowLocal(startMs).slice(11, 19)} 이 중지 ${nowLocal(stopMs).slice(11, 19)} 앞` };
  },
  requeue(row, x) {
    const scr = row.screen; const after = x.events.filter(e => (e.ms || 0) > row.ms && String(e.screen || '').toUpperCase() === scr);
    const again = x.incidents.find(i => i.rule === 'R13' && (i.screen || '') === scr && (i.ms || 0) > row.ms && i.id !== row.inc);
    if (again) return { v: 'noeffect', why: `다시 실행한 뒤에도 화면 진입 실패 반복(${again.id})` };
    if (after.some(e => e.type === 'step.end' && e.status === 'OK')) return { v: 'ok', why: '다시 실행한 뒤 단계 OK 기록 있음' };
    return x.now - row.ms > x.cfg.checkGiveUpMin * 60000 ? { v: 'unknown', why: `다시 실행 뒤 ${x.cfg.checkGiveUpMin}분 안에 단계 결과 없음` } : null;
  },
  lockdel(row, x) {
    const pid = Number((row.premise || {}).lockPid) || 0; if (!pid) return { v: 'unknown', why: '잠금 주인 PID 기록 없음' };
    return x.pidAlive(pid) ? { v: 'false', why: `지운 잠금 ${row.target} 의 주인 PID ${pid} 가 살아 있음. '주인 없는 잠금' 전제가 틀림` } : { v: 'ok', why: `잠금 주인 PID ${pid} 없음 확인` };
  },
  server(row, x) {
    const port = Number((row.premise || {}).port) || 0; const svc = D.serverSvc; if (!svc || !port) return { v: 'unknown', why: '서버 상태를 읽을 수 없음' };
    let st = null; try { st = svc.stateList().find(s => Number(s.port) === port); } catch { st = null; }
    return st && st.state === 'up' ? { v: 'ok', why: `포트 ${port} 응답` } : { v: 'noeffect', why: `재기동 뒤 포트 ${port} 상태 ${st ? st.state : '없음'}` };
  },
  resolve(row, x) {
    const pm = row.premise || {}; const again = x.incidents.find(i => pm.sig && i.sig === pm.sig && (i.ms || 0) > row.ms && !i.reload && i.id !== row.inc);
    if (again) return { v: 'false', why: `자동 해결로 닫은 뒤 같은 사건이 다시 발생(${again.id}). '${pm.why || '해결'}' 전제가 틀림` };
    return x.now - row.ms > 30 * 60000 ? { v: 'ok', why: '30분 동안 같은 사건 없음' } : null;
  },
  apply(row, x) {
    const imp = D.improve || mod('orch-improve'); const pr = imp && imp.get ? imp.get((row.premise || {}).proposal) : null; if (!pr) return { v: 'unknown', why: '개선안 기록 없음' };
    if (pr.reverted || pr.status !== 'applied') return { v: 'noeffect', why: `개선안 상태 ${pr.status}${pr.reverted ? '(되돌림)' : ''}` };
    return x.now - row.ms > 30 * 60000 ? { v: 'ok', why: '반영 뒤 30분 동안 되돌림 없음' } : null;
  },
};

// ── 관찰 모드 ──
function modes() { try { const mt = fs.statSync(modeFile()).mtimeMs; if (mt !== modeMt) { modeCache = readJson(modeFile(), {}); modeMt = mt; } } catch { modeCache = {}; modeMt = -1; } return modeCache || {}; }
/** 그 규칙이 관찰 모드인가(사건은 올리되 자가 복구 · 에이전트 · 작업 일시 중지 같은 개입을 하지 않음) */
function observing(rule) { try { if (!ready() || !rule) return false; const m = modes()[rule]; return !!(m && m.mode === 'observe'); } catch { return false; } }
function setMode(rule, o) { const m = Object.assign({}, modes()); if (o) m[rule] = o; else delete m[rule]; try { fs.mkdirSync(orchDir(), { recursive: true }); fs.writeFileSync(modeFile(), JSON.stringify(m, null, 1), 'utf8'); } catch (e) { errlog.note('orch-ledger', 'setMode', e); } modeCache = m; try { modeMt = fs.statSync(modeFile()).mtimeMs; } catch { modeMt = -1; } }
/** 관찰 모드 해제. by = '사용자' 또는 'VMO(개선안 반영 완료)' */
function release(rule, by) { const m = modes()[rule]; if (!m) return false; setMode(rule, null); if (orchEv) { try { orchEv.emit('vmo.rulemode', { rule, mode: 'active', by: by || '' }); } catch { /* 기록만 */ } } return true; }

/** 판정 기록 + 사건에 판정 줄 추가 */
function verdict(id, v, why) {
  const rows = readAll(); const row = rows.find(r => r.id === id); if (!row) return null;
  row.check = Object.assign({}, row.check, { verdict: v, at: nowLocal(), why: String(why || '').slice(0, 500) }); writeAll(rows);
  if (orchEv) { try { orchEv.emit('vmo.verdict', { id, kind: row.kind, rule: row.rule, inc: row.inc, screen: row.screen, verdict: v, why: String(why || '').slice(0, 300) }); } catch { /* 기록만 */ } }
  const w = watchM(); if (w && row.inc) { try { w.update(row.inc, { vmoCheck: { entry: id, verdict: v, at: row.check.at } }, { by: 'VMO 사후 검증', what: `${KIND_KO[row.kind] || row.kind} 판정: ${VERDICT_KO[v] || v}. ${String(why || '').slice(0, 300)}` }); } catch (e) { errlog.note('orch-ledger', 'verdictInc', e); } }
  return row;
}

/** 오판 확정 뒤 처리: 피해 복구 → 원 사건 falsePositive → R15 → 개선안 → 관찰 모드 */
function onFalse(row) {
  const c = cfg(); const w = watchM(); const done = [];
  // 1 피해 복구
  try {
    const u = row.undo || {};
    if (u.how === 'resume' && u.prog && u.prog.runId) {
      const pf = path.join(orchDir(), 'chain_progress', `${u.prog.runId}.json`);
      if (!fs.existsSync(pf)) { const rec = Object.assign({}, u.prog, { interruptedAt: nowLocal(), resumeFrom: (u.prog.cur || 0) + 1, updatedMs: Date.now(), why: `VMO ${row.rule} 오판으로 중지됨(${row.inc || row.id}). ${(u.prog.cur || 0) + 1}단계부터 재개 가능` }); fs.mkdirSync(path.dirname(pf), { recursive: true }); fs.writeFileSync(pf, JSON.stringify(rec), 'utf8'); done.push(`재개 기록 되살림(${(u.prog.cur || 0) + 1}단계부터)`); }
      if (row.job) { const jr = D.jobRunner || mod('job-runner'); if (jr && jr.restoreInterrupted && jr.restoreInterrupted(row.job, row.screen, `VMO 오판(${row.rule})으로 중지됨. ${(u.prog.cur || 0) + 1}단계부터 재개 가능`)) { done.push(`VMW 작업 ${row.job} 재개 가능으로 되돌림`); if (rerunAllowed()) { const hz = jr.healCount ? jr.healCount(row.job, row.screen) : 0; if (hz >= rerunMax()) done.push(`재수행 한도 ${rerunMax()}회 도달. 재개는 사용자`); else if (jr.start && (jr.noteHeal ? jr.noteHeal(row.job, row.screen) : true) && jr.start(row.job)) done.push(`작업 재개 시작(재수행 ${hz + 1}/${rerunMax()})`); } else done.push(`재개는 사용자(${RERUN_NOTE})`); } }
    } else if (u.how === 'reopen' && row.inc && w) { w.update(row.inc, { status: u.status || 'open', notice: false, reload: '' }, { by: 'VMO 사후 검증', what: '오판으로 닫은 사건 다시 열림' }); done.push('사건 다시 열림'); }
    else done.push('되돌릴 수 있는 것 없음(기록만)');
  } catch (e) { errlog.note('orch-ledger', 'undo', e); done.push(`복구 실패 ${e.message}`); }
  const why = (row.check && row.check.why) || '';
  // 2 원 사건
  if (w && row.inc && !(row.undo && row.undo.how === 'reopen')) { try { w.update(row.inc, { status: 'resolved', falsePositive: true, resolvedBy: 'VMO 사후 검증' }, { by: 'VMO 사후 검증', grade: 'A', what: `감시 오판으로 확정. ${done.join(' · ')}` }); } catch (e) { errlog.note('orch-ledger', 'markInc', e); } }
  // 3 개선안(자가 보완 · fix)
  let propId = '';
  try {
    const imp = D.improve || mod('orch-improve'); const day = nowLocal().slice(0, 10).replace(/-/g, '');
    const a = imp && imp.add ? imp.add({ title: `${row.rule} 오판 정정(${KIND_KO[row.kind] || row.kind}): ${why}`.slice(0, 190), impact: 'fix', check: 'S14', selfKey: `S14|${row.rule}|false`, sig: `fp|${row.rule}|${(row.premise || {}).key || row.kind}`,
      evidence: `개입 장부 .vibe/orch/interventions.jsonl ${row.id}(${row.at}) · 사건 ${row.inc || '-'} · 화면 ${row.screen || '-'} · 전제 ${JSON.stringify(row.premise || {}).slice(0, 300)} · 사후 검증 ${why}`,
      targets: [RULE_FILE[row.rule] || 'tools/VibeManager/orch-watch.js', `tools/VibeManager/test/t_fp_${String(row.rule).toLowerCase()}_${day}.js`],
      before_after: `변경 전: ${row.rule} 이 위 전제를 확인하지 않고 ${KIND_KO[row.kind] || row.kind} 함 → 변경 후: 개입 전에 그 전제를 확인하고, 전제가 틀리면 개입하지 않음`,
      verify: `개입 장부의 실제 순서(.vibe/orch/events.jsonl 의 해당 화면 사건 줄)를 그대로 넣는 재현 시험 test/t_fp_${String(row.rule).toLowerCase()}_${day}.js 추가: 같은 순서에서 ${row.rule} 사건 0건, 정상 경우에는 사건 1건. node tools/VibeManager/test/run_all.js 통과`,
      rollback: '대상 파일을 반영 전 백업으로 되돌림',
      plain: { what: `VMO 가 정상 실행을 잘못 건드린 ${row.rule} 판단을 고침`, risk: '판단 조건이 좁아져 실제 문제를 늦게 잡을 수 있음(재현 시험으로 정상 경우 확인)', undo: 'VMO Fixes 탭의 되돌리기' } }, 'self') : null;
    propId = (a && (a.id || a.dup)) || '';
  } catch (e) { errlog.note('orch-ledger', 'proposal', e); }
  // 4 관찰 모드(오판이 observeAfterFalse 건 이상이면)
  const falses = readAll().filter(r => r.rule === row.rule && r.check && r.check.verdict === 'false' && Date.now() - r.ms < c.interventionDays * 86400000).length;
  let obs = false; if (row.rule && falses >= Math.max(1, c.observeAfterFalse)) { setMode(row.rule, { mode: 'observe', since: nowLocal(), why: why.slice(0, 300), entry: row.id, proposal: propId }); obs = true; if (orchEv) { try { orchEv.emit('vmo.rulemode', { rule: row.rule, mode: 'observe', entry: row.id, proposal: propId }); } catch { /* 기록만 */ } } }
  // 5 사건 R15
  if (w) { try { w.raise('R15', { screen: row.screen, sig: `R15|${row.rule}|${row.id}`, title: `VMO 개입 오판. ${row.rule} ${KIND_KO[row.kind] || row.kind}${row.screen ? ` ${row.screen}` : ''}`, detail: [why, `조치: ${done.join(' · ')}`, propId ? `개선안 ${propId}` : '', obs ? `${row.rule} 관찰 모드(사건은 올리되 개입하지 않음 · 개선안 반영 완료 때 해제)` : ''].filter(Boolean).join(String.fromCharCode(10)), evidence: { entry: row.id, rule: row.rule, inc: row.inc, kind: row.kind, proposal: propId, observe: obs, undo: done } }); } catch (e) { errlog.note('orch-ledger', 'raiseR15', e); } }
  return { undo: done, proposal: propId, observe: obs };
}

/** 주기 실행(orch-selfcheck tick 에서 부름): 기한이 된 개입 사후 검증 · 사용자 반응 신호 · 관찰 모드 해제. 반환 { checked, falses, released } */
function tick(now0) {
  const res = { checked: 0, falses: 0, released: [] };
  try {
    if (!ready() || cfg().ledgerEnabled === false) return res;
    const now = now0 || Date.now(); const c = cfg(); const rows = readAll(); if (!rows.length && !Object.keys(modes()).length) return res;
    const w = watchM(); const st = stateM();
    const x = { now, cfg: c, events: D.events ? D.events() : (orchEv ? orchEv.tail(8 * 1024 * 1024) : []), incidents: w ? w.list(400) : [], pidAlive: pid => (st && st.pidAlive ? st.pidAlive(pid) : false) };
    for (const row of rows) {
      if (!row.check || row.check.verdict || (row.check.dueMs || 0) > now) continue;
      const fn = CHECKERS[row.kind]; if (!fn) continue; let r = null; try { r = fn(row, x); } catch (e) { errlog.note('orch-ledger', `check ${row.kind}`, e); r = { v: 'unknown', why: `검증 오류 ${e.message}` }; }
      if (!r) { if (now - row.ms > c.checkGiveUpMin * 60000) r = { v: 'unknown', why: `${c.checkGiveUpMin}분 안에 판정할 근거 없음` }; else continue; }
      const done = verdict(row.id, r.v, r.why); res.checked++;
      if (r.v === 'false' && done) { res.falses++; onFalse(done); }
    }
    // 사용자 반응 신호: VMO 가 멈춘 화면을 사용자가 userReactMin 안에 다시 실행·재개 → 오판 의심으로 표시(판정은 바꾸지 않음 · S14 가 경고)
    const rows2 = readAll(); let touched = false;
    for (const row of rows2) {
      if ((row.kind !== 'stop' && row.kind !== 'kill') || row.react || now - row.ms > 24 * 3600000) continue;
      const again = x.events.find(e => (e.type === 'chain.start' || e.type === 'job.item.start') && String(e.screen || '').toUpperCase() === row.screen && (e.ms || 0) > row.ms && (e.ms || 0) - row.ms <= c.userReactMin * 60000 && e.runId !== row.runId);
      if (again) { row.react = { at: nowLocal(again.ms), what: `개입 ${Math.round((again.ms - row.ms) / 60000)}분 뒤 같은 화면 다시 실행` }; touched = true; }
    }
    if (touched) writeAll(rows2);
    // 관찰 모드 해제: 그 규칙의 오판 개선안이 반영 완료
    const imp = D.improve || mod('orch-improve');
    for (const [rule, m] of Object.entries(modes())) { if (!m || m.mode !== 'observe' || !m.proposal || !imp || !imp.get) continue; const pr = imp.get(m.proposal); if (pr && pr.status === 'applied' && !pr.reverted) { release(rule, 'VMO(개선안 반영 완료)'); res.released.push(rule); } }
  } catch (e) { errlog.note('orch-ledger', 'tick', e); }
  return res;
}

/** 최근 days 일 규칙별 집계. { days, total, byRule: { rule: { n, ok, false, noeffect, unknown, pending, na, react } }, falses: [...], overdue, observe: { rule: {...} } } */
function stats(days) {
  const c = ready() ? cfg() : DEF; const since = Date.now() - (days || c.interventionDays) * 86400000; const rows = ready() ? readAll().filter(r => (r.ms || 0) >= since) : [];
  const byRule = {}; const falses = []; let overdue = 0; const now = Date.now();
  for (const r of rows) {
    const k = r.rule || r.kind; const b = byRule[k] || (byRule[k] = { n: 0, ok: 0, false: 0, noeffect: 0, unknown: 0, pending: 0, na: 0, react: 0 }); b.n++;
    const v = (r.check && r.check.verdict) || ''; if (v === 'n/a') b.na++; else if (!v) { b.pending++; if ((r.check.dueMs || 0) + c.checkGiveUpMin * 60000 < now) overdue++; } else b[v] = (b[v] || 0) + 1;
    if (r.react) b.react++;
    if (v === 'false') falses.push({ id: r.id, at: r.at, rule: r.rule, kind: r.kind, screen: r.screen, inc: r.inc, why: r.check.why });
  }
  return { days: days || c.interventionDays, total: rows.length, byRule, falses, overdue, observe: ready() ? Object.assign({}, modes()) : {} };
}
/** 사건 ID → 그 사건의 개입 목록(화면 표시용) */
function byInc(inc) { return readAll().filter(r => r.inc === inc); }

module.exports = { rerunAllowed, rerunMax, RERUN_NOTE, init, ready, note, verdict, tick, stats, byInc, observing, release, setMode, onFalse, readAll, CHECKERS, KIND_KO, VERDICT_KO, DEF };
