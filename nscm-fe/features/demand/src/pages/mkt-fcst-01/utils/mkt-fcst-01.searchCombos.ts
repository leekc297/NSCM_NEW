import type { ComboParam, ComboResponse } from '@foundation/models';

import { BUCKET_TYPE, DIVISION } from '../mkt-fcst-01.constants';
import type { SearchCondition } from '../mkt-fcst-01.types';

/**
 * 조회조건 콤보 원천 (Doc/Combo/DMF0003_콤보구성.md §1).
 *
 * Division / Team / End Customer / Biz Type / Plant Site / Sender Code 는 필터다. 파라미터 없이
 * 전량을 한 번 받고 좁히는 일은 화면이 한다 - 규칙은
 * features/master/src/components/searchFields/bigFilterCombo 참조.
 *
 *   콤보                          방식     목록 구성 조건   AS-IS
 *   FilterMyDivision              필터     없음             InitControls
 *   FilterTeambyDivision          필터     Division         :3031
 *   FilterEndCustomerByDivision   필터     Division + Team  :3061 / :3092 / :3173·:3187
 *   FilterBizType                 필터     Division         :3076 / :3115
 *   FilterPlantSiteByEndCustomer  필터     Division 만      :527 / :3124  (81 계열)
 *   FilterEdiSender               필터     없음             :500 / :3035  (81 전용)
 *   SiteByEndCustomer             재조회   Div + 고객       :3109 / :3208
 *   DmSiteByEndCustomer40         재조회   Team + 고객      :3212  (AS-IS CODE=SiteByEndCustomer40)
 *
 * Item Type 과 Bucket 만 그 밖의 재조회이며 현행 콤보 ID 를 그대로 쓴다.
 *
 * ====================================================================================
 * Sales Site 를 재조회로 통일한 이유 (2026-08-29 사용자 확정)
 * ====================================================================================
 * AS-IS 는 조작 경로 x 사업부 조합마다 다섯 갈래로 갈린다 - 진입/Team 변경은 필터
 * (BIGFILTER_SiteByEndCustomer), Division 변경 40 은 축 없는 BIGFILTER_ScmSitebyEndCustomer40,
 * Division·고객 변경 81·82 와 고객 변경 40 은 재조회다.
 *
 * 그 필터 원천을 TO-BE 사내 데이터로는 쓸 수 없다. BIGFILTER_SiteByEndCustomer 의 40 분기는
 * DEPT_ID 를 LEFT JOIN 두 단계로 만들고(SITE -> SITE_ITEM -> OWNER->DEPT), 비40 분기는
 * DEPT_ID 가 아예 NULL 이다. 엄격 매칭이라 Team 을 고르는 순간 목록이 통째로 빈다.
 * (같은 형태로 Plant Site 의 END_CUSTOMER 도 NULL 이 대부분이라 축을 뗐다 - MktFcst01Form 참조.)
 *
 * 재조회는 서버가 이미 좁혀 CODE / NAME 만 내려주므로 그 문제가 없다. AS-IS 도 다섯 갈래 중
 * 셋이 이미 재조회이고, 남은 둘(진입 / Team 변경)만 필터였다. 그 둘을 재조회로 맞추면 한 칸이
 * 한 규칙으로 동작한다 - 경로에 따라 목록과 표시 문구가 달라지던 AS-IS 결함(문서 §4-2)도 없어진다.
 *
 * 잃는 것: 40 진입 목록의 표시 문구. BIGFILTER_ScmSitebyEndCustomer40 은 NAME 이
 * SITE_DESCRIPTION 인데 재조회는 사이트 코드를 쓴다. AS-IS 도 경로마다 달랐던 부분이다.
 *
 * 옮기지 않은 것: 재조회 경로는 권한그룹을 PARAM5 로 함께 넘긴다
 * ('DM Planner (W/S)' 면 'Y')(:7036 · :7061, 문서 §4-4). 등록 SQL 의 토큰명을 알 수 없어
 * 싣지 않았다 - 이름이 틀리면 BE makeComboQuery 가 조용히 버린다.
 */
export const SEARCH_COMBO = {
  division: 'FilterMyDivision',
  team: 'FilterTeambyDivision',
  endCustomer: 'FilterEndCustomerByDivision',
  bizType: 'FilterBizType',
  plantSite: 'FilterPlantSiteByEndCustomer',
  senderCode: 'FilterEdiSender',
  // Sales Site - 재조회 2종. 사업부로만 갈린다.
  salesSite: 'SiteByEndCustomer_DM',
  salesSite40: 'SiteByEndCustomer40_DM',
} as const;

