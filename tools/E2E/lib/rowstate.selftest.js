// rowstate 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'rowstate.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeInsertInState: i, judgePasteBad: b, judgeLike: lk, judgeSelected: sl, judgeAllRound: ar, judgeTextDelete: td, judgeDivCands: dc, judgePasteCode: pc, judgeBlankExisting: be, judgeInsertDiv: id } = m.exports;
const I = { state: '정렬', kept: true, newRow: true, editable: 3 }; const P = { b: 'C', bad: 'X', before: 'A', after: 'A', pasted: true };
const cases = [
  ['Insert 정상', i(I), 'PASS'], ['상태 풀림', i({ ...I, kept: false }), 'FAIL'], ['신규행 없음', i({ ...I, newRow: false }), 'FAIL'], ['편집 불가', i({ ...I, editable: 0 }), 'FAIL'], ['측정 실패', i({ ...I, why: 'x' }), 'ERROR'],
  ['후보 밖 거부', b(P), 'PASS'], ['빈 값으로 거부', b({ ...P, after: '' }), 'PASS'], ['후보 밖 들어감', b({ ...P, after: 'X' }), 'FAIL'], ['붙여넣기 실패', b({ ...P, pasted: false }), 'ERROR'], ['측정 실패2', b({ ...P, why: 'x' }), 'ERROR'],
];
const LK = { b: 'C', full: 'ABCDEF', part: 'BCDE', vals: ['ABCDEF', 'xBCDEy'], sent: true };
cases.push(['부분일치', lk(LK), 'PASS'], ['0행', lk({ ...LK, vals: [] }), 'ERROR'], ['원래 값 없음', lk({ ...LK, vals: ['xBCDEy'] }), 'FAIL'], ['다른 칸 검색', lk({ ...LK, vals: ['ABCDEF', 'zzz'] }), 'ERROR'], ['요청 없음', lk({ ...LK, sent: false }), 'ERROR']);
const SL = { name: 'N', want: ['a', 'b'], vals: ['a', 'b', 'a'], sent: true }; const AR = { name: 'N', n0: 10, n1: 2, n2: 10 };
cases.push(['복수 정상', sl(SL), 'PASS'], ['조건 밖', sl({ ...SL, vals: ['a', 'b', 'c'] }), 'FAIL'], ['하나 빠짐', sl({ ...SL, vals: ['a'] }), 'FAIL'], ['0행', sl({ ...SL, vals: [] }), 'FAIL'], ['요청 없음', sl({ ...SL, sent: false }), 'ERROR'], ['왕복 정상', ar(AR), 'PASS'], ['왕복 실패', ar({ ...AR, n2: 2 }), 'FAIL'], ['선택 효과 없음', ar({ ...AR, n1: 10 }), 'ERROR']);
const TD = { where: 'C', key: 'Delete', full: 'ABCDEF', want: 'ADEF', got: 'ADEF' }; const DC = { divEditable: true, divs: ['40', '81'], changed: ['SITE'], same: ['X'] };
cases.push(['부분 삭제 정상', td(TD), 'PASS'], ['전부 지워짐', td({ ...TD, got: '' }), 'FAIL'], ['안 지워짐', td({ ...TD, got: 'ABCDEF' }), 'FAIL'], ['측정 실패', td({ ...TD, why: 'x' }), 'ERROR'], ['후보 재구성', dc(DC), 'PASS'], ['Div 편집 불가', dc({ ...DC, divEditable: false }), 'ERROR'], ['Div 1건', dc({ ...DC, divs: ['40'] }), 'ERROR'], ['후보 변화 없음', dc({ ...DC, changed: [] }), 'ERROR']);
const PC = { b: 'C', good: '81 Auto', raw: '81', disp: '81 Auto', keyEqName: false };
cases.push(['코드 동반', pc(PC), 'PASS'], ['코드 비어', pc({ ...PC, raw: '' }), 'FAIL'], ['이름이 코드 자리에', pc({ ...PC, raw: '81 Auto' }), 'FAIL'], ['이름=코드 칸', pc({ ...PC, raw: '81 Auto', keyEqName: true }), 'PASS'], ['미반영', pc({ ...PC, disp: 'x' }), 'ERROR']);
const BE = { b: 'C', cleared: true, posts: 0, msg: '필수', v0: '1' };
cases.push(['필수 차단', be(BE), 'PASS'], ['저장 요청 나감', be({ ...BE, posts: 1 }), 'FAIL'], ['안내 없음', be({ ...BE, msg: '' }), 'ERROR'], ['못 비움', be({ ...BE, cleared: false }), 'ERROR'], ['수정 없음 안내', be({ ...BE, msg: '수정한 내용이 없습니다.' }), 'ERROR'], ['상태 표시 없음', be({ ...BE, crud: '' }), 'ERROR'], ['상태 M 차단', be({ ...BE, crud: 'M' }), 'PASS']);
const ID0 = { cond: '81 Automotive', cell: '81 Automotive', changed: true, newAfter: 0 };
cases.push(['Insert Div 정상', id(ID0), 'PASS'], ['Div 다름', id({ ...ID0, cell: '40 Mobility' }), 'FAIL'], ['잔존·AS-IS 초기화', id({ ...ID0, newAfter: 1, asisClears: true }), 'FAIL'], ['잔존·AS-IS 초기화 없음', id({ ...ID0, newAfter: 1 }), 'PASS'], ['변경 못 함', id({ ...ID0, changed: false }), 'ERROR'], ['측정 실패', id({ ...ID0, why: 'x' }), 'ERROR'], ['조건값 못 읽음', id({ ...ID0, cond: '' }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
