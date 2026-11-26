// rowlink.ts T555·T557·T558 순수 함수 변이 입증(2026-11-25 SCP0005 U4a) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ROOT = path.join(__dirname, '..', '..', '..');
const ts = require(path.join(ROOT, 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'rowlink.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require);
const { emptyLike, sameRestore, sheetOfGrid, sheetCols, cellRuleOf, pickFreeInt } = m.exports;
const csv = (t) => { const s = t.replace(/^﻿/, '').split(/\r?\n/).filter(Boolean); const h = s[0].split(','); return s.slice(1).map(l => { const c = l.split(','); const o = {}; h.forEach((k, i) => o[k] = c[i] ?? ''); return o; }); };
const sc = csv(fs.readFileSync(path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv'), 'utf8')).filter(r => r.program_id === 'SCP0005');
const grid = sc.filter(r => r.sheet_name === 'Distribution Route').map(r => r.column_name);
const S = sheetCols(sc, grid, 'S'); const allS = new Set(sc.filter(r => r.input_tp_cd === 'S').map(r => r.column_name));
const cr = csv(fs.readFileSync(path.join(ROOT, 'Doc', 'asisfacts', 'screens', 'SCP0005', 'cell_rules.csv'), 'utf8'));
const J = (a) => JSON.stringify(a);
const cases = [
  ["emptyLike '/'", emptyLike('/'), true], ["emptyLike '-'", emptyLike('-'), true], ["emptyLike ''", emptyLike(''), true], ['emptyLike null', emptyLike(null), true],
  ["변이: emptyLike 'AVERAGE'", emptyLike('AVERAGE'), false], ["변이: emptyLike '0'", emptyLike('0'), false], ["변이: emptyLike '//'", emptyLike('//'), false],
  ["sameRestore '/' ↔ ''", sameRestore('/', ''), true], ["sameRestore '-' ↔ '/'", sameRestore('-', '/'), true], ["sameRestore '1,000' ↔ '1000'", sameRestore('1,000', '1000'), true],
  ["변이: sameRestore '/' ↔ 'AVERAGE'", sameRestore('/', 'AVERAGE'), false], ["변이: sameRestore '' ↔ '0'", sameRestore('', '0'), false],
  ['SCP0005 그리드 시트 = Distribution Route(실데이터)', sheetOfGrid(sc, grid), 'Distribution Route'],
  ['SCP0005 S 칸 = 8(ROUTE_ID·도시명 2·LT_SUM·감사 4)', S.size, 8],
  ['변이: 프로그램 전체 S 에는 LT_TYPE 이 들어감(종전 결함 재현)', allS.has('LT_TYPE'), true],
  ['시트 한정 S 에 LT_TYPE·PRIORITY·D_PORT_NAME 없음', [...S].some(c => ['LT_TYPE', 'PRIORITY', 'D_PORT_NAME', 'TRANSPORT_MODE'].includes(c)), false],
  ['시트 한정 S 에 ROUTE_ID 있음', S.has('ROUTE_ID'), true],
  ['팝업 그리드 칸이면 route 시트', sheetOfGrid(sc, sc.filter(r => r.sheet_name === 'route').map(r => r.column_name)), 'route'],
  ['빈 메타 = 빈 집합', sheetCols([], grid, 'S').size, 0],
  ['PRIORITY 규칙 0~99(SCP0005_DistributionRoute.cs:249)', J(cellRuleOf(cr, 'PRIORITY')), J({ min: 0, max: 99, maxLength: null })],
  ['D_COUNTRY 글자 수 2', cellRuleOf(cr, 'D_COUNTRY').maxLength, 2],
  ['대소문자 무시 One_SEGMENT_COST', cellRuleOf(cr, 'One_SEGMENT_COST').min, null],
  ['규칙 없는 칸', J(cellRuleOf(cr, 'NO_SUCH')), J({ min: null, max: null, maxLength: null })],
  ['pickFreeInt 1~99 중 1,2 사용 → 3', pickFreeInt([1, 2], 0, 99), 3],
  ['pickFreeInt 하한 0 이어도 1부터', pickFreeInt([], 0, 99), 1],
  ['변이: 1~99 전부 사용 → null', pickFreeInt(Array.from({ length: 99 }, (_, i) => i + 1), 0, 99), null],
  ['범위 없음 = 최대+1', pickFreeInt([5, 7], null, null), 8],
  ['변이: 결과가 상한을 넘지 않음(종전 99+1=100 결함)', pickFreeInt([99], 0, 99) <= 99, true],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}(기대 ${want})`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
