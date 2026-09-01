import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useNoticeSetupStore } from '../useNoticeSetupStore';

interface NoticeSetupFormProps {
  onSearch: () => void;
}

export const NoticeSetupForm = ({ onSearch }: NoticeSetupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useNoticeSetupStore(state => state.searchParams);
  const setSearchParams = useNoticeSetupStore(state => state.setSearchParams);
  const isOpenSearchArea = useNoticeSetupStore(state => state.isOpenSearchArea);

  const [modules, subModules, yesOrNo] = useTabComboQueries({
    filters: ['Module', { comboId: 'SubModule', module: searchParams.module }, 'YesOrNo'],
  });

  const moduleOptions = modules?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [];
  const subModuleOptions = subModules?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [];
  const activeOptions = yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00379', '_Module')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  isInput={false}
                  value={searchParams.module}
                  options={moduleOptions}
                  onChange={(_, option) => setSearchParams({ module: option || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00378', '_Sub Module')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  isInput={false}
                  value={searchParams.subModule}
                  options={subModuleOptions}
                  onChange={(_, option) => setSearchParams({ subModule: option || 'ALL' })}
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
                  allOption
                  isInput={false}
                  value={searchParams.activeYn}
                  options={activeOptions}
                  onChange={(_, option) => setSearchParams({ activeYn: option || 'ALL' })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
