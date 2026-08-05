import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnSettingModal, type ColumnSettingRow } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MeasureSelectModal } from './components/MeasureSelectModal';
import { SalesMonitoringForm } from './components/SalesMonitoringForm';
import { SalesMonitoringGrid } from './components/SalesMonitoringGrid';
import { MAIN_COLUMNS, MENU_ID, MSG, SHEETS } from './sales-monitoring.constants';
import type { CurrentWeekInfo, SalesMonitoringRow, SpreadTitleRow } from './sales-monitoring.types';
import styles from './SalesMonitoring.module.scss';
import { useSalesMonitoringStore } from './useSalesMonitoringStore';

// AS-IS DMF0048_SalesMonitoring (Demand > Demand Plan > Sales Monitoring / 판매 모니터링).
//   read-only 화면 (사용자 확정 2026-07-04) — AS-IS 는 FindButton/ExcelButton 만 override,
//   저장 스택(InitSaveDataTable/SetSaveData/fnValidation)은 주석 처리된 데드코드.
//   레이아웃: mkt-fcst(DMF0003) 표준 1:1 — MainTitle + SearchArea Form + SubTitle + PIVOT DataGrid.
//   SP: PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING(메인) + DMF0048_GET_SPREAD_TITLE(기간 헤더)
//       + PR_GET_DAY_RANGE(기본 조회구간 — AS-IS GetDayRange p_month=6, o_rc2 사용).
export const SalesMonitoring = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<SalesMonitoringRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const sc = useSalesMonitoringStore(s => s.searchCondition);
  const filters = useSalesMonitoringStore(s => s.filters);
  const setFilter = useSalesMonitoringStore(s => s.setFilter);
  const clearFilters = useSalesMonitoringStore(s => s.clearFilters);
  const openSearchArea = useSalesMonitoringStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesMonitoringStore(s => s.setOpenSearchArea);
  const staticColumns = useSalesMonitoringStore(s => s.staticColumns);
  const staticMeasures = useSalesMonitoringStore(s => s.staticMeasures);
  const fetchStaticColumns = useSalesMonitoringStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useSalesMonitoringStore(s => s.fetchStaticMeasures);
  const applyColumnVisibility = useSalesMonitoringStore(s => s.applyColumnVisibility);
  const userColumnKeys = useSalesMonitoringStore(s => s.userColumnKeys);
  const visibleMeasures = useSalesMonitoringStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useSalesMonitoringStore(s => s.applyVisibleMeasures);
  const applyDayRange = useSalesMonitoringStore(s => s.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). stale filters 자동 발사 → NULL payload 사고 차단.
  const [hasSearched, setHasSearched] = useState(false);

  // 메인 그리드 SP — PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING (18 IN + 세션 2 + O_RC1/O_RC2/O_RESULT).
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 PIVOT 기간 헤더 SP — DMF0048_GET_SPREAD_TITLE (5 IN + O_RC1).
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [];

  // ⭐ 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange 1:1: p_month=6, Tables[1]=o_rc2 사용,
  //   해당 월 1일 ~ 6개월 마지막 날). ⭐ A-4 — 적용 여부는 store persist (탭 수명 내 1회 —
  //   remount 시 사용자가 변경한 Period 를 서버 기본값이 덮지 않도록).
  const dayRangeApplied = useSalesMonitoringStore(s => s.dayRangeApplied);
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '6' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  useEffect(() => {
    const range = (dayRangeData as { o_rc2?: { DAY_RANGE?: string }[] })?.o_rc2?.[0]?.DAY_RANGE;
    if (!range) return;
    applyDayRange(range); // 내부에서 dayRangeApplied 가드 + 1회 마킹
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData]);

  // ⭐ 메인 SP o_rc2 — 현재 월/주 정보 (THIS_YYYYMM/THIS_YYYYMMWW). 헤더 초록 강조 + 과거 회색 판정 입력.
  const currentWeekInfo = useMemo<CurrentWeekInfo | null>(() => {
    const rc2 = (data as { o_rc2?: CurrentWeekInfo[] | CurrentWeekInfo } | undefined)?.o_rc2;
    return Array.isArray(rc2) ? (rc2[0] ?? null) : (rc2 ?? null);
  }, [data]);

  // mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화 (NULL payload SP 자동호출 방지)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Column / Measure 선택 모달 open state
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ⭐ A-1 (2026-07-04) — TITLESET 서버 영구 저장 (AS-IS DM0002_TitleSetForm OK → SCM_MST_TITLESET_USER 1:1).
  //   SCM0002_SET_TITLESET_POPUP: '^' delim 다건(DELETE 후 INSERT), P_USER_ID = BE 세션 자동(sesUserId).
  //   ^delim 다건 SAVE 는 apiClient.post 직접 (useProcMutation array unfold 안 함 — 표준 선례).
  const saveTitleSet = async (
    columnType: 'C' | 'M',
    saveRows: {
      name: string;
      sortOrderNo: number;
      subTotalFlag?: string;
      sortMethodCode?: string;
    }[]
  ): Promise<boolean> => {
    try {
      const payload = {
        programId: MENU_ID,
        sheetName: SHEETS.MAIN,
        columnType,
        activeFlag: saveRows.map(() => 'Y').join('^'),
        columnName: saveRows.map(r => r.name).join('^'),
        sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo || i + 1)).join('^'),
        subTotalFlag: saveRows.map(r => r.subTotalFlag ?? 'N').join('^'),
        sortMethodCode: saveRows.map(r => r.sortMethodCode ?? 'ASC').join('^'),
      };
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/titleSet/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return false;
      }
      return true;
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t('MSG00618', '_An error occurred while saving.');
      void setAlert({ type: 'alert', content: msg });
      return false;
    }
  };

  // ----- 조회 validation (AS-IS FindData L625~673 1:1 — validation.md 23건 중 조회 체인 5건) -----
  const validateFind = (): boolean => {
    // MSG00137 — 이전 작업 실행 중 (AS-IS blnWork 가드)
    if (isFetching) {
      void setAlert({
        type: 'alert',
        content: t(MSG.WORK_IN_PROGRESS, '_이전 작업이 아직 실행 중입니다.'),
      });
      return false;
    }
    // MSG00097 — Division 필수 (AS-IS L671)
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'),
      });
      return false;
    }
    // MSG00108 — 기간 역전 (AS-IS L638)
    if (Number(sc.startYyyymmdd) > Number(sc.endYyyymmdd)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다.'),
      });
      return false;
    }
    // MSG00164 — 3년 초과 (AS-IS L645: Value1.AddYears(3) < Value2)
    const limit = `${Number(sc.startYyyymmdd.slice(0, 4)) + 3}${sc.startYyyymmdd.slice(4)}`;
    if (Number(sc.endYyyymmdd) > Number(limit)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_MAX_3YEAR, '_조회 기간은 3년 이내로 입력해주세요.'),
      });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure filters → NULL SP 사고. setFilter+enabled 만).
  //   ⭐ B-1 (2026-07-04) — 동일 조건 재조회 시 react-query 캐시 반환 방지: queryKey invalidate 로
  //   최신 데이터 강제 refetch (filters 미변경이어도 서버 재호출).
  const handleSearch = () => {
    if (!validateFind()) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setHasSearched(true);
    setFilter();
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // SubTitle 공통버튼 — read-only: SEARCH/EXCEL 활성 (BTN 메타 등록), INSERT/DELETE/SAVE 미등록 →
  //   hasButton=false → hidden. sort/filter/condition/resetCondition/excel = DefaultButtonActions 자동.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  // Column / Measure 버튼 (AS-IS btnColumn/btnMeasure 1:1 — SubTitle customButtons, icon-only)
  const customButtons = [
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenColumnSetting(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  // Measure 선택 필터 — visibleMeasures null = 전체 표시
  const mainVisibleMeasures = visibleMeasures[SHEETS.MAIN];
  const rows: SalesMonitoringRow[] = useMemo(() => {
    const spRows = (data as { o_rc1?: SalesMonitoringRow[] })?.o_rc1 ?? [];
    if (!mainVisibleMeasures) return spRows;
    const allow = new Set(mainVisibleMeasures);
    return spRows.filter(r => typeof r.MEASURE !== 'string' || allow.has(r.MEASURE));
  }, [data, mainVisibleMeasures]);

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && <SalesMonitoringForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesMonitoring'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <SalesMonitoringGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        divisionId={sc.divisionId}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        colorYn={sc.colorYn}
        staticColumns={staticColumns[SHEETS.MAIN]}
        spreadTitle={spreadTitleRows}
        currentWeekInfo={currentWeekInfo}
      />

      {/* Column 설정 (공용 ColumnSettingModal — AS-IS btnColumn → DM0002_TitleSetForm 1:1) */}
      <ColumnSettingModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        // ⭐ A-2 (2026-07-04): TITLESET_USER.USER_INQUIRY_COLUMN_TYPE_CODE 실측 값 = 'C'(컬럼)/'M'(measure).
        //   'Sales Monitoring' 전달 시 이관 개인화 사용자(k0101 등 8명)의 'C' 행이 매칭 안 됨.
        columnType='C'
        divisionId={sc.divisionId}
        fallbackColumns={MAIN_COLUMNS.map(c => ({ key: c.key, header: c.header, width: c.width }))}
        title={t('LBL00711', '_Column')}
        // ⭐ 재진입 복원 — 이전 OK 결과 (미전달 시 서버 상태(DEFAULT/개인화)로 초기화되어
        //   사용자 선택이 원복되던 사고, 2026-07-04 사용자 지적)
        initialVisibleKeys={userColumnKeys ?? undefined}
        onSave={(settings: ColumnSettingRow[]) => {
          // 로컬 즉시 반영 + 서버 영구 저장('C') → 재조회 (BE display 가 개인화 기준으로 재계산)
          applyColumnVisibility(
            SHEETS.MAIN,
            settings.map(s => s.COLUMN_NAME)
          );
          void saveTitleSet(
            'C',
            settings.map(s => ({
              name: s.COLUMN_NAME,
              sortOrderNo: Number(s.SORT_ORDER_NO ?? 0),
              subTotalFlag: s.SUB_TOTAL_FLAG,
              sortMethodCode: s.USER_SORT_METHOD_CODE,
            }))
          ).then(ok => {
            if (ok) void fetchStaticColumns();
          });
        }}
      />

      {/* Measure 선택 (AS-IS btnMeasure → DM0002_TitleSetForm measure 모드 1:1) */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={staticMeasures[SHEETS.MAIN]}
        visibleMeasures={visibleMeasures[SHEETS.MAIN]}
        onApply={codes => {
          // 로컬 행 필터 + 서버 영구 저장('M') — 메인 SP 가 TITLESET 'M' 으로 행을 필터하므로
          //   저장 후 메인 쿼리 invalidate → 신규 선택 measure 행이 서버에서 반환됨 (A-1 핵심)
          applyVisibleMeasures(SHEETS.MAIN, codes);
          const all = staticMeasures[SHEETS.MAIN].map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            void fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />
    </div>
  );
};
