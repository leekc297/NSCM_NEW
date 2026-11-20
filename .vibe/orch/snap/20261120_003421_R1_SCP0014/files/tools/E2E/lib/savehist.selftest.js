// 이력·2회 저장 판정 변이 입증(2026-11-01 EG235·EG237·EG240) — 결함 스냅샷에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'savecheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { diffSnap, judgeHistory, judgeHistValues, judgeTwice, judgeSaveTime: st, judgeMaxValue: mv } = m.exports;
const T = (rows, hist) => ({ skipped: {}, tables: { T: { keys: ['K'], pk: ['K'], n: rows.length, rows }, ...(hist ? { T_H: { keys: ['K'], pk: ['S'], n: hist.length, rows: hist } } : {}) } });
const r = (o) => ({ K: 'A', V: '1', LAST_UPDATE_DATE: 't0', ...o }); const h = (o) => ({ S: '1', K: 'A', V: '1', HISTORY_CREATION_DATE: 't0', ...o });
const a = T([r({})], []);
const good = T([r({ V: '2', LAST_UPDATE_DATE: 't1' })], [h({ V: '2' })]);
const noHist = T([r({ V: '2', LAST_UPDATE_DATE: 't1' })], []);
const wrongHist = T([r({ V: '2', LAST_UPDATE_DATE: 't1' })], [h({ V: '9' })]);
const oldHist = T([r({ V: '2', LAST_UPDATE_DATE: 't1' })], [h({ V: '1' })]);
const dup = T([r({}), { K: 'B', V: '1', LAST_UPDATE_DATE: 't1' }], []);
const noTable = T([r({ V: '2' })]);
const cases = [
  ['저장 느림', st([4000, 3500]), 'FAIL'], ['저장 빠름(부하 1회 제외)', st([9000, 800]), 'PASS'], ['기록 없음', st([]), 'ERROR'], ['경계값 정상', mv({ called: true, err: '', ok: true, got: '9', val: '9', msg: '' }), 'PASS'], ['경계값 오류', mv({ called: true, err: 'ORA-01438', ok: false, got: '', val: '9', msg: '' }), 'FAIL'], ['경계값 잘림', mv({ called: true, err: '', ok: false, got: '8', val: '9', msg: '' }), 'FAIL'], ['경계값 차단', mv({ called: false, err: '', ok: false, got: '', val: '9', msg: 'x' }), 'ERROR'], ['이력 행 생성', judgeHistory(diffSnap(a, good), {}), 'PASS'], ['이력 행 없음', judgeHistory(diffSnap(a, noHist), {}), 'FAIL'], ['이력 표 없음', judgeHistory(diffSnap(T([r({})]), noTable), {}), 'ERROR'],
  ['이력 값 일치(변경 후)', judgeHistValues(diffSnap(a, good)), 'PASS'], ['이력 값 일치(변경 전 값 보관)', judgeHistValues(diffSnap(a, oldHist)), 'PASS'], ['이력 값 다름', judgeHistValues(diffSnap(a, wrongHist)), 'FAIL'], ['이력 행 없음 값 판정', judgeHistValues(diffSnap(a, noHist)), 'ERROR'],
  ['2회 저장 행 수 불변', judgeTwice(diffSnap(a, T([r({ LAST_UPDATE_DATE: 't2' })], [h({}), h({ S: '2' })])), 2), 'PASS'], ['2회 저장 중복 행', judgeTwice(diffSnap(a, dup), 2), 'FAIL'], ['저장 1회뿐', judgeTwice(diffSnap(a, good), 1), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.evidence}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
