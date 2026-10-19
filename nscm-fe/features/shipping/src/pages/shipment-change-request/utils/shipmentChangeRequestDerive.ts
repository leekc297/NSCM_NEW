// SSP0201 편집 파생 (design 03 §3.2 value 108건 중 FE 소관 규칙).
//   핵심축: EDIT_MAIN 플래그('Y'=변경/'N'=취소) + SO No 그룹 전파(같은 ERP_SO_NO 전행 동일변경).
//   주의: NEW_ROUTE_ID/NEW_BOD_ID/NEW_*_PORT/NEW_LT_DAY 등 경로·BOD·LT 계산은 AS-IS 에서도
//     주석처리되어 저장 SP(SQL)로 이관됨(design 03 §3.2/§6 :4979-5016). FE 는 재현하지 않는다 —
//     PKG_SSP0201(convert-sp) 배포 후 서버 파생이 채운다. FE 는 EDIT_MAIN/StringAction 마킹만 담당.

import { EDIT_MAIN_FLAG, SO_GROUP_KEY } from '../shipment-change-request.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// EDIT_MAIN 파생 트리거 컬럼(design 03 §3.2). 이 컬럼이 바뀌면 EDIT_MAIN='Y' + SO그룹 전파.
export const EDIT_MAIN_TRIGGER_COLUMNS = new Set<string>([
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_DETAIL',
  'REMARKS',
  'REMARKS2',
]);

// SO No 그룹 전파 대상 행 집합 — ERP_SO_NO 있으면 같은 SO 전행, 없으면 자기행만(design 03 §3.2).
export const soGroupRows = (
  allRows: Record<string, unknown>[],
  changedRow: Record<string, unknown>
): Record<string, unknown>[] => {
  const soNo = str(changedRow[SO_GROUP_KEY]);
  if (!soNo) return [changedRow];
  return allRows.filter(r => str(r[SO_GROUP_KEY]) === soNo);
};

// EDIT_MAIN 플래그 세팅(파생마다 'Y', CHANGE_REASON_CODE 취소 시 'N').
export const setEditMain = (row: Record<string, unknown>, flag: 'Y' | 'N'): void => {
  row[EDIT_MAIN_FLAG] = flag;
};

// CHANGE_REASON_CODE 변경 파생 — '-'/공백이면 DETAIL clear + EDIT_MAIN='N'(design 03 §3.2 :5023).
export const applyChangeReasonCode = (row: Record<string, unknown>, code: string): void => {
  if (!code || code === '-') {
    row.CHANGE_REASON_DETAIL = '';
    setEditMain(row, 'N');
  } else {
    setEditMain(row, 'Y');
  }
};

// erp_status='C'(DO 생성됨) 변경 차단 판정(MSG00189, design 03 §3.2 :5584).
export const isErpLocked = (row: Record<string, unknown>): boolean => str(row.ERP_STATUS) === 'C';

// CHANGE_REASON_DETAIL 입력 전 REASON_CODE 선행 필수(MSG00287, design 03 §3.2 :5529).
export const isReasonCodeMissing = (row: Record<string, unknown>): boolean => {
  const code = str(row.CHANGE_REASON_CODE);
  return !code || code === '-';
};
