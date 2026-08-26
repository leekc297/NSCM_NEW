import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle, type OlapPivotGridRef } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DemandPlanWaterfallForm } from './components/DemandPlanWaterfallForm';
import { DemandPlanWaterfallGrid } from './components/DemandPlanWaterfallGrid';
import { OlapLayoutModal } from './components/OlapLayoutModal';
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

  const gubun = searchParams.gubun;

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
  const data = (active.data?.o_rc1 ?? []) as Record<string, string | number>[];
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
  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  // Grid Layout 편집기 (PivotPanel + Subtotal 드롭다운) — 텍스트 버튼 (명칭 사용자 확정 2026-08-06).
  //   ⚠ IcGridColumnSetup 아이콘 사용 금지 (Column Setting 전용 용도)
  const [openLayoutModal, setOpenLayoutModal] = useState<boolean>(false);
  const customButtons = [
    {
      label: t('', 'Grid Layout'),
      title: t('', 'Grid Layout'),
      action: () => setOpenLayoutModal(true),
      buttonLabel: t('', 'Grid Layout'),
    },
  ];

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
      <DemandPlanWaterfallGrid olapRef={olapRef} gubun={gubun} data={data} tabId={tabId} />
      <OlapLayoutModal
        open={openLayoutModal}
        modalClose={() => setOpenLayoutModal(false)}
        olapRef={olapRef}
        rowTotals={searchParams.rowTotals}
        onRowTotalsChange={mode => setSearchParams({ rowTotals: mode })}
      />
    </>
  );
};
