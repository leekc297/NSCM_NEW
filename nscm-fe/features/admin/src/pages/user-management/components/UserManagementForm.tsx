import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useUserManagementStore } from '../useUserManagementStore';

import styles from './UserManagementForm.module.scss';

export const UserManagementForm = () => {
  const { t } = useTranslation();

  const searchParams = useUserManagementStore(state => state.searchParams);
  const setSearchParams = useUserManagementStore(state => state.setSearchParams);
  const setFilters = useUserManagementStore(state => state.setFilters);
  const isOpenSearchArea = useUserManagementStore(state => state.isOpenSearchArea);

  const [yesOrNo, group] = useTabComboQueries({
    filters: ['YesOrNo', 'UserGroup'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00339', '_User ID(Name)')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.user}
                  onChange={event => setSearchParams({ user: event.target.value })}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00338', '_Dept ID(Name)')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.department}
                  onChange={event => setSearchParams({ department: event.target.value })}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00340', '_User Group')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  multiple
                  isInput={false}
                  value={searchParams.group}
                  options={
                    group?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ group: option });
                  }}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              labelSize='long'
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
              className={styles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
