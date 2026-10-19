// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import { Dmf0052Form } from './components/Dmf0052Form';
import { Dmf0052GridData } from './components/Dmf0052GridData';
import { Dmf0052GridSummary } from './components/Dmf0052GridSummary';
import { Dmf0052GridSummaryPjt } from './components/Dmf0052GridSummaryPjt';
import { Dmf0052GridSummaryStatus } from './components/Dmf0052GridSummaryStatus';
import { GSCMDataModal } from './components/modals/GSCMDataModal';
import type { RESPONSE_SET } from './dmf0052.constants';
import { MENU_ID, SHEETS } from './dmf0052.constants';
import { useDmf0052Store } from './useDmf0052Store';

export const Dmf0052 = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridSummaryRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY, RESPONSE_SET.MAIN>>>();
  const gridFilterSummaryRef = useRef<FlexGridFilter>();
  const gridSummaryPjtRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_PJT, RESPONSE_SET.MAIN>>>();
  const gridFilterSummaryPjtRef = useRef<FlexGridFilter>();
  const gridSummaryStatusRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY_STATUS, RESPONSE_SET.MAIN>>>();
  const gridFilterSummaryStatusRef = useRef<FlexGridFilter>();
  const gridDataRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.ERP_DATA, RESPONSE_SET.MAIN>>>();
  const gridFilterDataRef = useRef<FlexGridFilter>();

  const filters = useDmf0052Store(state => state.filters);
  const setFilters = useDmf0052Store(state => state.setFilters);
  const staticColumns = useDmf0052Store(state => state.staticColumns);
  const fetchStaticColumns = useDmf0052Store(state => state.fetchStaticColumns);
  const isOpenSearchArea = useDmf0052Store(state => state.isOpenSearchArea);
  const setOpenSearchArea = useDmf0052Store(state => state.setOpenSearchArea);
  const openGSCMDataModal = useDmf0052Store(state => state.openGSCMDataModal);
  const setOpenGSCMDataModal = useDmf0052Store(state => state.setOpenGSCMDataModal);
  const activeSheetData = useDmf0052Store(state => state.activeSheetData);
  const setActiveSheetData = useDmf0052Store(state => state.setActiveSheetData);
  const selectedPjtKey = useDmf0052Store(state => state.selectedPjtKey);
  const selectedDataRow = useDmf0052Store(state => state.selectedDataRow);
  const setSelectedDataRow = useDmf0052Store(state => state.setSelectedDataRow);
  const dataRefreshKey = useDmf0052Store(state => state.dataRefreshKey);
  const bumpDataRefreshKey = useDmf0052Store(state => state.bumpDataRefreshKey);

  // spdSummary ← 시트 'SUMMARY'. As-is 조회 SP: DMF0052_GET_SUMMARY_DATA (FindData_Main, DMF0052_EDISummary.cs:312)
  const { data: dataSummary } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdSummaryPJT ← 시트 'Summary Pjt'. As-is 조회 SP: DMF0052_GET_PJT_DATA (FindData_Pjt, DMF0052_EDISummary.cs:355)
  const { data: dataSummaryPjt } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY_PJT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdSummaryStatus ← 시트 'Summary Status'. As-is 조회 SP: DMF0052_GET_STATUS_DATA (FindData_Status, DMF0052_EDISummary.cs:418)
  const { data: dataSummaryStatus } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY_STATUS,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdData ← 시트 'ERP Data' / 'GSCM Data' (activeSheet 전환).
  //   As-is: activeSheetData === 'GSCM Data' → FindData_GSCMData → DMF0052_GET_DETAIL_DATA (DMF0052_EDISummary.cs:460)
  //          activeSheetData === 'ERP Data'  → FindData_ERPData  → DMF0052_GET_ERP_DATA    (DMF0052_EDISummary.cs:529)
  //   AS-IS 트리거: spdPjt_CellDoubleClick (프로젝트 선택 후 상세) · BtnRefresh_Click (GSCM Data 재조회)
  //   dataRefreshKey 는 Refresh 클릭마다 nonce 를 올려 queryKey 변경 → refetch (sales-plan 선례의 removeQueries 대체 — 동일 조건 재조회).
  const dataFilters = useMemo(() => {
    if (!filters || !selectedPjtKey) return undefined;
    return {
      ...filters,
      projectCode: selectedPjtKey.projectCode,
      senderCode: selectedPjtKey.senderCode,
      refreshKey: String(dataRefreshKey),
    };
  }, [filters, selectedPjtKey, dataRefreshKey]);
  const { data: dataData } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: activeSheetData,
    tabId,
    filters: dataFilters,
    enabled: dataFilters !== undefined,
  });
  // As-is 저장 SP 없음 — 조회 전용 화면 (useProcMutation 미사용)

  // As-is this.Load (Form_Load → CreateSpread → GetSpdTitle) : 메타 컬럼 + 저장된 조회조건
  //   DMF0052_EDISummary.cs:123 (.ctor Load) → DMF0052_EDISummary.cs:696 GetSpdTitle
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // AS-IS this.btnRefresh.Click → BtnRefresh_Click (DMF0052_EDISummary.cs:218) → FindData_GSCMData
  //   To-Be: activeSheetData 를 'GSCM Data' 로 고정하고 dataRefreshKey 를 올려 refetch (same filters, new queryKey).
  const handleRefresh = () => {
    setActiveSheetData(SHEETS.GSCM_DATA);
    bumpDataRefreshKey();
  };

  // AS-IS 빈 override(기능 비활성으로 해석 → false): InsertButton(DMF0052_EDISummary.cs:245 3줄 빈 본문), DeleteButton(DMF0052_EDISummary.cs:249 3줄 빈 본문), SaveButton(DMF0052_EDISummary.cs:257 3줄 빈 본문), EditButton(DMF0052_EDISummary.cs:253 3줄 빈 본문)
  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (DMF0052_EDISummary.cs:221 23줄)
    save: false, // AS-IS SaveButton 미정의
    insert: false, // AS-IS InsertButton 미정의
    delete: false, // AS-IS DeleteButton 미정의
    excel: false, // AS-IS ExcelButton 미정의
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  // As-is 화면 버튼 → SubTitle customButtons (dmf0045 선례). 라벨은 LBL 코드, 동작은 위 핸들러
  //   AS-IS btnRefresh (BaseForm UsrButton, DMF0052_EDISummary.Designer.cs:218)
  const customButtons = [
    { label: t('LBL00106', '_Refresh'), action: handleRefresh },
  ];
  // AS-IS spdData.ActiveSheetChanging (DMF0052_EDISummary.Designer.cs:657) — FarPoint 다중 시트 전환 이벤트를
  //   To-Be 에서는 시트 전환 토글 버튼으로 흡수(단일 DataGrid + store.activeSheetData 구독).
  const dataCustomButtons = [
    { label: t('LBL00061', '_ERP Data'), action: () => setActiveSheetData(SHEETS.ERP_DATA) },
    { label: t('LBL00062', '_GSCM Data'), action: () => setActiveSheetData(SHEETS.GSCM_DATA) },
  ];
  // AS-IS spdData.CellDoubleClick → DMF0052_GSCMDataPopup (DialogResult/Tag) — 선택 행을 소비 후 닫는다.
  //   현 화면은 팝업 반환값을 그리드에 반영할 요구가 분석 자료에 없으므로 선택 행만 store 에서 비우고 모달을 닫는다.
  const handleModalSelect = (_rows: Record<string, unknown>[]) => {
    setSelectedDataRow(undefined);
    setOpenGSCMDataModal(false);
  };
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <Dmf0052Form />
      <SubTitle
        menuId={MENU_ID}
        grid={gridSummaryRef}
        gridFilter={gridFilterSummaryRef}
        dataCount={dataSummary?.o_rc?.length ?? 0}
        excelFileName='EDISummary'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
        customButtons={customButtons}
      />
      {/* As-is splitContainer1 (상/하 분할, SplitterDistance 기준 47%/53%) */}
      <PanelGroup orientation='vertical'>
        <Panel defaultSize='47%' minSize='10%'>
          {/* As-is splitContainer2 (좌/우 분할, SplitterDistance 기준 26%/74%) */}
          <PanelGroup orientation='horizontal'>
            <Panel defaultSize='26%' minSize='10%'>
              <Dmf0052GridSummary gridRef={gridSummaryRef} gridFilterRef={gridFilterSummaryRef} data={dataSummary?.o_rc ?? []} staticColumns={staticColumns[SHEETS.SUMMARY] ?? []} />
            </Panel>
            <PanelSeparator />
            <Panel defaultSize='74%' minSize='10%'>
              <SubTitle menuId={MENU_ID} grid={gridSummaryPjtRef} gridFilter={gridFilterSummaryPjtRef} dataCount={dataSummaryPjt?.o_rc?.length ?? 0} title='Summary Pjt' useHotkey={false} />
              <Dmf0052GridSummaryPjt gridRef={gridSummaryPjtRef} gridFilterRef={gridFilterSummaryPjtRef} data={dataSummaryPjt?.o_rc ?? []} staticColumns={staticColumns[SHEETS.SUMMARY_PJT] ?? []} />
            </Panel>
          </PanelGroup>
        </Panel>
        <PanelSeparator />
        <Panel defaultSize='53%' minSize='10%'>
          {/* As-is splitContainer3 (좌/우 분할, SplitterDistance 기준 26%/74%) */}
          <PanelGroup orientation='horizontal'>
            <Panel defaultSize='26%' minSize='10%'>
              <SubTitle menuId={MENU_ID} grid={gridSummaryStatusRef} gridFilter={gridFilterSummaryStatusRef} dataCount={dataSummaryStatus?.o_rc?.length ?? 0} title='Summary Status' useHotkey={false} />
              <Dmf0052GridSummaryStatus gridRef={gridSummaryStatusRef} gridFilterRef={gridFilterSummaryStatusRef} data={dataSummaryStatus?.o_rc ?? []} staticColumns={staticColumns[SHEETS.SUMMARY_STATUS] ?? []} />
            </Panel>
            <PanelSeparator />
            <Panel defaultSize='74%' minSize='10%'>
              <SubTitle menuId={MENU_ID} grid={gridDataRef} gridFilter={gridFilterDataRef} dataCount={dataData?.o_rc?.length ?? 0} title={activeSheetData === SHEETS.GSCM_DATA ? 'GSCM Data' : 'ERP Data'} useHotkey={false} customButtons={dataCustomButtons} />
              <Dmf0052GridData gridRef={gridDataRef} gridFilterRef={gridFilterDataRef} data={dataData?.o_rc ?? []} staticColumns={staticColumns[activeSheetData] ?? []} />
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
      {/* AS-IS 팝업 DMF0052_GSCMDataPopup (DMF0052_GSCMDataPopup.cs) — spdData_CellDoubleClick 트리거(DMF0052_EDISummary.Designer.cs:658) */}
      <GSCMDataModal
        open={openGSCMDataModal}
        modalClose={() => setOpenGSCMDataModal(false)}
        onSelect={handleModalSelect}
        preSearchParams={filters as Record<string, string> | undefined}
        selectedRow={selectedDataRow}
        staticColumns={staticColumns[SHEETS.EDI_SUMMARY_GSCM_DATA_POPUP] ?? []}
      />
    </>
  );
};
