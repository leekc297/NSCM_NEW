import { type MutableRefObject, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useApiManagementStore } from '../useApiManagementStore';

interface ApiManagementFormProps {
  onSearch: () => void;
  // API ID key-in 미러 — 페이지가 blur 없이(F5) 조회할 때 최신 입력값을 읽는다.
  //   (아래 typedApiId 주석 참조 — 스토어 반영은 blur 확정 시점에만)
  apiIdInputRef: MutableRefObject<string>;
}

export const ApiManagementForm = ({ onSearch, apiIdInputRef }: ApiManagementFormProps) => {
  const { t } = useTranslation();

  const searchParams = useApiManagementStore(state => state.searchParams);
  const setSearchParams = useApiManagementStore(state => state.setSearchParams);
  const isOpenSearchArea = useApiManagementStore(state => state.isOpenSearchArea);

  // API ID key-in 은 폼 로컬 state 로만 받는다 (typedApiId !== null 인 동안만 입력값 우선).
  //   금지: onChange 에서 스토어 write. searchParams 는 페이지 본체도 구독하므로 글자마다
  //   페이지 전체가 리렌더되고, ApiManagementGrid 가 매 렌더 새 dblClick 핸들러를 넘겨
  //   DataGrid 의 memo 까지 깨진다 = wijmo columnGroups 재대입(컬럼 객체 전체 재생성).
  //   스토어 반영은 blur 확정 시점 1회. blur 없이 F5 로 조회하는 경로는 apiIdInputRef 로 커버.
  const [typedApiId, setTypedApiId] = useState<string | null>(null);
  const apiIdText = typedApiId ?? searchParams.apiId;
  apiIdInputRef.current = apiIdText;

  const commitApiId = () => {
    setTypedApiId(null);
    if (apiIdText === searchParams.apiId) return;
    setSearchParams({ apiId: apiIdText });
  };

  const [yesOrNo] = useTabComboQueries({
    filters: ['YesOrNo'],
  });

  const [apiTypeData] = useTabLookupQueries({
    filters: [
      {
        lookupType: 'API_TP_CD',
      },
    ],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00345', '_API Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  isInput={false}
                  value={searchParams.apiType}
                  options={
                    apiTypeData?.map(item => ({
                      label: t(item.NAME, item.DESC),
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ apiType: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00323', '_API ID')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={apiIdText}
                  onChange={event => setTypedApiId(event.target.value)}
                  onBlur={commitApiId}
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
            />
          </Grid>
        </>
      }
    />
  );
};
