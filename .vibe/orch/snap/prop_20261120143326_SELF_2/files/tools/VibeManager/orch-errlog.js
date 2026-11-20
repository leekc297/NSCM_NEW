// 2026-11-19 VMO 자가진단 Q1: VM 실행 오류 기록 — .vibe/orch/vm_errors.jsonl 에 한 줄 1건(JSON).
//   종전에는 확장 오류가 Output 채널에만 남고 웹뷰 오류·감시기 안 오류는 어디에도 남지 않았다(빈 catch 219곳). 자가진단(orch-selfcheck.js S5)이 이 파일을 읽는다.
//   줄 형식: { at, ms, mod, fn, msg, code, stack[앞 5줄], sig, skipped(직전 기록 뒤 같은 서명으로 건너뛴 수) }
//   같은 서명은 DEDUPE_MS(60초)에 1건만 기록한다. 기록 실패는 본 작업을 멈추지 않는다.
//   파일이 MAX_BYTES 를 넘으면 vm_errors_<yyyymmdd_hhmmss>.jsonl 로 이름을 바꾸고 새 파일에 이어 쓴다.
'use strict';
const fs = require('fs');
const path = require('path');

const MAX_BYTES = 8 * 1024 * 1024;
const DEDUPE_MS = 60000;
let dir = '';
const last = new Map();       // sig → { ms, skipped }
const listeners = new Set();  // fn(record)

