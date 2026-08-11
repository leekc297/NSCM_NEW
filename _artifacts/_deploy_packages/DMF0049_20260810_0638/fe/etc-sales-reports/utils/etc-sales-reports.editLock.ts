// ⭐ DMF0049 — 편집/잠금 규칙 엔진 (제약매트릭스 §2~§6 전수 — AS-IS EditButton L338~461 / InsertRow L965~1056).
//   ⚠ DMF0044와 정반대 지점: **EDIT_FLAG 는 동적 셀 규칙에서 미사용** (EditButton 루프 L396~461 에
//   값 비교 없음 — InsertRow 재잠금 L1056 의 'Y' 행 키잠금만. §2.3 이중 게이트 비대칭 실측).
//   규칙 축: G0 그룹 게이트 / baseYm(BP='201801' 6자리 단일 — 결함② 교정) / Plan·Result 시점 /
//   sEditMeasure(DM_SR_ETC_CURRENCY — 82='SalesAmt_KRW' 뿐, 81 빈값=전잠금) / division(40 완화).
import { BP_BASE_YM, PLAN_RESULT, REPORT_TYPE } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow } from '../etc-sales-reports.types';

import { isDiv40, isDiv81, isDiv82 } from './etc-sales-reports.division';

// 동적 binding — M_yyyymm 단일 축
export const dynKindOf = (binding: string): 'M' | null => (/^M_\d{6}$/.test(binding) ? 'M' : null);

export interface EtcReportCellState {
  editable: boolean;
  isPast: boolean; // 회색 축 — Plan=기준월 이전 / Result=기준월 이후 (L580~596)
}

const LOCKED: EtcReportCellState = { editable: false, isPast: false };

// ⭐ 그룹 게이트 G0 — DM Planner && Division≠82 → 편집 전면 차단 (L341~345 MSG00096. 블랙리스트 1그룹)
export const isEditBlockedGroup = (userGroup: string, divisionId: string): boolean =>
  userGroup === 'DM Planner' && !isDiv82(divisionId);

// 기준월 — BP=201801 고정(6자리 단일 상수 — FindData 8자리 결함② 교정) / SP_W=조회 시점 당월
export const baseYmOf = (mdfType: string, thisMonth: string): string =>
  mdfType === REPORT_TYPE.BP_M ? BP_BASE_YM : thisMonth;

// ⭐ 동적 셀(M_) 편집/회색 판정 — 제약매트릭스 §2~§4 매트릭스 1:1
export const evalEtcReportCell = (params: {
  binding: string;
  row: EtcSalesReportRow | undefined;
  divisionId: string;
  planResult: string; // 'Plan' | 'Result'
  mdfType: string; // REPORT_SP_W | REPORT_BP_M
  yyyy: string; // 조회 연도
  thisMonth: string; // 조회 시점 고정 yyyymm
  sEditMeasure: string; // DM_LOOKUP_DIV(div,'DM_SR_ETC_CURRENCY') 첫 CODE — 없으면 ''
  userGroup: string;
}): EtcReportCellState => {
  const { binding, row, divisionId, planResult, mdfType, yyyy, thisMonth, sEditMeasure, userGroup } =
    params;
  if (dynKindOf(binding) !== 'M') return LOCKED;
  const ym = binding.slice(2);
  const baseYm = baseYmOf(mdfType, thisMonth);
  const isPlan = planResult === PLAN_RESULT.PLAN;
  // 회색 축 — Plan=과거(기준월 미만) / Result=미래(기준월 이상) (L580~596. BP 도 동일 상수 — 결함② 교정)
  const isPast = isPlan ? ym < baseYm : ym >= baseYm;

  // G0 — DM Planner && ≠82 전면 잠금 (L341~345)
  if (isEditBlockedGroup(userGroup, divisionId)) return { editable: false, isPast };
  if (!row) return { editable: false, isPast };

  const d40 = isDiv40(divisionId);
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  // 시점 창 내 편집 조건 — 40 무관 개방 / 비40 = MEASURE===sEditMeasure (L427~438/L448~459 §3)
  const measureOpen = d40 || (sEditMeasure !== '' && measure === sEditMeasure);

  if (isPlan) {
    // P1 — Plan && 과거년도 → 전 구간 잠금 (L421~424 [C20201223-000448]. BP 포함 — fallthrough 파리티)
    if (Number(yyyy) < Number(thisMonth.slice(0, 4))) return { editable: false, isPast };
    // P2 — 과거 구간 잠금 / P3 — 기준월 이후 = measureOpen (L417~420/L427~438)
    if (ym < baseYm) return { editable: false, isPast };
    return { editable: measureOpen, isPast };
  }
  // Result — R3: BP 는 전체 잠금 (AS-IS 실질 undefined 지대 — 보수 확정 D-6)
  if (mdfType === REPORT_TYPE.BP_M) return { editable: false, isPast };
  // R1 — 미래(기준월 이상) 잠금 / R2 — 과거 = measureOpen (L442~445/L448~459)
  if (ym >= baseYm) return { editable: false, isPast };
  return { editable: measureOpen, isPast };
};

// ============================================================================
// InsertRow 신규행 정적 컬럼 잠금 (L965~1024 division 분기 전수 — true=편집 가능)
//   결함①(L997 ETC_DESCR 해제 가드가 CURRENCY 인덱스 검사) = 컬럼 자기판정으로 자연 교정
//   (DMF0049 SHEET_COLUMNS 42행에 ETC_DESCR 부재 — 실효 차이 0).
// ============================================================================
const COMMON_LOCKED = new Set([
  'T_DEPARTMENT_NAME',
  'T_DEPT_NAME',
  'CUTOFF_YYYYMMDD',
  'NICK_NAME',
  'BIZ_TYPE_NAME',
  'DMS_CUSTOMER',
  'MEASURE', // 세트 삽입 시 강제 세팅 — 사용자 선택 불가
]);

export const insertStaticEditable = (binding: string, divisionId: string): boolean => {
  if (COMMON_LOCKED.has(binding)) return false;
  if (isDiv81(divisionId)) {
    if (binding === 'FCST_TYPE' || binding === 'CELL_MODEL_INFO') return false; // L983~1003
    return true;
  }
  if (isDiv82(divisionId)) {
    if (binding === 'ITEM_ID' || binding === 'CELL_MODEL_INFO') return false; // L1004~1024
    return true;
  }
  // 40 — SCM_SITE_ID 잠금 (L978 공통 세트) 외 개방
  if (binding === 'SCM_SITE_ID') return false;
  return true;
};

// 기존행 정적 컬럼 — 전량 잠금 (AS-IS L399~412 전 행 키영역 잠금 — 예외 없음)
export const existingStaticEditable = (): boolean => false;
