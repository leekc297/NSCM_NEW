// 2026-11-26 사용자 지시('VMO 에서 지금 하고 있는 보완 작업을 자가검진해서 보완 진행 · 사용자 승인이 아닌 자동 승인 대상' ·
//   'VM 목적(파싱 → 분석 → 개발 → 보완 → 시험 → CheckList)을 완벽하게 진행하기 위해 필요한 모든 것을 스스로 찾아서 보완'):
//   VMO 자가진단 S16 검사기 판정 결함. 전 화면 원장의 판정 근거를 tools/Harness/verify/checker_defect_scan.py 로 모아(탐지기 K1~K5 · 미검증 상위 묶음)
//   새로 생기거나 늘어난 항목이 있으면 검사기 전용 Claude 진단(읽기 전용)을 돌려 개선안(자가진단 SELF)으로 올린다. 대상이 tools/·Doc/ 라 자동 반영 경로(autoEligible)를 탄다.
//   사용자 결정 예외 = tools/Harness/rules/checker_scan_ignore.csv(스캔이 빼고 셈). 진단 간격 = harness.json orch.checkerDiagGapHours(기본 6시간) · 끄기 = orch.checkerScanEnabled false
'use strict';
const fs = require('fs'); const path = require('path'); const { spawn } = require('child_process');
let errlog = { note() { } }; try { errlog = require('./orch-errlog'); } catch { /* 없음 */ }
let getPaths = null;
const P = () => getPaths();
const two = n => String(n).padStart(2, '0');
const nowLocal = (ms) => { const d = ms ? new Date(ms) : new Date(); return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())} ${two(d.getHours())}:${two(d.getMinutes())}:${two(d.getSeconds())}`; };
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); require('./fs-retry').writeFileSyncRetry(f + '.t', JSON.stringify(v, null, 1), 'utf8'); require('./fs-retry').renameSyncRetry(f + '.t', f); } catch (e) { errlog.note('orch-checkerscan', 'writeJson', e); } }; // 2026-11-26 개선안 20261126164445_VISION: 쓰기와 바꾸기 일시 실패 재시도(fs-retry.js)
const selfDir = () => path.join(P().vibeDir, 'orch', 'selfcheck');
const outFile = () => path.join(selfDir(), 'checker_scan.json');
const metaFile = () => path.join(selfDir(), 'checker_diag.json');
const SCRIPT = 'tools/Harness/verify/checker_defect_scan.py';

function init(o) { getPaths = o.paths; }
function ready() { return !!getPaths; }

function runScan(timeoutSec) {
  return new Promise(resolve => {
    let out = ''; let done = false;
    const fin = code => { if (done) return; done = true; clearTimeout(t); resolve({ code, out }); };
    let ch; try { ch = spawn('python', [path.join(P().root, SCRIPT), '--if-changed', '--out', outFile()], { cwd: P().root, windowsHide: true }); } catch (e) { resolve({ code: -1, out: String(e.message || e) }); return; }
    ch.stdout.on('data', d => { out += d; }); ch.stderr.on('data', d => { out += d; });
    ch.on('error', e => fin(-1, out += String(e.message || e))); ch.on('close', c => fin(c));
    const t = setTimeout(() => { try { ch.kill(); } catch { } fin(-2); }, (timeoutSec || 600) * 1000);
  });
}

/** 스캔 결과 → 점검 항목(전부 warn · 진단은 이 모듈이 따로 함). key = S16|K1 · S16|C|<rule>|<서명 앞 40자> */
function itemsFrom(j) {
  const items = [];
  if (!j) return items;
  for (const d of j.detectors || []) {
    if (!d.rows) continue;
    items.push({ level: 'warn', key: `S16|${d.id}`, rows: d.rows, what: `${d.id} ${d.name} ${d.rows}행/${(d.screens || []).length}화면`, detail: (d.samples || []).slice(0, 3).map(s => `${s.menu_id} ${s.row_id} ${s.rule_id || ''} ${s.result || ''}: ${String(s.evidence || '').slice(0, 120)}`).join(' | ') });
  }
  for (const c of j.clusters || []) {
    items.push({ level: 'warn', key: `S16|C|${c.rule_id}|${String(c.sig || '').slice(0, 40)}`, rows: c.rows, what: `미검증 묶음 ${c.rule_id} ${c.result} ${c.rows}행/${(c.screens || []).length}화면`, detail: `${c.sig} · 예 ${(c.samples || []).slice(0, 2).map(s => `${s.menu_id} ${s.row_id}`).join(', ')}` });
  }
  return items;
}

async function check() {
  if (!getPaths) return { skip: '초기화 전', items: [], info: {} };
  const r = await runScan(600);
  if (r.code !== 0) return { skip: `checker_defect_scan.py exit ${r.code} · ${String(r.out).slice(-200)}`, items: [], info: {} };
  const j = readJson(outFile(), null);
  if (!j) return { skip: 'checker_scan.json 없음', items: [], info: {} };
  return { items: itemsFrom(j), info: { at: j.at, ledgers: j.ledgers, rows: j.rows, ignored: Object.values(j.ignored || {}).reduce((a, b) => a + b, 0), out: path.relative(P().root, outFile()).replace(/\\/g, '/') } };
}

/** 진단할 항목 = 지난 진단 뒤 새로 생겼거나 행 수가 늘어난 항목 */
function newItems(items, seen) {
  return items.filter(it => !seen[it.key] || (it.rows || 0) > (seen[it.key].rows || 0));
}

function diagPrompt(rel) {
  return [
    '.claude/agents/vm-orchestra.md 의 지킬 것을 따른다. 이번 일은 VMO 자가진단 S16 검사기 판정 결함 진단이다. 파일을 고치지 않는다(읽기만).',
    'VMO 목적(2026-11-26 사용자 지시): VM 의 파싱 → 분석 → 개발 → 보완 → 시험 → CheckList 가 제대로 돌도록 필요한 것을 스스로 찾아 보완하고, 없는 기능은 추가한다.',
    `입력 파일 ${rel} 을 읽는다. items = 전 화면 원장(Doc/verify/<ID>/verify_ledger.csv) 판정 근거에서 tools/Harness/verify/checker_defect_scan.py 가 찾은 검사기 결함 후보(K1 한 글자 칸 이름, K2 같은 문구 반복, K3 재지 못한 행의 해당없음, K4 결과와 증거 어긋남, K5 칸 값 없음) 와 미검증 상위 묶음이다.`,
    '할 일: 항목마다 예시 원장 행을 열고, 그 증거 문장을 만든 소스(Doc/e2e/specs/*.spec.ts, tools/E2E/lib/*.ts, tools/Harness/verify/*.py 의 put/result 대입)를 Grep 으로 찾아 원인을 확인한다. 검사기 결함이면 고치는 개선안을 올린다(최대 3건). 원장이 지난 측정분이라 이미 고쳐진 결함이면(소스에 수정이 있음) 올리지 않고 summary 에 적는다.',
    '규칙',
    '- 재지 못한 행은 미검증(ERROR)이다(2026-11-11 결정). 해당없음(NA)은 원문·메타 근거가 있을 때만. 예외: tools/Harness/rules/checker_scan_ignore.csv 의 사용자 결정(결함 유형 행 직접 일치 없음 = 해당없음 유지)은 바꾸지 않는다.',
    '- 원장 파일(verify_ledger.csv)·CheckList 결과물을 직접 고치는 안은 올리지 않는다. 검사기(판정 코드)를 고친다. 다음 CheckList 실행부터 반영된다.',
    '- 개선안마다 근거(입력 항목 key, 원장 화면·행 번호, 소스 파일:줄)를 적는다. 소스에서 확인하지 못한 것은 올리지 않는다.',
    '- targets 는 저장소 기준 경로(tools/Harness/verify/…, Doc/e2e/specs/…, tools/E2E/lib/…). impact = fix(검사기 결함 수정) 또는 core(판정 기준 자체를 바꿈).',
    "- verify 에 'python tools/Harness/verify/engine_selfcheck.py PASS' 와 고친 파이썬 파일의 '--selftest ALL PASS'(있으면), spec 을 고쳤으면 'npx playwright test <spec> --list 로드 정상'(tools/E2E 에서 VERIFY_ID=<화면>)을 넣는다. 원장 변화 확인은 '다음 CheckList 실행 뒤 checker_defect_scan.py 로 해당 탐지 행 수 감소 확인' 으로 적는다.",
    '- 결과는 마지막에 JSON 블록 하나: {"summary": "…", "proposals": [{"key": "S16|…", "title": "…", "evidence": "…", "targets": ["…"], "before_after": "…", "verify": "…", "rollback": "…", "impact": "fix"}]}',
  ].join('\n');
}

/** o = { agent, imp, cfg, notify }, 반환 { skipped|busy|ok, added } */
async function maybeDiagnose(o) {
  o = o || {}; const c = o.cfg || {};
  if (!getPaths || c.checkerScanEnabled === false) return { skipped: true, why: '꺼짐' };
  const agent = o.agent; const imp = o.imp; if (!agent || !imp) return { skipped: true, why: '모듈 없음' };
  const meta = readJson(metaFile(), { seen: {} }); const gap = (Number(c.checkerDiagGapHours) || 6) * 3600000;
  if (meta.lastMs && Date.now() - meta.lastMs < gap) return { skipped: true, why: '진단 간격 전' };
  const j = readJson(outFile(), null); const items = itemsFrom(j); const fresh = newItems(items, meta.seen || {});
  if (!fresh.length) return { skipped: true, why: '새 항목 없음' };
  const inF = path.join(selfDir(), 'checker_diag_in.json');
  writeJson(inF, { at: nowLocal(), scanAt: j && j.at, items: fresh.map(it => { const src = (j.detectors || []).find(d => `S16|${d.id}` === it.key) || (j.clusters || []).find(cl => it.key === `S16|C|${cl.rule_id}|${String(cl.sig || '').slice(0, 40)}`) || {}; return Object.assign({ key: it.key, what: it.what }, src); }) });
  const rel = path.relative(P().root, inF).replace(/\\/g, '/');
  const r = await agent.withLock('checkerdiag', async () => agent.runClaude(diagPrompt(rel), { label: 'VMO 검사기 결함 진단(S16)', permissionMode: 'default', allowedTools: ['Read', 'Glob', 'Grep'] }));
  if (r && r.busy) return { busy: true };
  meta.lastMs = Date.now(); meta.lastAt = nowLocal();
  const out = agent.lastJsonBlock ? agent.lastJsonBlock(r && r.text) : null;
  let added = 0, dups = 0;
  if (out && Array.isArray(out.proposals)) {
    for (const p of out.proposals.slice(0, 3)) {
      if (!p || !p.title || !p.evidence) continue;
      const a = imp.add(Object.assign({}, p, { selfKey: p.key || '', check: 'S16' }), 'self'); if (a.id) added++; else dups++;
    }
  }
  meta.seen = meta.seen || {}; for (const it of fresh) meta.seen[it.key] = { rows: it.rows, at: meta.lastAt };
  meta.lastResult = out ? `개선안 ${added}건${dups ? `, 중복 ${dups}건` : ''}` : `결과 JSON 없음(exit ${r && r.code})`; meta.summary = String((out && out.summary) || '').slice(0, 600);
  writeJson(metaFile(), meta);
  if (added && o.notify) { try { o.notify(`VMO 검사기 결함 진단: 개선안 ${added}건(자동 반영 대상)`); } catch { } }
  return { ok: !!out, added, dups };
}

module.exports = { init, ready, check, maybeDiagnose, itemsFrom, newItems, diagPrompt };
