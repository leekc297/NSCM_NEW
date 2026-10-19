import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, Label } from '@shared/lges';
import { Grid, Stack, Typography } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

import styles from './ErpEdiMasterForm.module.scss';

export const ErpEdiMasterForm = () => {
  const { t } = useTranslation();

  const openSearchArea = useErpEdiMasterStore(state => state.openSearchArea);
  const searchParams = useErpEdiMasterStore(state => state.searchParams);
  const setSearchParams = useErpEdiMasterStore(state => state.setSearchParams);
  const setSummaryFilters = useErpEdiMasterStore(state => state.setSummaryFilters);
  const clearAllGrids = useErpEdiMasterStore(state => state.clearAllGrids);
  const fetchStaticColumns = useErpEdiMasterStore(state => state.fetchStaticColumns);
  const updateHistory = useErpEdiMasterStore(state => state.updateHistory);

  // Division 변경은 clearAllGrids()로 전 그리드를 비운다. 편집중(dirty)이면 MSG00704 confirm
  //   후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를 콤보 변경에도 동일 적용.
  //   controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

  const [divisions] = useTabComboQueries({
    filters: ['MyDivision'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={() => {
        clearAllGrids();
        setSummaryFilters();
        void fetchStaticColumns();
      }}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              className={`${styles.customForm} ${commonStyles.formItem}`}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setSearchParams({ divisionId: option });
                      clearAllGrids();
                      void fetchStaticColumns();
                    });
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
              <Stack direction='row' sx={{ gap: '4px', alignItems: 'center' }}>
                <span className={styles.dotTag} />
                <Label labelText={t('LBL01155', '_Updated by')} />
                <Typography variant='bodyBasic'>{updateHistory?.UPDATED_BY ?? '-'}</Typography>
              </Stack>
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
