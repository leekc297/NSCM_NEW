// savecheck 판정 변이 입증(2026-10-31) — 결함을 흉내 낸 스냅샷으로 FAIL 을, 정상 스냅샷으로 PASS 를 내는지 확인한다
//   node tools/E2E/lib/savecheck.selftest.js  (TS 를 트랜스파일해 실행) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'savecheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { diffSnap, judgeRowCount, judgeAudit } = m.exports;
const row = (o) => ({ K: 'A', V: '1', CREATION_DATE: 'c0', CREATED_BY: 'u0', LAST_UPDATE_DATE: 't0', LAST_UPDATED_BY: 'u0', ...o });
const snap = (rows, hist = []) => ({ skipped: {}, tables: { T: { keys: ['K'], pk: ['K', 'S'], n: rows.length, rows }, T_H: { keys: ['K'], pk: [], n: hist.length, rows: hist } } });
const base = snap([row({ S: '1' })]);
const good = snap([row({ S: '1', V: '2', LAST_UPDATE_DATE: 't1', LAST_UPDATED_BY: 'me' })], [row({ S: '1' })]);
const cases = [
  ['정상 수정 → 행 수 PASS', judgeRowCount(diffSnap(base, good), {}), 'PASS'],
  ['정상 수정 → 감사 PASS', judgeAudit(diffSnap(base, good), 'me'), 'PASS'],
  ['이력 표 증가는 행 수 FAIL 아님', judgeRowCount(diffSnap(base, good), {}), 'PASS'],
  ['변이: 수정이 중복 행 생성 → 행 수 FAIL', judgeRowCount(diffSnap(base, snap([row({ S: '1' }), row({ S: '2', V: '2' })])), {}), 'FAIL'],
  ['변이: 수정이 행 삭제 → 행 수 FAIL', judgeRowCount(diffSnap(base, snap([])), {}), 'FAIL'],
  ['변이: 변화 없음 → ERROR', judgeRowCount(diffSnap(base, base), {}), 'ERROR'],
  ['변이: CREATION_DATE 덮어씀 → 감사 FAIL', judgeAudit(diffSnap(base, snap([row({ S: '1', V: '2', CREATION_DATE: 'c1', LAST_UPDATE_DATE: 't1', LAST_UPDATED_BY: 'me' })])), 'me'), 'FAIL'],
  ['변이: Updated 미갱신 → 감사 FAIL', judgeAudit(diffSnap(base, snap([row({ S: '1', V: '2', LAST_UPDATED_BY: 'me' })])), 'me'), 'FAIL'],
  ['변이: 수정자 다름 → 감사 FAIL', judgeAudit(diffSnap(base, snap([row({ S: '1', V: '2', LAST_UPDATE_DATE: 't1', LAST_UPDATED_BY: 'other' })])), 'me'), 'FAIL'],
  ['T212 append 표 행 증가 = AS-IS 동일', m.exports.judgeTwice([{ table: 'SCM_MGR.SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', added: [{ A: '1' }], removed: [], changed: [] }, { table: 'SSP_ANL_SHIP_CONFIRM', added: [], removed: [], changed: [] }], 2, new Map([['SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', 'SP:500 NEXT VALUE FOR']])), 'PASS'],
  ['T212 append 아닌 업무 표 행 증가', m.exports.judgeTwice([{ table: 'SSP_ANL_SHIP_CONFIRM', added: [{ A: '1' }], removed: [], changed: [] }], 2, new Map([['SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', 'x']])), 'FAIL'],
  ['T212 append 표라도 삭제 생기면', m.exports.judgeTwice([{ table: 'SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', added: [{ A: '1' }], removed: [{ A: '0' }], changed: [] }], 2, new Map([['SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', 'x']])), 'FAIL'],
  ['T222 append 표만 행 증가 → 행 수 PASS', m.exports.judgeRowCount([{ table: 'SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', keys: ['K'], added: [{ A: '1' }], removed: [], changed: [] }, { table: 'SSP_ANL_SHIP_CONFIRM', keys: ['K'], added: [], removed: [], changed: [{ before: {}, after: {} }] }], {}, new Map([['SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', 'x']])), 'PASS'],
  ['T222 체인이 안 쓰는 이력 표 → NA', m.exports.judgeHistory([{ table: 'SSP_ANL_SHIP_CONFIRM_H', keys: [], added: [], removed: [], changed: [] }], {}, new Set(['SSP_ANL_SHIP_CONFIRM_CHG_REQ'])), 'NA'],
  ['T222 체인이 쓰는 이력 표 +0 → FAIL', m.exports.judgeHistory([{ table: 'SSP_ANL_SHIP_CONFIRM_H', keys: [], added: [], removed: [], changed: [] }], {}, new Set(['SSP_ANL_SHIP_CONFIRM_H'])), 'FAIL'],
];
let bad = 0; for (const [n, r, w] of cases) { const ok = r.result === w; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${r.result}${ok ? '' : ' (기대 ' + w + ') ' + r.evidence}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
