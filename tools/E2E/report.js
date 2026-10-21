#!/usr/bin/env node
'use strict';
// report — Playwright results.json → Doc/e2e/results/_summary.csv / _summary.md (화면×종류 판정, 어노테이션 요약)
const fs = require('fs'); const path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^\uFEFF/, ''));
const dir = process.env.E2E_RESULTS || cfg.resultsDir; const f = path.join(dir, 'results.json');
if (!fs.existsSync(f)) { console.error('results.json 없음: ' + f); process.exit(2); }
// 2026-10-21: 이번 실행에서 갱신된 결과인지 확인 — run-e2e.cmd 의 잠금(_run.lock) 시작 시각보다 오래된 results.json 이면 Playwright 가 돌지 않은 것(예전 결과를 다시 출력하고 exit 0 하던 사고)
{
  const lockF = path.join(path.dirname(dir), '_run.lock');
  try {
    if (fs.existsSync(lockF)) {
      const lk = JSON.parse(fs.readFileSync(lockF, 'utf8')); const mt = fs.statSync(f).mtimeMs;
      if (lk.startedMs && mt < lk.startedMs - 2000) { console.error(`[FAIL] results.json 이 이번 실행(${lk.started}) 에서 갱신되지 않았습니다 — Playwright 미실행. 로그: Doc/e2e/logs/run_${lk.runId}_*.log`); process.exit(3); }
    }
  } catch (e) { console.error('[WARN] 결과 신선도 확인 실패: ' + e.message); }
}
const R = JSON.parse(fs.readFileSync(f, 'utf8'));
const rows = [];
const walk = (s, file) => { for (const sp of s.specs || []) for (const t of sp.tests || []) { const last = t.results[t.results.length - 1] || {}; const ann = (t.annotations || []).concat(last.annotations || []); const soft = (last.errors || []).map(e => (e.message || '').split('\n')[0].replace(/\u001b\[[0-9;]*m/g, '')).slice(0, 5); const m = /^([A-Z0-9_]+)\.(smoke|crud|authcrud|auth)\.spec\.ts$/.exec(path.basename(file || s.file || '')); rows.push({ menu_id: m ? m[1] : '', kind: m ? m[2] : '', title: sp.title + (t.projectName ? '' : ''), account: (sp.title.match(/\[([^\s\]]+)/) || [])[1] || '', status: t.status === 'expected' ? 'PASS' : t.status === 'unexpected' ? 'FAIL' : t.status === 'flaky' ? 'FLAKY' : 'SKIP', duration_ms: last.duration || 0, soft_fails: soft.length, annotations: ann.map(x => `${x.type}: ${x.description}`).join(' || ').replace(/\s+/g, ' ').slice(0, 1500), errors: soft.join(' || ').slice(0, 800) }); } for (const c of s.suites || []) walk(c, file || s.file); };
for (const s of R.suites || []) walk(s, s.file);
// 2026-10-20: 종류별 실행이 쌓이도록 병합 — 이번 실행에 포함된 (화면, 종류) 는 교체, 나머지 기존 행은 유지(체인이 smoke→crud→auth→authcrud 를 따로 돌려도 요약이 4종 모두 남게)
{
  const prev = path.join(dir, '_summary.csv');
  if (fs.existsSync(prev)) {
    const parse = text => { text = text.replace(/^﻿/, ''); const out = []; let row = [], f = '', q = false; for (let i = 0; i < text.length; i++) { const ch = text[i]; if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); out.push(row); row = []; f = ''; } else f += ch; } if (f || row.length) { row.push(f); out.push(row); } return out.filter(r => r.length > 1); };
    const old = parse(fs.readFileSync(prev, 'utf8')); const h = old.shift() || [];
    const ix = k => h.indexOf(k); const fresh = new Set(rows.map(r => `${r.menu_id}|${r.kind}`));
    for (const r of old) { const o = Object.fromEntries(h.map((k, i) => [k, r[i] ?? ''])); if (!o.menu_id || fresh.has(`${o.menu_id}|${o.kind}`)) continue; rows.push({ menu_id: o.menu_id, kind: o.kind, title: '', account: o.account || '', status: o.status || '', duration_ms: Number(o.duration_ms || 0), soft_fails: Number(o.soft_fails || 0), annotations: o.annotations || '', errors: o.errors || '' }); }
    void ix;
    rows.sort((x, y) => (x.menu_id + x.kind + x.account).localeCompare(y.menu_id + y.kind + y.account));
  }
}
const csv = ['menu_id,kind,account,status,duration_ms,soft_fails,errors,annotations'].concat(rows.map(r => [r.menu_id, r.kind, r.account, r.status, r.duration_ms, r.soft_fails, r.errors, r.annotations].map(v => '"' + String(v).replace(/"/g, '""') + '"').join(','))).join('\n');
fs.writeFileSync(path.join(dir, '_summary.csv'), '\uFEFF' + csv + '\n', 'utf8');
// 2026-10-20: 테스트 단계 4종 — smoke · crud · auth · authcrud(권한별 CRUD)
const KINDS = ['smoke', 'crud', 'auth', 'authcrud'];
const by = {}; for (const r of rows) { const k = r.menu_id || '(기타)'; by[k] = by[k] || Object.fromEntries(KINDS.map(x => [x, []])); (by[k][r.kind] || (by[k][r.kind] = [])).push(r); }
const agg = arr => arr.length ? `${arr.filter(r => r.status === 'PASS').length}/${arr.length}${arr.some(r => r.status === 'FAIL') ? ' ✗' : ''}` : '-';
const localStamp = d => { const p = n => String(n).padStart(2, '0'); return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`; }; // 2026-10-21: UTC(toISOString) → 로컬 시각
const md = [`# E2E 결과 — ${localStamp(new Date())}`, '', `테스트 ${rows.length} · PASS ${rows.filter(r => r.status === 'PASS').length} · FAIL ${rows.filter(r => r.status === 'FAIL').length} · FLAKY ${rows.filter(r => r.status === 'FLAKY').length} · SKIP ${rows.filter(r => r.status === 'SKIP').length}`, '', '| 화면 | 스모크 | CRUD | 권한(계정×DIV) | 권한별 CRUD(계정) | 실패 요약 |', '|---|---|---|---|---|---|'];
for (const [k, v] of Object.entries(by).sort()) md.push(`| ${k} | ${agg(v.smoke)} | ${agg(v.crud)} | ${agg(v.auth)} | ${agg(v.authcrud)} | ${KINDS.flatMap(x => v[x]).filter(r => r.status === 'FAIL').map(r => `${r.kind}${r.account ? '[' + r.account + ']' : ''}: ${r.errors.split(' || ')[0].slice(0, 120)}`).slice(0, 4).join('<br>')} |`);
md.push('', '상세: `_summary.csv` (어노테이션: columns=컬럼 대사, dynamic=동적 기간 컬럼(정적 메타 밖 binding 수·타이틀 시트 호출), calls=call-proc, buttons=노출 버튼, division=DIV별 행수, crud=CRUD 사이클 결과(mode/saved/cleaned), authcrud=계정 권한 기대(btn_auth) vs 실측) · HTML: `html/index.html` · 실패 trace: `artifacts/`');
fs.writeFileSync(path.join(dir, '_summary.md'), md.join('\n') + '\n', 'utf8');
console.log(md.slice(0, 3).join('\n')); console.log(`→ ${dir}\\_summary.md`);
