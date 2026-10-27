// 편집 잠금 판정 (design 03 §3-E/F, 01 R6) — formatItem(색)·beginningEdit(e.cancel) 공통 사용.
//   DB SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 전건 'S'(갭#1)라 코드 화이트리스트로 재현 —
//   admin 메타 정비 시 메타(INPUT_TP_CD) 기준으로 전환한다(03 §5-2).

import {
  HOLD_STOCK_EDITABLE_COLUMNS,
  MAIN_EDITABLE_MEASURE,
  PLAN_DETAIL_EDITABLE_COLUMNS,
  SHEETS,
} from '../shipment-plan.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const PLAN_DETAIL_SET = new Set<string>(PLAN_DETAIL_EDITABLE_COLUMNS);
const HOLD_STOCK_SET = new Set<string>(HOLD_STOCK_EDITABLE_COLUMNS);

// BtnNew(2차 NEW) 신규행 식별 — InsertRow(F8) 신규행과 편집 스팬이 다르다(gap-audit J1).
//   저장 대상 판정은 CRUD_TYPE 전용 유지(core §2.4) — 이 집합은 편집 스팬 판정 전용이며
//   행 객체(WeakSet 키) 수명과 함께 소멸한다. 페이지 handleNew 가 생성 직후 마킹한다.
const btnNewRows = new WeakSet<object>();
export const markBtnNewRow = (row: object): void => {
  btnNewRows.add(row);
};

// BtnNew 신규행 잠금 스팬 (AS-IS BtnNew_Click L7436~7437 LockRange 2회):
//   DIVISION_ID..PRODUCT_LEVEL1 + MTK_OWNER..ORIGIN_TO_DIVISION_ID 잠금, 그 밖 전 컬럼 편집.
//   InsertRow 잠금 스팬(DIVISION_ID..FCST_TYPE — 여백이 화이트리스트 7컬럼과 일치, 03 §1.2)보다
//   앞 스팬이 짧아 ITEM_ID·route·PROJECT 구간이 추가로 편집 가능하다.
//   주의: 경계 컬럼은 admin 메타(SCM_MST_SHEET_COLUMNS) 실제 바인딩과 철자가 정확히 같아야 한다 —
//   indexOf 가 못 찾으면 buildBtnNewLockedBindings 가 null 을 반환해 7컬럼 폴백으로 떨어진다.
//   MKT Owner 의 실제 바인딩은 MTK_OWNER 다(메타 실측 — 전치 표기, 자매 화면들도 MTK_OWNER 사용).
const BTN_NEW_LOCK_SPANS: [string, string][] = [
  ['DIVISION_ID', 'PRODUCT_LEVEL1'],
  ['MTK_OWNER', 'ORIGIN_TO_DIVISION_ID'],
];

/**
 * admin 메타 컬럼 순서(콤보 순서가 아니라 SCM_MST_SHEET_COLUMNS SORT 순 — DB 가 단일 원천)로
 * BtnNew 잠금 스팬을 binding 집합으로 변환한다. 경계 컬럼이 메타에 없거나 순서가 어긋나면
 * null 반환 — 호출부는 화이트리스트 7컬럼 폴백(안전측)으로 처리한다.
 */
export const buildBtnNewLockedBindings = (orderedBindings: string[]): Set<string> | null => {
  const locked = new Set<string>();
  for (const [from, to] of BTN_NEW_LOCK_SPANS) {
    const fromIdx = orderedBindings.indexOf(from);
    const toIdx = orderedBindings.indexOf(to);
    if (fromIdx < 0 || toIdx < fromIdx) return null;
    orderedBindings.slice(fromIdx, toIdx + 1).forEach(b => locked.add(b));
  }
  return locked;
};

/**
 * Main(PSI) 셀 편집 가능 판정:
 *   canEdit(권한 hasButton('EDIT') · 최신Plan realFlag) + MEASURE=='SHIP_PLAN_DETAIL' + TO_SITE 비공백 + D_ 컬럼 +
 *   **확정구간(curPlanDate <= 일자 <= CONFIRM_DAY)** 일자. W_/M_(Sum) 컬럼은 항상 잠금(03 §2.3).
 *   canEdit = hasButton('EDIT')(마운트 1회) — AS-IS EditButton 토글 미이식(convert-core §2.4).
 *
 * 편집창 = 확정구간(curPlanDate ~ CONFIRM_DAY) — AS-IS 그대로(사용자 결정 2026-10-21, 종전 2026-10-12
 *   반전 결정을 되돌림). AS-IS EditButton(cs L2777~2785)은 전 컬럼 잠금 후 `curPlanDate <= 일자 <=
 *   CONFIRM_DAY` 창의 D_·비SUM 셀만 `LockRange(..., false)` 로 해제한다. design 03 §3-F 와 동일.
 *   수정 가능 셀은 노란색(wj-cell-editable), 그 밖(확정구간 이전·이후)은 조회전용 하늘색(Rc)이다
 *   (사용자 지시 2026-10-21 "수정 가능 셀 노란색, 수정 불가 셀 하늘색 — 수정 가능 여부는 AS-IS 로직").
 *
 * CONFIRM_DAY 는 서버가 행별로 내려주는 확정구간 종료일이다(PKG_SSP0060 L3890 실측):
 *   `TO_CHAR(TO_DATE(planStart) + NVL(A.CONFIRM_DAY, 0), 'YYYYMMDD')` — NVL 로 항상 채워지고
 *   (offset null 이면 planStart 자신), offset 은 `SCM_MST_SITE.SHIP_FROZEN` 파생이라 플랜트별로
 *   다르다(실측 14·21·28·56일 등). 경계를 화면 전역 상수로 굳히지 않고 행 값으로만 판정한다.
 *   공백이면 창이 성립하지 않아 조회전용(AS-IS `GetDateFromYYYYMMDD("")` 가 MinValue 라 창 밖).
 */
