import {
  INSERT_LOCK_COLUMNS,
  REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG,
} from '../shipment-request-electrode.constants';

/**
 * 요청상세(spdDetail.shtRequestDetail) 행의 편집 가능 컬럼 판정 — design 01 R10 / 03 §3 규칙#11.
 *
 * - 신규행(CRUD_TYPE='I')은 Insert 직후 5컬럼(INSERT_LOCK_COLUMNS) lock (design 01 R6, cs:1466-1470).
 * - 기존행은 EditButton 진입(편집모드) 중에만 EDIT_FLAG 값별 컬럼범위가 unlock 된다:
 *   EDIT_FLAG='N'(신규 미확정) → REQUEST_DATE만 / 그 외 → SHIPMENT_DATE + REQUESTOR~REQUEST_DATE.
 * - 편집모드가 아니면(조회 직후) 전체 lock(design 03 §3 규칙#18, LockColumn(0,max,true)).
 */
export const isRequestDetailCellEditable = (params: {
  columnBinding: string;
  crudType?: string;
  editFlag?: string;
  isNewRow: boolean;
  isEditMode: boolean;
}): boolean => {
  const { columnBinding, editFlag, isNewRow, isEditMode } = params;

  if (isNewRow) return !INSERT_LOCK_COLUMNS.includes(columnBinding);

  if (!isEditMode) return false;

  const flagKey = editFlag === 'N' ? 'N' : 'DEFAULT';
  return REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG[flagKey].includes(columnBinding);
};

/** Stock Detail 시트는 항상 읽기전용(design 01 R10, ReadOnlySheetList, cs:455). */
export const isStockDetailCellEditable = (): boolean => false;
