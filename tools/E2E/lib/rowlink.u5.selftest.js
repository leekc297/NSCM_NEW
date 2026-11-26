// rowlink.ts T595~T599 순수 함수 변이 입증(2026-11-25 SCP0005 U5) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ROOT = path.join(__dirname, '..', '..', '..');
const ts = require(path.join(ROOT, 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'rowlink.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require);
const { guardReaches, msgCodeOf, sameMsg, msgLabelOf, groupMembers, groupFillValue, groupCandidates } = m.exports;
const cs = path.join(ROOT, 'GSCM', '06.UIL', 'GSCM.SCP.Forms.UIL', 'Master', 'SCP0005_DistributionRoute', 'SCP0005_DistributionRoute.cs');
const lines = fs.existsSync(cs) ? fs.readFileSync(cs, 'utf8').split(/\r?\n/) : [];
const body = lines.slice(1261 - 1, 1328).join('\n');  // CheckValid 본문(actions.csv 첫 문장 1262 ~ 마지막 1328)
const g = 'for (i < siMain.ActiveSheet.RowCount) ▸ if (intPRIORITY < 1)';
const days = ['DAYS_MON', 'DAYS_TUE', 'DAYS_WED', 'DAYS_THU', 'DAYS_FRI', 'DAYS_SAT', 'DAYS_SUN'].map(b => ({ binding: b, heads: ['Working Days', b.slice(5, 6) + b.slice(6).toLowerCase()] }));
const hdr = [{ binding: 'PRIORITY', heads: ['Priority*', 'Priority*'] }, ...days, { binding: 'LT_TYPE', heads: ['LT Type', 'LT Type'] }];
const cases = [
  ['AS-IS 원문 있음(SCP0005_DistributionRoute.cs)', lines.length > 1300, true],
  ['CheckValid intPRIORITY < 1 → PRIORITY 에 닿음', /PRIORITY$/.test(guardReaches(body, g, 'PRIORITY')), true],
  ['변이: 같은 조건이 FROM_CITY 에 닿지 않음', guardReaches(body, g, 'FROM_CITY'), ''],
  ['변이: 같은 조건이 LT_TYPE 에 닿지 않음', guardReaches(body, g, 'LT_TYPE'), ''],
  ['strFromCity 조건 → FROM_CITY_NAME', /FROM_CITY_NAME$/.test(guardReaches(body, 'for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strFromCity))', 'FROM_CITY_NAME')), true],
  ['변이: strFromCity 조건 → PRIORITY 아님', guardReaches(body, 'if (string.IsNullOrEmpty(strFromCity))', 'PRIORITY'), ''],
  ['직접 조건 DefColumns.X', guardReaches('', 'if (x == DefColumns.PRIORITY)', 'PRIORITY'), 'direct'],
  ['변이: 주석 안 대입은 무시', guardReaches('// a = DefColumns.PRIORITY;\n', 'if (a < 1)', 'PRIORITY'), ''],
  ['변이: == 비교는 대입 아님', guardReaches('if (a == DefColumns.PRIORITY) {}', 'if (a < 1)', 'PRIORITY'), ''],
  ['SaveData 요일 조건(MSG00223 cs:728) → DAYS_MON(+= 누적 대입 cs:684)', /DAYS_MON$/.test(guardReaches(lines.slice(600, 760).join('\n'), 'for (i <= siMain.GetMaxRowIndex()) ▸ if (String.IsNullOrEmpty(strDAYS_MON) && String.IsNullOrEmpty(strDAYS_TUE))', 'DAYS_MON')), true],
  ['변이: 요일 조건 → PRIORITY 아님', guardReaches(lines.slice(600, 760).join('\n'), 'if (String.IsNullOrEmpty(strDAYS_MON) && String.IsNullOrEmpty(strDAYS_TUE))', 'PRIORITY'), ''],
  ['변이: != 비교는 대입 아님', guardReaches('if (a != DefColumns.PRIORITY) {}', 'if (a < 1)', 'PRIORITY'), ''],
  ['msgCodeOf', msgCodeOf('("MSG00107", null)'), 'MSG00107'],
  ['sameMsg 한글 일치', sameMsg('Priority는 양의 정수입니다.', ['Priority는 양의 정수입니다.', 'Priority is a positive integer.']), true],
  ['sameMsg 영문 일치(끝 마침표 없음)', sameMsg('Priority is a positive integer', ['Priority는 양의 정수입니다.', 'Priority is a positive integer.']), true],
  ['변이: sameMsg 다른 문구', sameMsg('[Working Days] 값은 필수 입력 항목입니다.', ['Priority는 양의 정수입니다.', 'Priority is a positive integer.']), false],
  ['변이: sameMsg 빈 화면 문구', sameMsg('', ['Priority는 양의 정수입니다.']), false],
  ['sameMsg {0} 자리', sameMsg('[Working Days] 값은 필수 입력 항목입니다.', ['{0} 값은 필수 입력 항목입니다.']), true],
  ['msgLabelOf', msgLabelOf('[Working Days] 값은 필수 입력 항목입니다.'), 'Working Days'],
  ['변이: msgLabelOf 괄호 없음', msgLabelOf('Priority는 양의 정수입니다.'), ''],
  ['groupMembers Working Days = 요일 7칸', JSON.stringify(groupMembers(hdr, 'Working Days')), JSON.stringify(days.map(d => d.binding))],
  ['변이: 칸 자기 머리글(Priority)은 묶음 아님', groupMembers(hdr, 'Priority').length, 0],
  ['변이: 한 칸만 걸리면 묶음 아님', groupMembers([{ binding: 'A', heads: ['G', 'a'] }, { binding: 'B', heads: ['H', 'b'] }], 'G').length, 0],
  ['groupFillValue Y 우선', groupFillValue(['N', 'Y']), 'Y'],
  ['groupFillValue Y 없음 → N 아닌 첫 후보', groupFillValue(['N', '1']), '1'],
  ['변이: groupFillValue N 만', groupFillValue(['N', '']), ''],
  ['T636 groupCandidates 머리글 다른 이름(Departure Days) 낱말 days 겹침 1순위', JSON.stringify(groupCandidates([...days.map(d => ({ binding: d.binding, heads: ['Departure Days', d.heads[1]] })), { binding: 'A_PORT_NAME', heads: ['Arrival Port', 'Port'] }, { binding: 'A_COUNTRY', heads: ['Arrival Port', 'Country'] }], 'Working Days')[0]), JSON.stringify({ head: 'departure days', members: days.map(d => d.binding), score: 1 })],
  ['T636 변이: 겹침 없는 묶음 score 0', groupCandidates([{ binding: 'A', heads: ['Arrival Port', 'Port'] }, { binding: 'B', heads: ['Arrival Port', 'Country'] }], 'Working Days')[0].score, 0],
  ['T636 변이: 한 칸 묶음 제외', groupCandidates([{ binding: 'A', heads: ['Days', 'a'] }], 'Working Days').length, 0],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = JSON.stringify(got) === JSON.stringify(want); if (!ok) bad++; console.log(`${ok ? 'OK  ' : 'FAIL'} ${n} — got ${JSON.stringify(got)} want ${JSON.stringify(want)}`); }
console.log(`rowlink.u5 ${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
