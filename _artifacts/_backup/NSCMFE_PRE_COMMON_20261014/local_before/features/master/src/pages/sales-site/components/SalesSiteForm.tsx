import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

import { SHEET_INDEX, hasEndCustomer } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';
import {
  buildSalesSiteComboParam,
  buildSalesSiteOptions,
} from '../utils/sales-site.salesSiteCombo';
import {
  END_CUSTOMER_COLUMNS,
  SOLD_CUSTOMER_COLUMNS,
  toDivisionComboOptions,
} from '../utils/sales-site.util';

interface SalesSiteFormProps {
  setActiveTab: (tab: SHEET_INDEX) => void;
  openDetailGrid: boolean;
  setOpenDetailGrid: (open: boolean) => void;
}

export const SalesSiteForm = ({
  setActiveTab,
  openDetailGrid,
  setOpenDetailGrid,
}: SalesSiteFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useSalesSiteStore(state => state.openSearchArea);
  const searchParams = useSalesSiteStore(state => state.searchParams);
  const salesSiteTrigger = useSalesSiteStore(state => state.salesSiteTrigger);
  const setSearchParams = useSalesSiteStore(state => state.setSearchParams);
  const fetchStaticColumns = useSalesSiteStore(state => state.fetchStaticColumns);
  const setSiteFilters = useSalesSiteStore(state => state.setSiteFilters);

  /**
   * 목록 정렬은 CustomDropdown 의 sortBy='label' 로 건다 - 표시명(NAME) 기준 숫자-영문-한글
   * 순이다(sortOptionsBy 참조). Div 와 Active 는 항목이 몇 개뿐이라 서버 순서를 그대로 둔다.
   *
   * 조회조건 콤보는 항목마다 따로 받아 화면에서 division 으로 거른다. 조인 콤보 하나로 묶는
   * cascade 는 이 화면에 쓰지 않는다 — Sales Site 목록의 원천이 조건마다 통째로 바뀌어
   * (utils/sales-site.salesSiteCombo 참조) 다른 항목과 한 줄기로 엮이지 않기 때문이다.
   */
  const [divisions, endCustomers, yesOrNo] = useTabComboQueries({
    filters: ['FilterMyDivision', 'FilterEndCustomerByDivision', 'YesOrNo'],
  });

  // Sold-To Customer 는 division 을 실어 보낸다. 파라미터가 react-query 키에 들어가므로
  //   division 이 바뀌면 새 키가 되어 다시 조회된다. 파라미터 이름과 미선택 'ALL' 규약은
  //   카탈로그 SoldToCustomerField 와 같다.
  const [soldToCustomers] = useTabComboQueries({
    filters: [
      { comboId: 'dmf0004GetSoldtoCustomerData', divisionId: searchParams.divisionId || 'ALL' },
    ],
  });

  /**
   * Sales Site 만 원천이 셋이다. 트리거와 현재 조회조건으로 이번에 부를 콤보 1건을 조립하고,
   * 화면은 어느 원천인지 몰라도 된다.
   *
   * 콤보 파라미터 객체는 react-query 키에 그대로 들어가고 키는 구조 해시라, 매 렌더 새 객체여도
   * 같은 키다. 원천이나 값이 바뀐 순간에만 다른 키가 되어 그 1건만 조회된다 — 나머지 두 원천은
   * 호출되지 않는다. AS-IS 의 "필터 경로 vs 재조회 경로" 구분이 여기서 유지된다.
   */
  const [salesSites] = useTabComboQueries({
    filters: [buildSalesSiteComboParam(salesSiteTrigger, searchParams)],
  });

  // AS-IS 는 같은 if 블록에서 End Customer 칸 활성과 Sales Site 콤보 원천을 함께 정한다.
  //   술어가 하나이므로 화면에서도 하나만 쓴다.
  const isEndCustomerDisabled = !hasEndCustomer(searchParams.divisionId);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={() => {
        setSiteFilters();
        void fetchStaticColumns();
      }}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams(
                      {
                        divisionId: option,
                        endCustomer: 'ALL',
                        soldToCustomer: 'ALL',
                        salesSite: 'ALL',
                        activeFlag: 'ALL',
                      },
                      'division'
                    );
                    setOpenDetailGrid(true);
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={isEndCustomerDisabled}
                  value={searchParams.endCustomer}
                  options={toDivisionComboOptions(
                    endCustomers,
                    searchParams.divisionId,
                    END_CUSTOMER_COLUMNS
                  )}
                  onChange={(_, options) => {
                    // salesSite 를 함께 푸는 이유: End Customer 가 바뀌면 Sales Site 목록이
                    //   다시 만들어진다. AS-IS 도 목록을 다시 그릴 때마다
                    //   setListBox(..., true) 로 선택을 푼다.
                    setSearchParams(
                      { endCustomer: options, salesSite: 'ALL', activeFlag: 'ALL' },
                      'endCustomer'
                    );
                    setOpenDetailGrid(true);
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00081', '_Sold-To Customer')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={searchParams.soldToCustomer}
                  options={toDivisionComboOptions(
                    soldToCustomers,
                    searchParams.divisionId,
                    SOLD_CUSTOMER_COLUMNS
                  )}
                  onChange={(_, options) => {
                    setSearchParams(
                      { soldToCustomer: options, salesSite: 'ALL', activeFlag: 'ALL' },
                      'soldTo'
                    );
                    setOpenDetailGrid(true);
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={searchParams.salesSite}
                  options={buildSalesSiteOptions(salesSites)}
                  onChange={(_, options) => {
                    // 'ALL' 을 빈 값으로 바꾸지 않는다 — CustomDropdown 이 전체선택을 'ALL'
                    //   sentinel 로 내보내고 그 값이 그대로 돌아와야 전체 체크가 유지된다.
                    setSearchParams({ salesSite: options });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  limitTags={1}
                  value={searchParams.activeFlag}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      activeFlag: options || 'ALL',
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3} className={commonStyles.customGrid}>
            <FormItem
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox
                    checked={openDetailGrid}
                    onChange={checked => {
                      setOpenDetailGrid(checked);
                      if (!checked) setActiveTab(SHEET_INDEX.SITE);
                    }}
                  />
                  <Label labelText={t('LBL00316', '_Detail')} depth='sub' />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
