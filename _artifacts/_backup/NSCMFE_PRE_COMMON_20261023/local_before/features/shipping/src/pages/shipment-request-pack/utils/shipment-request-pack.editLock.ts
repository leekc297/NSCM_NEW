import {
  INSERT_EDITABLE_COLUMNS_MAIN,
  REQUEST_DETAIL_EDIT_COLUMNS,
} from '../shipment-request-pack.constants';

/**
 * spdMain(Pack Biz/Cell Biz) 셀 편집 가능 판정(design 01 R7/R9, `.cs:628-822`/`:2120-2186`).
 *
 * - 신규행(CRUD_TYPE='I')은 `INSERT_EDITABLE_COLUMNS_MAIN` 화이트리스트만 unlock(R9).
 *   Measure=="SHIP_REQ" 행의 확정구간 이후 동적 pivot 컬럼 추가 unlock 은 CONFIRM_DAY 기반 판정이
 *   아직 없어(design 01 R7/R18, GAP-08) 이번 회차에는 포함하지 않는다 — 잠금 유지(확인 필요 이월).
 * - 기존행은 Edit 버튼 토글(`isEditMode`) 상태를 그대로 따른다 — Measure=="SHIP_REQ" 행만
 *   확정구간 이후로 좁히는 세분화(R7)는 위와 같은 이유로 이번 회차 미착수, 전체 unlock 으로 남긴다.
 */
export const isMainGridCellEditable = (params: {
  columnBinding: string;
  crudType?: string;
  isEditMode: boolean;
}): boolean => {
  const { columnBinding, crudType, isEditMode } = params;
  if (crudType === 'I') return (INSERT_EDITABLE_COLUMNS_MAIN).includes(columnBinding);
  return isEditMode;
};

/**
 * spdDetail "Shipment Request Detail" 셀 편집 가능 판정(design 01 R6/R8, `.cs:823-899`).
 *
 * - 신규행(CRUD_TYPE='I')은 R10(Division+1~2/ShipToCode+2~3/NickName+1/Requestor~EditFlag/FromSite+1/
 *   Remark+1~끝 잠금) 대상이나, 그 오프셋이 가리키는 실제 컬럼 바인딩이 design 문서에 1:1로 확정되지
 *   않아(확인 필요) 이번 회차는 임의 추정 없이 기존행과 동일하게 편집모드 전체 unlock 으로 둔다
 *   (회귀 방지 — 04_react-gap.md 이월).
 * - 기존행은 EDIT_FLAG=='Y' 인 행만 `REQUEST_DETAIL_EDIT_COLUMNS`(Qty~REMARK) unlock, 그 외 행은
 *   편집모드 여부와 무관하게 항상 잠금(R6/R8).
 */
export const isRequestDetailCellEditable = (params: {
  columnBinding: string;
  crudType?: string;
  editFlag?: string;
  isEditMode: boolean;
}): boolean => {
  const { columnBinding, crudType, editFlag, isEditMode } = params;
  if (!isEditMode) return false;
  if (crudType === 'I') return true;
  return editFlag === 'Y' && (REQUEST_DETAIL_EDIT_COLUMNS).includes(columnBinding);
};
