// inputcheck 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'inputcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeBadInput: b, judgeDecimal: d, asisBlankDefault: abd, judgeBlankReject: br } = m.exports;
const SRC = ['x', '  string w = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.WORKING_TIME_DEFAULT)).ToString();', '  if (string.IsNullOrEmpty(w)) w = "0";', ''].join(String.fromCharCode(10));
const R = { rejected: true, req: 'null', dataType: '2', orig: '7', asisGuard: '', asisDefault: '' };
const B = { typed: true, bad: 'ZZZ', shown: '', calls: 0, body: '', msg: '', truncated: false }; const D = { typed: true, val: '1.5', shown: '1.5', calls: 1, body: '"V":"1.5"', msg: '', truncated: false };
const cases = [
  ['규칙 밖 값 저장됨', b({ ...B, calls: 1, body: '"X":"ZZZ"' }), 'FAIL'], ['저장 전 차단', b(B), 'PASS'], ['값 버리고 저장', b({ ...B, calls: 1, body: '"X":""' }), 'PASS'], ['입력 불가', b({ ...B, typed: false }), 'ERROR'], ['본문 잘림', b({ ...B, calls: 1, truncated: true }), 'ERROR'],
  ['AS-IS 빈값 기본값 찾음', { result: (abd(SRC, 'WORKING_TIME_DEFAULT') || {}).lit === '0' && abd(SRC, 'WORKING_TIME_DEFAULT').line === 3 ? 'PASS' : 'FAIL', why: JSON.stringify(abd(SRC, 'WORKING_TIME_DEFAULT')) }, 'PASS'],
  ['다른 칸은 못 찾음', { result: abd(SRC, 'OTHER_COL') === null ? 'PASS' : 'FAIL', why: '' }, 'PASS'],
  ['빈값 거부 · AS-IS 기본값 저장', br({ ...R, asisDefault: "빈값 → '0'(cs:569)" }), 'FAIL'], ['빈값 거부 · AS-IS 검증', br({ ...R, asisGuard: 'Save:600' }), 'PASS'],
  ['빈값 거부 · 근거 없음', br(R), 'ERROR'], ['칸 설정 필수 아님', br({ ...R, req: 'false' }), 'ERROR'], ['칸 설정 필수 아님 · 같은 경로 다른 값 입력됨 · AS-IS 기본값', br({ ...R, req: 'false', pathOk: "'0' 입력됨", asisDefault: 'x' }), 'FAIL'], ['칸 설정 필수 아님 · 같은 경로 입력됨 · 근거 없음', br({ ...R, req: 'false', pathOk: "'0' 입력됨" }), 'ERROR'], ['글자 칸 null', br({ ...R, dataType: '1' }), 'ERROR'], ['거부 미확인', br({ ...R, rejected: false, asisDefault: 'x' }), 'ERROR'],
  ['소수 보존', d(D), 'PASS'], ['소수 잘림', d({ ...D, body: '"V":"15"' }), 'FAIL'], ['소수 차단', d({ ...D, calls: 0 }), 'ERROR'], ['소수 입력 불가', d({ ...D, typed: false }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
