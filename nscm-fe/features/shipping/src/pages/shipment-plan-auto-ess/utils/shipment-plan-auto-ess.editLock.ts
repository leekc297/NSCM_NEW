// 편집 잠금 판정 (design 03 §3.3, 01 R6) — formatItem(색)·beginningEdit(e.cancel) 공통 사용.
//   DB SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 가 전건 'S'(잠금)라 코드 화이트리스트로 재현 —
//   admin 메타 정비 시 메타(INPUT_TP_CD) 기준으로 전환한다(design 03 §5-5).

import {
  MAIN_EDITABLE_MEASURE,
  PLAN_DETAIL_EDITABLE_COLUMNS,
  SHEETS,
} from '../shipment-plan-auto-ess.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const PLAN_DETAIL_SET = new Set<string>(PLAN_DETAIL_EDITABLE_COLUMNS);

/**
 * Main(PSI) 셀 편집 가능 판정:
 *   canEdit(권한 hasButton('EDIT') · 최신Plan realFlag) + MEASURE=='SHIP_PLAN'(편집 유일) + D_ 컬럼 +
 *   **CONFIRM_DAY 초과** 일자. W_/M_(Sum) 컬럼은 항상 잠금(03 §2.2).
 *   canEdit = hasButton('EDIT')(마운트 1회) — AS-IS EditButton 토글 미이식(convert-core §2.4).
 *
 * 확정구간(= curPlanDate ~ CONFIRM_DAY)은 조회전용이다 — 사용자 결정(자매 SSP0060 과 통일).
 *   AS-IS EditButton 과 design 03 §1.2/§2.3 은 `curPlanDate <= 일자 <= CONFIRM_DAY` 창을
 *   **편집창**으로 적었다. 확정(frozen)된 구간을 편집 표면으로 두는 셈이라 사용자가 반대로 확정했다:
 *   확정구간은 잠그고, 편집은 그 구간을 지난 일자에서만 허용한다.
 *   그래서 이 함수의 CONFIRM_DAY 비교는 AS-IS·design 과 **의도적으로 반대**다(convert-core §2.4 이탈 기록).
 *   자매 SSP0060 `shipment-plan/utils/shipment-plan.editLock.ts` 와 같은 판정이다.
 *
 * CONFIRM_DAY 는 서버가 행별로 내려주는 확정구간 종료일이다 — 플랜트별로 다르므로(SSP0060 실측
 *   14·21·28·56일 등) 경계를 화면 전역 상수로 굳히지 않고 행 값으로만 판정한다.
 *   공백·null 이면 확정구간이 없는 것으로 보고 curPlanDate 이후 전 일자를 편집 허용한다.
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
  const ymd = binding.slice(2);
  const confirmDay = str(row.CONFIRM_DAY).trim();
  if (curPlanDate && ymd < curPlanDate) return false;
  // 확정구간(일자 <= CONFIRM_DAY) = 조회전용 → 편집은 확정구간을 지난 일자에서만
  if (confirmDay && ymd <= confirmDay) return false;
  return true;
};

/**
 * Detail 셀 편집 가능 판정:
 *   - Shipment Plan Detail: canEdit + 행 SHIPMENT_STATUS=='C' && ERP_STATUS!='C' + 화이트리스트 7컬럼 (03 §3.3)
 *     Insert(F8) 신규행(CRUD_TYPE='I')은 동일 7컬럼만 편집(03 §3-E — canEdit 무관).
 *   - 나머지 6개 시트(Hold stock 포함): 전면 read-only — Hold stock 은 SAVE SP 미배포(표시전용, goal.md ②).
 *   canEdit = hasButton('EDIT')(마운트 1회) — AS-IS EditButton 토글 미이식(convert-core §2.4).
 */
export const isDetailCellEditable = (
  sheet: SHEETS,
  row: Record<string, unknown> | undefined,
  binding: string,
  canEdit: boolean
): boolean => {
  if (!row) return false;
  if (sheet !== SHEETS.PLAN_DETAIL) return false; // Hold stock 등 나머지 전면 잠금
  // 신규행 판정은 공통 CRUD_TYPE 전용(core §2.4 — 자체 행상태 필드 신설 금지)
  const isInsertedRow = str(row.CRUD_TYPE) === 'I';
  if (!PLAN_DETAIL_SET.has(binding)) return false;
  if (isInsertedRow) return true;
  if (!canEdit) return false;
  return str(row.SHIPMENT_STATUS) === 'C' && str(row.ERP_STATUS) !== 'C';
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
