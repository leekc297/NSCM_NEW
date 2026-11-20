// 2026-11-19 VMO P5: 상시 개선안 — 실행 기록을 집계하고 개선안을 올린다. 반영은 사용자 승인 뒤에만 한다(사용자 지시 11-19).
//   흐름: 집계(코드, digest) → 분석(Claude, 읽기 전용) → 개선안 등록(.vibe/orch/proposals/<id>.json, status pending)
//         → 사용자 승인 → 반영(Claude) → 검증 → applied | 검증 실패면 대상 파일 복원 후 apply-failed
//         → 사용자 반려 → rejected(사유 기록). 반려·등록된 것과 같은 서명은 다시 올리지 않는다.
//   분석 시점: 체인이 끝났을 때와 1시간마다 확인해 마지막 분석에서 reviewEveryHours(기본 24) 지났으면 1회. '지금 분석' 버튼은 즉시.
//   근거 없는 개선안 금지 — 측정값이 없으면 '측정 추가' 개선안만 올리게 지시한다.
//   기준값: tools/Harness/harness.json orch 절(reviewEnabled · reviewEveryHours · reviewDays · proposalMaxPerReview)
'use strict';
const fs = require('fs');
const path = require('path');
let errlog = { note() { return null; }, init() { return ''; } }; try { errlog = require('./orch-errlog'); } catch { } // 2026-11-19 자가진단 Q1: 삼키던 오류를 .vibe/orch/vm_errors.jsonl 에 남긴다
const agent = require('./orch-agent');
const state = require('./orch-state');
const watch = require('./orch-watch');
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

const DEF = { reviewEnabled: true, reviewEveryHours: 24, reviewDays: 7, proposalMaxPerReview: 5 };
const READ_TOOLS = 'Read,Glob,Grep,Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *),Bash(git status*),Bash(git diff*),Bash(git log*)';
const STATUS_KO = { superseded: '고친 안으로 대체', pending: '승인 대기', approved: '승인', applying: '반영 중', applied: '반영 완료', 'apply-failed': '반영 실패', rejected: '반려' };