export const isMainCellEditable = (
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean,
  curPlanDate: string
): boolean => {
  if (!canEdit || !row) return false;
  if (!binding.startsWith('D_')) return false;
  if (str(row.MEASURE) !== MAIN_EDITABLE_MEASURE) return false;
  if (str(row.TO_SITE).trim() === '') return false;
  const ymd = binding.slice(2);
  const confirmDay = str(row.CONFIRM_DAY).trim();
  // 확정구간 창: curPlanDate <= 일자 <= CONFIRM_DAY 만 편집 가능(AS-IS). 공백 CONFIRM_DAY = 창 없음.
  if (!confirmDay) return false;
  if (curPlanDate && ymd < curPlanDate) return false;
  if (ymd > confirmDay) return false;
  return true;
};

/**
 * Detail 셀 편집 가능 판정:
 *   - Shipment Plan Detail: canEdit + 행 SHIPMENT_STATUS=='C' && ERP_STATUS!='C' + 7컬럼 (03 §3-F)
 *     Insert(F8) 신규행(CRUD_TYPE='I')은 잠금 스팬 여백 = 동일 7컬럼만 편집(03 §3-E — canEdit 무관).
 *     BtnNew(2차 NEW) 신규행은 잠금 2스팬 밖 전 컬럼 편집(J1 — btnNewLockedBindings 필요).
 *   - Hold stock: canEdit 전행 3컬럼 (행별 상태분기 없음). 신규행도 동일 3컬럼.
 *   - 나머지 5개 시트: 전면 read-only (03 §1.5~1.9).
 *   canEdit = hasButton('EDIT')(마운트 1회) — AS-IS EditButton 토글 미이식(convert-core §2.4).
 */
export const isDetailCellEditable = (
  sheet: SHEETS,
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean,
  btnNewLockedBindings?: Set<string> | null
): boolean => {
  if (!row) return false;
  // 신규행 판정은 공통 CRUD_TYPE 전용(core §2.4 — 자체 행상태 필드 신설 금지)
  const isInsertedRow = str(row.CRUD_TYPE) === 'I';
  if (sheet === SHEETS.PLAN_DETAIL) {
    // BtnNew 신규행 — 잠금 스팬 밖 전 컬럼(메타 순서 미확보 시 화이트리스트 폴백 = 안전측)
    if (isInsertedRow && btnNewLockedBindings && btnNewRows.has(row)) {
      return !btnNewLockedBindings.has(binding);
    }
    if (!PLAN_DETAIL_SET.has(binding)) return false;
    if (isInsertedRow) return true;
    if (!canEdit) return false;
    return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) !== 'C';
  }
  if (sheet === SHEETS.HOLD_STOCK) {
    if (!HOLD_STOCK_SET.has(binding)) return false;
    return canEdit || isInsertedRow;
  }
  // 시트 2~6(Stock Location/oWMS/MES Stock/MES Stock Detail/Shipment Result) — 전면 read-only.
  //   AS-IS 는 Edit 시 SwitchLock 으로 셀이 노랗게 "수정 진입"은 되나 **저장 SP 가 없어 실제 편집/저장은
  //   안 된다**(사용자 확인 2026-10-20). 2026-10-20 에 전컬럼 편집개방을 넣었다가 AS-IS 재확인 후 롤백한다.
  return false;
};

/**
 * ERP D/O 편집차단 경고(MSG00189/MSG01401)를 띄울 셀인지 — "ERP_STATUS='C' 때문에만 막힌
 * 편집 대상 셀"에서만 true. = Plan Detail 편집 화이트리스트 컬럼 + 기존 행 SHIPMENT_STATUS='C'
 * + ERP_STATUS='C'. SO_NO 등 읽기전용 컬럼(화이트리스트 밖)과 신규행(ERP_STATUS 공백 강제)은
 * 제외한다 — 읽기전용 셀 더블클릭(= OrderDetail 팝업 열기)에는 경고가 뜨지 않게 하기 위함.
 *   AS-IS shtDetail_Change(cs L1064~1069)도 잠금해제 시트의 값 변경에만 MSG00189 를 띄운다.
 */
export const isErpDoBlockedCell = (
  sheet: SHEETS,
  row: Record<string, unknown> | undefined,
  binding: string
): boolean => {
  if (!row || sheet !== SHEETS.PLAN_DETAIL) return false;
  if (!PLAN_DETAIL_SET.has(binding)) return false;
  return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) === 'C';
};

/**
 * drpPeriod2 무메시지 clamp (design 02 §3 buttonGuard #37):
 *   drpPeriod(PlanDate 파생 범위)를 벗어나면 조용히 그 범위 값으로 되돌린다 — 안내 문구 추가 금지.
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
