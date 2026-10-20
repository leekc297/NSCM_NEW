// SCP0100 Global_PSI_Report — TobeGen 생성 골격 (As-is SCP0100_Global_PSI_Report, Fact Pack Doc/asisfacts/screens/SCP0100)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';

import { GlobalPsiReportForm } from './components/GlobalPsiReportForm';
import { GlobalPsiReportGridDetail } from './components/GlobalPsiReportGridDetail';
import { GlobalPsiReportGridSearchLevel } from './components/GlobalPsiReportGridSearchLevel';
import { GlobalPsiReportGridSearchLevelDetail } from './components/GlobalPsiReportGridSearchLevelDetail';
import type { RESPONSE_SET } from './global-psi-report.constants';
import { MENU_ID, SHEETS } from './global-psi-report.constants';
import { useGlobalPsiReportStore } from './useGlobalPsiReportStore';

export const GlobalPsiReport = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridSearchLevelRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL, RESPONSE_SET.MAIN>>>();
  const gridFilterSearchLevelRef = useRef<FlexGridFilter>();
  const gridDetailRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL, RESPONSE_SET.MAIN>>>();
  const gridFilterDetailRef = useRef<FlexGridFilter>();
  const gridSearchLevelDetailRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.REPORT, RESPONSE_SET.MAIN>>>();
  const gridFilterSearchLevelDetailRef = useRef<FlexGridFilter>();

  const filters = useGlobalPsiReportStore(state => state.filters);
  const setFilters = useGlobalPsiReportStore(state => state.setFilters);
  const staticColumns = useGlobalPsiReportStore(state => state.staticColumns);
  const fetchStaticColumns = useGlobalPsiReportStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useGlobalPsiReportStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useGlobalPsiReportStore(state => state.setOpenSearchArea);

  // spdSearchLevel ← 시트 'SEARCH_LEVEL'. As-is 조회 SP: (Fact Pack endpoints 참조)
  const { data: dataSearchLevel } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_LEVEL,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdDetail ← 시트 'SEARCH_LEVEL_DETAIL'. As-is 조회 SP: (Fact Pack endpoints 참조)
  const { data: dataDetail } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_LEVEL_DETAIL,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // spdSearchLevelDetail ← 시트 'REPORT'. As-is 조회 SP: SCP0100_GET_PLAN_DATE
  const { data: dataSearchLevelDetail } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.REPORT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  // As-is 저장 SP 없음 — 조회 전용 화면 (useProcMutation 미사용)

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // AS-IS this.btnMeasure.Click → btnMeasure_Click (SCP0100_Global_PSI_Report.cs:1137)
  //   호출 엔드포인트: SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleMeasure = () => {
    // TODO(이식): As-is btnMeasure_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS this.btnColumn.Click → BtnColumn_Click (SCP0100_Global_PSI_Report.cs:1141)
  //   호출 엔드포인트: SCP.SCP0100_GET_SHEET_CALENDAR_3SPAN
  //   To-Be 패턴: onClick → handleXxx (SubTitle customButtons 또는 필드 아이콘)
  const handleColumn = () => {
    // TODO(이식): As-is BtnColumn_Click 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SCP0100_Global_PSI_Report.cs:1175 8줄)
    save: false, // AS-IS SaveButton 미정의
    insert: false, // AS-IS InsertButton 미정의
    delete: false, // AS-IS DeleteButton 미정의
    // excel: (생략 = 기본 활성) AS-IS ExcelButton SCP0100_Global_PSI_Report.cs:1183 33줄
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  // As-is 화면 버튼 → SubTitle customButtons (dmf0045 선례). 라벨은 LBL 코드, 동작은 위 핸들러
  const customButtons = [
    { label: t('LBL?????', '_Button1'), action: () => { /* TODO(이식): As-is usrButton1 Click — events.csv 에 핸들러 없음 */ } }, // AS-IS usrButton1
    { label: t('LBL00310', '_Measure'), action: handleMeasure }, // AS-IS btnMeasure
    { label: t('LBL00711', '_Column'), action: handleColumn }, // AS-IS btnColumn
  ];
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <GlobalPsiReportForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridSearchLevelRef}
        gridFilter={gridFilterSearchLevelRef}
        dataCount={dataSearchLevel?.o_rc?.length ?? 0}
        excelFileName='Global_PSI_Report'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
        customButtons={customButtons}
      />
      {/* As-is splitContainer1 (상/하 분할, SplitterDistance 기준 50%) */}
      <PanelGroup orientation='vertical'>
        <Panel defaultSize='50%' minSize='10%'>
          <GlobalPsiReportGridSearchLevel gridRef={gridSearchLevelRef} gridFilterRef={gridFilterSearchLevelRef} data={dataSearchLevel?.o_rc ?? []} staticColumns={staticColumns[SHEETS.SEARCH_LEVEL] ?? []} />
          <SubTitle menuId={MENU_ID} grid={gridDetailRef} gridFilter={gridFilterDetailRef} dataCount={dataDetail?.o_rc?.length ?? 0} title='SEARCH_LEVEL_DETAIL' useHotkey={false} />
          <GlobalPsiReportGridDetail gridRef={gridDetailRef} gridFilterRef={gridFilterDetailRef} data={dataDetail?.o_rc ?? []} staticColumns={staticColumns[SHEETS.SEARCH_LEVEL_DETAIL] ?? []} />
          <SubTitle menuId={MENU_ID} grid={gridSearchLevelDetailRef} gridFilter={gridFilterSearchLevelDetailRef} dataCount={dataSearchLevelDetail?.o_rc?.length ?? 0} title='REPORT' useHotkey={false} />
          <GlobalPsiReportGridSearchLevelDetail gridRef={gridSearchLevelDetailRef} gridFilterRef={gridFilterSearchLevelDetailRef} data={dataSearchLevelDetail?.o_rc ?? []} staticColumns={staticColumns[SHEETS.REPORT] ?? []} />
        </Panel>
      </PanelGroup>
    </>
  );
};
