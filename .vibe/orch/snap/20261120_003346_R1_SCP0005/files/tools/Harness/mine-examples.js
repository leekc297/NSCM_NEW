#!/usr/bin/env node
'use strict';
// mine-examples — 하우스 스타일 few-shot 코퍼스: 매핑표(상태 구현)의 "As-is 항목 → To-Be 구현 위치(파일:라인)" 짝에서 실제 코드 조각을 떠서
//   유형별(§1 컨트롤 타입 / §2 이벤트 / §4 엔드포인트 / §5 시트) 예제 파일을 만든다. Claude Code 프롬프트(new_screen.md)가 이 예제를 읽어 기존 코드와 같은 모양으로 채운다.
//   node mine-examples.js [--per 3] [--lines 45]
//   입력: Doc/tobefacts/asis_mapping.csv, nscm-fe 소스   산출: tools/Harness/prompts/examples/<유형>.md + INDEX.md
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const PER = Number(opt('--per', 3)), LINES = Number(opt('--lines', 45));
const outDir = path.join(__dirname, 'prompts', 'examples'); fs.mkdirSync(outDir, { recursive: true });
const rows = readCsv(path.join(cfg.tobeOutDir, 'asis_mapping.csv')).filter(r => /^구현/.test(r.status) && /:\d+/.test(r.impl_location));
// 유형 키: §1 → 컨트롤 타입(UsrButton/LayoutControlItem/…), §2 → 이벤트명(Click/CellDoubleClick/…), §4 → 'endpoint', §5 → 'sheet'
const typeOf = r => { const s = r.summary; const m1 = /^§1 .*? \/ (\w+)/.exec(s); if (m1) return `control-${m1[1]}`; const m2 = /^§2 .*? \/ (\w+)/.exec(s); if (m2) return `event-${m2[1]}`; if (/^§4/.test(s)) return 'endpoint'; if (/^§5/.test(s)) return 'sheet'; return 'other'; };
const groups = {};
for (const r of rows) {
  const t = typeOf(r); if (t === 'other') continue;
  const loc = /([\w./-]+\.tsx?):(\d+)(?:-(\d+))?/.exec(r.impl_location); if (!loc) continue;
  const pageDir = path.join(cfg.feRoot, path.dirname(r.file)); let file = path.join(pageDir, loc[1]); if (!fs.existsSync(file)) { const alt = path.join(pageDir, 'components', loc[1]); if (fs.existsSync(alt)) file = alt; else continue; }
  const src = fs.readFileSync(file, 'utf8').split(/\r?\n/); const s0 = Number(loc[2]), s1 = loc[3] ? Number(loc[3]) : s0;
  // 조각: 지정 라인(들) 주변 — 함수/JSX 블록을 넉넉히 (최대 LINES 줄)
  let from = Math.max(1, s0 - 6), to = Math.min(src.length, Math.max(s1 + 10, s0 + 20)); if (to - from > LINES) to = from + LINES;
  const snippet = src.slice(from - 1, to).join('\n');
  (groups[t] = groups[t] || []).push({ menu: r.menu_id, summary: r.summary, where: `${path.relative(cfg.feRoot, file).replace(/\\/g, '/')}:${from}-${to}`, note: r.reason, snippet, score: snippet.length });
}
const index = [`# 하우스 스타일 예제 색인 (mine-examples.js ${new Date().toISOString().slice(0, 10)}) — 매핑표 '구현' ${rows.length}행에서 추출`, '', '| 유형 | 예제 수 | 파일 |', '|---|---|---|'];
for (const [t, list] of Object.entries(groups).sort()) {
  // 화면 다양성: 같은 화면은 1개씩 우선
  const byMenu = new Map(); for (const e of list) if (!byMenu.has(e.menu)) byMenu.set(e.menu, e); const picked = [...byMenu.values()].slice(0, PER);
  const md = [`# 예제 — ${t} (${list.length}건 중 ${picked.length})`, '', '같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**', ''];
  for (const e of picked) md.push(`## ${e.menu} · ${e.summary}`, `- 위치: \`${e.where}\`${e.note ? `\n- 비고: ${e.note}` : ''}`, '', '```tsx', e.snippet, '```', '');
  fs.writeFileSync(path.join(outDir, `${t}.md`), md.join('\n'), 'utf8'); index.push(`| ${t} | ${list.length} | examples/${t}.md |`);
}
fs.writeFileSync(path.join(outDir, 'INDEX.md'), index.join('\n') + '\n', 'utf8');
console.log(`예제 ${Object.keys(groups).length}유형 → ${outDir}  (` + Object.entries(groups).map(([t, l]) => `${t}:${l.length}`).join(' ') + ')');
