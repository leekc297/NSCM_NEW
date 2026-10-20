#!/usr/bin/env node
'use strict';
// GapCheck — As-is Fact(Doc/asisfacts) vs To-Be Fact(Doc/tobefacts) 를 화면(MENU_ID)별로 대사해 3분류한다.
//   node gap.js [ID ...] [--config harness.json]        (ID 없으면 짝지어진 전 화면)
//   분류: COVERED(To-Be 에 대응 근거 있음) / INTENDED(allowed_gaps 또는 매핑표 제외·해당없음) / MISSING(대응 없음) / UNMAPPED(매핑표 없어 판단 불가·근거만)
//   산출: Doc/gap/<ID>_gap.csv, Doc/gap/_summary.csv, Doc/gap/_summary.md
const fs = require('fs'); const path = require('path');
const { readCsv, CsvOut } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules');
const gapDir = cfg.gapDir || path.join(path.dirname(cfg.genOutDir), 'gap'); fs.mkdirSync(gapDir, { recursive: true });
const gaps = readCsv(path.join(R, 'allowed_gaps.csv')), mapCtl = readCsv(path.join(R, 'map_control.csv'));
const allowed = (kind, v) => { const g = gaps.find(g => g.kind === kind && new RegExp(g.pattern, 'i').test(v)); return g ? g.reason : null; };
const DY = require('./lib/dyncol');
const T = { idx: readCsv(path.join(cfg.tobeOutDir, 'screens', '_index.csv')), ep: readCsv(path.join(cfg.tobeOutDir, 'endpoints.csv')), ev: readCsv(path.join(cfg.tobeOutDir, 'events.csv')), ctl: readCsv(path.join(cfg.tobeOutDir, 'controls.csv')), refs: readCsv(path.join(cfg.tobeOutDir, 'asis_refs.csv')), map: readCsv(path.join(cfg.tobeOutDir, 'asis_mapping.csv')), consts: readCsv(path.join(cfg.tobeOutDir, 'constants.csv')), gc: readCsv(path.join(cfg.tobeOutDir, 'grid_columns.csv')), dts: readCsv(path.join(cfg.tobeOutDir, 'procedures_dts.csv')) };
// 선택 입력: 클라우드에서 내려받은 To-Be SP 등록 메타 (PR_GET_PROCEDURES_METADATA → CSV: menu_id,sheet,btn,pkg,proc)
const procMetaFile = path.join(cfg.tobeOutDir, 'db', 'proc_meta.csv');
const procMeta = fs.existsSync(procMetaFile) ? readCsv(procMetaFile) : [];
if (procMeta.length) console.log(`SP 등록 메타 ${procMeta.length}행 반영 (${procMetaFile})`);
const sheetColsFile = path.join(cfg.tobeOutDir, 'db', 'sheet_columns.csv');
const sheetCols = fs.existsSync(sheetColsFile) ? readCsv(sheetColsFile) : [];
if (sheetCols.length) console.log(`시트 컬럼 메타 ${sheetCols.length}행 반영`);
const ids = a.filter(x => !x.startsWith('--') && a[a.indexOf(x) - 1] !== '--config').map(x => x.toUpperCase());
// As-is ID ≠ To-Be MENU_ID 짝(rules/map_screen.csv: SCM0008→SYS0011 등). 없으면 같은 ID.
const mapScreenF = path.join(R, 'map_screen.csv'); const t2a = new Map(fs.existsSync(mapScreenF) ? readCsv(mapScreenF).map(r => [r.tobe_id.toUpperCase(), r.asis_id.toUpperCase()]) : []);
const asisIdOf = menu => { const a = t2a.get(menu.toUpperCase()); return a && fs.existsSync(path.join(cfg.asisOutDir, 'screens', a)) ? a : menu; };
const targets = T.idx.filter(r => r.menu_id && !/\/components\//.test(r.page_key) && fs.existsSync(path.join(cfg.asisOutDir, 'screens', asisIdOf(r.menu_id))) && (!ids.length || ids.includes(r.menu_id) || ids.includes(asisIdOf(r.menu_id))));
const sum = new CsvOut(path.join(gapDir, '_summary.csv'), ['menu_id', 'page_key', 'has_mapping_md', 'ep_total', 'ep_covered', 'ep_intended', 'ep_missing', 'ev_total', 'ev_covered', 'ev_intended', 'ev_missing', 'ev_unmapped', 'ctl_total', 'ctl_covered', 'ctl_intended', 'ctl_missing', 'ctl_unmapped', 'sheet_total', 'sheet_unmapped', 'hardcol_total', 'hardcol_unmapped', 'score']);
const allDetails = [];
const md = [`# GAP 요약 — ${new Date().toISOString().slice(0, 10)} (${targets.length}화면)`, '', '| 화면 | 매핑표 | 엔드포인트 C/I/M | 이벤트 C/I/M/U | 컨트롤 C/I/M/U | 시트 미대사 | 하드컬럼 미대사 | 점수 |', '|---|---|---|---|---|---|---|---|'];
for (const t of targets) {
  const ID = t.menu_id, AID = asisIdOf(ID), sdir = path.join(cfg.asisOutDir, 'screens', AID);
  const cur = rows => rows.filter(r => r.variant !== 'legacy');
  const A = { ep: cur(readCsv(path.join(sdir, 'endpoints.csv'))), ev: cur(readCsv(path.join(sdir, 'events.csv'))), ctl: cur(readCsv(path.join(sdir, 'controls.csv'))), grid: readCsv(path.join(sdir, 'grid_effective.csv')) };
  const pk = t.page_key;
  const B = { ep: T.ep.filter(r => r.page_key === pk && r.commented === '0'), ev: T.ev.filter(r => r.page_key === pk), ctl: T.ctl.filter(r => r.page_key === pk), refs: T.refs.filter(r => r.page_key === pk), map: T.map.filter(r => r.page_key === pk), consts: T.consts.filter(r => r.page_key === pk), gc: T.gc.filter(r => r.page_key === pk), dts: T.dts.filter(r => r.menu_id === ID) };
  const hasMap = B.map.length > 0;
  const refText = B.refs.map(r => r.sp_names + ' ' + r.comment).join('\n');
  const metaText = procMeta.filter(r => (r.menu_id || r.MNU_ID || '').toUpperCase() === ID).map(r => `${r.pkg || r.PKG_NM || ''} ${r.proc || r.PROC_NM || ''}`).join('\n');
  const codeText = B.ep.map(r => `${r.url} ${r.args}`).join('\n') + '\n' + B.dts.map(r => r.sp_hints + ' ' + r.sheet).join('\n') + '\n' + metaText;
  const mapRow = (needle) => B.map.find(m => m.summary.includes(needle) || m.impl_location.includes(needle) || m.reason.includes(needle));
  const detailRows = []; const out0 = new CsvOut(path.join(gapDir, `${ID}_gap.csv`), ['kind', 'asis_item', 'asis_detail', 'status', 'evidence', 'reason']);
  const out = { row: r => { detailRows.push(r); out0.row(r); }, close: () => out0.close() };
  const cnt = { ep: {}, ev: {}, ctl: {} }; const inc = (k, s) => cnt[k][s] = (cnt[k][s] || 0) + 1;
  // 1) 엔드포인트
  // 1-0) 기간형 동적 헤더 SP(GetSpdTitle → *_3SPAN / *_SPREAD_TITLE …) — '사내 등록'만으로 COVERED 금지, FE 가 배선 시트를 실제 조회해야 COVERED
  //      (2026-10-20 SCP0096: calendar 배선 등록 = COVERED 로 통과했지만 FE 미호출 → 조회 시 기간 컬럼 0). 판정 = lib/dyncol(check.js B27 과 동일)
  const titleP = new Map(DY.asisTitleEndpoints(A.ep).filter(t => t.kind === 'period').map(t => [t.sp.toUpperCase(), t]));
  const menuMeta = procMeta.filter(r => (r.menu_id || '').toUpperCase() === ID && r.use_yn !== 'N' && r.proc);
  const exactSheets = new Set([...titleP.values()].flatMap(t => { const c = DY.corpTitleSheets(t.sp, menuMeta); return c.via === 'exact' ? c.sheets : []; }));
  const pageSrc = (() => { const [feat, ...rest] = pk.split('/'); const pd = path.join(cfg.feRoot, 'features', feat, 'src', 'pages', ...rest); if (!feat || !fs.existsSync(pd)) return null; const walk = d => fs.readdirSync(d, { withFileTypes: true }).flatMap(x => x.isDirectory() ? (x.name === 'node_modules' ? [] : walk(path.join(d, x.name))) : [path.join(d, x.name)]); return Object.fromEntries(walk(pd).filter(f => /\.tsx?$/.test(f)).map(f => [f, fs.readFileSync(f, 'utf8')])); })();
  const seenEp = new Set();
  for (const e of A.ep) {
    const key = e.key || e.candidate; if (!key || seenEp.has(key)) continue; seenEp.add(key);
    const sp = (e.sp_or_sql || '').replace(/^SP\s+/, '');
    let status, evidence = '', reason = '';
    const al = allowed('endpoint', sp) || allowed('endpoint', key);
    const m = mapRow(key) || (sp && mapRow(sp));
    const tp = sp && titleP.get(sp.toUpperCase());
    const tc = tp && DY.corpTitleSheets(tp.sp, menuMeta, exactSheets);
    const tUsed = tc && pageSrc ? [...new Set((tc.via === 'exact' ? tc.pairs : DY.corpAllTitlePairs(menuMeta)).filter(p => DY.consumesPair(pageSrc, p)).map(p => p.sheet + (p.btn !== 'SEARCH' ? '/' + p.btn : '')))] : [];
    if (tp && !(m && /^(제외|해당없음)/.test(m.status)) && tUsed.length) { status = 'COVERED'; evidence = `동적 헤더 시트 '${tUsed.join("','")}' FE 조회${tc.via === 'exact' ? '' : ' (정확 배선 없음 — 같은 화면 타이틀 계열 시트)'}`; }
    else if (tp && !(m && /^(제외|해당없음)/.test(m.status)) && tc.via === 'exact') { status = 'MISSING'; reason = `기간형 동적 헤더 SP — 사내 배선 시트 '${tc.sheets.join("','")}' 를 FE 가 조회하지 않음(등록만으로는 기간 컬럼이 안 그려짐, check.js B27)`; }
    else if (tp && !(m && /^(제외|해당없음)/.test(m.status))) { status = 'MISSING'; reason = `기간형 동적 헤더 SP — 사내 정확 배선 없음·FE 조회 없음: 배선 등록 후 FE 조회 또는 대사표에 대체 근거 '제외'(check.js B27)`; }
    else if (al) { status = 'INTENDED'; reason = al; }
    else if (m && /^(제외|해당없음)/.test(m.status)) { status = 'INTENDED'; reason = `${m.design_id} ${m.status}: ${m.reason}`; }
    else if (sp && metaText.toUpperCase().includes(sp.toUpperCase())) { status = 'COVERED'; evidence = 'SP 등록 메타(SCM_ADM_PROC_M) 에 등록'; }
    else if (sp && (codeText.includes(sp) || refText.includes(sp))) { status = 'COVERED'; evidence = codeText.includes(sp) ? 'To-Be 코드/procedures.d.ts 에 SP 언급' : 'To-Be 주석(asis_refs) 에 SP 언급'; }
    else if (m && /^구현/.test(m.status)) { status = 'COVERED'; evidence = `${m.design_id} ${m.impl_location}`; }
    else { status = 'MISSING'; reason = hasMap ? '매핑표·코드·주석 어디에도 대응 없음' : '매핑표 없음 + 코드·주석에 SP 언급 없음'; }
    inc('ep', status); out.row({ kind: 'endpoint', asis_item: key, asis_detail: `SP ${sp} (${e.status}) @${e.member}:${e.line}`, status, evidence, reason });
  }
  // 2) 이벤트 (주 클래스)
  const mainClass = (A.ev.find(x => x.class.startsWith(ID + '_') && !/popup/i.test(x.class)) || A.ev[0] || {}).class;
  for (const e of A.ev.filter(x => x.class === mainClass && x.op === '+=' && x.handler !== '<lambda>' && /^[A-Z]/.test(x.event))) {
    const tgt = e.target.replace(/^this\./, ''); let status, evidence = '', reason = '';
    const al = allowed('event', e.target + ' ' + e.event) || allowed('control_name', tgt);
    const m = B.map.find(x => x.summary.includes(`${tgt} / ${e.event}`));
    if (al) { status = 'INTENDED'; reason = al; }
    else if (m && /^(제외|해당없음)/.test(m.status)) { status = 'INTENDED'; reason = `${m.design_id}: ${m.reason}`; }
    else if (m && /^구현/.test(m.status)) { status = 'COVERED'; evidence = `${m.design_id} ${m.impl_location}`; }
    else if (m) { status = 'MISSING'; reason = `${m.design_id} ${m.status}: ${m.reason}`; }
    else if (refText.includes(e.handler) || refText.includes(tgt)) { status = 'COVERED'; evidence = 'To-Be 주석에 As-is 핸들러/컨트롤 언급'; }
    else { status = hasMap ? 'MISSING' : 'UNMAPPED'; reason = hasMap ? '매핑표에 행 없음' : '매핑표 없음'; }
    inc('ev', status); out.row({ kind: 'event', asis_item: `${tgt}.${e.event}`, asis_detail: `→ ${e.handler} @${e.line}`, status, evidence, reason });
  }
  // 3) 조회조건/버튼 컨트롤 (사전 gen=field/button/grid 만)
  for (const c of A.ctl.filter(x => x.class === mainClass)) {
    const tp = c.type.split('.').pop(); const r = mapCtl.find(x => x.asis_type === tp);
    if (!r || !['field', 'button', 'grid'].includes(r.gen)) continue;
    let status, evidence = '', reason = '';
    const al = allowed('control_name', c.name) || allowed('control_type', tp);
    const m = B.map.find(x => x.summary.includes(`${c.name} / `));
    if (al) { status = 'INTENDED'; reason = al; }
    else if (m && /^(제외|해당없음)/.test(m.status)) { status = 'INTENDED'; reason = `${m.design_id}: ${m.reason}`; }
    else if (m && /^구현/.test(m.status)) { status = 'COVERED'; evidence = `${m.design_id} ${m.impl_location}`; }
    else if (m) { status = 'MISSING'; reason = `${m.design_id} ${m.status}: ${m.reason}`; }
    else if (refText.includes(c.name)) { status = 'COVERED'; evidence = 'To-Be 주석에 As-is 컨트롤명 언급'; }
    else { status = hasMap ? 'MISSING' : 'UNMAPPED'; reason = hasMap ? '매핑표에 행 없음' : '매핑표 없음'; }
    inc('ctl', status); out.row({ kind: 'control', asis_item: c.name, asis_detail: `${tp} → ${r.tobe_component} @${c.line}`, status, evidence, reason });
  }
  // 4) 시트 → SHEETS enum 값
  const metaSheets = sheetCols.filter(r => (r.program_id || r.PROGRAM_ID || '').toUpperCase() === ID);
  const sheetVals = new Set(B.consts.filter(x => /^SHEETS\./.test(x.name)).map(x => x.value).concat(metaSheets.map(r => r.sheet_name || r.SHEET_NAME)));
  const metaCols = new Set(metaSheets.map(r => (r.column_name || r.COLUMN_NAME || '').toUpperCase()));
  const sheets = [...new Set(A.grid.map(g => g.sheet))].filter(s => s && s !== '(시트 미상)' && !/popup/i.test(s));
  let sheetMissing = 0;
  for (const s of sheets) { const ok = sheetVals.has(s) || [...sheetVals].some(v => v.toLowerCase() === s.toLowerCase()); if (!ok) sheetMissing++; out.row({ kind: 'sheet', asis_item: s, asis_detail: A.grid.find(g => g.sheet === s).sheet_rule, status: ok ? 'COVERED' : (sheetCols.length ? 'MISSING' : 'UNMAPPED'), evidence: ok ? (metaSheets.length ? 'SHEETS enum / 시트 메타' : 'SHEETS enum') : '', reason: ok ? '' : `SHEETS enum 에 As-is 시트명 '${s}' 없음 — To-Be 등록 SHEET_NAME 이 다를 수 있어 DB 메타(SCM_MST_SHEET_COLUMNS) 대사 필요` }); }
  // 5) 하드코딩 컬럼 (As-is CODE 컬럼 vs To-Be grid_columns binding)
  const hard = A.grid.filter(g => g.source === 'CODE' && !/popup/i.test(g.sheet)); const bindings = new Set(B.gc.map(x => x.binding.toUpperCase()));
  let hardMissing = 0;
  for (const g of hard) { const meta = metaCols.has(g.column.toUpperCase()); const ok = meta || bindings.has(g.column.toUpperCase()) || codeText.toUpperCase().includes(g.column.toUpperCase()); if (!ok) hardMissing++; out.row({ kind: 'hard_column', asis_item: `${g.sheet}.${g.column}`, asis_detail: g.label, status: ok ? 'COVERED' : (sheetCols.length ? 'MISSING' : 'UNMAPPED'), evidence: ok ? (meta ? 'SCM_MST_SHEET_COLUMNS 메타' : 'To-Be 컬럼 정의/코드') : '', reason: ok ? '' : 'As-is 하드코딩 컬럼이 To-Be 소스에 없음 — 메타(SCM_MST_SHEET_COLUMNS) 로 옮겨졌는지 DB 대사 필요' }); }
  // 동적 컬럼(As-is grid_code DB_DRIVEN 컬럼 생성) — 2026-10-20 SCP0096: 정적 hard_column 축만 있어 DB루프 컬럼은 GAP 에 행 자체가 없었다.
  //   원천 결과셋 = 같은 화면의 기간형 타이틀 SP. 그 사내 시트(정확 배선 우선, 없으면 타이틀 계열)를 FE 가 조회해야 COVERED. 타이틀 SP 판정 밖 루프는 UNMAPPED(원천 확인 필요).
  {
    const loops = DY.asisDbLoop(sdir);
    const exactPairs = [...titleP.values()].flatMap(t => { const c = DY.corpTitleSheets(t.sp, menuMeta); return c.via === 'exact' ? c.pairs : []; });
    const srcPairs = exactPairs.length ? exactPairs : DY.corpAllTitlePairs(menuMeta);
    const srcSheets = [...new Set(srcPairs.map(p => p.sheet + (p.btn !== 'SEARCH' ? '/' + p.btn : '')))];
    const used = pageSrc ? [...new Set(srcPairs.filter(p => DY.consumesPair(pageSrc, p)).map(p => p.sheet + (p.btn !== 'SEARCH' ? '/' + p.btn : '')))] : [];
    const dm = m => B.map.find(x => new RegExp(`${m.split(':')[0]}\\s*[/:]\\s*${m.split(':')[1]}\\b`).test(x.summary));
    for (const loc of loops) {
      const mr = dm(loc); let status, evidence = '', reason = '';
      if (mr && /^(제외|해당없음)/.test(mr.status)) { status = 'INTENDED'; reason = `${mr.design_id} ${mr.status}: ${mr.reason}`; }
      else if (used.length) { status = 'COVERED'; evidence = `타이틀 시트 '${used.join("','")}' FE 조회${mr ? ' · 대사표 ' + mr.design_id : ' · 대사표 §6 행 없음(M08)'}`; }
      else if (!titleP.size) { status = 'UNMAPPED'; reason = 'DB루프 원천 결과셋이 기간형 타이틀 SP 판정에 안 걸림 — 원천 확인 필요'; }
      else { status = 'MISSING'; reason = srcSheets.length ? `동적 컬럼 원천 타이틀 시트 '${srcSheets.join("','")}' 를 FE 가 조회하지 않음 — 조회 시 이 컬럼들이 생성되지 않음(B27)` : '동적 컬럼 원천 타이틀 SP 의 사내 배선 없음 — DB 메타 등록 후 FE 조회(B27)'; }
      out.row({ kind: 'dynamic_column', asis_item: loc, asis_detail: `DB루프 컬럼 생성 ← ${[...titleP.values()].map(t => t.sp).join(', ') || '(타이틀 SP 미판정)'}`, status, evidence, reason });
    }
  }
  out.close();
  const g = k => ['COVERED', 'INTENDED', 'MISSING', 'UNMAPPED'].map(s => cnt[k][s] || 0);
  const [epC, epI, epM] = g('ep'), [evC, evI, evM, evU] = g('ev'), [ctC, ctI, ctM, ctU] = g('ctl');
  const tot = epC + epI + epM + evC + evI + evM + evU + ctC + ctI + ctM + ctU; const score = tot ? Math.round((epC + epI + evC + evI + ctC + ctI) / tot * 100) : 0;
  allDetails.push({ id: ID, pk, hasMap, score: 0, rows: detailRows });
  sum.row({ menu_id: ID, page_key: pk, has_mapping_md: hasMap ? 'Y' : 'N', ep_total: epC + epI + epM, ep_covered: epC, ep_intended: epI, ep_missing: epM, ev_total: evC + evI + evM + evU, ev_covered: evC, ev_intended: evI, ev_missing: evM, ev_unmapped: evU, ctl_total: ctC + ctI + ctM + ctU, ctl_covered: ctC, ctl_intended: ctI, ctl_missing: ctM, ctl_unmapped: ctU, sheet_total: sheets.length, sheet_unmapped: sheetMissing, hardcol_total: hard.length, hardcol_unmapped: hardMissing, score });
  allDetails[allDetails.length - 1].score = score; allDetails[allDetails.length - 1].counts = { epC, epI, epM, evC, evI, evM, evU, ctC, ctI, ctM, ctU, sheetMissing, sheets: sheets.length, hardMissing, hard: hard.length };
  md.push(`| ${ID} | ${hasMap ? 'Y' : '-'} | ${epC}/${epI}/${epM} | ${evC}/${evI}/${evM}/${evU} | ${ctC}/${ctI}/${ctM}/${ctU} | ${sheetMissing}/${sheets.length} | ${hardMissing}/${hard.length} | ${score} |`);
}
sum.close();
fs.writeFileSync(path.join(gapDir, '_summary.md'), md.join('\n') + '\n\nC=COVERED(대응 근거 있음) I=INTENDED(의도된 차이) M=MISSING(대응 없음) U=UNMAPPED(매핑표 없거나 DB 메타가 있어야 판단 가능). 점수 = (C+I)/(엔드포인트+이벤트+컨트롤 전체).\n\n**주의** 엔드포인트 MISSING 의 상당수는 SP 가 Oracle 메타(SCM_ADM_PROC_M) 에만 등록되어 소스에 이름이 없는 경우다 — 클라우드에서 `PR_GET_PROCEDURES_METADATA` 결과(메뉴×시트×버튼×PKG.SP) 를 CSV 로 내려 `Doc/tobefacts/db/proc_meta.csv` 에 두면 gap.js 가 COVERED 로 재판정한다(다음 단계).\n', 'utf8');
fs.writeFileSync(path.join(gapDir, 'index.html'), dashboard(allDetails), 'utf8');
console.log(`GAP: ${targets.length}화면 → ${gapDir} (index.html 대시보드)`);

function dashboard(items) {
  const esc = x => String(x ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
  const data = JSON.stringify(items).replace(/<\//g, '<\\/');
  return `<!DOCTYPE html><html lang="ko"><head><meta charset="utf-8"><title>NSCM GAP 대시보드</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
:root{--bg:#fff;--fg:#1f2328;--mute:#656d76;--line:#d0d7de;--card:#f6f8fa;--ok:#1a7f37;--int:#9a6700;--miss:#cf222e;--unm:#6e7781;--acc:#0969da}
@media (prefers-color-scheme: dark){:root{--bg:#0d1117;--fg:#e6edf3;--mute:#8b949e;--line:#30363d;--card:#161b22;--ok:#3fb950;--int:#d29922;--miss:#f85149;--unm:#8b949e;--acc:#58a6ff}}
body{margin:0;padding:20px 24px;background:var(--bg);color:var(--fg);font:14px/1.5 -apple-system,"Segoe UI","Malgun Gothic",sans-serif}
h1{font-size:20px;margin:0 0 4px}.sub{color:var(--mute);margin:0 0 16px;font-size:13px}
.tiles{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px;margin-bottom:16px}
.tile{background:var(--card);border:1px solid var(--line);border-radius:8px;padding:10px 12px}.tile b{font-size:22px;display:block}.tile span{color:var(--mute);font-size:12px}
.bar{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:10px;align-items:center}input,select{padding:6px 8px;border:1px solid var(--line);border-radius:6px;background:var(--bg);color:var(--fg)}
table{width:100%;border-collapse:collapse;font-size:13px}th,td{border-bottom:1px solid var(--line);padding:6px 8px;text-align:left;white-space:nowrap}th{cursor:pointer;background:var(--card);position:sticky;top:0}
tr.row:hover{background:var(--card);cursor:pointer}.c{color:var(--ok)}.i{color:var(--int)}.m{color:var(--miss);font-weight:600}.u{color:var(--unm)}
.score{display:inline-block;min-width:36px;text-align:center;border-radius:10px;padding:0 8px;color:#fff;background:var(--miss)}.score.hi{background:var(--ok)}.score.mid{background:var(--int)}
#detail{margin-top:18px;border:1px solid var(--line);border-radius:8px;padding:12px;background:var(--card);display:none}#detail h2{font-size:16px;margin:0 0 8px}
#detail td{white-space:normal}.pill{font-size:11px;padding:1px 6px;border-radius:8px;border:1px solid var(--line);margin-right:4px}
.legend{font-size:12px;color:var(--mute);margin:6px 0 14px}
</style></head><body>
<h1>NSCM GAP 대시보드 — As-is Fact ↔ To-Be Fact</h1>
<p class="sub">생성 ${new Date().toLocaleString('ko-KR')} · tools/Harness/gap.js · 화면을 클릭하면 항목별 상세. 점수 = (COVERED+INTENDED)/(엔드포인트+이벤트+컨트롤)</p>
<div class="tiles" id="tiles"></div>
<div class="bar"><input id="q" placeholder="화면ID / 페이지 검색"><select id="dom"><option value="">전체 도메인</option></select><select id="map"><option value="">매핑표 전체</option><option value="Y">매핑표 있음</option><option value="N">매핑표 없음</option></select><label><input type="checkbox" id="onlyMiss"> MISSING 있는 화면만</label></div>
<div class="legend"><span class="c">C</span>=COVERED 대응 근거 있음 · <span class="i">I</span>=INTENDED 의도된 차이(allowed_gaps/매핑표 제외·해당없음) · <span class="m">M</span>=MISSING 대응 없음 · <span class="u">U</span>=UNMAPPED 매핑표 없거나 DB 메타 필요</div>
<table id="t"><thead><tr><th data-k="id">화면</th><th data-k="pk">페이지</th><th data-k="hasMap">매핑표</th><th data-k="ep">엔드포인트 C/I/M</th><th data-k="ev">이벤트 C/I/M/U</th><th data-k="ct">컨트롤 C/I/M/U</th><th data-k="sh">시트 미대사</th><th data-k="hc">하드컬럼 미대사</th><th data-k="score">점수</th></tr></thead><tbody></tbody></table>
<div id="detail"></div>
<script>
const DATA=${data};
const $=s=>document.querySelector(s);const tb=$('#t tbody');let sortK='score',sortAsc=true;
const doms=[...new Set(DATA.map(d=>d.id.replace(/\d.*$/,'')))].sort();for(const d of doms){const o=document.createElement('option');o.value=d;o.textContent=d;$('#dom').appendChild(o);}
function tiles(rows){const sum=k=>rows.reduce((a,d)=>a+d.counts[k],0);const avg=rows.length?Math.round(rows.reduce((a,d)=>a+d.score,0)/rows.length):0;
$('#tiles').innerHTML=[['화면',rows.length,''],['평균 점수',avg,'(C+I)/전체'],['엔드포인트 MISSING',sum('epM'),'SP 메타(proc_meta.csv) 없으면 과대'],['이벤트 MISSING',sum('evM'),'매핑표 있는 화면만 판정'],['이벤트 UNMAPPED',sum('evU'),'매핑표 없음'],['컨트롤 MISSING',sum('ctM'),'']].map(([l,v,n])=>'<div class="tile"><b>'+v+'</b><span>'+l+(n?' — '+n:'')+'</span></div>').join('');}
function filt(){const q=$('#q').value.toLowerCase(),dm=$('#dom').value,mp=$('#map').value,om=$('#onlyMiss').checked;return DATA.filter(d=>(!q||d.id.toLowerCase().includes(q)||d.pk.toLowerCase().includes(q))&&(!dm||d.id.startsWith(dm))&&(!mp||(d.hasMap?'Y':'N')===mp)&&(!om||d.counts.epM+d.counts.evM+d.counts.ctM>0));}
const key={id:d=>d.id,pk:d=>d.pk,hasMap:d=>d.hasMap?1:0,ep:d=>d.counts.epM,ev:d=>d.counts.evM+d.counts.evU,ct:d=>d.counts.ctM+d.counts.ctU,sh:d=>d.counts.sheetMissing,hc:d=>d.counts.hardMissing,score:d=>d.score};
function render(){const rows=filt().sort((a,b)=>{const x=key[sortK](a),y=key[sortK](b);return (x<y?-1:x>y?1:0)*(sortAsc?1:-1);});tiles(rows);
tb.innerHTML=rows.map(d=>{const c=d.counts;const sc=d.score>=80?'hi':d.score>=50?'mid':'';return '<tr class="row" data-id="'+d.id+'"><td><b>'+d.id+'</b></td><td>'+d.pk+'</td><td>'+(d.hasMap?'Y':'-')+'</td><td><span class="c">'+c.epC+'</span>/<span class="i">'+c.epI+'</span>/<span class="m">'+c.epM+'</span></td><td><span class="c">'+c.evC+'</span>/<span class="i">'+c.evI+'</span>/<span class="m">'+c.evM+'</span>/<span class="u">'+c.evU+'</span></td><td><span class="c">'+c.ctC+'</span>/<span class="i">'+c.ctI+'</span>/<span class="m">'+c.ctM+'</span>/<span class="u">'+c.ctU+'</span></td><td>'+c.sheetMissing+'/'+c.sheets+'</td><td>'+c.hardMissing+'/'+c.hard+'</td><td><span class="score '+sc+'">'+d.score+'</span></td></tr>';}).join('');}
tb.addEventListener('click',e=>{const tr=e.target.closest('tr.row');if(!tr)return;const d=DATA.find(x=>x.id===tr.dataset.id);const st={COVERED:'c',INTENDED:'i',MISSING:'m',UNMAPPED:'u'};
$('#detail').style.display='block';$('#detail').innerHTML='<h2>'+d.id+' <small style="color:var(--mute)">'+d.pk+' · '+(d.hasMap?'__asis-mapping__.md 있음':'매핑표 없음')+' · Doc/gap/'+d.id+'_gap.csv</small></h2>'+['endpoint','event','control','sheet','hard_column','dynamic_column'].map(k=>{const rs=d.rows.filter(r=>r.kind===k);if(!rs.length)return '';return '<h3 style="font-size:14px;margin:10px 0 4px">'+({endpoint:'엔드포인트(SP)',event:'이벤트',control:'컨트롤',sheet:'시트',hard_column:'하드코딩 컬럼'})[k]+' ('+rs.length+')</h3><table><thead><tr><th>As-is</th><th>상세</th><th>판정</th><th>근거 / 사유</th></tr></thead><tbody>'+rs.map(r=>'<tr><td>'+esc(r.asis_item)+'</td><td>'+esc(r.asis_detail)+'</td><td class="'+st[r.status]+'">'+r.status+'</td><td>'+esc(r.evidence||r.reason)+'</td></tr>').join('')+'</tbody></table>';}).join('');$('#detail').scrollIntoView({behavior:'smooth'});});
function esc(x){return String(x??'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}
document.querySelectorAll('th').forEach(th=>th.addEventListener('click',()=>{const k=th.dataset.k;if(sortK===k)sortAsc=!sortAsc;else{sortK=k;sortAsc=k==='score';}render();}));
['q','dom','map','onlyMiss'].forEach(id=>$('#'+id).addEventListener('input',render));render();
</script></body></html>`;
}
