// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// As-is Spread Expression/계산식 100% 적용 (룰 09) — expressions.md 15건. E-nnn 마커는 게이트(check.js V01)가 센다.
export interface AsisExpressionRule { id: string; asisLine: number; kind: string; apply: () => void; }

export const BOD_EXPRESSIONS: AsisExpressionRule[] = [
  // E-001 [자동동기화/Auto-Sync] L393 InsertButton siMain.VMI_YN
  //   As-is: "N"
  { id: 'E-001', asisLine: 393, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-002 [자동동기화/Auto-Sync] L394 InsertButton siMain.BOD_VALID
  //   As-is: "Y"
  { id: 'E-002', asisLine: 394, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-003 [자동동기화/Auto-Sync] L395 InsertButton siMain.BEFORE_LEAD_TIME
  //   As-is: 0
  { id: 'E-003', asisLine: 395, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-004 [자동동기화/Auto-Sync] L396 InsertButton siMain.AFTER_LEAD_TIME
  //   As-is: 0
  { id: 'E-004', asisLine: 396, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-005 [자동동기화/Auto-Sync] L397 InsertButton siMain.FROM_YYYYMMDD
  //   As-is: sYYYYMMDD
  { id: 'E-005', asisLine: 397, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-006 [계산식] L398 InsertButton siMain.TO_YYYYMMDD
  //   As-is: "2099-12-27"
  { id: 'E-006', asisLine: 398, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-007 [자동동기화/Auto-Sync] L401 InsertButton siMain.DIVISION_ID
  //   As-is: strSel_Division
  { id: 'E-007', asisLine: 401, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-008 [자동동기화/Auto-Sync] L402 InsertButton siMain.DIVISION_ID
  //   As-is: strSel_Division
  { id: 'E-008', asisLine: 402, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-009 [자동동기화/Auto-Sync] L410 InsertButton siMain.DIVISION_ID
  //   As-is: strSel_Division
  { id: 'E-009', asisLine: 410, kind: 'InsertButton', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-010 [자동동기화/Auto-Sync] L736 SaveData_Main siMain.FROM_YYYYMMDD
  //   As-is: mondayDate
  { id: 'E-010', asisLine: 736, kind: 'SaveData_Main', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-011 [자동동기화/Auto-Sync] L744 SaveData_Main siMain.TO_YYYYMMDD
  //   As-is: sundayDate
  { id: 'E-011', asisLine: 744, kind: 'SaveData_Main', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-012 [자동동기화/Auto-Sync] L1165 SpdMain_ComboSelChange siMain.FROM_CITY
  //   As-is: dr["CITY"].ToString(
  { id: 'E-012', asisLine: 1165, kind: 'SpdMain_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-013 [자동동기화/Auto-Sync] L1176 SpdMain_ComboSelChange siMain.TO_CITY
  //   As-is: dr["CITY"].ToString(
  { id: 'E-013', asisLine: 1176, kind: 'SpdMain_ComboSelChange', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-014 [자동동기화/Auto-Sync] L1245 SpdMain_ClipboardPasted siMain.FROM_CITY
  //   As-is: dr["CITY"].ToString(
  { id: 'E-014', asisLine: 1245, kind: 'SpdMain_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
  // E-015 [자동동기화/Auto-Sync] L1255 SpdMain_ClipboardPasted siMain.TO_CITY
  //   As-is: dr["CITY"].ToString(
  { id: 'E-015', asisLine: 1255, kind: 'SpdMain_ClipboardPasted', apply: () => { /* TODO(이식): Wijmo formatItem/cellEditEnded */ } },
];
