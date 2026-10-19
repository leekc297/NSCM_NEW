import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { RUN_STATUS_LOOKUP_TYPE } from '../batch-log.constants';
import { useBatchLogStore } from '../useBatchLogStore';

interface BatchLogFormProps {
  onSearch: () => void;
}

export const BatchLogForm = ({ onSearch }: BatchLogFormProps) => {
  const { t } = useTranslation();

  const searchParams = useBatchLogStore(state => state.searchParams);
  const setSearchParams = useBatchLogStore(state => state.setSearchParams);
  const isOpenSearchArea = useBatchLogStore(state => state.isOpenSearchArea);

  // Run Status 옵션 — SCM_ADM_LOOKUP_MASTER_DETAIL JOB_RUN_STATUS (AS-IS LookupCommon).
  //   ALL 항목은 CustomDropdown allOption 이 UI 로 제공(DB 에 ALL 행 없음 = AS-IS isAddALL=false).
  const [runStatusData] = useTabLookupQueries({
    filters: [{ lookupType: RUN_STATUS_LOOKUP_TYPE }],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <Grid size={3}>
          <FormItem
            // AS-IS 영문 라벨(SCM0016_BatchLog Designer L181) 그대로. i18n LBL 코드 등록은
            //   deferred — SCM_ADM_MSG_M 역조회가 이 세션 DB ERROR 라 임의 코드 배정 시
            //   다국어 오매핑 위험(Hook #114). 등록 확정 후 t('LBL#####', 'Run Status') 로 교체.
            label='Run Status'
            labelAlign='right'
            className={commonStyles.formItem}
            render={() => (
              <CustomDropdown
                isInput={false}
                allOption
                value={searchParams.runStatus}
                options={
                  runStatusData?.map(item => ({
                    label: item.NAME,
                    value: item.CODE,
                  })) ?? []
                }
                onChange={(_, option) => {
                  setSearchParams({ runStatus: option });
                }}
              />
            )}
          />
        </Grid>
      }
    />
  );
};
