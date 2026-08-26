import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { DivisionField, EndCustomerField, SalesSiteField } from '../../../components';
// 임시 로컬 디버그 — 확인 끝나면 이 import 와 logSearchReset 호출, debugLabel prop 을 지운다.
import { logSearchReset } from '../../../components/searchFields/SearchFields.debug';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 ('ALL' 또는 콤마 조인).
// SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
// 'ALL' 은 ['ALL'] 로 왕복하므로 기존 저장 형태가 그대로 유지된다.
const toList = (v: string) => v.split(',').filter(Boolean);

interface CustomerFcstMasterFormProps {
  onSubmit: () => void;
}

export const CustomerFcstMasterForm = ({ onSubmit }: CustomerFcstMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstMasterStore(state => state.setSearchParams);
  const userId = useSessionStore(state => state.session.userId);

  // MyDivision / EndCustomer / SalesSite 는 카탈로그 필드가 같은 comboId 로 직접 조회한다.
  // react-query 키가 동일해 캐시를 공유하므로 네트워크 호출은 늘지 않는다.
  const [buckets, yesOrNo] = useTabComboQueries({ filters: ['BucketType', 'YesOrNo'] });

  useEffect(() => {
    setSearchParams({
      userId: userId,
    });
  }, [userId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={value => {
              // 임시 로컬 디버그 — 확인 끝나면 logSearchReset 호출과 import 삭제.
              logSearchReset({
                label: 'DMF0007 customer-forecast-master',
                changed: { field: 'divisionId', from: searchParams.divisionId, to: value },
                resets: [
                  { field: 'endCustomer', from: searchParams.endCustomer, to: 'ALL' },
                  { field: 'scmSiteId', from: searchParams.scmSiteId, to: 'ALL' },
                ],
              });
              setSearchParams({
                divisionId: value,
                endCustomer: 'ALL',
                scmSiteId: 'ALL',
              });
            }}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00032', '_Bucket Type')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.bucketType}
                  options={buckets?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({
                      bucketType: option,
                    });
                  }}
                />
              )}
            />
          </Grid>
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            debugLabel='DMF0007 customer-forecast-master / End Customer'
            value={toList(searchParams.endCustomer)}
            onChange={values => {
              // 임시 로컬 디버그 — 확인 끝나면 logSearchReset 호출과 import 삭제.
              logSearchReset({
                label: 'DMF0007 customer-forecast-master',
                changed: {
                  field: 'endCustomer (= SalesSite 콤보의 PROJECT_CODE)',
                  from: searchParams.endCustomer,
                  to: values.join(','),
                },
                resets: [{ field: 'scmSiteId', from: searchParams.scmSiteId, to: 'ALL' }],
              });
              setSearchParams({
                endCustomer: values.join(','),
                // cascade 상위 단계라 하위 Sales Site 선택은 초기화한다 —
                // 안 지우면 옵션에서 사라진 사이트가 조회조건에 그대로 남아 서버로 나간다.
                scmSiteId: 'ALL',
              });
            }}
          />
          {/* cascade = division-projectCode-salesSite ('SalesSite' 콤보 반환 컬럼).
              division 은 SalesSiteField 가 항상 먼저 걸므로 여기 적지 않는다.
              이 화면은 Team 조회조건이 없어 DEPT_ID 단계는 생략하고,
              End Customer 값이 PROJECT_CODE 자리를 대신한다. DMF0043 sales-site 와 동일.
              콤보를 바꾸면 컬럼명도 바뀌므로 매핑은 화면이 들고 있는다. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ PROJECT_CODE: toList(searchParams.endCustomer) }}
            debugLabel='DMF0007 customer-forecast-master / Sales Site'
            value={toList(searchParams.scmSiteId)}
            onChange={values => {
              setSearchParams({
                scmSiteId: values.join(','),
              });
            }}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  allOption
                  limitTags={1}
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      validYn: options,
                    });
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
