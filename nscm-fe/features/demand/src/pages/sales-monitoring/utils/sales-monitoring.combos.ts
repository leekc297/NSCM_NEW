import type { ComboParam } from '@foundation/models';

// Biz Type 콤보 원천 스왑 — AS-IS DMF0048_SalesMonitoring InitControls L338 `sDivision=="40"` 분기 1:1.
//   40    = 'BizType'           — 전역 lookup(SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='BIZ_TYPE').
//                                 SQL 에 @divisionId 가 없어 파라미터를 넘겨도 무시된다.
//   그 외 = 'BizTypeByDivision' — SCM0001_GET_BIZ_TYPE_BY_DIVISION(@divisionId 바인드).
//                                 동일 선례: DMF0042 BusinessPlanForm / DMF0003 SalesPlanForm.
// 주의: 40 분기에서 divisionId 를 함께 넘기면 안 된다. react-query 키가 division 마다 갈라져
//   같은 전역 목록을 division 수만큼 중복 호출한다.
export const BIZ_TYPE_COMBO_ID = {
  D40: 'BizType',
  BY_DIVISION: 'BizTypeByDivision',
} as const;

export const isDiv40 = (divisionId?: string): boolean => (divisionId ?? '').trim() === '40';

// 콤보 파라미터 quoting — BE makeComboQuery 가 SQL 의 @key 를 raw 치환하므로 홑따옴표 필수.
//   apiClient.getCombo 의 quoteComboParams 가 idempotent 하게 재보정하지만, 화면 표준(q())을 따른다.
const q = (v?: string): string => `'${v && v.trim() !== '' ? v.trim() : 'ALL'}'`;

export const bizTypeComboFilterOf = (divisionId?: string): ComboParam =>
  isDiv40(divisionId)
    ? { comboId: BIZ_TYPE_COMBO_ID.D40 }
    : { comboId: BIZ_TYPE_COMBO_ID.BY_DIVISION, divisionId: q(divisionId) };

// Plant Site 콤보 원천 — 2026-08-22 콤보 통일로 카탈로그 기본값 'PlantSitebyEndCustomer' 로 환원.
//   종전 'FromSiteByDivision' 오버라이드는 폐지했다 (이슈 2026-08-20: 81/81_JV/82 에서 목록이
//   ALL 만 노출 → 당시엔 AS-IS 기준 콤보로 교체). 그 증상은 서버측 @divisionId/@endCustomer
//   필터가 결과를 다 잘라내서 생긴 것으로, 콤보 SQL 이 파라미터 없이 전량을 내려주도록 개정되면서
//   해소된다. 화면은 comboId 를 넘기지 않고 PlantSiteField 기본 경로를 쓴다.
//   주의: business-plan 그리드 PLANT_SITE_ID dataMap 은 여전히 'FromSiteByDivision' 을 쓴다
//   (BusinessPlanGrid comboColumns) — 그리드 셀 콤보는 이번 통일 대상이 아니다.

// Plant Site 활성 기준 — 40 만 비활성. 81/81_UC/81_JV/82 는 모두 활성.
//   카탈로그 PlantSiteField 기본 게이트(81 계열 전용)는 이 화면 AS-IS 와 다르므로 호출 측에서 덮어쓴다.
export const isPlantSiteDisabled = (divisionId?: string): boolean => isDiv40(divisionId);
