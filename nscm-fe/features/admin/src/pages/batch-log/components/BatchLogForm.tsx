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
              // AS-IS clbRunStatus 는 UsrCheckedList(체크박스 다중 선택) — ItemSelectionMode=One 은
              //   리스트 하이라이트 모드일 뿐 체크 자체는 다중 가능(ValueList 가 체크 항목을 콤마로
              //   join, UsrCheckedList.cs L298~322/599~611). GetCheckedListValue 가 그 값을
              //   p_run_status 로 그대로 전달(SCM0016_BatchLog.cs L280) → 다중 선택 재현.
              <CustomDropdown
                multiple
                allOption
                useClearIcon
                value={searchParams.runStatus}
                options={
                  runStatusData?.map(item => ({
                    label: item.NAME,
                    value: item.CODE,
                  })) ?? []
                }
                onChange={(_, options) => {
                  setSearchParams({ runStatus: options });
                }}
              />
            )}
          />
        </Grid>
      }
    />
  );
};
