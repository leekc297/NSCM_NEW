// sumcheck 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'sumcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeSum: j } = m.exports;
const cases = [
  ['합계 일치', j({ kind: '푸터', shown: { A: 10 }, sums: { A: 10 }, rows: 2 }), 'PASS'], ['합계 틀림', j({ kind: '푸터', shown: { A: 11 }, sums: { A: 10 }, rows: 2 }), 'FAIL'], ['합계 없음', j({ kind: '없음', shown: {}, sums: {}, rows: 2 }), 'NA'], ['칸 전부 공란', j({ kind: '푸터', shown: { A: null }, sums: { A: 1 }, rows: 2 }), 'NA'], ['반올림 허용', j({ kind: '푸터', shown: { A: 10.001 }, sums: { A: 10 }, rows: 2 }), 'PASS'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
