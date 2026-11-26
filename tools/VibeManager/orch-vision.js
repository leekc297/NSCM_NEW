// 2026-11-20 하루 1회 큰 그림 점검 — 사용자 지시: "하루에 한번정도는 스스로 큰 그림을 보고 목적에 부합하기 위하여 전체적으로 VM, VMO 가 잘못된 것이 없는지
//   스스로 고민하고 판단해서 어떤 문제점이 있는지 확인해서 개선 방향을 제안 ... 기본적으로 사용자가 승인할때만 적용되도록 초기값"
//   흐름: 목적 자료(사용자 지시 메모리, 플랜, 사용자 지적 원장) + 실행 상태(7일 집계, 자가진단, 사건, 개선안, CheckList 소요) → Claude(읽기 전용) 판단
//         → 목적별 판단(맞음/어긋남 + 근거) · 문제점 · 개선 방향 → 개선안 source 'vision' 등록 → 사용자 승인 뒤 반영(visionAutoApply false 초기값)
//   주기: 환경설정 vibeManager.orch.visionEveryDays(일, 기본 1) · 적용 여부 vibeManager.orch.visionEnabled(기본 적용, 미적용 = 주기 점검 안 함 · 단추 점검은 됨). 2026-11-20 사용자 지시. 1시간마다 확인. 읽기 전용이라 체인 실행 중에도 한다. VMO 꺼짐이면 안 함. '큰 그림 점검' 단추 = 즉시
//   기록: .vibe/orch/vision/<yyyymmdd_hhmmss>.json(회차 결과) · meta.json(마지막 회차)
'use strict';
const fs = require('fs');
const path = require('path');
const os = require('os');
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { /* 오류 기록 모듈 없음 */ }
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

