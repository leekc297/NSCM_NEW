// snap 형상 정규화(shapeNorm · 2026-11-19 T348 · CR-115·CR-100) 변이 입증 — 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'snap.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', '__dirname', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require, __dirname);
const { shapeNorm: S } = m.exports;
const G = ['- text: Div', '- combobox "Div"', '- text: Period 2026.10 ~ 2027.03', '- checkbox "Qty < 0"', '- text: Qty < 0'].join('\n');
const R = ['- text: Div', '- combobox "Div"', '- text: Period', '- button "calendar"', '- textbox "YYYY.MM": "2026.11"', '- text: ~', '- button "calendar"', '- textbox "YYYY.MM": "2027.04"', '- img', '- checkbox "Qty < 0"', '- text: Qty < 0'].join('\n');
const eq = (a, b, k = '조회조건') => S(k, a) === S(k, b);
const cases = [
  ['공용 기간 칸 구조·아이콘·기본 월 = 같은 형상', eq(G, R), true],
  ['라벨 변경은 차이로 남음', eq(G, R.replace('- text: Period', '- text: Plan Period')), false],
  ['칸 순서 변경은 차이로 남음', eq(G, R.replace('- text: Div\n- combobox "Div"\n', '') + '\n- text: Div\n- combobox "Div"'), false],
  ['기간 칸 하나 빠지면 차이', eq(G, R.replace('- textbox "YYYY.MM": "2027.04"', '')), false],
  ['팝업 건수 줄 제외(CR-100)', eq('- dialog\n- text: {TOTAL}\n- grid', '- dialog\n- grid', '팝업'), true],
  ['조회조건 종류는 건수 줄 유지', eq('- text: {TOTAL}\n- grid', '- grid'), false],
  ['이름 있는 img 는 유지', eq('- img "logo"\n- grid', '- grid'), false],
];
// 실제 SCP0111 골든·수신(있을 때만)
const SN = path.join(__dirname, '..', '..', '..', 'Doc', 'verify', 'SCP0111', 'snap');
const rd = (d, f) => { try { return fs.readFileSync(path.join(SN, d, f), 'utf8'); } catch { return null; } };
for (const [f, k] of [['조회조건_Div_40.aria.yml', '조회조건'], ['팝업_Model_Nickname.aria.yml', '팝업']]) {
  const g = rd('golden', f), r = rd('received', f); if (g && r) cases.push([`SCP0111 실물 ${f}`, S(k, g).split('\n').map(x => x.trimEnd()).filter(Boolean).join('\n') === S(k, r).split('\n').map(x => x.trimEnd()).filter(Boolean).join('\n'), true]);
}
let bad = 0; for (const [n, got, want] of cases) if (got !== want) { bad++; console.log(`[FAIL] ${n}: ${got} != ${want}`); }
console.log(`snap selftest ${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
