#!/usr/bin/env node
'use strict';
// husky pre-commit 용 — 스테이징된 파일이 속한 화면 폴더마다 check.js (BLOCK 만 커밋 차단, 미구현은 경고)
const { execSync, spawnSync } = require('child_process'); const path = require('path'); const fs = require('fs');
const fe = process.cwd();
const staged = execSync('git diff --cached --name-only --diff-filter=ACMR', { encoding: 'utf8' }).split(/\r?\n/).filter(Boolean);
const dirs = [...new Set(staged.map(f => (f.match(/^(features\/[^/]+\/src\/pages\/[^/]+)\//) || [])[1]).filter(Boolean))];
let bad = 0;
for (const d of dirs) {
  const full = path.join(fe, d); if (!fs.existsSync(full)) continue;
  const r = spawnSync('node', [path.join(__dirname, 'check.js'), '--page', full], { encoding: 'utf8' });
  process.stdout.write((r.stdout || '') + (r.stderr || ''));
  if (r.status === 2) bad++;
}
if (bad) { console.error(`\n[Harness] BLOCK ${bad}개 화면 — 커밋 중단`); process.exit(1); }
