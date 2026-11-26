// condcol 판정 변이 입증(2026-11-25 T560 SCP0005 G1 V-e5d15dff) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'condcol.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { pickCondCol, chooseCondCol, stemCol } = m.exports;
const yn = (n, y) => Array.from({ length: n }, (_, i) => (i < y ? 'Y' : 'N'));
// SCP0005: DAYS_MON 이 VALID_YN 보다 앞 · 둘 다 Y/N
const cols = { DAYS_MON: yn(10, 9), FROM_CITY: ['A', 'B'], VALID_YN: yn(10, 8) };
const pk = pickCondCol(['ALL', 'Y', 'N'], cols, [], 'Valid');
const ch = chooseCondCol(pk, cols, '', 'Valid', 3);
// SCP0028 T521 회귀: To Site 는 TO_SITE 우선
const c2 = { FROM_SITE: ['S1', 'S2', 'S3'], TO_SITE: ['S1'], TO_SITE_DESCRIPTION: ['site one'] };
const pk2 = pickCondCol(['S1', 'S2'], c2, [], 'To Site');
const cases = [
  ['Valid → VALID_YN', ch.col, 'VALID_YN'], ['stem VALID_YN = stem Valid', stemCol('VALID_YN'), stemCol('Valid')], ['stem Mon ≠ DAYS_MON', stemCol('DAYS_MON'), 'DAYSMON'],
  ['stem SYN 꼬리 보존(밑줄 없음)', stemCol('SYN'), 'SYN'], ['stem ACTIVE_FLAG', stemCol('ACTIVE_FLAG'), 'ACTIVE'],
  ['T521 To Site → TO_SITE', chooseCondCol(pk2, c2, '', 'To Site', 2).col, 'TO_SITE'],
  ['갈래 칸 없음 → 값 겹침 칸', chooseCondCol(pickCondCol(['Y', 'N'], { DAYS_MON: yn(5, 3) }, [], 'Valid'), { DAYS_MON: yn(5, 3) }, '', 'Valid', 2).col, 'DAYS_MON'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}(기대 ${want})`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
