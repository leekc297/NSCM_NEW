import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

import { SHEET_INDEX } from '../sales-site.constants';
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

  const [divisions, endCustomers, soldToCustomers, salesSites, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SoldCustomer', 'SalesSite', 'YesOrNo'],
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
                    setSearchParams({
                      divisionId: option,
                      endCustomer: 'ALL',
                      soldToCustomer: 'ALL',
                      salesSite: 'ALL',
                    });
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
                  disabled={searchParams.divisionId === '40'}
                  value={searchParams.endCustomer}
                  options={
                    [
                      ...new Map(
                        endCustomers
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      endCustomer: options,
                    });
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
                    });
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
                  value={searchParams.salesSite}
                  options={
                    [
                      ...new Map(
                        salesSites
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [
                            `${item.DIVISION_ID ?? ''}|${item.END_CUSTOMER}|${item.CODE}`,
                            item,
                          ])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      salesSite: options,
                    });
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
