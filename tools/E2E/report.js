#!/usr/bin/env node
'use strict';
// report — Playwright results.json → Doc/e2e/results/_summary.csv / _summary.md (화면×종류 판정, 어노테이션 요약)
const fs = require('fs'); const path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^\uFEFF/, ''));
const dir = process.env.E2E_RESULTS || cfg.resultsDir; const f = path.join(dir, 'results.json');
if (!fs.existsSync(f)) { console.error('results.json 없음: ' + f); process.exit(2); }
const R = JSON.parse(fs.readFileSync(f, 'utf8'));
const rows = [];
const walk = (s, file) => { for (const sp of s.specs || []) for (const t of sp.tests || []) { const last = t.results[t.results.length - 1] || {}; const ann = (t.annotations || []).concat(last.annotations || []); const soft = (last.errors || []).map(e => (e.message || '').split('\n')[0].replace(/\u001b\[[0-9;]*m/g, '')).slice(0, 5); const m = /^([A-Z0-9_]+)\.(smoke|crud|auth)\.spec\.ts$/.exec(path.basename(file || s.file || '')); rows.push({ menu_id: m ? m[1] : '', kind: m ? m[2] : '', title: sp.title + (t.projectName ? '' : ''), account: (sp.title.match(/\[([^\s\]]+)/) || [])[1] || '', status: t.status === 'expected' ? 'PASS' : t.status === 'unexpected' ? 'FAIL' : t.status === 'flaky' ? 'FLAKY' : 'SKIP', duration_ms: last.duration || 0, soft_fails: soft.length, annotations: ann.map(x => `${x.type}: ${x.description}`).join(' || ').replace(/\s+/g, ' ').slice(0, 1500), errors: soft.join(' || ').slice(0, 800) }); } for (const c of s.suites || []) walk(c, file || s.file); };
for (const s of R.suites || []) walk(s, s.file);
const csv = ['menu_id,kind,account,status,duration_ms,soft_fails,errors,annotations'].concat(rows.map(r => [r.menu_id, r.kind, r.account, r.status, r.duration_ms, r.soft_fails, r.errors, r.annotations].map(v => '"' + String(v).replace(/"/g, '""') + '"').join(','))).join('\n');
fs.writeFileSync(path.join(dir, '_summary.csv'), '\uFEFF' + csv + '\n', 'utf8');
const by = {}; for (const r of rows) { const k = r.menu_id || '(기타)'; by[k] = by[k] || { smoke: [], crud: [], auth: [] }; (by[k][r.kind] || (by[k][r.kind] = [])).push(r); }
const agg = arr => arr.length ? `${arr.filter(r => r.status === 'PASS').length}/${arr.length}${arr.some(r => r.status === 'FAIL') ? ' ✗' : ''}` : '-';
const md = [`# E2E 결과 — ${new Date().toISOString().slice(0, 16).replace('T', ' ')}`, '', `테스트 ${rows.length} · PASS ${rows.filter(r => r.status === 'PASS').length} · FAIL ${rows.filter(r => r.status === 'FAIL').length} · FLAKY ${rows.filter(r => r.status === 'FLAKY').length} · SKIP ${rows.filter(r => r.status === 'SKIP').length}`, '', '| 화면 | 스모크 | CRUD | 권한(계정×DIV) | 실패 요약 |', '|---|---|---|---|---|'];
for (const [k, v] of Object.entries(by).sort()) md.push(`| ${k} | ${agg(v.smoke)} | ${agg(v.crud)} | ${agg(v.auth)} | ${[...v.smoke, ...v.crud, ...v.auth].filter(r => r.status === 'FAIL').map(r => `${r.kind}${r.account ? '[' + r.account + ']' : ''}: ${r.errors.split(' || ')[0].slice(0, 120)}`).slice(0, 3).join('<br>')} |`);
md.push('', '상세: `_summary.csv` (어노테이션: columns=컬럼 대사, calls=call-proc, buttons=노출 버튼, division=DIV별 행수) · HTML: `html/index.html` · 실패 trace: `artifacts/`');
fs.writeFileSync(path.join(dir, '_summary.md'), md.join('\n') + '\n', 'utf8');
console.log(md.slice(0, 3).join('\n')); console.log(`→ ${dir}\\_summary.md`);