let started = false, timer = null, notifier = null;
const listeners = new Set();
const P = () => agent.paths();
const orchDir = () => path.join(P().vibeDir, 'orch');
const propDir = () => path.join(orchDir(), 'proposals');
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, JSON.stringify(v, null, 2), 'utf8'); return true; } catch (e) { errlog.note('orch-improve', 'writeJson', e); return false; } };
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const two = n => String(n).padStart(2, '0');
const stamp = () => { const d = new Date(); return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`; };
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); return Object.assign({}, DEF, (h && h.orch) || {}); }
function changed() { for (const fn of listeners) { try { fn(); } catch (ex) { errlog.note('orch-improve', 'listener', ex); } } }
const normSig = s => String(s || '').toLowerCase().replace(/\d+(\.\d+)?/g, 'n').replace(/[^\w가-힣|/.]+/g, ' ').trim().slice(0, 160);

// ── 개선안 저장·조회 ──
function list() {
  let names = []; try { names = fs.readdirSync(propDir()).filter(f => f.endsWith('.json')).sort().reverse(); } catch { }
  return names.map(n => readJson(path.join(propDir(), n), null)).filter(Boolean);
}
function get(id) { return readJson(path.join(propDir(), `${id}.json`), null); }
function save(pr) { writeJson(path.join(propDir(), `${pr.id}.json`), pr); changed(); return pr; }
function log(pr, by, what, extra) { pr.history = pr.history || []; pr.history.push(Object.assign({ at: nowLocal(), by, what }, extra || {})); return pr; }
function add(o, source) {
  const sig = normSig(o.sig || o.title);
  const dup = list().find(x => normSig(x.sig || x.title) === sig && /^(pending|approved|applying|applied|rejected)$/.test(x.status));
  if (dup) return { dup: dup.id, status: dup.status };
  const sfx = source === 'review' ? 'REVIEW' : source === 'self' ? 'SELF' : source === 'vision' ? 'VISION' : 'INC'; // VISION = 큰 그림 점검(orch-vision.js) · 사용자 승인 뒤 반영 // SELF = VM 자가진단(orch-selfcheck.js)이 올린 개선안
  let id = `${stamp()}_${sfx}`; let n = 1; while (fs.existsSync(path.join(propDir(), `${id}.json`))) id = `${stamp()}_${sfx}_${++n}`;
  const pr = { id, at: nowLocal(), ms: Date.now(), source, status: 'pending', sig, title: String(o.title || '').slice(0, 200), evidence: o.evidence || '', targets: Array.isArray(o.targets) ? o.targets.map(String) : [], before_after: o.before_after || '', verify: o.verify || '', rollback: o.rollback || '', incident: o.incident || '', screen: o.screen || '', history: [] };
  if (o.plain && typeof o.plain === 'object') pr.plain = { what: String(o.plain.what || '').slice(0, 300), risk: String(o.plain.risk || '').slice(0, 300), undo: String(o.plain.undo || '').slice(0, 300) }; // 승인 대상의 업무 말 설명
  if (source === 'self') { pr.self = true; pr.check = String(o.check || ''); pr.selfKey = String(o.selfKey || ''); }
  save(pr); if (orchEv) orchEv.emit('proposal', { id, title: pr.title, source });
  return { id };
}

// ── 집계(코드) ──
function readEvents(days) {
  const d = orchDir(); const cut = Date.now() - days * 86400000; const out = [];
  let files = []; try { files = fs.readdirSync(d).filter(f => /^events(_\d+_\d+)?\.jsonl$/.test(f)).map(f => path.join(d, f)); } catch { }
  for (const f of files) { try { if (fs.statSync(f).mtimeMs < cut) continue; for (const ln of fs.readFileSync(f, 'utf8').split(/\r?\n/)) { if (!ln.trim()) continue; try { const e = JSON.parse(ln); if (e.ms >= cut) out.push(e); } catch { } } } catch { } }
  return out.sort((a, b) => a.ms - b.ms);
}
const med = a => { if (!a.length) return 0; const s = [...a].sort((x, y) => x - y); const m = Math.floor(s.length / 2); return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2; };
const pct = (a, q) => { if (!a.length) return 0; const s = [...a].sort((x, y) => x - y); return s[Math.min(s.length - 1, Math.floor(s.length * q))]; };
/** 최근 days 일 실행 기록 집계. 숫자는 전부 events.jsonl·incidents 에서 센 값이다 */
function digest(days) {
  days = days || cfg().reviewDays; const evs = readEvents(days);
  const steps = {}, waits = {}, chains = {}, claude = { n: 0, fail: 0, timedOut: 0, stopped: 0, noResult: 0, ms: 0, cost: 0, costN: 0, retry: 0, waitMs: 0 }, procs = {};
  // VMO 개선안 20261119193539_REVIEW_4(사용자 승인 2026-11-19): 끝 사건 없이 사라진 대기와 Claude 호출도 센다 — 종전에는 wait.end · claude.end 만 세어 중간에 끝난 실행의 대기 3건과 호출 1건이 집계에 없었다
  const wOpen = new Map(); const wKey = e => `${e.src}:${e.pid}:${e.kind}:${e.screen || ''}`; const wOf = k => waits[k] || (waits[k] = { kind: k, n: 0, sec: 0, max: 0, gaveUp: 0, screens: {}, started: 0, gone: 0, goneSec: 0, goneUnknown: 0, open: [] });
  let cStart = 0;
  // VMO 개선안 20261120094530_REVIEW(사용자 승인 2026-11-20): 중지된 실행을 실패와 따로 센다. 같은 screen 의 job.item.end status cancel, user.stop, proc.end stopped=true 가 앞뒤 60초 안에 있으면 stopped
  const STOP_WIN = 60000; const stopMarks = {};
  for (const e of evs) { if (!e.screen) continue; if ((e.type === 'job.item.end' && e.status === 'cancel') || e.type === 'user.stop' || (e.type === 'proc.end' && e.stopped === true)) (stopMarks[e.screen] || (stopMarks[e.screen] = [])).push(e.ms); }
  const vsStops = evs.filter(e => e.type === 'user.stop' && e.by === 'VS Code 종료');
  const wasStopped = e => e.stopped === true || !!(e.screen && (stopMarks[e.screen] || []).some(ms => Math.abs(ms - e.ms) <= STOP_WIN));
  for (const e of evs) {
    if (e.type === 'wait.start') { wOf(e.kind).started++; wOpen.set(wKey(e), e); }
    else if (e.type === 'wait.gone') { const w = wOf(e.kind); w.gone++; if (typeof e.sec_wait === 'number') w.goneSec += e.sec_wait; else w.goneUnknown++; } // 개선안 20261120103659_SELF: 대기 시간 미상(sec_wait null)은 따로 센다
    else if (e.type === 'claude.start') cStart++;
    if (e.type === 'step.end') { const k = e.task || e.name; const s = steps[k] || (steps[k] = { key: k, actor: e.actor, n: 0, fail: 0, stopped: 0, warn: 0, ms: [], repairs: 0 }); s.n++; if (e.status === 'FAIL') { if (wasStopped(e)) s.stopped++; else s.fail++; } if (e.status === 'WARN' || e.status === 'HOLD') s.warn++; if (e.ms_run) s.ms.push(e.ms_run); s.repairs += e.repairs || 0; }
    else if (e.type === 'wait.end') { const w = wOf(e.kind); wOpen.delete(wKey(e)); w.n++; w.sec += e.sec_wait || 0; w.max = Math.max(w.max, e.sec_wait || 0); if (e.gave_up) w.gaveUp++; if (e.screen) w.screens[e.screen] = (w.screens[e.screen] || 0) + (e.sec_wait || 0); }
    else if (e.type === 'chain.end') { const k = e.chain || e.chainLabel; const c = chains[k] || (chains[k] = { chain: k, label: e.chainLabel, n: 0, ok: 0, stopped: 0, ms: [], claudeRan: 0, claudeSkipped: 0, noClaude: 0 }); c.n++; if (e.ok) c.ok++; else if (wasStopped(e)) c.stopped++; if (e.ms_run) c.ms.push(e.ms_run); c.claudeRan += e.claudeRan || 0; c.claudeSkipped += e.claudeSkipped || 0; if (!e.claudeRan) c.noClaude++; }
    // 개선안 20261120094530_REVIEW_3: 시간 초과(timedOut)와 중지(stoppedBy 중지 요청, VS Code 종료)를 fail 과 따로 센다. stoppedBy 없는 종전 기록은 같은 VM 프로세스의 VS Code 종료 user.stop 뒤 15초 안 끝 또는 wasStopped 면 stopped
    else if (e.type === 'claude.end') { claude.n++; if (e.stoppedBy === '시간 초과' || e.timedOut === true) claude.timedOut++; else if (e.stoppedBy) claude.stopped++; else if (e.exit !== 0 && (wasStopped(e) || vsStops.some(s => s.src === e.src && s.pid === e.pid && e.ms >= s.ms && e.ms - s.ms <= 15000))) claude.stopped++; else if (e.exit !== 0) claude.fail++; if (e.hasResult === false && !e.stoppedBy && !e.timedOut) claude.noResult++; claude.ms += e.ms_run || 0; if (e.costUsd != null) { claude.cost += e.costUsd; claude.costN++; } }
    else if (e.type === 'claude.result' && e.costUsd != null) { claude.cost += e.costUsd; claude.costN++; }
    else if (e.type === 'claude.retry') claude.retry++;
    else if (e.type === 'claude.wait') claude.waitMs += e.ms_wait || 0;
    else if (e.type === 'proc.end' && !e.server) { const k = e.label; const pr = procs[k] || (procs[k] = { label: k, n: 0, fail: 0, stopped: 0, exits: {} }); pr.n++; if (e.exit !== 0 && wasStopped(e)) pr.stopped++; else if (e.exit !== 0) { pr.fail++; pr.exits[e.exit] = (pr.exits[e.exit] || 0) + 1; } }
  }
  for (const e of wOpen.values()) wOf(e.kind).open.push(e);           // 끝 사건이 없는 대기(지금 기다리는 중인 것 포함)
  let cRunning = 0; try { cRunning = state.snapshot().claudes.length; } catch { }
  const cut = Date.now() - days * 86400000; const incs = watch.list(1000).filter(x => (x.ms || 0) >= cut);
  const byRule = {}, bySig = {};
  for (const x of incs) { byRule[x.rule] = (byRule[x.rule] || 0) + (x.count || 1); const s = bySig[x.sig] || (bySig[x.sig] = { sig: x.sig, rule: x.rule, title: x.title, n: 0, screens: new Set(), statuses: {} }); s.n += x.count || 1; if (x.screen) s.screens.add(x.screen); s.statuses[x.status] = (s.statuses[x.status] || 0) + 1; }
  const r1 = v => Math.round(v / 100) / 10;
  const d = {
    at: nowLocal(), days, events: evs.length, firstEventAt: evs.length ? evs[0].at : '', lastEventAt: evs.length ? evs[evs.length - 1].at : '',
    steps: Object.values(steps).map(s => ({ key: s.key, actor: s.actor, n: s.n, fail: s.fail, stopped: s.stopped, warn: s.warn, repairs: s.repairs, medianSec: r1(med(s.ms)), p90Sec: r1(pct(s.ms, 0.9)), totalSec: r1(s.ms.reduce((a, b) => a + b, 0)) })).sort((a, b) => b.totalSec - a.totalSec).slice(0, 30),
    waits: Object.values(waits).map(w => ({ kind: w.kind, started: w.started, unfinished: w.open.length, unfinishedLive: w.open.filter(e => state.pidAlive(e.pid)).length, unfinishedScreens: [...new Set(w.open.map(e => e.screen).filter(Boolean))], gone: w.gone, goneSec: w.goneSec, goneUnknown: w.goneUnknown, n: w.n, totalSec: w.sec, maxSec: w.max, gaveUp: w.gaveUp, topScreens: Object.entries(w.screens).sort((a, b) => b[1] - a[1]).slice(0, 5).map(([s, v]) => `${s} ${v}s`) })).sort((a, b) => b.totalSec - a.totalSec),
    chains: Object.values(chains).map(c => ({ chain: c.chain, label: c.label, n: c.n, ok: c.ok, stopped: c.stopped, medianSec: r1(med(c.ms)), claudeRan: c.claudeRan, claudeSkipped: c.claudeSkipped, runsWithoutClaude: c.noClaude })),
    claude: { started: cStart, unfinished: Math.max(0, cStart - claude.n), runningNow: cRunning, calls: claude.n, fail: claude.fail, timedOut: claude.timedOut, stopped: claude.stopped, noResult: claude.noResult, totalSec: r1(claude.ms), costUsd: Math.round(claude.cost * 1000) / 1000, costCounted: claude.costN, sessionRetry: claude.retry, waitedSec: r1(claude.waitMs) },
    procFails: Object.values(procs).filter(x => x.fail || x.stopped).sort((a, b) => b.fail - a.fail || b.stopped - a.stopped).slice(0, 20),
    incidents: { total: incs.length, byRule, topRepeats: Object.values(bySig).sort((a, b) => b.n - a.n).slice(0, 15).map(s => ({ rule: s.rule, n: s.n, screens: [...s.screens], title: s.title, statuses: s.statuses, sig: s.sig })) },
  };
  writeJson(path.join(orchDir(), 'digest.json'), d);
  return d;
}

// ── 분석(Claude, 읽기 전용) ──
const metaFile = () => path.join(orchDir(), 'review_meta.json');
function reviewDue() { const c = cfg(); if (!c.reviewEnabled || c.enabled === false) return false; const m = readJson(metaFile(), {}); return Date.now() - (m.lastMs || 0) >= c.reviewEveryHours * 3600000; }
async function review(manual) {
  const c = cfg(); const d = digest(c.reviewDays);
  if (!d.events && !d.incidents.total) { writeJson(metaFile(), Object.assign(readJson(metaFile(), {}), { lastMs: Date.now(), lastAt: nowLocal(), lastResult: '실행 기록 0건. 분석 생략' })); agent.say('note', { text: `상시 분석: 최근 ${c.reviewDays}일 실행 기록 0건. 분석 생략` }); changed(); return { skipped: true }; }
  const known = list().map(x => ({ title: x.title, status: x.status, reason: x.reason || '' })).slice(0, 40);
  const prompt = [
    '.claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 상시 분석이다. 파일을 고치지 않는다(읽기만).',
    `Vibe_Manager 의 최근 ${c.reviewDays}일 실행 집계를 보고 개선안을 최대 ${c.proposalMaxPerReview}건 올린다.`,
    '',
    '규칙',
    '- 개선안마다 근거(집계의 어느 수치, 어느 사건·로그 파일)를 적는다. 근거 수치가 없는 개선안은 올리지 않는다.',
    '- 필요한 수치가 집계에 없으면 그 수치를 기록하게 하는 "측정 추가" 개선안을 올린다.',
    '- 필요하면 .vibe/orch/events.jsonl · .vibe/orch/incidents/ · .vibe/logs/ · Doc/verify/<ID>/_timing.csv · _test_timing.jsonl · 해당 소스를 읽어 원인을 확인한 뒤 올린다.',
    '- 이미 올라온 개선안(아래 목록)과 같은 내용, 반려된 내용은 다시 올리지 않는다.',
    '- 대상이 tools/VibeManager, tools/Harness, tools/E2E, tools/Docs 의 코드뿐인 안과 로그, 백업, 스냅샷 삭제 안은 VMO 가 승인 없이 반영한다(게이트 통과 조건, 삭제는 7일 지난 것만). 그 밖의 대상(FE, BE, DB 객체, 룰, hook, 설정 파일)은 사용자 승인 대상이므로 plain 에 개발 용어 없이 업무 말로 what(무엇이 달라지는지), risk(잘못되면 보이는 증상), undo(되돌리는 방법)를 1문장씩 적는다.',
    '- 올릴 것이 없으면 proposals 를 빈 배열로 낸다.',
    '- 마지막 출력은 아래 형식의 JSON 코드 블록 1개다.',
    '```json',
    '{ "proposals": [ { "title": "", "evidence": "수치와 출처 파일", "targets": ["바꿀 파일 경로 또는 DB 객체"], "before_after": "변경 전 → 변경 후", "verify": "반영 뒤 실행할 검증 명령과 기대 결과", "rollback": "되돌리는 방법", "sig": "같은 안을 가리는 짧은 열쇠말", "plain": { "what": "", "risk": "", "undo": "" } } ], "summary": "분석 요약 2~3문장" }',
    '```',
    '',
    '[집계]', JSON.stringify(d, null, 1),
    '',
    `[이미 올라온 개선안 ${known.length}건]`, known.length ? JSON.stringify(known, null, 1) : '없음',
  ].join('\n');
  const r = await agent.withLock('review', async () => { agent.say('start', { id: 'review', text: `상시 분석. 최근 ${c.reviewDays}일, 사건 ${d.incidents.total}건, 실행 기록 ${d.events}건` }); return agent.runClaude(prompt, { label: '상시 분석', permissionMode: 'default', allowedTools: READ_TOOLS }); });
  if (r && r.busy) { agent.say('note', { text: '상시 분석 보류. 사건 조치 중' }); return { busy: true }; }
  const out = agent.lastJsonBlock(r.text); const meta = Object.assign(readJson(metaFile(), {}), { lastMs: Date.now(), lastAt: nowLocal(), manual: !!manual, log: r.log, sec: Math.round(r.ms / 1000), costUsd: r.costUsd });
  if (!r.ok || !out || !Array.isArray(out.proposals)) { meta.lastResult = !r.ok ? `분석 실패 exit ${r.code}${r.timedOut ? ' (시간 초과)' : ''}` : '결과 JSON 없음'; writeJson(metaFile(), meta); agent.say('end', { id: 'review', ok: false, text: `상시 분석 ${meta.lastResult}` }); changed(); return { ok: false }; }
  let added = 0, dups = 0;
  for (const o of out.proposals.slice(0, c.proposalMaxPerReview)) { if (!o || !o.title || !o.evidence) continue; const a = add(o, 'review'); if (a.id) added++; else dups++; }
  meta.lastResult = `개선안 ${added}건 등록${dups ? ` · 중복 ${dups}건 제외` : ''}`; meta.summary = String(out.summary || '').slice(0, 600); writeJson(metaFile(), meta);
  agent.say('end', { id: 'review', ok: true, text: `상시 분석 완료. ${meta.lastResult}. ${meta.summary}` });
  if (added && notifier) { try { notifier(`개선안 ${added}건 승인 대기`); } catch (ex) { errlog.note('orch-improve', 'notify', ex); } }
  changed(); return { ok: true, added, dups };
}

