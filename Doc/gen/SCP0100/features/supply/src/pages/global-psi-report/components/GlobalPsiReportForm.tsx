// SCP0100 Global_PSI_Report — TobeGen 생성 골격 (As-is SCP0100_Global_PSI_Report, Fact Pack Doc/asisfacts/screens/SCP0100)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// 조회조건 카탈로그(features/master searchFields — 31개 화면이 같은 경로로 import)
import { BucketField, ItemField, PeriodField, ProjectField } from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, InputField, RadioGroup } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useGlobalPsiReportStore } from '../useGlobalPsiReportStore';

export const GlobalPsiReportForm = () => {
  const { t } = useTranslation();

  const searchParams = useGlobalPsiReportStore(state => state.searchParams);
  const setSearchParams = useGlobalPsiReportStore(state => state.setSearchParams);
  const setFilters = useGlobalPsiReportStore(state => state.setFilters);
  const isOpenSearchArea = useGlobalPsiReportStore(state => state.isOpenSearchArea);

  // As-is 에 Division 조회조건 없음 — 팝업 필드(division 필수)용 기본 사업부 = 공용 콤보 MyDivision 첫 값 (SCM_ADM_CMBO_SQL_M)
  const [myDivision] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const first = myDivision?.[0]?.CODE;
    if (!searchParams.divisionId && first) setSearchParams({ divisionId: String(first) });
  }, [myDivision, searchParams.divisionId, setSearchParams]);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [planDateCombo, graphTypeCombo, displayCombo, fromSiteIdsCombo, toSiteIdsCombo, planTypeCombo, searchLevelCombo, unitQtyCombo, divisionIdsCombo] = useTabComboQueries({
    filters: ['Plandate*', 'Graph', 'Display', 'FromSite', 'ToSite', 'Plan-type', 'SearchLevel', 'Unit(Qty)', 'MyDivision'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS clbDivision.SelectedIndexChanged → ClbDivision_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1127) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboGraphType.SelectedIndexChanged → CboGraphType_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1128) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboPlanDate.SelectedIndexChanged → CboPlanDate_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1129) 호출: SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN, biz:CommonData.CommonDataList_REPORT [code={?Data_REPORT.Type.PLAN_END_DATE}] — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboBucketType.SelectedIndexChanged → CboBucketType_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1130) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboDisplay.SelectedIndexChanged → CboDisplay_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1131) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboSearchLevel.SelectedIndexChanged → CboSearchLevel_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1132) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboUnitQty.SelectedIndexChanged → CboUnitQty_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1133) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS rgrpSearchLevel.SelectedIndexChanged → rgrpSearchLevel_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1134) 호출: SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboPlanType.SelectedIndexChanged → CboPlanType_SelectedIndexChanged (SCP0100_Global_PSI_Report.cs:1140) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS dCalendar.ValueChanged → DCalendar_ValueChanged (SCP0100_Global_PSI_Report.cs:1143) 호출: SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN — PeriodField onChange → setSearchParams
  //   AS-IS chkCellQty.CheckedChanged → ChkCellQty_CheckedChanged (SCP0100_Global_PSI_Report.cs:1144) — Checkbox onChange → setSearchParams / 그리드 표시 토글이면 applyDynVisibility
  //   AS-IS chkAS.CheckedChanged → ChkAS_CheckedChanged (SCP0100_Global_PSI_Report.cs:1145) — Checkbox onChange → setSearchParams / 그리드 표시 토글이면 applyDynVisibility

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            {/* AS-IS rgrpSearchLevel / RadioGroup (SCP0100_Global_PSI_Report.designer.cs:39) */}
            <FormItem
              label={t('LBL00050', '_Search Level')}
              labelAlign='right'
              render={() => (
                <RadioGroup value={searchParams.searchLevel} onChange={event => setSearchParams({ searchLevel: event.target.value })}>{/* TODO(이식): As-is 라디오 항목 */}</RadioGroup>
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkCellQty / UsrCheckBox (SCP0100_Global_PSI_Report.designer.cs:40) */}
            <FormItem
              label={t('LBL00690', '_Cell Qty')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.cellQty} onChange={checked => setSearchParams({ cellQty: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboPlanDate / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:41) */}
            <FormItem
              label={t('LBL00039', '_Plan date*')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.planDate}
                  options={planDateCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ planDate: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS cboBucketType / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:42) — 카탈로그 BucketField · 콤보 BucketType */}
          <BucketField value={searchParams.bucketType} onChange={v => setSearchParams({ bucketType: v })} gridSize={3} />
          {/* AS-IS dCalendar / UsrDateRangePicker3 (SCP0100_Global_PSI_Report.designer.cs:43) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS cboGraphType / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:44) */}
            <FormItem
              label={t('LBL01080', '_Graph')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.graphType}
                  options={graphTypeCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ graphType: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS txtItemId / UsrTextBox (SCP0100_Global_PSI_Report.designer.cs:47) + btnItemId 팝업(필드 내장) — 카탈로그 ItemField */}
          <ItemField
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS cboDisplay / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:48) */}
            <FormItem
              label={t('LBL01073', '_Display')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.display}
                  options={displayCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ display: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS txtProject / UsrTextBox (SCP0100_Global_PSI_Report.designer.cs:49) + btnProject 팝업(필드 내장) — 카탈로그 ProjectField */}
          <ProjectField
            value={searchParams.projectCodes}
            onChange={v => setSearchParams({ projectCodes: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS clbFromSite / UsrCheckedList2 (SCP0100_Global_PSI_Report.designer.cs:50) */}
            <FormItem
              label={t('LBL00022', '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.fromSiteIds.join(',')}
                  options={fromSiteIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ fromSiteIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbToSite / UsrCheckedList2 (SCP0100_Global_PSI_Report.designer.cs:51) */}
            <FormItem
              label={t('LBL00023', '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.toSiteIds.join(',')}
                  options={toSiteIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ toSiteIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS txtCellGroup / UsrTextBox (SCP0100_Global_PSI_Report.designer.cs:52) */}
            <FormItem
              label={t('LBL00049', '_Cell Group')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.cellGroup}
                  onChange={event => setSearchParams({ cellGroup: event.target.value })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboPlanType / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:54) */}
            <FormItem
              label={t('LBL00040', '_Plan-type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.planType}
                  options={planTypeCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ planType: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboSearchLevel / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:56) */}
            <FormItem
              label={t('LBL00050', '_Search Level')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.searchLevel}
                  options={searchLevelCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ searchLevel: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkAS / UsrCheckBox (SCP0100_Global_PSI_Report.designer.cs:57) */}
            <FormItem
              label={t('LBL00685', '_A/S')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.as} onChange={checked => setSearchParams({ as: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboUnitQty / UsrCombo (SCP0100_Global_PSI_Report.designer.cs:58) */}
            <FormItem
              label={t('LBL01129', '_Unit (Qty)')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.unitQty}
                  options={unitQtyCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ unitQty: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbDivision / UsrCheckedList2 (SCP0100_Global_PSI_Report.designer.cs:59) */}
            <FormItem
              label={t('LBL00001', '_Div*')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.divisionIds.join(',')}
                  options={divisionIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ divisionIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
