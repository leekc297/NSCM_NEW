import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { PivotEngine } from '@mescius/wijmo.olap';
import { useEffect, useMemo, useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, ResultArea, SubTitle, type OlapPivotGridRef } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DemandPlanWaterfallForm } from './components/DemandPlanWaterfallForm';
import { DemandPlanWaterfallGrid } from './components/DemandPlanWaterfallGrid';
import { OlapFieldRail, OlapGridMeta } from './components/olap-field-rail/OlapFieldRail';
import { OlapChartPane, type OlapChartType } from './components/OlapChartPane';
import {
  GUBUN,
  GUBUN_SHEET,
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
  // OLAP 판은 FlexGridFilter 미사용 — SubTitle 계약용 빈 ref
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
  const restoreSearchConditions = useDemandPlanWaterfallStore(
    state => state.restoreSearchConditions
  );

  const gubun = searchParams.gubun;

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
  const isFetching = active.isFetching;

  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    void fetchStaticColumns({
      divisionId: searchParams.divisionId,
      sheetNm: GUBUN_SHEET[gubun].main,
    });
  }, [tabId, session.userId, searchParams.divisionId, gubun, fetchStaticColumns]);

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

    // Version — SALES/BIZ 필수 (AS-IS checkRequiredOfSearch 마크. MKT 는 ''=CURRENT).
    // 무엇이 빠졌는지 명시 — MSG00283 '버전을 선택하세요' (범용 MSG00013 은 원인 불명 혼선)
    if (gubun !== GUBUN.MKT_FCST && !searchParams.version) {
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
  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
    ...(olapRef.current?.engine
      ? { excel: () => olapRef.current?.exportExcel('DemandPlanWaterfall') }
      : {}),
  };

  // [CHART 2026-08-27] 공통 버튼 열 우측 customButtons 슬롯 — 그리드 아래 PivotChart 분할(6:4, 드래그 조절) 토글
  const [showChart, setShowChart] = useState<boolean>(false);
  const [chartType, setChartType] = useState<OlapChartType>(0);
  const customButtons = [
    {
      label: t('', 'Chart'),
      title: t('', showChart ? 'Hide Chart' : 'Show Chart'),
      action: () => setShowChart(v => !v),
      buttonLabel: t('', 'Chart'),
    },
  ];

  // Grid Layout 편집기 — [RAIL 2026-08-27] 팝업(OlapLayoutModal) → 좌측 분할 패널 → **우측 300px 도킹 레일**
  //   (디자인 핸드오프 1a). SubTitle 의 [Grid Layout] 버튼은 삭제(사용자 지시 2026-08-27) — 레일 헤더 [Hide ›] 와
  //   접힌 가장자리 [‹] 만으로 토글한다. 기본 = 열림(디자인 기준).
  const [showLayout, setShowLayout] = useState<boolean>(true);

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
      <DemandPlanWaterfallForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data.length}
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
            <OlapGridMeta engine={engine} rowTotals={searchParams.rowTotals} rowCount={data.length} />
            <DemandPlanWaterfallGrid olapRef={olapRef} gubun={gubun} data={data} tabId={tabId} />
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
    </>
  );
};
