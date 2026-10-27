// SSP0015 ShipmentPSI — TobeGen 생성 골격 (As-is SSP0015_ShipmentPSI, Fact Pack Doc/asisfacts/screens/SSP0015)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import { ShipmentPSICommentsModal } from './components/modals/ShipmentPSICommentsModal';
import { ShipmentPlanMobilityItForm } from './components/ShipmentPlanMobilityItForm';
import { ShipmentPlanMobilityItGridDetail } from './components/ShipmentPlanMobilityItGridDetail';
import { ShipmentPlanMobilityItGridMain } from './components/ShipmentPlanMobilityItGridMain';
import type { RESPONSE_SET } from './shipment-plan-mobility-it.constants';
import { MENU_ID, SHEETS } from './shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from './useShipmentPlanMobilityItStore';

export const ShipmentPlanMobilityIt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridMainRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.WH_IN_PLAN_DETAIL, RESPONSE_SET.MAIN>>>();
  const gridFilterMainRef = useRef<FlexGridFilter>();
  const gridDetailRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.HOLD_STOCK_DETAIL, RESPONSE_SET.MAIN>>>();
  const gridFilterDetailRef = useRef<FlexGridFilter>();

  const filters = useShipmentPlanMobilityItStore(state => state.filters);
  const setFilters = useShipmentPlanMobilityItStore(state => state.setFilters);
  const staticColumns = useShipmentPlanMobilityItStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentPlanMobilityItStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useShipmentPlanMobilityItStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentPlanMobilityItStore(state => state.setOpenSearchArea);
  const openShipmentPSICommentsModal = useShipmentPlanMobilityItStore(state => state.openShipmentPSICommentsModal);
  const setOpenShipmentPSICommentsModal = useShipmentPlanMobilityItStore(state => state.setOpenShipmentPSICommentsModal);
  const activeSheetDetail = useShipmentPlanMobilityItStore(state => state.activeSheetDetail);
  const { saveWithValidation } = useSaveWithValidation();

  // spdMain ← 시트 'WH In Plan Detail'. As-is 조회 SP: (Fact Pack endpoints 참조)
  const { data: dataMain } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.WH_IN_PLAN_DETAIL,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdDetail ← 시트 'Hold stock Detail' / 'Hold stock' / 'MES Stock Detail' / 'SCS Stock Detail' / 'Shipment Confirm Detail' / 'Shipment PSI(IT & Mobile)' / 'Shipment PSI(Mobility & IT)' / 'Shipment PSI(Packer)' / 'Shipment Request Detail' / 'Shipment Result' / 'Stock Detail' / 'Stock Location Detail' / 'W/H stock' / 'W/H stock Detail' (activeSheet 전환). As-is 조회 SP: DM0003_GET_BUCKET_TYPE_CODE, SSP0015_GET_SHIPMENT_PSI_PACKER_PAST, SSP0015_GET_SHIPMENT_PSI_PACKER, SSP0015_GET_SHIPMENT_PSI, SSP0002_GET_NERP_CODE, SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER, SSP0015_GET_WH_STOCK, SSP0015_GET_MES_STOCK, SSP0015_GET_BLOCK_STOCK, SSP0015_GET_STOCK_LOCATION_DETAIL, SSP0015_GET_SCS_STOCK, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0015_GET_SHIPMENT_PSI_COMMENTS, SSP0015_GET_SHIPMENT_RESULT_PACKER, SSP0015_GET_SHIPMENT_RESULT, SCM0001_GET_SCP_DAY_PERIOD
  const { data: dataDetail } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: activeSheetDetail,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // As-is 저장: SSP0015_SAVE_SHIPMENT_PSI, SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, SSP0015_SAVE_BLOCK_STOCK_DATA, SSP0015_SAVE_MES_STOCK, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER, SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING, SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.WH_IN_PLAN_DETAIL,
    tabId,
  });

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = dataMain?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns[SHEETS.WH_IN_PLAN_DETAIL] ?? [], mutate);
  };

  // AS-IS this.btnMeasure.Click → btnMeasure_Click (SSP0015_ShipmentPSI.cs:1164)
  //   호출 엔드포인트: SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleMeasure = () => {
    // TODO(이식): As-is btnMeasure_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS this.btnItemID2.Click → BtnItemID2_Click (SSP0015_ShipmentPSI.cs:1168)
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleItemID2 = () => {
    // TODO(이식): As-is BtnItemID2_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS this.btnSearch.Click → BtnSearch_Click (SSP0015_ShipmentPSI.cs:1169)
  //   호출 엔드포인트: SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN, SSP.SSP0015_GET_SHIPMENT_RESULT, SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS, SSP.SSP0015_GET_STOCK_LOCATION_DETAIL, SSP.SSP0002_GET_NERP_CODE, SSP.SSP0015_GET_SCS_STOCK, SSP.SSP0015_GET_MES_STOCK, SSP.SSP0015_GET_BLOCK_STOCK, SSP.SSP0015_GET_WH_STOCK, SSP.SSP0026_GET_REQUEST_DETAIL_PACK, SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER, SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleSearch = () => {
    // TODO(이식): As-is BtnSearch_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS this.btnRequestor.Click → BtnRequestor_Click (SSP0015_ShipmentPSI.cs:1170)
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleRequestor = () => {
    // TODO(이식): As-is BtnRequestor_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS dsdm.Changed → shtDetail_Change (SSP0015_ShipmentPSI.cs:1190)
  //   To-Be 패턴: onChange
  const handleshtDetailChange = () => {
    // TODO(이식): As-is shtDetail_Change 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS InsertButton SSP0015_ShipmentPSI.cs:1711 4줄 → 행 추가
  const handleInsertRow = () => {
    // TODO(이식): As-is InsertButton/InsertRow 본문 — 기본값·잠금 컬럼(LockColumn)·cellType 은 그리드 컬럼 메타(_inputEditType/_ctrlType)로
    if (!gridMainRef.current) return;
    GridAction.addRow(gridMainRef.current, { /* TODO(이식): As-is InsertRow 기본값 (예: DIVISION_ID: divisionId, VALID_YN: 'Y') */ }, 'above');
  };
  // AS-IS DeleteButton SSP0015_ShipmentPSI.cs:1716 18줄 → 선택 행 삭제
  const handleDeleteRow = () => {
    // TODO(이식): As-is DeleteButton 본문 (삭제 가능 조건·확인 메시지 MSG 코드)
    if (!gridMainRef.current) return;
    GridAction.removeRow(gridMainRef.current);
  };
  // AS-IS EditButton SSP0015_ShipmentPSI.cs:1735 254줄 — hotkeyConfig 미지원: customButtons 의 편집 토글(IsReadOnly) 로 — TODO(이식)

  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SSP0015_ShipmentPSI.cs:1687 23줄)
    save: onSave, // AS-IS SaveButton SSP0015_ShipmentPSI.cs:2069 21줄
    insert: handleInsertRow, // AS-IS InsertButton SSP0015_ShipmentPSI.cs:1711 4줄
    delete: handleDeleteRow, // AS-IS DeleteButton SSP0015_ShipmentPSI.cs:1716 18줄
    excel: false, // AS-IS ExcelButton 미정의
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  // As-is 화면 버튼 → SubTitle customButtons (dmf0045 선례). 라벨은 LBL 코드, 동작은 위 핸들러
  const customButtons = [
    { label: t('LBL?????', '_Button1'), action: () => { /* TODO(이식): As-is usrButton1 Click — events.csv 에 핸들러 없음 */ } }, // AS-IS usrButton1
    { label: t('LBL00001', '_Div*'), action: handleMeasure }, // AS-IS btnMeasure
    { label: t('LBL01108', '_Requestor'), action: handleRequestor }, // AS-IS btnRequestor
    { label: t('LBL?????', '_Item ID2'), action: handleItemID2 }, // AS-IS btnItemID2
  ];
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ShipmentPlanMobilityItForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridMainRef}
        gridFilter={gridFilterMainRef}
        dataCount={dataMain?.o_rc?.length ?? 0}
        excelFileName='ShipmentPSI'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
        customButtons={customButtons}
      />
      {/* As-is splitContainer1 (상/하 분할, SplitterDistance 기준 53%/47%) */}
      <PanelGroup orientation='vertical'>
        <Panel defaultSize='53%' minSize='10%'>
          <ShipmentPlanMobilityItGridMain gridRef={gridMainRef} gridFilterRef={gridFilterMainRef} data={dataMain?.o_rc ?? []} staticColumns={staticColumns[SHEETS.WH_IN_PLAN_DETAIL] ?? []} />
        </Panel>
        <PanelSeparator />
        <Panel defaultSize='47%' minSize='10%'>
          <SubTitle menuId={MENU_ID} grid={gridDetailRef} gridFilter={gridFilterDetailRef} dataCount={dataDetail?.o_rc?.length ?? 0} title='Hold stock Detail' useHotkey={false} />
          <ShipmentPlanMobilityItGridDetail gridRef={gridDetailRef} gridFilterRef={gridFilterDetailRef} data={dataDetail?.o_rc ?? []} staticColumns={staticColumns[activeSheetDetail] ?? []} />
        </Panel>
      </PanelGroup>
      {/* AS-IS 팝업 SSP0015_ShipmentPSICommentsPopup — 열기: 해당 이벤트 핸들러에서 setOpenShipmentPSICommentsModal(true) (TODO(이식): 트리거·파라미터·반환 처리) */}
      <ShipmentPSICommentsModal open={openShipmentPSICommentsModal} modalClose={() => setOpenShipmentPSICommentsModal(false)} />
    </>
  );
};
