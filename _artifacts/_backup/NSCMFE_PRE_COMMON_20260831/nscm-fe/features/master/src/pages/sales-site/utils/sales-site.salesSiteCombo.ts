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
  byEndCustomer: 'UserSiteByEndCustomer',
  byDivision: 'ScmSitebyEndCustomer40',
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
    // endCustomer 자리에도 Sold-To 값이 들어간다. AS-IS 호출부가 clbEndCustomer 인자를 주석
    // 처리하고 그 자리에 Sold-To 를 넣어 둔 원문 그대로다.
    const soldTo = blank(soldToCustomer);
    return {
      comboId: SALES_SITE_COMBO.bySoldTo,
      PARAM1: divisionId,
      PARAM2: soldTo,
    };
  }
  if (hasEndCustomer(divisionId))
    // 이 화면은 deptId 를 항상 공란으로 넘긴다(SetChangeControl 의 string.Empty). Team 은
    // 컨트롤만 활성이고 이 목록을 좁히지 않는다.
    return {
      comboId: SALES_SITE_COMBO.byEndCustomer,
      divisionId,
      endCustomer: blank(endCustomer),
      deptId: '',
    };
  return { comboId: SALES_SITE_COMBO.byDivision, divisionId, endCustomer: '' };
};

/**
 * 콤보 응답을 드롭다운 옵션으로. CODE 중복은 접는다 - AS-IS 도 GroupBy 로 한 번 접는다.
 * 세 원천 모두 CODE / NAME 규약을 따르므로 원천별 분기는 없다.
 */
export const toSalesSiteOptions = (rows?: ComboResponse[]) => [
  ...new Map(
    (rows ?? [])
      .map(row => [String(row.CODE ?? ''), String(row.NAME ?? '')] as const)
      .filter(([code]) => code !== '')
      .map(([code, name]) => [code, { label: name || code, value: code }] as const)
  ).values(),
];
