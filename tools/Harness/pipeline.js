#!/usr/bin/env node
'use strict';
// pipeline — 화면 ID 하나로 끝까지: FE 골격 → 등록 SQL → PKG 골격 → FE 수선 루프(게이트 PASS) → PKG 이식 루프 → E2E 스펙 → [E2E 실행] → 대조표 갱신
//   node pipeline.js <ID> [--max 3] [--e2e] [--no-claude] [--regen-pkg] [--design <화면설계서.md>] [--config harness.json] [--phase 1[,2,…]]
//   --phase N   : 그 단계만 실행(1 FE골격 · 2 등록SQL · 3 PKG골격 · 4 FE수선 · 5 PKG이식 · 6 E2E스펙 · 7 대조표). 단계 결과는 Doc/gen/<ID>/_pipeline_steps.json 에 누적되고
//                 PIPELINE.md 는 누적본으로 다시 쓴다(Vibe_Manager 체인이 단계별 진행을 보여주기 위해 — 2026-10-20). 종료코드 = 이번에 실행한 단계의 실패 여부
//   --regen-pkg : 이식 작업이 들어간 <ID>_PKG.sql 을 버리고 골격을 다시 만든다(기본은 보존)
//   --no-claude : Claude 호출 없이 생성·게이트까지만 (골격 상태 확인용)   --e2e : FE/BE 가 떠 있을 때 스모크 실행까지
//   산출: Doc/gen/<ID>/PIPELINE.md (단계별 결과·소요·다음 할 일), 종료코드 0=전부 PASS / 1=사람 확인 필요
const fs = require('fs'); const path = require('path'); const { spawnSync } = require('child_process');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfgPath = opt('--config', path.join(__dirname, 'harness.json')); const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8').replace(/^﻿/, ''));
const ID = (a.find(x => !x.startsWith('--') && !['--max', '--config', '--phase', '--design'].includes(a[a.indexOf(x) - 1])) || '').toUpperCase(); if (!ID) { console.error('화면ID'); process.exit(2); }
const PH = String(opt('--phase', '')).split(',').map(x => parseInt(x, 10)).filter(n => n >= 1 && n <= 7); const want = n => !PH.length || PH.includes(n);
const MAX = opt('--max', '3'); const E2E = a.includes('--e2e'); const NOCLAUDE = a.includes('--no-claude');
const DESIGN = opt('--design', ''); const DARGS = DESIGN ? ['--design', DESIGN] : [];
const repo = path.dirname(cfg.feRoot); const genDir = path.join(cfg.genOutDir, ID); fs.mkdirSync(genDir, { recursive: true });
const stepsFile = path.join(genDir, '_pipeline_steps.json');
let steps = []; if (PH.length && fs.existsSync(stepsFile)) { try { steps = JSON.parse(fs.readFileSync(stepsFile, 'utf8')).filter(st => !PH.includes(parseInt(String(st.name).trim(), 10))); } catch { steps = []; } }
const ranNow = []; const saveSteps = () => { try { fs.writeFileSync(stepsFile, JSON.stringify(steps, null, 1), 'utf8'); } catch { } };
const run = (name, cmd, args, opts = {}) => {
  const t0 = Date.now(); const r = spawnSync(cmd, args, Object.assign({ encoding: 'utf8', maxBuffer: 256 * 1024 * 1024, shell: process.platform === 'win32' && !/node/.test(cmd) }, opts));
  const out = ((r.stdout || '') + (r.stderr || '')).trim(); const sec = Math.round((Date.now() - t0) / 1000);
  const st = { name, code: r.status, sec, tail: out.split(/\r?\n/).slice(-12).join('\n'), at: new Date().toISOString() }; steps.push(st); ranNow.push(st); saveSteps(); console.log(`[${r.status === 0 ? 'OK' : 'EXIT ' + r.status}] ${name} (${sec}s)`); return r;
};
const N = process.execPath; const H = f => path.join(__dirname, f); const C = ['--config', cfgPath];
// 1 FE 골격(없을 때만 --apply)
const reg = path.join(genDir, 'register.json');
const pageOf = () => { if (!fs.existsSync(reg)) return null; const r = JSON.parse(fs.readFileSync(reg, 'utf8')); return path.join(cfg.feRoot, 'features', r.feature, 'src', 'pages', r.pageDir); };
let pageDir = pageOf();
// 페이지 보호(lib/applied.touchReason): git 추적(커밋본)·매니페스트 없음·적용 후 변경·REPAIR.md 중 하나면 Doc/gen 에만 생성한다 — 파이프라인은 절대 --force 하지 않는다
const why = pageDir && fs.existsSync(pageDir) ? require('./lib/applied').touchReason(pageDir, genDir) : null;
if (want(1)) {
  if (!pageDir || !fs.existsSync(pageDir)) run('1 FE 골격 생성 + nscm-fe 적용(gen --apply)', N, [H('gen.js'), ID, '--apply', ...C]);
  else if (!why) run('1 FE 골격 재생성 + 재적용(하네스 골격 그대로 → gen --apply --overwrite)', N, [H('gen.js'), ID, '--apply', '--overwrite', ...C]);
  else run(`1 FE 골격 재생성(Doc/gen 만 — 페이지 보존: ${why})`, N, [H('gen.js'), ID, ...C]);
}
pageDir = pageOf();
// 2 등록 SQL · 3 PKG 골격
if (want(2)) run('2 Oracle 메타 등록 SQL(gen-register-sql)', N, [H('gen-register-sql.js'), ID, ...C]);
if (want(3)) { // 3 PKG 골격 — 이미 이식 작업이 들어간 <ID>_PKG.sql(골격 해시와 다름) 은 덮어쓰지 않는다(Claude 이식 결과 보존)
  const pkgFile = path.join(genDir, `${ID}_PKG.sql`), shaFile = path.join(genDir, `${ID}_PKG.sha256`);
  const FORCE_PKG = process.argv.includes('--regen-pkg'); // 골격 강제 재생성(이식 결과 폐기)
  const pkgTouched = !FORCE_PKG && fs.existsSync(pkgFile) && (!fs.existsSync(shaFile) || require('crypto').createHash('sha256').update(fs.readFileSync(pkgFile, 'utf8')).digest('hex') !== fs.readFileSync(shaFile, 'utf8').trim()); // 해시 파일 없음(구버전 골격)도 보존
  if (pkgTouched) { const st = { name: '3 Oracle PKG 골격(gen-pkg) — 건너뜀(이식 작업 흔적 있음, 기존 PKG.sql 보존)', code: 0, sec: 0, tail: '', at: new Date().toISOString() }; steps.push(st); ranNow.push(st); saveSteps(); console.log('[OK] 3 PKG 골격 건너뜀(이식 흔적 보존)'); }
  else run('3 Oracle PKG 골격(gen-pkg)', N, [H('gen-pkg.js'), ID, ...C]);
}
// 4 FE 수선 루프 / 5 PKG 이식 루프
if (!NOCLAUDE) { if (want(4)) run(`4 FE 수선 루프(Claude ×${MAX} + 게이트 --final)`, N, [H('repair-loop.js'), ID, '--max', MAX, '--no-gen', ...DARGS, ...C]); if (want(5)) run(`5 PKG 이식 루프(Claude ×${MAX} + check-pkg)`, N, [H('repair-loop.js'), ID, '--pkg', '--max', MAX, '--no-gen', ...C]); }
else if (pageDir && fs.existsSync(pageDir)) { if (want(4)) run('4 FE 게이트(--final, Claude 없음)', N, [H('check.js'), '--page', pageDir, '--id', ID, '--final', ...C]); if (want(5)) run('5 PKG 게이트(check-pkg)', N, [H('check-pkg.js'), ID, ...C]); }
// 6 E2E 스펙 (+실행)
const e2eDir = path.join(repo, 'tools', 'E2E'); if (want(6) && fs.existsSync(path.join(e2eDir, 'gen-e2e.js'))) { run('6 E2E 스펙 생성(gen-e2e)', N, [path.join(e2eDir, 'gen-e2e.js'), ID]); if (E2E) run('6b E2E 스모크 실행(run-e2e smoke)', path.join(e2eDir, 'run-e2e.cmd'), ['smoke', ID], { cwd: e2eDir }); }
// 7 대조표
const reconDir = path.join(repo, 'tools', 'Recon'); if (want(7) && fs.existsSync(path.join(reconDir, 'recon.js'))) run('7 대조표 갱신(recon)', N, [path.join(reconDir, 'recon.js'), ...C]);
steps.sort((x, y) => (parseInt(String(x.name).trim(), 10) || 0) - (parseInt(String(y.name).trim(), 10) || 0)); saveSteps();
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
if (PH.length) { const bad = ranNow.filter(st => st.code !== 0); console.log(`\n[phase ${PH.join(',')}] ${bad.length ? 'FAIL ' + bad.map(b => b.name).join(' / ') : 'OK'} · 누적 ${steps.length}단계 → ${path.join(genDir, 'PIPELINE.md')}`); process.exit(bad.length ? 1 : 0); }
console.log(`\n${pass ? 'PASS' : 'NEEDS_HUMAN'} → ${path.join(genDir, 'PIPELINE.md')}`); process.exit(pass ? 0 : 1);
