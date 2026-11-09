#!/usr/bin/env node
'use strict';
// e2e-judge — 🩹 E2E 오류 보완의 '독립 판정 세션' (2026-10-26, Atlas Studio 규약 이식: 검토자 분리 · 근거 등급)
//   node tools/Harness/e2e-judge.js <ID> <kind> [--round N] [--from <판정 JSON 파일>]
//
// 왜: 종전엔 수선한 Claude 세션이 스스로 실패 원인을 a(화면)/b(DB)/c(기대값) 로 분류했고, c 만 남으면 시험 기준을 고치고
//     그래도 실패하면 경고로 넘어갔다 — 고치지 못한 세션이 테스트 탓으로 돌리는 판정이 근거 확인 없이 통과하는 경로.
// 하는 일
//   1) 새 Claude 세션(이전 대화 이어받지 않음)·읽기 전용 도구(Read·Glob·Grep — 수정·실행 도구 차단)로 실패 항목을 다시 분류
//   2) 판정마다 근거 = 권위 원천의 '경로:줄 + 그 줄 원문 인용' → verify/evidence_check.py 가 실제로 있는지 확인(hard/soft)
//   3) 결과 봉투 Doc/gen/<ID>/E2E_REPAIR.result.json — decision.expectFix(근거 확인된 기대값 결함만 보정 허용) ·
//      decision.human(근거 없는 기대값 결함·판정 불가 = 사람 확인) · state input-required 면 사람 확인 대기
//   4) 사람 확인 항목은 Doc/e2e/_human_review.md 큐에 append, E2E_REPAIR.md 마지막 섹션에 '독립 판정' 표 append
// --from: Claude 를 부르지 않고 판정 JSON(아래 형식)을 파일에서 읽는다 — 배관 시험용
// exit 0 = 판정 기록됨(봉투의 state 를 볼 것) · 2 = 인자 오류 · 3 = 판정 실패(봉투 state=error 기록)
const fs = require('fs'); const path = require('path'); const { spawnSync } = require('child_process');
const env = require('./lib/envelope');
const ROOT = path.resolve(__dirname, '..', '..');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const ID = String(a[0] || '').toUpperCase(); const KIND = String(a[1] || '').toLowerCase();
if (!ID || !/^(smoke|crud|auth|authcrud)$/.test(KIND)) { console.log('사용: node tools/Harness/e2e-judge.js <ID> <smoke|crud|auth|authcrud> [--round N] [--from file]'); process.exit(2); }
const GEN = path.join(ROOT, 'Doc', 'gen', ID); const E2E = path.join(ROOT, 'Doc', 'e2e');
const repairMd = path.join(GEN, 'E2E_REPAIR.md'); const outFile = path.join(GEN, 'E2E_REPAIR.result.json');
const relp = p => path.relative(ROOT, p).split(path.sep).join('/');
const readT = p => { try { return fs.readFileSync(p, 'utf8').replace(/^﻿/, ''); } catch { return ''; } };
const now = () => { const d = new Date(); const z = n => String(n).padStart(2, '0'); return `${d.getFullYear()}-${z(d.getMonth() + 1)}-${z(d.getDate())} ${z(d.getHours())}:${z(d.getMinutes())}`; };

