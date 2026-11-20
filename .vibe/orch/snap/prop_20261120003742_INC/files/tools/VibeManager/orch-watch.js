// 2026-11-19 VMO P3: 규칙 감시기 — 사건(orch-state.js)과 상태를 보고 오류·지연·반복을 '사건'으로 만든다. Claude 를 부르지 않는다.
//   사건 파일: .vibe/orch/incidents/<yyyymmdd_hhmmss>_<규칙>_<화면>.json   { id, at, rule, title, screen, sig, count, repeat, detail, evidence, status, actions[] }
//   규칙:
//     R1  프로세스·단계 실패(exit≠0)            R2  같은 오류 반복(같은 화면 2회 · 전 화면 3회 — 14일 안)
//     R3  단계 지연(같은 작업 최근 10회 중앙값의 2배 초과)   R4  대기 지연(10분 초과)
//     R5  진행 없음(로그와 E2E 추적 파일 10분 무변경 · 종료 기록 없이 사라진 실행)   R6  서버 이상(포트만 열림 60초 · 체인 실행 중 서버 꺼짐)
//     R7  claude 비정상 종료                     R8  TCP 연결 수 12,000 이상
//     R9  죽은 잠금(주인 프로세스 없음)           R10 CheckList 판정 정체(연속 2회 FAIL·미검증 행 집합 같음)
//     R11 Claude 없이 끝난 체인에 FAIL·미검증 남음
//   기준값: tools/Harness/harness.json 의 orch 절(없으면 아래 DEF). 같은 사건(규칙+서명+화면)은 dedupeMin 분 안에는 새로 만들지 않고 횟수만 올린다.
'use strict';
const fs = require('fs');
const path = require('path');
let errlog = { note() { return null; }, init() { return ''; } }; try { errlog = require('./orch-errlog'); } catch { } // 2026-11-19 자가진단 Q1: 삼키던 오류를 .vibe/orch/vm_errors.jsonl 에 남긴다
const state = require('./orch-state');
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

const DEF = { repeatLockCount: 3, repeatLockMin: 60, repeatSameScreen: 2, repeatAllScreens: 3, repeatDays: 14, stepSlowFactor: 2, stepSlowMinSec: 60, stepSlowMinSamples: 3, waitMaxSec: 600, stallSec: 600, openFailRepeat: 5, serverListenSec: 60, tcpWarn: 12000, dedupeMin: 30, tickSec: 30 };
const TITLE = { R1: '실행 실패', R2: '같은 오류 반복', R3: '단계 지연', R4: '대기 지연', R5: '진행 없음', R6: '서버 이상', R7: 'Claude 비정상 종료', R8: 'TCP 연결 수 높음', R13: '화면 진입 실패 반복', R9: '죽은 잠금', R10: 'CheckList 판정 정체', R11: 'Claude 없이 끝난 체인에 오류 남음', R12: 'VM 자가진단' }; // R12 = orch-selfcheck.js 가 올린다(2026-11-19)

let root = '', orchDir = '', incDir = '', started = false, timer = null, serverSvc = null;
let cfg = Object.assign({}, DEF);
const listeners = new Set();        // fn(incident, isNew)
const seenOnce = new Set();         // 한 번만 알리는 키(R4·R5·R9)
const stops = new Map();            // wb → 사용자 중지 시각(ms)
let lastTcpInc = 0;
let lastTickMs = 0;                // 자가진단 S7: 감시기 tick 이 도는지 확인하는 값

