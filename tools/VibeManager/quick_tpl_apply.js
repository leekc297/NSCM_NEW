// 2026-11-26 개선안 20261126164547_SELF: quick.json 체인의 같은 3단계 묶음(미검증 해소, 해소 게이트, 재검증 1회)을 stepTemplates.unverifiedLoop 1곳으로 옮기고
//   체인 단계는 { "use": "unverifiedLoop" } 로 바꾸는 변환기. 펼쳐 읽는 코드(quick-tpl.js, prompt-panel.js loadQuick)가 VS Code 에 올라온 뒤에만 실행한다.
//   이유: 지금 돌고 있는 VM(설치본)이 { use } 를 모르면 그 단계를 '프롬프트 없음'(exit 2)으로 실패시킴(workbench.js runOnce).
//   사용: node tools/VibeManager/quick_tpl_apply.js [--check]   (--check = 바꿀 곳 수만 보고 파일은 그대로)
//   변환 뒤 확인: node tools/VibeManager/test/t_quick_tpl.js tools/VibeManager (반영 전 사본 quick.json.bak_<태그> 와 펼친 결과 비교)
'use strict';
const fs = require('fs'); const path = require('path');
const f = path.join(__dirname, 'quick.json'); const check = process.argv.includes('--check');
const rawText = fs.readFileSync(f, 'utf8'); const q = JSON.parse(rawText.replace(/^﻿/, ''));
const NAME = 'unverifiedLoop'; const key = s => JSON.stringify(s);
const tasks = ['S8.unverified', 'S8.unverifiedGate', 'S8.verify'];
const chains = q.groups.flatMap(g => g.items || []).filter(i => Array.isArray(i.steps));
let block = q.stepTemplates && q.stepTemplates[NAME] ? q.stepTemplates[NAME].steps : null;
if (!block) for (const c of chains) { const i = c.steps.findIndex((s, k) => tasks.every((t, j) => c.steps[k + j] && c.steps[k + j].task === t)); if (i >= 0) { block = c.steps.slice(i, i + 3); break; } }
if (!block) { console.log('바꿀 묶음 없음(이미 바꿨거나 체인에 없음)'); process.exit(0); }
const sig = block.map(key).join('|'); let n = 0; const odd = [];
for (const c of chains) {
  const out = [];
  for (let i = 0; i < c.steps.length; i++) {
    const s = c.steps[i];
    if (i + 3 <= c.steps.length && c.steps.slice(i, i + 3).map(key).join('|') === sig) { out.push({ use: NAME }); n++; i += 2; continue; }
    if (s && s.task === tasks[0] && c.steps[i + 1] && c.steps[i + 1].task === tasks[1]) odd.push(`${c.label} ${i + 1}단계(내용이 틀과 다름, 그대로 둠)`);
    out.push(s);
  }
  c.steps = out;
}
console.log(`틀 ${NAME} 로 바꿀 곳 ${n}${odd.length ? ` · 틀과 다른 묶음 ${odd.length}: ${odd.join(' / ')}` : ''}`);
if (check || !n) process.exit(0);
const desc = '미검증 해소 묶음: 미검증 해소(분류, 자동 재측정, 검사엔진 보완, 최대 2회) → 해소 게이트(열린 행 0 확인) → CheckList 재검증 1회(게이트 통과 때만). 체인이 { "use": "unverifiedLoop" } 로 부름(2026-11-26 개선안 20261126164547_SELF)';
const nq = {}; for (const k of Object.keys(q)) { if (k === 'stepTemplates') continue; nq[k] = q[k]; if (k === '$comment') nq.stepTemplates = Object.assign({}, q.stepTemplates || {}, { [NAME]: { desc, steps: block } }); }
if (!nq.stepTemplates) nq.stepTemplates = { [NAME]: { desc, steps: block } };
let s = JSON.stringify(nq, null, 2); if (rawText.includes('\r\n')) s = s.replace(/\n/g, '\r\n');
const bak = `${f}.bak_${new Date().toISOString().slice(0, 10).replace(/-/g, '')}_tpl`; fs.copyFileSync(f, bak);
fs.writeFileSync(f, s, 'utf8'); console.log(`quick.json 변환 끝 · 백업 ${path.basename(bak)}`);
