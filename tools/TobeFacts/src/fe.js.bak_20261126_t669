'use strict';
// To-Be FE(React + Wijmo) Fact 추출 — TypeScript 컴파일러 API 구문트리 기반. 주석은 Trivia 로만 다룬다.
const fs = require('fs');
const path = require('path');
const ts = require('typescript');
const { walk, rel, read, RE, matches, CsvOut } = require('./util');
const R = require('./fe_resolve');

const WIJMO_EVENTS = new Set(['initialized', 'formatItem', 'cellEditEnded', 'cellEditEnding', 'beginningEdit', 'prepareCellForEdit', 'selectionChanged', 'selectionChanging', 'loadedRows', 'loadingRows', 'pastingCell', 'pastedCell', 'pasting', 'pasted', 'itemsSourceChanged', 'updatingView', 'updatedView', 'scrollPositionChanged', 'sortingColumn', 'sortedColumn', 'resizedColumn', 'resizingColumn', 'draggingRow', 'draggedRow', 'draggingColumn', 'draggedColumn', 'rowEditEnded', 'rowEditEnding', 'rowAdded', 'deletingRow', 'deletedRow', 'copying', 'copied', 'keyDown', 'cellClick', 'autoSizingColumn', 'autoSizedColumn', 'groupCollapsedChanged', 'columnGroupCollapsedChanged', 'starSizedColumns', 'refreshing', 'refreshed', 'gotFocus', 'lostFocus', 'invalidInput', 'textChanged', 'valueChanged', 'selectedIndexChanged', 'isDroppedDownChanged', 'checkedChanged', 'itemClicked']);
const CONTROL_PROPS = ['name', 'field', 'id', 'label', 'title', 'binding', 'header', 'placeholder', 'type', 'value', 'variant', 'required', 'disabled', 'readOnly', 'visible', 'hidden', 'sheetName', 'menuId', 'procedureAction', 'btnCd', 'src', 'mode'];

function classify(feRoot, file) {
  const r = rel(feRoot, file);
  let m = r.match(/^features\/([^/]+)\/src\/pages\/([^/]+)\/(.*)$/);
  if (m) return { scope: 'page', feature: m[1], pageDir: m[2], pageKey: `${m[1]}/${m[2]}`, sub: m[3] };
  m = r.match(/^features\/([^/]+)\/src\/components\/([^/]+)\/?(.*)$/);
  if (m) return { scope: 'feature-component', feature: m[1], pageDir: m[2], pageKey: `${m[1]}/components/${m[2]}`, sub: m[3] };
  m = r.match(/^features\/([^/]+)\/src\/(.*)$/);
  if (m) return { scope: 'feature-misc', feature: m[1], pageDir: '', pageKey: `${m[1]}/_misc`, sub: m[2] };
  if (r.startsWith('packages/shared/')) return { scope: 'shared', feature: 'shared', pageDir: '', pageKey: 'shared', sub: r };
  if (r.startsWith('packages/foundation/')) return { scope: 'foundation', feature: 'foundation', pageDir: '', pageKey: 'foundation', sub: r };
  if (r.startsWith('apps/')) return { scope: 'web', feature: 'web', pageDir: '', pageKey: 'web', sub: r };
  return { scope: 'other', feature: '', pageDir: '', pageKey: 'other', sub: r };
}
function roleOf(sub) {
  const b = path.basename(sub).toLowerCase();
  if (b === '__asis-mapping__.md') return 'mapping';
  if (/\.test\.|\.spec\./.test(b)) return 'test';
  if (/constants?\.ts$/.test(b)) return 'constants';
  if (/types?\.ts$/.test(b)) return 'types';
  if (/store\.ts$/.test(b)) return 'store';
  if (/api\.ts$/.test(b)) return 'api';
  if (/^use[A-Z]/.test(path.basename(sub))) return 'hook';
  if (b === 'index.ts') return 'index';
  if (sub.startsWith('utils/')) return 'util';
  if (sub.startsWith('components/')) return 'component';
  if (b.endsWith('.tsx')) return 'page';
  if (b.endsWith('.scss') || b.endsWith('.css')) return 'style';
  return 'other';
}

