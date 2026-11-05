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
  normalizeDivision,
  POPUP_TARGET,
  SEARCH_MODE,
  SEARCH_LEVEL_CODE,
  SHEETS,
  type PopupTarget,
} from './global-psi-report.constants';
import type { ReportRow, SearchLevelRow, SearchLevelDetailRow } from './global-psi-report.types';
import { useGlobalPsiReportStore } from './useGlobalPsiReportStore';
import { applySearchLevelVisibility } from './utils/globalPsiReportColumns';

// AS-IS GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report(2,056줄) — 조회조건 패널 + 3개 FpSpread 오버레이
//   (spdDetail/spdSearchLevel/spdSearchLevelDetail) read-only Global PSI 리포트. 저장/입력 없음.
//   설계: .atlas/gscm-design/SCP0100/design/00~03(DB 실측 PASS). 상세 매핑: __asis-mapping__.md.
//   버튼 판정(design 01 §2 B1/B2): FindButton(SEARCH)/ExcelButton(EXCEL) 실동작 2종.
//     - search = handleSearch (조회는 무해 → 항상 허용)
//     - insert/save/delete = 사용자 지시(2026-10-14)로 노출(no-op, 기능 미구현). AS-IS read-only 대비 의도적 추가.
//     - manual/upload = false (요청 범위 밖, 계속 미노출)
//   NO-OP 4종(ChkCellQty/ChkAS/CboGraphType/CboPlanType)·usrButton1 dead 는 Form 에서 재현(design 01 §2).
export const GlobalPsiReport = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // SCM0002 팝업 대상 — btnItemId(ItemByDivisionModal) / btnProject(ProjectByDivisionModal) (design 02 §4.6).
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
  const activeRows = useMemo<Record<string, unknown>[]>(() => {
    const rows =
      activeSheet === SHEETS.REPORT
        ? reportRows
        : activeSheet === SHEETS.SEARCH_LEVEL_DETAIL
          ? levelDetailRows
          : levelRows;
    return rows as unknown as Record<string, unknown>[];
  }, [activeSheet, reportRows, levelRows, levelDetailRows]);
  // design 01 §2 R5 (AS-IS SetLayout cs:1488~1543) — Search Level 모드에서 searchLevel 별 PRODUCT_LEVEL1/2/3
  //   컬럼 show/hide. Detail(REPORT) 모드는 사용자정의 컬럼 기준이라 토글하지 않는다(AS-IS !_is_detail).
  //   01→03/FE 미이관분 복원(2026-10-16 감사). searchLevel 변경 시 useMemo 가 재계산 → 그리드 컬럼 재구성.
  const activeColumns = useMemo(
    () =>
      activeSheet === SHEETS.REPORT
        ? staticColumns[activeSheet]
        : applySearchLevelVisibility(staticColumns[activeSheet], sc.searchLevel),
    [staticColumns, activeSheet, sc.searchLevel]
  );

  // 동적 pivot 기간칼럼 3단 헤더 원천 — GET_SHEET_CALENDAR_3SPAN(design 03 §2). 조회기간(from~to)으로 조회.
  //   기간 미입력이면 미조회(enabled) → 그리드가 데이터 행 union 으로 폴백(globalPsiReportColumns).
  //   필수: filters 는 useMemo 로 참조 고정 — 리터럴을 넘기면 useTabProcQuery 가 재조회로 오판해 무한 루프.
  // 파라미터명은 BE 변환규칙(camelCase → P_ + UPPER_SNAKE)에 맞춰 startYyyymmdd/endYyyymmdd 로 보낸다.
  //   (pStartYyyymmdd 로 보내면 P_P_START_YYYYMMDD 로 변환돼 실제 P_START_YYYYMMDD 가 NULL → SP 가 o_rc1 공란
  //   반환 → 피벗 컬럼이 데이터 폴백에만 의존해 최초 오픈 시 안 뜸. 2026-10-15 실측·수정. 카탈로그 canonical 과 동일.)
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

  // 조회 시작일 > Plan 시작일 검증(design 02 §4.4 cs:2006~2018) — 위반이면 alert + range 를 plan_start:end 로
  //   되돌린다. YYYYMMDD 문자열은 사전식 비교가 대소 비교와 일치. 둘 중 하나라도 미입력이면 검증 skip.
  //   메시지: AS-IS 가 카탈로그 미사용 한국어 하드코딩(cs:2014 GMessageBox 문자열 리터럴)이라 TO-BE 도 AS-IS
  //   원문 그대로 하드코딩한다. 다국어 DB 선례가 없는 AS-IS 하드코딩 메시지의 등가 재현(사용자 지시 2026-10-19).
  const validatePlanDateRange = (): boolean => {
    const from = sc.fromYyyymmdd.trim();
    const plan = sc.planStartYyyymmdd.trim();
    if (!from || !plan || from <= plan) return true;
    void useMessageStore.getState().setAlert({
      type: 'alert',
      content: '[조회 시작일] Plan Date 이전으로 설정해야 합니다.',
    });
    // range 되돌림 — 시작일을 Plan 시작일로 맞춘다(AS-IS plan_start:end 복원 등가).
    setSearchCondition({ fromYyyymmdd: plan });
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
    // Insert/Delete/Save — 해당 화면에 기능·버튼 권한 없음(read-only 리포트) → 전부 미노출(사용자 지시 2026-10-23).
    //   false = SubTitle 미렌더. (2026-10-14 의 no-op 노출 지시는 폐기됨.)
    insert: false,
    save: false,
    delete: false,
    // Manual/Upload 는 요청 범위 밖 — 계속 미노출(read-only).
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
        // Plan Date(planStartYyyymmdd)는 'yyyymmdd' 로 끝나 공통 EXCLUDED_DATE_PARAM 에 걸려 Period(from/to)와
        //   함께 저장 제외되지만, 자유 날짜가 아니라 콤보 선택값이라 F6 저장/복원 대상이다 → opt-in(사용자 지시
        //   2026-10-30, ShipmentPlanSemi 동일 패턴). Period(from/toYyyymmdd)는 제외 유지 — Plan Date 변경 시
        //   Form effect 가 재시드하므로 복원 불요. 복원은 store restore 가 makeInitSearch allowlist 로 자동 처리.
        conditionIncludeKeys={['planStartYyyymmdd']}
        customButtons={customButtons}
      />

      {/* 영역3 그리드 — 활성 1시트(고정 admin 컬럼 + 동적 M_/W_ PIVOT 3단 헤더). read-only. Bucket 토글로
          M_/W_ visible 전환(design 03 §2.5). measure BG 8그룹·plan_start 헤더색·Unit(Qty) 로컬 배율은
          GlobalPsiReportGrid formatItem 에서 재현(design 03 §3-B / design 02 §2.5). */}
      <GlobalPsiReportGrid
        rows={activeRows}
        adminColumns={activeColumns}
        calendarRows={calendarRows}
        bucket={sc.bucket}
        planStartYyyymmdd={sc.planStartYyyymmdd}
        unitScaleIndex={unitScaleIndex}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onFocus={() => undefined}
      />

      {/* Model/Nick Name 팝업 — SCP0100.md 조회조건 #4 비고 지정 컴포넌트 = MaterialByDivisionModal(COM0013).
          #4 유형 '텍스트/다중' → multiCheckbox(체크 다중선택, setSelectedValue 가 Material Code 를 ',' 결합 반환)
          + 메인 SP P_ITEM_ID FN_SPLITSTRING 다건. Division 다중 전환에 맞춰 multiDivision(호출값 CSV 미러 표시).
          divisionId 는 ALL 센티널 규약: 빈 선택/'ALL' 이면 'ALL' 을 넘겨야 모달 조회가 돈다(enabled !!divisionId,
          SP P_DIVISION_ID='ALL' 전체 분기 — [[material-by-division-modal-all-sentinel]]). CSV 는 SP REGEXP_SUBSTR split. */}
      <MaterialByDivisionModal
        open={popupTarget === POPUP_TARGET.ITEM}
        modalClose={() => setPopupTarget(null)}
        multiCheckbox
        multiDivision
        setSelectedValue={items => setSearchCondition({ itemId: String(items ?? '') })}
        preSearchParams={{
          divisionId: sc.divisionId || 'ALL',
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />

      {/* Project 팝업 — SCP0100.md 조회조건 #3 비고 지정 컴포넌트 = ProjectByDivisionModal(COM0005).
          #3 유형 '다중' — multiCheckbox(체크 다중선택, setSelectedValue 가 Project Code 를 ',' 결합 CSV 반환)로
          전환(2026-10-16 사용자 지시). 메인 SP P_PROJECT 가 CSV 다건을 받도록 SP 쪽을 별도 수정 예정
          (WW/MM DATAONLY 의 VARIOUS_KEY LIKE 를 FN_SPLITSTRING 토큰별 OR LIKE 로 — 아래 보고 참조).
          Model/Nick Name(MaterialByDivisionModal) 다중 전환과 동형. store 는 CSV 를 그대로 P_PROJECT 로 전달.
          divisionId ALL 센티널 동일(빈값→'ALL'). 반환 ProjectCode(CSV)를 project 에 반영. */}
      <ProjectByDivisionModal
        open={popupTarget === POPUP_TARGET.PROJECT}
        modalClose={() => setPopupTarget(null)}
        callFromCell={false}
        multiCheckbox
        setSelectedValue={projects => setSearchCondition({ project: String(projects ?? '') })}
        preSearchParams={{
          deptId: 'ALL',
          divisionId: sc.divisionId || 'ALL',
          endCustomer: 'ALL',
          etc: '',
          projectCode: sc.project,
          salesSite: 'ALL',
        }}
      />

      {/* 개인화 팝업 2종 — btnColumn(ColumnLayoutModal) / btnMeasure(MeasureSelectModal) (design 02 §4.6 B3/B4).
          activeSheet(활성 시트)로 sheetName(admin SHEET_NAME) 3점 일치. read-only 리포트라 저장 후 메타 refetch 로만
          반영(로컬 즉시적용 machinery 불필요) — 컴포넌트 분리(진입 slim). */}
      <GlobalPsiReportModals
        activeSheet={activeSheet}
        // ALL→'' 정규화 — ColumnLayoutModal 자체 조회(PR_GET_SHEET_COLUMN_LIST/titleSet)가 공통 메타를 받도록(메타 fetch 와 동일 규약).
        divisionId={normalizeDivision(sc.divisionId)}
        openColumn={popupTarget === POPUP_TARGET.COLUMN}
        openMeasure={popupTarget === POPUP_TARGET.MEASURE}
        onClose={() => setPopupTarget(null)}
      />
    </>
  );
};
