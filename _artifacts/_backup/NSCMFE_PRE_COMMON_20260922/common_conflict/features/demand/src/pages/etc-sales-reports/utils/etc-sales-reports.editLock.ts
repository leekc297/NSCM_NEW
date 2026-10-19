// ⭐ DMF0049 — 편집/잠금 규칙 엔진 (제약매트릭스 §2~§6 전수 — AS-IS EditButton L338~461 / InsertRow L965~1056).
//   ⚠ DMF0044와 정반대 지점: **EDIT_FLAG 는 동적 셀 규칙에서 미사용** (EditButton 루프 L396~461 에
//   값 비교 없음 — InsertRow 재잠금 L1056 의 'Y' 행 키잠금만. §2.3 이중 게이트 비대칭 실측).
//   규칙 축: G0 그룹 게이트 / baseYm(BP='201801' 6자리 단일 — 결함② 교정) / Plan·Result 시점 /
//   sEditMeasure(DM_SR_ETC_CURRENCY — 82='SalesAmt_KRW' 뿐, 81 빈값=전잠금) / division(40 완화).
import { BP_BASE_YM, PLAN_RESULT, REPORT_TYPE } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow } from '../etc-sales-reports.types';

import { isDiv40, isDiv82 } from './etc-sales-reports.division';

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
  const {
    binding,
    row,
    divisionId,
    planResult,
    mdfType,
    yyyy,
    thisMonth,
    sEditMeasure,
    userGroup,
  } = params;
  if (dynKindOf(binding) !== 'M') return LOCKED;
  const ym = binding.slice(2);
  const baseYm = baseYmOf(mdfType, thisMonth);
  // BP(REPORT_BP_M)는 Plan/Result 값과 무관하게 Plan 입력 조건을 적용한다 (2026-09-22 사용자 확정
  //   — "BP 일 때는 Result 도 Plan 입력조건과 맞춰줘"). BP 기준월(201801) 고정 아래에서 Result 축을
  //   그대로 쓰면 R1(ym>=기준월)이 전 월을 잠그므로, BP 는 Result 여도 Plan 분기(P1/P2/P3)를 타게 한다.
  const usePlanRule = planResult === PLAN_RESULT.PLAN || mdfType === REPORT_TYPE.BP_M;
  // 회색 축 — Plan=과거(기준월 미만) / Result=미래(기준월 이상) (L580~596). BP 는 Plan 축을 따른다.
  const isPast = usePlanRule ? ym < baseYm : ym >= baseYm;

  // G0 — DM Planner && ≠82 전면 잠금 (L341~345)
  if (isEditBlockedGroup(userGroup, divisionId)) return { editable: false, isPast };
  if (!row) return { editable: false, isPast };

  const d40 = isDiv40(divisionId);
  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  // 시점 창 내 편집 조건 — 40 무관 개방 / 비40 = MEASURE===sEditMeasure (L427~438/L448~459 §3)
  const measureOpen = d40 || (sEditMeasure !== '' && measure === sEditMeasure);

  if (usePlanRule) {
    // P1 — Plan && 과거년도 → 전 구간 잠금 (L421~424 [C20201223-000448]. BP 포함 — fallthrough 파리티)
    if (Number(yyyy) < Number(thisMonth.slice(0, 4))) return { editable: false, isPast };
    // P2 — 과거 구간 잠금 / P3 — 기준월 이후 = measureOpen (L417~420/L427~438)
    if (ym < baseYm) return { editable: false, isPast };
    return { editable: measureOpen, isPast };
  }
  // Result (SP_W 한정 — BP 는 위 Plan 분기에서 처리됨. 2026-09-22 사용자 확정)
  // R1 — 미래(기준월 이상) 잠금 / R2 — 과거 = measureOpen (L442~445/L448~459)
  if (ym >= baseYm) return { editable: false, isPast };
  return { editable: measureOpen, isPast };
};

// ⭐ 정적 컬럼 편집 판정 — **UI Category Setup(`INPUT_TP_CD`) 단일 원천** (2026-08-11 전환.
//   DMF0044 동일 전환 선례 — `sales-reports.editLock.ts` staticEditableByMeta).
//   [이전] AS-IS `.cs` InsertRow(L965~1024) 의 division 분기 잠금 목록을 **하드코딩**하고
//          기존행은 전량 잠금(L399~412)으로 판정했다 → 운영자가 admin 화면에서 정한
//          `INPUT_TP_CD` 가 화면에 **무효화**됐다(실측: DMF0049 42컬럼 전부 'S'(Only Search)).
//   [현재] 컬럼 메타의 `inputTpCd` 를 그대로 따른다. AS-IS 파리티는 **메타 값**으로 보존한다
//          (InsertRow 가 잠그던 컬럼 = 'S', 신규행 입력 컬럼 = 'IM'/'IO' 로 등재).
//   규약은 공용 `GridUtils.isEditableCell`(foundation/utils/gridUtils.ts)과 **동일**하다 —
//   화면 게이트와 공용 게이트가 같은 메타·같은 규칙을 보므로 판정이 갈릴 수 없다.
//     IM / IO → EDIT_FLAG!=='N' && CRUD_TYPE==='I'   (insert 시 입력. IM=필수·IO=선택)
//     M  / O  → EDIT_FLAG!=='N'                       (전 행 입력)
//     S / 미지정 → 편집 불가
export const staticEditableByMeta = (
  inputTpCd: string | undefined,
  row: EtcSalesReportRow | undefined
): boolean => {
  if (!row) return false;
  const editFlag = typeof row.EDIT_FLAG === 'string' ? row.EDIT_FLAG : '';
  if (editFlag === 'N') return false;
  switch (inputTpCd) {
    case 'M':
    case 'O':
      return true;
    case 'IM':
    case 'IO':
      return row.CRUD_TYPE === 'I';
    default: // 'S' 및 미지정
      return false;
  }
};
