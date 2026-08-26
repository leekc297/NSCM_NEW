import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

import { DivisionField, EndCustomerField, SalesSiteField } from '../../../components';
import { logSearchReset } from '../../../components/searchFields/SearchFields.debug';
import { SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 ('ALL' 또는 콤마 조인).
// SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
// 'ALL' 은 ['ALL'] 로 왕복하므로 기존 저장 형태가 그대로 유지된다.
const toList = (v: string) => v.split(',').filter(Boolean);

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
  const setSearchParams = useSalesSiteStore(state => state.setSearchParams);
  const fetchStaticColumns = useSalesSiteStore(state => state.fetchStaticColumns);
  const setSiteFilters = useSalesSiteStore(state => state.setSiteFilters);

  const [soldToCustomers, yesOrNo] = useTabComboQueries({
    filters: ['SoldCustomer', 'YesOrNo'],
  });

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
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={value => {
              // 임시 로컬 디버그 — 확인 끝나면 logSearchReset 호출과 import 삭제.
              logSearchReset({
                label: 'DMF0043 sales-site',
                changed: { field: 'divisionId', from: searchParams.divisionId, to: value },
                resets: [
                  { field: 'endCustomer', from: searchParams.endCustomer, to: 'ALL' },
                  { field: 'soldToCustomer', from: searchParams.soldToCustomer, to: 'ALL' },
                  { field: 'salesSite', from: searchParams.salesSite, to: 'ALL' },
                  { field: 'activeFlag', from: searchParams.activeFlag, to: 'ALL' },
                ],
              });
              setSearchParams({
                divisionId: value,
                endCustomer: 'ALL',
                soldToCustomer: 'ALL',
                salesSite: 'ALL',
                activeFlag: 'ALL',
              });
              setOpenDetailGrid(true);
            }}
          />
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            disabled={searchParams.divisionId === '40'}
            value={toList(searchParams.endCustomer)}
            onChange={values => {
              // 임시 로컬 디버그 — 확인 끝나면 logSearchReset 호출과 import 삭제.
              logSearchReset({
                label: 'DMF0043 sales-site',
                changed: {
                  field: 'endCustomer (= SalesSite 콤보의 PROJECT_CODE)',
                  from: searchParams.endCustomer,
                  to: values.join(','),
                },
                resets: [
                  { field: 'salesSite', from: searchParams.salesSite, to: 'ALL' },
                  { field: 'activeFlag', from: searchParams.activeFlag, to: 'ALL' },
                ],
              });
              setSearchParams({
                endCustomer: values.join(','),
                // cascade 상위 단계라 하위 Sales Site 선택은 초기화한다 —
                // 안 지우면 옵션에서 사라진 사이트가 조회조건에 그대로 남아 서버로 나간다.
                salesSite: 'ALL',
                activeFlag: 'ALL',
              });
              setOpenDetailGrid(true);
            }}
          />
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
                  value={searchParams.soldToCustomer}
                  options={
                    [
                      ...new Map(
                        soldToCustomers
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [item.CODE, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      soldToCustomer: options,
                      activeFlag: 'ALL',
                    });
                    setOpenDetailGrid(true);
                  }}
                />
              )}
            />
          </Grid>
          {/* cascade = division-team-projectCode-salesSite ('SalesSite' 콤보 반환 컬럼).
              division 은 SalesSiteField 가 항상 먼저 걸므로 여기 적지 않는다.
              이 화면은 Team 조회조건이 없어 DEPT_ID 단계는 생략하고,
              End Customer 값이 PROJECT_CODE 자리를 대신한다.
              콤보를 바꾸면 컬럼명도 바뀌므로 매핑은 화면이 들고 있는다. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ PROJECT_CODE: toList(searchParams.endCustomer) }}
            debugLabel='DMF0043 sales-site / Sales Site'
            value={toList(searchParams.salesSite)}
            onChange={values => {
              setSearchParams({
                salesSite: values.join(','),
                activeFlag: 'ALL',
              });
              setOpenDetailGrid(true);
            }}
          />
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
                      activeFlag: options,
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
