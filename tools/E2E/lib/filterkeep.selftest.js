// filterkeep 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'filterkeep.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeFilterKeep: j } = m.exports;
const B = { n0: 100, n1: 10, n2: 10, n3: 100, label: 'Total: 10 / 100', why: '' };
const cases = [
  ['정상', j(B), 'PASS'], ['건수 표시 없음', j({ ...B, label: '' }), 'PASS'], ['필터 풀림', j({ ...B, n2: 100 }), 'FAIL'], ['건수 불일치', j({ ...B, label: 'Total: 100 / 100' }), 'FAIL'], ['해제 안 됨', j({ ...B, n3: 10 }), 'FAIL'], ['필터 효과 없음', j({ ...B, n1: 100 }), 'ERROR'], ['측정 실패', j({ ...B, why: 'x' }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
