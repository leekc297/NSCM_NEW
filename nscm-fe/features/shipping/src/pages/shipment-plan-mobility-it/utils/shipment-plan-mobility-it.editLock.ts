// 편집 잠금 판정 (design 03 §3.A/§3.B, 01 R7) — formatItem(색)·beginningEdit(e.cancel) 공통 사용.
//   DB SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 336건 전건 'S'(갭#A)라 코드 화이트리스트로 재현 —
//   admin 메타(INPUT_TP_CD) 정비 시 메타 기준으로 전환한다(design 03 §6-A).

import {
  CONFIRM_DETAIL_EDITABLE_COLUMNS,
  CONFIRM_DETAIL_PACKER_EXTRA_EDITABLE,
  HOLD_STOCK_EDITABLE_COLUMNS,
  MAIN_EDITABLE_MEASURE,
  MES_STOCK_EDITABLE_COLUMNS,
  SHEETS,
} from '../shipment-plan-mobility-it.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const CONFIRM_SET = new Set<string>(CONFIRM_DETAIL_EDITABLE_COLUMNS);
const CONFIRM_PACKER_EXTRA_SET = new Set<string>(CONFIRM_DETAIL_PACKER_EXTRA_EDITABLE);
const HOLD_SET = new Set<string>(HOLD_STOCK_EDITABLE_COLUMNS);
const MES_SET = new Set<string>(MES_STOCK_EDITABLE_COLUMNS);

/**
 * master(PSI) 셀 편집 가능 판정 (design 03 §3.A, AS-IS SSP0015.cs L1789~1802 EditButton unlock):
 *   canEdit(hasButton('EDIT') 마운트 1회 — AS-IS EditButton 토글 미이식, convert-core §2.4)
 *   + MEASURE=='WH_IN' 행 + D_ 컬럼. AS-IS 는 WH_IN 행의 MEASURE+1~끝 전체를 열고 W_/M_ 합계만
 *   SetLockSumColumn 으로 재잠금하며, 편집을 날짜로 제한하지 않는다(확정구간은 색만, 잠금 아님 — L2745).
 *   W_/M_/B_(Sum·텍스트) 컬럼은 D_ 아님이라 편집 불가.
 */
export const isMainCellEditable = (
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean
): boolean => {
  if (!canEdit || !row) return false;
  if (!binding.startsWith('D_')) return false;
  return str(row.MEASURE) === MAIN_EDITABLE_MEASURE;
};

/**
 * detail 셀 편집 가능 판정 (design 03 §3.A):
 *   - Shipment Confirm Detail(shtDetail): 화이트리스트 7컬럼 + 행 SHIPMENT_STATUS=='C' && ERP_STATUS!='C'.
 *     신규행(CRUD_TYPE='I')은 화이트리스트 7컬럼 편집(canEdit 무관 — Insert 경로).
 *   - Hold stock: canEdit 전행 3컬럼(신규행 포함).
 *   - MES Stock Detail: canEdit 2컬럼(MES_CHANGE_STATUS=='D' / AVAILABLE_YN=='-' 행은 전잠금).
 *   - 그 외 읽기전용 시트: 전면 잠금(design 03 §1.E).
 */
export const isDetailCellEditable = (
  sheet: SHEETS,
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean,
  // Packer 탭이면 Confirm Detail 의 Ship to(TO_SITE_SHIPTO_CODE)도 편집 가능(AS-IS L1864).
  isPacker = false
): boolean => {
  if (!row) return false;
  const isInsertedRow = str(row.CRUD_TYPE) === 'I';
  if (sheet === SHEETS.CONFIRM_DETAIL) {
    const editableCol = CONFIRM_SET.has(binding) || (isPacker && CONFIRM_PACKER_EXTRA_SET.has(binding));
    if (!editableCol) return false;
    if (isInsertedRow) return true;
    if (!canEdit) return false;
    return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) !== 'C';
  }
  if (sheet === SHEETS.HOLD_STOCK) {
    if (!HOLD_SET.has(binding)) return false;
    return canEdit || isInsertedRow;
  }
  if (sheet === SHEETS.MES_STOCK) {
    if (!MES_SET.has(binding)) return false;
    if (!canEdit) return false;
    // MES_CHANGE_STATUS=='D' 또는 AVAILABLE_YN=='-' 행 전잠금 (design 03 §3.A L1899-1901)
    if (str(row.MES_CHANGE_STATUS) === 'D' || str(row.AVAILABLE_YN) === '-') return false;
    return true;
  }
  return false;
};

/**
 * drpPeriod2 무메시지 clamp (design 02 §2.5) — drpPeriod 범위를 벗어나면 조용히 되돌린다.
 */
export const clampPeriod2 = (
  from: string,
  to: string,
  boundFrom: string,
  boundTo: string
): { from: string; to: string } => {
  if (!boundFrom || !boundTo) return { from, to };
  return {
    from: from && from >= boundFrom && from <= boundTo ? from : boundFrom,
    to: to && to >= boundFrom && to <= boundTo ? to : boundTo,
  };
};
