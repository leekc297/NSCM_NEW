// SSP0201 편집 화이트리스트 (design 03 §3.1 lock 39건, 01_layout §2 R1).
//   순수 함수 — 행 상태/컬럼별 세부 판정. 게이트는 모드 토글이 아니라 **EDIT 권한(canEdit) 축**이다:
//   AS-IS EditButton/SwitchLock 상태기계는 미이식(편집 기본 ON, convert-core §2.4 — constants 헤더 주석).
//   서브 그리드는 전량 읽기전용(siSub.LockColumn(0,max,true) :1824) — 별도 판정 없이 항상 잠금.

import {
  EE_DIVISION,
  EXISTING_ROW_EDIT_COLUMNS,
  FIXED_DIVISION,
  NEW_ROW_EDIT_COLUMNS,
} from '../shipment-change-request.constants';

const EXISTING_SET = new Set<string>(EXISTING_ROW_EDIT_COLUMNS);
const NEW_SET = new Set<string>(NEW_ROW_EDIT_COLUMNS);

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 여부 — 저장 대상 판정은 CRUD_TYPE 전용(convert-core §2.4, 자체 isNew 필드 금지).
export const isInsertedRow = (row: Record<string, unknown>): boolean => str(row.CRUD_TYPE) === 'I';

// Division 40/EE 여부 — END_CUSTOMER ↔ PROJECT_CODE 상호배타(design 03 §2 #2).
export const isEndCustomerDivision = (row: Record<string, unknown>): boolean => {
  const div = str(row.DIVISION_ID) || FIXED_DIVISION;
  return div === FIXED_DIVISION || div === EE_DIVISION;
};

// 셀 편집 가능 판정 (design 03 §3.1 / §4.3).
//   1) EDIT 권한(canEdit) 없으면 전량 잠금.
//   2) erp_status='C'(DO 생성됨) 행은 전량 잠금(MSG00189, :728/5586).
//   3) 신규행('I') = NEW_ROW_EDIT_COLUMNS 편집.
//   4) 기존행 status='C' AND erp_status!='C' = EXISTING_ROW_EDIT_COLUMNS 편집, 그 외 잠금.
//   5) Division 40/EE 상호배타: END_CUSTOMER(40/EE만) / PROJECT_CODE(그 외만).
export const isCellEditable = (
  row: Record<string, unknown>,
  binding: string,
  canEdit: boolean
): boolean => {
  if (!canEdit) return false;
  if (str(row.ERP_STATUS) === 'C') return false;

  // Division 40/EE 상호배타 컬럼
  if (binding === 'END_CUSTOMER' && !isEndCustomerDivision(row)) return false;
  if (binding === 'PROJECT_CODE' && isEndCustomerDivision(row)) return false;

  if (isInsertedRow(row)) return NEW_SET.has(binding);

  const status = str(row.SHIPMENT_STATUS);
  if (status === 'C') return EXISTING_SET.has(binding);
  return false;
};
