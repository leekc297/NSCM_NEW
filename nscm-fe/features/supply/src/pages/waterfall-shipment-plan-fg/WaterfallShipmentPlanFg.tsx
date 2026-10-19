import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, MeasureSelectModal, ProjectByDivisionModal } from 'features/master/src/components';
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

import { WaterfallShipmentPlanFgForm } from './components/WaterfallShipmentPlanFgForm';
import { WaterfallShipmentPlanFgGrid } from './components/WaterfallShipmentPlanFgGrid';
import { useWaterfallShipmentPlanFgStore } from './useWaterfallShipmentPlanFgStore';
import {
  ADMIN_COLUMN_SHEET_NAME,
  ADMIN_MEASURE_SHEET_NAME,
  LBL,
  MAX_PERIOD_DAYS,
  MENU_ID,
  MSG,
  SHEETS,
} from './waterfall-shipment-plan-fg.constants';
import type { MainRow } from './waterfall-shipment-plan-fg.types';
import styles from './WaterfallShipmentPlanFg.module.scss';

// AS-IS GSCM.SCP.Forms.UIL SCP0016_WaterfallShipmentPlanFG — 읽기전용 Waterfall pivot 조회 화면.
//   설계: .atlas/gscm-design/SCP0016/design/00~03 (v1, DB 실측). 상세 매핑: __asis-mapping__.md.
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M(SCP0016)=main/SEARCH·main/MEASURE_SELECT·spreadTitle/SEARCH
//     (자매 SCP0018 미러, 05_register.sql). PKG_SCP0016 미배포 → 메인 조회 런타임은 convert-sp 배포 후.
//     캘린더(spreadTitle)는 공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(VALID) 재사용.
//   읽기전용: SaveButton NO-OP · EditButton=MSG00109 후 return · Insert/Delete 미노출. 자매 SCP0017/SCP0018
//     선례 + DB 등록(SEARCH 만) 기준 편집 버튼 미노출(hotkeyConfig false) — 근거 __asis-mapping__.md.
export const WaterfallShipmentPlanFg = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(state => state.session);
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useWaterfallShipmentPlanFgStore(s => s.searchParams);
  const filters = useWaterfallShipmentPlanFgStore(s => s.filters);
  const setFilters = useWaterfallShipmentPlanFgStore(s => s.setFilters);
  const setSearchParams = useWaterfallShipmentPlanFgStore(s => s.setSearchParams);
  const clearFilters = useWaterfallShipmentPlanFgStore(s => s.clearFilters);
  const openSearchArea = useWaterfallShipmentPlanFgStore(s => s.openSearchArea);
  const setOpenSearchArea = useWaterfallShipmentPlanFgStore(s => s.setOpenSearchArea);
  const initialized = useWaterfallShipmentPlanFgStore(s => s.initialized);
  const fetchStaticColumns = useWaterfallShipmentPlanFgStore(s => s.fetchStaticColumns);
  const metaColumns = useWaterfallShipmentPlanFgStore(s => s.staticColumns[SHEETS.MAIN]);
  const staticMeasures = useWaterfallShipmentPlanFgStore(s => s.staticMeasures);
  const visibleMeasures = useWaterfallShipmentPlanFgStore(s => s.visibleMeasures);
  const columnSettings = useWaterfallShipmentPlanFgStore(s => s.columnSettings);
  const fetchStaticMeasures = useWaterfallShipmentPlanFgStore(s => s.fetchStaticMeasures);
  const applyVisibleMeasures = useWaterfallShipmentPlanFgStore(s => s.applyVisibleMeasures);
  const applyColumnSettings = useWaterfallShipmentPlanFgStore(s => s.applyColumnSettings);
  const noDivisionAuth = useWaterfallShipmentPlanFgStore(s => s.noDivisionAuth);
  // F6 저장조건 복원(진입 1회, basic-check #3) — searchParam 저장분을 searchParams 로 되살린다.
  const restoreSearchConditions = useWaterfallShipmentPlanFgStore(s => s.restoreSearchConditions);

  const [openModel, setOpenModel] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // 컬럼/Measure 메타 fetch(mount 1회) + keep-alive 잔여 filters 무효화(자동조회 금지, nscm-patterns §5-7)
  //   + F6 저장조건 복원(진입 1회, basic-check #3 — 저장은 SubTitle searchParam, 복원은 여기서 배선).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    clearFilters();
    void restoreSearchConditions();
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

  // Measure 팝업(MeasureSelectModal) 결과로 measure 행 필터(design 03 §4.3, 1행=1 measure). 모달 목록에 없는
  //   SP 파생 measure 는 항상 표시(면제 규칙, 자매 production-plan-waterfall 계보).
  const selectableMeasures = useMemo(() => new Set(staticMeasures.map(m => m.colNm)), [staticMeasures]);
  const visibleData = useMemo<MainRow[]>(() => {
    if (visibleMeasures == null) return rows;
    return rows.filter(row => {
      const measure = String(row.MEASURE ?? row.measure ?? '');
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

  // 조회 사전조건 (design 02 §6 / 01 D6): 필수값(Division/OperationGroup/Version/Period) + 기간 유효성.
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
    // 최대 조회기간(AS-IS DateUtil.Check_PeriodDate, G7): to >= from + 1년 + 7일 이면 차단. {0}='371 days'.
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
    return true;
  };

  const handleSearch = () => {
    if (noDivisionAuth) return; // 권한 Division 0건 = 조회 미발사(design 01 D9)
    if (!validateSearch()) return;
    setFilters({ userId: session.userId });
    void fetchStaticColumns();
  };

  // titleSet 저장 시트명 — 칼럼과 measure 가 서로 다른 sheet 이다(design 03 §0/§6-1 이원화).
  //   Column Set('C') = 칼럼 레이아웃 메타 sheetNm 'Waterfall Shipment Plan'.
  //   Measure('M')    = measure 메타 sheetNm 'Shipment Plan FG'(fetchStaticMeasures 와 동일 키 → round-trip).
  const titleSetSheet = ADMIN_COLUMN_SHEET_NAME;
  const measureSetSheet = ADMIN_MEASURE_SHEET_NAME;

  // Column Set(btnColumn = AS-IS SCM0002_TitleSetForm 'C') — 공용 ColumnLayoutModal 정본(hook #132/#20).
  //   저장(titleSet 'C') → 그리드 비움 + 컬럼 메타 재fetch 로 재구성. titleSet SP 미배포 상태에서는 서버
  //   영구저장 런타임이 convert-sp 후속(모달·로컬 적용은 동작, 04 리포트 명시).
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
      sheetName: measureSetSheet, // measure sheet('Shipment Plan FG') — fetch 키와 일치(G02 교정)
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

  // 읽기전용 — SaveButton NO-OP · EditButton=MSG00109 · Insert/Delete 미노출(design 01 D3/D4, §4d).
  //   DB 등록(SEARCH 만) + 자매 SCP0017/SCP0018 선례 기준 편집 버튼 미노출(false). search 는 무해하므로
  //   항상 허용하되 권한 Division 0건이면 차단(근거 __asis-mapping__.md — self-check §3 예외 조항).
  const hotkeyConfig: HotkeyConfig = {
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
        <WaterfallShipmentPlanFgForm
          onSearch={handleSearch}
          onModelSearch={() => setOpenModel(true)}
          onProjectSearch={() => setOpenProject(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={visibleData.length}
        excelFileName='WaterfallShipmentPlanFg'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        // #120 아이콘 순서 = (환율 없음) → Column Set → Measure (design 01 §7 hook #120, §4e #1/#2).
        customButtons={[
          {
            label: t(LBL.COLUMN_SET, '_Column Set'),
            title: t(LBL.COLUMN_SET, '_Column Set'),
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
        <WaterfallShipmentPlanFgGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          data={visibleData}
          tabId={tabId}
        />
      </div>

      {/* Model 검색 — 공용 표준 ItemByDivisionModal(btnItem_Id → txtItem_Id, design 02 §4.6 P1). */}
      <ItemByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={itemIds => setSearchParams({ itemId: itemIds })}
        // 반환 없으면 기존값 유지(AS-IS if(!="") 가드) — 모달이 빈 선택을 콜백하지 않는다.
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* Project 검색 — 공용 표준 ProjectByDivisionModal(btnProject → txtProject, design 02 §4.6 P2). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={projects => setSearchParams({ projectCode: projects })}
        preSearchParams={{ divisionId: sc.divisionId, projectCode: sc.projectCode }}
        callFromCell={false}
      />

      {/* Column Set (AS-IS btnColumn = SCM0002_TitleSetForm 'C') — 공용 정본 ColumnLayoutModal(hook #132). */}
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

      {/* Measure (AS-IS btnMeasure = SCM0002_TitleSetForm 'M') — master 공용 정본 MeasureSelectModal. */}
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