// ── 승인 → 반영 → 검증 ──
function backupTargets(pr) {
  const root = P().root; const dir = path.join(orchDir(), 'snap', `prop_${pr.id}`); const kept = [], absent = [];
  for (const t of pr.targets || []) {
    const rel = String(t).replace(/\\/g, '/').replace(/^\.\//, ''); const src = path.resolve(root, rel);
    if (path.relative(root, src).startsWith('..')) continue;
    try { if (fs.statSync(src).isFile()) { const to = path.join(dir, 'files', rel); fs.mkdirSync(path.dirname(to), { recursive: true }); fs.copyFileSync(src, to); kept.push(rel); } } catch { absent.push(rel); }
  }
  writeJson(path.join(dir, 'before.json'), { at: nowLocal(), kept, absent, git: agent.gitDirty() });
  try { fs.rmSync(path.join(dir, 'after.json'), { force: true }); } catch { }
  return { dir, kept, absent };
}
function changedSince(dir) {
  const before = readJson(path.join(dir, 'before.json'), {}).git; const after = agent.gitDirty(); if (!before || !after) return null;
  return Object.keys(after).filter(f => !(f in before) || before[f] !== after[f]).map(f => f.replace(/\\/g, '/')).filter(f => !f.startsWith('.vibe/') && !/\.bak_/.test(f));
}
const fileSig = f => { try { const st = fs.statSync(f); return `${st.size}|${Math.round(st.mtimeMs)}`; } catch { return ''; } };
/** Claude 가 끝난 직후 대상 파일 지문을 남긴다. 되돌릴 때 이 지문과 다르면 그 뒤 다른 쪽이 고친 것이므로 덮지 않는다 */
function markAfter(pr) { const root = P().root; const dir = path.join(orchDir(), 'snap', `prop_${pr.id}`); const b = readJson(path.join(dir, 'before.json'), null); if (!b) return; const sig = {}; for (const rel of [...(b.kept || []), ...(b.absent || [])]) sig[rel] = fileSig(path.join(root, rel)); writeJson(path.join(dir, 'after.json'), { at: nowLocal(), sig }); }
function restoreTargets(pr, opt) {
  const root = P().root; const dir = path.join(orchDir(), 'snap', `prop_${pr.id}`); const b = readJson(path.join(dir, 'before.json'), null); if (!b) return { ok: false, why: '사본 없음' };
  const done = [], fail = [], skipped = []; const after = (opt && opt.force) ? null : readJson(path.join(dir, 'after.json'), null);
  const touched = rel => after && after.sig && rel in after.sig && after.sig[rel] !== fileSig(path.join(root, rel));
  for (const rel of b.kept || []) { if (touched(rel)) { skipped.push(rel); continue; } try { fs.copyFileSync(path.join(dir, 'files', rel), path.join(root, rel)); done.push(rel); } catch (e) { fail.push(`${rel}: ${e.message}`); } }
  for (const rel of b.absent || []) { try { if (fs.existsSync(path.join(root, rel))) { fs.unlinkSync(path.join(root, rel)); done.push(`${rel}(삭제)`); } } catch (e) { fail.push(`${rel}: ${e.message}`); } }
  if (skipped.length) { try { require('./orch-errlog').note('orch-improve', 'restoreSkipped', `${pr.id} 되돌리지 않은 파일 ${skipped.join(', ')}(반영 뒤 다른 쪽이 고침)`); } catch { } }
  return { ok: !fail.length && !skipped.length, done, fail, skipped };
}
/** 사용자 승인 → 반영. 반환 { ok, status } */
async function approve(id, by) {
  const pr = get(id); if (!pr) return { ok: false, why: '개선안 없음' };
  if (!/^(pending|apply-failed)$/.test(pr.status)) return { ok: false, why: `상태 ${STATUS_KO[pr.status] || pr.status}` };
  pr.status = 'approved'; log(pr, by || '사용자', '승인'); save(pr);
  const prompt = [
    '.claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 사용자가 승인한 개선안 반영이다.',
    '승인 범위 = 아래 개선안의 targets 와 before_after. 이 범위 안에서는 C 등급 대상(FE·BE·DB 객체·tools/VibeManager·룰)도 수정한다. 범위 밖은 고치지 않는다. D 등급(금지)은 그대로 금지다.',
    (pr.self || pr.gated)
      ? 'VM 코드 자동 반영 대상 개선안이다. 저장소 파일(targets)만 고친다. 백업(.bak)은 VMO 가 이미 만들었으니 만들지 않는다. 설치 폴더(~/.vscode/extensions)와 tools/VibeManager/CHANGELOG.md 는 건드리지 않는다(반영 뒤 VMO 가 복사하고 기록한다). 다른 작업이 함께 고치는 파일(workbench.js · quick.json 등)은 전체를 다시 쓰지 말고 필요한 줄만 Edit 로 고친다. 구문 검사, test/run_all.js, 정의 정합은 VMO 가 반영 뒤 돌리므로 verify 에 적힌 확인만 실행한다. verify 가 비어 있으면 verified 를 true 로 낸다.'
      : '수정 전 파일마다 .bak_<yyyymmdd>_orchprop 백업을 둔다. 반영 뒤 verify 에 적힌 검증을 실행한다. 검증을 실행하지 못했으면 verified 를 false 로 낸다.',
    '작업 모드(tools/Harness/harness.json repairScope)와 저장소 hook 이 수정을 막으면 그 사실을 적고 applied 를 false 로 낸다.',
    '마지막 출력은 아래 형식의 JSON 코드 블록 1개다.',
    '```json',
    '{ "applied": true, "verified": true, "changed_files": [""], "verify_result": "실행한 명령, 출력 요약, 시각", "note": "" }',
    '```',
    '',
    '[개선안]', JSON.stringify({ id: pr.id, title: pr.title, evidence: pr.evidence, targets: pr.targets, before_after: pr.before_after, verify: pr.verify, rollback: pr.rollback }, null, 2),
  ].join('\n');
  let snap = backupTargets(pr); // 반영 전 게이트(약 100초) 동안의 다른 변경을 담기 위해 Claude 직전에 다시 뜬다(아래)
  // 2026-11-19 자가진단 Q6: VM 자가 보완 = 반영 전 게이트(구문 · 시험 · 정합) 기준선을 재고 대상 파일을 .bak_<yyyymmdd>_self<hhmm> 로 백업한다
  let selfPre = null, selfTag = '';
  if (pr.self || pr.gated) {
    const sc = require('./orch-selfcheck'); const d = new Date(); selfTag = `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}_self${two(d.getHours())}${two(d.getMinutes())}`;
    agent.say('note', { text: `자가 보완 반영 전 게이트 실행(구문, 시험, 정합). ${pr.title}` });
    selfPre = await sc.gate(); const root = P().root;
    for (const rel of snap.kept) { try { fs.copyFileSync(path.join(root, rel), path.join(root, `${rel}.bak_${selfTag}`)); } catch (ex) { errlog.note('orch-improve', 'selfBackup', ex); } }
    const p0 = get(id); log(p0, 'VMO', `반영 전 게이트: ${selfPre.text}${selfPre.ok ? '' : ` · 반영 전부터 어긋난 항목 ${selfPre.detail.length}건`} · 백업 태그 ${selfTag}`); save(p0);
  }
  // 2026-11-20 00:1x 정정: 사본을 게이트 앞에서 뜨면 그 사이 다른 작업이 고친 내용이 되돌릴 때 지워졌다(실제: 개선안 20261119232524_SELF_3 되돌림이 같은 시각 Claude Code 세션의 orchestra.js 수정을 지움)
  snap = backupTargets(pr);
  const r = await agent.withLock(`prop_${id}`, async () => { const p2 = get(id); p2.status = 'applying'; log(p2, 'VMO', '반영 시작'); save(p2); agent.say('start', { id, text: `개선안 반영. ${pr.title}` }); return agent.runClaude(prompt, { label: `개선안 반영 ${pr.title}` }); });
  try { markAfter(get(id)); } catch (ex) { errlog.note('orch-improve', 'markAfter', ex); }
  const cur = get(id);
  if (r && r.busy) { cur.status = 'pending'; log(cur, 'VMO', '반영 보류. 사건 조치 중. 다시 승인 필요'); save(cur); return { ok: false, why: 'busy' }; }
  const out = agent.lastJsonBlock(r.text); const files = changedSince(snap.dir);
  const meta = { log: r.log, sec: Math.round(r.ms / 1000), costUsd: r.costUsd, files: files || [] };
  if (!r.ok || !out || out.applied !== true || out.verified !== true) {
    const rs = restoreTargets(cur);
    cur.status = 'apply-failed'; cur.result = out || null;
    log(cur, 'VMO', `반영 실패. ${!r.ok ? `Claude exit ${r.code}${r.timedOut ? ' (시간 초과)' : ''}` : !out ? '결과 JSON 없음' : out.applied !== true ? `반영 안 됨: ${String(out.note || '').slice(0, 200)}` : `검증 실패: ${String(out.verify_result || '').slice(0, 200)}`} · 대상 파일 ${rs.done ? rs.done.length : 0}개 복원${rs.fail && rs.fail.length ? ` · 복원 실패 ${rs.fail.length}개` : ''}${rs.skipped && rs.skipped.length ? ` · 반영 뒤 다른 쪽이 고친 파일 ${rs.skipped.join(', ')} 는 되돌리지 않음(확인 필요)` : ''}${files && files.some(f => !(snap.kept.includes(f) || snap.absent.includes(f))) ? ` · 대상 밖 변경 ${files.filter(f => !(snap.kept.includes(f) || snap.absent.includes(f))).slice(0, 6).join(', ')} 는 그대로 남음` : ''}`, meta);
    save(cur); agent.say('end', { id, ok: false, text: `개선안 반영 실패. ${cur.title}` }); if (notifier) notifier(`개선안 반영 실패. ${cur.title}`);
    return { ok: false, status: cur.status };
  }
  const outside = (files || []).filter(f => !(snap.kept.includes(f) || snap.absent.includes(f)));
  if (cur.self || cur.gated) {
    const sc = require('./orch-selfcheck'); agent.say('note', { text: `자가 보완 반영 뒤 게이트 실행. ${cur.title}` });
    const g = await sc.gate(); const preBad = new Set((selfPre && selfPre.detail) || []); const newBad = g.detail.filter(x => !preBad.has(x));
    if (newBad.length || (!g.ok && !g.detail.length)) {
      const rs = restoreTargets(cur); cur.status = 'apply-failed'; cur.result = out; cur.gate = { ok: false, text: g.text, newBad };
      log(cur, 'VMO', `반영 실패. 게이트에서 새로 어긋난 항목 ${newBad.length}건: ${newBad.slice(0, 3).join(' / ').slice(0, 400)} · ${g.text} · 대상 파일 ${rs.done ? rs.done.length : 0}개 복원${rs.skipped && rs.skipped.length ? ` · 반영 뒤 다른 쪽이 고친 파일 ${rs.skipped.join(', ')} 는 되돌리지 않음(확인 필요)` : ''}${outside.length ? ` · 대상 밖 변경 ${outside.slice(0, 6).join(', ')} 는 그대로 남음` : ''}`, meta);
      save(cur); agent.say('end', { id, ok: false, text: `자가 보완 반영 실패(게이트). ${cur.title}` }); if (notifier) notifier(`자가 보완 반영 실패(게이트). ${cur.title}`);
      return { ok: false, status: cur.status };
    }
    const vmRel = (files || snap.kept).filter(x => x.startsWith('tools/VibeManager/')).map(x => x.slice('tools/VibeManager/'.length));
    const sy = vmRel.length ? sc.syncInstalled('VMO 자가 보완', selfTag.slice(9), vmRel) : { copied: [], fail: [] };
    cur.gate = { ok: true, text: g.text }; cur.selfTag = selfTag; cur.needsReload = !!(sy.copied && sy.copied.length); cur.appliedMs = Date.now(); cur.synced = sy.copied || [];
    const cl = changelogSelf(cur, out, files || snap.kept, g, sy, selfTag);
    log(cur, 'VMO', `게이트 통과: ${g.text} · 설치 폴더 복사 ${sy.copied ? sy.copied.length : 0}개${sy.fail && sy.fail.length ? ` · 복사 실패 ${sy.fail.length}개` : sy.why ? ` (${sy.why})` : ''} · CHANGELOG ${cl ? '절 추가' : '기록 실패'} · 적용은 VS Code 창 다시 로드 뒤`);
  }
  cur.status = 'applied'; cur.result = out; cur.snap = `prop_${id}`;
  log(cur, 'VMO', `반영 완료 · 검증 통과. ${String(out.verify_result || '').slice(0, 300)}${files ? ` · 변경 ${files.length}개 파일` : ' · 변경 파일 감지 미실행'}${outside.length ? ` · 대상 목록 밖 변경 ${outside.length}개: ${outside.slice(0, 6).join(', ')}` : ''}`, meta);
  save(cur); agent.say('end', { id, ok: true, text: `개선안 반영 완료. ${cur.title}` }); if (notifier) notifier(`개선안 반영 완료. ${cur.title}`);
  return { ok: true, status: cur.status };
}
/** VM 자가 보완 기록: CHANGELOG.md 맨 위에 절 1개를 넣는다(기존 절 형식). 반환 = 성공 여부 */
function changelogSelf(pr, out, files, g, sy, tag, reverted) {
  try {
    const f = path.join(P().root, 'tools', 'VibeManager', 'CHANGELOG.md'); const old = fs.readFileSync(f, 'utf8'); const eol = old.includes('\r\n') ? '\r\n' : '\n';
    const now = nowLocal(); const one = x => String(x || '').replace(/\s+/g, ' ').trim();
    const L = reverted
      ? [`## (판 번호 없음, VM 저장소 + 설치 폴더) VMO 자가 보완 되돌림: ${one(pr.title).slice(0, 120)} (${now.slice(0, 10)} ${now.slice(11, 16)})`,
        `- 사용자(${now.slice(5, 10)}): 개선안 ${pr.id} 되돌리기 실행.`,
        `- 복원: ${files.join(', ') || '없음'}. 설치 폴더 복사 ${sy && sy.copied ? sy.copied.length : 0}개.`,
        '- 미확인: VS Code 실화면(창 다시 로드 필요).']
      : [`## (판 번호 없음, VM 저장소 + 설치 폴더) VMO 자가 보완: ${one(pr.title).slice(0, 120)} (${now.slice(0, 10)} ${now.slice(11, 16)})`,
        `- 사용자(${now.slice(5, 10)}): 개선안 ${pr.id} 승인(VM 자가진단 ${pr.check || ''} ${pr.selfKey || ''}). 근거 = ${one(pr.evidence).slice(0, 400)}`,
        `- 변경: ${one(pr.before_after).slice(0, 500)}. 파일 ${files.join(', ') || '없음'}.`,
        `- 확인(${now.slice(11, 16)} 실행): ${g.text}.${out && out.verify_result ? ` 개선안 확인: ${one(out.verify_result).slice(0, 300)}` : ''}`,
        `- 미확인: VS Code 실화면(창 다시 로드 필요).${sy && sy.fail && sy.fail.length ? ` 설치 폴더 복사 실패 ${sy.fail.length}개.` : ''}`,
        `- 되돌리기: VMO 창 개선안 탭의 되돌리기 버튼, 또는 ${files.filter(x => !/\.bak_/.test(x)).map(x => `${x}.bak_${tag}`).join(', ')}(설치 폴더는 같은 태그).`];
    fs.writeFileSync(f, L.join(eol) + eol + eol + old, 'utf8'); return true;
  } catch (ex) { errlog.note('orch-improve', 'changelogSelf', ex); return false; }
}
function reject(id, reason, by) {
  const pr = get(id); if (!pr) return { ok: false };
  pr.status = 'rejected'; pr.reason = String(reason || '').slice(0, 500); log(pr, by || '사용자', `반려${pr.reason ? ` — ${pr.reason}` : ''}`); save(pr);
  return { ok: true };
}
/** 반영한 개선안의 대상 파일을 반영 전 사본으로 되돌린다(DB 객체는 개선안의 rollback 절차로 사용자가 되돌린다) */
function revert(id, by) {
  const pr = get(id); if (!pr || pr.status !== 'applied') return { ok: false, why: '반영 완료 상태가 아님' };
  const rs = restoreTargets(pr); pr.status = 'pending'; pr.reverted = true;
  if (pr.self || pr.gated) { // 자가 보완 = 설치 폴더도 되돌린 내용으로 다시 맞추고 CHANGELOG 에 되돌림 절을 남긴다
    try { const sc = require('./orch-selfcheck'); const d = new Date(); const vmRel = (pr.synced || []); const sy = vmRel.length ? sc.syncInstalled('VMO 자가 보완 되돌림', `selfrev${two(d.getHours())}${two(d.getMinutes())}`, vmRel) : { copied: [] };
      changelogSelf(pr, null, rs.done || [], null, sy, '', true); pr.needsReload = !!(sy.copied && sy.copied.length); rs.synced = sy.copied || []; } catch (ex) { errlog.note('orch-improve', 'revertSelf', ex); }
  }
  log(pr, by || '사용자', `되돌리기. ${rs.done ? rs.done.length : 0}개 파일 복원${rs.fail && rs.fail.length ? ` · 실패 ${rs.fail.length}개` : ''}${rs.skipped && rs.skipped.length ? ` · 반영 뒤 다른 쪽이 고친 파일 ${rs.skipped.join(', ')} 는 되돌리지 않음` : ''}`, { files: rs.done, fail: rs.fail, skipped: rs.skipped }); save(pr);
  return rs;
}

function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }
function meta() { const c = cfg(); const m = readJson(metaFile(), {}); return { enabled: !!c.reviewEnabled, everyHours: c.reviewEveryHours, days: c.reviewDays, lastAt: m.lastAt || '', lastResult: m.lastResult || '', summary: m.summary || '', pending: list().filter(x => x.status === 'pending').length }; }

function init(opts) {
  if (started) return; started = true; notifier = (opts && opts.notify) || null;
  let chainEndTimer = null;
  state.on(ev => { if (ev.type !== 'chain.end' && ev.type !== 'job.end') return; if (chainEndTimer) clearTimeout(chainEndTimer); chainEndTimer = setTimeout(() => { try { digest(); if (reviewDue()) review(false); } catch (ex) { errlog.note('orch-improve', 'chainEnd', ex); } }, 20000); });
  timer = setInterval(() => { try { if (reviewDue() && !state.snapshot().chains.length) review(false); } catch (ex) { errlog.note('orch-improve', 'reviewTimer', ex); } }, 3600000);
}
function dispose() { if (timer) { clearInterval(timer); timer = null; } started = false; }

module.exports = { init, dispose, on, list, get, save, add, approve, reject, revert, review, reviewDue, digest, meta, changelogSelf, STATUS_KO, DEF };
