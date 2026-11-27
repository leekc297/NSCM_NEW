// 2026-11-26 사용자 지시('VMO 는 IT 컨설턴트이며, DB, UI 모두를 섭렵한 최고의 엔지니어 · 자신의 입장에서 현재의 VM 을 바라보면서 기능추가/보완에 대한 의견을 스스로 내고 개발을 진행'):
//   VMO 컨설팅 검토. 큰 그림 점검(orch-vision.js · 사용자가 말한 목적에 맞는지)과 달리, 컨설턴트 겸 수석 엔지니어 입장에서 VM 전체를 진단하고
//   ① 현황 진단(강점 · 약점 · 위험) ② 개선 로드맵(지금 · 다음 · 나중) ③ 바로 개발할 개선안을 낸다. 개선안은 orch-improve 에 올라가 자동 반영 기준(orch-selfcheck.js autoEligible)으로 개발까지 간다.
//   보고 = .vibe/orch/consult/<시각>.md · last.md(다음 검토가 같은 제안을 되풀이하지 않게 읽음) · meta.json
//   주기 = harness.json orch.consultEveryDays(기본 1일) · 끄기 orch.consultEnabled false · 한 번에 올리는 개선안 상한 orch.consultMaxPerRun(기본 6)
//   초기화 = orch-vision.js init 이 함께 부른다(같은 paths · 같은 알림)
'use strict';
const fs = require('fs'); const path = require('path');
let errlog = { note() { } }; try { errlog = require('./orch-errlog'); } catch { /* 없음 */ }
let getPaths = null; let opts = {}; let notifier = null; let timer = null; let running = null;
const P = () => getPaths();
const DEF = { consultEnabled: true, consultEveryDays: 1, consultMaxPerRun: 6 };
const two = n => String(n).padStart(2, '0');
const nowLocal = ms => { const d = ms ? new Date(ms) : new Date(); return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())} ${two(d.getHours())}:${two(d.getMinutes())}:${two(d.getSeconds())}`; };
const stamp = () => { const d = new Date(); return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}_${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`; };
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
const writeText = (f, s) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f + '.t', s, 'utf8'); fs.renameSync(f + '.t', f); } catch (e) { errlog.note('orch-consult', 'write', e); } };
const cDir = () => path.join(P().vibeDir, 'orch', 'consult');
const mod = n => { if (opts.mods && opts.mods[n]) return opts.mods[n]; try { return require(`./${n}`); } catch (e) { errlog.note('orch-consult', `require ${n}`, e); return null; } };
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); return Object.assign({}, DEF, (h && h.orch) || {}); }
function meta() { return readJson(path.join(cDir(), 'meta.json'), {}); }
function due(now) { const c = cfg(); if (c.enabled === false || c.consultEnabled === false) return false; const m = meta(); return !m.lastMs || (now || Date.now()) - m.lastMs >= Number(c.consultEveryDays || 1) * 86400000; }

const PERSONA = [
  '역할: 너는 IT 컨설턴트이자 Oracle DB(SQL · PL/SQL · 성능), React/TypeScript UI, Spring Boot, 테스트 자동화, VS Code 확장 개발을 모두 다루는 수석 엔지니어다.',
  '고객 시스템을 진단하듯 Vibe_Manager 전체를 본다: VM(VS Code 확장 · 화면별 Workbench · VMW 업무 작업 · 체인 quick.json/steps.json), VMO(감시 · 자가진단 · 개선안 · 에이전트 · tools/VibeManager/orch-*.js), 하네스(tools/Harness · AS-IS 파싱 · 분석 · 생성 gen.js · 게이트 check.js · CheckList 검사기 verify/), E2E(tools/E2E · Doc/e2e/specs), 문서·매뉴얼 생성(tools/Docs · tools/Analysis), 클라우드 이관(tools/CloudPkg).',
  '프로젝트: LG Energy Solution NSCM. AS-IS C#.NET WinForms → TO-BE React 18 + Spring Boot 3.5 + Oracle 19c. VM 의 목적 = 파싱 → 분석 → 개발 → 보완 → 시험 → CheckList 를 누락 없이, 빠르게, 사람 손을 덜 쓰고 끝내는 것. 지금은 DB MODE 로 CheckList 정확도에 집중했고 차주부터 UI/DB MODE 로 AS-IS → TO-BE 화면 전환 개발을 한다.',
].join('\n');

