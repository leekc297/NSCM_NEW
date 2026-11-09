// layout2 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'layout2.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeHeaderHeight: hh, judgeScroll: sc, judgeHeaderFit: hf, judgeCandDash: cd, judgeAllSearch: al, judgeTypingStable: ty, judgeFilterItems: fi, judgeBodyDiff: bd } = m.exports;
const S = n => ({ name: 'a', h: n }); const A = { allFields: ['T'], sent: true, dialog: '', rows: 3 }; const T = { typed: true, idle: 0, typing: 0, moved: false };
const cases = [
  ['높이 유지', hh({ steps: [S(40), S(40.5)] }), 'PASS'], ['높이 변함', hh({ steps: [S(40), S(60)] }), 'FAIL'], ['1회만', hh({ steps: [S(40), S(0)] }), 'ERROR'],
  ['스크롤 없음', sc({ page: false, nested: [], rows: 5 }), 'PASS'], ['페이지 스크롤', sc({ page: true, nested: [], rows: 5 }), 'FAIL'], ['중첩 스크롤', sc({ page: false, nested: ['x'], rows: 5 }), 'FAIL'], ['0행', sc({ page: false, nested: [], rows: 0 }), 'ERROR'],
  ['헤더 정상', hf({ seen: 5, clipped: [] }), 'PASS'], ['헤더 잘림', hf({ seen: 5, clipped: ['A'] }), '판정필요'], ['렌더 0', hf({ seen: 0, clipped: [] }), 'ERROR'],
  ['후보 정상', cd({ fields: [{ name: 'A', opts: ['-', 'x'] }] }), 'PASS'], ['후보 - 일색', cd({ fields: [{ name: 'A', opts: ['-', '-'] }] }), 'FAIL'], ['후보 / 일색', cd({ fields: [{ name: 'A', opts: ['/'] }] }), 'FAIL'], ['콤보 없음', cd({ fields: [] }), 'NA'],
  ['ALL 정상', al(A), 'PASS'], ['필수 안내', al({ ...A, dialog: '필수 항목을 선택하세요' }), 'FAIL'], ['영문 안내', al({ ...A, dialog: 'Please select Team' }), 'FAIL'], ['요청 없음', al({ ...A, sent: false }), 'ERROR'], ['ALL 없음', al({ ...A, allFields: [] }), 'NA'],
  ['입력 안정', ty(T), 'PASS'], ['대조군 수준', ty({ ...T, idle: 2, typing: 2 }), 'PASS'], ['재렌더', ty({ ...T, typing: 3 }), 'FAIL'], ['스크롤 이동', ty({ ...T, moved: true }), 'FAIL'], ['입력칸 없음', ty({ ...T, typed: false }), 'NA'], ['측정 실패', ty({ ...T, why: 'x' }), 'ERROR'],
];
const FI = { b: 'C', items: ['a', 'b', '(Blanks)'], distinct: 2, blanksInGrid: true }; const BD = { sent: true, same: [], changed: ['K'], typed: true };
cases.push(['필터 정상', fi(FI), 'PASS'], ['공란류 2개', fi({ ...FI, items: ['a', 'b', '(Blanks)', ''] }), 'FAIL'], ['후보 잘림', fi({ ...FI, distinct: 3 }), 'FAIL'], ['측정 실패', fi({ ...FI, why: 'x' }), 'ERROR'], ['본문 정상', bd(BD), 'PASS'], ['재조회 달라짐', bd({ ...BD, same: ['F'] }), 'FAIL'], ['변경 무반영', bd({ ...BD, changed: [] }), 'FAIL'], ['여러 키', bd({ ...BD, changed: ['K', 'F'] }), 'ERROR'], ['입력칸 없음', bd({ ...BD, typed: false, changed: [] }), 'PASS'], ['본문 없음', bd({ ...BD, sent: false }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
