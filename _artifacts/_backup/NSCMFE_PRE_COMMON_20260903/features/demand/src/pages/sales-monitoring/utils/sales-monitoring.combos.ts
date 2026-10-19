// Biz Type 은 FilterBizType(#3) 하나로 통일했다 - 종전 division 별 원천 스왑
//   ('BizType' 전역 lookup / 'BizTypeByDivision')은 폐지. 그 필터 콤보가 두 갈래를 UNION 으로
//   합쳐 DIVISION_ID 와 함께 내려주므로 화면에서 한 축으로 좁히면 된다.

export const isDiv40 = (divisionId?: string): boolean => (divisionId ?? '').trim() === '40';

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
