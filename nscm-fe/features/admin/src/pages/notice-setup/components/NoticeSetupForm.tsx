import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO_ID } from '../notice-setup.constants';
import type { ComboOption } from '../notice-setup.types';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

interface NoticeSetupFormProps {
  onSearch: () => void;
}

export const NoticeSetupForm = ({ onSearch }: NoticeSetupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useNoticeSetupStore(state => state.searchParams);
  const setSearchParams = useNoticeSetupStore(state => state.setSearchParams);
  const isOpenSearchArea = useNoticeSetupStore(state => state.isOpenSearchArea);

  // 이전 comboId 'Module'/'SubModule' 은 SCM_ADM_CMBO_SQL_M 에 등록되지 않아 조회조건이 ALL 만 나왔다
  // (2026-09-11). mail-setup 표준(화면 전용 comboId + SubModule 은 PARENT_CODE 클라이언트 필터)으로 교체.
  // const [modules, subModules, yesOrNo] = useTabComboQueries({
  //   filters: ['Module', { comboId: 'SubModule', module: searchParams.module }, 'YesOrNo'],
  // });
  // 2026-09-11 사용자 요구 - Sub Module 조회조건 제거, Module 은 다중선택으로 변경.
  //   Sub Module 콤보는 더 이상 화면에서 쓰지 않아 조회하지 않는다.
  // const [modules, subModules, yesOrNo] = useTabComboQueries({
  //   filters: [COMBO_ID.MODULE, COMBO_ID.SUB_MODULE, 'YesOrNo'],
  // });
  const [modules, yesOrNo] = useTabComboQueries({
    filters: [COMBO_ID.MODULE, 'YesOrNo'],
  });

  const moduleOptions =
    (modules as ComboOption[] | undefined)?.map(item => ({ label: item.NAME, value: item.CODE })) ??
    [];
  // Sub Module 은 Module 종속 - CMBO 가 PARENT_CODE 를 함께 내려주므로 클라이언트 필터
  // const subModuleOptions =
  //   (subModules as ComboOption[] | undefined)
  //     ?.filter(
  //       item => searchParams.module === 'ALL' || item.PARENT_CODE === searchParams.module
  //     )
  //     .map(item => ({ label: item.NAME, value: item.CODE })) ?? [];
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
                  multiple
                  allOption
                  useClearIcon
                  isInput={false}
                  value={searchParams.module}
                  options={moduleOptions}
                  onChange={(_, option) => setSearchParams({ module: option || 'ALL' })}
                />
              )}
            />
          </Grid>
          {/* 2026-09-11 사용자 요구로 Sub Module 조회조건 제거
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
          */}
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
