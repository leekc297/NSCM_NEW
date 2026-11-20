// T59 필수 알림 항목명 추출 변이 입증(2026-11-06) — nscm.ts 의 REQUIRED_RX·requiredLabelOf 만 잘라 실행 · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'nscm.ts'), 'utf8');
const a = src.indexOf('export const REQUIRED_RX'), b = src.indexOf('\n}', src.indexOf('export function requiredLabelOf')) + 2;
if (a < 0 || b < 2) { console.log('[FAIL] nscm.ts 에서 REQUIRED_RX/requiredLabelOf 를 찾지 못함'); process.exit(1); }
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src.slice(a, b), { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { REQUIRED_RX: RX, requiredLabelOf: f } = m.exports;
const cases = [
  // [이름, 알림 원문, 기대 항목명('' = 필수 알림 아님/해석 불가)]
  ['SCP0016 실측(11-05 스크린샷)', '\nVer. 값은 필수 입력 항목입니다.\nConfirm', 'Ver.'],
  ['괄호 항목', '[Operation group] 은 필수 입력 항목입니다.', 'Operation group'],
  ['선택하세요', 'Division 을 선택하세요.', 'Division'],
  ['영문 select', 'Please select Plan Version.', 'Plan Version'],
  ['영문 required', 'Period is required.', 'Period'],
  ['필수 아닌 알림', '조회된 데이터가 없습니다.\nConfirm', ''],
  ['저장 확인창', 'Would you like to save it?', ''],
];
let bad = 0;
for (const [n, msg, want] of cases) {
  const isReq = RX.test(msg); const got = isReq ? f(msg) : '';
  const ok = got === want; if (!ok) bad++;
  console.log(`${ok ? 'OK ' : 'NG '} ${n}: '${got}' (기대 '${want}')`);
}
console.log(bad ? `[FAIL] ${bad}건` : `[PASS] ${cases.length}건`); process.exit(bad ? 1 : 0);
