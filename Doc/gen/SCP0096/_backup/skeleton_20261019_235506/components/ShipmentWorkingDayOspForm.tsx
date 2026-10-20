// SCP0096 Shipment_Working_Day_OSP — TobeGen 생성 골격 (As-is SCP0096_Shipment_Working_Day_OSP, Fact Pack Doc/asisfacts/screens/SCP0096)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// 조회조건 카탈로그(features/master searchFields — 31개 화면이 같은 경로로 import)
import { DivisionField, PeriodField, PlantSiteField } from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useShipmentWorkingDayOspStore } from '../useShipmentWorkingDayOspStore';

export const ShipmentWorkingDayOspForm = () => {
  const { t } = useTranslation();

  const searchParams = useShipmentWorkingDayOspStore(state => state.searchParams);
  const setSearchParams = useShipmentWorkingDayOspStore(state => state.setSearchParams);
  const setFilters = useShipmentWorkingDayOspStore(state => state.setFilters);
  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [inputValueCombo, dayWeekCombo] = useTabComboQueries({
    filters: ['InputValue', 'Dayoftheweek'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS cboDivision.SelectedIndexChanged → CboDivision_SelectedIndexChanged (SCP0096_Shipment_Working_Day_OSP.cs:251) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS clbPlantSite.SelectedIndexChanged → ClbPlantSite_SelectedIndexChanged (SCP0096_Shipment_Working_Day_OSP.cs:252) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS cboDayWeek.SelectedIndexChanged → CboDayWeek_SelectedIndexChanged (SCP0096_Shipment_Working_Day_OSP.cs:253) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange
  //   AS-IS this.chkSum.CheckedChanged → chkSum_CheckedChanged (SCP0096_Shipment_Working_Day_OSP.cs:255) — Checkbox onChange → setSearchParams / 그리드 표시 토글이면 applyDynVisibility

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* AS-IS dCalendar / UsrDateRangePicker3 (SCP0096_Shipment_Working_Day_OSP.Designer.cs:36) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          {/* AS-IS cboDivision / UsrCombo (SCP0096_Shipment_Working_Day_OSP.Designer.cs:38) — 카탈로그 DivisionField · 콤보 MyDivision */}
          <DivisionField value={searchParams.divisionId} onChange={v => setSearchParams({ divisionId: v })} gridSize={3} />
          {/* AS-IS clbPlantSite / UsrCheckedList (SCP0096_Shipment_Working_Day_OSP.Designer.cs:39) — 카탈로그 PlantSiteField · 콤보 PlantSitebyEndCustomer */}
          <PlantSiteField
            value={searchParams.plantSiteIds}
            onChange={v => setSearchParams({ plantSiteIds: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS chkSum / UsrCheckBox (SCP0096_Shipment_Working_Day_OSP.Designer.cs:40) */}
            <FormItem
              label={t('LBL00687', '_Sum')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.sumYn} onChange={checked => setSearchParams({ sumYn: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboInputValue / UsrCombo (SCP0096_Shipment_Working_Day_OSP.Designer.cs:41) */}
            <FormItem
              label={t('LBL01084', '_Input Value')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.inputValue}
                  options={inputValueCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ inputValue: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboDayWeek / UsrCombo (SCP0096_Shipment_Working_Day_OSP.Designer.cs:42) */}
            <FormItem
              label={t('LBL01067', '_Day of the week')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.dayWeek}
                  options={dayWeekCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ dayWeek: option })}
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
