import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useMenuButtonManagementStore } from '../useMenuButtonManagementStore';

export const MenuButtonnManagementForm = () => {
  const { t } = useTranslation();

  const searchParams = useMenuButtonManagementStore(state => state.searchParams);
  const setSearchParams = useMenuButtonManagementStore(state => state.setSearchParams);
  const isOpenSearchArea = useMenuButtonManagementStore(state => state.isOpenSearchArea);
  const setFilters = useMenuButtonManagementStore(state => state.setFilters);

  const [menuCombo, yesOrNo] = useTabComboQueries({
    filters: ['MenuList', 'YesOrNo'],
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
              label={t('LBL00347', '_Menu')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  value={searchParams.menuId}
                  options={
                    menuCombo?.map(item => ({
                      label: t(item.NAME, item.DESC),
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ menuId: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00306', '_Sheet name')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.sheetNm}
                  onChange={event => setSearchParams({ sheetNm: event.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00348', '_API Name')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.apiNm}
                  onChange={event => setSearchParams({ apiNm: event.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  allOption
                  isInput={false}
                  value={searchParams.useYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: t(item.NAME, item.DESC),
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
