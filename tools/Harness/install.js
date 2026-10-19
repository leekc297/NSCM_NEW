#!/usr/bin/env node
'use strict';
// 하네스 설치 — .claude/settings.json 에 hook 3개를 병합(중복 없이), husky pre-commit 에 게이트 한 줄 추가. 백업을 남긴다.
//   node install.js [--settings C:/Projects/NSCM/.claude/settings.json] [--husky C:/Projects/NSCM/nscm-fe/.husky/pre-commit] [--dry]
const fs = require('fs'); const path = require('path');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const dry = a.includes('--dry');
const settings = opt('--settings', 'C:/Projects/NSCM/.claude/settings.json');
const husky = opt('--husky', 'C:/Projects/NSCM/nscm-fe/.husky/pre-commit');
const H = 'C:/Projects/NSCM/tools/Harness/hooks';
const ps = f => `powershell -NoProfile -ExecutionPolicy Bypass -File ${H}/${f}`;
const want = {
  PostToolUse: { matcher: 'Write|Edit|MultiEdit', hook: { type: 'command', command: ps('check-asis-harness.ps1'), timeout: 30 } },
  Stop: { matcher: '', hook: { type: 'command', command: ps('harness-stop-gate.ps1'), timeout: 60 } },
  UserPromptSubmit: { matcher: '.*', hook: { type: 'command', command: ps('harness-gen-context.ps1'), timeout: 10 } }
};
const stamp = new Date().toISOString().replace(/[-:T]/g, '').slice(0, 14);
if (fs.existsSync(settings)) {
  const raw = fs.readFileSync(settings, 'utf8').replace(/^\uFEFF/, ''); const j = JSON.parse(raw); j.hooks = j.hooks || {};
  let changed = 0;
  for (const [ev, w] of Object.entries(want)) {
    j.hooks[ev] = j.hooks[ev] || [];
    const exists = j.hooks[ev].some(g => (g.hooks || []).some(h => h.command === w.hook.command));
    if (exists) continue;
    let group = j.hooks[ev].find(g => (g.matcher || '') === w.matcher);
    if (!group) { group = w.matcher ? { matcher: w.matcher, hooks: [] } : { hooks: [] }; j.hooks[ev].push(group); }
    group.hooks.push(w.hook); changed++;
  }
  if (changed && !dry) { fs.copyFileSync(settings, settings + '.bak_' + stamp); fs.writeFileSync(settings, JSON.stringify(j, null, 2) + '\n', 'utf8'); }
  console.log(`settings.json: hook ${changed}개 추가${dry ? ' (dry)' : ''} → ${settings}`);
} else console.log(`settings.json 없음: ${settings}`);
if (fs.existsSync(husky)) {
  const t = fs.readFileSync(husky, 'utf8');
  const line = 'node ../tools/Harness/pre-commit.js || exit 1   # Harness: 변경된 화면 폴더 게이트';
  if (!t.includes('tools/Harness/pre-commit.js')) { if (!dry) { fs.copyFileSync(husky, husky + '.bak_' + stamp); fs.writeFileSync(husky, t.replace(/\s*$/, '\n') + line + '\n', 'utf8'); } console.log(`husky pre-commit: 게이트 추가${dry ? ' (dry)' : ''}`); }
  else console.log('husky pre-commit: 이미 설치됨');
} else console.log(`husky pre-commit 없음: ${husky}`);
