import {
  INSERT_EDITABLE_COLUMNS_MAIN,
  REQUEST_DETAIL_EDIT_COLUMNS,
} from '../shipment-request-pack.constants';
import type { SearchParamProps } from '../shipment-request-pack.types';

import { parseDynamicColumnTag } from './shipment-request-pack.dynamicColumn';
import { BUCKET_PREFIX } from './shipment-request-pack.spreadHeader';

const MAIN_EDITABLE_MEASURE = ['SHIP_REQ', 'Ship Req'];

/**
 * 확정구간(회색) 판정(design 01 R18, AS-IS cs:718-724 SetBGColor 242,242,242) — 활성 D_ 날짜 컬럼 중
 * confirmDay(Pack=Plan_InforPacker_SCP NAME / Cell=CONFIRM_DAY, yyyymmdd) 이하(과거/확정) 셀. 전 행 적용.
 * W_/M_ 는 AS-IS 가 "D_"+confirmDay 컬럼 인덱스로만 회색 처리(일 단위)라 대상 아님.
 */
export const isMainGridDateConfirmed = (columnBinding: string, confirmDay?: string): boolean => {
  if (!confirmDay) return false;
  const tag = parseDynamicColumnTag(columnBinding);
  return !!tag && tag.bucket === 'D' && tag.yyyymmdd <= confirmDay;
};

/**
 * spdMain(Pack Biz/Cell Biz) 셀 편집 가능 판정(design 01 R7/R9/R18, `.cs:628-822`/`:2120-2186`).
 *
 * - 신규행(CRUD_TYPE='I')은 `INSERT_EDITABLE_COLUMNS_MAIN` 화이트리스트만 unlock(R9).
 * - 기존행(R7): Measure=="SHIP_REQ" 행의 **활성 버킷 동적(D_/W_/M_) 컬럼**이 편집 가능하다. 확정구간
 *   (D_ ≤ confirmDay)도 편집 가능하다 — AS-IS EditButton(Cell Biz) cs:713 `LockRange(startIdx..endIdx,
 *   false)` 가 SHIP_REQ 행의 동적 전 구간(확정구간 포함)을 언락하고, cs:720/724 회색(242,242,242)은
 *   색상만 입힌다(사용자 신고 2026-11-09 — 종전 TO-BE 는 확정구간을 잠가 AS-IS 와 어긋났다). 정적 컬럼·
 *   비활성 버킷·他 measure 는 잠금. 회색 시각표시는 `isMainGridDateConfirmed`(formatItem) 로 그대로 유지.
 */
export const isMainGridCellEditable = (params: {
  columnBinding: string;
  crudType?: string;
  isEditMode: boolean;
  measure?: string;
  bucketType?: SearchParamProps['bucketType'];
  confirmDay?: string;
}): boolean => {
  const { columnBinding, crudType, isEditMode, measure, bucketType, confirmDay } = params;
  if (crudType === 'I') {
    // 정적 화이트리스트(Model/From/To/FcstType/TrMode/Incoterms) + SHIP_REQ 신규행의 확정일 이후 D_
    //   날짜셀(비-SUM) 도 수량 입력 가능(AS-IS InsertRow cs:2160-2183). W_/M_(SUM 집계)·확정일 이하·
    //   他 measure 는 잠금 — 정적+동적을 합쳐 신규행 편집면을 AS-IS 와 일치시킨다(GAP-B1 해소).
    if (INSERT_EDITABLE_COLUMNS_MAIN.includes(columnBinding)) return true;
    if (!MAIN_EDITABLE_MEASURE.includes(measure ?? '')) return false;
    const insTag = parseDynamicColumnTag(columnBinding);
    if (!insTag || insTag.bucket !== 'D') return false; // D_ 만(W_/M_ = SUM → 잠금)
    return !isMainGridDateConfirmed(columnBinding, confirmDay); // 확정일 이하 잠금
  }
  if (!isEditMode) return false;
  if (!MAIN_EDITABLE_MEASURE.includes(measure ?? '')) return false; // SHIP_REQ 행만
  const tag = parseDynamicColumnTag(columnBinding);
  if (!tag) return false; // 정적 컬럼 잠금
  if (bucketType && tag.bucket !== BUCKET_PREFIX[bucketType]) return false; // 비활성 버킷 잠금
  // 확정구간(D_ ≤ confirmDay)도 편집 가능 — AS-IS cs:713 가 SHIP_REQ 행 동적 전 구간을 언락(회색은 색상만,
  //   item 4 사용자 신고 2026-11-09). 회색 표시는 isMainGridDateConfirmed(formatItem) 로 유지, 잠금은 하지 않는다.
  return true;
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
