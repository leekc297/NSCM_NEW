import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { GlobalPsiReportForm } from './components/GlobalPsiReportForm';
import { GlobalPsiReportGrid } from './components/GlobalPsiReportGrid';
import { GlobalPsiReportModals } from './components/GlobalPsiReportModals';
import {
  AUX_SHEET,
  LBL,
  MENU_ID,
  MSG,
  POPUP_TARGET,
  SEARCH_MODE,
  SEARCH_LEVEL_CODE,
  SHEETS,
  type PopupTarget,
} from './global-psi-report.constants';
import type { ReportRow, SearchLevelRow, SearchLevelDetailRow } from './global-psi-report.types';
import { divisionParam, useGlobalPsiReportStore } from './useGlobalPsiReportStore';
import { isStartAfterPlan } from './utils/globalPsiReportCalendar';

// AS-IS GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report(2,056줄) — 조회조건 패널 + 3개 FpSpread 오버레이
//   (spdDetail/spdSearchLevel/spdSearchLevelDetail) read-only Global PSI 리포트. 저장/입력 없음.
//   설계: .atlas/gscm-design/SCP0100/design/00~03(DB 실측 PASS). 상세 매핑: __asis-mapping__.md.
//   버튼 판정(design 01 §2 B1/B2): FindButton(SEARCH)/ExcelButton(EXCEL) 실동작 2종.
//     - search = handleSearch (조회는 무해 → 항상 허용)
//     - insert/save/delete/manual/upload = false (미배선 — read-only 리포트, 표준버튼 hasButton 미노출)
//   NO-OP 4종(ChkCellQty/ChkAS/CboGraphType/CboPlanType)·usrButton1 dead 는 Form 에서 재현(design 01 §2).
export const GlobalPsiReport = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // SCM0002 팝업 대상 — btnItemId(MaterialByDivisionModal — 카탈로그 메1) / btnProject(ProjectByDivisionModal) (design 02 §4.6).
  const [popupTarget, setPopupTarget] = useState<PopupTarget | null>(null);

  const sc = useGlobalPsiReportStore(s => s.searchCondition);
  const setSearchCondition = useGlobalPsiReportStore(s => s.setSearchCondition);
  const filters = useGlobalPsiReportStore(s => s.filters);
  const setFilter = useGlobalPsiReportStore(s => s.setFilter);
  const searchMode = useGlobalPsiReportStore(s => s.searchMode);
  const unitScaleIndex = useGlobalPsiReportStore(s => s.unitScaleIndex);
  const openSearchArea = useGlobalPsiReportStore(s => s.openSearchArea);
  const setOpenSearchArea = useGlobalPsiReportStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useGlobalPsiReportStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useGlobalPsiReportStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useGlobalPsiReportStore(s => s.restoreSearchConditions);
  const initialized = useGlobalPsiReportStore(s => s.initialized);
  const staticColumns = useGlobalPsiReportStore(s => s.staticColumns);

  // 활성 그리드 시트 판정 (design 01 R1~R3): DETAIL=REPORT / SearchLevel+CELL_GROUP_DETAIL=상세집계 / else 집계.
  const activeSheet = useMemo<SHEETS>(() => {
    if (searchMode === SEARCH_MODE.DETAIL) return SHEETS.REPORT;
    if (sc.searchLevel === SEARCH_LEVEL_CODE.CELL_GROUP_DETAIL) return SHEETS.SEARCH_LEVEL_DETAIL;
    return SHEETS.SEARCH_LEVEL;
  }, [searchMode, sc.searchLevel]);

  const reportQuery = useTabProcQuery<MENU_ID, SHEETS.REPORT>({
    menuId: MENU_ID,
    sheetName: SHEETS.REPORT,
    tabId,
    filters: filters[SHEETS.REPORT],
    enabled: !!filters[SHEETS.REPORT],
  });
  const levelQuery = useTabProcQuery<MENU_ID, SHEETS.SEARCH_LEVEL>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_LEVEL,
    tabId,
    filters: filters[SHEETS.SEARCH_LEVEL],
    enabled: !!filters[SHEETS.SEARCH_LEVEL],
  });
  const levelDetailQuery = useTabProcQuery<MENU_ID, SHEETS.SEARCH_LEVEL_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_LEVEL_DETAIL,
    tabId,
    filters: filters[SHEETS.SEARCH_LEVEL_DETAIL],
    enabled: !!filters[SHEETS.SEARCH_LEVEL_DETAIL],
  });

  // GET 응답 grid PIVOT 데이터 = O_RC1(표준 key 'o_rc1'). O_RESULT_CURSOR(상태봉투)는 무시(design 03 §4).
  const reportRows = useMemo<ReportRow[]>(
    () => (reportQuery.data as { o_rc1?: ReportRow[] })?.o_rc1 ?? [],
    [reportQuery.data]
  );
  const levelRows = useMemo<SearchLevelRow[]>(
    () => (levelQuery.data as { o_rc1?: SearchLevelRow[] })?.o_rc1 ?? [],
    [levelQuery.data]
  );
  const levelDetailRows = useMemo<SearchLevelDetailRow[]>(
    () => (levelDetailQuery.data as { o_rc1?: SearchLevelDetailRow[] })?.o_rc1 ?? [],
    [levelDetailQuery.data]
  );

  // 활성 시트 데이터/고정컬럼 — 그리드에 1시트만 전달(design 01 R1~R3 오버레이). 나머지 미조회.
  //   행 타입 = ResponseData(procedures.d.ts Base fallback = WijmoRowItem) — DataGrid itemsSource 계약 그대로(캐스팅 없음, #73).
  const activeRows = useMemo<WijmoRowItem[]>(
    () =>
      activeSheet === SHEETS.REPORT
        ? reportRows
        : activeSheet === SHEETS.SEARCH_LEVEL_DETAIL
          ? levelDetailRows
          : levelRows,
    [activeSheet, reportRows, levelRows, levelDetailRows]
  );
  const activeColumns = staticColumns[activeSheet];

  // 동적 pivot 기간칼럼 3단 헤더 원천 — GET_SHEET_CALENDAR_3SPAN(design 03 §2). 조회기간(from~to)으로 조회.
  //   기간 미입력이면 미조회(enabled) → 그리드가 데이터 행 union 으로 폴백(globalPsiReportColumns).
  //   필수: filters 는 useMemo 로 참조 고정 — 리터럴을 넘기면 useTabProcQuery 가 재조회로 오판해 무한 루프.
  //   키 = 사내 PROC_M COL_NM(startYyyymmdd/endYyyymmdd, proc_params.csv) — BE 는 COL_NM 으로 매핑하므로 다르면 NULL 전달(DoD B22).
  //   AS-IS SCP0100_Global_PSI_Report.cs:1327-1328 p_start_yyyymmdd/p_end_yyyymmdd.
  const calendarFilters = useMemo(
    () => ({ startYyyymmdd: sc.fromYyyymmdd, endYyyymmdd: sc.toYyyymmdd }),
    [sc.fromYyyymmdd, sc.toYyyymmdd]
  );
  const calendarQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.CALENDAR,
    tabId,
    filters: calendarFilters,
    enabled: !!sc.fromYyyymmdd && !!sc.toYyyymmdd,
  });
  const calendarRows = useMemo<Record<string, unknown>[]>(
    () => (calendarQuery.data as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [],
    [calendarQuery.data]
  );

  // 현재 노출 그리드 행수(SubTitle dataCount) — 활성 시트 기준.
  const activeRowCount = activeRows.length;

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 3시트 + SCM_MST_SHEET_MEASURE 36행) — mount 1회 fetch.
  //   F6 저장 조회조건 복원도 mount 1회(conditionsRestored 가드). 새로고침 시 새 store → 재복원(scp-bom 파리티).
  useEffect(() => {
    void restoreSearchConditions();
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 시작일 > Plan 시작일 검증(DCalendar_ValueChanged .cs:2006~2018). 1차 판정은 Form 의 Period 변경 시점(AS-IS 와
  //   같은 ValueChanged 타이밍)이고, 여기서는 Plan Date 변경·조건 복원 뒤 남은 위반을 조회 직전에 한 번 더 막는다.
  //   위반이면 alert(MSG01186, 사내 SCM_ADM_MSG_M 역조회) + 시작일을 Plan 시작일로 되돌린다(plan_start:end 복원 등가).
  const validatePlanDateRange = (): boolean => {
    if (!isStartAfterPlan(sc.fromYyyymmdd, sc.planStartYyyymmdd)) return true;
    void useMessageStore.getState().setAlert({
      type: 'alert',
      content: t(MSG.PLAN_DATE_RANGE, 'Begin Date is early or equal to Plan Date.'),
    });
    setSearchCondition({ fromYyyymmdd: sc.planStartYyyymmdd.trim() });
    return false;
  };

  // 조회 — 조회 시 메타 refetch(admin 동적 속성관리 — mount + Search 시마다). 필수값 가드는 Form 에서.
  const handleSearch = () => {
    if (!validatePlanDateRange()) return;
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(design 01 B1 FindButton=SEARCH).
    search: handleSearch,
    // read-only 리포트 — 저장/입력/삭제/수동/업로드 미배선(design 01 §2). ExcelButton(EXCEL)은 SubTitle 내장.
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 개인화 커스텀버튼 2종 — btnColumn(ColumnLayoutModal) / btnMeasure(MeasureSelectModal) (design 02 §4.6 B3/B4).
  //   표준 7버튼 밖 팝업이라 SubTitle hotkey 공통집합과 별개 — MNU_BTN(COLUMN_SETUP/MEASURE_SELECT) 등록 대상.
  //   권한 hasButton 조건부 노출(admin 동적 속성관리 §2 체크3). icon-only(SalesPlan 선례 동일).
  const customButtons = [
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t(LBL.COLUMN, 'Column Setting'),
            title: t(LBL.COLUMN, 'Column Setting'),
            action: () => setPopupTarget(POPUP_TARGET.COLUMN),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t(LBL.MEASURE, 'Measure'),
            title: t(LBL.MEASURE, 'Measure'),
            action: () => setPopupTarget(POPUP_TARGET.MEASURE),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {/* 영역2 조회조건 Form — 16조건 + 팝업 4(design 02 §5.1). tabId 는 Site/PlanDate/Calendar 보조 SP 쿼리키. */}
      <GlobalPsiReportForm
        tabId={tabId}
        onSearch={handleSearch}
        onItemSearch={() => setPopupTarget(POPUP_TARGET.ITEM)}
        onProjectSearch={() => setPopupTarget(POPUP_TARGET.PROJECT)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={activeRowCount}
        excelFileName='GlobalPsiReport'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* 영역3 그리드 — 활성 1시트(고정 admin 컬럼 + 동적 M_/W_ PIVOT 3단 헤더). read-only. Bucket 토글로
          M_/W_ visible 전환(design 03 §2.5). measure BG 8그룹·plan_start 헤더색·Unit(Qty) 로컬 배율은
          GlobalPsiReportGrid formatItem 에서 재현(design 03 §3-B / design 02 §2.5). */}
      <GlobalPsiReportGrid
        rows={activeRows}
        adminColumns={activeColumns}
        calendarRows={calendarRows}
        searchLevel={sc.searchLevel}
        isDetail={searchMode === SEARCH_MODE.DETAIL}
        bucket={sc.bucket}
        planStartYyyymmdd={sc.planStartYyyymmdd}
        unitScaleIndex={unitScaleIndex}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onFocus={() => undefined}
      />

      {/* Model/Nickname 팝업 — 조회조건 카탈로그 'Global PSI New' Model/Nickname = 메1(Material by Division Popup,
          xlsx '팝업 비교' "Model/Material 팝업양식은 메1(SCP)") · 자매 global-psi(SCP0031) 동일 MaterialByDivisionModal.
          반환 ItemID(1번째 인자)를 txtItemId 에 반영(AS-IS BtnItemId_Click .cs:1943-1947). division = 조회조건 Div.(AS-IS _division,
          ALL→''). scpModuleType = 호출 화면 ID(SCP0100 은 SP 의 Operation Group 특수 분기 대상 아님 → 기본 경로). */}
      <MaterialByDivisionModal
        open={popupTarget === POPUP_TARGET.ITEM}
        modalClose={() => setPopupTarget(null)}
        setSelectedValue={items => setSearchCondition({ itemId: items })}
        preSearchParams={{
          divisionId: divisionParam(sc.divisionId),
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />

      {/* SCM0002 Project-by-Division 팝업 — btnProject 반환 Project(1번째 인자)를 txtProject 에 반영(design 02 §4.6).
          preSearchParams 는 팝업 전용 MENU_ID(MODAL_PROJECT_BY_DIVISION) ProcRequest 계약이라 화면 필드로 직접
          못 맞춘다 → PriceBatchInputModal 선례처럼 division 스코프만 싣고 as never 로 캐스팅한다. */}
      <ProjectByDivisionModal
        open={popupTarget === POPUP_TARGET.PROJECT}
        modalClose={() => setPopupTarget(null)}
        setSelectedValue={projects => setSearchCondition({ project: projects })}
        preSearchParams={
          {
            divisionId: divisionParam(sc.divisionId),
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: sc.project,
            etc: 'N',
          } as never
        }
        callFromCell={false}
      />

      {/* 개인화 팝업 2종 — btnColumn(ColumnLayoutModal) / btnMeasure(MeasureSelectModal) (design 02 §4.6 B3/B4).
          activeSheet(활성 시트)로 sheetName(admin SHEET_NAME) 3점 일치. read-only 리포트라 저장 후 메타 refetch 로만
          반영(로컬 즉시적용 machinery 불필요) — 컴포넌트 분리(진입 slim). */}
      <GlobalPsiReportModals
        activeSheet={activeSheet}
        divisionId={divisionParam(sc.divisionId)}
        openColumn={popupTarget === POPUP_TARGET.COLUMN}
        openMeasure={popupTarget === POPUP_TARGET.MEASURE}
        onClose={() => setPopupTarget(null)}
      />
    </>
  );
};
