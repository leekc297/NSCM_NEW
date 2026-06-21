import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, Label } from '@shared/lges';
import { Grid, Stack, Typography } from '@shared/mui';

import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

import styles from './ErpEdiMasterForm.module.scss';

export const ErpEdiMasterForm = () => {
  const { t } = useTranslation();

  const openSearchArea = useErpEdiMasterStore(state => state.openSearchArea);
  const searchParams = useErpEdiMasterStore(state => state.searchParams);
  const setSearchParams = useErpEdiMasterStore(state => state.setSearchParams);
  const setSummaryFilters = useErpEdiMasterStore(state => state.setSummaryFilters);
  const fetchStaticColumns = useErpEdiMasterStore(state => state.fetchStaticColumns);
  const updateHistory = useErpEdiMasterStore(state => state.updateHistory);

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={() => {
        setSummaryFilters();
        void fetchStaticColumns();
      }}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              className={styles.customForm}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ divisionId: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={8} className={styles.legendCell}>
            <Stack
              direction='row'
              className={styles.legendStack}
              sx={{ gap: '16px', alignItems: 'center', justifyContent: 'flex-end' }}
            >
              <Stack direction='row' sx={{ gap: '4px', alignItems: 'center' }}>
                <span className={styles.dotTag} />
                <Label labelText={t('LBL00612', '_Last Update Start:')} />
                <Typography variant='bodyBasic'>{updateHistory?.SDATE ?? '-'}</Typography>
              </Stack>
              <Stack direction='row' sx={{ gap: '4px', alignItems: 'center' }}>
                <span className={styles.dotTag} />
                <Label labelText={t('LBL00613', '_Last Update End')} />
                <Typography variant='bodyBasic'>{updateHistory?.EDATE ?? '-'}</Typography>
              </Stack>
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
