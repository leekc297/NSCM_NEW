#!/usr/bin/env node
'use strict';
// repair-loop — 화면 하나를 사람 개입 없이 끝까지: 골격 생성(gen --apply) → Claude Code 채움 → 게이트(check --final: 매핑표·대사·tsc·eslint) → 실패 findings 를 붙여 재시도 … → PASS 또는 사람 확인 큐
//   node repair-loop.js <ID> [--max 3] [--feature demand] [--page kebab] [--no-gen] [--dry]
//   node repair-loop.js --batch ids.txt [--max 3]           (한 줄에 ID 하나; 순차 실행, Doc/gen/_repair_summary.csv)
//   node repair-loop.js <ID> --pkg                           PKG 이식 모드: gen-pkg → claude(port_pkg.md) → check-pkg 재시도
//   산출: Doc/gen/<ID>/REPAIR.md (회차별 게이트 결과·Claude 출력 꼬리), Doc/gen/_repair_summary.csv
//   종료코드: 0 전부 PASS / 1 사람 확인 필요 있음
//   2026-11-20 재개(플랜 vm-ui-snug-mountain R4): 회차마다 Doc/gen/<ID>/_repair_state.json(--pkg 는 _repair_state_pkg.json)에 회차·단계·마지막 게이트 결과·AI 세션 ID 기록.
//     VM_RESUME=1(VM 이 재개 때 넘김) 또는 --resume 이면 기록의 회차부터 남은 회차만 진행. 끊긴 AI 호출은 claude --resume <세션> 으로 이어받고, 실패하면 새 세션 + 같은 지시.
//     기록 없음·경과 시간 초과(VM_INTERRUPTED_KEEP_HOURS 또는 harness.json interruptedKeepHours, 기본 24, 0 = 기한 없음)·화면 ID/모드/인자 다름·기록 깨짐 = 처음부터 + 사유 출력.
//     정상 종료(REPAIR.md 기록) 때 기록 삭제. 모의 시험: node repair-loop.js --selftest (AI·게이트를 가짜 명령으로 바꿔 실행)
const fs = require('fs'); const path = require('path'); const { spawnSync } = require('child_process'); const crypto = require('crypto');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
if (a.includes('--selftest')) process.exit(selftest());
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const MAX = Number(opt('--max', 3)); const DRY = a.includes('--dry'); const NOGEN = a.includes('--no-gen'); const PKG = a.includes('--pkg');
const DESIGN = opt('--design', ''); // 화면설계서(md) 경로 — 지정 시 Fact Pack 보다 설계서를 우선 적용(사용자가 고친 설계 반영)
const repo = path.dirname(cfg.feRoot);
const ids = opt('--batch') ? fs.readFileSync(opt('--batch'), 'utf8').split(/\r?\n/).map(s => s.trim()).filter(s => s && !s.startsWith('#')) : a.filter(x => !x.startsWith('--') && !['--max', '--feature', '--page', '--config', '--batch'].includes(a[a.indexOf(x) - 1]));
if (!ids.length) { console.error('화면ID 또는 --batch 파일을 지정하세요'); process.exit(2); }
// 2026-11-02 작업 모드: DB MODE(repairScope=DB_ONLY) 는 FE 수선을 하지 않는다. --pkg(DB 이식)는 그대로 실행
if (!PKG && cfg.repairScope === 'DB_ONLY') { console.log('[DB MODE] FE 수선 루프 건너뜀 — FE 는 가이드만(UI/DB MODE 에서 실행)'); process.exit(0); }
const ALLOWED = 'Read,Edit,Write,Glob,Grep,Bash(node *),Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *)';
const HENV = Object.assign({}, process.env, { VIBE_HARNESS: '1', NSCM_SKIP_RULE_READ: '1', REPAIR_LOOP_PID: String(process.pid) }); // 하네스 표식 — .claude/hooks 의 check-rules-read/attach-context 통과(룰은 프롬프트로 주입)
const RESUME = a.includes('--resume') || process.env.VM_RESUME === '1';
const KEEP_H = (() => { const v = process.env.VM_INTERRUPTED_KEEP_HOURS != null && process.env.VM_INTERRUPTED_KEEP_HOURS !== '' ? process.env.VM_INTERRUPTED_KEEP_HOURS : cfg.interruptedKeepHours; return v != null && v !== '' && !isNaN(Number(v)) ? Math.max(0, Number(v)) : 24; })();
const RESUME_NOTE = '창 다시 로드로 중단됨. 파일 상태를 확인하고 끊긴 지점부터 이어서 진행하세요.';
const GATE_MOCK = process.env.REPAIR_LOOP_GATE_MOCK || ''; // --selftest 전용: 게이트를 가짜 스크립트로 대체
const run = (cmd, args, opts = {}) => { const r = spawnSync(cmd, args, Object.assign({ encoding: 'utf8', maxBuffer: 256 * 1024 * 1024, shell: process.platform === 'win32', timeout: 45 * 60 * 1000, env: HENV }, opts)); return { code: r.status, out: (r.stdout || '') + (r.stderr || '') + (r.error ? '\n' + r.error.message : ''), err: r.error }; };
const now = () => new Date().toISOString().slice(0, 19).replace('T', ' ');
// Claude CLI — VibeManager 가 고른 최신 CLI(CLAUDE_BIN) 우선. PATH 의 claude 가 오래되면(예: 2.1.123) 최신 모델 요청이 400
// "does not support this model; 2.1.251+ required" 로 중지되던 문제(2026-10-19) 대응. CLAUDE_MODEL 이 있으면 --model 전달.
const CLAUDE = (() => { const b = (process.env.CLAUDE_BIN || '').trim(); return b ? (/\s/.test(b) ? `"${b}"` : b) : 'claude'; })();
// 2026-11-20 출력 형식 text → stream-json(--verbose 필수). 출력은 Doc/gen/<ID>/_repair_claude[_pkg].jsonl 파일로 받아 강제 종료 때도 세션 ID(init 이벤트)가 남는다.
//   새 세션은 --session-id <uuid> 로 ID 를 미리 정해 호출 전에 기록, 재개는 --resume <uuid>.
const CLAUDE_ARGS = ['-p', '--allowedTools', ALLOWED, '--output-format', 'stream-json', '--verbose', ...(process.env.CLAUDE_MODEL ? ['--model', process.env.CLAUDE_MODEL] : [])];
const claudeArgs = sess => CLAUDE_ARGS.concat(sess.resumeId ? ['--resume', sess.resumeId] : ['--session-id', sess.newId]);
function parseStream(txt) {
  const o = { sid: '', init: false, result: null, isError: false };
  for (const ln of String(txt || '').split(/\r?\n/)) {
    if (!ln.startsWith('{')) continue; let e; try { e = JSON.parse(ln); } catch { continue; }
    if (e.session_id) o.sid = e.session_id;
    if (e.type === 'system' && e.subtype === 'init') o.init = true;
    if (e.type === 'result') { o.result = typeof e.result === 'string' ? e.result : JSON.stringify(e.result || ''); o.isError = !!e.is_error; }
  }
  return o;
}
function claudeCall(input, sess, streamFile) {
  const fd = fs.openSync(streamFile, 'w'); let r;
  try { r = spawnSync(CLAUDE, claudeArgs(sess), { cwd: repo, input, stdio: ['pipe', fd, 'pipe'], encoding: 'utf8', maxBuffer: 256 * 1024 * 1024, shell: process.platform === 'win32', timeout: 45 * 60 * 1000, env: HENV }); }
  finally { fs.closeSync(fd); }
  const txt = fs.existsSync(streamFile) ? fs.readFileSync(streamFile, 'utf8') : ''; const p = parseStream(txt);
  let out = (p.result != null ? p.result : txt.slice(-4000)) + (r.stderr ? '\n' + r.stderr : '') + (r.error ? '\n' + r.error.message : '');
  if (/claude_code_version_too_old|does not support this model/.test(out)) out = `[Claude CLI 버전 부족] ${CLAUDE} — 'claude update' 또는 VS Code Claude Code 확장 업데이트 후 VibeManager 로 다시 실행하세요.\n` + out;
  return { code: r.status, out, sid: p.sid || sess.resumeId || sess.newId, init: p.init };
}
// sess = { newId } 새 세션 | { resumeId, onNew(id) } 끊긴 세션 이어받기(실패하면 새 세션 + RESUME_NOTE + 원래 지시)
function claudeRun(input, sess, streamFile) {
  if (!sess.resumeId) return Object.assign(claudeCall(input, sess, streamFile), { how: 'new' });
  const r = claudeCall(RESUME_NOTE, sess, streamFile);
  if (r.init) return Object.assign(r, { how: 'resume' });
  const nid = crypto.randomUUID(); if (sess.onNew) sess.onNew(nid);
  const r2 = claudeCall(RESUME_NOTE + '\n\n' + input, { newId: nid }, streamFile);
  r2.out = `[세션 이어받기 실패(${sess.resumeId}) → 새 세션 ${nid}] ${String(r.out || '').trim().slice(-300)}\n` + r2.out;
  return Object.assign(r2, { how: 'new-after-resume-fail' });
}

