// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

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

  // spdSummary ← 시트 'SUMMARY'. As-is 조회 SP: DMF0052_GET_SUMMARY_DATA
  const { data: dataSummary } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdSummaryPJT ← 시트 'Summary Pjt'. As-is 조회 SP: DMF0052_GET_PJT_DATA
  const { data: dataSummaryPjt } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY_PJT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdSummaryStatus ← 시트 'Summary Status'. As-is 조회 SP: DMF0052_GET_STATUS_DATA
  const { data: dataSummaryStatus } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUMMARY_STATUS,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdData ← 시트 'ERP Data' / 'GSCM Data' (activeSheet 전환). As-is 조회 SP: (Fact Pack endpoints 참조)
  const { data: dataData } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: activeSheetData,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  // As-is 저장 SP 없음 — 조회 전용 화면 (useProcMutation 미사용)

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // AS-IS this.btnRefresh.Click → BtnRefresh_Click (DMF0052_EDISummary.Designer.cs:218)
  //   호출 엔드포인트: DM.DMF0052_GET_DETAIL_DATA, DM.DMF0052_GET_SPREAD_TITLE
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleRefresh = () => {
    // TODO(이식): As-is BtnRefresh_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
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
  const customButtons = [
    { label: t('LBL?????', '_Refresh'), action: handleRefresh }, // AS-IS btnRefresh
  ];
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
              <SubTitle menuId={MENU_ID} grid={gridDataRef} gridFilter={gridFilterDataRef} dataCount={dataData?.o_rc?.length ?? 0} title='ERP Data' useHotkey={false} />
              <Dmf0052GridData gridRef={gridDataRef} gridFilterRef={gridFilterDataRef} data={dataData?.o_rc ?? []} staticColumns={staticColumns[activeSheetData] ?? []} />
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
      {/* AS-IS 팝업 DMF0052_GSCMDataPopup — 열기: 해당 이벤트 핸들러에서 setOpenGSCMDataModal(true) (TODO(이식): 트리거·파라미터·반환 처리) */}
      <GSCMDataModal open={openGSCMDataModal} modalClose={() => setOpenGSCMDataModal(false)} />
    </>
  );
};
