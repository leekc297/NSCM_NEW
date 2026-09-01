import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, MainTitle, SubTitle, toColumnLayoutSettings } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CustFcstWaterfallForm } from './components/CustFcstWaterfallForm';
import { CustFcstWaterfallGrid } from './components/CustFcstWaterfallGrid';
import { MENU_ID, MSG, PERIOD_LIMIT_YEARS, SHEETS } from './cust-fcst-waterfall.constants';
import type { SpreadTitleRow, WaterfallRow } from './cust-fcst-waterfall.types';
import { useCustFcstWaterfallStore } from './useCustFcstWaterfallStore';
import { saveTitleSet } from './utils/cust-fcst-waterfall.api';

// DMF0053 Customer FCST Waterfall — 읽기 전용 Waterfall 조회 리포트 (신규 생성 2026-08-27).
//   AS-IS: GSCM.DM.Forms.UIL\Plan\DMF0053_CustFcstWaterfall.cs 1,822행 (Insert/Delete/Save 주석
//   L577/582/596 · EditButton=MSG00109 L591 · 조회 후 전열 잠금 L786) — CUD 진입점 전부 미노출.
//   정본 분석: Doc/화면분석서/DMF0053_CustFcstWaterfall_주요이벤트_상세분석.md (E01~E23).