const HEAD = {
  files: ['page_key', 'menu_id', 'scope', 'feature', 'page_dir', 'file', 'role', 'lines'],
  constants: ['page_key', 'file', 'line', 'kind', 'name', 'value'],
  endpoints: ['page_key', 'menu_id', 'file', 'line', 'in_function', 'kind', 'callee', 'menu', 'sheet', 'action', 'url', 'resolved', 'args', 'commented'],
  events: ['page_key', 'menu_id', 'file', 'line', 'in_function', 'element', 'event', 'handler', 'via'],
  controls: ['page_key', 'menu_id', 'file', 'line', 'in_function', 'component', 'props'],
  grid_columns: ['page_key', 'menu_id', 'file', 'line', 'in_function', 'context', 'binding', 'header', 'width', 'visible', 'isReadOnly', 'dataType', 'format', 'other_props', 'via'],
  messages: ['page_key', 'menu_id', 'file', 'line', 'in_function', 'code', 'via'],
  asis_refs: ['page_key', 'menu_id', 'file', 'line', 'screen_ids', 'sp_names', 'cs_lines', 'tables', 'comment'],
  commented_code: ['page_key', 'menu_id', 'file', 'line', 'kind', 'snippet'],
  asis_mapping: ['page_key', 'menu_id', 'file', 'design_id', 'summary', 'impl_location', 'reason', 'status'],
  procedures_dts: ['menu_id', 'sheet', 'request_keys', 'response_cursors', 'response_keys', 'sp_hints', 'line']
};
const IDX_HEAD = ['page_key', 'menu_id', 'feature', 'page_dir', 'files', 'endpoints', 'endpoints_unresolved', 'endpoints_propagated', 'events', 'controls', 'grid_columns_hardcoded', 'uses_meta_column', 'uses_spread_title', 'messages', 'asis_refs', 'commented_code', 'mapping_rows', 'mapping_impl', 'mapping_todo', 'mapping_excluded', 'mapping_na'];

