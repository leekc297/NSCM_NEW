#!/usr/bin/env node
'use strict';
// snapshot — 생성기 회귀 테스트: 전 화면 골격을 임시 폴더에 생성해 파일 해시를 기준선과 비교한다 (룰/템플릿 변경이 의도한 화면만 바꿨는지 확인)
//   node snapshot.js --update        기준선 갱신 (rules/_snapshot.json)
//   node snapshot.js                 비교 → 변경 화면/파일 목록, exit 1 if 변경
//   node snapshot.js DMF0003 ...     일부만
const fs = require('fs'); const path = require('path'); const os = require('os'); const crypto = require('crypto'); const { spawnSync } = require('child_process');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfgPath = opt('--config', path.join(__dirname, 'harness.json')); const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules'); const base = path.join(R, '_snapshot.json');
const ids = a.filter(x => !x.startsWith('--') && a[a.indexOf(x) - 1] !== '--config').map(x => x.toUpperCase());
const screens = fs.readdirSync(path.join(cfg.asisOutDir, 'screens')).filter(d => /^[A-Z]/.test(d) && fs.statSync(path.join(cfg.asisOutDir, 'screens', d)).isDirectory() && (!ids.length || ids.includes(d.toUpperCase())));
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'harness-snap-')); const tcfg = Object.assign({}, cfg, { genOutDir: tmp }); const tcfgF = path.join(tmp, 'harness.json'); fs.writeFileSync(tcfgF, JSON.stringify(tcfg));
const walk = d => fs.existsSync(d) ? fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]) : [];
const cur = {}; let fail = 0;
for (const id of screens) {
  const r = spawnSync(process.execPath, [path.join(__dirname, 'gen.js'), id, '--config', tcfgF], { encoding: 'utf8' });
  if (r.status !== 0) { cur[id] = { _error: (r.stderr || r.stdout || '').trim().slice(0, 200) }; fail++; continue; }
  const dir = path.join(tmp, id); const files = {};
  for (const f of walk(dir)) { const rel = path.relative(dir, f).replace(/\\/g, '/'); if (/GEN_NOTES\.md$|REPAIR\.md$|CHECK\.md$/.test(rel)) continue; const txt = fs.readFileSync(f, 'utf8').replace(/TobeGen \d{4}-\d{2}-\d{2}|\d{4}-\d{2}-\d{2}T[\d:.]+Z?|생성: [^\n]*\d{4}-\d{2}-\d{2}/g, '<date>'); files[rel] = crypto.createHash('sha1').update(txt).digest('hex').slice(0, 12); }
  cur[id] = files;
}
fs.rmSync(tmp, { recursive: true, force: true });
if (a.includes('--update')) { const prev = fs.existsSync(base) ? JSON.parse(fs.readFileSync(base, 'utf8')) : {}; fs.writeFileSync(base, JSON.stringify(Object.assign(prev, cur), null, 1), 'utf8'); console.log(`기준선 갱신: ${Object.keys(cur).length}화면 (${fail} 생성 실패) → ${base}`); process.exit(fail ? 1 : 0); }
if (!fs.existsSync(base)) { console.error('기준선 없음 — 먼저 node snapshot.js --update'); process.exit(2); }
const prev = JSON.parse(fs.readFileSync(base, 'utf8')); const changed = [];
for (const id of Object.keys(cur)) {
  const p = prev[id]; if (!p) { changed.push([id, 'NEW', Object.keys(cur[id]).length]); continue; }
  const keys = new Set([...Object.keys(p), ...Object.keys(cur[id])]); const diff = [...keys].filter(k => p[k] !== cur[id][k]);
  if (diff.length) changed.push([id, 'CHANGED', diff.length, diff.slice(0, 6).join(', ')]);
}
const md = [`# 생성기 스냅샷 비교 — ${new Date().toISOString().slice(0, 16).replace('T', ' ')}`, '', `화면 ${Object.keys(cur).length} · 변경 ${changed.length} · 생성 실패 ${fail}`, '', '| 화면 | 상태 | 파일 수 | 파일 |', '|---|---|---|---|', ...changed.map(c => `| ${c[0]} | ${c[1]} | ${c[2]} | ${c[3] || ''} |`)];
fs.mkdirSync(cfg.genOutDir, { recursive: true }); fs.writeFileSync(path.join(cfg.genOutDir, '_snapshot_diff.md'), md.join('\n') + '\n', 'utf8');
console.log(md.slice(0, 3).join('\n')); for (const c of changed.slice(0, 30)) console.log(`  ${c[0]} ${c[1]} ${c[2]} ${c[3] || ''}`);
console.log(`→ ${path.join(cfg.genOutDir, '_snapshot_diff.md')}`);
process.exit(changed.length || fail ? 1 : 0);
