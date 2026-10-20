#!/usr/bin/env node
'use strict';
// TobeGen — As-is Fact Pack(Doc/asisfacts/screens/<ID>) + 매핑 사전(rules/) → To-Be 화면 골격 생성기 (결정론적, LLM 없음)
//   node gen.js <화면ID> [--feature demand] [--page edi-summary] [--apply [--overwrite]] [--config harness.json]   (--overwrite: 작업 흔적 없는 골격만 재적용)
//   산출: Doc/gen/<ID>/features/<feature>/src/pages/<page>/... + register.json + GEN_NOTES.md + __asis-mapping__.md
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../TobeFacts/src/util');
const T = require('./templates');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
let ID = (a.find(x => !x.startsWith('--') && a[a.indexOf(x) - 1] !== '--feature' && a[a.indexOf(x) - 1] !== '--page' && a[a.indexOf(x) - 1] !== '--config') || '').toUpperCase();
if (!ID) { console.error('화면ID 를 지정하세요'); process.exit(2); }
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules');
const rules = {
  control: readCsv(path.join(R, 'map_control.csv')), field: readCsv(path.join(R, 'map_field.csv')), button: readCsv(path.join(R, 'map_button.csv')), event: readCsv(path.join(R, 'map_event.csv')),
  domain: readCsv(path.join(R, 'map_domain.csv')), gaps: readCsv(path.join(R, 'allowed_gaps.csv'))
};
// As-is ID ≠ To-Be MENU_ID 인 화면(rules/map_screen.csv): 어느 쪽 ID 로 불러도 ID=To-Be MENU_ID, AID=As-is Fact Pack 폴더
const mapScreenF = path.join(R, 'map_screen.csv'); const mapScreen = fs.existsSync(mapScreenF) ? readCsv(mapScreenF) : [];
let AID = ID; { const byA = mapScreen.find(r => r.asis_id.toUpperCase() === ID), byT = mapScreen.find(r => r.tobe_id.toUpperCase() === ID); if (byA && byA.tobe_id) ID = byA.tobe_id.toUpperCase(); else if (byT) AID = byT.asis_id.toUpperCase(); }
if (AID !== ID) console.log(`화면 짝: As-is ${AID} → To-Be ${ID} (map_screen.csv)`);
const sdir = path.join(cfg.asisOutDir, 'screens', AID);
if (!fs.existsSync(sdir)) { console.error(`As-is Fact Pack 없음: ${sdir}`); process.exit(2); }
const P = n => readCsv(path.join(sdir, n));
const cur = rows => rows.filter(r => r.variant !== 'legacy');
const controls = cur(P('controls.csv')), events = cur(P('events.csv')), endpoints = cur(P('endpoints.csv')), flow = cur(P('flow.csv')), grid = P('grid_effective.csv');
// As-is 공통 버튼(BaseForm override) — members.csv(메서드 목록) 우선, 없으면 flow.csv 의 button 진입점. 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시 의무
const members = fs.existsSync(path.join(sdir, 'members.csv')) ? cur(P('members.csv')) : [];
const commonButtons = (() => {
  const names = ['FindButton', 'InsertButton', 'DeleteButton', 'SaveButton', 'EditButton', 'ExcelButton', 'UploadButton', 'ImportButton', 'PrintButton', 'CopyButton', 'NewButton'];
  const out = {};
  for (const n of names) {
    const m = members.find(r => r.member === n && /override/.test(r.modifiers || '') && r.kind === 'Method');
    const byFlow = flow.some(f => f.entry_kind === 'button' && f.entry === n);
    if (m) out[n] = { src: 'members', line: Number(m.line), lines: Number(m.lines), file: m.file, hasBody: Number(m.lines) > 3 }; else if (byFlow) out[n] = { src: 'flow', hasBody: true };
  }
  return out;
})();
const hasConditionPanel = controls.some(c => /UsrConditionPanel/i.test(c.type));

