// SCP0122 PlanActivityMgmt — TobeGen 생성 골격 (As-is SCP0122_PlanActivityMgmt, Fact Pack Doc/asisfacts/screens/SCP0122)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// 조회조건 카탈로그(features/master searchFields — 31개 화면이 같은 경로로 import)
import { DivisionField } from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { usePlanActivityMgmtStore } from '../usePlanActivityMgmtStore';

export const PlanActivityMgmtForm = () => {
  const { t } = useTranslation();

  const searchParams = usePlanActivityMgmtStore(state => state.searchParams);
  const setSearchParams = usePlanActivityMgmtStore(state => state.setSearchParams);
  const setFilters = usePlanActivityMgmtStore(state => state.setFilters);
  const isOpenSearchArea = usePlanActivityMgmtStore(state => state.isOpenSearchArea);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [planGroupsCombo, processCombo] = useTabComboQueries({
    filters: ['PlanGroup', 'Process'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS cboDivision.SelectedIndexChanged → ClbDivision_SelectedIndexChanged (SCP0122_PlanActivityMgmt.cs:217) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboPlanGroup.SelectedIndexChanged → CboPlanGroup_SelectedIndexChanged (SCP0122_PlanActivityMgmt.cs:218) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            {/* AS-IS cboPlanGroup / UsrComboBox (SCP0122_PlanActivityMgmt.Designer.cs:37) */}
            <FormItem
              label={t('LBL00002', '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.planGroups}
                  options={planGroupsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ planGroups: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboProcess / UsrComboBox (SCP0122_PlanActivityMgmt.Designer.cs:38) */}
            <FormItem
              label={t('LBL00059', '_Process')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.process}
                  options={processCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ process: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS cboDivision / UsrCombo (SCP0122_PlanActivityMgmt.Designer.cs:39) — 카탈로그 DivisionField · 콤보 MyDivision */}
          <DivisionField value={searchParams.divisionId} onChange={v => setSearchParams({ divisionId: v })} gridSize={3} />
        </>
      }
    />
  );
};
