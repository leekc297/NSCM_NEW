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
 * 현재 TO-BE 메타는 124행 전건 `INPUT_TP_CD='S'` 라 컬럼 축이 전부 잠겨 있다.
 *   정비 UPDATE(M 3 / IM 7 / O 8 / shtSub M 2·O 4)는 `design/05_register_input-tp-cd.sql` 로
 *   분리 산출했고 **사용자 결정에 따라 DB 에 적용하지 않았다** — 그래서 편집·필수검증 축은
 *   이번 회차 「미검증」이다. 커스텀 화이트리스트로 우회하면 `useSaveWithValidation` 의
 *   필수검사가 조용히 무발동한다(메모리 input-tp-cd-search-only-kills-save-validation).
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
