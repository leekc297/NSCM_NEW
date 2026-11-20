// insertpre 분기 시트 추출(2026-11-13 T303) 변이 입증. 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ROOT = path.join(__dirname, '..', '..', '..');
const ts = require(path.join(ROOT, 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'insertpre.ts'), 'utf8');
const m = { exports: {} };
new Function('module', 'exports', 'require', '__dirname', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, n => (n.startsWith('.') ? {} : require(n)), __dirname);
const { sheetConstAbove, sheetsOfLines } = m.exports;
const L = [
  'public static string shtHoldStock = "Hold stock";',
  'public static string shtPlanDetail = "Shipment Plan Detail";',
  'private void InsertRow()',
  '{',
  '  if (siDetail.IsLock(x) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldStock)',
  '  {',
  '    siDetail.Insert();',
  '  }',
  '  else if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail)',
  '  {',
  '    siDetail.Insert();',
  '  }',
  '}',
  'private void Other()',
  '{',
  '  siMain.Insert();',
  '}',
];
const cases = [
  ['첫 분기 문장 위 상수', sheetConstAbove(L, 7), 'shtHoldStock'],
  ['둘째 분기 문장 위 상수', sheetConstAbove(L, 11), 'shtPlanDetail'],
  ['메서드 선언을 넘어 위로 올라가지 않는다(변이)', sheetConstAbove(L, 16), ''],
  ['분기 2개 → 시트 2개, 문장 순서', JSON.stringify(sheetsOfLines(L, [7, 11])), JSON.stringify(['Hold stock', 'Shipment Plan Detail'])],
  ['같은 시트 문장 2개 → 1개(중복 제거)', JSON.stringify(sheetsOfLines(L, [7, 7])), JSON.stringify(['Hold stock'])],
  ['시트 조건 없는 문장만 → 빈 목록', JSON.stringify(sheetsOfLines(L, [16])), '[]'],
];
{ const far = ['private void M()', '{', '  if (s.ActiveSheet.SheetName == SpdSheet.shtA)', '  {']; for (let i = 0; i < 120; i++) far.push('    x = ' + i + ';'); far.push('    s.Insert();'); far.push('  }', '}');
  cases.push(['T310 조건이 120줄 위에 있어도 읽는다', sheetConstAbove(far, far.indexOf('    s.Insert();') + 1), 'shtA']);
  const two = ['private void A()', '{', '  if (s.ActiveSheet.SheetName == SpdSheet.shtA) { }', '}', 'private void B()', '{']; for (let i = 0; i < 90; i++) two.push('  y = ' + i + ';'); two.push('  s.Insert();', '}');
  cases.push(['T310 범위를 넓혀도 다른 메서드의 조건은 읽지 않는다(변이)', sheetConstAbove(two, two.indexOf('  s.Insert();') + 1), '']); }
const real = path.join(ROOT, 'GSCM', '06.UIL', 'GSCM.SSP.Forms.UIL', 'Plan', 'SSP0021_ShipmentPlan.UIL', 'SSP0021_ShipmentPlan.cs');
if (fs.existsSync(real)) {
  const s = fs.readFileSync(real, 'utf8').split(/\r?\n/); const n = s.findIndex(x => /private void InsertRow\(\)/.test(x));
  const ins = []; for (let i = n; i < n + 120 && i < s.length; i++) if (/siDetail\.(Insert|AddRow|AddNew|InsertRow)\w*\(/.test(s[i]) && !/^\s*\/\//.test(s[i])) ins.push(i + 1);
  const got = sheetsOfLines(s, ins);
  cases.push(['SSP0021 원문: 첫 분기 시트 = Hold stock', String(got[0]), 'Hold stock']);
  cases.push(['SSP0021 원문: 분기 시트 2개 이상', String(got.length >= 2), 'true']);
} else cases.push(['SSP0021 원문 없음, 건너뜀', 'skip', 'skip']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'PASS' : 'FAIL'} ${n}${ok ? '' : ` → ${got} (기대 ${want})`}`); }
console.log(`selftest ${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