export const CustFcstWaterfall = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<TFlexGrid<WaterfallRow> | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();
  const queryClient = useQueryClient();

  const filters = useCustFcstWaterfallStore(state => state.filters);
  const searchParams = useCustFcstWaterfallStore(state => state.searchParams);
  const setSearchParams = useCustFcstWaterfallStore(state => state.setSearchParams);
  const setFilters = useCustFcstWaterfallStore(state => state.setFilters);
  const isOpenSearchArea = useCustFcstWaterfallStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustFcstWaterfallStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useCustFcstWaterfallStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCustFcstWaterfallStore(state => state.fetchStaticMeasures);
  const staticColumns = useCustFcstWaterfallStore(state => state.staticColumns);
  const staticMeasures = useCustFcstWaterfallStore(state => state.staticMeasures);
  const applyColumnLayout = useCustFcstWaterfallStore(state => state.applyColumnLayout);
  const clearData = useCustFcstWaterfallStore(state => state.clearData);

  const [columnModalOpen, setColumnModalOpen] = useState<boolean>(false);
  const [measureModalOpen, setMeasureModalOpen] = useState<boolean>(false);

  const mainQuery = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const titleQuery = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const data = (mainQuery.data?.o_rc1 ?? []) as WaterfallRow[];
  const spreadTitle = (titleQuery.data?.o_rc1 ?? []) as SpreadTitleRow[];

  // [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건 복원 (탭당 1회 — store initialized 가드).
  //   복원된 divisionId 는 아래 정적 컬럼 effect 의 deps 라 컬럼·Measure 도 뒤따라 재fetch 된다.
  const restoreSearchConditions = useCustFcstWaterfallStore(
    state => state.restoreSearchConditions
  );
  useEffect(() => {
    if (!session.userId) return;
    void restoreSearchConditions();
  }, [tabId, session.userId, restoreSearchConditions]);

  // 정적 컬럼·Measure — 서버 직접 비교 (#113): division 변경 시 재fetch (SHEET_NAME='CUST Fcst Waterfall')
  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    void fetchStaticColumns({ divisionId: searchParams.divisionId });
    void fetchStaticMeasures({ divisionId: searchParams.divisionId });
  }, [tabId, session.userId, searchParams.divisionId, fetchStaticColumns, fetchStaticMeasures]);

  // Column Setting 모달 재진입 복원/Default — 현재 grid 메타 (개인화는 titleSet 저장·재조회로 복원)
  const columnLayoutSettings = useMemo(() => toColumnLayoutSettings(staticColumns), [staticColumns]);

  // ── 조회 (AS-IS FindData L662~924 — A-01~A-05) ──
  const handleSubmit = () => {
    if (!session.userId) return;

    // A-01 (MSG00097) — Division 필수
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_REQUIRED, '_Please select Division.') });
      return;
    }

    const fromDt = dayjs(searchParams.startYyyymmdd, 'YYYYMMDD');
    const toDt = dayjs(searchParams.endYyyymmdd, 'YYYYMMDD');
    const fromCd = dayjs(searchParams.fromCreateYyyymmdd, 'YYYYMMDD');
    const toCd = dayjs(searchParams.toCreateYyyymmdd, 'YYYYMMDD');
    if (!fromDt.isValid() || !toDt.isValid() || !fromCd.isValid() || !toCd.isValid()) {
      void setAlert({ type: 'alert', content: t('MSG00013', '_Please enter the required fields.') });
      return;
    }

    // A-02 (MSG00108) — Period 역전
    if (fromDt.isAfter(toDt)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_INVALID, '_Invalid period.') });
      return;
    }

    // A-03 (MSG00164) — Period 3년 초과: 알림 + 종료일 자동 보정 후 중단 (AS-IS L692~699 보정까지 파리티)
    if (fromDt.add(PERIOD_LIMIT_YEARS, 'year').isBefore(toDt)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_LIMIT, '_The period is too long.') });
      setSearchParams({ endYyyymmdd: fromDt.add(PERIOD_LIMIT_YEARS, 'year').format('YYYYMMDD') });
      return;
    }

    // A-04 (MSG00108) — Input Date 역전
    if (fromCd.isAfter(toCd)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_INVALID, '_Invalid period.') });
      return;
    }

    // A-05 (MSG00164) — Input Date 3년 초과: 보정 후 중단 (AS-IS L709~716)
    if (fromCd.add(PERIOD_LIMIT_YEARS, 'year').isBefore(toCd)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_LIMIT, '_The period is too long.') });
      setSearchParams({ toCreateYyyymmdd: fromCd.add(PERIOD_LIMIT_YEARS, 'year').format('YYYYMMDD') });
      return;
    }

    const changed = setFilters({ userId: session.userId });
    // 조건 불변 재조회 = 메인+TITLE 전 쿼리 재조회 — [tabId] prefix invalidate (DMF0035/DMF0040 계보)
    if (!changed) void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  // 조회 전용 — CUD/업로드 미노출 (AS-IS Insert/Delete/Save 주석·EditButton=MSG00109)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  // AS-IS btnColumn(L1326 — Column Show)/btnMeasure(L1338) — hook #120 순서: ColumnSet → Measure
  const customButtons = [
    {
      label: t('LBL00605', 'Column Setting'),
      title: t('LBL00605', 'Column Setting'),
      action: () => setColumnModalOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
    {
      label: t('LBL00712', '_Measure'),
      title: t('LBL00712', '_Measure'),
      action: () => setMeasureModalOpen(true),
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
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
      <CustFcstWaterfallForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data.length}
        excelFileName='CustFcstWaterfall'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <CustFcstWaterfallGrid gridRef={gridRef} data={data} spreadTitle={spreadTitle} />

      {/* Column 설정 (AS-IS btnColumn L1326 — PROGRAM_ID='DMF0053', titleSet 'C'. 공용 ColumnLayoutModal) */}
      <ColumnLayoutModal
        open={columnModalOpen}
        modalClose={() => setColumnModalOpen(false)}
        menuId={MENU_ID}
        sheetName='CUST Fcst Waterfall'
        columnType='C'
        divisionId={searchParams.divisionId}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutSettings}
        onSave={settings => {
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet(
            'C',
            visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          );
          // UC-03 / hook #132 §2-2 — 설정 저장 = 기존 조회 데이터 Reset (그리드 비움, Search 재조회)
          clearData();
        }}
      />

      {/* Measure 설정 (AS-IS btnMeasure L1338 — master 공용 정본. PROGRAM_ID='DMF0053' 독립 축) */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          );
          clearData(); // UC-03 동일
        }}
      />
    </>
  );
};
