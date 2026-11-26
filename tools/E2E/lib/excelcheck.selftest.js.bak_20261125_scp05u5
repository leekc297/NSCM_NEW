// excelcheck 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'excelcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeForm: f, judgeBadUpload: u, judgeBlankUpload: bu } = m.exports;
const OK = { button: true, asisHas: '', download: true, dialog: '', bytes: 100, sheets: [{ name: 'S', rows: 1, cols: 3, header: ['A', 'B', 'C'] }], parseErr: '' };
const U = { button: true, fileInput: true, calls: 0, msg: 'Invalid Column Header Title' };
const cases = [
  ['양식 정상', f(OK), 'PASS'], ['버튼 없음·AS-IS 있음', f({ ...OK, button: false, asisHas: 'x:1' }), 'FAIL'], ['버튼 없음·AS-IS 없음', f({ ...OK, button: false }), 'NA'], ['파일 안 내려옴', f({ ...OK, download: false }), 'FAIL'], ['팝업 뒤 다운로드', f({ ...OK, download: false, dialog: '기간' }), 'ERROR'], ['0바이트', f({ ...OK, bytes: 0 }), 'FAIL'], ['열리지 않음', f({ ...OK, parseErr: 'bad' }), 'FAIL'], ['머리글 없음', f({ ...OK, sheets: [{ name: 'S', rows: 0, cols: 0, header: [] }] }), 'FAIL'],
  ['잘못된 파일 차단', u(U), 'PASS'], ['잘못된 파일 저장 요청', u({ ...U, calls: 1 }), 'FAIL'], ['성공 문구', u({ ...U, msg: '성공적으로 저장되었습니다' }), 'FAIL'], ['무문구', u({ ...U, msg: '' }), 'FAIL'], ['버튼 없음', u({ ...U, button: false }), 'NA'], ['파일 입력 없음', u({ ...U, fileInput: false }), 'ERROR'],
];
const BU = { hasForm: true, button: true, req: ['A*'], fileInput: true, calls: 0, msg: 'A 값은 필수 입력입니다.' };
cases.push(['필수 차단', bu(BU), 'PASS'], ['요청·안내 없음', bu({ ...BU, msg: '' }), 'FAIL'], ['요청 나감', bu({ ...BU, msg: '', calls: 1 }), 'ERROR'], ['버튼 없음', bu({ ...BU, button: false }), 'NA'], ['필수 표시 없음', bu({ ...BU, req: [] }), 'NA'], ['양식 못 받음', bu({ ...BU, hasForm: false }), 'ERROR'], ['파일 입력 없음', bu({ ...BU, fileInput: false }), 'ERROR']);
cases.push(['SQL 오류 노출', bu({ ...BU, msg: 'HTTP 500 ORA-20001: x / SQLERRM=ORA-01403: 데이터 / "SCM_MGR.PKG_A", 221행' }), 'FAIL'], ['고정 머리글은 성공 아님', m.exports.judgeBadUpload({ button: true, fileInput: true, calls: 0, msg: 'Excel Upload bad.xlsx OK Cancel Upload Result Success Error Total' }), 'ERROR'], ['실제 성공 문구', m.exports.judgeBadUpload({ button: true, fileInput: true, calls: 0, msg: '저장되었습니다' }), 'FAIL']);
const FB = { download: true, buckets: ['20261102', '20270404'], from: '20261101', to: '20270430' }; const FT = { expect: true, download: true, merged: 3, row2: ['a'] };
cases.push(['T206 기간 칸 2개·두번째 안', m.exports.judgeFormBucket({ download: true, buckets: ['20261010'], ranges: [{ label: 'A', from: '20260928', to: '20261231' }, { label: 'B', from: '20261010', to: '20261231' }] }), 'PASS'],
  ['T206 기간 칸 2개·어디에도 밖', m.exports.judgeFormBucket({ download: true, buckets: ['20280101'], ranges: [{ label: 'A', from: '20260928', to: '20261231' }, { label: 'B', from: '20261010', to: '20261231' }] }), 'FAIL'],
  ['T206 기간 칸 0개', m.exports.judgeFormBucket({ download: true, buckets: ['20261010'], ranges: [] }), 'ERROR'],
  ['T206 기간 칸 1개', m.exports.judgeFormBucket({ download: true, buckets: ['20261010'], ranges: [{ label: 'P', from: '20260928', to: '20261231' }] }), 'ERROR']);
cases.push(['버킷 안', m.exports.judgeFormBucket(FB), 'PASS'], ['버킷 밖', m.exports.judgeFormBucket({ ...FB, buckets: ['20261102', '20280101'] }), 'FAIL'], ['버킷 없음', m.exports.judgeFormBucket({ ...FB, buckets: [] }), 'NA'], ['기간 못 읽음', m.exports.judgeFormBucket({ ...FB, from: '' }), 'ERROR'], ['양 끝 안 맞음', m.exports.judgeFormBucket({ ...FB, buckets: ['20261201', '20270301'] }), 'ERROR'], ['2단 정상', m.exports.judgeFormTwoRow(FT), 'PASS'], ['병합 없음', m.exports.judgeFormTwoRow({ ...FT, merged: 0 }), 'FAIL'], ['대상 아님', m.exports.judgeFormTwoRow({ ...FT, expect: false }), 'NA']);
const UB = m.exports.judgeUploadBlock; const UB0 = { fileInput: true, validated: true, resultText: '오류 1', okBtn: true, saves: 0, msg: '오류 행이 존재하여 저장할 수 없습니다.' };
cases.push(['2단계 차단', UB(UB0), 'PASS'], ['저장 나감', UB({ ...UB0, saves: 1 }), 'FAIL'], ['문구 없음', UB({ ...UB0, msg: '' }), 'ERROR'], ['파일 입력 없음', UB({ ...UB0, fileInput: false }), 'ERROR'], ['검사 없음', UB({ ...UB0, validated: false }), 'ERROR'], ['버튼 없음', UB({ ...UB0, okBtn: false, msg: '' }), 'NA'], ['검사 SQL 오류', UB({ ...UB0, msg: 'ORA-01403' }), 'FAIL'], ['결과 칸 SQLCODE', UB({ ...UB0, resultText: 'ORA-20001: [P] SQLCODE=100 / SQLERRM', msg: '' }), 'FAIL']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
