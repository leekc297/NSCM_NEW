#!/usr/bin/env node
'use strict';
// Recon — 개발대상 대조표: 개발대상 목록(xlsx) × As-is 파싱(AsisFacts) × To-Be(TobeFacts/소스/메타) × 하네스 산출(gen/check/gap/docs/golden/e2e)
//   node recon.js [--config ../Harness/harness.json]
//   선행: python xlsx_to_csv.py  (Doc/recon/_input/*.csv, rules/map_screen.csv)
//   산출: Doc/recon/대사표_화면.csv, 대사표_SP.csv, 대사표_시트.csv, 대사표.md, index.html
//   판정(화면): OK=대상·파싱·To-Be 모두 있음 / 누락-파싱 / 누락-ToBe / 대상외 / 재확인
const fs = require('fs'); const path = require('path');
const { readCsv, CsvOut } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, '..', 'Harness', 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, '..', 'Harness', 'rules');
const DOC = path.dirname(cfg.genOutDir);
const reconDir = path.join(DOC, 'recon'), inDir = path.join(reconDir, '_input'); fs.mkdirSync(inDir, { recursive: true });
const ex = p => fs.existsSync(p); const rc = p => ex(p) ? readCsv(p) : [];
const up = s => (s || '').toUpperCase();

// ── 입력
const targets = rc(path.join(inDir, 'dev_targets.csv')), tSps = rc(path.join(inDir, 'dev_target_sps.csv')), tSheets = rc(path.join(inDir, 'dev_target_sheets.csv'));
const progress = rc(path.join(inDir, 'dev_progress.csv')), spStatus = rc(path.join(inDir, 'sp_dev_status.csv'));
const mapScreen = rc(path.join(R, 'map_screen.csv'));
const a2t = new Map(mapScreen.map(r => [up(r.asis_id), up(r.tobe_id)])); const t2a = new Map(mapScreen.map(r => [up(r.tobe_id), up(r.asis_id)]));
const asisScreens = ex(path.join(cfg.asisOutDir, 'screens')) ? fs.readdirSync(path.join(cfg.asisOutDir, 'screens')).filter(d => fs.statSync(path.join(cfg.asisOutDir, 'screens', d)).isDirectory()) : [];
const tIdx = rc(path.join(cfg.tobeOutDir, 'screens', '_index.csv')).filter(r => r.menu_id && !/\/components\//.test(r.page_key));
const tByMenu = new Map(); for (const r of tIdx) if (!tByMenu.has(up(r.menu_id))) tByMenu.set(up(r.menu_id), r);
const gapSum = new Map(rc(path.join(cfg.gapDir || path.join(DOC, 'gap'), '_summary.csv')).map(r => [up(r.menu_id), r]));
const golden = rc(path.join(DOC, 'golden', '_summary.csv')); const goldenBy = new Map(); for (const g of golden) goldenBy.set(up(g.asis_sp), g.verdict);
const procMeta = rc(path.join(cfg.tobeOutDir, 'db', 'proc_meta.csv')); const metaByMenu = new Map();
for (const r of procMeta) if (r.proc) { const k = up(r.menu_id); if (!metaByMenu.has(k)) metaByMenu.set(k, new Set()); metaByMenu.get(k).add(up(r.proc)); }
const sheetCols = rc(path.join(cfg.tobeOutDir, 'db', 'sheet_columns.csv')); const metaSheets = new Map();
for (const r of sheetCols) { const k = up(r.program_id); if (!metaSheets.has(k)) metaSheets.set(k, new Set()); metaSheets.get(k).add(r.sheet_name); }
const tConsts = rc(path.join(cfg.tobeOutDir, 'constants.csv'));
// To-Be 패키지 소스(오프라인 폴백)
const pkgProcs = new Set(); const pkgDir = cfg.tobePkgDir || path.join(DOC, '..', 'To-be_v2_converted', '06_Packages');
if (ex(pkgDir)) for (const fn of fs.readdirSync(pkgDir).filter(f => /\.sql$/i.test(f))) { const t = fs.readFileSync(path.join(pkgDir, fn), 'utf8'); const pk = /PACKAGE\s+(?:BODY\s+)?(?:SCM_MGR\.)?(PKG_\w+)/i.exec(t); if (!pk) continue; for (const m of t.matchAll(/^\s*PROCEDURE\s+(\w+)/gim)) pkgProcs.add(`${up(pk[1])}.${up(m[1])}`); }
const norm = s => up(s).replace(/[^A-Z0-9]/g, '');
const findTobeProc = (sp, menu) => { const n = norm(sp); const pool = [...(metaByMenu.get(menu) || []), ...pkgProcs]; let hit = pool.find(p => norm(p.split('.').pop().replace(/^P_/, '')) === n); if (hit) return [hit, 'exact']; hit = pool.find(p => norm(p).includes(n)); return hit ? [hit, 'contains'] : ['', '']; };
const e2eDir = path.join(DOC, 'e2e', 'specs');
const e2eRes = rc(path.join(DOC, 'e2e', 'results', '_summary.csv')); const e2eOfRes = id => { const r = e2eRes.filter(x => up(x.menu_id) === id); return r.length ? `${r.filter(x => x.status === 'PASS').length}/${r.length}` : ''; };
// 신뢰도 점수(0~100): 사람이 볼 화면을 고르는 기준. gen 없으면 공란
const confidence = (gap, chk, gold, e2e, docs) => { let c = 100; const why = [];
  if (gap && gap.score !== '') { const d = Math.round((100 - Number(gap.score)) / 2); c -= d; if (d) why.push(`GAP ${gap.score}`); }
  if (chk) { const [b, w] = chk.split('/').map(Number); if (b) { c -= Math.min(40, b * 10); why.push(`BLOCK ${b}`); } if (w) { c -= Math.min(10, w * 2); } }
  if (gold) { const [p, t] = gold.split('/').map(Number); if (p < t) { c -= 20; why.push(`골든 ${gold}`); } }
  if (e2e) { const [p, t] = e2e.split('/').map(Number); if (p < t) { c -= 20; why.push(`E2E ${e2e}`); } } else { c -= 5; why.push('E2E 미실행'); }
  if (!docs) { c -= 10; why.push('문서 없음'); }
  return { score: Math.max(0, c), why: why.join(' · ') }; };
const e2eOf = id => ex(e2eDir) ? fs.readdirSync(e2eDir).filter(f => f.toUpperCase().startsWith(id + '.') || f.toUpperCase().startsWith(id + '-')).length : 0;
const DOCS1 = ['analysis.md', 'tobe_design.md', 'oracle_migration.md', 'web_components.md', 'source_links.md'], DOCS2 = ['business_analysis.md', 'screen_design.md', 'unit_test.md'];

// ── 화면 대사
const ids = new Set([...targets.map(r => up(r.asis_id)), ...asisScreens.map(up)]);
for (const r of tIdx) { const m = up(r.menu_id); if (!(t2a.has(m) && t2a.get(m) !== m)) ids.add(m); } // 이름이 바뀐 To-Be 화면은 As-is ID 행에서 다룬다
// 전 화면 엔드포인트 사용표(endpoint_usage.csv) — 특정 화면에서 못 찾은 SP 가 다른 화면/공통에서 검출되는지 확인용
const usage = rc(path.join(cfg.asisOutDir, 'endpoint_usage.csv')); const usageBy = new Map();
for (const u of usage) { if (u.commented === '1') continue; const sp = up((u.key || u.candidate || '').split('.').pop()); if (!sp) continue; if (!usageBy.has(sp)) usageBy.set(sp, new Set()); usageBy.get(sp).add(u.screen_id || '(공통)'); }
const scrRows = [];
for (const id of [...ids].sort()) {
  if (!/^[A-Z]{2,5}\d{4}|^GSCM_|^SYS\d{4}/.test(id)) continue;
  const tg = targets.find(r => up(r.asis_id) === id); const tobeId = a2t.get(id) || id; const tb = tByMenu.get(tobeId) || (tobeId !== id ? tByMenu.get(id) : null);
  const parsed = asisScreens.find(d => up(d) === id); const sdir = parsed ? path.join(cfg.asisOutDir, 'screens', parsed) : '';
  const cnt = f => parsed ? rc(path.join(sdir, f)).filter(r => r.variant !== 'legacy').length : '';
  const spsParsed = parsed ? [...new Set(rc(path.join(sdir, 'endpoints.csv')).filter(r => r.variant !== 'legacy' && r.status === 'MATCH' && /^SP\s/.test(r.sp_or_sql || '')).map(r => r.sp_or_sql.replace(/^SP\s+/, '').split('.').pop()))] : [];
  const genDir = path.join(cfg.genOutDir, tobeId); const gen = ex(genDir) ? 'Y' : (ex(path.join(cfg.genOutDir, id)) ? 'Y' : '');
  const chk = ex(path.join(genDir, 'CHECK.md')) ? ((/BLOCK (\d+) \/ WARN (\d+)/.exec(fs.readFileSync(path.join(genDir, 'CHECK.md'), 'utf8')) || []).slice(1).join('/') || '') : '';
  const gap = gapSum.get(tobeId) || gapSum.get(id); const agentDir = path.join(cfg.asisOutDir, 'agent', id);
  const docs = ex(agentDir) ? `${DOCS1.filter(f => ex(path.join(agentDir, f))).length}/5+${DOCS2.filter(f => ex(path.join(agentDir, f))).length}/3` : '';
  const gv = spsParsed.map(s => goldenBy.get(up(s))).filter(Boolean); const gold = gv.length ? `${gv.filter(v => v === 'PASS').length}/${gv.length}` : '';
  const pr = progress.find(r => up(r.asis_id) === id);
  let status, reason = '';
  if (tg && !parsed) { status = '누락-파싱'; reason = '개발대상인데 As-is Fact Pack 없음 — As-is 소스 폴더명/ID 패턴 확인(asisfacts.json screenIdPatterns)'; }
  else if (tg && parsed && !tb) { status = '누락-ToBe'; reason = `To-Be 페이지(MENU_ID=${tobeId}) 없음 — 하네스 new-screen 대상`; }
  else if (!tg && parsed && tb) { status = '대상외-구현됨'; reason = '개발대상 목록에 없으나 As-is·To-Be 모두 존재 — 목록 갱신 필요'; }
  else if (!tg && parsed && !tb) { status = '대상외'; reason = 'As-is 에만 있음(2ND 이후 또는 폐기 대상인지 확인)'; }
  else if (!tg && !parsed && tb) { status = 'ToBe신규'; reason = 'To-Be 전용 화면(As-is 없음)'; }
  else { status = 'OK'; if (gap && +gap.score < 60) { status = '재확인'; reason = `GAP 점수 ${gap.score} 낮음`; } if (chk && !chk.startsWith('0/')) { status = '재확인'; reason += ' 하네스 BLOCK 있음'; } }
  const e2e = e2eOfRes(tobeId); const conf = (gen || tb) ? confidence(gap, chk, gold, e2e, docs) : { score: '', why: '' };
  if (status === 'OK' && conf.score !== '' && conf.score < 70) { status = '검토필요'; reason = `신뢰도 ${conf.score} (${conf.why})`; }
  scrRows.push({ asis_id: id, tobe_id: tobeId, stage: tg ? tg.stage : '', module: tg ? tg.module : (tb ? tb.feature : ''), title: tg ? tg.menu3 : '', in_target: tg ? 'Y' : '', asis_parsed: parsed ? 'Y' : '', controls: cnt('controls.csv'), events: cnt('events.csv'), sps: spsParsed.length, tobe_page: tb ? tb.page_key : '', tobe_endpoints: tb ? tb.endpoints : '', gen, check_block_warn: chk, gap_score: gap ? gap.score : '', agent_docs: docs, golden_pass: gold, e2e_specs: e2eOf(tobeId) || '', e2e_pass: e2e, confidence: conf.score, confidence_why: conf.why, owner: pr ? pr.owner : '', done: tg ? (tg.done || (pr ? pr.done : '')) : '', status, reason: reason.trim() });
}
const scrOut = new CsvOut(path.join(reconDir, '대사표_화면.csv'), Object.keys(scrRows[0] || { asis_id: 1 })); for (const r of scrRows) scrOut.row(r); scrOut.close();

// ── SP 대사: 개발대상 SP ∪ 파싱 SP, 화면별
const spRows = [];
const spKeys = new Map();
for (const r of tSps) spKeys.set(`${up(r.asis_id)}|${up(r.sp)}`, { asis_id: up(r.asis_id), sp: r.sp, in_xlsx: 'Y', parsed: '' });
for (const d of asisScreens) for (const r of rc(path.join(cfg.asisOutDir, 'screens', d, 'endpoints.csv'))) {
  if (r.variant === 'legacy' || r.status !== 'MATCH' || !/^SP\s/.test(r.sp_or_sql || '')) continue;
  const sp = r.sp_or_sql.replace(/^SP\s+/, '').split('.').pop(); const k = `${up(d)}|${up(sp)}`;
  if (spKeys.has(k)) spKeys.get(k).parsed = 'Y'; else spKeys.set(k, { asis_id: up(d), sp, in_xlsx: '', parsed: 'Y' });
}
for (const v of [...spKeys.values()].sort((x, y) => (x.asis_id + x.sp).localeCompare(y.asis_id + y.sp))) {
  const tobeId = a2t.get(v.asis_id) || v.asis_id; const [tp, how] = findTobeProc(v.sp, tobeId);
  const st = spStatus.find(s => up(s.ui_id) === v.asis_id && up(s.sp) === up(v.sp)); const common = /^(UP_FX_|PR_SCM_SYS|SCM0001_GET_|UP_SP_GET_COMMON)/i.test(v.sp);
  const inTarget = targets.some(t => up(t.asis_id) === v.asis_id);
  let status = tp ? 'OK' : (common ? '공통(제외)' : (inTarget ? '누락-ToBe' : '대상외'));
  let where = '';
  if (v.in_xlsx && !v.parsed) { const w = usageBy.get(up(v.sp)); where = w ? [...w].slice(0, 6).join(' ') : ''; status += w ? ' / 파싱미검출(타화면 검출)' : ' / 파싱미검출(전체 미검출)'; }
  if (!v.in_xlsx && v.parsed && !common) status += ' / 목록외';
  spRows.push({ asis_id: v.asis_id, tobe_id: tobeId, asis_sp: v.sp, in_target_list: v.in_xlsx, parsed: v.parsed, found_in_other: where, tobe_proc: tp, match: how, sp_dev_done: st ? (st.done || st.finished) : '', golden: goldenBy.get(up(v.sp)) || '', status });
}
const spOut = new CsvOut(path.join(reconDir, '대사표_SP.csv'), Object.keys(spRows[0] || { asis_id: 1 })); for (const r of spRows) spOut.row(r); spOut.close();

// ── 시트 대사: 개발대상 시트(UI_Detail) ∪ 파싱 시트(grid_effective) vs To-Be(SHEETS 상수 / 시트 메타)
const shRows = [];
const shKeys = new Map();
for (const r of tSheets) if (r.asis_id) shKeys.set(`${up(r.asis_id)}|${r.sheet}`, { asis_id: up(r.asis_id), sheet: r.sheet, in_xlsx: 'Y', kind: r.kind, md: r.md_level, parsed: '', rule: '' });
for (const d of asisScreens) for (const g of rc(path.join(cfg.asisOutDir, 'screens', d, 'grid_effective.csv'))) { const k = `${up(d)}|${g.sheet}`; if (shKeys.has(k)) { shKeys.get(k).parsed = 'Y'; shKeys.get(k).rule = g.sheet_rule; } else if (![...shKeys.keys()].some(x => x.startsWith(up(d) + '|') && x.split('|')[1].toLowerCase() === g.sheet.toLowerCase())) shKeys.set(k, { asis_id: up(d), sheet: g.sheet, in_xlsx: '', kind: '', md: '', parsed: 'Y', rule: g.sheet_rule }); else { const kk = [...shKeys.keys()].find(x => x.startsWith(up(d) + '|') && x.split('|')[1].toLowerCase() === g.sheet.toLowerCase()); shKeys.get(kk).parsed = 'Y'; shKeys.get(kk).rule = g.sheet_rule; } }
for (const v of [...shKeys.values()].sort((x, y) => (x.asis_id + x.sheet).localeCompare(y.asis_id + y.sheet))) {
  const tobeId = a2t.get(v.asis_id) || v.asis_id; const tb = tByMenu.get(tobeId);
  const consts = tb ? tConsts.filter(c => c.page_key === tb.page_key && /^SHEETS\./.test(c.name)).map(c => c.value) : [];
  const meta = metaSheets.get(tobeId) || new Set(); const n = s => s.toLowerCase().replace(/[^a-z0-9]/g, '');
  const inConst = consts.find(c => n(c) === n(v.sheet)) || '', inMeta = [...meta].find(c => n(c) === n(v.sheet)) || '';
  const inT = targets.some(t => up(t.asis_id) === v.asis_id);
  const status = inConst || inMeta ? 'OK' : (!tb ? (inT ? '누락-ToBe화면' : '대상외') : (sheetCols.length ? '누락-시트' : '미확인(메타 필요)'));
  shRows.push({ asis_id: v.asis_id, tobe_id: tobeId, sheet: v.sheet, in_target_list: v.in_xlsx, kind: v.kind, md_level: v.md, parsed: v.parsed, sheet_rule: v.rule, tobe_sheets_const: inConst, tobe_sheet_meta: inMeta, status });
}
const shOut = new CsvOut(path.join(reconDir, '대사표_시트.csv'), Object.keys(shRows[0] || { asis_id: 1 })); for (const r of shRows) shOut.row(r); shOut.close();

// ── 요약 md / html
const cntBy = (rows, k) => rows.reduce((m, r) => (m[r[k]] = (m[r[k]] || 0) + 1, m), {});
const sc = cntBy(scrRows, 'status'), ss = cntBy(spRows, 'status'), sh = cntBy(shRows, 'status');
const fmt = o => Object.entries(o).sort((x, y) => y[1] - x[1]).map(([k, v]) => `${k} ${v}`).join(' · ');
const md = [`# 개발대상 대조표 — ${new Date().toISOString().slice(0, 10)}`, '', `입력: 개발대상 ${targets.length}화면 / As-is 파싱 ${asisScreens.length}화면 / To-Be 페이지 ${tByMenu.size} / SP 메타 ${procMeta.length}행 / 시트 메타 ${sheetCols.length}행 / 패키지 PROC ${pkgProcs.size}`, '',
  `## 화면 (${scrRows.length}) — ${fmt(sc)}`, '', '| As-is | To-Be | 대상 | 파싱 | To-Be 페이지 | gen | BLOCK/WARN | GAP | 문서 | 골든 | E2E | 신뢰도 | 판정 | 사유 |', '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|',
  ...scrRows.map(r => `| ${r.asis_id} | ${r.tobe_id} | ${r.in_target} | ${r.asis_parsed} | ${r.tobe_page} | ${r.gen} | ${r.check_block_warn} | ${r.gap_score} | ${r.agent_docs} | ${r.golden_pass} | ${r.e2e_pass || r.e2e_specs} | ${r.confidence} | **${r.status}** | ${r.reason} |`),
  '', `## SP (${spRows.length}) — ${fmt(ss)}`, '', '누락-ToBe 만:', '', '| As-is | SP | 목록 | 파싱 | 상태 |', '|---|---|---|---|---|', ...spRows.filter(r => /누락/.test(r.status)).map(r => `| ${r.asis_id} | ${r.asis_sp} | ${r.in_target_list} | ${r.parsed} | ${r.status} |`),
  '', `## 시트 (${shRows.length}) — ${fmt(sh)}`, '', '누락만:', '', '| As-is | 시트 | 목록 | 파싱 | 상태 |', '|---|---|---|---|---|', ...shRows.filter(r => /누락/.test(r.status)).map(r => `| ${r.asis_id} | ${r.sheet} | ${r.in_target_list} | ${r.parsed} | ${r.status} |`),
  '', '판정: OK / 검토필요(신뢰도<70 — 사람이 볼 1%) / 누락-파싱(대상인데 Fact Pack 없음) / 누락-ToBe(대상·파싱 있는데 To-Be 없음) / 대상외(-구현됨) / ToBe신규 / 재확인(GAP<60 또는 BLOCK). SP 공통(제외)=UP_FX_/SCM0001_GET_ 등 공통 SP. 시트 "미확인(메타 필요)"= sheet_columns.csv 를 export_tobe_meta.py 로 내려받으면 재판정.'];
fs.writeFileSync(path.join(reconDir, '대사표.md'), md.join('\n') + '\n', 'utf8');
const html = `<!DOCTYPE html><html lang="ko"><head><meta charset="utf-8"><title>NSCM 개발대상 대조표</title><meta name="viewport" content="width=device-width,initial-scale=1">
<style>:root{--bg:#fff;--fg:#1a1a1a;--mut:#666;--line:#e3e3e3;--ok:#1b7f3b;--bad:#b3261e;--warn:#9a6700;--card:#f6f7f9}@media(prefers-color-scheme:dark){:root:not([data-theme=light]){--bg:#111;--fg:#eee;--mut:#aaa;--line:#333;--card:#1c1c1c}}body{margin:0;padding:16px;background:var(--bg);color:var(--fg);font:14px/1.45 system-ui,sans-serif}h1{font-size:20px;margin:0 0 8px}.tiles{display:flex;flex-wrap:wrap;gap:8px;margin:12px 0}.tile{background:var(--card);border:1px solid var(--line);border-radius:8px;padding:8px 12px;min-width:120px}.tile b{display:block;font-size:20px}.tabs button{border:1px solid var(--line);background:var(--card);color:var(--fg);padding:6px 12px;border-radius:6px;margin-right:6px;cursor:pointer}.tabs button.on{background:var(--fg);color:var(--bg)}input{padding:6px 8px;border:1px solid var(--line);border-radius:6px;background:var(--bg);color:var(--fg);min-width:220px}table{border-collapse:collapse;width:100%;margin-top:8px;font-size:13px}th,td{border-bottom:1px solid var(--line);padding:4px 6px;text-align:left;white-space:nowrap}th{cursor:pointer;position:sticky;top:0;background:var(--bg)}.OK{color:var(--ok);font-weight:600}.bad{color:var(--bad);font-weight:600}.warn{color:var(--warn);font-weight:600}.wrap{overflow:auto;max-height:75vh}</style></head><body>
<h1>NSCM 개발대상 대조표 <small style="color:var(--mut);font-weight:400">${new Date().toISOString().slice(0, 16).replace('T', ' ')}</small></h1>
<div class="tiles" id="tiles"></div><div class="tabs"><button data-t="screens" class="on">화면</button><button data-t="sps">SP</button><button data-t="sheets">시트</button> <input id="q" placeholder="필터(ID/상태/텍스트)"></div><div class="wrap"><table id="tb"></table></div>
<script>const D={screens:${JSON.stringify(scrRows)},sps:${JSON.stringify(spRows)},sheets:${JSON.stringify(shRows)}};let cur='screens',sortK=null,asc=true;const $=s=>document.querySelector(s);
const cls=v=>/^OK/.test(v)?'OK':/누락/.test(v)?'bad':/재확인|검토필요|미확인|목록외|파싱미검출/.test(v)?'warn':'';
function tiles(){const c={};D[cur].forEach(r=>c[r.status]=(c[r.status]||0)+1);$('#tiles').innerHTML=Object.entries(c).sort((a,b)=>b[1]-a[1]).map(([k,v])=>'<div class="tile '+cls(k)+'"><b>'+v+'</b>'+k+'</div>').join('')}
function render(){const q=$('#q').value.toLowerCase();let rows=D[cur].filter(r=>!q||JSON.stringify(r).toLowerCase().includes(q));if(sortK)rows=rows.slice().sort((a,b)=>{const x=a[sortK],y=b[sortK];const n=parseFloat(x)-parseFloat(y);return (isNaN(n)?String(x).localeCompare(String(y)):n)*(asc?1:-1)});const cols=Object.keys(D[cur][0]||{});$('#tb').innerHTML='<thead><tr>'+cols.map(c=>'<th data-k="'+c+'">'+c+(sortK===c?(asc?' ▲':' ▼'):'')+'</th>').join('')+'</tr></thead><tbody>'+rows.map(r=>'<tr>'+cols.map(c=>'<td class="'+(c==='status'?cls(r[c]):'')+'">'+String(r[c]??'')+'</td>').join('')+'</tr>').join('')+'</tbody>';tiles()}
document.querySelectorAll('.tabs button').forEach(b=>b.onclick=()=>{document.querySelectorAll('.tabs button').forEach(x=>x.classList.remove('on'));b.classList.add('on');cur=b.dataset.t;sortK=null;render()});$('#q').oninput=render;$('#tb').onclick=e=>{const th=e.target.closest('th');if(!th)return;if(sortK===th.dataset.k)asc=!asc;else{sortK=th.dataset.k;asc=true}render()};render();</script></body></html>`;
fs.writeFileSync(path.join(reconDir, 'index.html'), html, 'utf8');
console.log(`대사표: 화면 ${scrRows.length} (${fmt(sc)})\n       SP ${spRows.length} (${fmt(ss)})\n       시트 ${shRows.length} (${fmt(sh)})\n→ ${reconDir}\\대사표.md / index.html`);
