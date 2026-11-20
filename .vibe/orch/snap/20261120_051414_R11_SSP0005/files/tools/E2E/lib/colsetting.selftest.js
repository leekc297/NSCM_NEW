// colsetting 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'colsetting.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeRequiredShown: s, judgeRequiredRed: r, judgeRequiredLocked: l, judgeDefaultBtn: d, judgeNoChangeOk: o, judgeApplied: ap } = m.exports;
const L = { col: 'A', stayed: true, msg: '고정', ctl: 'B', ctlMoved: true };
const cases = [
  ['표시 정상', s({ required: ['A*'], left: ['C'], right: ['A'] }), 'PASS'], ['필수가 Invisible', s({ required: ['A'], left: ['A'], right: ['C'] }), 'FAIL'], ['목록 제외 표기', s({ required: ['A', 'Z'], left: [], right: ['A'] }), 'PASS'], ['메타 없음', s({ required: [], left: [], right: ['A'] }), 'ERROR'], ['목록 못 읽음', s({ required: ['A'], left: [], right: [] }), 'ERROR'],
  ['빨강 정상', r({ required: ['A'], right: ['A', 'B'], red: ['A'] }), 'PASS'], ['빨강 없음', r({ required: ['A'], right: ['A'], red: [] }), 'FAIL'], ['비필수 빨강', r({ required: ['A'], right: ['A', 'B'], red: ['A', 'B'] }), 'FAIL'], ['대상 없음', r({ required: ['A'], right: ['B'], red: [] }), 'ERROR'],
  ['차단 정상', l(L), 'PASS'], ['이동됨', l({ ...L, stayed: false }), 'FAIL'], ['문구 없음', l({ ...L, msg: '' }), 'FAIL'], ['대조군도 안 됨', l({ ...L, ctlMoved: false }), 'ERROR'], ['시도 실패', l({ ...L, stayed: null }), 'ERROR'], ['대조군 없음', l({ ...L, ctl: '', ctlMoved: null }), 'PASS'],
];
cases.push(['Default 복원', d({ moved: true, before: ['A'], after: ['A', 'B'], ctl: 'B' }), 'PASS'], ['Default 실패', d({ moved: true, before: ['A'], after: ['A'], ctl: 'B' }), 'FAIL'], ['이동 실패', d({ moved: false, before: [], after: [], ctl: 'B' }), 'ERROR'], ['무변경 호출 0', o({ calls: 0, closed: true }), 'PASS'], ['무변경 호출', o({ calls: 2, closed: true }), 'FAIL'], ['안 닫힘', o({ calls: 0, closed: false }), 'ERROR'], ['즉시 반영', ap({ col: 'C', before: true, after: false, restored: true }), 'PASS'], ['반영 안 됨', ap({ col: 'C', before: true, after: true, restored: true }), 'FAIL'], ['전제 없음', ap({ col: 'C', before: false, after: false, restored: null }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
