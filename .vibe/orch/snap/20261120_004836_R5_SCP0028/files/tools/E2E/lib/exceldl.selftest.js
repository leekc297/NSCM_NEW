// exceldl 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'exceldl.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeHeaders: h, judgeCodeName: c, judgeFreeze: f, judgeNumFmt: n } = m.exports;
const cases = [
  ['머리글 일치', h({ file: ['A*', 'B'], screen: ['A', 'B'] }), 'PASS'], ['파일에 없음', h({ file: ['A'], screen: ['A', 'B'] }), 'FAIL'], ['화면에 없음', h({ file: ['A', 'C'], screen: ['A'] }), 'FAIL'], ['머리글 0', h({ file: [], screen: ['A'] }), 'ERROR'],
  ['Name', c([{ col: 'X', file: 'One', disp: 'One', raw: '1' }]), 'PASS'], ['코드', c([{ col: 'X', file: '1', disp: 'One', raw: '1' }]), 'FAIL'], ['대상 없음', c([{ col: 'X', file: 'a', disp: 'a', raw: 'a' }]), 'NA'],
  ['틀 고정', f({ freeze: 'A2' }), 'PASS'], ['틀 고정 없음', f({ freeze: null }), 'FAIL'],
  ['서식 있음', n({ numCells: 3, general: 1, samples: ['#,##0'] }), 'PASS'], ['전부 General', n({ numCells: 3, general: 3, samples: ['General'] }), 'FAIL'], ['숫자 없음', n({ numCells: 0, general: 0, samples: [] }), 'NA'],
];
let bad = 0; for (const [nmz, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${nmz} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
