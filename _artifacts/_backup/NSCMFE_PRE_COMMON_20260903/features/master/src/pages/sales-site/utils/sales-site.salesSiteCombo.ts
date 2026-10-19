import type { ComboParam, ComboResponse } from '@foundation/models';

import { hasEndCustomer } from '../sales-site.constants';

/**
 * 조회조건 Sales Site 콤보 원천 3종.
 *
 * AS-IS(DMF0004_SalesSite.cs)는 조건에 따라 목록 원천을 통째로 갈아끼운다. 화면에 보이는
 * 칸은 하나지만 그 뒤의 SQL 은 셋이다.
 *
 *   division 이 81 접두 또는 82  -> UserSiteByEndCustomer  (division + End Customer)
 *   그 외 division (40 등)        -> ScmSitebyEndCustomer40 (division)
 *   Sold-To Customer 변경         -> SiteByEndCustomerSold  (division + Sold-To)
 *
 * 앞의 둘은 InitControls / cboDivision_SelectedIndexChanged 의 같은 블록에서, 셋째는
 * clbSoldToCustomer_SelectedIndexChanged 에서 호출한다. 셋째에는 division 분기가 없다 -
 * 40 이든 82 든 Sold-To 를 고르면 무조건 이 원천으로 바뀐다.
 *
 * 주의: 원소스에 남은 기준은 SetChangeControl(BigFilter 메모리 캐시)이 아니라 그 위에 주석으로
 * 처리된 Data.* 호출이다. 속도개선 과정에서 BigFilter 로 갈아끼우며 ScmSitebyEndCustomer40 의
 * division 인자가 빠졌지만, 원소스는 Data.ScmSitebyEndCustomer40(group, user, sDivision, "")
 * 로 division 을 받는다. TO-BE 는 서버 콤보로 되돌아가므로 원소스 인자를 따른다.
 *
 * group / user 두 자리는 BE 가 @sesUserId 로 주입하므로(LookupServiceImpl.retrieveCombo)
 * FE 는 싣지 않는다. 값 인용(홑따옴표)도 apiClient.getCombo 의 quoteComboParams 가 일괄 처리하니
 * 여기서 붙이지 않는다.
 */
export const SALES_SITE_COMBO = {
  /** 필터. 81 접두 / 82 - division + End Customer 로 좁힌다. */
  byEndCustomer: 'FilterSiteByEndCustomer',
  /** 필터. 그 외 division - End Customer 칸이 잠겨 division 만 걸린다. */
  byDivision: 'FilterScmSitebyEndCustomer40',
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

/** 미선택('ALL' / 공란)이면 빈 배열 = 그 단계 미적용. 다중 선택은 콤마로 나눈다. */
const toFilterList = (value?: string) =>
  (value ?? '')
    .split(',')
    .map(v => v.trim())
    .filter(v => v !== '' && v !== 'ALL');

// 콤보 통일화 과도기라 컬럼명이 두 벌이다. 둘 다 견딘다.
const readRowDivision = (row: ComboResponse) =>
  String(row.DIVISION_ID ?? row.DIVISION_CODE ?? '').trim();
const readRowEndCustomer = (row: ComboResponse) =>
  String(row.END_CUSTOMER ?? row.END_CUSTOMER_CODE ?? '').trim();

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
  // endCustomer 는 필터 경로에서 안 쓴다 - 파라미터가 없고, 좁히는 일은 buildSalesSiteOptions 가 한다.
  // Filter 접두는 필터 방식이다 - 파라미터를 싣지 않고 전량을 받는다. 조회조건으로 좁히는
  //   일은 buildSalesSiteOptions 가 한다. 파라미터가 없으니 쿼리 키도 고정이라 division 이나
  //   End Customer 를 바꿔도 서버를 다시 치지 않는다(AS-IS BigFilter 와 같은 동작).
  return {
    comboId: hasEndCustomer(divisionId)
      ? SALES_SITE_COMBO.byEndCustomer
      : SALES_SITE_COMBO.byDivision,
  };
};

/**
 * 콤보 응답을 드롭다운 옵션으로. 필터 경로에서는 여기서 조회조건으로 좁힌다.
 *
 * 트리거별로 좁히는 정도가 다르다. 재조회 경로(soldTo)는 서버가 이미 걸러 내려주므로 다시 거르지
 * 않는다 - 그 응답에는 END_CUSTOMER 컬럼이 없을 수 있어 한 번 더 걸면 목록이 통째로 빈다.
 *
 * division 은 관대 매칭이다(빈 행 통과). 콤보가 그 컬럼을 안 내려주는 경우가 있어 엄격하게
 * 자르면 전 행이 날아간다. End Customer 는 값이 있을 때만 엄격하게 건다 - 관대하게 두면
 * 고른 고객이 목록을 못 좁혀 필터가 무력해진다. AS-IS BigFilter 의 Count == 0 분기와 같다.
 */
export const buildSalesSiteOptions = (
  rows: ComboResponse[] | undefined,
  trigger: SalesSiteTrigger,
  { divisionId, endCustomer }: Pick<SalesSiteComboSource, 'divisionId' | 'endCustomer'>
) => {
  const division = String(divisionId ?? '').trim();
  const customers = trigger === 'soldTo' ? [] : toFilterList(endCustomer);
  return [
    ...new Map(
      (rows ?? [])
        .filter(row => {
          const rowDivision = readRowDivision(row);
          if (rowDivision !== '' && division !== '' && rowDivision !== division) return false;
          return customers.length === 0 || customers.includes(readRowEndCustomer(row));
        })
        .map(row => [String(row.CODE ?? '').trim(), row] as const)
        .filter(([code]) => code !== '')
        .map(
          ([code, row]) =>
            [code, { label: String(row.NAME ?? '').trim() || code, value: code }] as const
        )
    ).values(),
  ];
};
