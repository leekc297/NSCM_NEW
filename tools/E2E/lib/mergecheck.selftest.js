// mergecheck 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'mergecheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeHierMerge: h, judgeMergeInput: i, judgeMergeDelete: d, judgeNewRowMerge: n, judgeRestore: r } = m.exports;
const I = { how: '입력', b: 'C', opened: true, want: '1000', before: '5', after: '1,000', span0: 3, span1: 3 };
const D = { b: 'C', cruds: ['D', 'D', 'D'], outD: 0, posts: 0 };
const R = { b: 'C', v0: 'a', v1: 'aX', v2: 'a', crud1: 'M', crud2: '' };
const cases = [
  ['계층 정상', h({ checked: 5, bad: [] }), 'PASS'], ['중간 미병합', h({ checked: 5, bad: ['r1 B'] }), 'FAIL'], ['대조 0', h({ checked: 0, bad: [] }), 'NA'],
  ['병합 입력 정상(콤마 무시)', i(I), 'PASS'], ['편집기 안 열림', i({ ...I, opened: false }), 'FAIL'], ['값 미반영(대조군 반영)', i({ ...I, after: '5', ctrlOk: true }), 'FAIL'], ['값 미반영(대조군도 거부)', i({ ...I, after: '5', ctrlOk: false }), 'ERROR'], ['병합 풀림', i({ ...I, span1: 1 }), 'FAIL'], ['병합 아님', i({ ...I, span0: 1 }), 'ERROR'], ['측정 실패', i({ ...I, why: 'x' }), 'ERROR'],
  ['Delete 전체 D', d(D), 'PASS'], ['일부만 D', d({ ...D, cruds: ['D', '', ''] }), 'FAIL'], ['범위 밖 D', d({ ...D, outD: 1 }), 'FAIL'], ['D 없음', d({ ...D, cruds: ['', '', ''] }), 'ERROR'], ['토글형 전체', d({ ...D, cruds: ['', '', ''], toggled: 3, keys: ['ACTIVE'] }), 'PASS'], ['토글 일부', d({ ...D, cruds: ['', '', ''], toggled: 1, keys: ['ACTIVE'] }), 'FAIL'], ['서버 요청', d({ ...D, posts: 1 }), 'ERROR'], ['측정 실패', d({ ...D, why: 'x' }), 'ERROR'],
  ['신규 행 병합 안 됨', n({ b: 'C', same: true, span: 1 }), 'PASS'], ['신규 행 병합됨', n({ b: 'C', same: true, span: 2 }), 'FAIL'], ['같은 값 못 넣음', n({ b: 'C', same: false, span: 1 }), 'ERROR'],
  ['복원 해제', r(R), 'PASS'], ['복원 뒤 M', r({ ...R, crud2: 'M' }), 'FAIL'], ['복원 뒤 M·코드 다름', r({ ...R, crud2: 'M', diff: ["ID 'a'→'b'"] }), 'ERROR'], ['값 변경 안 됨', r({ ...R, v1: 'a' }), 'ERROR'], ['복원 안 됨', r({ ...R, v2: 'b' }), 'ERROR'], ['수정 표시 없음', r({ ...R, crud1: '' }), 'ERROR'],
  ['AS-IS Delete 빈 본문 + 알림(T341)', d({ b: 'PLAN_TYPE', cruds: ['', '', ''], outD: 0, posts: 0, alert: '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.', asisNoDelete: 'X.cs:536 DeleteButton' }), 'NA'],
  ['AS-IS Delete 빈 본문 + 알림 없음(T341)', d({ b: 'PLAN_TYPE', cruds: ['', ''], outD: 0, posts: 0, asisNoDelete: 'X.cs:536 DeleteButton' }), 'ERROR'],
  ['AS-IS Delete 있음 + 알림(T341)', d({ b: 'PLAN_TYPE', cruds: ['', ''], outD: 0, posts: 0, alert: 'x' }), 'ERROR'],
  ['빈 재정의 줄(T341)', { result: m.exports.emptyOverrideLine('a\nb\n  protected override void DeleteButton()\n  {\n\n  }\n', 'DeleteButton') === 3 ? 'PASS' : 'FAIL', why: '' }, 'PASS'],
  ['본문 있는 재정의(T341)', { result: m.exports.emptyOverrideLine('protected override void DeleteButton() { DeleteRow(); }', 'DeleteButton') === 0 ? 'PASS' : 'FAIL', why: '' }, 'PASS'],
];
let bad = 0; for (const [nm, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${nm} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
