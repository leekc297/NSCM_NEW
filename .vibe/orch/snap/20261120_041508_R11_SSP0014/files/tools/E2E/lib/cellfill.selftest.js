// cellfill 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'cellfill.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeFill: j } = m.exports;
const B = { src: 'A', tgt: 'B', v: 'a1', got: 'b1' };
const cases = [
  ['빈 값·기존 행 값 있음', j({ ...B, got: '', peer: { n: 2, values: ['b1'] } }), 'FAIL'], ['빈 값·기존 행도 빈 값', j({ ...B, got: '', peer: { n: 2, values: [] } }), 'PASS'], ['빈 값·기존 행 없음', j({ ...B, got: '' }), 'ERROR'], ['복사 일치', j({ ...B, copyFrom: 'C', copyVal: 'b1' }), 'PASS'], ['복사 불일치', j({ ...B, copyFrom: 'C', copyVal: 'x' }), 'FAIL'],
  ['기존 행 일치', j({ ...B, peer: { n: 3, values: ['b1', 'b2'] } }), 'PASS'], ['기존 행 불일치', j({ ...B, peer: { n: 3, values: ['z'] } }), 'ERROR'], ['기존 행 없음', j({ ...B, peer: { n: 0, values: [] } }), 'PASS'], ['대조 없음', j(B), 'PASS'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