/**
 * 이 화면에서 조회할 수 있는 사업부 - 82(ESS)만 조회한다(2026-11-17 요청).
 *
 * FilterMyDivision 은 여러 화면이 함께 쓰는 공용 콤보라 SQL 은 그대로 두고 여기서 거른다.
 * 사용자 권한으로 40·81 이 있어도 이 화면 목록에는 나오지 않고, 다른 화면은 영향이 없다.
 * 권한 데이터(그룹별 사업부·메뉴 권한)로 맞추지 않은 이유: 이 메뉴 권한이 있는 그룹 대부분이
 * 전 사업부를 갖고 있고 다른 화면과 공유한다(2026-11-17 DB 실측).
 */
export const SEARCHABLE_DIVISIONS: readonly string[] = [DIVISION.ESS];

/** Division 콤보 응답에서 이 화면이 조회할 수 있는 사업부만 남긴다. */
export const filterSearchableDivisions = (rows: ComboResponse[] | undefined): ComboResponse[] =>
  (rows ?? []).filter(row => SEARCHABLE_DIVISIONS.includes(String(row.CODE ?? '').trim()));

/**
 * Division 을 바꿀 때 함께 되돌리는 조회조건 - 종속 조회조건 전면 reset
 * (AS-IS cboDivision_SelectedIndexChanged :3019~). 콤보 onChange 와 복원값 교정(MktFcst01.tsx)이 같이 쓴다.
 */
export const buildDivisionChangePatch = (division: string): Partial<SearchCondition> => ({
  divisionId: division,
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  bizTypes: [],
  plantSiteIds: [],
  senderCodes: [],
  projectCodes: [],
  itemIds: [],
  nickName: '',
  owners: [],
  itemTypes: [],
  // Cell Qty 는 Div 40 전용 (AS-IS L2107/2140: 비40 = Enabled=false + Checked=false).
  ...(division !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
  // Invalid(MKT FCST 미등록 제외)는 Div82 전용 - 82 진입 시 기본 checked (AS-IS L469~477).
  invalidYn: division === DIVISION.ESS,
  // G4 - Bucket 기본값: 82(ESS)=Daily / 그 외=Weekly (v1.7 3장, AS-IS OnShown).
  bucketType: BUCKET_TYPE.WEEKLY,
  // Sum / Qty >= 0 은 division 변경 시 초기화하지 않는다
  // (AS-IS cboDivision_SelectedIndexChanged :3019~3164 도 chkSum/chkQty 를 건드리지 않는다).
  asYn: false,
});

/** 81 계열·82 판정 - AS-IS :3170 · :3188 Substring(0,2)=="81" || =="82" 와 같다. */
const is81or82 = (divisionId: string): boolean => {
  const d = (divisionId ?? '').trim();
  return d.startsWith('81') || d === '82';
};

/** 전체선택('ALL')과 전체해제는 조건 없음과 같다 - 둘 다 공란으로 접는다. */
const join = (values: readonly string[]): string =>
  values
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL')
    .join(',');

export interface SalesSiteComboInput {
  divisionId: string;
  deptIds: readonly string[];
  endCustomers: readonly string[];
}

/**
 * Sales Site 콤보 파라미터. 사업부로 두 갈래다.
 *
 *   81 계열·82  SiteByEndCustomer     Division + End Customer   AS-IS GetSalesSite   :7022
 *   40 등       DmSiteByEndCustomer40 Team + End Customer       AS-IS GetSalesSite40 :7047
 *
 * 목록 구성 조건이 전부 파라미터로 실리므로 그중 하나라도 바뀌면 react-query 키가 달라져
 * SQL 이 다시 나간다 (refetch 를 직접 부르지 않는다).
 *
 * 40 갈래에도 divisionId 를 싣는다 - AS-IS GetSalesSite40 은 PARAM1 이 팀이라 사업부를 안
 * 넘기지만, 등록 SQL 이 @divisionId 를 조건으로 써서 빠지면 BE makeComboQuery 가 공란으로
 * 치환해 목록이 조회조건과 무관하게 고정된다(DMF0082 에서 실측). 그 경로는 40 전용이라
 * 결과는 AS-IS 와 같다.
 */
export const buildSalesSiteComboParam = ({
  divisionId,
  deptIds,
  endCustomers,
}: SalesSiteComboInput): ComboParam => {
  const endCustomer = join(endCustomers);
  if (is81or82(divisionId)) {
    return { comboId: SEARCH_COMBO.salesSite, divisionId, endCustomer };
  }
  return {
    comboId: SEARCH_COMBO.salesSite40,
    divisionId,
    deptId: join(deptIds),
    endCustomer,
  };
};
