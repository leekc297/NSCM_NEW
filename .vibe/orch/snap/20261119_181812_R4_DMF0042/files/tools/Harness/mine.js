#!/usr/bin/env node
'use strict';
// 짝지어진 화면(As-is Fact ↔ To-Be Fact + __asis-mapping__.md)에서 매핑 사전 초안을 채굴한다.
//   node mine.js --tobe <Doc/tobefacts> --asis <Doc/asisfacts> --out rules/
// 산출: map_control.mined.csv, map_event.mined.csv, allowed_gaps.mined.csv, pairs.csv
const fs = require('fs'); const path = require('path');
const { readCsv, CsvOut } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const tobe = opt('--tobe'), asis = opt('--asis'), out = opt('--out', path.join(__dirname, 'rules'));
fs.mkdirSync(out, { recursive: true });

const map = readCsv(path.join(tobe, 'asis_mapping.csv'));
const ctl = readCsv(path.join(tobe, 'controls.csv'));
const compCount = {}; for (const c of ctl) compCount[c.component] = (compCount[c.component] || 0) + 1;
const comps = Object.keys(compCount).filter(k => compCount[k] >= 5 && /^[A-Z]/.test(k)).sort((x, y) => y.length - x.length);
const compRe = new RegExp('\\b(' + comps.map(c => c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|') + ')\\b', 'g');
const EV = ['onClick', 'onChange', 'onSearch', 'onKeyDown', 'onBlur', 'onClose', 'onSelect', 'formatItem', 'cellEditEnded', 'cellEditEnding', 'beginningEdit', 'dblclick', 'dblClick', 'click', 'selectionChanged', 'pastingCell', 'pastedCell', 'updatedLayout', 'scrollPositionChanged', 'loadedRows', 'itemsSourceChanged', 'useEffect', 'useCascadeFields', 'refetch', 'hotkeyConfig', 'customButtons', 'SubTitle', 'addHandler', 'keyDown', 'rowEditEnded', 'filterApplied'];
const evRe = new RegExp('\\b(' + EV.join('|') + ')\\b', 'g');
const uniq = xs => [...new Set(xs)];

const ctrlAgg = {}, evAgg = {}, gapAgg = {}, pairs = new Set();
for (const r of map) {
  pairs.add(r.menu_id);
  const m = r.summary.match(/^§(\d)\s+(\S+)\s*\/\s*(.+)$/); if (!m) continue;
  const sec = m[1], name = m[2], type = m[3].trim();
  const st = r.status.split(/[\s(]/)[0];
  if (sec === '1') {
    if (st === '구현') { for (const c of uniq(r.impl_location.match(compRe) || ['(미식별)'])) { const k = type + '|' + c; ctrlAgg[k] = ctrlAgg[k] || { asis_type: type, tobe_component: c, count: 0, examples: [] }; ctrlAgg[k].count++; if (ctrlAgg[k].examples.length < 3) ctrlAgg[k].examples.push(`${r.menu_id}:${name}`); } }
    else { const reason = r.reason.replace(/\s+/g, ' ').trim(); const key = type + '|' + st; gapAgg[key] = gapAgg[key] || { asis_type: type, status: st, count: 0, reasons: {} , examples: [] }; gapAgg[key].count++; gapAgg[key].reasons[reason.slice(0, 80)] = (gapAgg[key].reasons[reason.slice(0, 80)] || 0) + 1; if (gapAgg[key].examples.length < 3) gapAgg[key].examples.push(`${r.menu_id}:${name}`); }
  } else if (sec === '2') {
    const ctlType = name.replace(/^(btn|cbo|clb|chk|txt|drp|spd|lbl|grd|rdo|dt|num)/, m0 => m0.toUpperCase());
    const prefix = (name.match(/^[a-z]+/) || [''])[0];
    const k = prefix + '|' + type + '|' + st;
    evAgg[k] = evAgg[k] || { asis_prefix: prefix, asis_event: type, status: st, count: 0, tobe_patterns: {}, examples: [] };
    evAgg[k].count++; if (evAgg[k].examples.length < 3) evAgg[k].examples.push(`${r.menu_id}:${name}`);
    for (const p of uniq(r.impl_location.match(evRe) || (st === '구현' ? ['(미식별)'] : []))) evAgg[k].tobe_patterns[p] = (evAgg[k].tobe_patterns[p] || 0) + 1;
    void ctlType;
  }
}
const top = o => Object.entries(o).sort((x, y) => y[1] - x[1]).map(([k, v]) => `${k}(${v})`).join(' ');
let w = new CsvOut(path.join(out, 'map_control.mined.csv'), ['asis_type', 'tobe_component', 'count', 'share', 'examples']);
const byType = {}; for (const v of Object.values(ctrlAgg)) byType[v.asis_type] = (byType[v.asis_type] || 0) + v.count;
for (const v of Object.values(ctrlAgg).sort((x, y) => x.asis_type.localeCompare(y.asis_type) || y.count - x.count)) w.row({ asis_type: v.asis_type, tobe_component: v.tobe_component, count: v.count, share: (v.count / byType[v.asis_type] * 100).toFixed(0) + '%', examples: v.examples.join(' ') });
w.close();
w = new CsvOut(path.join(out, 'map_event.mined.csv'), ['asis_prefix', 'asis_event', 'status', 'count', 'tobe_patterns', 'examples']);
for (const v of Object.values(evAgg).sort((x, y) => y.count - x.count)) w.row({ asis_prefix: v.asis_prefix, asis_event: v.asis_event, status: v.status, count: v.count, tobe_patterns: top(v.tobe_patterns), examples: v.examples.join(' ') });
w.close();
w = new CsvOut(path.join(out, 'allowed_gaps.mined.csv'), ['asis_type', 'status', 'count', 'top_reasons', 'examples']);
for (const v of Object.values(gapAgg).sort((x, y) => y.count - x.count)) w.row({ asis_type: v.asis_type, status: v.status, count: v.count, top_reasons: top(v.reasons), examples: v.examples.join(' ') });
w.close();
// 짝 화면 목록 (As-is Pack 있음 + To-Be 페이지 있음)
const asisIdx = readCsv(path.join(asis, 'screens', '_index.csv')).map(r => r.screen_id);
const tobeIdx = readCsv(path.join(tobe, 'screens', '_index.csv')).filter(r => r.menu_id);
w = new CsvOut(path.join(out, 'pairs.csv'), ['menu_id', 'page_key', 'has_asis', 'has_mapping_md']);
for (const r of tobeIdx) w.row({ menu_id: r.menu_id, page_key: r.page_key, has_asis: asisIdx.includes(r.menu_id) ? 'Y' : 'N', has_mapping_md: pairs.has(r.menu_id) ? 'Y' : 'N' });
w.close();
console.log(`mapping rows ${map.length}, control pairs ${Object.keys(ctrlAgg).length}, event keys ${Object.keys(evAgg).length}, gap keys ${Object.keys(gapAgg).length}, pages with mapping ${pairs.size}`);
