import type { ComboParam, ComboResponse } from '@foundation/models';

import { hasEndCustomer } from '../sales-site.constants';

/**
 * 조회조건 Sales Site 콤보 원천 3종. 셋 다 재조회다.
 *
 * AS-IS(DMF0004_SalesSite.cs)는 조건에 따라 목록 원천을 통째로 갈아끼운다. 화면에 보이는
 * 칸은 하나지만 그 뒤의 SQL 은 셋이다.
 *
 *   division 이 81 접두 또는 82  -> UserSiteByEndCustomer  (division + End Customer, Active Y + AS 사이트)
 *   그 외 division (40 등)        -> ScmSitebyEndCustomer40 (division)
 *   Sold-To Customer 변경         -> SiteByEndCustomerSold  (division + Sold-To)
 *
 * 앞의 둘은 InitControls / cboDivision_SelectedIndexChanged 의 같은 블록에서, 셋째는
 * clbSoldToCustomer_SelectedIndexChanged 에서 호출한다. 셋째에는 division 분기가 없다 -
 * 40 이든 82 든 Sold-To 를 고르면 무조건 이 원천으로 바뀐다.
 *
 * ====================================================================================
 * 앞의 둘을 필터에서 재조회로 되돌린 이유 (2026-08-31 사용자 확정 - DMF0003·DMF0082 와 같은 결정)
 * ====================================================================================
 * BIGFILTER_SiteByEndCustomer 의 40 분기는 DEPT_ID 를 LEFT JOIN 두 단계로 만들고
 * (SITE -> SITE_ITEM -> OWNER->DEPT), 비40 분기는 DEPT_ID 가 아예 NULL 이다. END_CUSTOMER 도
 * NULL 이 섞인다. 클라이언트 축은 엄격 매칭이라 조회조건을 고르는 순간 목록이 통째로 빈다.
 * 재조회는 서버가 이미 좁혀 CODE / NAME 만 내려주므로 그 문제가 없다.
 *
 * 잃는 것: 40 목록의 표시 문구. ScmSitebyEndCustomer40 은 NAME 이 SITE_DESCRIPTION 인데
 * 재조회는 사이트 코드를 쓴다.
 *
 * group / user 두 자리는 BE 가 @sesUserId 로 주입하므로(LookupServiceImpl.retrieveCombo)
 * FE 는 싣지 않는다. 값 인용(홑따옴표)도 apiClient.getCombo 의 quoteComboParams 가 일괄 처리하니
 * 여기서 붙이지 않는다.
 */
export const SALES_SITE_COMBO = {
  /** 재조회. 81 접두 / 82 - division + End Customer. */
  byEndCustomer: 'SiteByEndCustomer_DM',
  /** 재조회. 그 외 division(40 등) - division + Team + End Customer. 이 화면엔 Team 칸이 없다. */
  byDivision: 'SiteByEndCustomer40_DM',
  /** 재조회. Sold-To 변경 시에만 나간다. */
  bySoldTo: 'SiteByEndCustomerSold',
} as const;

/**
 * 저장 성공 직후 다시 받아야 할 콤보. Sales Site 원천 3종 전부를 넣는다 - 지금 활성인 원천만
 * 비우면 트리거가 바뀌는 순간 저장 전 목록이 캐시에서 그대로 살아난다.
 *
 * 조인 콤보 'SalesSite' 는 이 화면이 더 이상 쓰지 않지만 함께 넣는다. DMF0004 가 그 콤보의
 * 원천 마스터라, 같이 열려 있는 다른 화면(MDI keep-alive)의 Sales Site 목록도 같이 상한다.
 */
export const SALES_SITE_STALE_COMBO_IDS = [
  ...Object.values(SALES_SITE_COMBO),
  'SalesSite',
] as const;

/**
 * 마지막으로 바뀐 조회조건. AS-IS 는 이벤트 기반이라 나중에 발생한 핸들러가 목록을 덮어쓴다.
 * React 는 상태 기반이므로 그 "마지막"을 상태로 들고 같은 규칙을 재현한다.
 *
 * division 과 endCustomer 는 같은 원천으로 가지만 값을 나눠 둔다 - End Customer 변경이
 * Sold-To 우선을 해제한다는 사실이 코드에 드러나야 한다.
 */
export type SalesSiteTrigger = 'division' | 'endCustomer' | 'soldTo';

interface SalesSiteComboSource {
  divisionId: string;
  endCustomer: string;
  soldToCustomer: string;
}

