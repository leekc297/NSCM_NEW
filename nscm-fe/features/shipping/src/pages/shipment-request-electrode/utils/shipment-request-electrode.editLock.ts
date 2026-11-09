import {
  INSERT_LOCK_COLUMNS,
  MEASURE,
  REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG,
} from '../shipment-request-electrode.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

const isValidYmd8 = (s: string): boolean => /^\d{8}$/.test(s);

/** 임의 토큰 → yyyymmdd 8자리(비숫자 제거). */
const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

/**
 * 요청상세(spdDetail.shtRequestDetail) 행의 편집 가능 컬럼 판정 — AS-IS InsertRow(cs:1447-1472) + EditButton
 * spdDetail(cs:1703-1718) 실측(LockRange2(...,true)=Lock, SpreadInfo.cs:7072).
 *
 * - 신규행(CRUD_TYPE='I')은 Insert 직후 5컬럼(INSERT_LOCK_COLUMNS)만 lock, 나머지 편집가능(cs:1466-1470).
 * - 기존행은 편집모드(canEdit) 중에만, EDIT_FLAG 값별로 **잠기지 않은** 컬럼만 편집가능
 *   (REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG): EDIT_FLAG='N' → 없음(행 전체 잠금) / 그 외 → SHIPMENT_QTY·INCOTERMS·TRANSPORT_MODE.
 *   REQUEST_DATE·REQUESTOR·SHIPMENT_DATE·DIVISION_ID 등은 기존행에서 항상 잠긴다(사용자 지적 2026-11-05 교정).
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

// ── 메인 pivot(spdMain) 편집 — AS-IS EditButton spdMain 분기(cs:1500-1562) ──
//   편집·저장 모두 **X축(UOM) 일(Daily) 셀만** 대상이다(cs:1520 "X_D_"+CONFIRM_DAY / cs:1550 "X_D_"+기간종료 /
//   cs:2781 Tag.IndexOf("X_D_")==0). 다른 축(Y_/Z_)·버킷(W_/M_)은 편집/저장 대상이 아니다.
const PIVOT_DAY_X_PATTERN = /^X_D_(\d{8})$/;

/** X축 일 셀(X_D_yyyymmdd) 여부 — 편집/저장 공용 게이트. */
export const isPivotDayXBinding = (binding: string): boolean => PIVOT_DAY_X_PATTERN.test(binding);

/** X_D_ binding 에서 yyyymmdd 8자리. 아니면 ''. */
export const dayOfPivotBinding = (binding: string): string => {
  const m = PIVOT_DAY_X_PATTERN.exec(binding);
  return m ? m[1] : '';
};

/** From/To Site 가 실제 사이트인지(AS-IS strFromSite != "-" && strToSite != "-", cs:1531/1548). */
const hasRealSites = (row: Record<string, unknown>): boolean => {
  const from = str(row.FROM_SITE);
  const to = str(row.TO_SITE);
  return !!from && from !== '-' && !!to && to !== '-';
};

/**
 * 메인 pivot 셀 편집 가능 판정 — AS-IS EditButton spdMain 편집모드 진입 분기(cs:1500-1562)의 1:1.
 *   `MEASURE==='R_SHIP_REQ_ETA'` 행의 X_D_ 일 셀 중 **확정일(CONFIRM_DAY) 다음날 ~ 조회기간 종료일** 구간만
 *   편집 가능하다(cs:1550 `j=intEndIdx+1 .. X_D_+기간종료`, SUM 열 제외 — X_D_ 게이트로 SUM(W_/M_) 자동 배제).
 *   확정일 이전(포함) 구간은 잠금 + BACK_COLOR 틴트([[isShipmentPsiPastTinted]]). From/To Site 가 '-'(미지정)이면 전체 잠금.
 *   confirmDay 공백/무효면 AS-IS `intEndIdx==-1 → continue`(cs:1544-1547) 등가로 편집 셀 없음.
 */
export const isShipmentPsiCellEditable = (params: {
  row: Record<string, unknown>;
  binding: string;
  periodStartYyyymmdd: string;
  periodEndYyyymmdd: string;
}): boolean => {
  const { row, binding, periodStartYyyymmdd, periodEndYyyymmdd } = params;
  if (!isPivotDayXBinding(binding)) return false;
  if (str(row.MEASURE) !== MEASURE.SHIP_REQ_ETA) return false;
  if (!hasRealSites(row)) return false;
  const confirmDay = str(row.CONFIRM_DAY);
  if (!isValidYmd8(confirmDay)) return false; // intEndIdx==-1 등가(확정일 없음/무효 → 편집 없음)
  const start = ymd8(periodStartYyyymmdd);
  const end = ymd8(periodEndYyyymmdd);
  // AS-IS intEndIdx = GetColumnIndex("X_D_"+CONFIRM_DAY) 가 -1 이면 행 전체 skip(cs:1544). 확정일 컬럼은 조회기간
  //   (from~to) 캘린더에만 생성되므로, 확정일이 그 범위 밖이면 편집 셀이 아예 없다 — 이 가드를 빠뜨리면 확정일이
  //   조회 시작일보다 과거인 행에서 전 구간이 편집 가능해져 AS-IS 와 벌어진다(2026-11-04 사용자 지적).
  if (isValidYmd8(start) && confirmDay < start) return false;
  if (isValidYmd8(end) && confirmDay > end) return false;
  const day = dayOfPivotBinding(binding);
  if (isValidYmd8(end) && day > end) return false; // 조회기간 밖
  return day > confirmDay; // 확정일 '이후'만 개방(cs:1550 intEndIdx+1 ~ idx(X_D_periodEnd))
};

/**
 * 메인 pivot 확정(과거) 구간 — AS-IS BACK_COLOR 틴트 대상(cs:1526-1538 `Cells[i, MEASURE+2, i, X_D_confirmDay]`).
 *   R_SHIP_REQ_ETA 행 + From/To Site 유효 + confirmDay 유효 + date<=confirmDay(확정일 포함) X_D_ 셀.
 *   색(RGB)은 행의 BACK_COLOR("R,G,B")를 호출부(formatItem)가 적용한다.
 */
export const isShipmentPsiPastTinted = (params: {
  row: Record<string, unknown>;
  binding: string;
  periodStartYyyymmdd: string;
  periodEndYyyymmdd: string;
}): boolean => {
  const { row, binding, periodStartYyyymmdd, periodEndYyyymmdd } = params;
  if (!isPivotDayXBinding(binding)) return false;
  if (str(row.MEASURE) !== MEASURE.SHIP_REQ_ETA) return false;
  if (!hasRealSites(row)) return false;
  const confirmDay = str(row.CONFIRM_DAY);
  if (!isValidYmd8(confirmDay)) return false;
  // 편집 가능 판정과 동일하게 확정일 컬럼이 조회기간 밖이면 틴트 없음(AS-IS intEndIdx==-1 → backcolor 블록 미실행).
  const start = ymd8(periodStartYyyymmdd);
  const end = ymd8(periodEndYyyymmdd);
  if (isValidYmd8(start) && confirmDay < start) return false;
  if (isValidYmd8(end) && confirmDay > end) return false;
  return dayOfPivotBinding(binding) <= confirmDay;
};