let getPaths = null; let opts = {}; let timer = null; let running = null; let notifier = null;
const listeners = new Set();
const P = () => getPaths();
const vDir = () => path.join(P().vibeDir, 'orch', 'vision');
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
const readText = (f, max) => { try { const t = fs.readFileSync(f, 'utf8').replace(/^﻿/, ''); return max ? t.slice(0, max) : t; } catch { return ''; } };
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, JSON.stringify(v, null, 1), 'utf8'); return true; } catch (e) { errlog.note('orch-vision', 'writeJson', e); return false; } };
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const two = n => String(n).padStart(2, '0');
const stamp = () => { const d = new Date(); return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}_${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`; };
const mod = n => { if (opts.mods && opts.mods[n]) return opts.mods[n]; try { return require(`./${n}`); } catch (e) { errlog.note('orch-vision', `require ${n}`, e); return null; } };
const DEF = { visionEnabled: true, visionEveryDays: 1, visionAutoApply: false, visionMaxPerRun: 8 }; // 2026-11-26 사용자 지시('VMO 기능에 한계 없음 · 기능 개선과 추가 · UI MODE 준비 · UI/UX 추천'): 관점 3개를 더해 상한 5 → 8
/** harness.json orch 절 위에 환경설정(VS Code 설정 · opts.settings) 값을 덮는다. 일수는 1 이상 */
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); let s = {}; try { s = opts.settings ? opts.settings() || {} : {}; } catch { s = {}; } const c = Object.assign({}, DEF, (h && h.orch) || {}, s); c.visionEveryDays = Math.max(1, Number(c.visionEveryDays) || 1); return c; }
const say = (kind, o) => { const m = Object.assign({ type: 'vision', kind }, o || {}); for (const fn of listeners) { try { fn(m); } catch (e) { errlog.note('orch-vision', 'listener', e); } } };
function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }
function ladderSummary() { try { const l = require('./orch-ladder'); if (!l.ready()) l.init({ paths: () => P() }); return l.summary(); } catch (e) { errlog.note('orch-vision', 'ladder', e); return null; } } // 2026-11-20 진단 사다리 요약(Overview)
function meta() { const c = cfg(); const m = readJson(path.join(vDir(), 'meta.json'), {}); const nextMs = c.visionEnabled && c.enabled !== false ? (m.lastMs || 0) + c.visionEveryDays * 86400000 : 0; return Object.assign({ ladder: ladderSummary(), enabled: !!c.visionEnabled, everyDays: c.visionEveryDays, autoApply: !!c.visionAutoApply, running: !!running, nextAt: nextMs ? nowLocal(Math.max(nextMs, Date.now())) : '' }, m); }
function due() { const c = cfg(); if (c.enabled === false || !c.visionEnabled) return false; const m = readJson(path.join(vDir(), 'meta.json'), {}); return !m.lastMs || Date.now() - m.lastMs >= c.visionEveryDays * 86400000; }

/** 목적 자료: 사용자 지시 메모리(VM, VMO, CheckList 속도), 플랜 파일 앞부분, 사용자 지적 원장 */
function purposeDocs() {
  const out = []; const memDir = opts.memDir || path.join(os.homedir(), '.claude', 'projects', String(P().root).replace(/[^A-Za-z0-9]/g, '-'), 'memory');
  let names = []; try { names = fs.readdirSync(memDir); } catch { names = []; }
  const pick = names.filter(n => /^(feedback_vmo_|feedback_checklist_speed|project_vm_orchestra_plan|feedback_no_guess|feedback_sentence_rule)/.test(n)).sort();
  for (const n of pick) out.push({ src: `memory/${n}`, text: readText(path.join(memDir, n), 2500) });
  const plan = opts.planFile || path.join(os.homedir(), '.claude', 'plans', 'vm-ui-snug-mountain.md'); const pt = readText(plan, 3000); if (pt) out.push({ src: 'plans/vm-ui-snug-mountain.md(앞 3000자)', text: pt });
  const L = readJson(path.join(opts.vmDir || path.join(P().root, 'tools', 'VibeManager'), 'user_checks.json'), { items: [] });
  out.push({ src: 'tools/VibeManager/user_checks.json(사용자 지적 원장)', text: (L.items || []).map(u => `${u.id} ${u.at} [${u.status}] ${u.symptom} · 원문 "${String(u.quote || '').slice(0, 160)}"`).join('\n') });
  return out;
}
/** 실행 상태 자료(코드 집계) */
function stateDocs() {
  const o = {};
  try { const imp = mod('orch-improve'); o.digest7d = imp && imp.digest ? imp.digest(7) : null; const ps = imp ? imp.list() : []; const by = {}; for (const p of ps) { const k = `${p.source || '-'}:${p.status}`; by[k] = (by[k] || 0) + 1; } o.proposals = by; o.applyFailed = ps.filter(p => p.status === 'apply-failed').slice(0, 10).map(p => `${p.id} ${String(p.title).slice(0, 80)}`); } catch (e) { errlog.note('orch-vision', 'proposals', e); }
  try { const sc = mod('orch-selfcheck'); const r = sc && sc.result ? sc.result() : null; if (r && r.checks) o.selfcheck = Object.fromEntries(Object.entries(r.checks).map(([k, v]) => [k, { status: v.status, count: v.count, items: (v.items || []).slice(0, 5).map(i => `${i.level} ${i.what}`) }])); } catch (e) { errlog.note('orch-vision', 'selfcheck', e); }
  try { const w = mod('orch-watch'); const inc = w ? w.list(400) : []; const cut = Date.now() - 7 * 86400000; const by = {}; for (const i of inc) if ((i.ms || 0) >= cut) { const k = `${i.rule}:${i.status}`; by[k] = (by[k] || 0) + 1; } o.incidents7d = by; } catch (e) { errlog.note('orch-vision', 'incidents', e); }
  try { const vd = path.join(P().root, 'Doc', 'verify'); const tm = {}; for (const id of fs.readdirSync(vd)) { const t = readJson(path.join(vd, id, 'run_timing.json'), null); if (Array.isArray(t) && t.length) { const l = t[t.length - 1]; tm[id] = { at: l.run_at, wallMin: l.wall_min, top: (l.top || []).slice(0, 3).map(x => `${x.stage} ${x.tool} ${x.min}분`) }; } } o.checklistTiming = tm; } catch { /* 소요표 없음 */ }
  try { const ch = readText(path.join(opts.vmDir || path.join(P().root, 'tools', 'VibeManager'), 'CHANGELOG.md'), 400000); const d = new Date(); const ds = [0, 1].map(k => { const x = new Date(d.getTime() - k * 86400000); return `${x.getFullYear()}-${two(x.getMonth() + 1)}-${two(x.getDate())}`; }); o.changes24h = ch.split('\n').filter(l => /^## /.test(l) && ds.some(s => l.includes(s))).slice(0, 40).map(l => l.slice(3, 200)); } catch { /* 변경 기록 없음 */ }
  try { const lg = mod('orch-ledger'); if (lg) { if (!lg.ready()) lg.init({ paths: () => P() }); const s = lg.stats(7); o.interventions7d = { total: s.total, byRule: s.byRule, falses: s.falses.slice(-10), observe: s.observe, overdue: s.overdue }; } } catch (e) { errlog.note('orch-vision', 'interventions', e); } // 2026-11-20 VMO 개입 장부(오판, 관찰 모드)
  // 2026-11-23 개선안 20261123000643_VISION 단계 4: 문장 규칙(S11) 판정 수치 = 대상 문장 잔량(remain), 7일 안 점검 사이 증가 합(newSum7d), 반영 게이트가 막은 개선안 수(gateBlocked7d)
  try {
    const cut = Date.now() - 7 * 86400000; const sc = mod('orch-selfcheck'); const r = sc && sc.result ? sc.result() : null; const s11 = r && r.checks && r.checks.S11;
    const rows = []; let hl = ''; try { hl = fs.readFileSync(path.join(P().vibeDir, 'orch', 'selfcheck', 'history.jsonl'), 'utf8'); } catch { hl = ''; }
    for (const ln of hl.split('\n')) { if (!ln.includes('"S11"')) continue; try { const j = JSON.parse(ln); const m = /^(\w+):(\d+)$/.exec((j.status || {}).S11 || ''); const ms = Date.parse(String(j.at || '').replace(' ', 'T')); if (m && m[1] !== 'skip' && Number.isFinite(ms)) rows.push({ at: j.at, ms, n: Number(m[2]) }); } catch { /* 깨진 줄 건너뜀 */ } }
    const rises = []; for (let i = 1; i < rows.length; i++) if (rows[i].ms >= cut && rows[i].n > rows[i - 1].n) rises.push({ at: rows[i].at, from: rows[i - 1].n, to: rows[i].n });
    const ps = mod('orch-improve') ? mod('orch-improve').list() : []; const blocked = ps.filter(p => p.gate && (p.gate.newBad || []).some(x => /^S11 /.test(x)) && (p.autoMs || p.applyStartMs || 0) >= cut).length;
    o.styleRule = { remain: s11 && s11.status !== 'skip' ? (s11.status === 'ok' ? 0 : s11.count) : null, remainAt: s11 ? s11.at || '' : '', newSum7d: rises.reduce((a, x) => a + x.to - x.from, 0), rises7d: rises.slice(-10), gateBlocked7d: blocked, measured7d: rows.filter(x => x.ms >= cut).length };
  } catch (e) { errlog.note('orch-vision', 'styleRule', e); }
  try { const uc = mod('orch-usercheck'); const lj = readJson(path.join(P().vibeDir, 'orch', 'usercheck', 'learn.json'), {}); o.userLearn = { lastAt: lj.lastAt || '', lastResult: lj.lastResult || '', excluded: (lj.excluded || []).slice(-10) }; if (uc && uc.pendingPrompts) o.userPromptsPending = uc.pendingPrompts().length; } catch (e) { errlog.note('orch-vision', 'usercheck', e); }
  return o;
}
const READ_TOOLS = 'Skill,Read,Glob,Grep,Bash(git log*),Bash(git diff*),Bash(git status*)';
function buildPrompt(c) {
  const known = (mod('orch-improve') ? mod('orch-improve').list() : []).filter(p => p.source === 'vision' || /^(pending|rejected)$/.test(p.status)).slice(0, 40).map(p => ({ title: p.title, status: p.status, source: p.source, reason: p.reason || '' }));
  return [
    '.claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 하루 1회 큰 그림 점검이다. 파일을 고치지 않는다(읽기만).',
    'Skill 도구로 vmo-diagnosis-ladder 를 불러 어긋난 목적마다 단계(L3 구조 · L4 개념)를 판정한다. L4 로 판정한 목적은 vmo-concept-review 를 불러 그 순서대로 개념 재정립안을 낸다(impact core, level L4, 제목 "개념 재정립: …").',
    'Vibe_Manager(VM: UI별 Workbench, VMW: 업무 작업, 공통 기능)와 VMO(감시, 자가 복구, 자가진단, 개선안, 에이전트)가 아래 [목적] 에 맞게 움직이는지 판단한다.',
    '',
    '할 일',
    '1. [목적] 에서 사용자가 요구한 목적을 항목으로 뽑고, 항목마다 지금 상태가 맞음/어긋남/미확인 인지 [실행 상태] 수치와 소스를 근거로 판단한다.',
    '1-1. 목적 "VM 고정 문구가 문장 규칙을 지킴"(S11)은 [실행 상태] styleRule 의 두 수치로 판정한다. 새로 생긴 위반 = newSum7d(7일 안 점검 사이 증가 합), 대상 문장 잔량 = remain. 둘 다 0 이면 맞음, 하나라도 0 보다 크면 어긋남, remain 이 null 이거나 measured7d 가 0 이면 미확인. evidence 에 두 수치와 remainAt 시각을 적는다. 줄 머리 상태 표지와 메뉴 이름 인용은 doc_style.py 가 문장에서 빼므로 위반으로 세지 않는다.',
    '2. 어긋난 항목은 원인(어느 파일, 어느 함수, 어느 설정)을 소스에서 확인한다. tools/VibeManager, tools/Harness, tools/E2E 를 읽는다.',
    '3. 구조 문제(감시 빈틈, 목적과 다른 동작, 반복되는 사용자 지적, CheckList 판정 결과가 AS-IS 와 달라지는 위험)를 개선 방향으로 올린다.',
    `4. 개선안은 최대 ${c.visionMaxPerRun}건. 근거 수치와 출처가 없으면 올리지 않는다. 이미 올라온 안(아래 목록), 반려된 안과 같은 내용은 올리지 않는다.`,
    '5. CheckList 속도 개선은 CheckList 판정 결과가 같은 대체 방법만 올린다(할 일을 빼는 안 금지).',
    '6. 반영은 자동 반영 기준(orch-selfcheck.js autoEligible)을 따른다. fix·core 모두 자동(coreAutoApply), 승인 유지 = 실행 hook 스크립트·.claude/settings.json·DB 객체·시험 계정 설정·작업 모드 변경, FE·BE 소스는 작업 모드를 따름(UI/DB MODE 자동 · DB MODE 금지). plain 에 업무 말로 무엇이 바뀌는지, 위험, 되돌리는 법을 적는다.',
    '8. 기능 개선과 기능 추가(2026-11-26 사용자 지시 "VMO 기능에 한계 없음"): VM 전 과정(파싱 → 분석 → 개발 → 보완 → 시험 → CheckList)과 VMW 업무 작업을 단계마다 따라가며 사람이 손으로 하고 있는 일, 빠진 도구, 끊긴 연결(생성기 없이 수작업 1화면에만 있는 사실 파일 등)을 찾아 기능 추가 안을 낸다. 요청받지 않은 기능도 목적에 필요하면 올린다.',
    '9. UI MODE 전환 준비(차주부터 UI/DB MODE 로 AS-IS → TO-BE 화면 전환 개발): UI 개발 경로(tools/Harness gen.js·check.js 게이트, 화면별 대조표 __asis-mapping__.md, 참조 화면 DMF0004~0006 패턴, 신규 화면 필수 3종 ui-dynamic-property-management·menu-button-dynamic-fetch·ui-category-setup-column-meta, 화면 완료 게이트 screen-completion-gate G1~G11, 작업 모드 전환 set_scope.py, 보완 체인 🧯·🛠️)을 점검해 UI 개발이 누락 없이 끝까지 돌도록 부족한 생성기·게이트·VMO 감시·체인 단계를 안으로 올린다. 개발 중 CheckList 가 같은 기준으로 바로 잴 수 있는지도 본다.',
    '10. UI/UX 추천: VM·VMO·VMW 웹뷰(tools/VibeManager 의 workbench.js, orchestra.js, jobs.js, flow-panel.js, menu-view.js, prompt-panel.js, history.js, tabview.js 와 media 폴더)를 읽고, 사용자가 요청한 부분에 한정하지 않고 지금 널리 쓰이는 UI/UX 관행(정보 위계와 요약 먼저, 진행 상태와 남은 시간 표시, 빈 상태·오류 안내와 다음 행동, 키보드 접근성, 일관된 컴포넌트와 간격, 다크 모드, 좁은 폭 대응, 알림 과다 줄이기)에 비춰 개선안을 낸다. 근거는 화면 파일:줄과 어긋난 관행.',
    '7. 감·예측 금지. 확인하지 못한 것은 "미확인" 으로 적는다. 문장은 한국어 업무 문서 문체(수식어, 번역투, 줄표 금지).',
    '',
    '마지막 출력은 JSON 코드 블록 1개다.',
    require('./orch-improve').IMPACT_RULE,
    require('./orch-improve').VERIFY_RULE,
    '```json',
    '{ "summary": "3문장 이내", "purposes": [ { "purpose": "", "source": "근거 문서", "verdict": "맞음|어긋남|미확인", "evidence": "수치와 출처" } ], "proposals": [ { "title": "", "impact": "core|fix", "level": "L1|L2|L3|L4", "levelWhy": "", "evidence": "수치와 출처 파일", "targets": ["바꿀 파일 경로"], "before_after": "변경 전 → 변경 후", "verify": "검증 명령과 반영 전 값 → 반영 뒤 기대값", "rollback": "되돌리는 방법", "sig": "같은 안을 가릴 짧은 서명", "plain": { "what": "", "risk": "", "undo": "" } } ] }',
    '```',
    '',
    '[목적]', ...purposeDocs().map(d => `--- ${d.src}\n${d.text}`),
    '',
    '[실행 상태]', JSON.stringify(stateDocs(), null, 1).slice(0, 60000),
    '',
    `[이미 올라온 개선안 ${known.length}건]`, known.length ? JSON.stringify(known, null, 1) : '없음',
  ].join('\n');
}