const idx = readCsv(path.join(cfg.asisOutDir, 'screens', '_index.csv')).find(r => r.screen_id === AID) || {};
const agentDir = path.join(cfg.asisOutDir, 'agent', AID);

// ── 이름 규칙 ──
const classes = [...new Set(controls.map(c => c.class))];
const mainClass = classes.find(c => c.startsWith(ID + '_') && !/popup/i.test(c)) || classes[0] || ID;
const popupClasses = classes.filter(c => c !== mainClass);
const asisName = mainClass.replace(new RegExp('^' + ID + '_'), '') || ID;
// To-Be 메뉴 메타(Doc/tobefacts/db/menu.csv — export_tobe_meta.py)가 있으면 그것이 정본: 페이지 폴더 = MNU_URL, feature = ROUTE_PATH 첫 세그먼트(없으면 상위 메뉴 체인 최상위)
const menuMeta = (() => { const f = path.join(cfg.tobeOutDir || '', 'db', 'menu.csv'); if (!cfg.tobeOutDir || !fs.existsSync(f)) return null; const rows = readCsv(f); const me = rows.find(r => (r.mnu_id || '').toUpperCase() === ID); if (!me) return null;
  let top = me, guard = 0; while (top.uppr_mnu_id && guard++ < 6) { const up = rows.find(r => r.mnu_id === top.uppr_mnu_id); if (!up) break; top = up; }
  const routeTop = (me.route_path || '').split('/').filter(Boolean)[0]; const feature = routeTop || (top.mnu_url || top.mnu_id || '').toLowerCase().replace(/[^a-z0-9]+/g, '-');
  return { me, feature, pageDir: (me.mnu_url || '').split('/').filter(Boolean).pop() || null, parent: me.uppr_mnu_id, useYn: me.use_yn, title: me.mnu_desc, msgId: me.mnu_msg_id }; })();
