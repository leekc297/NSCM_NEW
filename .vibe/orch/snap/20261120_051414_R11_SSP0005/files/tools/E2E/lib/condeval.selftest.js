// condeval 평가기 변이 입증(2026-11-12 T264 — AUTH·SHEET 원자 추가 계기 · 이 평가기에는 자기 시험이 없었다). 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'condeval.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020', esModuleInterop: true } }).outputText)(m, m.exports, require);
const { evalRules } = m.exports;
const base = { group: ['SSP Planner'], admin: false, div: '81', self: 'QTY', col: n => ({ ERP_STATUS: 'C', SHIPMENT_STATUS: 'C' })[n] ?? null };
const show = r => ('error' in r ? 'ERR' : r.editable ? 'EDIT' : 'LOCK');
const R = (g, lock = 'Y') => [{ g, lock, ref: 't:1' }];
const cases = [
  ['조건 없는 잠금', show(evalRules(R(''), base)), 'LOCK'],
  ['COL 조건 참 → 잠금', show(evalRules(R('COL(ERP_STATUS)=="C"'), base)), 'LOCK'],
  ['COL 조건 거짓 → 기본 편집', show(evalRules(R('COL(ERP_STATUS)!="C"'), base)), 'EDIT'],
  ['RAW 는 평가 불가', show(evalRules(R('RAW(x > 1)'), base)), 'ERR'],
  ['AUTH 문맥 없음 = 평가 불가', show(evalRules(R('AUTH'), base)), 'ERR'],
  ['AUTH 참(권한 계정) → 규칙 적용', show(evalRules(R('AUTH', 'N'), { ...base, auth: true })), 'EDIT'],
  ['AUTH 거짓 → 규칙 미적용', show(evalRules([{ g: '', lock: 'Y', ref: 'a' }, { g: 'AUTH', lock: 'N', ref: 'b' }], { ...base, auth: false })), 'LOCK'],
  ['!(AUTH)', show(evalRules(R('!(AUTH)'), { ...base, auth: true })), 'EDIT'],
  ['SHEET 문맥 없음 = 평가 불가', show(evalRules(R('SHEET=="Shipment Plan Detail"'), base)), 'ERR'],
  ['SHEET 일치 → 잠금', show(evalRules(R('SHEET=="Shipment Plan Detail"'), { ...base, sheet: 'Shipment Plan Detail' })), 'LOCK'],
  ['SHEET 공백·대소문자 무시 일치', show(evalRules(R('SHEET=="Shipment Plan Detail"'), { ...base, sheet: 'shipment  plan detail' })), 'LOCK'],
  ['SHEET 다른 시트 → 규칙 미적용', show(evalRules(R('SHEET=="Hold stock"'), { ...base, sheet: 'Shipment Plan Detail' })), 'EDIT'],
  ['SHEET != 다른 시트 → 적용', show(evalRules(R('SHEET!="Hold stock"'), { ...base, sheet: 'Shipment Plan Detail' })), 'LOCK'],
  ['T301 그룹 하나: 그룹 잠금 규칙 적용', show(evalRules(R('GROUP=="DM Planner"'), { ...base, group: ['DM Planner'] })), 'LOCK'],
  ['T301 그룹 둘: 다른 보유 그룹으로 편집 가능(합집합)', show(evalRules(R('GROUP=="DM Planner"'), { ...base, group: ['DM Planner', 'DM ADMIN'] })), 'EDIT'],
  ['T301 admin 플래그도 보유 권한으로 센다', show(evalRules(R('GROUP=="DM Planner"'), { ...base, group: ['DM Planner'], admin: true })), 'EDIT'],
  ['T301 모든 보유 그룹이 잠금이면 잠금(변이)', show(evalRules(R('GROUP=="DM Planner" || GROUP=="DM Viewer"'), { ...base, group: ['DM Planner', 'DM Viewer'] })), 'LOCK'],
  ['T301 그룹 조건 없는 잠금은 그룹이 여럿이어도 잠금', show(evalRules(R('COL(ERP_STATUS)=="C"'), { ...base, group: ['A', 'B', 'C'] })), 'LOCK'],
  ['T301 특정 그룹만 해제하는 규칙: 그 그룹을 가지면 편집', show(evalRules([{ g: '', lock: 'Y', ref: 'a' }, { g: 'GROUP=="ADMIN"', lock: 'N', ref: 'b' }], { ...base, group: ['SSP Planner', 'ADMIN'] })), 'EDIT'],
  ['T301 편집 가능한 그룹이 없고 평가 불가가 있으면 평가 불가', show(evalRules(R('GROUP=="A" || RAW(x)'), { ...base, group: ['A', 'B'] })), 'ERR'],
  ['SHEET && COL 복합', show(evalRules(R('SHEET=="Shipment Plan Detail" && COL(ERP_STATUS)=="C"'), { ...base, sheet: 'Shipment Plan Detail' })), 'LOCK'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'PASS' : 'FAIL'} ${n}${ok ? '' : ` → ${got} (기대 ${want})`}`); }
console.log(`selftest ${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
