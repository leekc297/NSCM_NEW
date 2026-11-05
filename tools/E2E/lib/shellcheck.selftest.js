// shellcheck 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'shellcheck.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeOpen: o, judgeTabName: t, judgeSearchBtn: b, judgeInitVals: iv, judgeVersionAfterDiv: va, judgePeriodGarbage: pg, judgePeriodReverse: pr } = m.exports;
const I = { x: 0, y: 0, w: 100, h: 30 };
const cases = [
  ['오픈 정상', o({ notFound: false, authorized: true, failed: [] }), 'PASS'], ['404', o({ notFound: true, authorized: true, failed: [] }), 'FAIL'], ['요청 실패', o({ notFound: false, authorized: true, failed: ['a 500'] }), 'FAIL'], ['권한 없음', o({ notFound: false, authorized: false, failed: [] }), 'ERROR'],
  ['탭 일치', t({ tab: 'Shipment  Lot Size', names: ['shipment lot size'] }), 'PASS'], ['탭 다름', t({ tab: 'DMF0005', names: ['Sales Site'] }), 'FAIL'], ['탭 못 읽음', t({ tab: '', names: ['x'] }), 'ERROR'], ['메뉴 없음', t({ tab: 'x', names: [] }), 'ERROR'],
  ['안쪽', b([{ label: 'A', input: I, btn: { x: 75, y: 2, w: 24, h: 26 } }]), 'PASS'], ['밖', b([{ label: 'A', input: I, btn: { x: 105, y: 2, w: 24, h: 26 } }]), 'FAIL'], ['대상 없음', b([]), 'NA'],
];
const IV = { div: '40', divCands: ['40', '81'], year: '2026', nowYear: '2026', hasDiv: true }; const VA = { hasVersion: true, changedDiv: true, before: 'V1', after: 'V2', cands: ['V2'] };
cases.push(['초기값 정상', iv(IV), 'PASS'], ['Division 빈 칸', iv({ ...IV, div: '' }), 'FAIL'], ['후보 밖', iv({ ...IV, div: '99' }), 'ERROR'], ['Year 다름', iv({ ...IV, year: '2020' }), 'FAIL'], ['조건 없음', iv({ ...IV, hasDiv: false, year: null }), 'NA'], ['Version 정상', va(VA), 'PASS'], ['Version 빈 칸', va({ ...VA, after: '' }), 'FAIL'], ['재구성 안 됨', va({ ...VA, after: 'V1' }), 'FAIL'], ['Version 없음', va({ ...VA, hasVersion: false }), 'NA'], ['Div 변경 못 함', va({ ...VA, changedDiv: false }), 'ERROR']);
const PG = { hasPeriod: true, v0: '2026-10', typed: '2026-10', sent: false, msg: '' }; const PR = { hasRange: true, set: true, from: '2026-10', to: '2024-10', sent: false, msg: '기간 오류', asisGuard: true };
cases.push(['글자 거부', pg(PG), 'PASS'], ['글자 남음·안내', pg({ ...PG, typed: 'ABCD', msg: '형식 오류' }), 'PASS'], ['글자 남음·요청', pg({ ...PG, typed: 'ABCD', sent: true }), 'FAIL'], ['글자 남음·무반응', pg({ ...PG, typed: 'ABCD' }), 'ERROR'], ['기간 없음', pg({ ...PG, hasPeriod: false }), 'NA'], ['역전 차단', pr(PR), 'PASS'], ['역전 요청·근거', pr({ ...PR, msg: '', sent: true }), 'FAIL'], ['역전 요청·근거 없음', pr({ ...PR, msg: '', sent: true, asisGuard: false }), 'ERROR'], ['역전 못 넣음·대조군도', pr({ ...PR, set: false }), 'ERROR'], ['역전 거부·대조군 됨', pr({ ...PR, set: false, ctrlOk: true }), 'PASS'], ['범위 없음', pr({ ...PR, hasRange: false }), 'NA'], ['무반응', pr({ ...PR, msg: '' }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
