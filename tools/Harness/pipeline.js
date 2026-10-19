#!/usr/bin/env node
'use strict';
// pipeline — 화면 ID 하나로 끝까지: FE 골격 → 등록 SQL → PKG 골격 → FE 수선 루프(게이트 PASS) → PKG 이식 루프 → E2E 스펙 → [E2E 실행] → 대사표 갱신
//   node pipeline.js <ID> [--max 3] [--e2e] [--no-claude] [--regen-pkg] [--config harness.json]
//   --regen-pkg : 이식 작업이 들어간 <ID>_PKG.sql 을 버리고 골격을 다시 만든다(기본은 보존)
//   --no-claude : Claude 호출 없이 생성·게이트까지만 (골격 상태 확인용)   --e2e : FE/BE 가 떠 있을 때 스모크 실행까지
//   산출: Doc/gen/<ID>/PIPELINE.md (단계별 결과·소요·다음 할 일), 종료코드 0=전부 PASS / 1=사람 확인 필요
const fs = require('fs'); const path = require('path'); const { spawnSync } = require('child_process');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfgPath = opt('--config', path.join(__dirname, 'harness.json')); const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8').replace(/^﻿/, ''));
const ID = (a.find(x => !x.startsWith('--') && !['--max', '--config'].includes(a[a.indexOf(x) - 1])) || '').toUpperCase(); if (!ID) { console.error('화면ID'); process.exit(2); }
const MAX = opt('--max', '3'); const E2E = a.includes('--e2e'); const NOCLAUDE = a.includes('--no-claude');
const repo = path.dirname(cfg.feRoot); const genDir = path.join(cfg.genOutDir, ID); fs.mkdirSync(genDir, { recursive: true });
const steps = []; const run = (name, cmd, args, opts = {}) => {
  const t0 = Date.now(); const r = spawnSync(cmd, args, Object.assign({ encoding: 'utf8', maxBuffer: 256 * 1024 * 1024, shell: process.platform === 'win32' && !/node/.test(cmd) }, opts));
  const out = ((r.stdout || '') + (r.stderr || '')).trim(); const sec = Math.round((Date.now() - t0) / 1000);
  steps.push({ name, code: r.status, sec, tail: out.split(/\r?\n/).slice(-12).join('\n') }); console.log(`[${r.status === 0 ? 'OK' : 'EXIT ' + r.status}] ${name} (${sec}s)`); return r;
};
const N = process.execPath; const H = f => path.join(__dirname, f); const C = ['--config', cfgPath];
// 1 FE 골격(없을 때만 --apply)
const reg = path.join(genDir, 'register.json');
const pageOf = () => { if (!fs.existsSync(reg)) return null; const r = JSON.parse(fs.readFileSync(reg, 'utf8')); return path.join(cfg.feRoot, 'features', r.feature, 'src', 'pages', r.pageDir); };
let pageDir = pageOf();
const touched = pageDir && fs.existsSync(pageDir) && require('./lib/applied').isTouched(pageDir, genDir);
if (!pageDir || !fs.existsSync(pageDir)) run('1 FE 골격 생성 + nscm-fe 적용(gen --apply)', N, [H('gen.js'), ID, '--apply', ...C]);
else if (!touched) run('1 FE 골격 재생성 + 재적용(작업 흔적 없음 → gen --apply --overwrite)', N, [H('gen.js'), ID, '--apply', '--overwrite', ...C]);
else run('1 FE 골격 재생성(Doc/gen 만 — 페이지에 작업 흔적 있어 적용 안 함)', N, [H('gen.js'), ID, ...C]);
pageDir = pageOf();
// 2 등록 SQL · 3 PKG 골격
run('2 Oracle 메타 등록 SQL(gen-register-sql)', N, [H('gen-register-sql.js'), ID, ...C]);
{ // 3 PKG 골격 — 이미 이식 작업이 들어간 <ID>_PKG.sql(골격 해시와 다름) 은 덮어쓰지 않는다(Claude 이식 결과 보존)
  const pkgFile = path.join(genDir, `${ID}_PKG.sql`), shaFile = path.join(genDir, `${ID}_PKG.sha256`);
  const FORCE_PKG = process.argv.includes('--regen-pkg'); // 골격 강제 재생성(이식 결과 폐기)
  const pkgTouched = !FORCE_PKG && fs.existsSync(pkgFile) && (!fs.existsSync(shaFile) || require('crypto').createHash('sha256').update(fs.readFileSync(pkgFile, 'utf8')).digest('hex') !== fs.readFileSync(shaFile, 'utf8').trim()); // 해시 파일 없음(구버전 골격)도 보존
  if (pkgTouched) { steps.push({ name: '3 Oracle PKG 골격(gen-pkg) — 건너뜀(이식 작업 흔적 있음, 기존 PKG.sql 보존)', code: 0, sec: 0, tail: '' }); console.log('[OK] 3 PKG 골격 건너뜀(이식 흔적 보존)'); }
  else run('3 Oracle PKG 골격(gen-pkg)', N, [H('gen-pkg.js'), ID, ...C]);
}
// 4 FE 수선 루프 / 5 PKG 이식 루프
if (!NOCLAUDE) { run(`4 FE 수선 루프(Claude ×${MAX} + 게이트 --final)`, N, [H('repair-loop.js'), ID, '--max', MAX, '--no-gen', ...C]); run(`5 PKG 이식 루프(Claude ×${MAX} + check-pkg)`, N, [H('repair-loop.js'), ID, '--pkg', '--max', MAX, '--no-gen', ...C]); }
else if (pageDir && fs.existsSync(pageDir)) { run('4 FE 게이트(--final, Claude 없음)', N, [H('check.js'), '--page', pageDir, '--id', ID, '--final', ...C]); run('5 PKG 게이트(check-pkg)', N, [H('check-pkg.js'), ID, ...C]); }
// 6 E2E 스펙 (+실행)
const e2eDir = path.join(repo, 'tools', 'E2E'); if (fs.existsSync(path.join(e2eDir, 'gen-e2e.js'))) { run('6 E2E 스펙 생성(gen-e2e)', N, [path.join(e2eDir, 'gen-e2e.js'), ID]); if (E2E) run('6b E2E 스모크 실행(run-e2e smoke)', path.join(e2eDir, 'run-e2e.cmd'), ['smoke', ID], { cwd: e2eDir }); }
// 7 대사표
const reconDir = path.join(repo, 'tools', 'Recon'); if (fs.existsSync(path.join(reconDir, 'recon.js'))) run('7 대사표 갱신(recon)', N, [path.join(reconDir, 'recon.js'), ...C]);
// 결과 요약
const chk = fs.existsSync(path.join(genDir, 'CHECK.md')) ? (/BLOCK (\d+) \/ WARN (\d+)/.exec(fs.readFileSync(path.join(genDir, 'CHECK.md'), 'utf8')) || []).slice(1) : [];
const dodF = path.join(genDir, 'DOD.md'); const dod = fs.existsSync(dodF) ? (/(\d+)\/(\d+) 충족/.exec(fs.readFileSync(dodF, 'utf8')) || []).slice(1) : [];
const pkgChk = fs.existsSync(path.join(genDir, 'CHECK_PKG.md')) ? (/BLOCK (\d+) \/ WARN (\d+)/.exec(fs.readFileSync(path.join(genDir, 'CHECK_PKG.md'), 'utf8')) || []).slice(1) : [];
const rep = fs.existsSync(path.join(cfg.genOutDir, '_repair_summary.csv')) ? fs.readFileSync(path.join(cfg.genOutDir, '_repair_summary.csv'), 'utf8').split(/\r?\n/).filter(l => l.startsWith(ID + ',') || l.startsWith(ID + ':PKG,')).map(l => l.split(',').slice(0, 2).join('=')).join(' · ') : '';
const pass = chk[0] === '0' && (!pkgChk.length || pkgChk[0] === '0');
const next = []; if (chk[0] && chk[0] !== '0') next.push(`FE 게이트 BLOCK ${chk[0]} — Doc/gen/${ID}/CHECK.md · REPAIR.md`); if (pkgChk[0] && pkgChk[0] !== '0') next.push(`PKG 게이트 BLOCK ${pkgChk[0]} — CHECK_PKG.md · REPAIR_PKG.md`); if (dod[0] && dod[0] !== dod[1]) next.push(`DoD ${dod[0]}/${dod[1]} — DOD.md 의 ❌`); if (!E2E) next.push('E2E 스모크: FE/BE 기동 후 `tools\\E2E\\run-e2e.cmd smoke ' + ID + '`'); next.push(`DB 반영: python tools\\DbConn\\run_sql.py Doc\\gen\\${ID}\\${ID}_PKG.sql --commit → ${ID}_registration.sql(미리보기 후 --commit)`);
const stamp = new Date(Date.now() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16).replace('T', ' ');
const md = [`# PIPELINE ${ID} — ${stamp} ${pass ? '✅ 게이트 PASS' : '⚠ 사람 확인 필요'}`, '', `페이지: \`${pageDir || '-'}\` · FE 게이트 BLOCK/WARN ${chk.join('/') || '-'} · DoD ${dod.join('/') || '-'} · PKG 게이트 ${pkgChk.join('/') || '-'} · 수선 ${rep || '-'}`, '', '| 단계 | 결과 | 소요 |', '|---|---|---|', ...steps.map(s => `| ${s.name} | ${s.code === 0 ? 'OK' : 'exit ' + s.code} | ${s.sec}s |`), '', '## 다음 할 일', '', ...next.map(n => `- ${n}`), '', '## 단계 로그(꼬리)', '', ...steps.flatMap(s => [`### ${s.name}`, '```', s.tail, '```', ''])];
fs.writeFileSync(path.join(genDir, 'PIPELINE.md'), md.join('\n'), 'utf8');
console.log(`\n${pass ? 'PASS' : 'NEEDS_HUMAN'} → ${path.join(genDir, 'PIPELINE.md')}`); process.exit(pass ? 0 : 1);
