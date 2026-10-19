import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import {
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  toColumnLayoutSettings,
  type ColumnLayoutRow,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ProductionPlanWaterfallForm } from './components/ProductionPlanWaterfallForm';
import { ProductionPlanWaterfallGrid } from './components/ProductionPlanWaterfallGrid';
import {
  ADMIN_SHEET_NAME,
  GAP_VERSION_NO_LENGTH,
  LBL,
  MAX_PERIOD_DAYS,
  MENU_ID,
  MSG,
  SHEETS,
} from './production-plan-waterfall.constants';
import type { MainRow } from './production-plan-waterfall.types';
import styles from './ProductionPlanWaterfall.module.scss';
import { useProductionPlanWaterfallStore } from './useProductionPlanWaterfallStore';

// AS-IS GSCM.SCP.Forms.UIL SCP0017_WaterfallProductionPlan — 읽기전용 Waterfall pivot 조회 화면.
//   설계: .atlas/gscm-design/SCP0017/design/00~03 (v1, DB 실측). 상세 매핑: __asis-mapping__.md.
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M(SCP0017)=main/SEARCH·title/SEARCH 2행 등록됨(ora.py, 05_register.sql).
//     PKG_SCP0017 미배포(all_objects 0건) → 조회 런타임은 convert-sp 배포 후. 메뉴 가시화 완료.
//   읽기전용: Insert/Delete/Save NO-OP(AS-IS 주석 본문), Edit=MSG00109 후 return. 자매 SCP0101(SEARCH-only)
//     선례 + DB 등록(SEARCH 만) 기준으로 편집 버튼 미노출(hotkeyConfig false) — 근거 __asis-mapping__.md.
export const ProductionPlanWaterfall = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(state => state.session);
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useProductionPlanWaterfallStore(s => s.searchParams);
  const filters = useProductionPlanWaterfallStore(s => s.filters);
  const setFilters = useProductionPlanWaterfallStore(s => s.setFilters);
  const setSearchParams = useProductionPlanWaterfallStore(s => s.setSearchParams);
  const clearFilters = useProductionPlanWaterfallStore(s => s.clearFilters);
  const openSearchArea = useProductionPlanWaterfallStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanWaterfallStore(s => s.setOpenSearchArea);
  const initialized = useProductionPlanWaterfallStore(s => s.initialized);
  const fetchStaticColumns = useProductionPlanWaterfallStore(s => s.fetchStaticColumns);
  const metaColumns = useProductionPlanWaterfallStore(s => s.staticColumns[SHEETS.MAIN]);
  const staticMeasures = useProductionPlanWaterfallStore(s => s.staticMeasures);
  const visibleMeasures = useProductionPlanWaterfallStore(s => s.visibleMeasures);
  const columnSettings = useProductionPlanWaterfallStore(s => s.columnSettings);
  const fetchStaticMeasures = useProductionPlanWaterfallStore(s => s.fetchStaticMeasures);
  const applyVisibleMeasures = useProductionPlanWaterfallStore(s => s.applyVisibleMeasures);
  const applyColumnSettings = useProductionPlanWaterfallStore(s => s.applyColumnSettings);
  // 권한 Division 0건 게이트(design 01 L1, G6) — Form 이 콤보 실측으로 세팅. true 면 조회 미발사.
  const noDivisionAuth = useProductionPlanWaterfallStore(s => s.noDivisionAuth);

  const [openModel, setOpenModel] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // 컬럼/Measure 메타 fetch(mount 1회) + keep-alive 잔여 filters 무효화(자동조회 금지, nscm-patterns §5-7).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 데이터(메인 pivot). enabled = filters 세팅 후(명시 Search 게이트).
  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);

  // Measure 팝업(MeasureSelectModal) 결과로 measure 행 필터(design 03 §1.3, 1행=1 measure). 면제 규칙:
  //   모달 목록(staticMeasures)에 없는 SP 파생 measure(예 Gap 모드 GAP_ACC)는 항상 표시(demand-plan-waterfall 계보).
  const selectableMeasures = useMemo(
    () => new Set(staticMeasures.map(m => m.colNm)),
    [staticMeasures]
  );
  const visibleData = useMemo<MainRow[]>(() => {
    if (visibleMeasures == null) return rows;
    return rows.filter(row => {
      const measure = String(row.MEASURE ?? '');
      if (!selectableMeasures.has(measure)) return true; // 파생 measure = 필터 면제
      return visibleMeasures.includes(measure);
    });
  }, [rows, visibleMeasures, selectableMeasures]);

  // Column Set 팝업 초기값 — 이전 OK 결과가 있으면 그것, 없으면 현재 메타(admin fetch)에서 파생.
  const columnLayoutSettings = useMemo(
    () => columnSettings ?? toColumnLayoutSettings(metaColumns),
    [columnSettings, metaColumns]
  );

  // {0} 필수 메시지 — TO-BE MSG00429("{0} value is required.")는 i18next 가 {0} 치환 안 함 → 라벨 직접 삽입.
  const requiredMsg = (label: string): string =>
    t(MSG.REQUIRED_FIELD, '_{0} is required.').replace('{0}', label);

  // 조회 사전조건 (design 02 §6 / 03 §4.3): 필수값(Division/OperationGroup/Version/Period) + Gap→version 2건(MSG00376) + 기간.
  const validateSearch = (): boolean => {
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.DIVISION, '_Div')) });
      return false;
    }
    if (!sc.operationGroupId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.OPERATION_GROUP, '_Operation Group')) });
      return false;
    }
    if (sc.versionNos.length === 0) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.VERSION, '_Version')) });
      return false;
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.PERIOD, '_Period')) });
      return false;
    }
    const fromDigits = sc.fromYyyymmdd.replace(/-/g, '');
    const toDigits = sc.toYyyymmdd.replace(/-/g, '');
    if (fromDigits > toDigits) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_RANGE, '_Invalid period (start > end).') });
      return false;
    }
    // 최대 조회기간(AS-IS DateUtil.Check_PeriodDate cs:142~144, G7): to >= from + 1년 + 7일 이면 차단.
    //   무제한 기간 → 대형 pivot 부하 방지. 정수 YYYYMMDD 비교로 AS-IS 그대로 재현. 안내 param = 371(364+7)일.
    //   MSG.PERIOD_MAX=MSG01187(EN 'Maximum Period is From Date + {0}.') → {0}='371 days'(I2 문구 역조회 해소).
    const maxToExclusive = dayjs(fromDigits, 'YYYYMMDD').add(1, 'year').add(7, 'day');
    if (maxToExclusive.isValid() && Number(toDigits) >= Number(maxToExclusive.format('YYYYMMDD'))) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_MAX, '_Maximum Period is From Date + {0}.').replace(
          '{0}',
          `${MAX_PERIOD_DAYS} days`
        ),
      });
      return false;
    }
    // Gap 체크 시 version 정확히 2건(version_no 길이 27) — design 02 §4e MSG00376.
    if (sc.chkGap) {
      const versionNo = sc.versionNos.join(',');
      if (versionNo.length !== GAP_VERSION_NO_LENGTH || sc.versionNos.length !== 2) {
        void setAlert({
          type: 'alert',
          content: t(MSG.GAP_NEED_TWO_VERSION, '_Select 2 versions when Gap is checked.'),
        });
        return false;
      }
    }
    return true;
  };

  const handleSearch = () => {
    if (noDivisionAuth) return; // 권한 Division 0건 = 조회 미발사(design 01 L1, G6)
    if (!validateSearch()) return;
    setFilters({ userId: session.userId });
    void fetchStaticColumns();
  };

  // titleSet 저장 시트명 — SCM_MST_SHEET_COLUMNS/MEASURE 의 sheetNm(design 03 §1, 'MODEL').
  const titleSetSheet = ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN;

  // Column Set(btnColumn = AS-IS SCM0002_TitleSetForm 'C') — 공용 ColumnLayoutModal 정본(hook #132/#20).
  //   저장(titleSet 'C') → 그리드 비움 + 컬럼 메타 재fetch 로 재구성(demand-plan-waterfall 계보). PKG/titleSet SP
  //   미배포 상태에서는 서버 영구저장 런타임이 convert-sp 후속(모달·로컬 적용은 동작, 04 리포트 명시).
  const handleSaveColumnLayout = (settings: ColumnLayoutRow[]) => {
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    applyColumnSettings(settings);
    const visible = settings.filter(row => row.USER_FLAG === 'Y');
    void saveTitleSet({
      menuId: MENU_ID,
      sheetName: titleSetSheet,
      columnType: 'C',
      rows: visible.map((row, index) => ({
        name: row.COLUMN_NAME,
        sortOrderNo: index + 1,
        colWidth: row.COL_WIDTH,
        cellColor: row.CELL_COLOR,
        textColor: row.TEXT_COLOR,
      })),
    }).then(ok => {
      if (!ok) {
        void setAlert({ type: 'alert', content: t('MSG00618', '__An error occurred while saving.') });
        return;
      }
      void setToast({ type: 'success', message: t('MSG00606', '__Saved.') });
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      void fetchStaticColumns();
    });
  };

  // Measure(btnMeasure = AS-IS SCM0002_TitleSetForm 'M') — 공용 MeasureSelectModal 정본(hook #132).
  //   저장(titleSet 'M') → 그리드 비움 + measure 메타 재fetch. codes=null = 전체(면제 규칙은 visibleData).
  const handleApplyMeasures = (codes: string[] | null) => {
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    applyVisibleMeasures(codes);
    const selected = codes ?? staticMeasures.map(m => m.colNm);
    void saveTitleSet({
      menuId: MENU_ID,
      sheetName: titleSetSheet,
      columnType: 'M',
      rows: selected.map((name, index) => ({ name, sortOrderNo: index + 1 })),
    }).then(ok => {
      if (!ok) {
        void setAlert({ type: 'alert', content: t('MSG00618', '__An error occurred while saving.') });
        return;
      }
      void setToast({ type: 'success', message: t('MSG00606', '__Saved.') });
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      void fetchStaticMeasures();
    });
  };

  // 읽기전용 — Insert/Delete/Save NO-OP, Edit=MSG00109. 자매 SCP0101(SEARCH-only) + DB 등록(SEARCH만) 기준
  //   편집 버튼 미노출(false). AS-IS 는 버튼이 보였으나 NO-OP 였고, 사내 read-only 선례가 미노출이라 정합
  //   (근거 __asis-mapping__.md — self-check §3 예외 조항). search 는 무해하므로 항상 허용.
  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 허용하되, 권한 Division 0건이면 차단(design 01 L1, G6 — 자매 inventory-trend 선례).
    search: noDivisionAuth ? false : handleSearch,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ProductionPlanWaterfallForm onSearch={handleSearch} onModelSearch={() => setOpenModel(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={visibleData.length}
        excelFileName='ProductionPlanWaterfall'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        // #120 아이콘 순서 = (환율 없음) → Column Set → Measure. btnColumn/btnMeasure = SCM0002_TitleSetForm(design 03 §7 Hook #20).
        customButtons={[
          {
            label: t('LBL00605', '_Column Set'),
            title: t('LBL00605', '_Column Set'),
            action: () => setOpenColumnSetting(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
          {
            label: t(LBL.MEASURE, '_Measure'),
            title: t(LBL.MEASURE, '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanWaterfallGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          data={visibleData}
          tabId={tabId}
        />
      </div>

      {/* Model 검색 — 공용 표준 ItemByDivisionModal(btnItemId → txtItemId, design 02 §4.6). */}
      <ItemByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={itemIds => setSearchParams({ modelId: itemIds })}
        // AS-IS 는 division + sScmSite(plant site) 전달이나 공용 ItemByDivisionModal 은 plant site 필터 미지원
        //   (preSearchParams = divisionId/itemId 등). plant site 사전필터는 잔여(04 리포트) — 공용 모달 수정 금지(Hard Boundary).
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.modelId }}
        callFromCell={false}
      />

      {/* Column Set (AS-IS btnColumn = SCM0002_TitleSetForm 'C') — 공용 정본 ColumnLayoutModal(hook #132).
          fallbackColumns/initialSettings = 현재 화면 컬럼(개인화 반영본) — 미전달 시 재진입에 선택 원복. */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        sheetName={titleSetSheet}
        columnType='C'
        divisionId={sc.divisionId}
        fallbackColumns={metaColumns.map(column => ({
          key: column.colNm,
          header: column.colLblNm,
          width: column.colWth,
        }))}
        initialSettings={columnLayoutSettings}
        title={t(LBL.COLUMN, '_Column')}
        leftTitle={t(LBL.INVISIBLE, '_Invisible')}
        rightTitle={t(LBL.VISIBLE, '_Visible')}
        onSave={handleSaveColumnLayout}
      />

      {/* Measure (AS-IS btnMeasure = SCM0002_TitleSetForm 'M') — master 공용 정본 MeasureSelectModal.
          visibleMeasures = 이전 OK 결과(null=display 기본). OK = titleSet 'M' 저장 + 그리드 비움. */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={handleApplyMeasures}
      />
    </>
  );
};
