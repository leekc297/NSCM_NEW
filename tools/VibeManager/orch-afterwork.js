'use strict';
// 2026-11-26 사용자 지시('작업 종료 시 개선항목 찾아서 진행을 자동으로 진행되도록 해주세요'):
//   VM 작업(체인 chain.end · 작업 목록 job.end)이 끝나면 VMO 가 스스로 개선 항목을 찾고 진행한다.
//   ① 검사기 판정 결함 스캔(checker_defect_scan.py) → 새 항목만 진단(orch-checkerscan.maybeDiagnose · 간격 afterWorkDiagGapMin)
//   ② 방금 끝난 작업을 주제로 컨설팅 검토(orch-consult.run · 간격 afterWorkConsultGapMin) — 개선안은 '컨설팅:' 머리말로 등록
//   ③ 올라온 개선안은 기존 자동 반영 경로(orch-selfcheck.autoApplyNext · autoEligible · coreAutoApply)로 진행. 승인 대상(실행 hook·settings·DB 객체 등)은 그대로 승인 대기
//   여러 체인이 이어 끝나면 마지막 종료 뒤 afterWorkDelaySec 동안 새 종료·실행 중 체인이 없을 때 한 번만 돈다. 사용자가 중지한 작업(stopped·aborted)은 건너뜀
//   설정 harness.json orch: afterWorkEnabled(기본 true) · afterWorkDelaySec(90) · afterWorkDiagGapMin(30) · afterWorkConsultGapMin(60)
//   기록 .vibe/orch/afterwork/last.json · history.jsonl
const fs = require('fs'); const path = require('path');
const errlog = require('./orch-errlog');
const DEF = { afterWorkEnabled: true, afterWorkDelaySec: 90, afterWorkDiagGapMin: 30, afterWorkConsultGapMin: 60 };
let getPaths = null, opts = {}, unsub = null, timer = null, pending = [], running = null;
const P = () => getPaths();
const mod = n => { if (opts.mods && opts.mods[n]) return opts.mods[n]; try { return require('./' + n); } catch (e) { errlog.note('orch-afterwork', `require ${n}`, e); return null; } };
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return d; } };
const dir = () => path.join(P().vibeDir, 'orch', 'afterwork');
const nowLocal = () => { const d = new Date(); const z = n => String(n).padStart(2, '0'); return `${d.getFullYear()}-${z(d.getMonth() + 1)}-${z(d.getDate())} ${z(d.getHours())}:${z(d.getMinutes())}:${z(d.getSeconds())}`; };
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); return Object.assign({}, DEF, (h && h.orch) || {}); }
function meta() { return readJson(path.join(dir(), 'last.json'), {}); }
function save(m) {
  try { fs.mkdirSync(dir(), { recursive: true }); fs.writeFileSync(path.join(dir(), 'last.json'), JSON.stringify(m, null, 1)); fs.appendFileSync(path.join(dir(), 'history.jsonl'), JSON.stringify(m) + '\n'); } catch (e) { errlog.note('orch-afterwork', 'save', e); }
}

/** 종료 사건 → 처리 대상인가(사용자 중지·창 종료는 빼고) */
function wants(ev) {
  if (!ev || (ev.type !== 'chain.end' && ev.type !== 'job.end')) return false;
  if (ev.type === 'chain.end') return !(ev.aborted || ev.stopped);
  return !/^(interrupted|stopped|paused|cancel)/i.test(String(ev.status || ''));
}

/** 끝난 작업들을 컨설팅 주제 문장으로 */
function topicOf(evs) {
  const parts = evs.slice(-5).map(e => {
    if (e.type === 'job.end') { const c = e.counts || {}; return `작업 목록 ${e.label || e.job || ''} 끝(${e.status || ''}${c.ok != null ? ` · 성공 ${c.ok}` : ''}${c.fail != null ? ` · 실패 ${c.fail}` : ''})`; }
    const min = e.ms_run ? Math.round(e.ms_run / 60000) : null;
    return `체인 ${e.chainLabel || e.chain || ''}${e.screen ? ` 화면 ${e.screen}` : ''} ${e.ok ? '성공' : `실패(단계 ${e.failNo || '-'})`}${min != null ? ` · ${min}분` : ''}${e.hold ? ` · 보류 ${e.hold}` : ''}${e.repairs ? ` · 보완 ${e.repairs}` : ''}${e.md ? ` · 결과 ${e.md}` : ''}`;
  });
  return `방금 끝난 VM 작업: ${parts.join(' / ')}. 이 작업을 돌리며 드러난 VM·VMO·VMW 의 결함, 느린 단계, 사람이 손으로 한 일, 빠진 기능을 결과 파일·로그·events.jsonl 에서 찾아 바로 개발할 개선안으로 올린다.`;
}

