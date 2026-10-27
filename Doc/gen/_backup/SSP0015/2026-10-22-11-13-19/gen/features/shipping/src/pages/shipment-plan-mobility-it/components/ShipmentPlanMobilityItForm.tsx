// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// 조회조건 카탈로그(features/master searchFields — 31개 화면이 같은 경로로 import)
import { BucketField, ItemField, PeriodField, PlantSiteField } from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';

export const ShipmentPlanMobilityItForm = () => {
  const { t } = useTranslation();

  const searchParams = useShipmentPlanMobilityItStore(state => state.searchParams);
  const setSearchParams = useShipmentPlanMobilityItStore(state => state.setSearchParams);
  const setFilters = useShipmentPlanMobilityItStore(state => state.setFilters);
  const isOpenSearchArea = useShipmentPlanMobilityItStore(state => state.isOpenSearchArea);

  // As-is 에 Division 조회조건 없음 — 팝업 필드(division 필수)용 기본 사업부 = 공용 콤보 MyDivision 첫 값 (SCM_ADM_CMBO_SQL_M)
  const [myDivision] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const first = myDivision?.[0]?.CODE;
    if (!searchParams.divisionId && first) setSearchParams({ divisionId: String(first) });
  }, [myDivision, searchParams.divisionId, setSearchParams]);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [planDateCombo, divisionIdsCombo, resultTypeCombo] = useTabComboQueries({
    filters: ['Plan-date*', 'MyDivision', 'ResultType'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS this.cboBucketType.SelectedIndexChanged → cboBucketType_SelectedIndexChanged (SSP0015_ShipmentPSI.cs:1165) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS this.chkSum.CheckedChanged → chkSum_CheckedChanged (SSP0015_ShipmentPSI.cs:1166) — Checkbox onChange → setSearchParams / 그리드 표시 토글이면 applyDynVisibility
  //   AS-IS clbDivision.SelectedIndexChanged → clbDivision_SelectedIndexChanged (SSP0015_ShipmentPSI.cs:1179) 호출: biz:CommonData.CommonDataList [code=PlanDateShip], SCP.SCM0001_GET_SCP_DAY_PERIOD — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboPlanDate.SelectedIndexChanged → CboPlanDate_SelectedIndexChanged (SSP0015_ShipmentPSI.cs:1180) 호출: SCP.SCM0001_GET_SCP_DAY_PERIOD — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            {/* AS-IS cboPlanDate / UsrCombo (SSP0015_ShipmentPSI.Designer.cs:36) */}
            <FormItem
              label={t('LBL00039', '_Plan-date*')}
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
          <Grid size={3}>
            {/* AS-IS chkSum / UsrCheckBox (SSP0015_ShipmentPSI.Designer.cs:37) */}
            <FormItem
              label={t('LBL?????', '_Change Qty')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.sumYn} onChange={checked => setSearchParams({ sumYn: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS clbPlantSite / UsrCheckedList (SSP0015_ShipmentPSI.Designer.cs:40) — 카탈로그 PlantSiteField · 콤보 PlantSitebyEndCustomer */}
          <PlantSiteField
            value={searchParams.plantSiteIds}
            onChange={v => setSearchParams({ plantSiteIds: v })}
            gridSize={3}
          />
          {/* AS-IS drpPeriod / UsrDateRangePicker (SSP0015_ShipmentPSI.Designer.cs:41) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          {/* AS-IS txtItemId / UsrMultiLineEditor (SSP0015_ShipmentPSI.Designer.cs:42) + btnItemId 팝업(필드 내장) — 카탈로그 ItemField */}
          <ItemField
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          {/* AS-IS cboBucketType / UsrCombo (SSP0015_ShipmentPSI.Designer.cs:43) — 카탈로그 BucketField · 콤보 BucketType */}
          <BucketField value={searchParams.bucketType} onChange={v => setSearchParams({ bucketType: v })} gridSize={3} />
          <Grid size={3}>
            {/* AS-IS clbDivision / UsrCombo (SSP0015_ShipmentPSI.Designer.cs:44) */}
            <FormItem
              label={t('LBL00001', '_Division*')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.divisionIds}
                  options={divisionIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionIds: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkMyModel / UsrCheckBox (SSP0015_ShipmentPSI.Designer.cs:45) */}
            <FormItem
              label={t('LBL01093', '_My Model')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.myModel} onChange={checked => setSearchParams({ myModel: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkPartLeader / UsrCheckBox (SSP0015_ShipmentPSI.Designer.cs:46) */}
            <FormItem
              label={t('LBL01101', '_Part Leader')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.partLeader} onChange={checked => setSearchParams({ partLeader: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkTeamLeader / UsrCheckBox (SSP0015_ShipmentPSI.Designer.cs:47) */}
            <FormItem
              label={t('LBL01124', '_Team Leader')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.teamLeader} onChange={checked => setSearchParams({ teamLeader: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS chkDelegateeModel / UsrCheckBox (SSP0015_ShipmentPSI.Designer.cs:48) */}
            <FormItem
              label={t('LBL01070', '_Delegatee Model')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.delegateeModel} onChange={checked => setSearchParams({ delegateeModel: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbResultType / UsrCheckedList (SSP0015_ShipmentPSI.Designer.cs:71) */}
            <FormItem
              label={t('LBL01109', '_Result Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.resultType.join(',')}
                  options={resultTypeCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ resultType: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS txtRequestor / UsrTextBox (SSP0015_ShipmentPSI.Designer.cs:73) */}
            <FormItem
              label={t('LBL?????', '_item.UserName')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.requestor}
                  onChange={event => setSearchParams({ requestor: event.target.value })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS txtModel2 / UsrMultiLineEditor (SSP0015_ShipmentPSI.Designer.cs:75) */}
            <FormItem
              label={t('LBL00669', '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.model2}
                  onChange={event => setSearchParams({ model2: event.target.value })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS drpPeriod2 / UsrDateRangePicker (SSP0015_ShipmentPSI.Designer.cs:77) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          {/* AS-IS drpPeriod3 / UsrDateRangePicker (SSP0015_ShipmentPSI.Designer.cs:78) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS txtLotID / UsrMultiLineEditor (SSP0015_ShipmentPSI.Designer.cs:79) */}
            <FormItem
              label={t('LBL01090', '_Lot ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.lotId}
                  onChange={event => setSearchParams({ lotId: event.target.value })}
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