const two = n => String(n).padStart(2, '0');
const stamp = (ms) => { const d = new Date(ms || Date.now()); return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}_${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`; };
const readJson = (f, dflt) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return dflt; } };
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, JSON.stringify(v, null, 2), 'utf8'); return true; } catch (e) { errlog.note('orch-watch', 'writeJson', e); return false; } };
function loadCfg() { const h = readJson(path.join(root, 'tools', 'Harness', 'harness.json'), {}); cfg = Object.assign({}, DEF, (h && h.orch) || {}); return cfg; }

// ── 사건 저장·조회 ──
function list(limit) {
  let names = []; try { names = fs.readdirSync(incDir).filter(f => f.endsWith('.json')).sort().reverse(); } catch { }
  const out = []; for (const n of names.slice(0, limit || 200)) { const j = readJson(path.join(incDir, n), null); if (j) { j.file = path.join(incDir, n); out.push(j); } }
  return out;
}
function get(id) { return readJson(path.join(incDir, `${id}.json`), null); }
function save(inc) { return writeJson(path.join(incDir, `${inc.id}.json`), inc); }
/** 사건에 조치 기록 추가 · 상태 변경(open | acting | resolved | need-user | closed) */
function update(id, patch, action) {
  const inc = get(id); if (!inc) return null;
  if (inc.reload && patch && patch.status === 'need-user') patch = Object.assign({}, patch, { status: inc.status }); // 창 다시 로드로 생긴 사건 = 사용자 확인 대상 아님(2026-11-20 사용자 지시)
  Object.assign(inc, patch || {}); if (action) { inc.actions = inc.actions || []; inc.actions.push(Object.assign({ at: orchEv ? orchEv.nowLocal() : new Date().toISOString() }, action)); }
  save(inc); for (const fn of listeners) { try { fn(inc, false); } catch (ex) { errlog.note('orch-watch', 'listener', ex); } }
  return inc;
}

function raise(rule, o) {
  const now = Date.now(); const screen = String(o.screen || '').toUpperCase(); const sig = o.sig || `${rule}|${o.key || o.title || ''}`;
  // 같은 사건이 열려 있으면 횟수만 올린다
  const open = list(60).find(x => x.rule === rule && x.sig === sig && (x.screen || '') === screen && x.status !== 'closed' && x.status !== 'resolved' && now - (x.ms || 0) < cfg.dedupeMin * 60000);
  if (open) { if (o.evidence) open.evidence = o.evidence; if (o.title && /반복 \d+회/.test(o.title)) open.title = o.title; open.count = (open.count || 1) + 1; open.lastAt = orchEv ? orchEv.nowLocal(now) : ''; open.lastMs = now; if (o.detail) open.detail = o.detail; save(open); for (const fn of listeners) { try { fn(open, false); } catch (ex) { errlog.note('orch-watch', 'listener', ex); } } return open; }
  const inc = { id: `${stamp(now)}_${rule}_${screen || 'ALL'}`, at: orchEv ? orchEv.nowLocal(now) : new Date(now).toISOString(), ms: now, rule, ruleName: TITLE[rule] || rule, title: o.title || TITLE[rule] || rule, screen, sig, count: 1, repeat: o.repeat || null, detail: o.detail || '', evidence: o.evidence || {}, status: o.notice ? 'resolved' : 'open', notice: !!o.notice, actions: o.notice ? [{ at: orchEv ? orchEv.nowLocal(now) : '', by: 'VMO', what: '알림(사건 아님). Claude 조치 없음' }] : [] };
  let n = 1; while (fs.existsSync(path.join(incDir, `${inc.id}.json`))) inc.id = `${stamp(now)}_${rule}_${screen || 'ALL'}_${++n}`;
  save(inc);
  if (orchEv) orchEv.emit('incident', { id: inc.id, rule, screen, title: inc.title, sig });
  for (const fn of listeners) { try { fn(inc, true); } catch (ex) { errlog.note('orch-watch', 'listener', ex); } }
  return inc;
}

// ── R2: 서명 이력 ──
const sigFile = () => path.join(orchDir, 'sig_history.json');
function noteSig(sig, screen) {
  if (!sig) return { same: 0, all: 0 };
  const h = readJson(sigFile(), {}); const cut = Date.now() - cfg.repeatDays * 86400000;
  const arr = (h[sig] || []).filter(x => x.ms >= cut); arr.push({ ms: Date.now(), screen: screen || '' }); h[sig] = arr.slice(-50);
  for (const k of Object.keys(h)) { h[k] = h[k].filter(x => x.ms >= cut); if (!h[k].length) delete h[k]; }
  writeJson(sigFile(), h);
  return { same: arr.filter(x => x.screen === (screen || '')).length, all: arr.length, screens: [...new Set(arr.map(x => x.screen).filter(Boolean))] };
}
function failure(o) { // 실패 1건 → 반복 기준을 넘으면 R2, 아니면 R1
  const rp = noteSig(o.sig, o.screen);
  const repeated = rp.same >= cfg.repeatSameScreen || rp.all >= cfg.repeatAllScreens;
  return raise(repeated ? 'R2' : 'R1', Object.assign({}, o, { repeat: rp, title: repeated ? `같은 오류 반복 ${rp.same >= cfg.repeatSameScreen ? `${o.screen || '공통'} ${rp.same}회` : `전 화면 ${rp.all}회`} — ${o.title}` : o.title }));
}

// ── 죽은 잠금 반복 이력(.vibe/orch/lock_history.json) ──
function noteLock(l) {
  const f = path.join(orchDir, 'lock_history.json'); const h = readJson(f, {}); const cut = Date.now() - (cfg.repeatLockMin || 60) * 60000;
  let gap = null; try { const t = Date.parse(String(l.started || '').replace(' ', 'T')); if (Number.isFinite(t)) gap = Math.max(0, Math.round((Date.now() - t) / 1000)); } catch { }
  const arr = (h[l.file] || []).filter(x => x.ms >= cut && x.pid !== l.pid);
  arr.push({ ms: Date.now(), pid: l.pid, started: String(l.started || '').replace('T', ' ').slice(0, 19), gapSec: gap, args: String(l.args || '').slice(0, 200), ppid: l.ppid || null, parent: l.parent || '', chain: String(l.chain || '').slice(0, 300) });
  h[l.file] = arr.slice(-30);
  for (const k of Object.keys(h)) { h[k] = h[k].filter(x => x.ms >= Date.now() - 24 * 3600000); if (!h[k].length) delete h[k]; }
  writeJson(f, h);
  return arr;
}

// ── R3: 단계 소요 통계 ──
const statFile = () => path.join(orchDir, 'step_stats.json');
function median(a) { const s = [...a].sort((x, y) => x - y); const m = Math.floor(s.length / 2); return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2; }
function noteStep(ev) {
  const key = ev.task || ev.name; if (!key || !ev.ms_run) return;
  const st = readJson(statFile(), {}); const arr = st[key] || [];
  if (arr.length >= cfg.stepSlowMinSamples) {
    const med = median(arr);
    if (ev.ms_run > med * cfg.stepSlowFactor && ev.ms_run / 1000 >= cfg.stepSlowMinSec)
      raise('R3', { screen: ev.screen, key, sig: `R3|${key}`, title: `단계 지연. ${ev.name} ${Math.round(ev.ms_run / 1000)}초(최근 ${arr.length}회 중앙값 ${Math.round(med / 1000)}초의 ${(ev.ms_run / med).toFixed(1)}배)`, detail: `체인 ${ev.chainLabel || ev.chain} · 단계 ${ev.no} · 실행 주체 ${ev.actor}`, evidence: { runId: ev.runId, ms_run: ev.ms_run, median_ms: med, samples: arr.slice() } });
  }
  if (ev.status === 'OK' || ev.status === 'WARN') { arr.push(ev.ms_run); st[key] = arr.slice(-10); writeJson(statFile(), st); }
}

// ── R10 · R11: CheckList 결과 비교 ──
function checklistSnap(id) {
  const j = readJson(path.join(root, 'Doc', 'verify', id, 'run_verify.result.json'), null); if (!j) return null;
  const tri = readJson(path.join(root, 'Doc', 'verify', id, 'unverified_triage.json'), {});
  const s = j.summary || {};
  return { started: j.started || '', ts: j.ts || '', fail: s.FAIL || 0, review: s['판정필요'] || 0, unverified: s['미검증'] || 0, actionable: tri.actionable != null ? tri.actionable : null, issues: (j.issues || []).map(x => `${x.id}|${x.class || ''}`).sort() };
}
function checkChecklist(ev) {
  const id = String(ev.screen || '').toUpperCase(); if (!id) return;
  const cur = checklistSnap(id); if (!cur) return;
  const f = path.join(orchDir, 'checklist_prev', `${id}.json`); const prev = readJson(f, null);
  if (prev && prev.started !== cur.started && cur.issues.length && prev.issues.join(',') === cur.issues.join(',') && prev.unverified === cur.unverified)
    raise('R10', { screen: id, sig: `R10|${id}`, title: `CheckList 판정 정체. ${id} 연속 2회 FAIL ${cur.fail} · 미검증 ${cur.unverified} 행 집합 같음`, detail: `직전 실행 ${prev.started} → 이번 ${cur.started}. FAIL·미검증 행 ${cur.issues.length}개가 그대로. 처리 대상(actionable) ${prev.actionable} → ${cur.actionable}`, evidence: { result: `Doc/verify/${id}/run_verify.result.json`, fixlist: `Doc/verify/${id}/fixlist.csv`, issues: cur.issues.slice(0, 80) } });
  if (!prev || prev.started !== cur.started) writeJson(f, cur);
  if (ev.claudeRan === 0 && (cur.fail > 0 || cur.unverified > 0))
    raise('R11', { screen: id, sig: `R11|${id}|${ev.chain}`, title: `Claude 없이 끝난 체인. ${id} FAIL ${cur.fail} · 미검증 ${cur.unverified} 남음`, detail: `체인 ${ev.chainLabel}: 스크립트 단계 ${ev.scriptRan}개 실행, Claude 단계 실행 0, 건너뜀 ${ev.claudeSkipped}`, evidence: { md: ev.md, result: `Doc/verify/${id}/run_verify.result.json` } });
}

// ── 사건 → 규칙 ──
// 2026-11-20 사용자 지적: 에이전트 대화로 SCP0028, SSP0014 를 중지했는데(taskkill) 실패로 보고 사건 4건 → 에이전트가 Claude 를 3번 더 부름.
//   화면 단위 중지 표시(markUserStop)를 더한다. 에이전트 대화가 중지를 지시받으면 그 화면을 대화가 끝난 뒤 30초까지 사용자 중지로 본다
const screenStops = new Map();
function markUserStop(screens, untilMs, by) { for (const s of screens || []) if (s) screenStops.set(String(s).toUpperCase(), { until: untilMs, by: by || '' }); }
function userStopped(wb, screen) { const t = stops.get(wb); if (t && Date.now() - t < 15000) return true; const s = screen && screenStops.get(String(screen).toUpperCase()); return !!s && Date.now() <= s.until; }
function onEvent(ev) {
  try {
    if (cfg.enabled === false) return; // VMO 꺼짐(harness.json orch.enabled false) = 사건을 만들지 않는다
    const t = ev.type;
    // 2026-11-20: 2분 넘게 지난 사건 기록은 판정하지 않는다. 사건 기록 파일이 줄면 state 가 처음부터 다시 읽는데(orch-state.js tailTick), 그때 지난 실패가 새 사건으로 올라갔다
    //   (실측: 00:48:20 새 창이 18:29, 23:04, 23:18 의 claude.end 와 00:33~00:34 의 step.end 를 다시 읽어 R7 3건, R2 4건 생성)
    if (t !== 'user.stop' && ev.ms && Date.now() - ev.ms > STALE_EVENT_MS) return;
    if (t === 'user.stop') { stops.set(ev.wb, ev.ms || Date.now()); return; }
    if (t === 'proc.end' && ev.exit !== 0 && ev.exit != null && !ev.server) {
      if (userStopped(ev.wb, ev.screen)) return;
      const inChain = state.snapshot().chains.some(c => c.wb === ev.wb && c.screen === ev.screen);
      if (inChain) return;                               // 체인 안 실패는 step.end 가 판정(okCodes · verify 반영)
      failure({ screen: ev.screen, sig: ev.sig || `proc|${ev.label}`, title: `${ev.label} 실패 (exit ${ev.exit})`, detail: ev.why || '', evidence: { log: ev.log, exit: ev.exit, whySrc: ev.whySrc } });
    }
    else if (t === 'step.end') {
      noteStep(ev);
      if (ev.status === 'FAIL' && !userStopped(ev.wb, ev.screen)) failure({ screen: ev.screen, sig: ev.sig || `step|${ev.task || ev.name}`, title: `${ev.name} 실패${ev.exit != null ? ` (exit ${ev.exit})` : ''} — ${ev.chainLabel || ''}`, detail: ev.why || ev.note || '', evidence: { runId: ev.runId, task: ev.task, actor: ev.actor, failFrom: ev.failFrom, repairs: ev.repairs } });
    }
    else if (t === 'chain.end') {
      if (userStopped(ev.wb, ev.screen)) return; // 사용자(또는 사용자 지시를 받은 에이전트, VMO 자가 복구)가 멈춘 체인 = 실패 사건 없음
      if (/^checklist$/i.test(ev.chain || '') || /CheckList/i.test(ev.chainLabel || '')) checkChecklist(ev);
      else if (ev.claudeRan === 0 && ev.ok === false && !userStopped(ev.wb)) raise('R11', { screen: ev.screen, sig: `R11|${ev.screen}|${ev.chain}`, title: `Claude 없이 끝난 체인. ${ev.chainLabel} ${ev.failNo ? `${ev.failNo}단계에서 중단` : '미완료'}`, detail: `스크립트 단계 ${ev.scriptRan}개 실행, Claude 단계 실행 0, 건너뜀 ${ev.claudeSkipped}`, evidence: { md: ev.md } });
    }
    else if (t === 'claude.end' && ev.exit !== 0 && ev.exit != null) {
      if (userStopped(ev.wb)) return;
      const w = ev.stderrTail || ''; const cls = /No conversation found|session.*not found|resume/i.test(w) ? '세션 이어받기 실패' : /not logged in|authentication|401|login/i.test(w) ? '로그인 만료' : /is not recognized|ENOENT|cannot find/i.test(w) ? 'CLI 경로' : /ETIMEDOUT|ECONNRESET|fetch failed|network|EAI_AGAIN/i.test(w) ? '네트워크' : (ev.anyOutput ? '응답 중 종료' : '미분류');
      raise('R7', { screen: ev.screen, sig: `R7|${cls}`, title: `Claude 비정상 종료 (exit ${ev.exit}). ${cls}`, detail: w || '(stderr 없음)', evidence: { log: ev.log, label: ev.label, source: ev.source, cls } });
    }
    else if (t === 'server.state' && ev.source === 'poll' && ev.state === 'down' && ev.prev && ev.prev !== 'down') {
      const cs = state.snapshot().chains;
      if (cs.length) raise('R6', { screen: '', sig: `R6|down|${ev.port}`, title: `체인 실행 중 서버 꺼짐. 포트 ${ev.port}`, detail: `실행 중 체인 ${cs.map(c => `${c.screen} ${c.label}`).join(' · ')}`, evidence: { port: ev.port, chains: cs.map(c => c.runId) } });
    }
  } catch (ex) { errlog.note('orch-watch', 'onEvent', ex); }
}

// Doc/verify/<ID>/e2e/artifacts/.playwright-artifacts-<n>/traces 안 파일의 최신 수정 시각(ms). 화면 ID, 폴더, 파일이 없으면 0
function e2eTraceMs(screen) {
  const id = String(screen || '').toUpperCase(); if (!/^[A-Z0-9_]+$/.test(id)) return 0;
  const base = path.join(root, 'Doc', 'verify', id, 'e2e', 'artifacts'); let dirs = []; try { dirs = fs.readdirSync(base).filter(n => n.startsWith('.playwright-artifacts-')); } catch { return 0; }
  let max = 0;
  for (const d of dirs) { const td = path.join(base, d, 'traces'); let names = []; try { names = fs.readdirSync(td); } catch { continue; } for (const n of names) { try { const m = fs.statSync(path.join(td, n)).mtimeMs; if (m > max) max = m; } catch { } } }
  return max;
}

/** 실행 로그 끝 256KB 에서 화면 진입 실패 줄 수(tools/E2E/lib/nscm.ts openScreen 이 찍는 문구) */
function openFailCount(file) {
  try { const st = fs.statSync(file); const len = Math.min(st.size, 262144); const fd = fs.openSync(file, 'r'); const buf = Buffer.alloc(len); try { fs.readSync(fd, buf, 0, len, st.size - len); } finally { fs.closeSync(fd); } const t = buf.toString('utf8'); if (/\[진입 실패\]/.test(t)) return 999; /* 2026-11-20 A1: run_verify 진입 확인이 측정을 멈춘 경우 = 바로 사건 */ return (t.match(/화면 진입 실패로 처리/g) || []).length; } catch { return 0; /* 로그 없음 = 0회 */ }
}
/** 화면 FE 페이지 폴더의 ts, tsx 를 FE 개발 서버에 변환 요청해 오류가 나는 첫 파일을 돌려준다. { file, msg } 또는 null(오류 없음 · 서버 꺼짐 · 폴더 모름) */
async function feCompileError(screen) {
  let feUrl = 'http://127.0.0.1:5173'; try { feUrl = JSON.parse(fs.readFileSync(path.join(root, 'tools', 'E2E', 'e2e.config.json'), 'utf8').replace(/^\uFEFF/, '')).feUrl || feUrl; } catch { /* 설정 없음 = 기본 주소 */ }
  const dir = pageDirOf(root, screen); if (!dir) return null;
  const files = []; const walk = d => { let es = []; try { es = fs.readdirSync(d, { withFileTypes: true }); } catch { return; } for (const e of es) { const f = path.join(d, e.name); if (e.isDirectory()) walk(f); else if (/\.tsx?$/.test(e.name) && !/\.(test|spec|d)\.tsx?$/.test(e.name)) files.push(f); } }; walk(dir);
  for (const f of files.slice(0, 60)) {
    try {
      const r = await fetch(`${feUrl}/@fs/${f.replace(/\\/g, '/')}`, { signal: AbortSignal.timeout(8000) }); if (r.status < 500) continue;
      const t = await r.text(); const m = /"message":"((?:[^"\\]|\\.)*)"/.exec(t); const msg = (m ? m[1].replace(/\\n/g, ' ').replace(/\\"/g, '"') : t.replace(/<[^>]+>/g, ' ')).replace(/\s+/g, ' ').trim().slice(0, 400);
      return { file: path.relative(root, f).replace(/\\/g, '/'), msg };
    } catch { return null; /* FE 개발 서버 꺼짐 = 확인 못 함 */ }
  }
  return null;
}
/** 화면 ID → FE 페이지 폴더. 페이지 상수 파일의 MENU_ID 값으로 찾는다(결과는 기억) */
const pageDirMemo = new Map();
function pageDirOf(root, screen) {
  if (pageDirMemo.has(screen)) return pageDirMemo.get(screen);
  let found = ''; const base = path.join(root, 'nscm-fe', 'features'); const re = new RegExp(`MENU_ID\\b[^;]{0,40}['"]${screen}['"]`);
  try { for (const ft of fs.readdirSync(base)) { const pg = path.join(base, ft, 'src', 'pages'); let ds = []; try { ds = fs.readdirSync(pg, { withFileTypes: true }); } catch { continue; } for (const d of ds) { if (!d.isDirectory()) continue; for (const fn of fs.readdirSync(path.join(pg, d.name))) { if (!/constants\.ts$/.test(fn)) continue; if (re.test(fs.readFileSync(path.join(pg, d.name, fn), 'utf8'))) { found = path.join(pg, d.name); break; } } if (found) break; } if (found) break; } } catch (e) { errlog.note('orch-watch', 'pageDirOf', e); }
  pageDirMemo.set(screen, found); return found;
}
function tick() {
  try {
    lastTickMs = Date.now();
    loadCfg();
    // 2026-11-19 18:2x 정정: 주인 프로세스가 없어진 항목을 먼저 정리한 뒤 판정한다. 종전에는 판정 → 정리 순서라, 끝 사건 없이 종료된 run_verify 의 대기가
    //   '대기 지연(R4)'으로 올라갔다(실제 사건 20261119_181812_R4_DMF0042: 대기 PID 28056 은 이미 없었음 · Claude 호출 1회 1.60 USD 소모)
    const gone = state.sweep();
    // 끝 사건 없이 사라진 대기 = wait.gone 사건으로 남긴다(집계가 센다 · 개선안 20261119193539_REVIEW_4). 측정이므로 VMO 가 꺼져 있어도 남긴다
    for (const g of gone) if (g.what === 'wait') { try { if (orchEv) orchEv.emit('wait.gone', { kind: g.kind, screen: g.screen || '', waiter_pid: g.pid, sec_wait: Math.max(0, Math.round((Date.now() - g.t0) / 1000)), why: String(g.why || '').slice(0, 200) }); } catch { } }
    if (cfg.enabled === false) return; // VMO 꺼짐 = 상태 정리만 하고 판정하지 않는다
    const snap = state.snapshot();
    for (const w of snap.waits) { const k = `R4|${w.kind}|${w.screen}`; if (w.sec > cfg.waitMaxSec) { if (!seenOnce.has(k)) { seenOnce.add(k); raise('R4', { screen: w.screen, sig: k, title: `대기 지연. ${w.screen} ${w.kind} ${Math.round(w.sec / 60)}분째`, detail: w.why || '', evidence: { kind: w.kind, sec: w.sec, max_sec: w.max_sec, blocker_pid: w.blocker_pid, locks: snap.locks.filter(l => !w.screen || l.file.includes(w.screen)) } }); } } else seenOnce.delete(k); }
    // R13(2026-11-20 사용자 지적 'VMO 가 이를 확인해서 오류를 조치했어야'): SCP0028, SSP0014 CheckList 가 화면을 열지 못한 채 시험 80개와 AI 판정 검토까지 2시간 반 돌았는데 사건이 없었다.
    //   실행 중 로그 끝에서 화면 진입 실패 줄을 세어 openFailRepeat(5)회 이상이면 사건으로 올린다. FE 개발 서버가 내는 변환 오류(없는 import 등)를 같이 확인해 원인을 사건에 담는다
    for (const pr of snap.procs) {
      if (!pr.log || !pr.screen) continue; const k13 = `R13|${pr.log}`; if (seenOnce.has(k13)) continue;
      const n = openFailCount(path.join(root, pr.log)); if (n < cfg.openFailRepeat) continue;
      seenOnce.add(k13); const scr = pr.screen;
      feCompileError(scr).then(fe => { raise('R13', { screen: scr, sig: `R13|${scr}`, title: `화면 진입 실패 반복. ${scr} ${n >= 999 ? '진입 확인에서 열리지 않음' : n + '회'}${fe ? ' (FE 변환 오류)' : ''}`, detail: fe ? `FE 개발 서버 변환 오류: ${fe.file}
${fe.msg}` : 'FE 변환 오류 없음. 메뉴 권한, BE 상태, 계정 순으로 확인', evidence: { log: pr.log, pid: pr.pid, count: n, fe: fe || null, fix: fe && /Failed to resolve import/.test(fe.msg) ? `python tools/CommonSync/screen_sync.py ${scr}` : '' } }); }).catch(e => errlog.note('orch-watch', 'R13', e));
    }
    for (const pr of snap.procs) {
      if (pr.sec < cfg.stallSec || !pr.log) continue;
      let quiet = null; try { quiet = (Date.now() - fs.statSync(path.join(root, pr.log)).mtimeMs) / 1000; } catch { quiet = null; }
      const k = `R5|${pr.log}`;
      if (quiet == null || quiet <= cfg.stallSec || seenOnce.has(k)) continue;
      // 개선안 20261119205920_INC: 화면 ID 가 있는 실행은 E2E 추적 파일 수정 시각도 본다. list 리포터는 테스트 종료 때만 로그를 써서 상한 20~30분 테스트 중에는 로그가 멈춘다
      const logQuiet = quiet; const tr = e2eTraceMs(pr.screen); const traceQuiet = tr ? (Date.now() - tr) / 1000 : null;
      if (traceQuiet != null && traceQuiet < quiet) quiet = traceQuiet;
      if (quiet <= cfg.stallSec) continue;
      seenOnce.add(k); raise('R5', { screen: pr.screen, sig: `R5|${pr.label}`, title: `진행 없음. ${pr.label} 로그 ${Math.round(logQuiet / 60)}분 무출력`, detail: `PID ${pr.pid} · 실행 ${Math.round(pr.sec / 60)}분째${traceQuiet != null ? ` · E2E 추적 파일 ${Math.round(traceQuiet / 60)}분 무변경` : ''}`, evidence: { log: pr.log, pid: pr.pid, quiet_sec: Math.round(quiet), log_quiet_sec: Math.round(logQuiet), trace_quiet_sec: traceQuiet != null ? Math.round(traceQuiet) : null, waits: snap.waits.filter(w => w.screen === pr.screen) } });
    }
    // 2026-11-20 사용자 승인: 창 다시 로드(또는 VS Code 종료)로 끊긴 실행 = 띄운 주인이 이전 확장 호스트이고 그 프로세스가 이미 없음. 사건으로 올리지 않고 한 번에 묶어 알림 1건
    //   (실측: 00:47 창 로드 뒤 R5 7건이 올라와 에이전트가 Claude 를 6번 불러 00:48~01:00 동안 자가 보완이 밀림)
    const cut = [];
    for (const g of gone) {
      if (g.what === 'wait' || g.server) continue;
      if (g.owner && g.owner !== process.pid && !state.pidAlive(g.owner)) { cut.push(g); continue; }
      raise('R5', { screen: g.screen, sig: `R5|gone|${g.what}|${g.label || ''}`, title: `종료 기록 없이 사라진 실행. ${g.what === 'chain' ? '체인' : g.what === 'claude' ? 'Claude' : '프로세스'} ${g.label || ''}`, detail: `시작 ${orchEv ? orchEv.nowLocal(g.t0) : g.t0} · 주인 PID ${g.owner} · 끝 사건 없음(중지, 창 다시 로드, 강제 종료)`, evidence: { log: g.log || '', pid: g.pid || null } });
    }
    if (cut.length) { const kind = g => (g.what === 'chain' ? '체인' : g.what === 'claude' ? 'Claude' : '프로세스'); raise('R5', { notice: true, screen: '', sig: `R5|reloadcut|${cut[0].owner}`, title: `창 다시 로드로 끊긴 실행 ${cut.length}건(알림)`, detail: cut.map(g => `${kind(g)} ${g.screen ? g.screen + ' ' : ''}${g.label || ''} · 시작 ${orchEv ? orchEv.nowLocal(g.t0).slice(11, 16) : ''}`).join(String.fromCharCode(10)), evidence: { owner: cut[0].owner, runs: cut.map(g => ({ what: g.what, screen: g.screen || '', label: g.label || '', log: g.log || '' })) } }); }
    if (serverSvc) for (const s of serverSvc.stateList()) {
      const k = `R6|listen|${s.port}`;
      if (s.state === 'listen' && Date.now() - s.since > cfg.serverListenSec * 1000) { if (!seenOnce.has(k)) { seenOnce.add(k); raise('R6', { screen: '', sig: k, title: `서버 응답 없음. ${s.label} 포트 ${s.port} 열림 · HTTP 응답 없음 ${Math.round((Date.now() - s.since) / 1000)}초`, detail: s.owner === 'vm' ? 'VM 이 띄운 서버' : 'VM 밖에서 띄운 서버', evidence: { port: s.port, owner: s.owner } }); } } else seenOnce.delete(k);
    }
    if (snap.load.tcp != null && snap.load.tcp >= cfg.tcpWarn && Date.now() - lastTcpInc > 30 * 60000) { lastTcpInc = Date.now(); raise('R8', { screen: '', sig: 'R8|tcp', title: `TCP 연결 수 ${snap.load.tcp.toLocaleString()}, 기준 ${cfg.tcpWarn.toLocaleString()} 이상(E2E 중단 기준 14,000)`, detail: '동적 포트 고갈 전 단계. 연결을 많이 쥔 프로세스 확인 필요', evidence: { tcp: snap.load.tcp } }); }
    // 죽은 잠금: 1~2회는 R9(삭제만) · 같은 잠금 파일이 repeatLockMin(60)분 안에 repeatLockCount(3)회 이상이면 'R2 같은 오류 반복' 1건으로 묶는다
    //   (VMO 개선안 20261119193539_REVIEW_3 · 사용자 승인 2026-11-19: DMF0042 dbwin 잠금이 32분에 8회 남았는데 매번 새 R9 로 올라가 삭제만 됨)
    for (const l of snap.locks) {
      const k = `R9|${l.file}|${l.pid}`; if (l.alive !== false || seenOnce.has(k)) continue; seenOnce.add(k);
      const screen = (/\.([A-Z]{2,4}\d{4}[A-Z]?)\.lock$/.exec(l.file) || [])[1] || '';
      const occ = noteLock(l); const ev = { file: `Doc/e2e/${l.file}`, pid: l.pid };
      if (occ.length >= (cfg.repeatLockCount || 3)) {
        const lines = occ.map((o, n) => `${n + 1}. 감지 ${orchEv ? orchEv.nowLocal(o.ms).slice(11, 19) : o.ms} · 잠금 시작 ${o.started || '-'}${o.gapSec != null ? ` · 시작~감지 ${o.gapSec}초` : ''} · PID ${o.pid} · 부모 ${o.parent || '미기록'}${o.ppid ? `(${o.ppid})` : ''}${o.chain ? ` · 사슬 ${o.chain}` : ''} · 인자 ${o.args || '-'}`);
        raise('R2', { screen, sig: `R2|R9|${l.file}`, title: `같은 죽은 잠금 반복 ${occ.length}회(${cfg.repeatLockMin || 60}분 안). ${l.file}`, detail: lines.join(String.fromCharCode(10)), evidence: Object.assign({ deadLock: ev, occurrences: occ }, ev), repeat: { same: occ.length, all: occ.length, screens: screen ? [screen] : [] } });
      } else raise('R9', { screen, sig: `R9|${l.file}`, title: `죽은 잠금. ${l.file} (PID ${l.pid} 없음)`, detail: `시작 ${l.started} · 인자 ${l.args}${l.parent ? ` · 부모 ${l.parent}(${l.ppid || ''})` : ''}`, evidence: ev });
    }
  } catch (ex) { errlog.note('orch-watch', 'tick', ex); }
}

// ── 창 다시 로드로 생긴 사건 가려내기(2026-11-20 사용자 지시 'RELOAD 때문에 발생한 프로세스는 사용자 확인 필요에서 제외') ──
//   cut      = 끝 기록 없이 사라진 실행(R5 gone)의 주인이 이전 확장 호스트이고, 그 호스트의 마지막 기록이 사건보다 앞
//   shutdown = 실패 기록(step.end, proc.end, claude.end, chain.end)을 남긴 호스트가 없어졌고, 그 기록 뒤 15초 안에 다른 호스트가 켜짐
//   replay   = 사건 시각 5초 안에 원인 기록이 없음(새 호스트가 지난 사건 기록을 다시 읽어 올린 중복)
//   사건 기록이 사건 시각을 덮지 못하면 판정하지 않는다(빈 값 반환)
const STALE_EVENT_MS = 120000;
const RELOAD_KO = { cut: '창 로드로 끊긴 실행', shutdown: '창이 닫히며 끝난 프로세스', replay: '창 로드 뒤 지난 기록을 다시 읽어 올린 중복' };
const failEnd = ev => (ev.type === 'step.end' && ev.status === 'FAIL') || (ev.type === 'proc.end' && ev.exit !== 0 && ev.exit != null && !ev.server);
const SRC_OF = { R1: failEnd, R2: failEnd, R7: ev => ev.type === 'claude.end' && ev.exit !== 0 && ev.exit != null, R11: ev => ev.type === 'chain.end' };
function reloadCause(inc, ctx) {
  const alive = ctx.alive, self = ctx.selfPid, evs = ctx.events || [], acts = ctx.activations || [];
  const sig = String(inc.sig || '');
  if (inc.rule === 'R5') {
    if (sig.indexOf('R5|gone|') !== 0) return '';
    const owner = Number((inc.evidence && inc.evidence.owner) || (/주인 PID (\d+)/.exec(inc.detail || '') || [])[1] || 0);
    if (!owner || owner === self || alive(owner)) return '';
    let last = 0; for (const e of evs) if (e.src === 'vm' && e.pid === owner && e.ms > last) last = e.ms;
    return last && last < inc.ms ? 'cut' : '';
  }
  const src = SRC_OF[inc.rule]; if (!src || (inc.rule === 'R2' && sig.indexOf('R2|') === 0)) return ''; // R2|R9 = 죽은 잠금 반복(대상 아님)
  let first = 0; for (const e of evs) if (e.ms && (!first || e.ms < first)) first = e.ms;
  if (!first || first > inc.ms) return '';
  const occ = T => {
    let s = null; for (const e of evs) if (e.src === 'vm' && e.ms >= T - 5000 && e.ms <= T + 1000 && src(e)) s = e;
    if (!s) return 'replay';
    if (s.pid === self || alive(s.pid)) return '';
    return acts.some(a => a.pid !== s.pid && a.ms - T >= -1000 && a.ms - T <= 15000) ? 'shutdown' : '';
  };
  const a = occ(inc.ms); if (!a) return '';
  return inc.lastMs && inc.lastMs !== inc.ms ? occ(inc.lastMs) : a;
}
function readLines(f) { const out = []; try { for (const ln of fs.readFileSync(f, 'utf8').split(/\r?\n/)) { if (!ln.trim()) continue; try { out.push(JSON.parse(ln)); } catch { /* 깨진 줄 건너뜀 */ } } } catch { /* 파일 없음 = 빈 목록 */ } return out; }
/** 열림, 사용자 확인 필요, 30분 넘게 조치 중인 사건 중 창 다시 로드로 생긴 것을 알림(해결)으로 바꾼다. 반환 = 바꾼 사건 ID 목록 */
function reloadSweep() {
  const marked = [];
  try {
    const lastAct = x => { const a = (x.actions || []).slice(-1)[0]; const t = a ? Date.parse(a.at) : NaN; return Number.isFinite(t) ? t : (x.lastMs || x.ms || 0); };
    const cand = list(400).filter(x => !x.reload && !x.notice && (x.status === 'open' || x.status === 'need-user' || (x.status === 'acting' && Date.now() - lastAct(x) > 30 * 60000)));
    if (!cand.length) return marked;
    const ctx = { selfPid: process.pid, alive: state.pidAlive, events: orchEv ? orchEv.tail(8 * 1024 * 1024) : [], activations: readLines(path.join(orchDir, 'activations.jsonl')) };
    for (const inc of cand) { const c = reloadCause(inc, ctx); if (!c) continue; update(inc.id, { status: 'resolved', notice: true, reload: c, prevStatus: inc.status }, { by: 'VMO', what: `창 다시 로드로 생긴 사건(${RELOAD_KO[c]}). 사용자 확인 대상에서 뺌` }); marked.push(inc.id); }
  } catch (ex) { errlog.note('orch-watch', 'reloadSweep', ex); }
  return marked;
}

/** 사건 구독 fn(incident, isNew). 반환 = 해제 함수 */
function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }

function init(p, opts) {
  if (started || !p || !p.root) return;
  started = true; root = p.root; orchDir = path.join(p.vibeDir || path.join(p.root, '.vibe'), 'orch'); incDir = path.join(orchDir, 'incidents');
  try { fs.mkdirSync(incDir, { recursive: true }); } catch { }
  serverSvc = (opts && opts.serverSvc) || null;
  errlog.init(p.vibeDir || path.join(p.root, '.vibe'));
  loadCfg(); state.init(p); state.on(onEvent);
  timer = setInterval(tick, Math.max(5, cfg.tickSec) * 1000);
  if (!(opts && opts.noReloadSweep)) for (const d of [5000, 60000]) { const h = setTimeout(reloadSweep, d); if (h.unref) h.unref(); } // 이전 창이 닫히며 남긴 사건 정리
}
function dispose() { if (timer) { clearInterval(timer); timer = null; } started = false; }

function health() { return { started, lastTickMs, tickSec: Math.max(5, cfg.tickSec) }; }

module.exports = { reloadCause, reloadSweep, RELOAD_KO, STALE_EVENT_MS, markUserStop, userStopped, feCompileError, openFailCount, init, dispose, on, list, get, update, raise, tick, onEvent, health, TITLE, DEF };
