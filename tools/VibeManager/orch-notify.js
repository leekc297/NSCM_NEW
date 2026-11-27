// 2026-11-26 개선안 20261126164445_VISION_3: VMO 알림을 한곳에서 내보낸다.
//   근거: extension.js 에서 VMO 모듈 5개(orch-agent, orch-heal, orch-improve, orch-vision, orch-selfcheck)가 각자 알림을 띄웠고 묶음, 간격 제한이 없었음.
//         11-25 00:00~11-26 10:55 반영 89건, 실패 8건이 건마다 알림 1건(vision meta).
//   종류(kind): applied = 반영 완료(windowMs 동안 모아 '개선안 반영 N건, 실패 M건' 1건) · apply-failed = 반영 실패(바로)
//               incident = 사건(바로) · selfcheck = 자가진단 · approval = 승인 대기 · 그 밖 = 바로
//   같은 문구는 windowMs 안에 1번만 보낸다(반영 완료 묶음 제외).
//   기록: .vibe/orch/events.jsonl 에 notify.shown(보낸 알림), notify.merged(묶거나 거른 알림) 1줄씩.
//   끄기: harness.json orch.notifyMerge false = 종전처럼 건마다 바로 보냄(기록은 남김).
'use strict';
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { }

const DEF_WINDOW_MS = 10 * 60000;
let show = null, windowMs = DEF_WINDOW_MS, mergeOn = () => true, now = () => Date.now();
let batch = null; // { startMs, applied: Map(key → text), failed: Map(key → text), timer, button, open }
const recent = new Map(); // text → 마지막 보낸 ms

function emit(type, data) { if (!orchEv) return; try { orchEv.emit(type, data); } catch (ex) { errlog.note('orch-notify', 'emit', ex); } }
/** opts.show(text, { button, open, kind }) = 실제 표시(VS Code 알림). opts.windowMs = 묶음, 중복 간격. opts.merge() = 묶음 켬 여부. opts.now = 시험용 시계 */
function init(opts) {
  opts = opts || {}; show = opts.show || null; windowMs = Number(opts.windowMs) > 0 ? Number(opts.windowMs) : DEF_WINDOW_MS;
  mergeOn = typeof opts.merge === 'function' ? opts.merge : () => true; if (typeof opts.now === 'function') now = opts.now;
}
function out(kind, text, o, merged) {
  emit('notify.shown', { kind, text: String(text).slice(0, 300), merged: merged || 0 });
  if (!show) return; try { show(String(text), { button: (o && o.button) || '', open: (o && o.open) || '', kind }); } catch (ex) { errlog.note('orch-notify', 'show', ex); }
}
/** 묶음 보내기. 반영 완료 0건이면 보내지 않음(실패는 이미 바로 보냄). 반환 = 보낸 문구 또는 '' */
function flush() {
  const b = batch; batch = null; if (!b) return ''; if (b.timer) { clearTimeout(b.timer); b.timer = null; }
  if (!b.applied.size) return '';
  const text = `Vibe_Manager VMO. 개선안 반영 ${b.applied.size}건, 실패 ${b.failed.size}건(최근 ${Math.max(1, Math.round(windowMs / 60000))}분)`;
  out('applied', text, { button: b.button, open: b.open }, b.applied.size); return text;
}
/** kind = 종류, text = 문구, o = { key(같은 일 구분, 예: 개선안 id), button, open } . 반환 'shown' | 'merged' | 'dup' */
function send(kind, text, o) {
  o = o || {}; kind = kind || 'other'; const t = String(text || '').trim(); if (!t) return 'dup';
  const key = String(o.key || t);
  if (!mergeOn()) { out(kind, t, o, 0); return 'shown'; }
  if (kind === 'applied' || kind === 'apply-failed') {
    if (!batch) { batch = { startMs: now(), applied: new Map(), failed: new Map(), timer: null, button: o.button || '', open: o.open || '' }; batch.timer = setTimeout(() => { try { flush(); } catch (ex) { errlog.note('orch-notify', 'flush', ex); } }, windowMs); if (batch.timer.unref) batch.timer.unref(); }
    if (kind === 'applied') { const had = batch.applied.has(key); batch.applied.set(key, t); emit('notify.merged', { kind, text: t.slice(0, 300), reason: had ? 'same-key' : 'batch' }); return 'merged'; }
    if (o.key && batch.failed.has(key)) { emit('notify.merged', { kind, text: t.slice(0, 300), reason: 'same-key' }); return 'dup'; } // 같은 개선안 실패를 orch-improve, orch-selfcheck 가 각각 알림
    batch.failed.set(key, t);
  }
  const last = recent.get(t); const n = now();
  if (last != null && n - last < windowMs) { emit('notify.merged', { kind, text: t.slice(0, 300), reason: 'dup' }); return 'dup'; }
  recent.set(t, n); for (const [k, v] of recent) if (n - v >= windowMs) recent.delete(k);
  out(kind, t, o, 0); return 'shown';
}
/** 종전 notifier(text) 모양에서 종류 추정: 반영 실패 → apply-failed, 반영 완료 → applied, 승인 대기·등록 → approval */
function kindOf(text) {
  const s = String(text || '');
  if (/반영 실패|되돌림\)/.test(s)) return 'apply-failed';
  if (/반영 완료|자가 보완 반영:/.test(s)) return 'applied';
  if (/승인 대기|건 등록/.test(s)) return 'approval';
  return 'other';
}
function pending() { return batch ? { applied: batch.applied.size, failed: batch.failed.size, startMs: batch.startMs } : null; }
function dispose() { if (batch && batch.timer) clearTimeout(batch.timer); batch = null; recent.clear(); show = null; }

module.exports = { init, send, flush, kindOf, pending, dispose, DEF_WINDOW_MS };
