import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, MainTitle, SubTitle, toColumnLayoutSettings } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MktFcstComparisonForm } from './components/MktFcstComparisonForm';
import { MktFcstComparisonGrid } from './components/MktFcstComparisonGrid';
import {
  isBucketResetBoundary,
  MENU_ID,
  MSG,
  PERIOD_LIMIT_YEARS,
  SHEETS,
} from './mkt-fcst-comparison.constants';
import type { ComparisonRow, SpreadTitleRow } from './mkt-fcst-comparison.types';
import { useMktFcstComparisonStore } from './useMktFcstComparisonStore';
import { saveTitleSet } from './utils/mkt-fcst-comparison.api';

// DMF0040 MKT FCST Comparison — 읽기 전용 버전(최대 2) 비교 Waterfall 리포트 (신규 생성 2026-08-26).
//   AS-IS: GSCM.DM.Forms.UIL\Plan\DMF0040_MktFcst_Comparison.cs 1,875행 (Insert/Delete/Save 빈 구현
//   L578/583/597 · EditButton=MSG00109 L588 · 조회 후 전열 잠금 L760) — CUD 진입점 전부 미노출.
//   정본 분석: Doc/화면분석서/DMF0040_MktFcstComparison_주요이벤트_상세분석.md (E01~E22).

