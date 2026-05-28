import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useApiManagementStore } from '../useApiManagementStore';

export const ApiManagementForm = () => {
  const { t } = useTranslation();

  const searchParams = useApiManagementStore(state => state.searchParams);
  const setSearchParams = useApiManagementStore(state => state.setSearchParams);
  const setFilters = useApiManagementStore(state => state.setFilters);
  const isOpenSearchArea = useApiManagementStore(state => state.isOpenSearchArea);

  const [yesOrNo] = useTabComboQueries({
    filters: ['YesOrNo'],
  });

  const [apiTypeData] = useTabLookupQueries({
    filters: [
      {
        lookupType: 'API_TP_CD',
      },
    ],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              label={t('LBL00345', '_API Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  isInput={false}
                  value={searchParams.apiType}
                  options={
                    apiTypeData?.map(item => ({
                      label: t(item.NAME, item.DESC),
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ apiType: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00323', '_API ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.apiId}
                  onChange={event => setSearchParams({ apiId: event.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.useYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ useYn: option });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
