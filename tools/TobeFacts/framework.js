#!/usr/bin/env node
'use strict';
// framework — To-Be 프레임워크·공통 카탈로그: @foundation / @shared / features/master/src/components(공통 모달·조회조건) / apps/web mdi 의 export 를
//   TypeScript 컴파일러 API 로 추출해 "무엇이 있고(이름·종류·import 경로), 어떻게 쓰며(시그니처·props·JSDoc), 얼마나 쓰이는지(features 사용 수), As-is 무엇에 대응하는지(룰 사전)" 를 한 곳에 정리한다.
//   node framework.js [--config tobefacts.json]
//   산출: <outDir>/framework/framework.csv · components.md · hooks.md · stores.md · apis.md · utils.md · types.md · INDEX.md
//         <rulesDir>/tobe_catalog.csv (name,kind,import_from,file,usage,asis_types) — check.js D01(사전 밖 컴포넌트)·Claude 프롬프트가 참조
const fs = require('fs'); const path = require('path');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'tobefacts.json')), 'utf8').replace(/^﻿/, ''));
try { require.resolve('typescript'); } catch (_) { process.env.NODE_PATH = [path.join(cfg.feRoot, 'node_modules'), process.env.NODE_PATH || ''].filter(Boolean).join(path.delimiter); require('module').Module._initPaths(); }
const ts = require('typescript');
const { CsvOut, readCsv } = require('./src/util');
const FE = cfg.feRoot; const outDir = path.join(cfg.outDir, 'framework'); fs.mkdirSync(outDir, { recursive: true });
const rulesDir = cfg.rulesDir || path.join(__dirname, '..', 'Harness', 'rules');
const walk = d => fs.existsSync(d) ? fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.name === 'node_modules' || e.name.startsWith('.') ? [] : e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]) : [];
// 스캔 영역 → import 별칭
const AREAS = [
  { root: 'packages/foundation/src', alias: p => '@foundation/' + p.split('/')[0], layer: 'foundation' },
  { root: 'packages/shared/src', alias: p => '@shared/' + p.split('/')[0], layer: 'shared' },
  { root: 'features/master/src/components', alias: () => "features/master/src/components", layer: 'master-common' },
  { root: 'apps/web/src/mdi', alias: () => 'apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)', layer: 'app-shell' },
];
const norm = f => f.replace(/\\/g, '/'); // TypeScript 는 경로를 '/' 로 정규화 — Windows 백슬래시 경로로 getSourceFile 하면 undefined
const files = AREAS.flatMap(ar => walk(path.join(FE, ar.root)).filter(f => /\.(ts|tsx)$/.test(f) && !/\.(test|spec|stories)\.tsx?$/.test(f) && !/\.d\.ts$/.test(f)).map(f => ({ f: norm(f), ar })));
const program = ts.createProgram(files.map(x => x.f), { jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2022, module: ts.ModuleKind.ESNext, allowJs: false, skipLibCheck: true, noResolve: true });
const checker = program.getTypeChecker();
const rows = [];
const jsdoc = node => { const d = ts.getJSDocCommentsAndTags(node).map(j => (j.comment && typeof j.comment === 'string' ? j.comment : (j.comment || []).map(c => c.text || '').join(''))).filter(Boolean).join(' '); if (d) return d; const lead = ts.getLeadingCommentRanges(node.getSourceFile().getFullText(), node.getFullStart()) || []; return lead.map(r => node.getSourceFile().getFullText().slice(r.pos, r.end)).join(' ').replace(/^\/\*+|\*+\/$|^\/\/+/gm, '').replace(/^\s*\*\s?/gm, '').replace(/\s+/g, ' ').trim(); };
const typeText = t => { try { return checker.typeToString(t, undefined, ts.TypeFormatFlags.NoTruncation | ts.TypeFormatFlags.UseAliasDefinedOutsideCurrentScope).slice(0, 400); } catch { return ''; } };
const isUpper = s => /^[A-Z]/.test(s);
const kindOf = (name, node, sf) => {
  if (ts.isInterfaceDeclaration(node) || ts.isTypeAliasDeclaration(node)) return 'type'; if (ts.isEnumDeclaration(node)) return 'enum'; if (ts.isClassDeclaration(node)) return 'class';
  if (/^use[A-Z]\w*Store$/.test(name)) return 'store'; if (/^use[A-Z]/.test(name)) return 'hook';
  if (/\.tsx$/.test(sf.fileName) && isUpper(name)) return 'component';
  if (ts.isVariableDeclaration(node) && node.initializer && (ts.isArrowFunction(node.initializer) || ts.isFunctionExpression(node.initializer)) || ts.isFunctionDeclaration(node)) return isUpper(name) ? 'component' : 'function';
  if (ts.isVariableDeclaration(node) && node.initializer && ts.isObjectLiteralExpression(node.initializer)) return 'namespace-object';
  return isUpper(name) && /^[A-Z_0-9]+$/.test(name) ? 'constant' : 'value';
};
const propsOf = (sym, node) => {
  // 컴포넌트/함수: 첫 매개변수 타입의 멤버
  try { const t = checker.getTypeOfSymbolAtLocation(sym, node); const sigs = t.getCallSignatures(); if (!sigs.length) return { sig: '', props: [] };
    const sig = sigs[0]; const sigText = checker.signatureToString(sig, undefined, ts.TypeFormatFlags.NoTruncation).slice(0, 500);
    const p0 = sig.getParameters()[0]; if (!p0) return { sig: sigText, props: [] };
    const pt = checker.getTypeOfSymbolAtLocation(p0, node); const props = pt.getProperties().slice(0, 60).map(p => { const d = p.getDeclarations && p.getDeclarations()[0]; const opt = !!(p.flags & ts.SymbolFlags.Optional); const tt = d ? typeText(checker.getTypeOfSymbolAtLocation(p, d)) : ''; const doc = ts.displayPartsToString(p.getDocumentationComment(checker)).replace(/\s+/g, ' ').slice(0, 160); return `${p.getName()}${opt ? '?' : ''}: ${tt.slice(0, 80)}${doc ? ' — ' + doc : ''}`; });
    return { sig: sigText, props }; } catch { return { sig: '', props: [] }; }
};
for (const { f, ar } of files) {
  const sf = program.getSourceFile(f); if (!sf) continue; const modSym = checker.getSymbolAtLocation(sf); if (!modSym) continue;
  const rel = path.relative(FE, f).replace(/\\/g, '/'); const sub = path.relative(path.join(FE, ar.root), f).replace(/\\/g, '/');
  let exports = []; try { exports = checker.getExportsOfModule(modSym); } catch { continue; }
  for (const ex of exports) {
    let sym = ex; if (sym.flags & ts.SymbolFlags.Alias) { try { sym = checker.getAliasedSymbol(sym); } catch { } }
    const decl = (sym.getDeclarations() || [])[0]; if (!decl) continue; if (norm(decl.getSourceFile().fileName) !== f) continue; // 재export 는 원본에서 1회
    const name = ex.getName(); if (name === 'default') continue;
    const node = ts.isVariableDeclaration(decl) || ts.isFunctionDeclaration(decl) || ts.isInterfaceDeclaration(decl) || ts.isTypeAliasDeclaration(decl) || ts.isEnumDeclaration(decl) || ts.isClassDeclaration(decl) ? decl : decl;
    const kind = kindOf(name, node, sf); const { sig, props } = /component|hook|function|store/.test(kind) ? propsOf(sym, node) : { sig: '', props: [] };
    const docText = (jsdoc(ts.isVariableDeclaration(node) ? node.parent.parent : node) || ts.displayPartsToString(sym.getDocumentationComment(checker))).replace(/[=\-─]{5,}/g, ' ').replace(/\s+/g, ' ').trim();
    rows.push({ layer: ar.layer, kind, name, import_from: ar.alias(sub), file: rel, line: sf.getLineAndCharacterOfPosition(node.getStart()).line + 1, signature: sig.replace(/\s+/g, ' '), props: props.join(' | '), doc: docText.slice(0, 300), usage: 0, asis_types: '' });
  }
}
// 사용 수: features/*/src/pages 에서 import 된 횟수(이름 단위)
const pageFiles = walk(path.join(FE, 'features')).filter(f => /\/src\/pages\/.*\.tsx?$/.test(f.replace(/\\/g, '/')) && !/\.(test|spec)\./.test(f));
const importText = pageFiles.map(f => fs.readFileSync(f, 'utf8').match(/^import[\s\S]*?from\s+['"][^'"]+['"];?/gm) || []).flat().join('\n');
for (const r of rows) { const re = new RegExp(`\\b${r.name}\\b`, 'g'); r.usage = (importText.match(re) || []).length; }
// As-is 대응(룰 사전)
const mapCtl = readCsv(path.join(rulesDir, 'map_control.csv')), mapFld = readCsv(path.join(rulesDir, 'map_field.csv')), mapBtn = readCsv(path.join(rulesDir, 'map_button.csv'));
for (const r of rows) { const s = new Set(); for (const m of mapCtl) if (m.tobe_component === r.name) s.add(m.asis_type); for (const m of mapFld) if (m.field === r.name) s.add('field:' + m.name_pattern); for (const m of mapBtn) if ((m.modal || '') === r.name || (m.tobe || '').includes(r.name)) s.add('button:' + m.name_pattern); r.asis_types = [...s].join(' / '); }
rows.sort((x, y) => x.layer.localeCompare(y.layer) || x.kind.localeCompare(y.kind) || y.usage - x.usage || x.name.localeCompare(y.name));
// CSV
const out = new CsvOut(path.join(outDir, 'framework.csv'), ['layer', 'kind', 'name', 'import_from', 'file', 'line', 'usage', 'asis_types', 'signature', 'props', 'doc']); for (const r of rows) out.row(r); out.close();
const cat = new CsvOut(path.join(rulesDir, 'tobe_catalog.csv'), ['name', 'kind', 'import_from', 'file', 'usage', 'asis_types']); for (const r of rows.filter(r => /component|hook|store|function|namespace-object/.test(r.kind))) cat.row(r); cat.close();
// MD (종류별)
const esc = s => String(s || '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
const groups = { components: ['component'], hooks: ['hook'], stores: ['store'], apis: ['namespace-object', 'class'], utils: ['function', 'constant', 'value', 'enum'], types: ['type'] };
const idx = [`# To-Be 프레임워크·공통 카탈로그 (TobeFacts framework.js ${new Date().toISOString().slice(0, 10)})`, '', `원천: ${AREAS.map(a => a.root).join(' · ')} — export ${rows.length}건. 사용 수 = features/*/src/pages 의 import 등장 횟수. As-is 대응 = tools/Harness/rules 사전.`, '', '| 파일 | 종류 | 건수 | 많이 쓰는 것 |', '|---|---|---|---|'];
for (const [g, kinds] of Object.entries(groups)) {
  const list = rows.filter(r => kinds.includes(r.kind)); if (!list.length) continue;
  const md = [`# ${g} (${list.length})`, '', '사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).', ''];
  for (const layer of [...new Set(list.map(r => r.layer))]) {
    md.push(`## ${layer}`, '', '| 이름 | import | 사용 | As-is 대응 | 설명 |', '|---|---|---|---|---|');
    for (const r of list.filter(r => r.layer === layer)) md.push(`| **${r.name}** | \`${esc(r.import_from)}\` | ${r.usage} | ${esc(r.asis_types)} | ${esc(r.doc).slice(0, 140)} |`);
    md.push('');
    for (const r of list.filter(r => r.layer === layer && (r.signature || r.props))) { md.push(`### ${r.name}  <sub>${r.file}:${r.line}</sub>`, ''); if (r.signature) md.push('```ts', r.signature.slice(0, 600), '```'); if (r.props) md.push('', 'props/params:', '', ...r.props.split(' | ').map(p => `- \`${p}\``)); md.push(''); }
  }
  fs.writeFileSync(path.join(outDir, `${g}.md`), md.join('\n'), 'utf8');
  idx.push(`| [${g}.md](${g}.md) | ${kinds.join(', ')} | ${list.length} | ${list.slice(0, 8).map(r => r.name).join(', ')} |`);
}
idx.push('', '## 화면 개발 표준 (카탈로그 적용 규칙)', '', '- 조회조건: `features/master/src/components/searchFields` 의 *Field 카탈로그(13종) 우선 → 없으면 `FormItem + CustomDropdown/InputField/DatePickerCalendar`(룰 25 §1.5.4). 직접 `<label>/<input>` 금지.', '- 공통 모달: `features/master/src/components` 의 *Modal/*Popup(Item/Project/Owner/Customer/Team/Region/StorageLocation/Material…) 재사용 — 화면 종속 팝업만 `components/modals/`.', '- 조회/저장: `useTabProcQuery<MENU_ID>` / `useProcMutation<MENU_ID>` / `useTabComboQueries` — `apiClient` 직접 호출 금지.', '- 그리드: `DataGrid`(@shared/components) + `GridAction`(@foundation/utils) addRow/removeRow, 컬럼은 메타(/admin/menu/{MENU}/column) + `staticColumns`.', '- 알림: `useMessageStore`(@shared/stores) setAlert/confirm — `window.alert` 금지. 세션: `useSessionStore`.', '- 타이틀/버튼: `MainTitle` + `SubTitle hotkeyConfig`(search/save/insert/delete/upload/manual 명시, condition/resetCondition 는 UsrConditionPanel 유무).');
fs.writeFileSync(path.join(outDir, 'INDEX.md'), idx.join('\n') + '\n', 'utf8');
const byKind = rows.reduce((m, r) => (m[r.kind] = (m[r.kind] || 0) + 1, m), {});
console.log(`framework: export ${rows.length} (${Object.entries(byKind).map(([k, v]) => `${k} ${v}`).join(', ')}) → ${outDir}  · 카탈로그 ${rulesDir}/tobe_catalog.csv`);
