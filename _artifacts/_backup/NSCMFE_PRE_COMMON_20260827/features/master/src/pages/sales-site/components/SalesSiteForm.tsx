import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useCascadeFields } from '../../../components';
import {
  DIVISION_NO_END_CUSTOMER,
  SEARCH_CASCADE_COMBO_ID,
  SHEET_INDEX,
} from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';

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

  // Division 40 은 End Customer 개념이 없어 그 단계 콤보만 잠근다 (콤보 조회 자체는 그대로).
  const isEndCustomerDisabled = searchParams.divisionId === DIVISION_NO_END_CUSTOMER;

  // Div / End Customer / Sales Site / Sold-To Customer 콤보는 CascadeFields 가 직접 조회한다.
  // 여기서는 이 화면에만 있는 Active 콤보만 받는다.
  const [yesOrNo] = useTabComboQueries({ filters: ['YesOrNo'] });

  // Sold-To Customer 가 End Customer 와 Sales Site 사이에 끼어 배치가 찢어지므로 컴포넌트가
  // 아니라 훅으로 받아 필요한 자리에 하나씩 꽂는다. cascade 계산은 아래 levels 배열 순서를 따르고
  // 렌더 위치와 무관하다. 이 화면은 Team 조회조건이 없어 3단만 쓴다.
  const cascade = useCascadeFields({
    comboId: SEARCH_CASCADE_COMBO_ID,
    gridSize: 3,
    // field 는 스토어 필드명 — value 로 넘긴 searchParams 의 키와 대조돼 오타가 컴파일에서 잡힌다.
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'endCustomer', field: 'endCustomer', disabled: isEndCustomerDisabled },
      { key: 'salesSite', field: 'salesSite' },
    ],
    value: searchParams,
    onChange: (next, changed) => {
      // 하위 단계 초기화는 next 에 이미 들어 있다. 이 화면 고유 항목만 얹는다 —
      // Active 는 어느 단계가 바뀌든 초기화하고, Sold-To Customer 는 Division 소속 값이라
      // Division 이 바뀔 때만 초기화한다. 종전 인라인 동작 그대로.
      setSearchParams({
        ...next,
        ...(changed === 'division' ? { soldToCustomer: 'ALL' } : {}),
        activeFlag: 'ALL',
      });
      setOpenDetailGrid(true);
    },
  });

  // Sold-To Customer 는 Sales Site 와 다른 콤보('SoldCustomer')에서 뽑는 별개의 가지다 —
  // 그 콤보의 cascade 는 Div - Team - Sold-To Customer 순이다. 상위 단계를 위 훅과 같은 field
  // (divisionId)로 맞춰 두면 Div 값을 공유하면서 각자 자기 콤보를 좁힌다.
  // 이 화면은 Team 조회조건이 없어 그 단계는 렌더하지 않는다 — 선택값이 없으니 필터도 걸리지 않고
  // 전량이 그대로 흘러간다. Team 조회조건이 생기면 그 단계에 field 를 달아주면 된다.
  // 콤보 SQL 이 표준 규약(DIVISION_CODE / TEAM_CODE / SOLD_CUSTOMER_CODE + _NAME)을 따르므로
  // 단계별 columns 지정은 필요 없다.
  const soldToCascade = useCascadeFields({
    comboId: 'SoldCustomer',
    gridSize: 3,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team' },
      { key: 'soldToCustomer', field: 'soldToCustomer' },
    ],
    value: searchParams,
    onChange: next => {
      setSearchParams({ ...next, activeFlag: 'ALL' });
      setOpenDetailGrid(true);
    },
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
          {cascade.field('division')}
          {cascade.field('endCustomer')}
          {soldToCascade.field('soldToCustomer')}
          {cascade.field('salesSite')}
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
