import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { PivotEngine } from '@mescius/wijmo.olap';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import {
  MainTitle,
  ResultArea,
  saveTitleSet,
  SubTitle,
  type OlapPivotGridRef,
} from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DemandPlanWaterfallForm } from './components/DemandPlanWaterfallForm';
import { DemandPlanWaterfallGrid } from './components/DemandPlanWaterfallGrid';
import { OlapFieldRail, OlapGridMeta } from './components/olap-field-rail/OlapFieldRail';
import { OlapChartPane, type OlapChartType } from './components/OlapChartPane';
import {
  GUBUN,
  GUBUN_META,
  MENU_ID,
  PERIOD_LIMIT_YEARS,
  SHEETS,
} from './demand-plan-waterfall.constants';
import { useDemandPlanWaterfallStore } from './useDemandPlanWaterfallStore';

// DMF0035 Demand Plan Waterfall — AS-IS 3 UI(0035/0022/0051) 통합 조회 전용 리포트 (2026-08-06).
//   정본: Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md (+ Cascade_Filter 전수 md).
//   MSG 는 AS-IS 실문구 대사(#114) — MSG00137/00108/00164/00097 (통합분석 §2.F 실측).

export const DemandPlanWaterfall = ({ tabId, title }: PageProps<MENU_ID>) => {
  const olapRef = useRef<OlapPivotGridRef | null>(null);
  // SubTitle 연동용 — PivotGrid 는 FlexGrid 파생 (OlapPivotGridRef.grid 인스턴스 프록시)
  const gridRef = useRef<TFlexGrid | undefined>(undefined);
  // UM-07 — PivotGrid(FlexGrid 파생)에 FlexGridFilter 를 붙여 SubTitle Filter(F4) 가 산다 (Grid 가 마운트 시 채움)
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();
  const queryClient = useQueryClient();

  const filters = useDemandPlanWaterfallStore(state => state.filters);
  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useDemandPlanWaterfallStore(state => state.setSearchParams);
  const setFilters = useDemandPlanWaterfallStore(state => state.setFilters);
  const isOpenSearchArea = useDemandPlanWaterfallStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useDemandPlanWaterfallStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useDemandPlanWaterfallStore(state => state.fetchStaticColumns);
  // [E20260831-MEASURE] 공통 메저 선택 상태 (개별 selector — 객체 destructuring 금지 규약)
  const fetchStaticMeasures = useDemandPlanWaterfallStore(state => state.fetchStaticMeasures);
  const staticMeasures = useDemandPlanWaterfallStore(state => state.staticMeasures);
  const visibleMeasures = useDemandPlanWaterfallStore(state => state.visibleMeasures);
  const applyVisibleMeasures = useDemandPlanWaterfallStore(state => state.applyVisibleMeasures);
  const restoreSearchConditions = useDemandPlanWaterfallStore(
    state => state.restoreSearchConditions
  );
  const clearData = useDemandPlanWaterfallStore(state => state.clearData);
  const resetForBucket = useDemandPlanWaterfallStore(state => state.resetForBucket);

  const gubun = searchParams.gubun;

  // ⭐ UM-01 Division 기본 선택 (사용자 결정 2026-08-28): 세션 division 이 MyDivision 목록에 있으면 그것,
  //   없으면 목록 첫 행 (AS-IS .cs:420~423 `cboDivision.SelectedIndex = 1` = 첫 실 division 자동선택).
  //   빈 값일 때만 1회 채운다 — F6 복원값·사용자 선택은 덮지 않는다(2026-08-23 "자동 보정 없음"은 선택 후 재보정 금지).
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (myDivisions ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchParams({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [myDivisions, searchParams.divisionId, session.div, setSearchParams]);

  // UM-01 — Division 변경 = Grid 초기화 (#59 §1.4 / memory feedback_division_change_grid_reset).
  //   filters 를 비우면 3 GUBUN 쿼리가 전부 disabled 되어 데이터·타이틀이 비고, 다시 보려면 Search 를 눌러야 한다.
  //   조회 전용 화면 = CRUD reset 해당없음. 정적 컬럼은 divisionId deps effect 가 뒤따라 재fetch.
  const handleDivisionChange = () => {
    clearData();
  };

  // [E20260831-BUCKETRESET] BUCKET 변경 = 항상 GRID 초기화 (사용자 지시 2026-08-31 — 구 UM-08 경계 판정 폐기).
  //   AS-IS InitSpread 등가: 활성 GUBUN 메인 비움 + 타이틀 즉시 재조회(새 헤더). 재조회는 Search 버튼.
  const handleBucketChange = (_prev: string, next: string) => {
    resetForBucket(next);
  };

  // [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건 복원 (탭당 1회 — store initialized 가드).
  //   복원된 divisionId/gubun 은 아래 정적 컬럼 effect 의 deps 라 컬럼도 뒤따라 재fetch 된다.
  useEffect(() => {
    if (!session.userId) return;
    void restoreSearchConditions();
  }, [tabId, session.userId, restoreSearchConditions]);

  // GUBUN별 메인 시트 3본 — 활성 GUBUN 만 enabled
  const mktQuery = useTabProcQuery<MENU_ID, SHEETS.MKT_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.MKT_FCST,
    tabId,
    filters: filters[SHEETS.MKT_FCST],
    enabled: gubun === GUBUN.MKT_FCST && !!filters[SHEETS.MKT_FCST],
  });
  const salesQuery = useTabProcQuery<MENU_ID, SHEETS.SALES_PLAN>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_PLAN,
    tabId,
    filters: filters[SHEETS.SALES_PLAN],
    enabled: gubun === GUBUN.SALES_PLAN && !!filters[SHEETS.SALES_PLAN],
  });
  const bizQuery = useTabProcQuery<MENU_ID, SHEETS.BIZ_PLAN>({
    menuId: MENU_ID,
    sheetName: SHEETS.BIZ_PLAN,
    tabId,
    filters: filters[SHEETS.BIZ_PLAN],
    enabled: gubun === GUBUN.BIZ_PLAN && !!filters[SHEETS.BIZ_PLAN],
  });

  const active =
    gubun === GUBUN.MKT_FCST ? mktQuery : gubun === GUBUN.SALES_PLAN ? salesQuery : bizQuery;
  const activeRows = active.data?.o_rc1;
  const data = useMemo(
    () => (activeRows ?? []) as Record<string, string | number>[],
    [activeRows]
  );
  // ⭐ [E20260902-MEASDEPS] 메저 선택은 **서버 축(TITLESET_USER 'M')** 단일 출처 — 클라이언트 행 필터 ⛔.
  //   메인 SP 는 사용자 저장 메저를 base 로 **종속(파생) 메저를 서버에서 덧붙여** 반환한다:
  //     `PKG_DMF0035` L433~481 CUST_FCST → Immidiate/Planning_Forecast/Commercial_Agreement/Firm_Temp/
  //       Manumacturing_Material_Temp/Material_Temp/Backorder/CUST_FCST_EDI
  //     `PKG_DMF0035` L489~556 CUST_FCST(_ORG) → DM_MST_CUSTOMER_FCST.MEASURE / 'Customer Fcst[Org.]'
  //   이 종속 메저 코드들은 모달 목록의 원천(`SCM_MST_SHEET_MEASURE` VALID_YN='Y')에 **없거나 VALID_YN='N'**
  //   이라, 구 구현의 `vis.includes(MEASURE)` 필터가 종속 메저를 통째로 잘라냈다
  //   (사용자 신고 2026-09-02 "div 81 최초 조회는 나오는데 Measure 모달 저장 후 종속메저 사라짐" —
  //    선택을 바꾸지 않고 OK 만 눌러도 재현. AS-IS `DMF0035_MktFcstWaterfall.cs:1809` 은 팝업 OK 시
  //    `InitSpread()` 뿐이고 행 필터가 없다 = 서버가 선택+종속을 함께 내려주는 계약).
  //   → FE 는 SP 반환 measure 집합을 그대로 렌더한다. 정본 = DMF0003 `MktFcst.tsx:867~873` 동일 문구.
  //   `visibleMeasures` 는 모달 재진입 시 좌/우 복원 + 아래 **면제형 행 필터**의 입력으로 쓰인다.
  //
  // ⭐ [E20260902-MEASFILTEREXEMPT] 사용자 확정 2026-09-02 — "종속메저는 메저필터 적용 대상에서 제외(항상 표시)".
  //   필터를 **전면 제거**하면 건수 표시가 선택에 반응하지 않고(REQ:CHAT-20260831-W44 후퇴),
  //   **전면 적용**하면 종속메저가 잘린다(REQ:CHAT-20260902-W46 원인). 둘 다 아닌 **면제 규칙**을 쓴다:
  //     · 모달 목록(= SHEET_MEASURE VALID_YN='Y' 후보)에 있는 메저 → 선택 여부대로 필터
  //     · 모달 목록에 **없는** 메저(= SP 가 붙인 종속/파생) → 필터 면제, 항상 표시
  //   판정 원천은 `staticMeasures`(모달에 넘기는 바로 그 목록)라 모달과 축이 어긋날 수 없다.
  //   ⚠ staticMeasures 가 비면(fetch 실패) 전 메저가 '면제' 로 떨어져 필터가 no-op 이 된다 —
  //     메타 실패로 행이 사라지는 쪽보다 안전한 degrade (의도된 동작).
  const selectableMeasures = useMemo(
    () => new Set(staticMeasures.map(measure => measure.colNm)),
    [staticMeasures]
  );
  const visibleData = useMemo(() => {
    const vis = visibleMeasures[gubun];
    if (vis == null) return data;
    return data.filter(row => {
      const measure = String(row.MEASURE ?? '');
      if (!selectableMeasures.has(measure)) return true; // 종속메저 = 면제
      return vis.includes(measure);
    });
  }, [data, visibleMeasures, gubun, selectableMeasures]);
  const isFetching = active.isFetching;

  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    // [E20260831-METASHEET] 메타 조회 = AS-IS 시트명 + 종속 PROGRAM_ID (구 camel 시트명은 MKT/BIZ 0행 — Fields 에 DEFAULT 만 노출 실사고)
    void fetchStaticColumns({
      divisionId: searchParams.divisionId,
      sheetNm: GUBUN_META[gubun].sheetNm,
      programId: GUBUN_META[gubun].programId,
    });
    // [E20260831-MEASURE] 공통 메저 선택(AS-IS 0035/0022/0051 공통 기능) — SHEET_MEASURE 메타 동반 fetch
    void fetchStaticMeasures({
      divisionId: searchParams.divisionId,
      measureSheetNm: GUBUN_META[gubun].measureSheetNm,
      programId: GUBUN_META[gubun].programId,
    });
  }, [
    tabId,
    session.userId,
    searchParams.divisionId,
    gubun,
    fetchStaticColumns,
    fetchStaticMeasures,
  ]);

  // SubTitle 의 FlexGrid ref 를 OLAP 내부 그리드로 동기 (PivotGrid = FlexGrid 파생)
  useEffect(() => {
    gridRef.current = (olapRef.current?.grid as TFlexGrid | undefined) ?? undefined;
  });

  const handleSubmit = () => {
    if (!session.userId) return;

    // MSG00137 — "전 작업이 아직 실행 중입니다." (AS-IS blnWork 가드)
    if (isFetching) {
      void setAlert({
        type: 'alert',
        content: t('MSG00137', '_The previous task is still running.'),
      });
      return;
    }

    // MSG00097 — "권한을 가진 Division이 없습니다." (AS-IS .cs:1100)
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t('MSG00097', '_There is no Division with permission.'),
      });
      return;
    }

    const fromDt = dayjs(searchParams.startYyyymmdd, 'YYYYMMDD');
    const toDt = dayjs(searchParams.endYyyymmdd, 'YYYYMMDD');
    if (!fromDt.isValid() || !toDt.isValid()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00013', '_Please enter the required fields.'),
      });
      return;
    }

    // Version — [E20260831-VERREQ] 전 waterfall type 필수 (사용자 지시 2026-08-31 — 구 'MKT ''=CURRENT 비필수' 폐기.
    //   초기값·type 변경 시 기본값 = 'CURRENT'([E20260831-VERCUR]) 라 통상 통과, 사용자가 비운 경우만 차단).
    // 무엇이 빠졌는지 명시 — MSG00283 '버전을 선택하세요' (범용 MSG00013 은 원인 불명 혼선)
    if (!searchParams.version) {
      void setAlert({
        type: 'alert',
        content: t('MSG00283', '_Please select Version.'),
      });
      return;
    }

    // MSG00108 — "시작일자가 종료일자보다 늦을 수 없습니다."
    if (fromDt.isAfter(toDt)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_The start date cannot be later than the end date.'),
      });
      return;
    }

    // MSG00164 — 기간 상한 (MKT/SALES 3년, BIZ 10년 — AS-IS 실측). 초과 시 To 보정 후 중단
    const limitYears = PERIOD_LIMIT_YEARS[gubun];
    if (fromDt.add(limitYears, 'year').isBefore(toDt)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00164', `_The search period cannot exceed ${limitYears} years.`),
      });
      setSearchParams({ endYyyymmdd: fromDt.add(limitYears, 'year').format('YYYYMMDD') });
      return;
    }

    const changed = setFilters({ userId: session.userId });
    // 조건 불변 재조회 = 메인+TITLE 전 쿼리 재조회 — [tabId] prefix invalidate
    // (active.refetch 만 하면 TITLE 이 캐시 재사용 → SP 정정 후에도 옛 컬럼셋 표시. hook 계보:
    //  invalidateQueries([MENU_ID]) 는 메인 그리드 미매칭 — 키 prefix 는 tabId)
    if (!changed) void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  // 조회 전용 — CUD/업로드 숨김 (AS-IS F7/F8/F9 no-op, F2=MSG00109)
  //   [CHART/EXPORT 2026-08-27] Export = 공통 [Excel] 버튼 위치 그대로, 동작만 OLAP 내보내기
  //   (OlapPivotGrid.exportExcel — FlexGridXlsxConverter, 피벗 헤더 포함)로 교체. 조회 전(그리드 미마운트)엔 기본 동작.
  // Grid Layout 편집기 — [RAIL 2026-08-27] 팝업(OlapLayoutModal) → 좌측 분할 패널 → **우측 300px 도킹 레일**
  //   (디자인 핸드오프 1a). SubTitle 의 [Grid Layout] 버튼은 삭제(사용자 지시 2026-08-27) — 레일 헤더 [Hide ›] 와
  //   접힌 가장자리 [‹] 만으로 토글한다. 기본 = 열림(디자인 기준).
  const [showLayout, setShowLayout] = useState<boolean>(true);

  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
    // [E20260831-NOCOMMONFS] 공통 FILTER/SORT 기능 제외 — 버튼 숨김 (사용자 지시 2026-08-31).
    //   피벗 필터 축은 레일 Filters 영역이 담당(구 UM-07 F4=레일 열기 재해석은 폐기 — 레일은 [‹]/[Hide ›] 토글).
    filter: false,
    sort: false,
    ...(olapRef.current?.engine
      ? { excel: () => olapRef.current?.exportExcel('DemandPlanWaterfall') }
      : {}),
  };

  // [CHART 2026-08-27] 차트 분할 상태 — [E20260831-NOCHARTBTN] Chart 버튼 삭제(사용자 지시 2026-08-31):
  //   showChart 는 false 고정(토글 진입점 제거), OlapChartPane 코드는 보존(재도입 시 버튼만 복원).
  const [showChart] = useState<boolean>(false);
  const [chartType, setChartType] = useState<OlapChartType>(0);

  // ⭐ [E20260902-PIVOTCOUNT] 건수 표기 = **피벗 후 행수** (사용자 지시 2026-09-02).
  //   구 구현은 원천 행수(`visibleData.length` = SP O_RC1)를 표시했는데, OLAP 그리드는 `rowFields` 조합으로
  //   그룹핑하므로 **축에 없는 컬럼으로만 갈리는 원천 행은 한 행으로 병합**된다. 그래서 표기 건수가 그리드·
  //   Excel 행수보다 많아진다 (SALES div81 실사고: UI 1,150건 vs Excel 1,144행 = 병합 6행).
  //   이제 `OlapPivotGrid` 가 `engine.updatedView` 시점에 `pivotView.items.length` 를 올려주고, 그 값을
  //   SubTitle dataCount / OlapGridMeta rowCount 두 곳이 함께 쓴다(두 표기가 같은 원천 — W44 요구 유지).
  //   ⚠ 그리드 미마운트(조회 전·초기화 직후)에는 통지가 없으므로 0 으로 둔다.
  const [pivotRowCount, setPivotRowCount] = useState(0);
  useEffect(() => {
    if (data.length === 0) setPivotRowCount(0);
  }, [data]);
  // [E20260831-MEASURE] 공통 메저 선택 모달 (AS-IS 0035/0022/0051 공통 기능 — 정본 사용형 DMF0003, hook #132)
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ⭐ [E20260902-MEASDEPS] Measure 모달 OK — 정본 DMF0003 `MktFcst.tsx:1204~1226` 1:1.
  //   ① 그리드 비움: 이전 조회 rows 는 이전 메저 집합 기준이라 무효. `clearData()` 로 filters 를 비워
  //      3 GUBUN 쿼리를 disable 하고, `removeQueries([tabId])` 로 캐시까지 지운다.
  //      ⚠ removeQueries 필수 — queryKey 는 `buildTabQueryKey(tabId, sheet, action, filters)` 라
  //        동일 조건으로 다시 Search 하면 전역 staleTime=Infinity 캐시가 옛 rows 를 그대로 돌려준다.
  //      ⚠ 키 prefix 는 **tabId(UUID)** 다 — `invalidateQueries([MENU_ID])` 는 메인 그리드에 매칭되지 않는다.
  //   ② 서버 저장: 표시 메저만 sortOrderNo 1..n (titleSetApi 저장 계약 = 행 존재가 곧 표시).
  //      codes === null(전체 선택)이면 전 메저 코드를 그대로 저장한다 — 빈 배열 저장은 SP no-op(false).
  //   ③ 저장 성공 후 메저 메타 재fetch — 모달 재진입 목록/기본값을 서버 기준으로 다시 맞춘다.
  //   재조회는 Search 버튼 (division/bucket 변경 초기화와 동일 정책 — 자동 재조회 없음).
  const handleApplyMeasures = (codes: string[] | null) => {
    clearData();
    queryClient.removeQueries({ queryKey: [tabId] });
    // 모달 재진입 시 좌/우 복원 상태 (행 필터 아님 — 위 [E20260902-MEASDEPS] 주석 참조)
    applyVisibleMeasures(gubun, codes);

    const meta = GUBUN_META[gubun];
    const selected = codes ?? staticMeasures.map(measure => measure.colNm);
    void saveTitleSet({
      menuId: meta.programId,
      sheetName: meta.titleSetSheetNm,
      // Measure 개인화 — 폭/색은 대상이 아니라 미전달(빈 값으로 저장됨).
      columnType: 'M',
      rows: selected.map((name, index) => ({ name, sortOrderNo: index + 1 })),
    }).then(ok => {
      if (!ok) {
        void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
        return;
      }
      if (!session.userId || !searchParams.divisionId) return;
      void fetchStaticMeasures({
        divisionId: searchParams.divisionId,
        measureSheetNm: meta.measureSheetNm,
        programId: meta.programId,
      });
    });
  };
  const customButtons = [
    // #120 아이콘 순서 규약(환율→ColumnSet→Measure) — 본 화면은 Measure 만 해당. BTN 권한 배선(MEASURE_SELECT)은
    // 사내/클라우드 메타 미등재 상태라 무게이트 노출(사용자 지시 2026-08-31) — 배선 등재 시 hasButton 게이트 전환.
    {
      label: t('LBL00712', '_Measure'),
      title: t('LBL00712', '_Measure'),
      action: () => setOpenMeasureSelect(true),
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  // 패널이 쓰는 PivotEngine — 그리드는 조회 후에야 마운트되므로 ref 값을 state 로 승격해 패널이 따라 렌더되게 한다.
  //   그리드 마운트/교체 시점 = 데이터·GUBUN 변경 직후이므로 그 deps 로 검사한다(동일 인스턴스면 setState 생략).
  const [engine, setEngine] = useState<PivotEngine | null>(null);
  useEffect(() => {
    const next = olapRef.current?.engine ?? null;
    if (next !== engine) setEngine(next);
  }, [engine, data, gubun, showLayout]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <DemandPlanWaterfallForm
        onSubmit={handleSubmit}
        onDivisionChange={handleDivisionChange}
        onBucketChange={handleBucketChange}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={pivotRowCount}
        excelFileName='DemandPlanWaterfall'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      {/* [RAIL 2026-08-27] 디자인 핸드오프 "1a Docked field rail" — 좌 = 그리드 팬(메타 스트립 + OLAP 그리드,
          flex:1) / 우 = 300px 도킹 레일(Hide › 로 28px 가장자리까지 접힘, 그리드가 남은 폭 차지). */}
      <ResultArea.Group direction='horizontal' gap={0}>
        {/* 그리드 팬 — Chart 토글 시 세로 분할(그리드 6 : 차트 4, 드래그 조절). key 로 split 재구성 */}
        <ResultArea.Group key={showChart ? 'chart' : 'grid'} split={showChart} minSize={20}>
          <ResultArea flex={6}>
            <OlapGridMeta
              engine={engine}
              rowTotals={searchParams.rowTotals}
              rowCount={pivotRowCount}
            />
            <DemandPlanWaterfallGrid
              olapRef={olapRef}
              gridFilterRef={gridFilterRef}
              gubun={gubun}
              data={visibleData}
              onPivotRowCountChange={setPivotRowCount}
              tabId={tabId}
              onBucketChange={handleBucketChange}
            />
          </ResultArea>
          {showChart && (
            <OlapChartPane
              engine={engine}
              chartType={chartType}
              onChartTypeChange={setChartType}
              flex={4}
            />
          )}
        </ResultArea.Group>
        <OlapFieldRail
          engine={engine}
          rowTotals={searchParams.rowTotals}
          onRowTotalsChange={mode => setSearchParams({ rowTotals: mode })}
          open={showLayout}
          onToggleOpen={setShowLayout}
        />
      </ResultArea.Group>

      {/* [E20260831-MEASURE] 공통 메저 선택 — master 공용 정본 모달(hook #132, 사본 ⛔).
          ⭐ [E20260902-MEASDEPS] OK = **서버 영구 저장(titleset 'M') + 그리드 비움** (정본 DMF0003
             `MktFcst.tsx:1204~1226` 1:1). AS-IS `DM0002_TitleSetForm_Popup.cs:425` SaveTitleSet →
             `SCM0002_SET_TITLESET_POPUP` 과 동일 계약이며, 종속 메저는 다음 조회 때 SP 가 붙여 내려준다.
          ⚠ 저장 엔드포인트는 공용 `POST /admin/menu/{mnuId}/titleset` (BE 고정 매핑) —
             `MenuServiceImpl.saveTitleSet` javadoc 대로 `SCM_ADM_MNU_BTN_MPG_M` 등록을 요구하지 않는다
             (화면별 `{menuId}/titleSet/SAVE/call-proc` 경로였다면 403). 따라서 메타 배선 작업 불요.
          ⚠ menuId 는 **GUBUN 별 종속 PROGRAM_ID**(DMF0035/DMF0022/DMF0051) — BE 가 path mnuId 를 그대로
             P_PROGRAM_ID 로 넘기므로 MENU_ID 고정 전달 시 SALES/BIZ 가 저장은 되고 조회에 안 잡힌다. */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures[gubun]}
        onApply={handleApplyMeasures}
      />
    </>
  );
};
