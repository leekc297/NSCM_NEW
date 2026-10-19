#!/usr/bin/env node
'use strict';
// 룰 보완 후보 — Doc/gap/*_gap.csv 의 MISSING/UNMAPPED 를 유형별로 집계해, 사전에 붙여 넣을 수 있는 CSV 행 초안을 만든다 (6단계 "원천 차단" 루프의 입력).
//   node suggest-rules.js [--config harness.json] [--min 3]   → rules/_candidates.md, rules/_candidates.csv
const fs = require('fs'); const path = require('path');
const { readCsv, CsvOut } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules'); const gapDir = cfg.gapDir; const MIN = Number(opt('--min', 3));
const files = fs.readdirSync(gapDir).filter(f => /_gap\.csv$/.test(f));
const agg = { ctl_type: {}, ctl_name: {}, event: {}, sp_family: {}, sp: {} };
const bump = (k, key, id, extra) => { const o = agg[k][key] = agg[k][key] || { n: 0, screens: new Set(), extra: new Set() }; o.n++; o.screens.add(id); if (extra) o.extra.add(extra); };
for (const f of files) {
  const id = f.replace(/_gap\.csv$/, '');
  for (const r of readCsv(path.join(gapDir, f))) {
    if (!/MISSING|UNMAPPED/.test(r.status)) continue;
    if (r.kind === 'control') { const t = (r.asis_detail.match(/^(\S+) →/) || [, '?'])[1]; bump('ctl_type', t, id); bump('ctl_name', r.asis_item.replace(/\d+$/, ''), id, t); }
    else if (r.kind === 'event') { const [tgt, ev] = r.asis_item.split('.'); bump('event', `${(tgt || '').replace(/\d+$/, '').replace(/^(btn|cbo|clb|chk|txt|spd|drp|rd|rgrp)[A-Za-z]*$/, '$1*')}.${ev}`, id); }
    else if (r.kind === 'endpoint') { const sp = (r.asis_detail.match(/^SP (\S+)/) || [, ''])[1]; if (!sp) continue; bump('sp', sp, id); const fam = sp.replace(/^[A-Z]+\d+_/, '*_').replace(/_(\d+)$/, '_N'); bump('sp_family', fam, id); }
  }
}
// 이미 사전에 있는 것은 후보에서 제외 (UNMAPPED 는 매핑표가 없어서지 룰이 없어서가 아님)
const mapCtl = readCsv(path.join(R, 'map_control.csv')), mapField = readCsv(path.join(R, 'map_field.csv')), mapBtn = readCsv(path.join(R, 'map_button.csv')), mapEv = readCsv(path.join(R, 'map_event.csv')), gaps = readCsv(path.join(R, 'allowed_gaps.csv'));
const known = {
  ctl_type: k => mapCtl.some(r => r.asis_type === k),
  ctl_name: k => mapField.some(r => new RegExp(r.name_pattern, 'i').test(k)) || mapBtn.some(r => new RegExp(r.name_pattern, 'i').test(k)) || gaps.some(g => g.kind === 'control_name' && new RegExp(g.pattern, 'i').test(k)) || /^spd/i.test(k),
  event: k => { const [t, e] = k.split('.'); const tt = t.replace('*', 'X'); return mapEv.some(r => new RegExp(r.asis_target_pattern, 'i').test(tt) && new RegExp('^(' + r.asis_event + ')$', 'i').test(e)) || gaps.some(g => g.kind === 'event' && new RegExp(g.pattern, 'i').test(tt + ' ' + e)); },
  sp_family: k => gaps.some(g => g.kind === 'endpoint' && new RegExp(g.pattern, 'i').test(k.replace('*_', 'X_'))),
  sp: k => gaps.some(g => g.kind === 'endpoint' && new RegExp(g.pattern, 'i').test(k))
};
const top = (k, min = MIN) => Object.entries(agg[k]).filter(([key, v]) => v.screens.size >= min && !known[k](key)).sort((x, y) => y[1].screens.size - x[1].screens.size);
const md = [`# 룰 보완 후보 — ${new Date().toISOString().slice(0, 10)} (gap ${files.length}화면, ${MIN}화면 이상 반복만)`, '',
  '아래는 GAP 에서 MISSING/UNMAPPED 로 반복되는 As-is 요소다. 각 행은 "표준 매핑을 정하면 map_* 에, 의도된 차이면 allowed_gaps 에" 한 줄로 끝난다. 결정 후 `_candidates.csv` 의 해당 행을 대상 CSV 로 옮기면 생성기·검사기가 함께 바뀐다.', ''];
