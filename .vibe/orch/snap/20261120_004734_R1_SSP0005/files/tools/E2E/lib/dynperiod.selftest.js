// dynperiod 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'dynperiod.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeDynPeriod: j, periodOf: p } = m.exports;
const P = { from: '202601', to: '202603' };
const eq = (a, b) => JSON.stringify(a) === JSON.stringify(b) ? { result: 'PASS', why: '' } : { result: 'FAIL', why: JSON.stringify(a) };
const cases = [
  ['월 칸 일치', j({ bindings: ['202601', '202602', '202603'], period: P }), 'PASS'], ['월 칸 누락', j({ bindings: ['202601', '202603'], period: P }), 'FAIL'], ['월 칸 초과', j({ bindings: ['202601', '202602', '202603', '202604'], period: P }), 'FAIL'], ['연도 넘김', j({ bindings: ['202512', '202601'], period: { from: '202512', to: '202601' } }), 'PASS'],
  ['칸 0개', j({ bindings: [], period: P }), 'FAIL'], ['중복', j({ bindings: ['W202601', 'W202601'], period: P }), 'FAIL'], ['역순', j({ bindings: ['202602', '202601'], period: P }), 'FAIL'], ['다른 접두 같은 날짜', j({ bindings: ['W_20270101', 'D_20270101'], period: { from: '20270101', to: '20270131' } }), 'PASS'], ['같은 접두 중복', j({ bindings: ['W_20270101', 'W_20270101'], period: P }), 'FAIL'], ['주 번호 연말 넘김', j({ bindings: ['W_20270153', 'W_20270101'], period: { from: '20261201', to: '20270131' } }), 'PASS'], ['날짜 역순', j({ bindings: ['D_20270102', 'D_20270101'], period: { from: '20270101', to: '20270131' } }), 'FAIL'], ['기간 모름', j({ bindings: ['202601'], period: null }), 'ERROR'], ['주 칸', j({ bindings: ['W20260101', 'W20260108'], period: { from: '20260101', to: '20260131' } }), 'PASS'],
  ['기간 추출', eq(p(JSON.stringify(['id', 'main', 'SEARCH', { fromSite: 'AB', fromDate: '2026-01-01', toDate: '20260131' }])), { from: '20260101', to: '20260131' }), 'PASS'], ['기간 없음', eq(p(JSON.stringify(['id', { fromSite: 'AB', toSite: 'CD' }])), null), 'PASS'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
