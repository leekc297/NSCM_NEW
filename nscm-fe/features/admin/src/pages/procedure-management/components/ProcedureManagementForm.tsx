import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useProcedureManagementStore } from '../useProcedureManagementStore';

export const ProcedureManagementForm = () => {
  const { t } = useTranslation();

  const searchParams = useProcedureManagementStore(state => state.searchParams);
  const setSearchParams = useProcedureManagementStore(state => state.setSearchParams);
  const setListFilter = useProcedureManagementStore(state => state.setListFilter);
  const isOpenSearchArea = useProcedureManagementStore(state => state.isOpenSearchArea);

  const [schemaTypeData, yesOrNo] = useTabComboQueries({
    filters: ['DbSchema', 'YesOrNo'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setListFilter}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00303', '_Schema')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={searchParams?.schema}
                  options={
                    schemaTypeData?.map(item => ({
                      label: t(item.NAME, item.DESC),
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ schema: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00304', '_Procedure Name')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams?.procedure}
                  onChange={event => setSearchParams({ procedure: event.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00325', '_Update YN')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams?.updateYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: t(item.NAME, item.DESC),
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ updateYn: option });
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
