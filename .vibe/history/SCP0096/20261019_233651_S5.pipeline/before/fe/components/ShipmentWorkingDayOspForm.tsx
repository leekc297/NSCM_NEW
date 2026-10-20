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

  // AS-IS cboInputValue 는 Y/N(biz:CommonData.YesOrNo cs:51) · cboDayWeek 는 WEEK_WORK_TIME lookup(biz:CommonData.CommonDataList cs:49)
  //   TO-BE: 등록 콤보 'InputValue'(=YesOrNo) / 'Dayoftheweek'(=WEEK_WORK_TIME lookup) 로 매핑
  const [inputValueCombo, dayWeekCombo] = useTabComboQueries({
    filters: ['InputValue', 'Dayoftheweek'],
  });

  // AS-IS CboDayWeek_SelectedIndexChanged (SCP0096_Shipment_Working_Day_OSP.cs:670-682) — 요일 미선택이면 cboInputValue 비활성
  const inputValueDisabled = !searchParams.dayWeek;

  // AS-IS 이벤트 요약:
  //   cboDivision.SelectedIndexChanged → CboDivision_SelectedIndexChanged (cs:660-663): SetChangedControl() — Division 변경 시 PlantSite 재조회. TO-BE 는 PlantSiteField 가 division prop 으로 cascade (DivisionField onChange 로 자동).
  //   clbPlantSite.SelectedIndexChanged → ClbPlantSite_SelectedIndexChanged (cs:665-668): 본문 공백 no-op.
  //   cboDayWeek.SelectedIndexChanged → CboDayWeek_SelectedIndexChanged (cs:670-682): 아래 inputValueDisabled 로 흡수.
  //   this.chkSum.CheckedChanged → chkSum_CheckedChanged (cs:324-337): Grid 측 sumYn visibility 재계산(SetSpreadColumn).

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
            {/* AS-IS cboInputValue / UsrCombo (SCP0096_Shipment_Working_Day_OSP.Designer.cs:41) · disabled 는 CboDayWeek_SelectedIndexChanged cs:674-680 */}
            <FormItem
              label={t('LBL01084', '_Input Value')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.inputValue}
                  disabled={inputValueDisabled}
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
