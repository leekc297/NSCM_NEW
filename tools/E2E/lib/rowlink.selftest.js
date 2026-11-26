// linkedCols(rowlink.ts) 변이 입증(2026-11-25 T534) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ROOT = path.join(__dirname, '..', '..', '..');
const ts = require(path.join(ROOT, 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'rowlink.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require);
const { linkedCols: f, identExclude: g } = m.exports;
const K = ['DIVISION_ID', 'FROM_SITE', 'ITEM_ID', 'USER_ID', 'USER_NAME', 'PART_LEADER', 'PART_LEADER_NAME', 'TEAM_LEADER', 'TEAM_LEADER_NAME', 'VALID_YN', 'TRANSPORT_MODE', 'TRANSPORT_MODE_NAME', 'ITEM_NAME', 'SITE_CD', 'SITE_NM'];
const J = (a) => JSON.stringify(a);
const cases = [
  ['USER_ID → USER_NAME(SSP0014 실측)', J(f('USER_ID', K)), J(['USER_NAME'])],
  ['PART_LEADER → PART_LEADER_NAME(<칸>_ 접두)', J(f('PART_LEADER', K)), J(['PART_LEADER_NAME'])],
  ['TRANSPORT_MODE → TRANSPORT_MODE_NAME(T457 규칙 유지)', J(f('TRANSPORT_MODE', K)), J(['TRANSPORT_MODE_NAME'])],
  ['SITE_CD → SITE_NM', J(f('SITE_CD', K)), J(['SITE_NM'])],
  ['변이: VALID_YN 은 연동 칸 없음', J(f('VALID_YN', K)), J([])],
  ['변이: FROM_SITE 는 SITE_NM 을 잇지 않음(이름 줄기 다름)', J(f('FROM_SITE', K)), J([])],
  ['변이: ITEM_ID 가 USER_NAME 을 잇지 않음', J(f('ITEM_ID', K)), J(['ITEM_NAME'])],
  ['변이: 자기 칸은 연동 칸 아님', f('USER_ID', ['USER_ID']).length, 0],
  ['identExclude = 시험 칸 + 연동 칸', J(g('USER_ID', K)), J(['USER_ID', 'USER_NAME'])],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}(기대 ${want})`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
