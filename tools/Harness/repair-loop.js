#!/usr/bin/env node
'use strict';
// repair-loop — 화면 하나를 사람 개입 없이 끝까지: 골격 생성(gen --apply) → Claude Code 채움 → 게이트(check --final: 매핑표·대사·tsc·eslint) → 실패 findings 를 붙여 재시도 … → PASS 또는 사람 확인 큐
//   node repair-loop.js <ID> [--max 3] [--feature demand] [--page kebab] [--no-gen] [--dry]
//   node repair-loop.js --batch ids.txt [--max 3]           (한 줄에 ID 하나; 순차 실행, Doc/gen/_repair_summary.csv)
//   node repair-loop.js <ID> --pkg                           PKG 이식 모드: gen-pkg → claude(port_pkg.md) → check-pkg 재시도
//   산출: Doc/gen/<ID>/REPAIR.md (회차별 게이트 결과·Claude 출력 꼬리), Doc/gen/_repair_summary.csv
//   종료코드: 0 전부 PASS / 1 사람 확인 필요 있음
const fs = require('fs'); const path = require('path'); const { spawnSync } = require('child_process');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const MAX = Number(opt('--max', 3)); const DRY = a.includes('--dry'); const NOGEN = a.includes('--no-gen'); const PKG = a.includes('--pkg');
const repo = path.dirname(cfg.feRoot);
const ids = opt('--batch') ? fs.readFileSync(opt('--batch'), 'utf8').split(/\r?\n/).map(s => s.trim()).filter(s => s && !s.startsWith('#')) : a.filter(x => !x.startsWith('--') && !['--max', '--feature', '--page', '--config', '--batch'].includes(a[a.indexOf(x) - 1]));
if (!ids.length) { console.error('화면ID 또는 --batch 파일을 지정하세요'); process.exit(2); }
const ALLOWED = 'Read,Edit,Write,Glob,Grep,Bash(node *),Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *)';
const run = (cmd, args, opts = {}) => { const r = spawnSync(cmd, args, Object.assign({ encoding: 'utf8', maxBuffer: 256 * 1024 * 1024, shell: process.platform === 'win32', timeout: 45 * 60 * 1000 }, opts)); return { code: r.status, out: (r.stdout || '') + (r.stderr || '') + (r.error ? '\n' + r.error.message : ''), err: r.error }; };
const now = () => new Date().toISOString().slice(0, 19).replace('T', ' ');

