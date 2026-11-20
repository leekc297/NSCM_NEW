'use strict';
// 결과 봉투 vibe-result/1 — 판정 산출물 옆에 두는 <이름>.result.json (2026-10-26)
//   형식은 Atlas Studio 결과 봉투(state·verdict·issues·evidence)를 따른다. 짝 = tools/Harness/verify/envelope.py (같은 규칙 — 한쪽만 고치지 말 것)
//   { schema, producer, id, kind?, round?, ts, state, verdict, summary{}, issues[{id,class,msg,grade,evidence[]}], evidence[], decision{} }
//   state   = completed | failed | input-required(사람 확인 대기) | error(실행·판정 불가)
//   verdict = pass | fail | hold | null
//   evidence.kind: 기계 근거 = test·build·lint·schema·exec·db·source(검증된 인용) / 사람 = human(by 필수) / AI 판단 = agent-judgment
//   읽기 규칙: 파일 없음·깨짐·형식 위반 = state 'error' 로 돌려준다 — 판정이 없는 것을 통과로 보지 않는다.
const fs = require('fs'); const path = require('path');
const SCHEMA = 'vibe-result/1';
const STATES = ['completed', 'failed', 'input-required', 'error'];
const VERDICTS = ['pass', 'fail', 'hold'];
const MACHINE = ['test', 'build', 'lint', 'schema', 'exec', 'db'];
const AI_NAMES = /^(ai|claude|agent|assistant|bot)\b/i;

const sidecar = file => file.endsWith('.result.json') ? file : file.replace(/\.(md|csv|json|xlsx)$/i, '') + '.result.json';

// 근거 하나가 '기계·사람 근거(hard)' 인가. source 는 evidence_check.py 가 verified=true 로 확인한 것만.
function isHard(ev) {
  if (!ev || typeof ev !== 'object') return false;
  if (MACHINE.includes(ev.kind)) return ev.verified !== false;
  if (ev.kind === 'source') return ev.verified === true;
  if (ev.kind === 'human') return !!(ev.by && !AI_NAMES.test(String(ev.by).trim()));
  return false;
}
const gradeOf = issue => ((issue && issue.evidence) || []).some(isHard) ? 'hard' : 'soft';

function write(file, env) {
  const out = Object.assign({ schema: SCHEMA, ts: new Date().toISOString() }, env);
  if (!STATES.includes(out.state)) throw new Error(`state 값 오류: ${out.state}`);
  if (out.verdict != null && !VERDICTS.includes(out.verdict)) throw new Error(`verdict 값 오류: ${out.verdict}`);
  out.issues = (out.issues || []).map(i => Object.assign({}, i, { grade: i.grade || gradeOf(i) }));
  out.evidence = out.evidence || [];
  const p = sidecar(file); fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p + '.tmp', JSON.stringify(out, null, 1), 'utf8'); fs.renameSync(p + '.tmp', p);
  return p;
}

function read(file) {
  const p = sidecar(file); const err = why => ({ schema: SCHEMA, state: 'error', verdict: null, issues: [], evidence: [], why, file: p });
  if (!fs.existsSync(p)) return err('결과 파일 없음');
  let j; try { j = JSON.parse(fs.readFileSync(p, 'utf8').replace(/^﻿/, '')); } catch (e) { return err(`결과 파일 해석 실패: ${e.message}`); }
  if (!j || j.schema !== SCHEMA) return err(`schema 불일치: ${j && j.schema}`);
  if (!STATES.includes(j.state)) return err(`state 값 오류: ${j.state}`);
  if (j.verdict != null && !VERDICTS.includes(j.verdict)) return err(`verdict 값 오류: ${j.verdict}`);
  j.issues = Array.isArray(j.issues) ? j.issues : []; j.evidence = Array.isArray(j.evidence) ? j.evidence : []; j.file = p;
  return j;
}

module.exports = { SCHEMA, STATES, VERDICTS, sidecar, isHard, gradeOf, write, read };