function pageDirOf(id) {
  const reg = path.join(cfg.genOutDir, id, 'register.json'); if (!fs.existsSync(reg)) return null;
  const r = JSON.parse(fs.readFileSync(reg, 'utf8')); return { dir: path.join(cfg.feRoot, 'features', r.feature, 'src', 'pages', r.pageDir), rel: `nscm-fe/features/${r.feature}/src/pages/${r.pageDir}`, menuId: r.menuId };
}
function gate(id, pageDir, round) {
  if (GATE_MOCK) { const m = run(process.execPath, [GATE_MOCK, id, String(round)], { shell: false }); const ln = m.out.split(/\r?\n/).find(l => l.startsWith('{')); try { return JSON.parse(ln); } catch { return { block: 1, warn: 0, findings: [{ level: 'BLOCK', code: 'X00', msg: 'mock gate 출력 해석 실패: ' + m.out.slice(0, 300) }] }; } }
  const args = PKG ? [path.join(__dirname, 'check-pkg.js'), id, '--json', '--config', opt('--config', path.join(__dirname, 'harness.json'))] : [path.join(__dirname, 'check.js'), '--page', pageDir, '--id', id, '--final', '--json', '--config', opt('--config', path.join(__dirname, 'harness.json'))];
  const r = run(process.execPath, args, { shell: false });
  const line = r.out.split(/\r?\n/).find(l => l.startsWith('{'));
  try { return JSON.parse(line); } catch { return { block: 1, warn: 0, findings: [{ level: 'BLOCK', code: 'X00', msg: 'check.js 출력 해석 실패: ' + r.out.slice(0, 300) }] }; }
}
function claudeFill(id, pg, round, findings, sess, streamFile) {
  // 2026-10-23 사용자 지시: SCP·SSP 는 화면 VALIDATION 취합 화면 파일을 검증 대조 원천으로(new_screen.md 6-2 · port_pkg.md 3-2 · 게이트 VR1~VR3)
  const vr = require('./lib/valref').find(cfg, id); const vrNote = vr && vr.screen ? ` VALIDATION reference (SCP/SSP AS-IS validation census + TO-BE verdict/TAG): ${vr.screen} — use it as the validation checklist (${PKG ? 'port_pkg.md 3-2, DB rows' : 'new_screen.md 6-2, UI rows'}).` : '';
  const fl = findings.length ? `\n\nPrevious gate findings to fix FIRST (round ${round}):\n` + findings.map(f => `- [${f.level}] ${f.code} ${f.msg}${f.where ? ' @' + f.where : ''}`).join('\n') : '';
  if (PKG) {
    const pp = `Read tools/Harness/prompts/port_pkg.md and follow it for screen ${id}. Package file: Doc/gen/${id}/${id}_PKG.sql, notes: Doc/gen/${id}/${id}_PKG_NOTES.md.${vrNote} Port every /* ===== ASIS ... ===== */ block to Oracle PL/SQL in place, delete the ASIS blocks, keep signatures and the EXCEPTION skeleton, then run \`node tools/Harness/check-pkg.js ${id}\` and fix every BLOCK. Summarize remaining items in Korean.${fl}`;
    if (DRY) return { code: 0, out: '(dry) ' + pp };
    return claudeRun(pp, sess, streamFile); // 프롬프트는 stdin 으로 — Windows shell 인용 문제(본문 속 --page 가 옵션으로 해석) 회피
  }
  const designNote = DESIGN ? ` DESIGN DOC FIRST: read ${DESIGN.replace(/\\/g, '/')} (and tobe_design.md next to it if present) — where it differs from the Fact Pack (fields, sheets, buttons, popups, labels), the design doc wins; record each such override as a row in __asis-mapping__.md with reason '설계서 우선'.` : '';
  const prompt = `Read tools/Harness/prompts/new_screen.md and follow it for screen ${id} (To-Be MENU_ID ${pg.menuId}). Skeleton: ${pg.rel}. Notes: Doc/gen/${id}/GEN_NOTES.md.${vrNote} Fill only the spots marked TODO, keep generator-owned parts, then update __asis-mapping__.md statuses (no empty cells). Run \`node tools/Harness/check.js --page ${pg.rel.replace(/^nscm-fe\//, 'nscm-fe/')} --id ${id} --final\` yourself before finishing and fix every BLOCK. Summarize remaining items with reasons in Korean.${fl}${designNote}`;
  if (DRY) return { code: 0, out: '(dry) ' + prompt };
  return claudeRun(prompt, sess, streamFile);
}
// ── 재개 기록(2026-11-20) ── stage: gate = 그 회차 게이트 진행 중 · claude = 그 회차 AI 진행 중 · done = 그 회차 게이트 끝
const stateFileOf = id => path.join(cfg.genOutDir, id, PKG ? '_repair_state_pkg.json' : '_repair_state.json');
const streamFileOf = id => path.join(cfg.genOutDir, id, PKG ? '_repair_claude_pkg.jsonl' : '_repair_claude.jsonl');
const argSig = () => ({ mode: PKG ? 'pkg' : 'fe', max: MAX, design: DESIGN || '' });
function saveState(id, st) { st.updatedAt = new Date().toISOString(); const f = stateFileOf(id); fs.mkdirSync(path.dirname(f), { recursive: true }); const tmp = f + '.tmp'; fs.writeFileSync(tmp, JSON.stringify(st, null, 1), 'utf8'); fs.renameSync(tmp, f); }
function loadResume(id) { // 반환 { st } 이어가기 | { reason } 처음부터
  const f = stateFileOf(id); if (!fs.existsSync(f)) return { reason: `재개 기록 없음(${path.basename(f)})` };
  let st; try { st = JSON.parse(fs.readFileSync(f, 'utf8')); } catch (e) { return { reason: `재개 기록 깨짐(${e.message})` }; }
  if (!st || typeof st !== 'object' || !Number.isInteger(st.round) || !['gate', 'claude', 'done'].includes(st.stage) || !Array.isArray(st.log)) return { reason: '재개 기록 깨짐(round/stage/log 형식 다름)' };
  if (String(st.id || '').toUpperCase() !== id) return { reason: `대상 화면 ID 다름(기록 ${st.id} · 이번 ${id})` };
  const sig = argSig(), ss = st.sig || {}; const diff = Object.keys(sig).filter(k => String(ss[k]) !== String(sig[k]));
  if (diff.length) return { reason: `실행 인자 다름(${diff.map(k => `${k}: 기록 ${ss[k]} · 이번 ${sig[k]}`).join(', ')})` };
  const age = (Date.now() - Date.parse(st.updatedAt || '')) / 3600000;
  if (!(age >= 0)) return { reason: '재개 기록 깨짐(updatedAt 없음)' };
  if (KEEP_H > 0 && age > KEEP_H) return { reason: `끊긴 뒤 ${age.toFixed(1)}시간 경과(기준 ${KEEP_H}시간)` };
  if (st.stage !== 'gate' && !(st.lastGate && typeof st.lastGate.block === 'number')) return { reason: '재개 기록 깨짐(lastGate 없음)' };
  return { st };
}
const gateLines = (round, res) => [`## 게이트 ${round}회차 — BLOCK ${res.block} / WARN ${res.warn}`, ...(res.findings || []).filter(f => f.level === 'BLOCK').slice(0, 30).map(f => `- ✗ ${f.code} ${f.msg} ${f.where ? '@' + f.where : ''}`), ''];
const summary = [];
for (const id0 of ids) {
  const id = id0.toUpperCase(); const log = []; const t0 = Date.now();
  log.push(`# REPAIR ${id} — ${now()}`, '');
  let pg = pageDirOf(id);
  if (PKG) {
    if (!pg) { console.log(`[SKIP] ${id}: register.json 없음 (gen.js 먼저)`); summary.push([id, 'NO_PLAN', 0, 0, 0, 0]); continue; }
    if (!NOGEN && !fs.existsSync(path.join(cfg.genOutDir, id, `${id}_PKG.sql`))) { const g = run(process.execPath, [path.join(__dirname, 'gen-pkg.js'), id, '--config', opt('--config', path.join(__dirname, 'harness.json'))], { shell: false }); log.push('## gen-pkg', '```', g.out.trim().slice(-800), '```', ''); }
  } else if (!NOGEN && !(pg && fs.existsSync(pg.dir))) {
    const args = [path.join(__dirname, 'gen.js'), id, '--apply', '--config', opt('--config', path.join(__dirname, 'harness.json'))]; if (opt('--feature')) args.push('--feature', opt('--feature')); if (opt('--page')) args.push('--page', opt('--page'));
    const g = run(process.execPath, args, { shell: false }); log.push('## gen --apply', '```', g.out.trim().slice(-1500), '```', '');
    pg = pageDirOf(id);
    if (!pg || !fs.existsSync(pg.dir)) { log.push('**골격 생성 실패 — 사람 확인 필요**'); summary.push([id, 'GEN_FAIL', 0, 0, 0, Math.round((Date.now() - t0) / 1000)]); fs.mkdirSync(path.join(cfg.genOutDir, id), { recursive: true }); fs.writeFileSync(path.join(cfg.genOutDir, id, 'REPAIR.md'), log.join('\n') + '\n', 'utf8'); console.log(`[GEN_FAIL] ${id}`); continue; }
  }
  if (!pg) { console.log(`[SKIP] ${id}: Doc/gen/${id}/register.json 없음`); summary.push([id, 'NO_PLAN', 0, 0, 0, 0]); continue; }
  // 재개 판정 — 기록이 맞으면 끊긴 회차부터, 아니면 처음부터 + 사유
  let st = null, startSec = 0;
  if (RESUME && !DRY) {
    const rz = loadResume(id);
    if (rz.st) {
      st = rz.st; startSec = Number(st.elapsedSec) || 0; log.length = 0; log.push(...st.log, `## 재개 — ${now()} · ${st.round}회차 ${st.stage === 'claude' ? 'AI 진행 중' : st.stage === 'gate' ? '게이트 진행 중' : '게이트 끝'}에서 끊김${process.env.VM_RESUME_RUN ? ' · VM_RESUME_RUN ' + process.env.VM_RESUME_RUN : ''}`, '');
      console.log(`[재개] ${id}: ${st.round}회차 ${st.stage} 지점부터 이어서(세션 ${st.sessionId || '없음'})`);
    } else console.log(`[재개 불가 → 처음부터] ${id}: ${rz.reason}`);
  }
  if (!st) st = { id, sig: argSig(), startedAt: new Date().toISOString(), round: 0, stage: 'gate', lastGate: null, sessionId: '', log: [] };
  const put = patch => { Object.assign(st, patch, { log: log.slice(), elapsedSec: startSec + Math.round((Date.now() - t0) / 1000) }); if (!DRY) saveState(id, st); };
  let res, round, status = 'PASS', resumeSid = '';
  if (st.stage === 'done') { round = st.round; res = st.lastGate; }
  else if (st.stage === 'claude') { round = st.round - 1; res = st.lastGate; resumeSid = st.sessionId; }
  else { // gate: 그 회차 게이트부터 다시
    round = st.round; put({ round, stage: 'gate' });
    res = gate(id, pg.dir, round); log.push(...gateLines(round, res)); put({ stage: 'done', lastGate: res });
    if (round > 0) console.log(`  ${id} round ${round}: BLOCK ${res.block} / WARN ${res.warn}`);
  }
  while (res.block > 0 && round < MAX) {
    round++;
    const findings = res.findings.filter(f => f.level === 'BLOCK').slice(0, 40);
    let sess;
    if (resumeSid) { sess = { resumeId: resumeSid, onNew: nid => put({ sessionId: nid, sessionNote: `이어받기 실패 → 새 세션(이전 ${resumeSid})` }) }; resumeSid = ''; }
    else { sess = { newId: crypto.randomUUID() }; put({ round, stage: 'claude', sessionId: sess.newId, sessionNote: '' }); }
    const c = claudeFill(id, pg, round, findings, sess, streamFileOf(id));
    log.push(`## Claude ${round}회차 (exit ${c.code}${c.how ? ' · ' + ({ new: '새 세션', resume: '세션 이어받기', 'new-after-resume-fail': '이어받기 실패 → 새 세션' })[c.how] + ' ' + c.sid : ''})`, '```', (c.out || '').trim().slice(-2500), '```', '');
    put({ round, stage: 'gate', sessionId: c.sid || st.sessionId });
    res = gate(id, pg.dir, round);
    log.push(...gateLines(round, res)); put({ stage: 'done', lastGate: res });
    console.log(`  ${id} round ${round}: BLOCK ${res.block} / WARN ${res.warn}`);
  }
  if (res.block > 0) { status = 'NEEDS_HUMAN'; log.push(`**${MAX}회 재시도 후에도 BLOCK ${res.block} — 사람 확인 큐**`); }
  else log.push(`**PASS** (WARN ${res.warn}) — ${round}회 수선`);
  fs.writeFileSync(path.join(cfg.genOutDir, id, PKG ? 'REPAIR_PKG.md' : 'REPAIR.md'), log.join('\n') + '\n', 'utf8');
  for (const f of [stateFileOf(id), streamFileOf(id)]) { try { fs.unlinkSync(f); } catch { /* 없음 */ } } // 정상 종료 = 재개 기록 삭제
  summary.push([id + (PKG ? ':PKG' : ''), status, round, res.block, res.warn, startSec + Math.round((Date.now() - t0) / 1000)]);
  console.log(`[${status}] ${id}  rounds=${round} BLOCK=${res.block} WARN=${res.warn}`);
}
const sf = path.join(cfg.genOutDir, '_repair_summary.csv');
const prev = fs.existsSync(sf) ? fs.readFileSync(sf, 'utf8').replace(/^﻿/, '').split(/\r?\n/).slice(1).filter(Boolean).filter(l => !summary.some(s => l.startsWith(s[0] + ','))) : [];
fs.writeFileSync(sf, '﻿id,status,rounds,block,warn,seconds,at\n' + prev.concat(summary.map(s => s.concat(now()).join(','))).join('\n') + '\n', 'utf8');
console.log(`요약 → ${sf}`);
process.exit(summary.some(s => s[1] !== 'PASS') ? 1 : 0);

