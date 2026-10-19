import {
  COLUMN,
  CRUD_INSERT,
  ERP_STATUS_CONFIRM,
  SHIPMENT_STATUS_CONFIRM,
} from '../shipment-change-request-plan.constants';

import { str, type GridRowData } from './shipmentChangeRequestPlanDerive';

/**
 * 행 단위 편집 가드 (design 03 §3.4 "행 조건").
 *
 * 금지(hook #130): AS-IS `LockColumn`/`LockRange` 42건을 FE 컬럼명 상수 배열로 이식하는 것.
 *   **열 단위 잠금의 원천은 `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 다** — 공용 DataGrid 가
 *   `GridUtils.isEditableCell` 로 소비한다. 여기서는 메타로 표현할 수 없는 **행 조건만** 판정한다.
 *
 * 컬럼 축 편집 메타(`INPUT_TP_CD`)는 `design/05_register_input-tp-cd.sql` 로 정비했고 **2026-09-29
 *   DB 에 적용**했다(그리드 편집·콤보 전무 신고 해소). 실측 분포 S=100 / M=5 / IM=7 / O=12 —
 *   24컬럼이 편집 가능이다. FE 는 컬럼 화이트리스트로 우회하지 않는다(hook #130): 우회하면 공용
 *   `useSaveWithValidation` 의 메타 기반 필수검사가 조용히 무발동한다
 *   (메모리 input-tp-cd-search-only-kills-save-validation).
 */
export const isRowEditable = (row: GridRowData, canEdit: boolean): boolean => {
  if (!canEdit) return false;
  // ERP 확정행은 전면 차단(R-25 / CP-13 / MSG01202).
  if (str(row[COLUMN.ERP_STATUS]) === ERP_STATUS_CONFIRM) return false;
  // 신규행은 항상 편집 대상(열 잠금은 INPUT_TP_CD='IM' 이 담당).
  if (str(row.CRUD_TYPE) === CRUD_INSERT) return true;
  // 기존행은 SHIPMENT_STATUS='C' 이고 ERP_STATUS!='C' 일 때만 편집 가능하다.
  return str(row[COLUMN.SHIPMENT_STATUS]) === SHIPMENT_STATUS_CONFIRM;
};

export const isInsertedRow = (row: GridRowData): boolean => str(row.CRUD_TYPE) === CRUD_INSERT;

export const isErpConfirmed = (row: GridRowData): boolean =>
  str(row[COLUMN.ERP_STATUS]) === ERP_STATUS_CONFIRM;
