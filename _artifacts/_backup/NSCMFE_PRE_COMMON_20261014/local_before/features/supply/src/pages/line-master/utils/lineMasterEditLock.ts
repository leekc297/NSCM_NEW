// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

// design 03 §3.2 (gridSignals lock 9건) + §1.2 편집규칙 요약(cs:335~337/571~573):
//   신규행('I')  : SCM_SITE_ID(콤보) + LINE_ID/LINE_NAME/VALID_YN/RACK_YN/SCS_PROD_AMEND 입력 가능.
//                  잠금 = DIVISION_ID/SITE_DESCRIPTION/OPERATION_ID (파생·조회조건).
//   기존행(편집) : LINE_NAME/VALID_YN/SCS_PROD_AMEND 만. 키/OPERATION_ID/RACK_YN 재잠금(cs:335~337).
const NEW_ROW_EDITABLE: ReadonlySet<string> = new Set([
  'SCM_SITE_ID',
  'LINE_ID',
  'LINE_NAME',
  'VALID_YN',
  'RACK_YN',
  'SCS_PROD_AMEND',
]);

const EXISTING_ROW_EDITABLE: ReadonlySet<string> = new Set([
  'LINE_NAME',
  'VALID_YN',
  'SCS_PROD_AMEND',
]);

const crudType = (row: WijmoRowItem | undefined): string =>
  (row?.CRUD_TYPE) ?? '';

// Plant 시트 = 조회 전용. 전 칼럼 잠금 (design 03 §3.2 #16, cs:444 Edit -> MSG00109).
export const isPlantCellEditable = (): boolean => false;

// Packer 시트 셀 편집 가부. 신규행/기존행 화이트리스트 분기 (design 03 §3.2).
export const isPackerCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean =>
  crudType(row) === 'I' ? NEW_ROW_EDITABLE.has(binding) : EXISTING_ROW_EDITABLE.has(binding);

// Packer 신규행 기본값 (design 03 §3.1 #1, cs:569):
//   DIVISION_ID = 조회 사업부 / VALID_YN='Y' / RACK_YN='N'. 나머지는 콤보 선택·입력·파생으로 채워진다.
export const packerInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  SCM_SITE_ID: '',
  SITE_DESCRIPTION: '',
  LINE_ID: '',
  LINE_NAME: '',
  VALID_YN: 'Y',
  OPERATION_ID: '',
  RACK_YN: 'N',
  SCS_PROD_AMEND: 'N',
});
