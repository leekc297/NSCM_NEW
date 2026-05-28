import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useUICategorySetupStore } from '../useUICategorySetupStore';

import styles from './UICategorySetupForm.module.scss';

export const UICategorySetupForm = () => {
  const { t } = useTranslation();

  const searchParams = useUICategorySetupStore(state => state.searchParams);
  const setSearchParams = useUICategorySetupStore(state => state.setSearchParams);
  const setFilters = useUICategorySetupStore(state => state.setFilters);
  const isOpenSearchArea = useUICategorySetupStore(state => state.isOpenSearchArea);

  const [yesOrNo] = useTabComboQueries({
    filters: ['YesOrNo'],
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
              className={styles.customForm}
              label={t('LBL00305', '_Program ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.programId}
                  onChange={e => {
                    setSearchParams({ programId: e.target.value });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00306', '_Sheet Name')}
              labelAlign='right'
              className={styles.customForm}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.sheetName}
                  onChange={e => {
                    setSearchParams({ sheetName: e.target.value });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00007', '_Valid')}
              labelAlign='right'
              className={styles.customForm}
              render={() => (
                <CustomDropdown
                  value={searchParams.valid}
                  isInput={false}
                  allOption
                  options={yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ valid: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00307', '_Column Name')}
              labelAlign='right'
              className={styles.customForm}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.columnName}
                  onChange={e => {
                    setSearchParams({ columnName: e.target.value });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00308', '_Column Label Name')}
              labelAlign='right'
              className={styles.customForm}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.columnLabelName}
                  onChange={e => {
                    setSearchParams({ columnLabelName: e.target.value });
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
