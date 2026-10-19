// ====================================================================================
// CustomerFcstMasterForm - DMF0007 조회조건
// ====================================================================================
// 검색조건 - 콤보
//
//   Div           SEARCH_CASCADE_COMBO_ID       조인 콤보 1단   useCascadeFields
//   Bucket Type   'BucketType'                  단독
//   End Customer  SEARCH_CASCADE_COMBO_ID       조인 콤보 2단   useCascadeFields (Div 로 좁힘)
//                                                               sortBy='label' (가나다 정렬)
//   Sales Site    SEARCH_SALES_SITE_COMBO_ID    파라미터 콤보   SalesSiteField
//                                               (Div / End Customer 가 바뀌면 재조회)
//                                                               sortBy='label' (가나다 정렬)
//   Active        'YesOrNo'                     단독
//
// 정렬은 이 화면만 켠 것이다. End Customer / Sales Site 는 코드 목록이라 콤보가 준 순서에
// 업무 의미가 없어서 사용자가 눈으로 찾기 쉬운 표시명 순(숫자-영어-한글)으로 바꿨다.
// 같은 콤보를 쓰는 다른 화면은 손대지 않았다 - 정렬은 칸마다 켜는 옵트인이다.
//
// 콤보 ID 상수와 그 유래는 customer-fcst-master.constants 참조.
// ====================================================================================

import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { SalesSiteField, useCascadeFields } from '../../../components';
import {
  SEARCH_CASCADE_COMBO_ID,
  SEARCH_SALES_SITE_COMBO_ID,
} from '../customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFormProps {
  onSubmit: () => void;
}

export const CustomerFcstMasterForm = ({ onSubmit }: CustomerFcstMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstMasterStore(state => state.setSearchParams);
  const userId = useSessionStore(state => state.session.userId);

  // Div / End Customer 콤보는 useCascadeFields 가 직접 조회한다.
  // 여기서는 이 화면에만 있는 Bucket Type / Active 콤보만 받는다.
  const [buckets, yesOrNo] = useTabComboQueries({ filters: ['BucketType', 'YesOrNo'] });

  // Bucket Type 이 Div 와 End Customer 사이에 끼어 배치가 찢어지므로 컴포넌트가 아니라 훅으로
  // 받아 필요한 자리에 하나씩 꽂는다. cascade 계산은 아래 levels 순서를 따르고 렌더 위치와
  // 무관하다. 이 화면은 Team 조회조건이 없어 2단이다.
  const cascade = useCascadeFields({
    comboId: SEARCH_CASCADE_COMBO_ID,
    gridSize: 3,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'endCustomer', field: 'endCustomer', sortBy: 'label' },
    ],
    value: searchParams,
    onChange: next => setSearchParams({ ...next, scmSiteId: 'ALL' }),
  });

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
          {cascade.field('division')}
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
          {cascade.field('endCustomer')}
          <SalesSiteField
            gridSize={3}
            comboId={SEARCH_SALES_SITE_COMBO_ID}
            sortBy='label'
            division={searchParams.divisionId}
            endCustomer={searchParams.endCustomer}
            value={searchParams.scmSiteId.split(',').filter(Boolean)}
            onChange={codes => setSearchParams({ scmSiteId: codes.join(',') })}
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
