// celledit 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'celledit.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeEditorText: e, judgeKeepQty: k, judgeMonthSum: ms } = m.exports;
const K = { qty: 'Q', typed: '7', before: '7', after: '7', other: 'X' };
const cases = [
  ['표시값', e([{ b: 'A', raw: '1', disp: 'One', editor: 'One' }]), 'PASS'], ['코드 노출', e([{ b: 'A', raw: '1', disp: 'One', editor: '1' }]), 'FAIL'], ['대상 없음', e([{ b: 'A', raw: 'x', disp: 'x', editor: 'x' }]), 'ERROR'], ['편집기 못 읽음', e([{ b: 'A', raw: '1', disp: 'One', editor: null }]), 'ERROR'],
  ['유지', k(K), 'PASS'], ['바뀜', k({ ...K, after: '0' }), 'FAIL'], ['비워짐', k({ ...K, after: '' }), 'FAIL'], ['입력 미반영', k({ ...K, before: '0', after: '0' }), 'ERROR'], ['천 단위', k({ ...K, typed: '1000', before: '1,000', after: '1,000' }), 'PASS'], ['측정 실패', k({ ...K, why: 'x' }), 'ERROR'],
];
const D = (v) => [{ d: '20260101', v }, { d: '20260102', v: 0 }];
cases.push(['월 합계 일치', ms({ month: 'M', want: 7, days: D(7), daysInMonth: 2 }), 'PASS'], ['월 합계 다름', ms({ month: 'M', want: 7, days: D(3), daysInMonth: 2 }), 'FAIL'], ['일자 칸 부족', ms({ month: 'M', want: 7, days: D(7), daysInMonth: 31 }), 'ERROR'], ['측정 실패', ms({ month: 'M', want: 7, days: [], daysInMonth: 2, why: 'x' }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
