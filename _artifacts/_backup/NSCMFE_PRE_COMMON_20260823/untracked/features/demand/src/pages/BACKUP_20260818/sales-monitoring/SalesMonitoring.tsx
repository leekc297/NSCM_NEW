import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ColumnLayoutModal,
  MeasureSelectModal,
  saveTitleSet,
  toColumnLayoutSettings,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesMonitoringForm } from './components/SalesMonitoringForm';
import { SalesMonitoringGrid } from './components/SalesMonitoringGrid';
import {
  MAIN_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './sales-monitoring.constants';
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
  const applyColumnLayout = useSalesMonitoringStore(s => s.applyColumnLayout);
  const clearUserColumnLayout = useSalesMonitoringStore(s => s.clearUserColumnLayout);
  const originalStaticColumns = useSalesMonitoringStore(s => s.originalStaticColumns);
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

  // Column/Measure 설정 저장 = Grid 초기화 의무 (사용자 요구 2026-08-05).
  //   저장 즉시 표시 컬럼/메저가 바뀌므로, 이전 설정으로 조회해 둔 rows 를 그대로 두면
  //   화면의 컬럼 구성과 데이터가 어긋난다. 그리드를 공백으로 되돌리고 재조회는 Search 로만.
  //   removeQueries([tabId]) 필수 — queryKey 는 filters '값' 기반이라 동일 조건으로 다시
  //   Search 하면 전역 staleTime=Infinity 캐시가 이전 설정으로 받은 rows 를 그대로 돌려준다.
  const clearGridOnSettingChange = () => {
    setHasSearched(false); // 쿼리 disable — Search 전까지 자동 재조회 안 함
    clearFilters(); // filters 무효화 (enabled=false + queryKey 변경 → rows 비움)
    queryClient.removeQueries({ queryKey: [tabId] }); // 이전 조회 결과 캐시 제거
  };

  // ⭐ Division 변경 시 컬럼 개인화 무효화 — SCM_MST_TITLESET_USER 는 division 무관 1벌인데
  //   titleSet 조회는 division 별 컬럼 세트로 필터된다. 비우지 않으면 이전 division 레이아웃이
  //   새 division 컬럼에 적용돼 "목록에 없는 컬럼 = 비표시" 규칙으로 전 컬럼이 사라진다.
  //   다음 fetchStaticColumns(Search)가 그 division 기준으로 다시 조회한다.
  //   Grid 도 같이 비운다 — 컬럼 세트가 division 별로 달라지므로 이전 division 으로 조회한 rows 를
  //   남겨두면 화면의 컬럼 구성과 데이터가 어긋난다 (Column/Measure 설정 변경과 동일 이유).
  //   재조회는 Search 로만 — clearGridOnSettingChange 가 hasSearched 를 내려 자동 발사를 막는다.
  //   Measure 는 즉시 재조회한다 — PR_GET_SHEET_MEASURE_LIST 가 division 별로 세트를 필터하므로,
  //   Search 전에 Measure 팝업을 열어도 새 division 기준 목록이 뜨게 한다.
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    clearUserColumnLayout();
    clearGridOnSettingChange();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, clearUserColumnLayout, fetchStaticMeasures]);

  // ⭐ A-1 (2026-07-04) — TITLESET 서버 영구 저장 (AS-IS DM0002_TitleSetForm OK → SCM_MST_TITLESET_USER 1:1).
  //   저장 실패를 사용자에게 알리는 공통 처리 — 조용히 삼키면 "저장했는데 재진입 시 원복" 과 구분이 안 된다.
  //   실제 호출은 공용 saveTitleSet (POST /admin/menu/{mnuId}/titleset) 이 담당한다.
  const alertSaveFailed = () => {
    void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
  };

  // ColumnLayoutModal 재진입 복원 — 현재 grid 상태(개인화 반영본).
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns[SHEETS.MAIN]),
    [staticColumns]
  );
  // Default 버튼 원복 기준 — 개인화 적용 전 admin 메타 원본.
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns[SHEETS.MAIN]),
    [originalStaticColumns]
  );

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

      {/* Column 설정 (공용 ColumnLayoutModal — 표시/순서 + Width/Cell·Text Color 개인화).
          AS-IS btnColumn → DM0002_TitleSetForm 1:1 */}
      <ColumnLayoutModal
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
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        // ⭐ 재진입 복원 — 현재 grid 상태(개인화 반영본). 미전달 시 서버 상태로 초기화되어
        //   사용자 선택이 원복되던 사고 (2026-07-04 사용자 지적)
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // (0) 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다.
          clearGridOnSettingChange();
          // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns 에 적용 → grid 즉시 갱신.
          applyColumnLayout(
            SHEETS.MAIN,
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          // (2) titleSet 'C' 영구 저장 — 표시 column + 순서 + 폭/색.
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            // ⚠️ 팝업 조회(위 sheetName/columnType)와 반드시 같은 값이어야 한다.
            sheetName: SHEETS.MAIN,
            columnType: 'C',
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              alertSaveFailed();
              return;
            }
            // ⭐ 팝업 titleSet 조회 캐시 무효화 (필수). 전역 staleTime=Infinity 라 invalidate 없이는
            //   재조회가 아예 안 일어나고, buildInitialRows 는 BE 응답을 화면 상태보다 우선하므로
            //   저장 전 값이 그대로 이겨서 재진입 시 원복된 것처럼 보인다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
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
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다.
          //   (메인 SP 가 TITLESET 'M' 으로 행을 필터하므로 신규 선택은 재조회로만 반영된다.)
          clearGridOnSettingChange();
          applyVisibleMeasures(SHEETS.MAIN, codes);
          const all = staticMeasures[SHEETS.MAIN].map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
            // Measure 개인화 — 폭/색은 대상이 아니라 미전달(빈 값으로 저장됨).
            //   필수: 저장 키는 팝업 조회와 같은 상수를 써야 한다 (다르면 재진입 시 개인화 유실).
            columnType: TITLESET_MEASURE_TYPE,
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              alertSaveFailed();
              return;
            }
            void fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />
    </div>
  );
};
