import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  COMPLETED_YN_OPTIONS,
  PLAN_GROUP_DASHBOARD_COMBO_ID,
  PROCESS_CODE_LOOKUP_TYPE,
} from '../plan-group-dashboard.constants';
import { buildDivisionFilteredOptions } from '../plan-group-dashboard.util';
import { usePlanGroupDashboardStore } from '../usePlanGroupDashboardStore';

/**
 * 조회조건 6종 — AS-IS SCP0124_PlanGroupDashboard cboDivision/cboPlanGroup/clbPlant/
 * cboCompleted/dCalendar(항상 표시, 01_layout.md §2 #1~5) + usrConditionPanel1 하위
 * ActivityCode/ProcessCode(상세토글, extraConditions). 배치 순서는 01_layout.md §1 AS-IS
 * 좌표(x좌표 기준 좌→우) 그대로: Division→PlanGroup→Plant→Completed→기간.
 *
 * Division→PlanGroup cascade 는 병렬 필터 방식(재조회 아님, 02_search-combo.md §3) —
 * useCascadeFields 불요, buildDivisionFilteredOptions 로 필터한다(bod.util.ts 표준 패턴 재사용).
 *
 * clbPlant 는 공급 SQL_ID 를 확정하지 못해(constants.ts 주석 참조) 콤보를 배선하지 않는다 —
 * 확인 필요(02_search-combo.md §2.3, §7-2). 후보 콤보 자체가 없어 화면에 노출하지 않고 값은
 * 항상 'ALL'로 고정 전송한다(추측 배선 금지, anti-simplification §1) — 05 register 대상 아님.
 *
 * ActivityCode/ProcessCode(usrConditionPanel1 하위)는 메인 SP 파라미터 6개(procedures.d.ts
 * SCP0124.main.request)에 없고 boundControl 도 미확정이라(02_search-combo.md §2.2/§7-4)
 * 콤보 값을 담는 UI 필드만 노출하고 조회 필터로는 배선하지 않는다 — 확인 필요.
 *
 * 다국어 LABEL — 02_search-combo.md §4.5 가 6건 전체를 "확인 필요"로 남겼다(AS-IS 캡션 미확보로
 * `SCM_ADM_MSG_M` 역조회 자체를 시작 못함). 이 화면에서 `SCM_ADM_MSG_M`(LANG_CD='EN') 문구
 * 매칭으로 재확인한 결과 Division/Plan Group/Completed/Period/Search 5건은 기존 LBL 문구와
 * 일치해 그 ID 를 재사용한다. Activity Code/Process Code 는 정확히 일치하는 기존 LBL 이 없어
 * (LBL00059='Process'/LBL01044='Process Area' 뿐, 의미 불일치) 신규 ID 를 임의 생성하지 않고
 * `t()` 호출 없이 리터럴 영문 fallback 만 사용한다(convert-core §4.1 Hook #114 — 엉뚱한 기존
 * 코드 재사용 금지, 신규 등록은 이 activity 범위 밖).
 */
export const PlanGroupDashboardForm = () => {
  const { t } = useTranslation();

  const searchParams = usePlanGroupDashboardStore(state => state.searchParams);
  const setSearchParams = usePlanGroupDashboardStore(state => state.setSearchParams);
  const setFilters = usePlanGroupDashboardStore(state => state.setFilters);
  const fetchStaticColumns = usePlanGroupDashboardStore(state => state.fetchStaticColumns);
  const openSearchArea = usePlanGroupDashboardStore(state => state.isOpenSearchArea);

  const [divisions, planGroups, activityCodes] = useTabComboQueries({
    filters: [
      PLAN_GROUP_DASHBOARD_COMBO_ID.DIVISION,
      PLAN_GROUP_DASHBOARD_COMBO_ID.PLAN_GROUP,
      PLAN_GROUP_DASHBOARD_COMBO_ID.ACTIVITY_CODE,
    ],
  });
  const [processCodes] = useTabComboQueries({
    filters: [{ comboId: 'LookupCommon', lookupType: PROCESS_CODE_LOOKUP_TYPE }],
  });

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00002', '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.planGroupId}
                  options={buildDivisionFilteredOptions(
                    planGroups,
                    searchParams.divisionId,
                    'CODE',
                    'NAME'
                  )}
                  onChange={(_, option) => setSearchParams({ planGroupId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00058', '_Completed')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.completedYn}
                  options={[...COMPLETED_YN_OPTIONS]}
                  onChange={(_, option) => setSearchParams({ completedYn: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <PeriodRangePicker
              label={t('LBL00013', '_Period')}
              start={searchParams.startDate}
              end={searchParams.endDate}
              onChange={(start, end) => setSearchParams({ startDate: start, endDate: end })}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='Activity Code'
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.activityCode}
                  options={
                    activityCodes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ activityCode: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='Process Code'
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.processCode}
                  options={
                    processCodes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ processCode: option })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