// ── 모의 시험(2026-11-20 R4) ── AI(claude)·게이트를 가짜 명령으로 바꿔 강제 종료 → 재개를 확인한다. 실제 AI·UI 생성 체인은 부르지 않는다.
function selftest() {
  const os = require('os'); const T = fs.mkdtempSync(path.join(os.tmpdir(), 'rl_selftest_')); const ID = 'DMF9999';
  const RESUME_NOTE_T = '창 다시 로드로 중단됨. 파일 상태를 확인하고 끊긴 지점부터 이어서 진행하세요.';
  const cfgFile = path.join(T, 'harness.json'); const gen = path.join(T, 'gen'); const fe = path.join(T, 'nscm-fe');
  fs.writeFileSync(cfgFile, JSON.stringify({ feRoot: fe, genOutDir: gen, analysisRoot: path.join(T, '_analysis'), repairScope: 'DB_FE' }), 'utf8');
  fs.mkdirSync(path.join(gen, ID), { recursive: true }); fs.writeFileSync(path.join(gen, ID, 'register.json'), JSON.stringify({ feature: 'demand', pageDir: 'dmf9999', menuId: 'M9999' }), 'utf8');
  fs.mkdirSync(path.join(fe, 'features', 'demand', 'src', 'pages', 'dmf9999'), { recursive: true });
  const calls = path.join(T, 'calls.jsonl'), sessF = path.join(T, 'sessions.json'), killMark = path.join(T, 'killed.mark');
  const common = `const fs=require('fs');const rec=o=>fs.appendFileSync(${JSON.stringify(calls)},JSON.stringify(Object.assign({run:process.env.SELFTEST_RUN},o))+'\\n');
const kill=()=>{fs.writeFileSync(${JSON.stringify(killMark)},'1');try{process.kill(Number(process.env.REPAIR_LOOP_PID))}catch(e){}};
const shouldKill=k=>process.env.SELFTEST_KILL===k&&!fs.existsSync(${JSON.stringify(killMark)});\n`;
  const gateJs = path.join(T, 'gate_mock.js');
  fs.writeFileSync(gateJs, common + `const round=Number(process.argv[3]);rec({kind:'gate',round});
if(shouldKill('gate:'+round)){kill();setTimeout(()=>process.exit(1),3000);}
else{const b=[5,4,2,0][round]??0;console.log(JSON.stringify({block:b,warn:0,findings:Array.from({length:b},(_,i)=>({level:'BLOCK',code:'T'+i,msg:'mock'}))}));}`, 'utf8');
  const claudeJs = path.join(T, 'fake_claude.js');
  fs.writeFileSync(claudeJs, common + `const av=process.argv.slice(2);const v=k=>{const i=av.indexOf(k);return i>=0?av[i+1]:''};
const input=fs.readFileSync(0,'utf8');const m=input.match(/\\(round (\\d+)\\)/);const round=m?Number(m[1]):null;
const resume=v('--resume'),sid=v('--session-id');const ss=fs.existsSync(${JSON.stringify(sessF)})?JSON.parse(fs.readFileSync(${JSON.stringify(sessF)},'utf8')):[];
rec({kind:'claude',round,resume,sid,streamJson:av.includes('stream-json')&&av.includes('--verbose'),input:input.slice(0,400)});
if(resume&&(process.env.SELFTEST_FORGET==='1'||!ss.includes(resume))){process.stderr.write('No conversation found with session ID: '+resume+'\\n');process.exit(1);}
const id=resume||sid;if(sid){ss.push(sid);fs.writeFileSync(${JSON.stringify(sessF)},JSON.stringify(ss));}
fs.writeSync(1,JSON.stringify({type:'system',subtype:'init',session_id:id})+'\\n');
if(round!=null&&shouldKill('claude:'+round)){kill();setTimeout(()=>process.exit(1),3000);}
else{fs.writeSync(1,JSON.stringify({type:'result',subtype:'success',is_error:false,result:'mock fill '+(round??'resume'),session_id:id})+'\\n');}`, 'utf8');
  const claudeCmd = path.join(T, 'fake_claude.cmd'); fs.writeFileSync(claudeCmd, `@"${process.execPath}" "%~dp0fake_claude.js" %*\r\n`, 'utf8');
  const stF = path.join(gen, ID, '_repair_state.json'), repF = path.join(gen, ID, 'REPAIR.md');
  const base = Object.assign({}, process.env); delete base.VM_RESUME; delete base.VM_RESUME_RUN; delete base.CLAUDE_MODEL; delete base.VM_INTERRUPTED_KEEP_HOURS;
  const go = (label, { env = {}, args = [] } = {}) => {
    const r = spawnSync(process.execPath, [__filename, ID, '--no-gen', ...(args.includes('--max') ? [] : ['--max', '3']), '--config', cfgFile, ...args], { encoding: 'utf8', env: Object.assign({}, base, { CLAUDE_BIN: claudeCmd, REPAIR_LOOP_GATE_MOCK: gateJs, SELFTEST_RUN: label }, env), timeout: 120000 });
    const all = fs.existsSync(calls) ? fs.readFileSync(calls, 'utf8').split(/\r?\n/).filter(Boolean).map(l => JSON.parse(l)) : [];
    const mine = all.filter(c => c.run === label);
    return { code: r.status, out: (r.stdout || '') + (r.stderr || ''), gates: mine.filter(c => c.kind === 'gate').map(c => c.round), cl: mine.filter(c => c.kind === 'claude') };
  };
  const reset = () => { for (const f of [stF, repF, killMark, sessF]) { try { fs.unlinkSync(f); } catch { } } };
  const readSt = () => JSON.parse(fs.readFileSync(stF, 'utf8')); const writeSt = st => fs.writeFileSync(stF, JSON.stringify(st), 'utf8');
  let pass = 0, fail = 0; const ok = (name, cond, info) => { if (cond) pass++; else fail++; console.log(`${cond ? 'PASS' : 'FAIL'} ${name}${cond ? '' : ' :: ' + JSON.stringify(info).slice(0, 800)}`); };
  const R = { env: { VM_RESUME: '1', VM_RESUME_RUN: 'J_SELFTEST' } };

  // 1 끊김 없는 실행 = 기준
  reset(); let r = go('base');
  ok('1 기준 실행: 게이트 0~3회차, AI 3회(새 세션, stream-json), PASS, 기록 삭제', r.code === 0 && r.gates.join() === '0,1,2,3' && r.cl.length === 3 && r.cl.every(c => c.sid && !c.resume && c.streamJson) && !fs.existsSync(stF) && /\*\*PASS\*\*/.test(fs.readFileSync(repF, 'utf8')), r);

  // 2 2회차 게이트 끝난 뒤 끊김(stage done) → 재개 → 3회차부터
  reset(); r = go('k3', { env: { SELFTEST_KILL: 'claude:3' } }); let st = readSt();
  ok('2a 3회차 AI 중 강제 종료 → 기록 round 3, stage claude', r.code !== 0 && st.round === 3 && st.stage === 'claude' && st.lastGate.block === 2, { code: r.code, st: { round: st.round, stage: st.stage } });
  st.round = 2; st.stage = 'done'; writeSt(st); // 2회차 게이트 직후 지점으로 바꿈
  r = go('k3r', R);
  ok('2b 재개: 게이트 3회차만, AI 3회차 1회(새 세션), 1·2회차 다시 안 함', r.code === 0 && r.gates.join() === '3' && r.cl.length === 1 && r.cl[0].round === 3 && r.cl[0].sid && !r.cl[0].resume && /\[재개\]/.test(r.out), r);
  const rep2 = fs.readFileSync(repF, 'utf8');
  ok('2c REPAIR.md 에 1~3회차 기록 이어짐, 재개 표시, 기록 삭제', /Claude 1회차/.test(rep2) && /Claude 2회차/.test(rep2) && /Claude 3회차/.test(rep2) && /## 재개/.test(rep2) && !fs.existsSync(stF), rep2.slice(0, 400));

  // 3 2회차 게이트 중 끊김 → 재개 → 2회차 게이트 다시 → 3회차
  reset(); r = go('kg2', { env: { SELFTEST_KILL: 'gate:2' } }); st = readSt();
  ok('3a 2회차 게이트 중 강제 종료 → 기록 round 2, stage gate', r.code !== 0 && st.round === 2 && st.stage === 'gate' && r.cl.length === 2, { code: r.code, round: st.round, stage: st.stage });
  r = go('kg2r', R);
  ok('3b 재개: 게이트 2·3회차, AI 3회차 1회', r.code === 0 && r.gates.join() === '2,3' && r.cl.length === 1 && r.cl[0].round === 3, r);

  // 4 2회차 AI 중 끊김 → 재개 → --resume <기록된 세션> + 중단 지시
  reset(); r = go('kc2', { env: { SELFTEST_KILL: 'claude:2' } }); st = readSt(); const sid2 = st.sessionId;
  ok('4a 2회차 AI 중 강제 종료 → 기록 round 2, stage claude, 세션 ID = 2회차 --session-id', r.code !== 0 && st.round === 2 && st.stage === 'claude' && sid2 && r.cl[1] && r.cl[1].sid === sid2, { st: { round: st.round, stage: st.stage, sid2 }, cl: r.cl });
  r = go('kc2r', R);
  ok('4b 재개: 첫 AI 호출 --resume <같은 세션>, 입력 = 중단 지시, 게이트 2·3, 3회차 새 세션', r.cl[0] && r.cl[0].resume === sid2 && r.cl[0].input.startsWith(RESUME_NOTE_T) && r.cl.length === 2 && r.cl[1].round === 3 && r.cl[1].sid && r.gates.join() === '2,3' && r.code === 0, r);
  ok('4c REPAIR.md 에 세션 이어받기 표시', /세션 이어받기 /.test(fs.readFileSync(repF, 'utf8')), '');

  // 5 이어받기 실패 → 새 세션 + 같은 문구 + 원래 지시
  reset(); r = go('kf2', { env: { SELFTEST_KILL: 'claude:2' } }); const sidF = readSt().sessionId;
  r = go('kf2r', { env: Object.assign({ SELFTEST_FORGET: '1' }, R.env) });
  ok('5 이어받기 실패: --resume 거부 → --session-id 새 세션, 입력 = 중단 지시 + 원래 지시', r.cl[0] && r.cl[0].resume === sidF && r.cl[1] && r.cl[1].sid && r.cl[1].sid !== sidF && r.cl[1].input.startsWith(RESUME_NOTE_T) && /new_screen\.md/.test(r.cl[1].input) && r.gates.join() === '2,3' && r.code === 0 && /이어받기 실패/.test(fs.readFileSync(repF, 'utf8')), r);

  // 6 거부 조건 → 처음부터 + 사유
  const rejectCase = (name, prep, args, re) => { reset(); go(name + '_k', { env: { SELFTEST_KILL: 'gate:2' } }); if (prep) prep(); const x = go(name, { env: R.env, args }); ok(`6 ${name}: 처음부터(게이트 0회차, AI 1회차부터) + 사유 출력`, re.test(x.out) && x.gates[0] === 0 && x.cl[0] && x.cl[0].round === 1 && !x.cl[0].resume, x); };
  reset(); r = go('nostate', R); ok('6 nostate: 기록 없음 → 처음부터 + 사유', /재개 기록 없음/.test(r.out) && r.gates.join() === '0,1,2,3' && r.code === 0, r);
  rejectCase('expired', () => { const s = readSt(); s.updatedAt = new Date(Date.now() - 25 * 3600000).toISOString(); writeSt(s); }, [], /시간 경과/);
  rejectCase('other_id', () => { const s = readSt(); s.id = 'DMF0000'; writeSt(s); }, [], /대상 화면 ID 다름/);
  rejectCase('broken', () => fs.writeFileSync(stF, '{ broken', 'utf8'), [], /재개 기록 깨짐/);
  rejectCase('arg_diff', null, ['--max', '4'], /실행 인자 다름/);

  // 7 --resume 인자도 같은 동작, 재개 신호 없으면 기록 있어도 처음부터
  reset(); go('flag_k', { env: { SELFTEST_KILL: 'gate:1' } }); r = go('flag', { args: ['--resume'] });
  ok('7a --resume 인자: 게이트 1회차부터', r.gates.join() === '1,2,3' && r.code === 0, r);
  reset(); go('nosig_k', { env: { SELFTEST_KILL: 'gate:2' } }); r = go('nosig');
  ok('7b 재개 신호 없음: 기록 무시, 처음부터', r.gates.join() === '0,1,2,3' && r.code === 0 && !fs.existsSync(stF), r);

  console.log(`\nselftest ${fail ? 'FAIL' : 'PASS'} — PASS ${pass} / FAIL ${fail} · 임시 폴더 ${T}`);
  if (!fail) { try { fs.rmSync(T, { recursive: true, force: true }); } catch { } }
  return fail ? 1 : 0;
}
