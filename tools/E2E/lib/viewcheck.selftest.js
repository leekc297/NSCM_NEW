// viewcheck 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'viewcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeDivCols: d, judgeLayout: l } = m.exports;
const E = { A: '기본', B: '숨김', C: '선택', D: '', E: '필수' };
const R = (label, x, y, w = 100, h = 30) => ({ label, x, y, w, h });
const cases = [
  ['컬럼 일치', d({ div: '40', expect: E, visible: ['A', 'E', 'C'], gridOk: true }), 'PASS'], ['선택 컬럼 없어도 일치', d({ div: '40', expect: E, visible: ['A', 'E'], gridOk: true }), 'PASS'], ['기본 컬럼 누락', d({ div: '40', expect: E, visible: ['E'], gridOk: true }), 'FAIL'], ['숨김 컬럼 노출', d({ div: '40', expect: E, visible: ['A', 'E', 'B'], gridOk: true }), 'FAIL'], ['다른 Div 컬럼 노출', d({ div: '40', expect: E, visible: ['A', 'E', 'D'], gridOk: true }), 'FAIL'], ['이름 달라도 라벨 같음', d({ div: '40', expect: { A40: '기본' }, visible: ['A'], gridOk: true, labels: { A40: 'End Customer*' }, shownLabels: ['End Customer'] }), 'PASS'], ['라벨도 없음', d({ div: '40', expect: { A40: '기본' }, visible: ['A'], gridOk: true, labels: { A40: 'End Customer' }, shownLabels: ['Other'] }), 'FAIL'], ['숨김 이름이 보이나 표시 컬럼과 라벨 같음', d({ div: '40', expect: { A40: '기본', A: '숨김' }, visible: ['A'], gridOk: true, labels: { A40: 'X', A: 'X' }, shownLabels: ['X'] }), 'PASS'], ['그리드 못 읽음', d({ div: '40', expect: E, visible: [], gridOk: false }), 'ERROR'], ['기대 없음', d({ div: '40', expect: { C: '선택' }, visible: ['C'], gridOk: true }), 'ERROR'],
  ['겹침 없음', l({ width: 1000, rects: [R('a', 0, 0), R('b', 100, 0)], overflowX: false }), 'PASS'], ['겹침', l({ width: 1000, rects: [R('a', 0, 0), R('b', 50, 0)], overflowX: false }), 'FAIL'], ['화면 밖', l({ width: 1000, rects: [R('a', 950, 0)], overflowX: false }), 'FAIL'], ['칸 없음', l({ width: 1000, rects: [], overflowX: false }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
