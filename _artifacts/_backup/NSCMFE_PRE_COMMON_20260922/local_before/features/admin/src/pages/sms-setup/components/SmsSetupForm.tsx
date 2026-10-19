import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ALL, COMBO_ID } from '../sms-setup.constants';
import type { ComboOption } from '../sms-setup.types';
import { useSmsSetupStore } from '../useSmsSetupStore';

interface SmsSetupFormProps {
  onSearch: () => void;
}

export const SmsSetupForm = ({ onSearch }: SmsSetupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useSmsSetupStore(state => state.searchParams);
  const setSearchParams = useSmsSetupStore(state => state.setSearchParams);
  const isOpenSearchArea = useSmsSetupStore(state => state.isOpenSearchArea);

  const [modules, yesOrNo] = useTabComboQueries({
    filters: [COMBO_ID.MODULE, 'YesOrNo'],
  });

  const moduleOptions = (modules as ComboOption[] | undefined)?.map(item => ({
    label: item.NAME,
    value: item.CODE,
  }));
 
  {/* Sub Module 은 Module 종속 — CMBO 가 PARENT_CODE 를 함께 내려주므로 클라이언트 필터 -> 미사용처리
  const subModuleOptions = (subModules as ComboOption[] | undefined)
    ?.filter(item => searchParams.module === ALL || item.PARENT_CODE === searchParams.module)
    .map(item => ({ label: item.NAME, value: item.CODE }));
  */}

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
