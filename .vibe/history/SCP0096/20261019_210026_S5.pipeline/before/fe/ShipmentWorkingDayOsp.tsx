// SCP0096 Shipment_Working_Day_OSP — TobeGen 생성 골격 (As-is SCP0096_Shipment_Working_Day_OSP, Fact Pack Doc/asisfacts/screens/SCP0096)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { ShipmentWorkingDayOspForm } from './components/ShipmentWorkingDayOspForm';
import { ShipmentWorkingDayOspGrid } from './components/ShipmentWorkingDayOspGrid';
import type { RESPONSE_SET } from './shipment-working-day-osp.constants';
import { MENU_ID, SHEETS } from './shipment-working-day-osp.constants';
import { useShipmentWorkingDayOspStore } from './useShipmentWorkingDayOspStore';

export const ShipmentWorkingDayOsp = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SHIPMENT_WORKING_DAY_OSP, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useShipmentWorkingDayOspStore(state => state.filters);
  const setFilters = useShipmentWorkingDayOspStore(state => state.setFilters);
  const staticColumns = useShipmentWorkingDayOspStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentWorkingDayOspStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentWorkingDayOspStore(state => state.setOpenSearchArea);

  // spdMain ← 시트 'Shipment Working Day OSP'. As-is 조회 SP: DM0003_GET_BUCKET_TYPE_CODE, SCP0096_GET_SHIPMENT_WORKING_DAY_OSP, SCP0009_GET_SHEET_CALENDAR_3SPAN
  const { data: data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_WORKING_DAY_OSP,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  // As-is 저장 SP 없음 — 조회 전용 화면 (useProcMutation 미사용)

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // AS-IS btnInput.Click → BtnInput_Click (SCP0096_Shipment_Working_Day_OSP.cs:254)
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleInput = () => {
    // TODO(이식): As-is BtnInput_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS SaveButton SCP0096_Shipment_Working_Day_OSP.cs:299 4줄 — 저장 SP 가 Fact Pack 에 없음(그리드 외 저장/파일 등) → TODO(이식)
  const handleSave = () => {
    // TODO(이식): As-is SaveButton 본문
  };
  // AS-IS EditButton SCP0096_Shipment_Working_Day_OSP.cs:282 16줄 — hotkeyConfig 미지원: customButtons 의 편집 토글(IsReadOnly) 로 — TODO(이식)

  // AS-IS 빈 override(기능 비활성으로 해석 → false): InsertButton(SCP0096_Shipment_Working_Day_OSP.cs:274 3줄 빈 본문), DeleteButton(SCP0096_Shipment_Working_Day_OSP.cs:278 3줄 빈 본문)
  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SCP0096_Shipment_Working_Day_OSP.cs:269 4줄)
    save: handleSave, // AS-IS SaveButton SCP0096_Shipment_Working_Day_OSP.cs:299 4줄
    insert: false, // AS-IS InsertButton 미정의
    delete: false, // AS-IS DeleteButton 미정의
    excel: false, // AS-IS ExcelButton 미정의
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  // As-is 화면 버튼 → SubTitle customButtons (dmf0045 선례). 라벨은 LBL 코드, 동작은 위 핸들러
  const customButtons = [
    { label: t('LBL?????', '_Button1'), action: () => { /* TODO(이식): As-is usrButton1 Click — events.csv 에 핸들러 없음 */ } }, // AS-IS usrButton1
    { label: t('LBL00872', '_Input'), action: handleInput }, // AS-IS btnInput
  ];
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ShipmentWorkingDayOspForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc?.length ?? 0}
        excelFileName='Shipment_Working_Day_OSP'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
        customButtons={customButtons}
      />
      <ShipmentWorkingDayOspGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} staticColumns={staticColumns} />
    </>
  );
};