function run(cfg, out) {
  const feRoot = cfg.feRoot, sinks = cfg.sinks;
  const files = walk(feRoot, { exts: ['.ts', '.tsx', '.md', '.scss'], skipDirs: ['node_modules', 'dist', '.turbo', 'coverage', '__mocks__'] })
    .filter(f => !/\.d\.ts$/.test(f) || /procedures\.d\.ts$/.test(f));
  const w = {}; for (const k of Object.keys(HEAD)) w[k] = new CsvOut(path.join(out, k + '.csv'), HEAD[k]);
  const sfCache = new Map();
  const SF = f => { if (!sfCache.has(f)) sfCache.set(f, ts.createSourceFile(f, read(f), ts.ScriptTarget.Latest, true, f.endsWith('x') ? ts.ScriptKind.TSX : ts.ScriptKind.TS)); return sfCache.get(f); };
  // 1) 상수 수집 (페이지 단위 + 전역)
  const constsByPage = new Map(), globalConsts = new Map();
  for (const f of files.filter(x => /\.tsx?$/.test(x) && !/\.d\.ts$/.test(x))) {
    const c = classify(feRoot, f), list = [];
    R.collectConstants(SF(f), list, rel(feRoot, f));
    if (!constsByPage.has(c.pageKey)) constsByPage.set(c.pageKey, new Map());
    const m = constsByPage.get(c.pageKey);
    for (const x of list) {
      m.set(x.name, x.value);
      if (x.kind === 'enum' || x.kind === 'object') { const t = x.name.split('.').pop(); if (!m.has(t)) m.set(t, x.value); }
      if (c.scope === 'shared' || c.scope === 'foundation') globalConsts.set(x.name, x.value);
      if (x.kind === 'proptype') continue; // 타입 보조 정보는 CSV 에 내지 않음
      w.constants.row({ page_key: c.pageKey, file: rel(feRoot, f), line: x.line, kind: x.kind, name: x.name, value: x.value });
    }
  }
  const menuIdOf = new Map();
  for (const [k, m] of constsByPage) {
    let id = m.get('MENU_ID') || '';
    if (!id) { const d = k.split('/').pop().toUpperCase().replace(/-/g, '_'); if (/^(DMF|DM|SCP|SSP|SCM|SYS|COM|SDM)\d{4}/.test(d)) id = d; }
    menuIdOf.set(k, id);
  }
  // 2) 파일별 추출
  const stats = new Map();
  const bump = (k, f, n = 1) => { if (!stats.has(k)) stats.set(k, {}); const s = stats.get(k); s[f] = (s[f] || 0) + n; };
  const fnIndexByPage = new Map();
  for (const f of files) {
    const c = classify(feRoot, f), fr = rel(feRoot, f), menuId = menuIdOf.get(c.pageKey) || '';
    if (!fnIndexByPage.has(c.pageKey)) fnIndexByPage.set(c.pageKey, { params: new Map(), calls: [], unresolved: [], menuId, pageKey: c.pageKey });
    const text = read(f);
    w.files.row({ page_key: c.pageKey, menu_id: menuId, scope: c.scope, feature: c.feature, page_dir: c.pageDir, file: fr, role: roleOf(c.sub), lines: text.split(/\r?\n/).length });
    bump(c.pageKey, 'files');
    if (fr.endsWith('__asis-mapping__.md')) { parseMapping(text, c, menuId, fr, w, bump); continue; }
    if (!/\.tsx?$/.test(f)) continue;
    if (/procedures\.d\.ts$/.test(f)) { parseProceduresDts(SF(f), fr, w); continue; }
    const consts = new Map([...globalConsts, ...(constsByPage.get(c.pageKey) || new Map())]);
    consts.set('MENU_ID', menuId || consts.get('MENU_ID') || '{MENU_ID}');
    const ctx = { sf: SF(f), fr, c, menuId, consts, w, bump, sinks, text, fnIndex: fnIndexByPage.get(c.pageKey) };
    extract(ctx); extractComments(ctx);
  }
  // 파라미터 의존 호출 전파: 래퍼 함수의 {param} 자리를 호출자의 실제 인자로 치환 (페이지 안에서만, 고정 1단계)
  let nProp = 0;
  for (const ix of fnIndexByPage.values()) {
    for (const u of ix.unresolved) {
      const params = ix.params.get(u.fn); if (!params) continue;
      const toks = [...new Set([...u.url.matchAll(/\{\??([A-Za-z_$][\w$]*)\}/g)].map(m => m[1]))].filter(tk => params.includes(tk));
      if (!toks.length) continue;
      const callers = ix.calls.filter(cl => cl.tail === u.fn && cl.file !== undefined);
      for (const cl of callers) {
        let url = u.url, ok = true;
        for (const tk of toks) { const v = cl.args[params.indexOf(tk)]; if (v == null) { ok = false; break; } url = url.split(`{?${tk}}`).join(v).split(`{${tk}}`).join(v); }
        if (!ok || /\{\?/.test(url)) continue;
        const m = url.match(/^\/?([^/]+)\/([^/]+)\/([^/]*)\/call-proc/);
        w.endpoints.row({ page_key: ix.pageKey, menu_id: ix.menuId, file: cl.file, line: cl.line, in_function: cl.from, kind: 'propagated', callee: `${u.fn}→${u.callee}`, menu: m ? m[1] : u.menu, sheet: m ? m[2] : u.sheet, action: m ? m[3] : u.action, url, resolved: 'Y', args: `via ${u.fr.split('/').pop()}:${u.line}`, commented: 0 });
        bump(ix.pageKey, 'endpoints_propagated'); nProp++;
      }
    }
  }
  console.log(`전파: 래퍼 호출 ${nProp}건 해석`);
  for (const k of Object.keys(w)) w[k].close();
  const idx = new CsvOut(path.join(out, 'screens', '_index.csv'), IDX_HEAD);
  for (const [k, s] of [...stats].sort()) {
    if (!k.includes('/')) continue;
    idx.row({ page_key: k, menu_id: menuIdOf.get(k) || '', feature: k.split('/')[0], page_dir: k.split('/').slice(1).join('/'), files: s.files || 0, endpoints: s.endpoints || 0, endpoints_unresolved: s.endpoints_unresolved || 0, endpoints_propagated: s.endpoints_propagated || 0, events: s.events || 0, controls: s.controls || 0, grid_columns_hardcoded: s.grid_columns || 0, uses_meta_column: s.meta_column ? 'Y' : '', uses_spread_title: s.spread_title ? 'Y' : '', messages: s.messages || 0, asis_refs: s.asis_refs || 0, commented_code: s.commented_code || 0, mapping_rows: s.mapping_rows || 0, mapping_impl: s.mapping_impl || 0, mapping_todo: s.mapping_todo || 0, mapping_excluded: s.mapping_excluded || 0, mapping_na: s.mapping_na || 0 });
  }
  idx.close();
  return { files: files.length, pages: [...menuIdOf.keys()].filter(k => /^[^/]+\/[^/]+$/.test(k) && !k.endsWith('_misc')).length };
}

// ─────────────── 코드 추출 ───────────────
function extract(ctx) {
  const { sf, fr, c, menuId, consts, w, bump, sinks } = ctx;
  const L = n => R.lineOf(sf, n.getStart(sf));
  const row = (k, o) => { w[k].row(Object.assign({ page_key: c.pageKey, menu_id: menuId, file: fr }, o)); bump(c.pageKey, k === 'grid_columns' ? 'grid_columns' : k); };
  const txt = (e, n = 160) => e ? e.getText(sf).replace(/\s+/g, ' ').slice(0, n) : '';
  const rvAttr = a => { if (!a.initializer) return 'true'; if (ts.isStringLiteral(a.initializer)) return a.initializer.text; const e = a.initializer.expression; if (!e) return ''; const r = R.resolve(e, sf, consts); return r.resolved ? r.value : txt(e, 60); };
  const visit = n => {
    if ((ts.isArrowFunction(n) || ts.isFunctionExpression(n) || ts.isFunctionDeclaration(n) || ts.isMethodDeclaration(n)) && ctx.fnIndex) {
      const nm = ts.isFunctionDeclaration(n) || ts.isMethodDeclaration(n) ? (n.name ? n.name.getText(sf) : '') : R.enclosingName(n.body || n, sf);
      if (nm && nm !== '(module)' && !ctx.fnIndex.params.has(nm)) ctx.fnIndex.params.set(nm, n.parameters.map(p => ts.isIdentifier(p.name) ? p.name.text : p.name.getText(sf)));
    }
    if (ts.isCallExpression(n)) onCall(n);
    else if (ts.isJsxOpeningElement(n) || ts.isJsxSelfClosingElement(n)) onJsx(n);
    else if (ts.isObjectLiteralExpression(n)) onObject(n);
    else if (ts.isStringLiteralLike(n) && RE.msgCode.test(n.text)) row('messages', { line: L(n), in_function: R.enclosingName(n, sf), code: n.text, via: n.parent && ts.isCallExpression(n.parent) ? txt(n.parent.expression, 40) : (n.parent ? ts.SyntaxKind[n.parent.kind] : '') });
    ts.forEachChild(n, visit);
  };
  function onCall(n) {
    const callee = n.expression.getText(sf).replace(/\s+/g, ''), tail = callee.split('.').pop(), fn = R.enclosingName(n, sf), A = n.arguments;
    if (ctx.fnIndex) ctx.fnIndex.calls.push({ tail, args: A.map(a => { const r = R.resolve(a, sf, consts); return r.resolved ? r.value : null; }), file: fr, line: L(n), from: fn });
    if (tail === 'addHandler' && ts.isPropertyAccessExpression(n.expression) && ts.isPropertyAccessExpression(n.expression.expression)) {
      const ev = n.expression.expression; row('events', { line: L(n), in_function: fn, element: ev.expression.getText(sf).slice(0, 60), event: ev.name.text, handler: handlerName(A[0], sf), via: 'addHandler' });
    } else if (tail === 'addEventListener' && A.length >= 2 && ts.isStringLiteralLike(A[0])) {
      row('events', { line: L(n), in_function: fn, element: callee.replace(/\.addEventListener$/, '').slice(0, 60), event: A[0].text, handler: handlerName(A[1], sf), via: 'addEventListener' });
    }
    let kind = null;
    if (sinks.callProc.includes(callee) || sinks.callProc.includes(tail)) kind = 'callProc';
    else if (sinks.hooks.includes(tail)) kind = 'hook';
    else if (sinks.http.includes(callee) || sinks.http.includes(tail)) kind = 'http';
    if (!kind) return;
    let menu = '', sheet = '', action = '', url = '', resolved = true, args = '';
    const rv = e => { if (!e) { resolved = false; return ''; } const r = R.resolve(e, sf, consts); if (!r.resolved) resolved = false; return r.value; };
    if (kind === 'callProc') {
      // 화면 로컬 래퍼 callProc(sheet, action, params) — 3번째 인자가 객체면 메뉴는 MENU_ID 로 본다
      const local = !callee.startsWith('apiClient.') && A[2] && (ts.isObjectLiteralExpression(R.stripAsConst(A[2])) || ts.isSpreadElement(A[2]) || (A.length === 3 && ts.isIdentifier(A[2]) && /payload|params|param|data|body/i.test(A[2].text)));
      if (local) { menu = menuId || rv(consts.has('MENU_ID') ? { kind: 0, getText: () => 'MENU_ID' } : null); menu = menuId; sheet = rv(A[0]); action = rv(A[1]); args = txt(A[2]); }
      else { menu = rv(A[0]); sheet = rv(A[1]); action = rv(A[2]); args = txt(A[3]); }
      url = `${menu}/${sheet}/${action}/call-proc`;
    }
    else if (kind === 'hook') {
      const o = A[0], pm = R.prop(o, 'menuId'), ps = R.prop(o, 'sheetName'), pa = R.prop(o, 'procedureAction');
      menu = pm ? rv(pm) : menuId; sheet = ps ? rv(ps) : ''; action = pa ? rv(pa) : '';
      if (/Combo|Lookup/.test(tail)) { url = `(${tail})`; resolved = true; const pf = R.prop(o, 'filters') || R.prop(o, 'src') || o; args = txt(pf, 200); }
      else { url = (sheet || action) ? `${menu}/${sheet}/${action}/call-proc` : `(${tail})`; args = txt(R.prop(o, 'filters')); }
    } else {
      url = rv(A[0]); args = txt(A[1]);
      const m = url.match(/^\/?([^/]+)\/([^/]+)\/([^/]+)\/call-proc/);
      if (m) { menu = m[1]; sheet = m[2]; action = m[3]; }
      else { const m2 = url.match(/^\/?([^/]+)\/(column|measure|search-conditions|titleSet[^/]*|combo|lookup)/); if (m2) { menu = m2[1]; action = m2[2]; } }
    }
    if (/\/column\b|titleSet/.test(url) || /column|titleSet/i.test(action)) bump(c.pageKey, 'meta_column');
    if (/spreadTitle|SPREAD_TITLE/i.test(sheet + action + url)) bump(c.pageKey, 'spread_title');
    row('endpoints', { line: L(n), in_function: fn, kind, callee, menu, sheet, action, url, resolved: resolved ? 'Y' : 'N', args, commented: 0 });
    if (!resolved) { bump(c.pageKey, 'endpoints_unresolved'); if (ctx.fnIndex) ctx.fnIndex.unresolved.push({ fr, line: L(n), fn, kind, callee, menu, sheet, action, url, args }); }
  }
  function emitEvent(n, tag, a) {
    const e = a.initializer && ts.isJsxExpression(a.initializer) ? a.initializer.expression : null;
    row('events', { line: L(a), in_function: R.enclosingName(n, sf), element: tag, event: a.name.getText(sf), handler: handlerName(e, sf), via: 'jsx' });
  }
  function onJsx(n) {
    const tag = n.tagName.getText(sf);
    if (!/^[A-Z]/.test(tag) && !tag.includes('.')) { for (const a of n.attributes.properties) if (ts.isJsxAttribute(a) && /^on[A-Z]/.test(a.name.getText(sf))) emitEvent(n, tag, a); return; }
    const props = [];
    for (const a of n.attributes.properties) {
      if (!ts.isJsxAttribute(a)) { props.push('...' + txt(a, 40).replace(/\s/g, '')); continue; }
      const name = a.name.getText(sf);
      if (/^on[A-Z]/.test(name) || WIJMO_EVENTS.has(name)) { emitEvent(n, tag, a); continue; }
      if (CONTROL_PROPS.includes(name)) props.push(`${name}=${rvAttr(a)}`);
    }
    row('controls', { line: L(n), in_function: R.enclosingName(n, sf), component: tag, props: props.join(' | ') });
    if (/Column$/.test(tag)) {
      const get = k => { const a = n.attributes.properties.find(p => ts.isJsxAttribute(p) && p.name.getText(sf) === k); return a ? rvAttr(a) : ''; };
      row('grid_columns', { line: L(n), in_function: R.enclosingName(n, sf), context: tag, binding: get('binding'), header: get('header'), width: get('width'), visible: get('visible'), isReadOnly: get('isReadOnly'), dataType: get('dataType'), format: get('format'), other_props: '', via: 'jsx' });
    }
  }
  function onObject(n) {
    const names = n.properties.filter(p => ts.isPropertyAssignment(p) || ts.isShorthandPropertyAssignment(p)).map(p => p.name.getText(sf));
    const metaShape = names.includes('colNm') && (names.includes('colLblNm') || names.includes('colWth'));
    if (!metaShape && (!names.includes('binding') || !['header', 'width', 'dataType', 'isReadOnly', 'visible'].some(k => names.includes(k)))) return;
    const K = metaShape ? { binding: 'colNm', header: 'colLblNm', width: 'colWth', visible: 'display', isReadOnly: 'editable', dataType: 'dataTpCd', format: 'fmt' } : { binding: 'binding', header: 'header', width: 'width', visible: 'visible', isReadOnly: 'isReadOnly', dataType: 'dataType', format: 'format' };
    const get = k => { const p = R.prop(n, K[k]); if (!p) return ''; const r = R.resolve(p, sf, consts); return r.resolved ? r.value : txt(p, 60); };
    let ctxName = '', p = n.parent;
    while (p && !ctxName) { if (ts.isVariableDeclaration(p) || ts.isPropertyAssignment(p)) ctxName = p.name.getText(sf); else if (ts.isFunctionDeclaration(p) && p.name) ctxName = p.name.text; p = p.parent; }
    row('grid_columns', { line: L(n), in_function: R.enclosingName(n, sf), context: ctxName, binding: get('binding'), header: get('header'), width: get('width'), visible: get('visible'), isReadOnly: get('isReadOnly'), dataType: get('dataType'), format: get('format'), other_props: names.filter(k => !Object.values(K).includes(k)).join(' '), via: metaShape ? (R.prop(n, 'colNm') && ts.isStringLiteralLike(R.stripAsConst(R.prop(n, 'colNm'))) ? 'meta-shape' : 'meta-map') : 'object' });
  }
  visit(sf);
}
function handlerName(e, sf) {
  if (!e) return '';
  e = R.stripAsConst(e);
  if (ts.isIdentifier(e) || ts.isPropertyAccessExpression(e)) return e.getText(sf);
  if (ts.isCallExpression(e)) return e.getText(sf).replace(/\s+/g, ' ').slice(0, 80);
  if (ts.isArrowFunction(e) || ts.isFunctionExpression(e)) {
    const calls = []; const v = x => { if (ts.isCallExpression(x)) calls.push(x.expression.getText(sf).replace(/\s+/g, '')); ts.forEachChild(x, v); }; v(e.body);
    return '<arrow> ' + [...new Set(calls)].slice(0, 6).join(',');
  }
  return e.getText(sf).replace(/\s+/g, ' ').slice(0, 80);
}

// ─────────────── 주석(Trivia) — 살아있는 코드와 절대 섞지 않는다 ───────────────
function extractComments(ctx) {
  const { sf, fr, c, menuId, w, bump, sinks, text } = ctx;
  const seen = new Set(), ranges = [];
  const add = rs => { if (!rs) return; for (const r of rs) if (!seen.has(r.pos)) { seen.add(r.pos); ranges.push(r); } };
  const visit = n => {
    add(ts.getLeadingCommentRanges(text, n.getFullStart()));
    add(ts.getTrailingCommentRanges(text, n.end));
    if (ts.isJsxExpression(n) && !n.expression) add(ts.getLeadingCommentRanges(text, n.getStart(sf) + 1));
    ts.forEachChild(n, visit);
  };
  visit(sf); add(ts.getLeadingCommentRanges(text, 0));
  // 주석 속 sink 호출 탐지 — crosscheck.py 와 같은 규칙(유니코드 경계, 제네릭 <...> 건너뛰기)
  const all = [...sinks.callProc, ...sinks.hooks, ...sinks.http];
  const tails = new Set([...sinks.callProc, ...sinks.hooks].map(x => x.split('.').pop())), fulls = new Set([...sinks.http, ...sinks.callProc]);
  const alts = [...new Set(all.map(x => x.split('.').pop()))].sort((a, b) => b.length - a.length).map(x => x.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
  const nameRe = new RegExp('(?<![\\p{L}\\p{N}_.$])((?:[\\p{L}\\p{N}_$]+\\s*\\.\\s*)*(?:' + alts.join('|') + '))\\s*(?=[<(])', 'gu');
  const callFollows = (code, pos) => { let j = pos; while (j < code.length && /\s/.test(code[j])) j++; if (code[j] === '<') { let d = 0; while (j < code.length) { if (code[j] === '<') d++; else if (code[j] === '>') d--; else if (j - pos > 600) return false; j++; if (d === 0) break; } while (j < code.length && /\s/.test(code[j])) j++; } return code[j] === '('; };
  const findSink = text => { nameRe.lastIndex = 0; let m; while ((m = nameRe.exec(text))) { const callee = m[1].replace(/\s+/g, ''); if ((fulls.has(callee) || tails.has(callee.split('.').pop())) && callFollows(text, m.index + m[1].length)) return callee; } return null; };
  for (const r of ranges.sort((a, b) => a.pos - b.pos)) {
    const raw = text.slice(r.pos, r.end);
    const body = raw.replace(/^\/\*+|\*+\/$/g, '').replace(/^\s*\/\/+ ?/gm, '').replace(/^\s*\* ?/gm, '');
    const line = R.lineOf(sf, r.pos);
    const ids = matches(RE.screenId, body), sps = matches(RE.spName, body).filter(s => !ids.includes(s)), cs = matches(RE.csLine, body), tbs = matches(RE.tableName, body).filter(t => !sps.includes(t));
    if (ids.length || sps.length || cs.length || tbs.length) {
      w.asis_refs.row({ page_key: c.pageKey, menu_id: menuId, file: fr, line, screen_ids: ids.join(' '), sp_names: sps.join(' '), cs_lines: cs.map(x => x.replace(/\D+/g, '')).join(' '), tables: tbs.join(' '), comment: body.replace(/\s+/g, ' ').trim().slice(0, 240) });
      bump(c.pageKey, 'asis_refs');
    }
    const sinkHit = findSink(body.replace(/\n/g, ' '));
    const codeish = sinkHit ? 'endpoint' : /<[A-Z][A-Za-z]+[\s/>]/.test(body) ? 'jsx' : (/(=>|;\s*$|\bconst\b|\breturn\b|\bawait\b)/m.test(body) && /[(){}]/.test(body)) ? 'code' : null;
    if (codeish) {
      const snippet = body.replace(/\s+/g, ' ').trim().slice(0, 240);
      w.commented_code.row({ page_key: c.pageKey, menu_id: menuId, file: fr, line, kind: codeish, snippet });
      bump(c.pageKey, 'commented_code');
      if (codeish === 'endpoint') w.endpoints.row({ page_key: c.pageKey, menu_id: menuId, file: fr, line, in_function: '', kind: 'commented', callee: sinkHit, menu: '', sheet: '', action: '', url: '', resolved: '', args: snippet.slice(0, 160), commented: 1 });
    }
  }
}

// ─────────────── __asis-mapping__.md ───────────────
function parseMapping(text, c, menuId, fr, w, bump) {
  for (const line of text.split(/\r?\n/)) {
    const m = line.match(/^\|\s*([A-Z]\d{2}-\d+-\d{3})\s*\|(.*)\|\s*$/); if (!m) continue;
    const cells = m[2].split('|').map(s => s.trim());
    const status = cells[3] || '';
    w.asis_mapping.row({ page_key: c.pageKey, menu_id: menuId, file: fr, design_id: m[1], summary: cells[0] || '', impl_location: cells[1] || '', reason: cells[2] || '', status });
    bump(c.pageKey, 'mapping_rows');
    if (status.startsWith('구현')) bump(c.pageKey, 'mapping_impl'); else if (status.startsWith('미구현')) bump(c.pageKey, 'mapping_todo'); else if (status.startsWith('제외')) bump(c.pageKey, 'mapping_excluded'); else if (status.startsWith('해당없음')) bump(c.pageKey, 'mapping_na');
  }
}

// ─────────────── procedures.d.ts ───────────────
function parseProceduresDts(sf, fr, w) {
  const text = sf.getFullText();
  const hintsAt = node => { const h = []; for (const r of ts.getLeadingCommentRanges(text, node.getFullStart()) || []) h.push(...matches(RE.spName, text.slice(r.pos, r.end))); return h; };
  const visit = n => {
    if (ts.isInterfaceDeclaration(n) && n.name.text === 'RawProcedureMap') {
      for (const m of n.members) {
        if (!ts.isPropertySignature(m) || !m.type) continue;
        const menu = m.name.getText(sf).replace(/['"]/g, ''), menuHints = hintsAt(m), sheets = [];
        const collect = t => {
          if (ts.isTypeLiteralNode(t)) { for (const s of t.members) if (ts.isPropertySignature(s) && s.type) sheets.push([s.name.getText(sf).replace(/['"]/g, ''), s.type, s]); }
          else if (ts.isIntersectionTypeNode(t)) t.types.forEach(collect);
          else if (ts.isMappedTypeNode(t)) { const keys = t.typeParameter.constraint ? t.typeParameter.constraint.getText(sf).replace(/['"\s]/g, '').split('|') : ['?']; for (const k of keys) sheets.push([k, t.type, t]); }
          else if (ts.isParenthesizedTypeNode(t)) collect(t.type);
        };
        collect(m.type);
        for (const [sheet, t, node] of sheets) {
          const req = [], cursors = [], resp = [];
          if (t && ts.isTypeLiteralNode(t)) for (const s of t.members) {
            if (!ts.isPropertySignature(s) || !s.type) continue;
            const nm = s.name.getText(sf);
            if (nm === 'request' && ts.isTypeLiteralNode(s.type)) req.push(...s.type.members.filter(x => x.name).map(x => x.name.getText(sf)));
            if (nm === 'response' && ts.isTypeLiteralNode(s.type)) for (const cu of s.type.members) { if (!ts.isPropertySignature(cu) || !cu.type) continue; cursors.push(cu.name.getText(sf)); if (ts.isTypeLiteralNode(cu.type)) resp.push(...cu.type.members.filter(x => x.name).map(x => cu.name.getText(sf) + '.' + x.name.getText(sf))); }
          }
          w.procedures_dts.row({ menu_id: menu, sheet, request_keys: req.join(' '), response_cursors: cursors.join(' '), response_keys: resp.slice(0, 80).join(' '), sp_hints: [...new Set([...hintsAt(node), ...menuHints])].join(' '), line: R.lineOf(sf, node.getStart(sf)) });
        }
      }
    }
    ts.forEachChild(n, visit);
  };
  visit(sf);
}

module.exports = { run, classify };