/** 작업 종료 뒤 한 번 실행 — 반환 { ok, scan, diag, consult, apply } | { skipped } */
async function runOnce(evs, manual) {
  const c = cfg(); if (!manual && (c.enabled === false || c.afterWorkEnabled === false)) return { skipped: '꺼짐' };
  if (running) return { skipped: '진행 중' };
  running = (async () => {
    const m = meta(); const now = Date.now(); const out = { at: nowLocal(), ms: now, events: evs.map(e => ({ type: e.type, chain: e.chainLabel || e.chain || e.label || e.job || '', screen: e.screen || '', ok: e.ok, status: e.status })) };
    const agent = mod('orch-agent'); const imp = mod('orch-improve');
    // ① 검사기 판정 결함 스캔 + 새 항목 진단
    try {
      const cs = mod('orch-checkerscan');
      if (cs && c.checkerScanEnabled !== false) {
        if (!cs.ready()) cs.init({ paths: getPaths });
        const r = await cs.check(); out.scan = r.skip ? { skip: r.skip } : { items: r.items.length, at: r.info && r.info.at };
        if (!r.skip && agent && imp) {
          const d = await cs.maybeDiagnose({ agent, imp, cfg: Object.assign({}, c, { checkerDiagGapHours: Number(c.afterWorkDiagGapMin) / 60 }) });
          out.diag = d;
        }
      } else out.scan = { skip: 'orch-checkerscan 없음 또는 꺼짐' };
    } catch (e) { errlog.note('orch-afterwork', 'scan', e); out.scan = { error: e.message }; }
    // ② 방금 끝난 작업을 주제로 컨설팅(간격 안이면 건너뜀)
    try {
      const gap = Number(c.afterWorkConsultGapMin) * 60000;
      const cons = mod('orch-consult');
      if (!cons) out.consult = { skip: 'orch-consult 없음' };
      else if (c.consultEnabled === false) out.consult = { skip: '컨설팅 꺼짐' };
      else if (!manual && m.consultMs && now - m.consultMs < gap) out.consult = { skip: `간격 전(${Math.round((gap - (now - m.consultMs)) / 60000)}분 남음)` };
      else {
        if (!cons.ready || !cons.ready()) cons.init({ paths: getPaths, noTimer: true });
        const r = await cons.run(false, topicOf(evs)); out.consult = r; if (r && (r.ok || r.added)) out.consultMs = now;
      }
    } catch (e) { errlog.note('orch-afterwork', 'consult', e); out.consult = { error: e.message }; }
    out.consultMs = out.consultMs || m.consultMs || 0;
    // ③ 자동 반영 차례를 바로 한 번 돌린다(자동 대상만 · 승인 대상은 그대로 대기)
    try { const sc = mod('orch-selfcheck'); if (sc && sc.autoApplyNext) { const a = await sc.autoApplyNext(false); out.apply = a; } } catch (e) { errlog.note('orch-afterwork', 'apply', e); out.apply = { error: e.message }; }
    out.ok = true; save(out);
    if (opts.notify) { const n = (out.diag && out.diag.added || 0) + (out.consult && out.consult.added || 0); if (n) opts.notify(`작업 종료 뒤 개선 항목 ${n}건을 찾아 올렸습니다(자동 반영 대상은 차례대로 진행).`); }
    return out;
  })();
  try { return await running; } finally { running = null; }
}

function busyChains() { try { const st = mod('orch-state'); return st && st.snapshot ? (st.snapshot().chains || []).length : 0; } catch { return 0; } }
function schedule() {
  if (timer) clearTimeout(timer);
  const c = cfg(); const ms = Math.max(10, Number(c.afterWorkDelaySec) || 90) * 1000;
  timer = setTimeout(() => {
    timer = null;
    if (busyChains()) { schedule(); return; }   // 다른 체인이 돌고 있으면 다 끝날 때까지 미룸
    const evs = pending; pending = [];
    runOnce(evs, false).catch(e => errlog.note('orch-afterwork', 'run', e));
  }, ms);
  if (timer.unref) timer.unref();
}

function onEvent(ev) { try { if (!wants(ev)) return; pending.push(ev); schedule(); } catch (e) { errlog.note('orch-afterwork', 'event', e); } }

function init(o) {
  getPaths = o.paths; opts = o || {};
  if (unsub || o.noListen) return;
  const st = mod('orch-state'); if (st && st.on) unsub = st.on(onEvent);
}
function dispose() { if (unsub) { try { unsub(); } catch { /* 무시 */ } unsub = null; } if (timer) { clearTimeout(timer); timer = null; } pending = []; }
const ready = () => !!getPaths;

module.exports = { init, dispose, ready, runOnce, wants, topicOf, onEvent, meta, DEF };