export const MktFcstComparison = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<TFlexGrid<ComparisonRow> | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();
  const queryClient = useQueryClient();

  const filters = useMktFcstComparisonStore(state => state.filters);
  const searchParams = useMktFcstComparisonStore(state => state.searchParams);
  const setSearchParams = useMktFcstComparisonStore(state => state.setSearchParams);
  const setFilters = useMktFcstComparisonStore(state => state.setFilters);
  const isOpenSearchArea = useMktFcstComparisonStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMktFcstComparisonStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useMktFcstComparisonStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useMktFcstComparisonStore(state => state.fetchStaticMeasures);
  const staticColumns = useMktFcstComparisonStore(state => state.staticColumns);
  const originalStaticColumns = useMktFcstComparisonStore(state => state.originalStaticColumns);
  const staticMeasures = useMktFcstComparisonStore(state => state.staticMeasures);
  const applyColumnLayout = useMktFcstComparisonStore(state => state.applyColumnLayout);
  const clearData = useMktFcstComparisonStore(state => state.clearData);
  const resetForBucket = useMktFcstComparisonStore(state => state.resetForBucket);

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

  const data = (mainQuery.data?.o_rc1 ?? []) as ComparisonRow[];
  const spreadTitle = (titleQuery.data?.o_rc1 ?? []) as SpreadTitleRow[];

  // [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건 복원 (탭당 1회 — store initialized 가드).
  //   복원된 divisionId 는 아래 정적 컬럼 effect 의 deps 라 컬럼·Measure 도 뒤따라 재fetch 된다.
  const restoreSearchConditions = useMktFcstComparisonStore(state => state.restoreSearchConditions);
  useEffect(() => {
    if (!session.userId) return;
    void restoreSearchConditions();
  }, [tabId, session.userId, restoreSearchConditions]);

  // ⭐ UM-01 Division 기본 선택 (사용자 결정 2026-08-28): 세션 division 이 MyDivision 목록에 있으면 그것,
  //   없으면 목록 첫 행 (AS-IS L374~377 `cboDivision.SelectedIndex = 1` = 첫 실 division 자동선택).
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
  //   filters 를 비우면 useTabProcQuery 가 disabled 되어 rows·헤더가 비고, 다시 보려면 Search 를 눌러야 한다.
  //   컬럼·Measure 메타는 divisionId deps effect 가 뒤따라 재fetch 한다. 편집 축 없음(조회 전용) = CRUD reset 해당없음.
  const handleDivisionChange = () => {
    clearData();
  };

  // UM-08 — bucket 전환: 경계(신·구 중 ONLY_WEEKLY)면 AS-IS InitSpread() 등가 = 메인 비움 + 타이틀 즉시 재조회(새 헤더).
  //   그 외 전환은 재조회 없이 Grid 가 D_/W_/M_ 가시성만 즉시 토글한다 (AS-IS SetSpreadColumn).
  const handleBucketChange = (prev: string, next: string) => {
    if (isBucketResetBoundary(prev, next)) resetForBucket(next);
  };

  // 정적 컬럼·Measure — 서버 직접 비교 (#113): division 변경 시 재fetch (SHEET_NAME='Mkt Fcst Waterfall')
  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    void fetchStaticColumns({ divisionId: searchParams.divisionId });
    void fetchStaticMeasures({ divisionId: searchParams.divisionId });
  }, [tabId, session.userId, searchParams.divisionId, fetchStaticColumns, fetchStaticMeasures]);

  // Column Setting 모달 재진입 복원 — 현재 grid 상태(개인화 반영본).
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns),
    [staticColumns]
  );
  // Default 원복 기준 — 개인화 적용 전 admin 원본 (siblings DMF0003/DMF0082 동형).
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns),
    [originalStaticColumns]
  );

  // ── 조회 (AS-IS FindData L652~940 — A-01/A-02/A-03) ──
  const handleSubmit = () => {
    if (!session.userId) return;

    // A-01 (MSG00097) — Division 필수
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.DIVISION_REQUIRED, '_Please select Division.'),
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

    // Version* — 기본값(최근 MF_W 2)이 비어 있으면 모달 선택 요구 (checkRequiredOfSearch 파리티)
    if (!searchParams.version) {
      void setAlert({ type: 'alert', content: t('MSG00283', '_Please select Version.') });
      return;
    }

    // A-02 (MSG00108) — 기간 역전
    if (fromDt.isAfter(toDt)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_INVALID, '_Invalid period.') });
      return;
    }

    // A-03 (MSG00164) — 2년 초과: 알림 + 종료일 자동 보정 후 중단 (AS-IS L688~695 보정까지 파리티.
    //   ⚠ 공용 문구는 '3년' — 로직은 AS-IS 2년. 제약매트릭스 A-03 비고)
    if (fromDt.add(PERIOD_LIMIT_YEARS, 'year').isBefore(toDt)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_LIMIT, '_The period is too long.') });
      setSearchParams({ endYyyymmdd: fromDt.add(PERIOD_LIMIT_YEARS, 'year').format('YYYYMMDD') });
      return;
    }

    const changed = setFilters({ userId: session.userId });
    // 조건 불변 재조회 = 메인+TITLE 전 쿼리 재조회 — [tabId] prefix invalidate (DMF0035 계보)
    if (!changed) void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  // 조회 전용 — CUD/업로드 미노출 (AS-IS Insert/Delete/Save 빈 구현·EditButton=MSG00109)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  // AS-IS btnColumn(L1338 — Column Show)/btnMeasure(L1350) — hook #120 순서: ColumnSet → Measure
  const customButtons = [
    {
      label: t('LBL00605', 'Column Setting'),
      title: t('LBL00605', 'Column Setting'),
      action: () => setColumnModalOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
    // {
    //   label: t('LBL00310', '_Measure'),
    //   title: t('LBL00310', '_Measure'),
    //   action: () => setMeasureModalOpen(true),
    //   iconComponent: <IcMeasureSelect />,
    //   buttonLabel: '',
    // },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <MktFcstComparisonForm
        onSubmit={handleSubmit}
        onDivisionChange={handleDivisionChange}
        onBucketChange={handleBucketChange}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data.length}
        excelFileName='MktFcstComparison'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      {/* UM-07 — gridFilterRef 를 DataGrid 까지 관통해야 Filter(F4) 가 산다 (미전달 = 조용한 no-op) */}
      <MktFcstComparisonGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data}
        spreadTitle={spreadTitle}
      />

      {/* Column 설정 (AS-IS btnColumn L1338 — PROGRAM_ID='DMF0040', titleSet 'C'. 공용 ColumnLayoutModal) */}
      <ColumnLayoutModal
        open={columnModalOpen}
        modalClose={() => setColumnModalOpen(false)}
        menuId={MENU_ID}
        sheetName='Mkt Fcst Waterfall'
        columnType='C'
        divisionId={searchParams.divisionId}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
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

      {/* Measure 설정 (AS-IS btnMeasure L1350 — master 공용 정본. TO-BE 는 PROGRAM_ID='DMF0040' 독립 축) */}
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