function pageDirOf(id) {
  const reg = path.join(cfg.genOutDir, id, 'register.json'); if (!fs.existsSync(reg)) return null;
  const r = JSON.parse(fs.readFileSync(reg, 'utf8')); return { dir: path.join(cfg.feRoot, 'features', r.feature, 'src', 'pages', r.pageDir), rel: `nscm-fe/features/${r.feature}/src/pages/${r.pageDir}`, menuId: r.menuId };
}
function gate(id, pageDir) {
  const args = PKG ? [path.join(__dirname, 'check-pkg.js'), id, '--json', '--config', opt('--config', path.join(__dirname, 'harness.json'))] : [path.join(__dirname, 'check.js'), '--page', pageDir, '--id', id, '--final', '--json', '--config', opt('--config', path.join(__dirname, 'harness.json'))];
  const r = run(process.execPath, args, { shell: false });
  const line = r.out.split(/\r?\n/).find(l => l.startsWith('{'));
  try { return JSON.parse(line); } catch { return { block: 1, warn: 0, findings: [{ level: 'BLOCK', code: 'X00', msg: 'check.js 출력 해석 실패: ' + r.out.slice(0, 300) }] }; }
}
function claudeFill(id, pg, round, findings) {
  const fl = findings.length ? `\n\nPrevious gate findings to fix FIRST (round ${round}):\n` + findings.map(f => `- [${f.level}] ${f.code} ${f.msg}${f.where ? ' @' + f.where : ''}`).join('\n') : '';
  if (PKG) {
    const pp = `Read tools/Harness/prompts/port_pkg.md and follow it for screen ${id}. Package file: Doc/gen/${id}/${id}_PKG.sql, notes: Doc/gen/${id}/${id}_PKG_NOTES.md. Port every /* ===== ASIS ... ===== */ block to Oracle PL/SQL in place, delete the ASIS blocks, keep signatures and the EXCEPTION skeleton, then run \`node tools/Harness/check-pkg.js ${id}\` and fix every BLOCK. Summarize remaining items in Korean.${fl}`;
    if (DRY) return { code: 0, out: '(dry) ' + pp };
    return run('claude', ['-p', '--allowedTools', ALLOWED, '--output-format', 'text'], { cwd: repo, input: pp }); // 프롬프트는 stdin 으로 — Windows shell 인용 문제(본문 속 --page 가 옵션으로 해석) 회피
  }
  const prompt = `Read tools/Harness/prompts/new_screen.md and follow it for screen ${id} (To-Be MENU_ID ${pg.menuId}). Skeleton: ${pg.rel}. Notes: Doc/gen/${id}/GEN_NOTES.md. Fill only the spots marked TODO, keep generator-owned parts, then update __asis-mapping__.md statuses (no empty cells). Run \`node tools/Harness/check.js --page ${pg.rel.replace(/^nscm-fe\//, 'nscm-fe/')} --id ${id} --final\` yourself before finishing and fix every BLOCK. Summarize remaining items with reasons in Korean.${fl}`;
  if (DRY) return { code: 0, out: '(dry) ' + prompt };
  return run('claude', ['-p', '--allowedTools', ALLOWED, '--output-format', 'text'], { cwd: repo, input: prompt });
}
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
  let res = gate(id, pg.dir), round = 0, status = 'PASS';
  log.push(`## 게이트 0회차 — BLOCK ${res.block} / WARN ${res.warn}`, ...res.findings.filter(f => f.level === 'BLOCK').slice(0, 30).map(f => `- ✗ ${f.code} ${f.msg} ${f.where ? '@' + f.where : ''}`), '');
  while (res.block > 0 && round < MAX) {
    round++;
    const c = claudeFill(id, pg, round, res.findings.filter(f => f.level === 'BLOCK').slice(0, 40));
    log.push(`## Claude ${round}회차 (exit ${c.code})`, '```', (c.out || '').trim().slice(-2500), '```', '');
    res = gate(id, pg.dir);
    log.push(`## 게이트 ${round}회차 — BLOCK ${res.block} / WARN ${res.warn}`, ...res.findings.filter(f => f.level === 'BLOCK').slice(0, 30).map(f => `- ✗ ${f.code} ${f.msg} ${f.where ? '@' + f.where : ''}`), '');
    console.log(`  ${id} round ${round}: BLOCK ${res.block} / WARN ${res.warn}`);
  }
  if (res.block > 0) { status = 'NEEDS_HUMAN'; log.push(`**${MAX}회 재시도 후에도 BLOCK ${res.block} — 사람 확인 큐**`); }
  else log.push(`**PASS** (WARN ${res.warn}) — ${round}회 수선`);
  fs.writeFileSync(path.join(cfg.genOutDir, id, PKG ? 'REPAIR_PKG.md' : 'REPAIR.md'), log.join('\n') + '\n', 'utf8');
  summary.push([id + (PKG ? ':PKG' : ''), status, round, res.block, res.warn, Math.round((Date.now() - t0) / 1000)]);
  console.log(`[${status}] ${id}  rounds=${round} BLOCK=${res.block} WARN=${res.warn}`);
}
const sf = path.join(cfg.genOutDir, '_repair_summary.csv');
const prev = fs.existsSync(sf) ? fs.readFileSync(sf, 'utf8').replace(/^﻿/, '').split(/\r?\n/).slice(1).filter(Boolean).filter(l => !summary.some(s => l.startsWith(s[0] + ','))) : [];
fs.writeFileSync(sf, '﻿id,status,rounds,block,warn,seconds,at\n' + prev.concat(summary.map(s => s.concat(now()).join(','))).join('\n') + '\n', 'utf8');
console.log(`요약 → ${sf}`);
process.exit(summary.some(s => s[1] !== 'PASS') ? 1 : 0);
