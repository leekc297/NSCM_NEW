// SSP0201 편집 가드 — **행 조건만** 판정한다(표준 COL-02 / hook #130).
//   열 단위 잠금의 원천은 `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 다 — 공용 DataGrid 가
//   `GridUtils.isEditableCell` 로 소비한다. 여기서는 메타로 표현할 수 없는 **행 조건만** 본다.
//   컬럼 축 편집 메타(INPUT_TP_CD)는 design/31_fix_main_input-tp-cd_standard-parity.sql 로 정비했다
//   (자매 SSP0200 과 동일 구조 — 종전 NEW_ROW_EDIT_COLUMNS/EXISTING_ROW_EDIT_COLUMNS 컬럼명
//   화이트리스트를 메타로 이관). FE 화이트리스트로 우회하면 공용 useSaveWithValidation 의 메타 기반
//   필수검사가 조용히 무발동한다(memory input-tp-cd-search-only-kills-save-validation).
//   서브 그리드는 전량 읽기전용(siSub.LockColumn(0,max,true) :1824) — 별도 판정 없이 항상 잠금.

import { EE_DIVISION, FIXED_DIVISION, INSERT_COPIED_FLAG } from '../shipment-change-request.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 여부 — 저장 대상 판정은 CRUD_TYPE 전용(convert-core §2.4, 자체 isNew 필드 금지).
export const isInsertedRow = (row: Record<string, unknown>): boolean => str(row.CRUD_TYPE) === 'I';

// Insert(복사) 경로로 만든 신규행 여부 — buildCopiedRow 만 INSERT_COPIED_FLAG 를 심는다.
//   END_CUSTOMER 는 메타상 IM(편집가능)이지만, 이 표식 행에서만 FE 가 추가로 잠근다 — AS-IS
//   비대칭(Insert=잠금 cs:2523 / New=편집 cs:3007-3014) 재현. 메타(INPUT_TP_CD)로는 표현 불가.
export const isInsertCopiedRow = (row: Record<string, unknown>): boolean =>
  str(row[INSERT_COPIED_FLAG]) === 'Y';

// END_CUSTOMER 가 이 행에서 FE 추가잠금 대상인지 — Insert 복사행에서만 true.
//   New 버튼 빈 행은 false(메타 IM 그대로 편집 허용). editGate·formatItem 공용.
export const isEndCustomerLockedOnInsert = (
  row: Record<string, unknown>,
  binding: string
): boolean => binding === 'END_CUSTOMER' && isInsertCopiedRow(row);

// Division 40/EE 여부 — END_CUSTOMER ↔ PROJECT_CODE 상호배타(design 03 §2 #2).
//   배타의 편집 차단은 컬럼 visible 토글(staticColumns)이 담당한다 — 숨긴 열은 편집 대상이 아니다.
export const isEndCustomerDivision = (row: Record<string, unknown>): boolean => {
  const div = str(row.DIVISION_ID) || FIXED_DIVISION;
  return div === FIXED_DIVISION || div === EE_DIVISION;
};

// 행 단위 편집 가드 (design 03 §3.1 "행 조건", 자매 SSP0200 isRowEditable 미러).
//   1) EDIT 권한(canEdit) 없으면 전량 잠금.
//   2) erp_status='C'(DO 생성됨) 행은 전량 잠금(MSG01202, :728/5586).
//   3) 신규행('I')은 편집 대상 — 어느 열이 열리는지는 INPUT_TP_CD(IM/IO/M/O)가 결정한다.
//   4) 기존행은 SHIPMENT_STATUS='C' 일 때만 편집 대상(이때 열리는 열은 INPUT_TP_CD M/O) — 그 외 잠금.
export const isRowEditable = (row: Record<string, unknown>, canEdit: boolean): boolean => {
  if (!canEdit) return false;
  if (str(row.ERP_STATUS) === 'C') return false;
  if (isInsertedRow(row)) return true;
  return str(row.SHIPMENT_STATUS) === 'C';
};