if (menuMeta) console.log(`To-Be 메뉴 메타: ${ID} → feature=${menuMeta.feature} pageDir=${menuMeta.pageDir} 상위=${menuMeta.parent} USE_YN=${menuMeta.useYn} (${menuMeta.title})`);
const kebab = opt('--page') || (menuMeta && menuMeta.pageDir) || asisName.replace(/([A-Z]+)([A-Z][a-z])/g, '$1-$2').replace(/([a-z0-9])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase().replace(/^(\d+-)+/, '').replace(/-+/g, '-');
const Page = kebab.split('-').map(s => s[0].toUpperCase() + s.slice(1)).join('');
const prefix = (ID.match(/^[A-Z]+/) || [''])[0];
const feature = opt('--feature') || (menuMeta && menuMeta.feature) || (rules.domain.find(d => d.prefix === prefix) || {}).feature || 'misc';
const label = n => n.replace(/^(btn|cbo|clb|chk|txt|drp|spd|lbl|grd|rgrp|rdo|dt|num|mrp|usr|d)([A-Z])/, '$2').replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2').replace(/([a-z0-9])([A-Z])/g, '$1 $2').replace(/_/g, ' ').trim() || n;
const camel = n => { const toks = label(n).split(/\s+/).map(t => /^[A-Z0-9]+$/.test(t) ? t.toLowerCase() : t); return toks.map((t, i) => i === 0 ? t[0].toLowerCase() + t.slice(1) : t[0].toUpperCase() + t.slice(1)).join(''); };
const pascal = s => s.split(/\s+/).map(t => /^[A-Z0-9]+$/.test(t) ? t[0] + t.slice(1).toLowerCase() : t[0].toUpperCase() + t.slice(1)).join('');
const upperSnake = s => s.replace(/[^A-Za-z0-9]+/g, '_').replace(/^_|_$/g, '').toUpperCase() || 'MAIN';
const typeOf = c => c.type.split('.').pop();
const ruleOf = c => rules.control.find(r => r.asis_type === typeOf(c)) || { tobe_component: '(unknown)', gen: 'todo', slot: 'custom', note: '사전에 없는 타입 — map_control.csv 에 추가' };
const gapFor = (kind, v) => rules.gaps.find(g => g.kind === kind && new RegExp(g.pattern, 'i').test(v));

// ── 0) 디자이너 속성(props.csv) · 라벨 코드 사전(rules/lbl_codes.csv) ──
const props = fs.existsSync(path.join(sdir, 'props.csv')) ? P('props.csv').filter(r => r.variant !== 'legacy') : [];
const propOf = (target, prop) => { const r = props.find(x => x.target.replace(/^this\./, '') === target && x.prop === prop); return r ? r.value : ''; };
const unq = v => (v || '').replace(/^"+|"+$/g, '').replace(/^""|""$/g, '');
const labelItems = props.filter(r => r.prop === 'Control').map(r => ({ item: r.target.replace(/^this\./, ''), ctl: r.value.replace(/^this\./, '') }));
const designerLabel = name => { const li = labelItems.find(x => x.ctl === name); const t = li ? unq(propOf(li.item, 'Text')) : ''; if (t && !/^(layoutControlItem|lci)\d*/i.test(t) && t !== li.item) return t; const own = unq(propOf(name, 'Text')); return own && own !== name ? own : ''; };
const lblCodes = fs.existsSync(path.join(R, 'lbl_codes.csv')) ? readCsv(path.join(R, 'lbl_codes.csv')) : [];
const normT = x => (x || '').toLowerCase().replace(/[^\p{L}\p{N}]/gu, '');
const lblByText = new Map(); for (const r of lblCodes.filter(r => r.code.startsWith('LBL'))) { const k = normT(r.text); if (k && (!lblByText.has(k) || Number(lblByText.get(k).count) < Number(r.count))) lblByText.set(k, r); }
// 선택 입력: 클라우드 메시지 마스터(Doc/tobefacts/db/msg_master.csv) — 코드/문구 컬럼은 이름으로 추정
const msgMaster = (() => { const f = path.join(cfg.tobeOutDir || '', 'db', 'msg_master.csv'); if (!cfg.tobeOutDir || !fs.existsSync(f)) return []; const rows = readCsv(f); if (!rows.length) return []; const cols = Object.keys(rows[0]); const codeCol = cols.find(c => /^(MSG_ID|MSG_CD|CODE|MESSAGE_ID|msg_id|msg_cd|code)$/i.test(c)) || cols[0]; const textCols = cols.filter(c => /(EN|ENG|KO|KOR|TXT|TEXT|CTN|NM|NAME|MSG)/i.test(c) && c !== codeCol); return rows.flatMap(r => textCols.map(tc => ({ code: r[codeCol], text: r[tc] })).filter(x => x.code && x.text && /^LBL/.test(x.code))); })();
for (const m of msgMaster) { const k = normT(m.text); if (k && !lblByText.has(k)) lblByText.set(k, { code: m.code, count: '0' }); }
const lblFor = text => { const k = normT(text); if (!k) return ''; if (lblByText.has(k)) return lblByText.get(k).code; const k2 = k.replace(/(id|code|name|no)$/,''); for (const [kk, r] of lblByText) if (kk === k2 || kk.replace(/(id|code|name|no)$/,'') === k) return r.code; return ''; };

// ── 1) 조회조건 필드 / 버튼 ──
const mainCtl = controls.filter(c => c.class === mainClass).sort((x, y) => Number(x.line) - Number(y.line));
const fields = [], buttons = [], grids = [], skipped = [], todos = [];
for (const c of mainCtl) {
  const r = ruleOf(c), t = typeOf(c);
  if (r.gen === 'skip') { skipped.push({ c, reason: (gapFor('control_type', t) || {}).reason || r.note }); continue; }
  if (r.gen === 'field') { const m = rules.field.find(f => new RegExp(f.name_pattern).test(c.name)); const cat = m && m.field ? m : null; const dl = designerLabel(c.name); const lb = dl || label(c.name); fields.push({ c, r, cat, comboId: m ? m.combo_id : '', lbl: (m && m.lbl) || lblFor(lb) || '', kindHint: m ? m.kind : '', key: m ? m.param_key : camel(c.name), label: lb, labelSrc: dl ? 'designer' : 'name' }); }
  else if (r.gen === 'button') { const b = rules.button.find(b => new RegExp(b.name_pattern).test(c.name)); const dl = designerLabel(c.name); buttons.push({ c, r, b, key: camel(c.name), label: dl || label(c.name), lbl: lblFor(dl || label(c.name)) }); }
  else if (r.gen === 'grid') grids.push({ c, r });
  else if (r.gen === 'container') { /* SearchArea 등 — 템플릿이 항상 포함 */ }
  else todos.push({ c, r });
}
// 팝업 버튼 + 짝 텍스트필드 → 팝업 필드 승격
for (const b of buttons.filter(b => b.b && b.b.kind === 'field-popup')) {
  const suffix = b.c.name.replace(/^btn/, '');
  const f = fields.find(f => new RegExp('^(txt|usr)' + suffix + '$', 'i').test(f.c.name) || f.c.name.toLowerCase() === 'txt' + suffix.toLowerCase());
  if (f) { f.popup = b; b.merged = f; if (f.cat && f.cat.kind === 'popup') b.absorbed = true; }
}
// ── 2) 시트 ──
const sheetRows = {}; for (const g of grid) (sheetRows[g.sheet] = sheetRows[g.sheet] || []).push(g);
const sheets = Object.keys(sheetRows).filter(s => s !== '(시트 미상)').map(s => ({ name: s, key: upperSnake(s), rule: sheetRows[s][0].sheet_rule, rows: sheetRows[s], popup: /popup/i.test(s), used: !/미참조/.test(sheetRows[s][0].sheet_rule || '') }));  // used=false: 메타 정의만 있고 As-is 코드가 참조하지 않는 시트(등록·배선 생략)
const mainSheets = sheets.filter(s => !s.popup); const popupSheets = sheets.filter(s => s.popup);
if (!mainSheets.length) mainSheets.push({ name: 'main', key: 'MAIN', rule: '(시트 미상 — 메타 확인)', rows: [], popup: false });
const divisionCols = grid.length ? Object.keys(grid[0]).filter(k => !['sheet', 'sheet_rule', 'column', 'label', 'source'].includes(k)) : [];
// 동적 헤더(타이틀) SP — 2026-10-20 SCP0096 보강: 기존 `_SPREAD_TITLE` 정규식 1개라 GetSpdTitle → *_GET_SHEET_CALENDAR_3SPAN(기간 3단 헤더)을
//   놓쳐 SHEETS 에 타이틀 시트가 안 생기고 GEN_NOTES TODO 에도 안 떴다 → 후속 수작업이 BE 에 없는 응답 키(o_rc1_columns)로 컬럼을 파생.
//   판정은 lib/dyncol(check.js B27 · gap.js 와 동일): SP 이름 계열 + 호출 메서드(GetSpdTitle…) + grid_code DB루프. 메타형(SHEET_COLUMNS 만 읽는 공통 타이틀)은 admin 컬럼 메타로 대체.
const DY = require('./lib/dyncol');
const titleEps = DY.asisTitleEndpoints(endpoints).filter(t => t.kind === 'period'); const titleLoops = DY.asisDbLoop(sdir);
const corpMeta = (() => { const f = cfg.tobeOutDir && path.join(cfg.tobeOutDir, 'db', 'proc_meta.csv'); return f && fs.existsSync(f) ? readCsv(f).filter(r => r.menu_id === ID && r.use_yn !== 'N' && r.proc) : []; })();
// 시트명: ①사내 정확 배선 시트(예: SCP0096 'calendar') ②같은 화면 타이틀 계열 사내 시트(예: SCP0016 3SPAN_ISO → 'spreadTitle')
//         ③배선 없음 → 3SPAN/CALENDAR 계열 'calendar' · 그 외 'spreadTitle'(기존 관례)
const corpFamily = DY.corpAllTitleSheets(corpMeta);
const titleSheetsAll = titleEps.map(t => { const c = DY.corpTitleSheets(t.sp, corpMeta); const name = c.via === 'exact' ? c.sheets[0] : corpFamily.length ? corpFamily[0] : (/CALENDAR/i.test(t.sp) ? 'calendar' : 'spreadTitle'); return { sp: t.sp, members: t.members, name, key: name.replace(/([a-z])([A-Z])/g, '$1_$2').replace(/[^A-Za-z0-9]+/g, '_').toUpperCase(), corpProc: c.via === 'exact' ? c.procs[0] : '', via: c.via === 'exact' ? 'exact' : corpFamily.length ? 'family' : 'none' }; });
// SHEETS enum 용(시트명 중복 제거) — SP→시트 배정(btnCdOf)은 titleSheetsAll 로 전부 수행
const titleSheets = titleSheetsAll.filter((t, i, arr) => arr.findIndex(x => x.name === t.name) === i).map(t => ({ ...t, sp: titleSheetsAll.filter(x => x.name === t.name).map(x => x.sp).join(' / '), members: [...new Set(titleSheetsAll.filter(x => x.name === t.name).flatMap(x => x.members))], corpProc: titleSheetsAll.filter(x => x.name === t.name).map(x => x.corpProc).find(Boolean) || '' }));
const hasSpreadTitle = titleSheets.length > 0 || endpoints.some(e => /_SPREAD_TITLE/i.test(e.sp_or_sql || e.key));
// ── 3) 엔드포인트 → register ──
const eps = {}; for (const e of endpoints) { const k = e.key || e.candidate; if (!k) continue; eps[k] = eps[k] || { key: k, sp: (e.sp_or_sql || '').replace(/^SP\s+/, ''), status: e.status, members: new Set(), entries: new Set() }; eps[k].members.add(e.member); }
for (const f of flow) { if (eps[f.endpoint]) eps[f.endpoint].entries.add(`${f.entry_kind}:${f.entry}`); }
const btnCdOf = (ep) => {
  const en = [...ep.entries].join(' ');
  const sp = ep.sp.toUpperCase();
  { const ts = titleSheetsAll.find(t => t.sp.toUpperCase() === sp); if (ts) return { sheet: ts.name, btn: 'SEARCH' }; }
  if (/_SPREAD_TITLE/.test(sp)) return { sheet: 'spreadTitle', btn: 'SEARCH' };
  if (/UP_FX_GETCOMMONDATALIST|_GET_(COMMON|CODE|COMBO)/.test(sp)) return { sheet: '(combo)', btn: '(콤보ID 등록)' };
  if (/_(SAVE|SET|UPD|UPDATE|INS|INSERT|DEL|DELETE|MERGE)_/.test(sp)) return { sheet: mainSheets[0].name, btn: 'SAVE' };
  if (/FindButton|btnSearch|btnFind|Load/.test(en) && /_GET_/.test(sp)) { const m = sp.match(/_GET_(.+)$/); const tail = m ? m[1] : 'DATA'; return { sheet: mainSheets.length === 1 ? mainSheets[0].name : guessSheet(tail), btn: 'SEARCH' }; }
  const m = sp.match(/_GET_(.+)$/); return { sheet: guessSheet(m ? m[1] : ''), btn: m ? m[1] : 'ACTION' };
};
function guessSheet(tail) { const t = tail.replace(/_/g, ' ').toLowerCase(); const pool = [...mainSheets, ...popupSheets]; const usedPool = pool.filter(s => s.used); if (/popup/.test(t) && usedPool.some(s => s.popup)) return usedPool.find(s => s.popup).name; const hit = [...usedPool, ...pool.filter(s => !s.used)].find(s => s.name.toLowerCase().includes(t.split(' ')[0]) || t.includes(s.name.toLowerCase().split(' ')[0])); return hit ? hit.name : mainSheets[0].name; }
const procs = Object.values(eps).map(ep => { const g = gapFor('endpoint', ep.sp); const b = btnCdOf(ep); return Object.assign({ asis_endpoint: ep.key, asis_sp: ep.sp, status: ep.status, entries: [...ep.entries], methods: [...ep.members], tobe_pkg_candidate: `PKG_${ID}.P_${ep.sp.toUpperCase()}` }, b, g ? { allowed_gap: g.reason } : {}); });
// ── 4) 이벤트 → 핸들러 스텁 ──
const evMap = e => rules.event.find(r => new RegExp(r.asis_target_pattern, 'i').test(e.target.replace(/^this\./, '')) && new RegExp('^(' + r.asis_event + ')$', 'i').test(e.event));
const handlers = events.filter(e => e.class === mainClass && e.op === '+=' && e.handler !== '<lambda>' && /^[A-Z]/.test(e.event)).map(e => {
  const r = evMap(e) || { tobe_slot: 'handler', tobe_pattern: '(사전 없음 — map_event.csv 추가)' };
  const calls = [...new Set(flow.filter(f => f.path.split(' > ')[0] === e.handler).map(f => f.endpoint))];
  return { e, r, calls, name: 'handle' + e.handler.replace(/^(btn|Btn|spd|cbo|clb|chk)/, '').replace(/_?(Click|Changed|CheckedChanged|SelectedIndexChanged|CellDoubleClick|Load)$/, '').replace(/[^A-Za-z0-9]/g, '') || 'handle' + e.handler };
});
// ── 5) 단위테스트 초안 (Agent unit_test.md) ──
const tcs = []; const ut = path.join(agentDir, 'unit_test.md');
if (fs.existsSync(ut)) for (const line of fs.readFileSync(ut, 'utf8').split(/\r?\n/)) { const m = line.match(/^\|\s*(TC-[A-Z0-9-]+)\s*\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|/); if (m) tcs.push({ id: m[1], kind: m[2].trim(), pre: m[3].trim(), step: m[4].trim(), input: m[5].trim(), expect: m[6].trim(), basis: m[7].trim() }); }

// ── 스프레드 ↔ 시트 배정 (스프레드 이름 토큰과 시트명 토큰의 겹침으로 1:1, 남는 시트는 미배정 스프레드에 activeSheet 로) ──
const tok = x => x.toLowerCase().replace(/^spd|^grd|^spread/, '').replace(/_?sheet\d*$/i, '').split(/[^a-z0-9]+|(?<=[a-z])(?=[A-Z])/).filter(Boolean);
if (!grids.length) grids.push({ c: { name: 'spdMain', type: '(virtual)FpSpread', file: '', line: '0' }, r: {}, virtual: true }); // 스프레드 컨트롤이 디자이너에 없는 화면(동적 생성) — 기본 그리드 1개
const gridPlan = grids.map((g, i) => ({ ctl: g.c, name: g.c.name, suffix: grids.length === 1 ? '' : pascal(label(g.c.name.replace(/^spd/, '')) || 'Grid' + (i + 1)), sheets: [], events: [] }));
const freeSheets = mainSheets.slice();
for (const gp of gridPlan) {
  const t = new Set(tok(gp.name)); let best = null, score = 0;
  for (const sh of freeSheets) { const u = tok(sh.name); const sc = u.filter(x => t.has(x) || [...t].some(y => y.includes(x) || x.includes(y))).length; if (sc > score) { score = sc; best = sh; } }
  if (best && score > 0) { gp.sheets.push(best); freeSheets.splice(freeSheets.indexOf(best), 1); }
}
if (freeSheets.length) { const tgt = gridPlan.find(g => !g.sheets.length) || gridPlan[gridPlan.length - 1]; if (tgt) tgt.sheets.push(...freeSheets.splice(0)); }
for (const gp of gridPlan) if (!gp.sheets.length) gp.sheets.push(mainSheets[0]);
// ── 레이아웃 트리: SplitContainer(parent 체인) → PanelGroup 중첩. Orientation.Horizontal(상/하) → vertical, Vertical(좌/우) → horizontal ──
const ctlByName = new Map(mainCtl.map(c => [c.name, c]));
const childrenOf = parent => mainCtl.filter(c => c.parent === parent);
const sizeOf = name => { const m = unq(propOf(name, 'Size')).match(/Size\((\d+),\s*(\d+)\)/); return m ? { w: Number(m[1]), h: Number(m[2]) } : null; };
function layoutNode(name) {
  const c = ctlByName.get(name); if (!c) return null;
  const t = typeOf(c);
  if (t === 'SplitContainer') {
    const horiz = /Horizontal/.test(propOf(name, 'Orientation')); // WinForms Horizontal = 위/아래 분할
    const dist = Number(propOf(name, 'SplitterDistance')) || 0, sz = sizeOf(name);
    const total = sz ? (horiz ? sz.h : sz.w) : 0; let pct = total && dist ? Math.round(dist / total * 100) : 50; pct = Math.min(85, Math.max(15, pct));
    const p1 = childrenOf(name + '.Panel1').map(x => layoutNode(x.name)).filter(Boolean), p2 = childrenOf(name + '.Panel2').map(x => layoutNode(x.name)).filter(Boolean);
    const collapsed1 = /true/i.test(propOf(name, 'Panel1Collapsed')), collapsed2 = /true/i.test(propOf(name, 'Panel2Collapsed'));
    const kids = [];
    if (p1.length && !collapsed1) kids.push({ size: pct, nodes: p1 });
    if (p2.length && !collapsed2) kids.push({ size: 100 - pct, nodes: p2 });
    if (!kids.length) return null; if (kids.length === 1) return kids[0].nodes.length === 1 ? kids[0].nodes[0] : { kind: 'group', orientation: horiz ? 'vertical' : 'horizontal', name, panels: kids };
    return { kind: 'group', orientation: horiz ? 'vertical' : 'horizontal', name, panels: kids };
  }
  if (t === 'FpSpread') { const gp = gridPlan.find(g => g.name === name); return gp ? { kind: 'grid', plan: gp } : null; }
  if (/TabControl/.test(t)) { const pages = childrenOf(name).map(x => layoutNode(x.name)).filter(Boolean); return pages.length ? { kind: 'tabs', name, pages } : null; }
  if (/Panel|TabPage|GroupBox|UsrLayoutControl|SplitContainer|TableLayoutPanel|FlowLayoutPanel/.test(t) && !/UsrConditionPanel/.test(t)) { const inner = childrenOf(name).map(x => layoutNode(x.name)).filter(Boolean); return inner.length === 1 ? inner[0] : inner.length ? { kind: 'stack', name, nodes: inner } : null; }
  return null;
}
const roots = childrenOf('this').map(c => layoutNode(c.name)).filter(Boolean);
const placed = new Set(); (function mark(n) { if (!n) return; if (n.kind === 'grid') placed.add(n.plan.name); (n.panels || []).forEach(p => p.nodes.forEach(mark)); (n.nodes || n.pages || []).forEach(mark); })({ kind: 'stack', nodes: roots });
const layout = { roots, unplaced: gridPlan.filter(g => !placed.has(g.name)) };
// 주 시트 = 조회 버튼(FindButton/btnSearch) 첫 SEARCH 엔드포인트의 시트
const primary = procs.find(p => p.btn === 'SEARCH' && p.sheet !== 'spreadTitle' && p.entries.some(e => /FindButton|btnSearch|btnFind|Load/.test(e)));
if (primary) { const i = mainSheets.findIndex(s => s.name === primary.sheet); if (i > 0) mainSheets.unshift(mainSheets.splice(i, 1)[0]); }
for (const b of buttons) b.modalName = b.b && b.b.modal && !b.absorbed ? pascal(b.merged ? b.merged.label : b.label) : '';
const AN = require('./lib/analysis');
const validations = AN.load(cfg.analysisRoot, AID, 'V'), expressions = AN.load(cfg.analysisRoot, AID, 'E');
for (const h of handlers) { const tgt = h.e.target.replace(/^this\./, '').split('.')[0]; const gp = gridPlan.find(g => g.name === tgt); if (gp) gp.events.push(h); }
if (gridPlan.length === 1) { for (const h of handlers) if (h.r.tobe_slot === 'grid-event' && !gridPlan[0].events.includes(h)) gridPlan[0].events.push(h); }
const ctx = { controlsAll: controls, eventsAll: events, endpointsAll: endpoints, menuMeta, commonButtons, hasConditionPanel, members, pascal, ID, Page, validations, expressions, gridPlan, layout, props, kebab, feature, asisName, mainClass, popupClasses, fields, buttons, grids, skipped, todos, sheets, mainSheets, popupSheets, divisionCols, hasSpreadTitle, titleSheets, titleLoops, procs, handlers, tcs, idx, rules, label };
const outRoot = path.join(cfg.genOutDir, ID);
const pageRel = path.join('features', feature, 'src', 'pages', kebab);
const files = T.render(ctx);
fs.rmSync(outRoot, { recursive: true, force: true });
for (const [rel, body] of Object.entries(files)) { const p = path.join(outRoot, rel.startsWith('@') ? rel.slice(1) : path.join(pageRel, rel)); fs.mkdirSync(path.dirname(p), { recursive: true }); fs.writeFileSync(p, body, 'utf8'); }
console.log(`${ID} → ${outRoot}  (${Object.keys(files).length} files)  page=${pageRel}  fields=${fields.length} buttons=${buttons.length} sheets=${mainSheets.length}+${popupSheets.length}popup procs=${procs.length} handlers=${handlers.length} tcs=${tcs.length} V=${validations.length} E=${expressions.length}`);
if (a.includes('--apply')) {
  const target = path.join(cfg.feRoot, pageRel);
  if (fs.existsSync(target)) {
    // --overwrite: 골격 재적용(생성기 수정 후). Claude/사람이 손댄 흔적(REPAIR.md 또는 매핑표 '구현' 행)이 있으면 거부 — 작업물 보호
    const why = require('./lib/applied').touchReason(target, path.join(cfg.genOutDir, ID));
    if (!a.includes('--overwrite')) { console.error(`이미 존재: ${target} — 적용하지 않음(수동 병합). 골격만 있는 상태면 --overwrite 로 재적용`); process.exit(3); }
    if (why && !a.includes('--force')) { console.error(`작업 흔적 있음(${why}): ${target} — --overwrite 거부. 정말 교체하려면 사람이 --force 를 명시(Doc/gen/${ID}/_backup/ 에 백업 후 교체)`); process.exit(3); }
    const bak = path.join(cfg.genOutDir, ID, '_backup', new Date().toISOString().replace(/[:.]/g, '-')); fs.mkdirSync(bak, { recursive: true }); fs.cpSync(target, bak, { recursive: true }); console.log(`기존 페이지 백업: ${bak}`);
    fs.rmSync(target, { recursive: true, force: true }); console.log(`기존 골격 제거 후 재적용: ${target}${why ? '  (--force: ' + why + ')' : ''}`);
  }
  fs.cpSync(path.join(outRoot, pageRel), target, { recursive: true });
  require('./lib/applied').writeManifest(target, path.join(cfg.genOutDir, ID)); // 적용 시점 파일 해시 — 이후 변경(Claude/사람 작업) 감지용
  console.log(`적용: ${target}`);
}