/** 큰 그림 점검 1회. manual = 단추. 반환 { ok, added, dups, file } | { skipped } */
async function run(manual) {
  const c = cfg(); if (!manual && (c.enabled === false || !c.visionEnabled)) return { skipped: '꺼짐' };
  if (running) return { skipped: '점검 중' };
  const agent = mod('orch-agent'); if (!agent || !agent.runClaude) return { skipped: '에이전트 없음' };
  running = (async () => {
    const t0 = Date.now(); say('start', { manual: !!manual });
    const prompt = buildPrompt(c);
    const r = await agent.withLock('vision', async () => { agent.say('start', { id: 'vision', text: '큰 그림 점검. VM, VMO 가 목적에 맞는지 판단' }); return agent.runClaude(prompt, { label: '큰 그림 점검', permissionMode: 'default', allowedTools: READ_TOOLS }); });
    if (r && r.busy) { say('end', { ok: false, why: '에이전트 사용 중' }); return { skipped: '에이전트 사용 중' }; }
    const out = agent.lastJsonBlock(r.text); const m = { lastMs: Date.now(), lastAt: nowLocal(), manual: !!manual, sec: Math.round((Date.now() - t0) / 1000), log: r.log || '' };
    if (!r.ok || !out) { m.lastResult = !r.ok ? `점검 실패 exit ${r.code}${r.timedOut ? ' (시간 초과)' : ''}` : '결과 JSON 없음'; writeJson(path.join(vDir(), 'meta.json'), m); agent.say('end', { id: 'vision', ok: false, text: `큰 그림 점검 ${m.lastResult}` }); say('end', { ok: false, why: m.lastResult }); return { ok: false, why: m.lastResult }; }
    const imp = mod('orch-improve'); let added = 0, dups = 0; const ids = [];
    for (const o of (Array.isArray(out.proposals) ? out.proposals : []).slice(0, c.visionMaxPerRun)) { if (!o || !o.title || !o.evidence) continue; const a = imp ? imp.add(o, 'vision') : {}; if (a.id) { added++; ids.push(a.id); } else dups++; }
    const file = path.join(vDir(), `${stamp()}.json`); writeJson(file, { at: nowLocal(), summary: String(out.summary || ''), purposes: Array.isArray(out.purposes) ? out.purposes.slice(0, 40) : [], proposals: ids, log: r.log || '' });
    const miss = (out.purposes || []).filter(p => p && p.verdict === '어긋남').length;
    m.lastResult = `목적 ${(out.purposes || []).length}건 중 어긋남 ${miss} · 개선안 ${added}건 등록${dups ? ` · 중복 ${dups}건 제외` : ''}`; m.summary = String(out.summary || '').slice(0, 600); m.file = path.relative(P().root, file); m.purposes = (out.purposes || []).slice(0, 40);
    writeJson(path.join(vDir(), 'meta.json'), m);
    agent.say('end', { id: 'vision', ok: true, text: `큰 그림 점검 완료. ${m.lastResult}. ${m.summary}` }); say('end', { ok: true, added });
    if (added && notifier) { try { notifier(`큰 그림 점검: 개선안 ${added}건 승인 대기`); } catch (e) { errlog.note('orch-vision', 'notify', e); } }
    if (orchEv) orchEv.emit('vision', { added, miss, sec: m.sec });
    return { ok: true, added, dups, file: m.file };
  })();
  try { return await running; } catch (e) { errlog.note('orch-vision', 'run', e); return { ok: false, why: e.message }; } finally { running = null; }
}

function init(o) {
  getPaths = o.paths; opts = o || {}; notifier = o.notify || null;
  try { require('./orch-consult').init({ paths: o.paths, notify: o.notify, noTimer: o.noTimer }); } catch (e) { errlog.note('orch-vision', 'consult init', e); } // 2026-11-26 VMO 컨설팅 검토(orch-consult.js) — 큰 그림 점검과 같은 paths·알림, 자기 타이머
  if (timer) return;
  if (o.noTimer) return;
  timer = setInterval(() => { try { if (due()) run(false); } catch (e) { errlog.note('orch-vision', 'timer', e); } }, 3600000);
  const first = setTimeout(() => { try { if (due()) run(false); } catch (e) { errlog.note('orch-vision', 'first', e); } }, 10 * 60000); if (first.unref) first.unref(); // 창을 연 뒤 10분: 다시 로드 때마다 바로 돌지 않게
}
function dispose() { try { require('./orch-consult').dispose(); } catch { /* 없음 */ } if (timer) { clearInterval(timer); timer = null; } }
module.exports = { init, dispose, on, run, due, meta, buildPrompt, purposeDocs, stateDocs, DEF };
