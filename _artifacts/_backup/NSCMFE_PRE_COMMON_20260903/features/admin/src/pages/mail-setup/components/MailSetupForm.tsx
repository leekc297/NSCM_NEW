import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ALL, COMBO_ID } from '../mail-setup.constants';
import type { ComboOption } from '../mail-setup.types';
import { useMailSetupStore } from '../useMailSetupStore';

interface MailSetupFormProps {
  onSearch: () => void;
}

export const MailSetupForm = ({ onSearch }: MailSetupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useMailSetupStore(state => state.searchParams);
  const setSearchParams = useMailSetupStore(state => state.setSearchParams);
  const isOpenSearchArea = useMailSetupStore(state => state.isOpenSearchArea);

  const [modules, subModules, yesOrNo] = useTabComboQueries({
    filters: [COMBO_ID.MODULE, COMBO_ID.SUB_MODULE, 'YesOrNo'],
  });

  const moduleOptions = (modules as ComboOption[] | undefined)?.map(item => ({
    label: item.NAME,
    value: item.CODE,
  }));

  // Sub Module 은 Module 종속 — CMBO 가 PARENT_CODE 를 함께 내려주므로 클라이언트 필터
  const subModuleOptions = (subModules as ComboOption[] | undefined)
    ?.filter(item => searchParams.module === ALL || item.PARENT_CODE === searchParams.module)
    .map(item => ({ label: item.NAME, value: item.CODE }));

  const activeOptions = (yesOrNo as ComboOption[] | undefined)?.map(item => ({
    label: item.NAME,
    value: item.CODE,
  }));

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
                  options={moduleOptions ?? []}
                  onChange={(_, option) => setSearchParams({ module: option || ALL })}
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
                  value={searchParams.submodule}
                  options={subModuleOptions ?? []}
                  onChange={(_, option) => setSearchParams({ submodule: option || ALL })}
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
                  value={searchParams.active}
                  options={activeOptions ?? []}
                  onChange={(_, option) => setSearchParams({ active: option || ALL })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