const two = n => String(n).padStart(2, '0');
function nowLocal(ms) {
  const d = new Date(ms == null ? Date.now() : ms); const off = -d.getTimezoneOffset(); const sg = off >= 0 ? '+' : '-'; const ab = Math.abs(off);
  return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())}T${two(d.getHours())}:${two(d.getMinutes())}:${two(d.getSeconds())}${sg}${two(Math.floor(ab / 60))}:${two(ab % 60)}`;
}

/** vibeDir = <프로젝트>/.vibe · 여러 번 불러도 됨 */
function init(vibeDir) {
  if (!vibeDir) return '';
  const d = path.join(vibeDir, 'orch');
  try { fs.mkdirSync(d, { recursive: true }); dir = d; } catch { }
  return dir;
}
function file() { return dir ? path.join(dir, 'vm_errors.jsonl') : ''; }

/** 오류 문구 → 반복 비교용 서명(경로 · 화면 ID · 시각 · 숫자를 지운다) */
function signature(mod, fn, msg) {
  const first = String(msg || '').split(/\r?\n/).find(s => s.trim()) || '';
  const norm = first
    .replace(/[A-Za-z]:[\\/][^\s'"|]+/g, '<path>')
    .replace(/\b[A-Z]{2,4}\d{4}[A-Z]?\b/g, '<ID>')
    .replace(/\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}(?::\d{2})?/g, '<time>')
    .replace(/\d+(?:\.\d+)?/g, 'N')
    .replace(/\s+/g, ' ').trim().slice(0, 200);
  return `${mod}.${fn} | ${norm}`;
}

function rotate(f) {
  try {
    const st = fs.statSync(f); if (st.size < MAX_BYTES) return;
    const d = new Date(); const tag = `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}_${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`;
    fs.renameSync(f, path.join(dir, `vm_errors_${tag}.jsonl`));
  } catch { }
}

/** 오류 1건 기록. err = Error | 문자열. extra = 덧붙일 필드. 반환 = 기록한 객체(60초 안 같은 서명이면 null) */
function note(mod, fn, err, extra) {
  try {
    const ms = Date.now();
    const msg = String((err && err.message) || err || '').slice(0, 600);
    const sig = signature(mod, fn, msg);
    const prev = last.get(sig);
    if (prev && ms - prev.ms < DEDUPE_MS) { prev.skipped++; return null; }
    const stack = String((err && err.stack) || '').split(/\r?\n/).slice(1, 6).map(s => s.trim().slice(0, 240));
    const rec = Object.assign({ at: nowLocal(ms), ms, mod: String(mod), fn: String(fn), msg, code: (err && err.code) || '', stack, sig, skipped: prev ? prev.skipped : 0 }, extra || {});
    last.set(sig, { ms, skipped: 0 });
    if (last.size > 500) { for (const [k, v] of last) if (ms - v.ms > 3600000) last.delete(k); }
    const f = file();
    if (f) { rotate(f); fs.appendFileSync(f, JSON.stringify(rec) + '\n', 'utf8'); }
    for (const l of listeners) { try { l(rec); } catch { } }
    return rec;
  } catch { return null; }
}

/** 최근 기록 읽기(파일 끝에서 maxBytes 만큼). 깨진 줄은 건너뛴다 */
function tail(maxBytes) {
  const f = file(); if (!f) return [];
  try {
    const st = fs.statSync(f); const n = Math.min(st.size, maxBytes || 2 * 1024 * 1024);
    const fd = fs.openSync(f, 'r'); const buf = Buffer.alloc(n);
    try { fs.readSync(fd, buf, 0, n, st.size - n); } finally { fs.closeSync(fd); }
    const lines = buf.toString('utf8').split(/\r?\n/); if (n < st.size) lines.shift();
    const out = [];
    for (const ln of lines) { if (!ln.trim()) continue; try { out.push(JSON.parse(ln)); } catch { } }
    return out;
  } catch { return []; }
}

/** sinceMs 뒤 기록을 서명별로 묶는다. 반환 = [{ sig, mod, fn, msg, count(건너뛴 수 포함), firstAt, lastAt, lastMs, stack }] 횟수 많은 순 */
function stats(sinceMs) {
  const by = new Map();
  for (const r of tail(4 * 1024 * 1024)) {
    if (sinceMs && r.ms < sinceMs) continue;
    const g = by.get(r.sig) || { sig: r.sig, mod: r.mod, fn: r.fn, msg: r.msg, count: 0, firstAt: r.at, firstMs: r.ms, lastAt: r.at, lastMs: r.ms, stack: r.stack || [] };
    g.count += 1 + (r.skipped || 0); g.lastAt = r.at; g.lastMs = r.ms; g.msg = r.msg; if (r.stack && r.stack.length) g.stack = r.stack;
    by.set(r.sig, g);
  }
  return [...by.values()].sort((a, b) => b.count - a.count);
}

/** 같은 프로세스 안 구독. 반환 = 해제 함수 */
function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }

/** 웹뷰 스크립트에 넣는 오류 보고 코드. api = acquireVsCodeApi() 결과를 담은 변수 이름. 호스트는 type 'vmerr' 메시지를 fromWebview() 로 넘긴다 */
function webviewSnippet(api) {
  return `(function(){var n=0;function rep(k,m,f,l,c,s){if(n++>20)return;try{${api}.postMessage({type:'vmerr',kind:k,msg:String(m||'').slice(0,400),src:String(f||'').split('/').pop().slice(0,80),line:l||0,col:c||0,stack:String(s||'').slice(0,800)});}catch(_){}}`
    + `window.addEventListener('error',function(e){rep('error',e.message,e.filename,e.lineno,e.colno,e.error&&e.error.stack);});`
    + `window.addEventListener('unhandledrejection',function(e){var r=e.reason||{};rep('rejection',r.message||r,'',0,0,r.stack);});})();`;
}
/** 웹뷰가 보낸 vmerr 메시지 기록. view = 'workbench' | 'orchestra' | 'jobs' */
function fromWebview(view, m) {
  if (!m) return null;
  const e = new Error(String(m.msg || '')); e.stack = `Error\n${String(m.stack || '').split(/\r?\n/).slice(0, 6).join('\n')}`;
  return note(`webview:${view}`, m.kind || 'error', e, { line: m.line || 0, col: m.col || 0 });
}

module.exports = { init, note, tail, stats, on, file, signature, webviewSnippet, fromWebview, DEDUPE_MS };
