// inputcheck 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'inputcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeBadInput: b, judgeDecimal: d } = m.exports;
const B = { typed: true, bad: 'ZZZ', shown: '', calls: 0, body: '', msg: '', truncated: false }; const D = { typed: true, val: '1.5', shown: '1.5', calls: 1, body: '"V":"1.5"', msg: '', truncated: false };
const cases = [
  ['규칙 밖 값 저장됨', b({ ...B, calls: 1, body: '"X":"ZZZ"' }), 'FAIL'], ['저장 전 차단', b(B), 'PASS'], ['값 버리고 저장', b({ ...B, calls: 1, body: '"X":""' }), 'PASS'], ['입력 불가', b({ ...B, typed: false }), 'ERROR'], ['본문 잘림', b({ ...B, calls: 1, truncated: true }), 'ERROR'],
  ['소수 보존', d(D), 'PASS'], ['소수 잘림', d({ ...D, body: '"V":"15"' }), 'FAIL'], ['소수 차단', d({ ...D, calls: 0 }), 'ERROR'], ['소수 입력 불가', d({ ...D, typed: false }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