// ── 입력 수집 ──
const md = readT(repairMd); const secs = md.split(/^## /m); const lastSec = secs.length > 1 ? '## ' + secs[secs.length - 1] : '';
const hm = /^## 수선\s+(\d+)/.exec(lastSec); const ROUND = Number(opt('--round', hm ? hm[1] : 0)) || null;
const cm = /판정요약:\s*a=(\d+)\s*b=(\d+)\s*c=(\d+)/.exec(lastSec); const claim = cm ? { a: +cm[1], b: +cm[2], c: +cm[3] } : null;
// 2026-11-06(사용자 지시): run-e2e.cmd <종류> <ID> 결과·로그는 화면 폴더 Doc/e2e/results/<ID>/·Doc/e2e/logs/<ID>/ — 화면 폴더 먼저, 없으면(전환 전) 공용 위치.
//   공용 logs/ 는 첫 줄('==== … run-e2e <종류> … <ID>')이 이 화면인 것만 쓴다(종전: 화면 구분 없이 가장 최근 로그 — 다른 화면 로그를 읽을 수 있었다)
const SUMF = [path.join(E2E, 'results', ID, '_summary.csv'), path.join(E2E, 'results', '_summary.csv')].find(f => fs.existsSync(f)) || path.join(E2E, 'results', '_summary.csv');
const sumRows = readT(SUMF).split(/\r?\n/).filter(l => l.startsWith(`"${ID}","${KIND}"`));
const logs = (() => {
  const reF = new RegExp(`^run_\\d+_\\d+_(${KIND}|all)\\.log$`); const out = [];
  const add = (dir, rel, need) => { try { for (const f of fs.readdirSync(dir)) { if (!reF.test(f)) continue; const p = path.join(dir, f); if (need && !new RegExp(`run-e2e\\b.*\\b${ID}\\b`, 'i').test(readT(p).split(/\r?\n/)[0] || '')) continue; out.push({ rel: rel + f, p, t: fs.statSync(p).mtimeMs }); } } catch { } };
  add(path.join(E2E, 'logs', ID), `${ID}/`, false); add(path.join(E2E, 'logs'), '', true);
  return out.sort((a, b) => b.t - a.t);
})();
const logRel = logs[0] ? `Doc/e2e/logs/${logs[0].rel}` : '(없음)';
// 실패 원문은 스크립트가 직접 뽑아 프롬프트에 싣는다 — 판정 세션의 Read 가 큰 CSV·로그에서 EBADF 로 실패한 사례(2026-10-26 SCP0122 첫 실행)
const csvCells = l => { const out = []; let cur = '', q = false; for (let i = 0; i < l.length; i++) { const ch = l[i]; if (q) { if (ch === '"' && l[i + 1] === '"') { cur += '"'; i++; } else if (ch === '"') q = false; else cur += ch; } else if (ch === '"') q = true; else if (ch === ',') { out.push(cur); cur = ''; } else cur += ch; } out.push(cur); return out; };
const failRows = sumRows.map(csvCells).filter(c => c[3] === 'FAIL').map(c => ({ account: c[2], errors: c[6] || '', annotations: (c[7] || '').slice(0, 1500) }));
const errText = failRows.map(r => r.errors).join(' || ');
const logErr = (() => { if (!logs[0]) return ''; const L = readT(logs[0].p).split(/\r?\n/); const out = []; for (let i = 0; i < L.length && out.join('\n').length < 6000; i++) if (/\bError:/.test(L[i])) out.push(L.slice(i, i + 8).join('\n'), '---'); return out.join('\n'); })();
const normT = s => String(s || '').replace(/\[[^\]]*\]/g, ' ').replace(/\([^)]*\)/g, ' ').replace(/[`'"]/g, '').replace(/\s+/g, ' ').trim().toLowerCase();
// 판정 항목이 실제 실패 목록(요약 errors 열)에 있는가 — 실패하지 않은 항목에 보정을 허용하지 않기 위함
const inFailList = title => { const t = normT(title); if (!t || !errText) return false; const e = normT(errText); return e.includes(t) || t.split(' ').filter(w => w.length > 1).every(w => e.includes(w)); };

function failRec(why) {
  env.write(outFile, { producer: 'e2e-judge', id: ID, kind: KIND, round: ROUND, state: 'error', verdict: null, why, repairClaim: claim,
    decision: { expectFix: [], human: [], retest: false }, evidence: [{ kind: 'agent-judgment', ref: 'e2e-judge 실패' }] });
  console.log(`JUDGE: ERROR ${why} → ${relp(outFile)}`); process.exit(3);
}
if (!sumRows.some(l => l.includes('"FAIL"'))) console.log(`(참고) _summary.csv 에 ${ID} ${KIND} FAIL 행이 없음 — 최근 결과 기준으로 판정`);

const PROMPT = `너는 NSCM E2E 실패의 **독립 판정자**다. 화면 ${ID} 의 E2E ${KIND} 단계가 실패했고, 다른 세션이 이미 원인을 찾아 일부를 고쳤다(아래 수선 기록).
너의 일은 **고치는 것이 아니라 판정만** 하는 것이다. 파일을 수정하거나 명령을 실행하지 마라(읽기·검색 도구만 쓸 수 있다).

## 판정 대상 — 실패 항목 = 아래 '실패 요약' 의 errors 에 있는 것만(여기 없는 항목을 새로 만들지 마라)
- 실패 요약(${relp(SUMF)} 의 "${ID}","${KIND}" FAIL 행 — 스크립트가 옮김):
${failRows.length ? failRows.map((r, n) => `  ${n + 1}) account=${r.account || '-'} errors=${r.errors}\n     annotations=${r.annotations}`).join('\n') : '  (FAIL 행 없음 — 판정할 실패 항목이 없으면 items 를 비워라)'}
- 실행 로그 ${logRel} 의 Error: 블록(스크립트가 옮김):
${logErr || '  (없음)'}
- 스펙·계획: Doc/e2e/specs/${ID}.${KIND}.spec.ts · Doc/e2e/specs/${ID}.plan.json
- 수선 기록(다른 세션의 주장 — 그대로 믿지 말고 근거를 직접 확인하라): Doc/gen/${ID}/E2E_REPAIR.md 의 마지막 '## 수선' 섹션
- 권위 원천(근거는 여기서만 인용한다): AS-IS 소스 GSCM/**/*.cs · TO-BE 화면 nscm-fe/features/**/pages/** · 메타 Doc/tobefacts/db/*.csv(sheet_columns·btn_auth·proc_params·proc_meta·menu) · AS-IS Fact Pack Doc/asisfacts/screens/<AS-IS ID>/*.csv · E2E 헬퍼 tools/E2E/lib/*

## 분류 (실패 항목마다 하나)
- screen: TO-BE 화면 결함(라벨·컬럼·버튼·편집 가능 여부·저장 페이로드 등이 AS-IS·메타와 다름)
- db: DB 객체·메타 결함(PKG/SP 오류, PROC_M·btn_auth·sheet_columns·메뉴 등록 누락)
- expectation: E2E 기대값·측정 결함(시험이 AS-IS·메타와 다른 것을 기대하거나 측정이 틀림)
- undetermined: 근거로 확정할 수 없음

## 근거 규칙 (기계가 확인한다 — 지키지 않으면 그 판정은 'AI 판단' 으로 강등되어 사람 확인으로 넘어간다)
- 근거 하나 = {"kind":"source","ref":"<저장소 루트 기준 경로>:<줄>","expect":"<그 줄 원문을 그대로 옮긴 일부>"}
- 줄 번호를 지어내지 마라. 반드시 Read 로 연 파일에서 본 줄을 적고, expect 는 그 줄(±3줄) 안에 글자 그대로 있는 문자열이어야 한다.
- CSV 처럼 줄 번호를 쓰기 어려우면 ref 에 경로만 쓰고 expect 를 배열로 — 같은 한 줄 안에 모두 나와야 하는 토큰들(예 ["${ID}","OPMZ_ACTV_SEQ","M"]).
- expectation 판정에는 '시험이 기대한 것' 과 '권위 원천이 말하는 것' 이 다르다는 근거가 둘 다 필요하다(스펙/헬퍼 줄 + 원천 줄).
- 근거를 찾지 못하면 evidence 를 비우고 class 를 undetermined 로 둔다. 추측으로 채우지 마라.

## 출력 — 마지막 메시지에 JSON 하나만(설명 문장·코드펜스 없이)
{"items":[{"id":"1","title":"<실패 테스트 제목>","class":"screen|db|expectation|undetermined","repair_class":"<수선 기록의 판정 a|b|c, 없으면 ->","msg":"<판정 사유 1~2문장>","evidence":[{"kind":"source","ref":"...","expect":"..."}]}],"notes":"<수선 기록과 다르게 판정한 이유 등>"}`;

function askClaude() {
  const bin = (process.env.CLAUDE_BIN || '').trim() || 'claude'; const cmd = /\s/.test(bin) ? `"${bin}"` : bin;
  const args = ['-p', '--output-format', 'json', '--permission-mode', 'default', '--allowedTools', 'Read,Glob,Grep',
    '--disallowedTools', 'Edit,Write,MultiEdit,NotebookEdit,Bash,WebFetch,WebSearch', ...(process.env.CLAUDE_MODEL ? ['--model', process.env.CLAUDE_MODEL] : [])];
  console.log(`▶ 독립 판정 세션 시작 — 새 세션 · 읽기 전용(Read·Glob·Grep) · ${ID} ${KIND} round ${ROUND || '?'}`);
  const r = spawnSync(cmd, args, { cwd: ROOT, input: PROMPT, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, shell: process.platform === 'win32', timeout: 30 * 60 * 1000,
    env: Object.assign({}, process.env, { VIBE_HARNESS: '1', NSCM_SKIP_RULE_READ: '1' }) });
  if (r.error) failRec(`Claude 실행 실패: ${r.error.message}`);
  let j; try { j = JSON.parse(r.stdout); } catch { failRec(`Claude 출력 해석 실패(exit ${r.status}): ${(r.stdout || r.stderr || '').slice(0, 300)}`); }
  if (j.is_error) failRec(`Claude 오류: ${String(j.result || '').slice(0, 300)}`);
  if (j.permission_denials && j.permission_denials.length) console.log(`  (차단된 도구 호출 ${j.permission_denials.length}건 — 읽기 전용 제한이 동작함)`);
  return String(j.result || '');
}
function parseJudge(text) {
  const t = text.replace(/^```(?:json)?\s*/m, '').replace(/```\s*$/m, ''); const i = t.indexOf('{'); const k = t.lastIndexOf('}');
  if (i < 0 || k < i) failRec('판정 JSON 없음');
  let j; try { j = JSON.parse(t.slice(i, k + 1)); } catch (e) { failRec(`판정 JSON 해석 실패: ${e.message}`); }
  if (!Array.isArray(j.items)) failRec('판정 JSON 에 items 배열 없음');
  return j;
}

const judged = parseJudge(opt('--from') ? readT(path.resolve(opt('--from'))) : askClaude());
const CLASSES = ['screen', 'db', 'expectation', 'undetermined'];
const issues = judged.items.map((it, n) => ({ id: String(it.id || n + 1), class: CLASSES.includes(it.class) ? it.class : 'undetermined', title: String(it.title || ''),
  msg: String(it.msg || ''), repair_class: String(it.repair_class || '-'), evidence: (Array.isArray(it.evidence) ? it.evidence : []).filter(e => e && typeof e === 'object') }));
env.write(outFile, { producer: 'e2e-judge', id: ID, kind: KIND, round: ROUND, state: 'completed', verdict: 'fail', issues, repairClaim: claim, notes: String(judged.notes || ''),
  evidence: [{ kind: 'agent-judgment', ref: 'claude -p 읽기 전용 독립 판정' }] });
// 근거 확인(hard/soft) — 같은 파일에 verified·grade 기록
const py = spawnSync('python', [path.join(__dirname, 'verify', 'evidence_check.py'), outFile, '--quiet'], { cwd: ROOT, encoding: 'utf8' });
if (py.status !== 0) failRec(`근거 확인 실패: ${(py.stdout || '') + (py.stderr || '')}`.slice(0, 300));
const e = env.read(outFile); if (e.state === 'error') failRec(e.why);
for (const i of e.issues) i.in_fail_list = failRows.length ? inFailList(i.title) : null; // null = 요약에 FAIL 행이 없어 대조 불가
const expectFix = e.issues.filter(i => i.class === 'expectation' && i.grade === 'hard' && i.in_fail_list !== false).map(i => i.id);
const human = e.issues.filter(i => (i.class === 'expectation' && !expectFix.includes(i.id)) || i.class === 'undetermined').map(i => i.id);
const cnt = c => e.issues.filter(i => i.class === c).length;
const summary = { screen: cnt('screen'), db: cnt('db'), expectation: cnt('expectation'), expectation_hard: expectFix.length, expectation_soft: cnt('expectation') - expectFix.length, undetermined: cnt('undetermined'),
  disagree: claim ? Math.abs((claim.c || 0) - cnt('expectation')) : null };
const state = human.length ? 'input-required' : 'completed';
delete e.file;
env.write(outFile, Object.assign(e, { state, verdict: human.length ? 'hold' : 'fail', summary, decision: { expectFix, human, retest: summary.screen + summary.db > 0 || expectFix.length > 0 } }));

// 사람 확인 큐 + 수선 기록에 독립 판정 표
if (human.length) {
  const q = path.join(E2E, '_human_review.md');
  if (!fs.existsSync(q)) fs.writeFileSync(q, '# E2E 사람 확인 큐 (독립 판정 결과 — 근거 미확인 기대값 결함·판정 불가)\n\n> e2e-judge.js 가 append. 확인 후 처리 열에 사람 이름·결정을 적는다. 이 행이 남아 있으면 해당 E2E 는 완료가 아니다.\n\n| 일시 | 화면 | 종류 | 수선 회차 | 항목 | 판정 | 근거 상태 | 수선 세션 판정 | 처리(사람) |\n|---|---|---|---|---|---|---|---|---|\n', 'utf8');
  const esc = s => String(s || '').replace(/\|/g, '/').replace(/\r?\n/g, ' ').slice(0, 160);
  fs.appendFileSync(q, e.issues.filter(i => human.includes(i.id)).map(i => `| ${now()} | ${ID} | ${KIND} | ${ROUND || '-'} | ${esc(i.title || i.msg)} | ${i.class} | ${esc((i.evidence || []).map(v => v.why).join('; ') || '근거 없음')} | ${i.repair_class} | |`).join('\n') + '\n', 'utf8');
}
if (fs.existsSync(repairMd)) {
  const L = ['', `### 독립 판정 — ${now()} (e2e-judge · 새 세션 · 읽기 전용)`, '', `결과: ${state === 'input-required' ? '⏸ 사람 확인 필요' : '판정 완료'} · 화면 ${summary.screen} · DB ${summary.db} · 기대값 ${summary.expectation}(근거 확인 ${summary.expectation_hard}) · 판정 불가 ${summary.undetermined}${claim ? ` · 수선 세션 주장 a=${claim.a} b=${claim.b} c=${claim.c}` : ''}`, '',
    '| 항목 | 판정 | 근거 등급 | 실패 목록 | 근거 확인 | 사유 |', '|---|---|---|---|---|---|',
    ...e.issues.map(i => `| ${(i.title || i.id).replace(/\|/g, '/').slice(0, 60)} | ${i.class} | ${i.grade} | ${i.in_fail_list === false ? '✖ 없음' : i.in_fail_list ? '✔' : '대조 불가'} | ${(i.evidence || []).map(v => `${v.verified ? '✔' : '✖'} ${v.why}`).join('<br>').replace(/\|/g, '/') || '근거 없음'} | ${i.msg.replace(/\|/g, '/').slice(0, 160)} |`),
    '', `결과 봉투: ${relp(outFile)} · 기대값 보정 허용 = 근거 확인된 항목(${expectFix.join(', ') || '없음'})만`, ''];
  fs.appendFileSync(repairMd, L.join('\n'), 'utf8');
}
console.log(`JUDGE: state=${state} screen=${summary.screen} db=${summary.db} expectation=${summary.expectation}(hard ${summary.expectation_hard}/soft ${summary.expectation_soft}) undetermined=${summary.undetermined} → ${relp(outFile)}`);
process.exit(0);