function buildPrompt(c, known) {
  return [
    '.claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 VMO 컨설팅 검토다. 파일을 고치지 않는다(읽기만).',
    PERSONA,
    '',
    '읽을 곳(필요한 만큼 더 읽는다): tools/VibeManager/CONCEPT.md · README.md · CHANGELOG.md(위쪽 최근 절) · quick.json · steps.json · package.json · orch-*.js · workbench.js 와 웹뷰 파일, tools/Harness/harness.json · tools/Harness/README.md(도구 등록부), .vibe/orch/selfcheck/result.json(자가진단 결과) · .vibe/orch/selfcheck/checker_scan.json(검사기 결함 탐색) · .vibe/orch/vision/meta.json(큰 그림 점검), Doc/verify/_ENGINE_MASTER.md · Doc/verify/_checker_defects.md(끝부분), CLAUDE.md, .vibe/orch/consult/last.md(지난 컨설팅 보고 — 같은 제안을 되풀이하지 않는다).',
    '',
    '할 일',
    '1. 현황 진단: 영역(파싱 · 분석 · UI 개발 · DB 개발 · 보완 · 시험 · CheckList · VMO · UI/UX · 운영)마다 강점 · 약점 · 위험을 근거(파일:줄, 기록 파일의 수치와 시각)와 함께 적는다.',
    '2. 개선 로드맵: 지금(이번 주) · 다음(차주 UI MODE 전환 전후) · 나중으로 나눠 항목마다 왜 필요한지와 효과를 잴 방법(지표 · 측정 도구)을 적는다. 기대 수치를 지어내지 않는다.',
    `3. 이번에 바로 개발할 개선안 최대 ${c.consultMaxPerRun}건: 기능 추가와 보완 모두. 사용자가 요청하지 않은 것도 컨설턴트로서 필요하다고 판단하면 낸다. UI/UX 는 지금 널리 쓰이는 관행(요약 먼저, 진행과 남은 시간, 빈 상태·오류 안내와 다음 행동, 키보드 접근성, 일관된 컴포넌트, 다크 모드, 좁은 폭, 알림 과다 줄이기) 기준.`,
    '',
    '규칙',
    '- 근거를 소스·기록에서 확인하지 못한 것은 올리지 않는다. 감·예측 금지, 확인 못 한 것은 "미확인".',
    '- 아래 [이미 올라온 개선안] · 반려된 안과 같은 내용은 올리지 않는다. 사용자 결정(tools/Harness/rules/checker_scan_ignore.csv, 메모리 feedback_* 문서)을 뒤집는 안은 올리지 않는다.',
    '- 개선안 하나는 한 번에 반영·검증할 수 있는 크기로 나눈다. targets 는 저장소 기준 경로. 실행 hook 스크립트·.claude/settings.json 을 고치는 부분은 코드 안과 나눠 올린다. FE·BE 소스(nscm-fe · nscm-be) 안은 작업 모드가 UI/DB MODE(DB_FE)일 때 반영된다는 점을 plain 에 적는다.',
    '- verify 는 반영할 때 실행할 명령(node tools/VibeManager/test/run_all.js · python tools/Harness/verify/engine_selfcheck.py · 해당 --selftest)과 반영 뒤 확인을 나눠 적는다. 새 기능에는 시험 파일을 함께 넣는다.',
    '- 문장은 한국어 업무 문서 문체(수식어 · 번역투 · 줄표 금지).',
    '',
    '마지막 출력은 JSON 코드 블록 1개다.',
    (() => { try { return require('./orch-improve').IMPACT_RULE; } catch { return ''; } })(),
    '```json',
    '{ "summary": "3문장 이내", "assessment": [ { "area": "", "verdict": "강점|약점|위험", "evidence": "" } ], "roadmap": [ { "when": "지금|다음|나중", "item": "", "why": "", "measure": "" } ], "proposals": [ { "title": "", "impact": "fix|core", "level": "L1|L2|L3|L4", "evidence": "", "targets": [""], "before_after": "", "verify": "", "rollback": "", "plain": "" } ] }',
    '```',
    '',
    `[이미 올라온 개선안 ${known.length}건]`, known.length ? JSON.stringify(known, null, 1) : '없음',
  ].join('\n');
}

/** 결과 JSON → 보고서(markdown) */
function reportMd(out, ids, at) {
  const L = [`# VMO 컨설팅 검토 ${at}`, '', String(out.summary || ''), '', '## 현황 진단', '| 영역 | 판단 | 근거 |', '|---|---|---|'];
  for (const a of out.assessment || []) L.push(`| ${a.area || ''} | ${a.verdict || ''} | ${String(a.evidence || '').replace(/\|/g, '/').replace(/\n/g, ' ')} |`);
  L.push('', '## 개선 로드맵', '| 시점 | 항목 | 이유 | 효과 측정 |', '|---|---|---|---|');
  for (const r of out.roadmap || []) L.push(`| ${r.when || ''} | ${String(r.item || '').replace(/\|/g, '/')} | ${String(r.why || '').replace(/\|/g, '/')} | ${String(r.measure || '').replace(/\|/g, '/')} |`);
  L.push('', '## 이번에 올린 개선안');
  (out.proposals || []).forEach((p, i) => L.push(`${i + 1}. ${p.title || ''}${ids[i] ? ` (${ids[i]})` : ' (중복 제외)'} · ${p.impact || ''} · 대상 ${(p.targets || []).join(', ')}`));
  return L.join('\n') + '\n';
}

