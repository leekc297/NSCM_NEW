import { useEffect } from 'react';

import { apiClient } from '@foundation/apis';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { MENU_ID } from '../lookup.constants';
import { initSearchParams, useLookupStore, type SearchParamProps } from '../useLookupStore';

import styles from './LookupForm.module.scss';

interface LookupFormProps {
  onSubmit: () => void;
}

export const LookupForm = ({ onSubmit }: LookupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useLookupStore(state => state.searchParams);
  const setSearchParams = useLookupStore(state => state.setSearchParams);
  const isOpenSearchArea = useLookupStore(state => state.isOpenSearchArea);

  const [system] = useTabLookupQueries({
    filters: [
      {
        lookupType: 'SYSTEM',
      },
    ],
  });

  const [yesOrNo] = useTabComboQueries({
    filters: ['YesOrNo'],
  });

  // 화면 진입 시 저장된 검색조건 복원 (As-Is Condition 기능 — contribute-view 동일 패턴)
  //   Condition 버튼이 저장한 {paramNm, paramCtn} 들을 searchParams 로 셋팅.
  useEffect(() => {
    void apiClient
      .get<
        { paramNm: keyof SearchParamProps; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`)
      .then(res => {
        if (res.data.result?.length > 0) {
          // 저장된 조건이 있으면 기본값이 아닌 빈 값에서 시작 — 응답에 없는 항목은 ''로 남아야 함
          const saved = res.data.result.reduce(
            (acc, curr) => {
              acc[curr.paramNm] = curr.paramCtn;
              return acc;
            },
            { ...initSearchParams, validYn: '' } as SearchParamProps
          );
          setSearchParams(saved);
        }
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              label={t('LBL00636', 'Lookup Type')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.lookupType}
                  onChange={event => setSearchParams({ lookupType: event.target.value })}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00638', 'System')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.lookupGroup}
                  options={
                    system?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ lookupGroup: option });
                  }}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00007', 'Active')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ validYn: option });
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