const out = new CsvOut(path.join(R, '_candidates.csv'), ['target_csv', 'suggested_row', 'kind', 'key', 'screens', 'count', 'example_screens', 'decision']);
md.push('## 1. 컨트롤 타입 (map_control.csv 보강 또는 allowed_gaps control_type)', '', '| As-is 타입 | 화면 수 | 건수 | 예 |', '|---|---:|---:|---|');
for (const [k, v] of top('ctl_type')) { md.push(`| ${k} | ${v.screens.size} | ${v.n} | ${[...v.screens].slice(0, 5).join(' ')} |`); out.row({ target_csv: 'map_control.csv | allowed_gaps.csv', suggested_row: `${k},<To-Be 컴포넌트>,<import>,form-field,,field,  |  control_type,^${k}$,<사유>,`, kind: 'ctl_type', key: k, screens: v.screens.size, count: v.n, example_screens: [...v.screens].slice(0, 5).join(' '), decision: '' }); }
md.push('', '## 2. 컨트롤 이름 패턴 (map_field.csv 카탈로그 배정 또는 map_button.csv)', '', '| 이름(숫자 제거) | 타입 | 화면 수 | 예 |', '|---|---|---:|---|');
for (const [k, v] of top('ctl_name')) { md.push(`| ${k} | ${[...v.extra].join('/')} | ${v.screens.size} | ${[...v.screens].slice(0, 5).join(' ')} |`); out.row({ target_csv: 'map_field.csv | map_button.csv', suggested_row: `^${k}\\d*$,<Field>,<kind>,<paramKey>,<comboId>,<LBL>,`, kind: 'ctl_name', key: k, screens: v.screens.size, count: v.n, example_screens: [...v.screens].slice(0, 5).join(' '), decision: '' }); }
md.push('', '## 3. 이벤트 (map_event.csv 또는 allowed_gaps event)', '', '| 타깃.이벤트 | 화면 수 | 예 |', '|---|---:|---|');
for (const [k, v] of top('event')) { md.push(`| ${k} | ${v.screens.size} | ${[...v.screens].slice(0, 5).join(' ')} |`); const [t, e] = k.split('.'); out.row({ target_csv: 'map_event.csv | allowed_gaps.csv', suggested_row: `^${t.replace('*', '')},${e},handler,"<To-Be 패턴>",  |  event,^${t.replace('*', '')}\\w*\\s+${e},<사유>,`, kind: 'event', key: k, screens: v.screens.size, count: v.n, example_screens: [...v.screens].slice(0, 5).join(' '), decision: '' }); }
md.push('', '## 4. SP 계열 (allowed_gaps endpoint — 공통 SP 는 콤보/메타/권한으로 대체되는 것이 보통)', '', '| SP 패턴 | 화면 수 | 예 SP |', '|---|---:|---|');
for (const [k, v] of top('sp_family')) { const ex = Object.keys(agg.sp).filter(s => s.replace(/^[A-Z]+\d+_/, '*_').replace(/_(\d+)$/, '_N') === k).slice(0, 3); md.push(`| ${k} | ${v.screens.size} | ${ex.join(' ')} |`); out.row({ target_csv: 'allowed_gaps.csv', suggested_row: `endpoint,${k.replace('*_', '_').replace(/\*/g, '.*')}$,<대체 수단>,`, kind: 'sp_family', key: k, screens: v.screens.size, count: v.n, example_screens: [...v.screens].slice(0, 5).join(' '), decision: '' }); }
md.push('', '## 5. 공통 SP 단건 (여러 화면이 같은 SP 를 호출 — 공통 콤보/권한 후보)', '', '| SP | 화면 수 |', '|---|---:|');
for (const [k, v] of top('sp', Math.max(MIN, 3))) md.push(`| ${k} | ${v.screens.size} |`);
out.close(); fs.writeFileSync(path.join(R, '_candidates.md'), md.join('\n') + '\n', 'utf8');
console.log(`후보: 타입 ${top('ctl_type').length}, 이름 ${top('ctl_name').length}, 이벤트 ${top('event').length}, SP계열 ${top('sp_family').length} → ${path.join(R, '_candidates.md')}`);