async function run(manual) {
  const c = cfg(); if (!manual && (c.enabled === false || c.consultEnabled === false)) return { skipped: '꺼짐' };
  if (running) return { skipped: '검토 중' };
  const agent = mod('orch-agent'); if (!agent || !agent.runClaude) return { skipped: '에이전트 없음' };
  running = (async () => {
    const t0 = Date.now(); const imp = mod('orch-improve');
    const known = (imp ? imp.list() : []).filter(p => /^(pending|approved|applying|rejected)$/.test(p.status) || Date.now() - (p.ms || 0) < 14 * 86400000).slice(0, 80).map(p => ({ title: p.title, status: p.status, reason: p.reason || '' }));
    const r = await agent.withLock('consult', async () => { if (agent.say) agent.say('start', { id: 'consult', text: 'VMO 컨설팅 검토. 컨설턴트 겸 수석 엔지니어 입장에서 VM 전체 진단·로드맵·개선안' }); return agent.runClaude(buildPrompt(c, known), { label: 'VMO 컨설팅 검토', permissionMode: 'default', allowedTools: ['Read', 'Glob', 'Grep'] }); });
    if (r && r.busy) return { skipped: '에이전트 사용 중' };
    const out = agent.lastJsonBlock ? agent.lastJsonBlock(r && r.text) : null;
    const m = { lastMs: Date.now(), lastAt: nowLocal(), manual: !!manual, sec: Math.round((Date.now() - t0) / 1000), log: (r && r.log) || '' };
    if (!out) { m.lastResult = r && r.ok ? '결과 JSON 없음' : `검토 실패 exit ${r && r.code}`; writeText(path.join(cDir(), 'meta.json'), JSON.stringify(m, null, 1)); if (agent.say) agent.say('end', { id: 'consult', ok: false, text: `VMO 컨설팅 검토 ${m.lastResult}` }); return { ok: false, why: m.lastResult }; }
    const ids = []; let added = 0, dups = 0;
    for (const o of (Array.isArray(out.proposals) ? out.proposals : []).slice(0, c.consultMaxPerRun)) {
      if (!o || !o.title || !o.evidence) { ids.push(''); continue; }
      const a = imp ? imp.add(Object.assign({}, o, { title: /^컨설팅:/.test(o.title) ? o.title : `컨설팅: ${o.title}`, origin: 'consult' }), 'vision') : {};
      if (a.id) { added++; ids.push(a.id); } else { dups++; ids.push(''); }
    }
    const md = reportMd(out, ids, m.lastAt); const f = path.join(cDir(), `${stamp()}.md`);
    writeText(f, md); writeText(path.join(cDir(), 'last.md'), md);
    m.file = path.relative(P().root, f).replace(/\\/g, '/'); m.lastResult = `진단 ${(out.assessment || []).length}건 · 로드맵 ${(out.roadmap || []).length}건 · 개선안 ${added}건 등록${dups ? ` · 중복 ${dups}건 제외` : ''}`; m.summary = String(out.summary || '').slice(0, 600);
    writeText(path.join(cDir(), 'meta.json'), JSON.stringify(m, null, 1));
    if (agent.say) agent.say('end', { id: 'consult', ok: true, text: `VMO 컨설팅 검토 완료. ${m.lastResult}. 보고 ${m.file}` });
    if (notifier) { try { notifier(`VMO 컨설팅 검토: ${m.lastResult}(보고 ${m.file})`); } catch (e) { errlog.note('orch-consult', 'notify', e); } }
    return { ok: true, added, dups, file: m.file };
  })();
  try { return await running; } catch (e) { errlog.note('orch-consult', 'run', e); return { ok: false, why: e.message }; } finally { running = null; }
}

function init(o) {
  getPaths = o.paths; opts = o || {}; notifier = o.notify || null; if (timer || o.noTimer) return;
  timer = setInterval(() => { try { if (due()) run(false); } catch (e) { errlog.note('orch-consult', 'timer', e); } }, 3600000);
  const first = setTimeout(() => { try { if (due()) run(false); } catch (e) { errlog.note('orch-consult', 'first', e); } }, 25 * 60000); if (first.unref) first.unref(); // 창을 연 뒤 25분(큰 그림 점검 10분과 겹치지 않게)
}
function dispose() { if (timer) { clearInterval(timer); timer = null; } }
function ready() { return !!getPaths; }

module.exports = { init, dispose, ready, run, due, meta, buildPrompt, reportMd, PERSONA };