/**
 * 미선택은 공란으로 넘긴다. AS-IS GetDMInnerTable 진입부가 'ALL' 을 '' 로 바꾸고, 값이 비면
 * 그 단계를 아예 건너뛴다. 공란 규약은 콤보 파라미터에 한한다 - 스토어 조회조건 필드는
 * 종전대로 'ALL' 을 담아야 드롭다운 전체 체크가 유지되고 proc 요청 규약도 맞는다.
 */
const blank = (value?: string) => (!value || value === 'ALL' ? '' : value);

/** 트리거와 현재 조회조건으로 이번에 부를 콤보 1건을 정한다. */
export const buildSalesSiteComboParam = (
  trigger: SalesSiteTrigger,
  { divisionId, endCustomer, soldToCustomer }: SalesSiteComboSource
): ComboParam => {
  if (trigger === 'soldTo') {
    // 자리마다 다른 조회조건이 들어간다.
    //   PARAM1 division / PARAM2 End Customer / PARAM5 Sold-To Customer.
    //   SQL 은 division 40 분기에서 PARAM5 로 SOLDTO_CUSTOMER 를, 그 외 분기에서 PARAM2 로
    //   END_CUSTOMER 를 건다.
    //   PARAM3 / PARAM4 (GroupID / UserID)는 BE 가 @sesUserId 로 주입하므로 FE 는 싣지 않는다.
    //
    //   주의: AS-IS 호출부(clbSoldToCustomer_SelectedIndexChanged)는 End Customer 인자를 주석
    //   처리하고 그 자리에 Sold-To 를 넘긴다. 같은 폴더의 DM0004_SalesSiteTest99 는 End Customer
    //   를 넘긴다. 정본은 후자로 확정했다(2026-08-27).
    return {
      comboId: SALES_SITE_COMBO.bySoldTo,
      divisionId: divisionId,
      endCustomer: blank(endCustomer),
      soldCustomer: blank(soldToCustomer),
    };
  }
  // 재조회다 - 목록 구성 조건을 전부 파라미터로 실으므로 그중 하나라도 바뀌면 react-query 키가
  //   달라져 SQL 이 다시 나간다(refetch 를 직접 부르지 않는다).
  if (hasEndCustomer(divisionId)) {
    // 필수: validYn / asYn 을 함께 싣는다. 공용 SQL(SiteByEndCustomer_DM)은 두 값이 비면
    //   Active 조건을 끄고(사용 중지 사이트 포함) 운영 그룹 W(AS 사이트) 분기를 아예 타지 않는다.
    //   AS-IS UserSiteByEndCustomer 는 사용 중(Active Y) 사이트 전체 + AS 사이트였다
    //   (실측 2026-10-06: 미전송 81 526 / 82 966 -> 전송 81 447 / 82 756).
    //   SQL 본문은 DMF0003 등과 공용이라 손대지 않고 이 화면의 전달값만 바꾼다.
    return {
      comboId: SALES_SITE_COMBO.byEndCustomer,
      divisionId,
      endCustomer: blank(endCustomer),
      validYn: 'Y',
      asYn: 'Y',
    };
  }
  // 40 등. deptId 는 이 화면에 Team 칸이 없어 늘 공란이다 - 자리를 비워 두면 그 조건이 없다는
  //   뜻이고, 다른 화면(DMF0003·DMF0082)과 파라미터 모양을 맞춰 둔다.
  return {
    comboId: SALES_SITE_COMBO.byDivision,
    divisionId,
    deptId: '',
    endCustomer: blank(endCustomer),
  };
};

/**
 * 콤보 응답을 드롭다운 옵션으로.
 *
 * 필수: 조회조건으로 다시 거르지 않는다. 세 원천이 전부 재조회라 서버가 이미 좁혀
 * CODE / NAME 만 내려준다 - DIVISION_ID / END_CUSTOMER 컬럼이 아예 없을 수 있어 한 번 더 걸면
 * 엄격 매칭에서 전 행이 잘려 "값은 내려오는데 옵션이 0건" 이 된다.
 *
 * CODE 중복은 접고(첫 행이 이긴다) 코드가 빈 행은 버린다.
 */
export const buildSalesSiteOptions = (rows: ComboResponse[] | undefined) => [
  ...new Map(
    (rows ?? [])
      .map(row => [String(row.CODE ?? '').trim(), row] as const)
      .filter(([code]) => code !== '')
      .map(
        ([code, row]) =>
          [code, { label: String(row.NAME ?? '').trim() || code, value: code }] as const
      )
  ).values(),
];
