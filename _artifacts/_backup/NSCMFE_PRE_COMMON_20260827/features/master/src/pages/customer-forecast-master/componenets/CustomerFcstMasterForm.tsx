import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { useCascadeFields } from '../../../components';
import { SEARCH_CASCADE_COMBO_ID } from '../customer-fcst-master.constants';
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

  // Div / End Customer / Sales Site 콤보는 CascadeFields 가 조인 콤보 1건으로 직접 조회한다.
  // 여기서는 이 화면에만 있는 Bucket Type / Active 콤보만 받는다.
  const [buckets, yesOrNo] = useTabComboQueries({ filters: ['BucketType', 'YesOrNo'] });

  // Bucket Type 이 Div 와 End Customer 사이에 끼어 배치가 찢어지므로 컴포넌트가 아니라 훅으로
  // 받아 필요한 자리에 하나씩 꽂는다. cascade 계산은 아래 levels 배열 순서를 따르고 렌더 위치와
  // 무관하다. 이 화면은 Team 조회조건이 없어 division - endCustomer - salesSite 3단만 쓴다.
  const cascade = useCascadeFields({
    comboId: SEARCH_CASCADE_COMBO_ID,
    gridSize: 3,
    // field 는 스토어 필드명 — value 로 넘긴 searchParams 의 키와 대조돼 오타가 컴파일에서 잡힌다.
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'endCustomer', field: 'endCustomer' },
      { key: 'salesSite', field: 'scmSiteId' },
    ],
    value: searchParams,
    // 하위 단계 초기화(Div 변경 시 End Customer / Sales Site)는 next 에 이미 들어 있다.
    // 이 화면은 같이 지울 고유 조회조건이 없어 그대로 반영만 한다.
    onChange: next => setSearchParams(next),
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
          {cascade.field('salesSite')}
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
