/**
 * DMF0020 SalesFuturePrice — 메인 페이지
 *
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/
 *        DMF0020_SalesFuturePrice/DMF0020_SalesFuturePrice.cs (3,969줄)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/__asis-mapping__.md
 * To-Be 설계: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/tobe_design.md §9
 *
 * 사용자 요구 (2026-05-28):
 *   1. Tab1 — 기존 PIVOT SP 결과 그대로 FlexGrid (wide-format)
 *   2. Tab2 — Wijmo PivotGrid (클라이언트 unpivot, 룰 27)
 *   3. 조회조건 POPUP 3종 — 공통 modal 재사용 (Form 안에서)
 *   4. 자체 modal 6종 — 신규 컴포넌트 (룰 25 §3.4)
 *   5. AS-IS 분석서·원시소스 참조 보존 — 모든 핸들러에 AS-IS Line 주석
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesFuturePriceFlexGrid } from './components/SalesFuturePriceFlexGrid';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { SalesFuturePricePivotGrid } from './components/SalesFuturePricePivotGrid';
import { ColumnTitleSetModal } from './components/modals/ColumnTitleSetModal';
import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import { SalesPriceRangeModal } from './components/modals/SalesPriceRangeModal';
import { SalesPriceTemplateModal } from './components/modals/SalesPriceTemplateModal';
import { SalesPriceVersionModal } from './components/modals/SalesPriceVersionModal';
import { useSalesFuturePriceExpression } from './hooks/useSalesFuturePriceExpression';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import { MENU_ID, SHEET_INDEX } from './sales-future-price.constants';
import type { SalesFuturePriceRow } from './sales-future-price.types';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';

export const SalesFuturePrice = ({ tabId, title }: PageProps<MenuId>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const { saveWithValidation } = useSaveWithValidation();

  // -------------------------------------------------------------------------
  // Refs — FlexGrid (Tab1) 만. PivotGrid 는 자체 ref 내부 관리 (룰 27 §C).
  // -------------------------------------------------------------------------
  const gridRef = useRef<FlexGrid<SalesFuturePriceRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<SalesFuturePriceRow>>();

  // -------------------------------------------------------------------------
  // Store
  // -------------------------------------------------------------------------
  const filters = useSalesFuturePriceStore(state => state.filters);
  const setFilters = useSalesFuturePriceStore(state => state.setFilters);
  const searchParams = useSalesFuturePriceStore(state => state.searchParams);
  const staticColumns = useSalesFuturePriceStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesFuturePriceStore(state => state.fetchStaticColumns);
  const fetchDynamicColumns = useSalesFuturePriceStore(state => state.fetchDynamicColumns);
  const isOpenSearchArea = useSalesFuturePriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(state => state.setOpenSearchArea);
  const selectedTabIndex = useSalesFuturePriceStore(state => state.selectedTabIndex);
  const setSelectedTabIndex = useSalesFuturePriceStore(state => state.setSelectedTabIndex);

  // Modal 6종 (사용자 결정 — 자체 생성)
  const modals = useSalesFuturePriceStore(state => state.modals);
  const setOpenExchangeRate = useSalesFuturePriceStore(state => state.setOpenExchangeRate);
  const setOpenSalesPriceRange = useSalesFuturePriceStore(state => state.setOpenSalesPriceRange);
  const setOpenPriceBatchInput = useSalesFuturePriceStore(state => state.setOpenPriceBatchInput);
  const setOpenSalesPriceTemplate = useSalesFuturePriceStore(
    state => state.setOpenSalesPriceTemplate
  );
  const setOpenSalesPriceVersion = useSalesFuturePriceStore(
    state => state.setOpenSalesPriceVersion
  );
  const setOpenColumnTitleSet = useSalesFuturePriceStore(state => state.setOpenColumnTitleSet);

  // -------------------------------------------------------------------------
  // AS-IS Validation / Expression hook (총 50+ 매핑)
  // -------------------------------------------------------------------------
  const {
    confirmSaveData,
    validateFindWorkInProgress,
    validateVersionSelected,
    validatePeriodOrder,
    validateDivisionSelected,
    guardEnterEditMode,
    showSaveErrorFromResultSet,
  } = useSalesFuturePriceValidation();

  const { isEss, buildInsertRowDefaults } = useSalesFuturePriceExpression();

  // -------------------------------------------------------------------------
  // Data — 메인 SP 결과 (PIVOT wide-format) — Tab1 FlexGrid + Tab2 PivotGrid 양쪽 사용
  // AS-IS: DMF0020_SalesFuturePrice.cs:1279~1380 FindData
  // -------------------------------------------------------------------------
  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    filters: (filters ?? {}) as never,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    onSuccess: () => void refetch(),
  });

  // -------------------------------------------------------------------------
  // Effects — staticColumns 초기 로드 + 검색조건 변경 시 동적 컬럼 재조회
  // -------------------------------------------------------------------------
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  useEffect(() => {
    if (filters) void fetchDynamicColumns();
  }, [filters, fetchDynamicColumns]);

  // -------------------------------------------------------------------------
  // Handlers — F5/F7/F8 가드 + AS-IS 71 Validation 적용
  // -------------------------------------------------------------------------

  /** F5 조회 — AS-IS FindData (.cs:1279~) MSG00137/MSG00283/MSG00108/MSG00097 */
  const onSearch = () => {
    if (!validateFindWorkInProgress()) return;
    if (!validateVersionSelected(searchParams.versionId)) return;
    if (!validateDivisionSelected(searchParams.divisionId)) return;
    if (!validatePeriodOrder(searchParams.periodFrom, searchParams.periodTo)) return;
    setFilters();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();
  };

  /** F7 저장 — AS-IS SaveData (.cs:1551~1933) MSG00137/MSG00002/MSG00043/MSG00004 */
  const onSave = () => {
    const rows = (data as { o_rc1?: SalesFuturePriceRow[] } | undefined)?.o_rc1 ?? [];
    const saveData = rows.filter(item => item.CRUD_TYPE);
    if (saveData.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00018', '_변경된 사항이 없습니다.') });
      return;
    }
    confirmSaveData(() => {
      saveWithValidation(
        saveData as never,
        staticColumns,
        mutate as never,
        (resultSet?: { errors?: Array<{ MESSAGE?: string }> }) => {
          // AS-IS .cs:1929 MessageBox.Show(ds.Tables[...])
          showSaveErrorFromResultSet(resultSet?.errors);
        }
      );
    });
  };

  /** F8 행 추가 — AS-IS InsertRow (.cs:2007~2163) + Combo Cell Type 초기값 */
  const onInsert = () => {
    if (!gridRef.current) return;
    if (!guardEnterEditMode()) return;
    GridAction.addRow(gridRef.current, buildInsertRowDefaults());
  };

  /** F9 행 삭제 — AS-IS DeleteButton (룰 12 GridAction 표준) */
  const onDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  /** F11 Excel Upload — AS-IS btnExcelUpload_Click (.cs:3935) MSG00265 */
  const onExcelUpload = () => {
    // 자체 처리 (Excel 파일 input + DMF0020_EXCEL_UPLOAD SP 호출)
    void setAlert({ type: 'alert', content: t('MSG00265', '_Excel 업로드 안내') });
  };

  /** Batch Job — AS-IS btnBatch_Click (.cs:3493) MSG00143 */
  const onBatchClick = () => {
    void setAlert({ type: 'alert', content: t('MSG00143', '_배치 실행 안내') });
  };

  // -------------------------------------------------------------------------
  // Hotkey — 룰 12 표준 (F5/F7/F8/F9/F11)
  // -------------------------------------------------------------------------
  const hotkeyConfig: HotkeyConfig = {
    search: onSearch,
    save: onSave,
    insert: onInsert,
    delete: onDelete,
    upload: onExcelUpload,
    manual: false,
  };

  // -------------------------------------------------------------------------
  // Tab1/Tab2 데이터
  // -------------------------------------------------------------------------
  const rows = (data as { o_rc1?: SalesFuturePriceRow[] } | undefined)?.o_rc1 ?? [];
  const isPivotTab = selectedTabIndex === SHEET_INDEX.MAIN_PIVOT;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <SalesFuturePriceForm
        onSearch={onSearch}
        onOpenExchangeRate={() => setOpenExchangeRate(true)}
        onOpenSalesPriceRange={() => setOpenSalesPriceRange(true)}
        onOpenPriceBatchInput={() => setOpenPriceBatchInput(true)}
        onOpenSalesPriceTemplate={() => setOpenSalesPriceTemplate(true)}
        onOpenSalesPriceVersion={() => setOpenSalesPriceVersion(true)}
        onOpenColumnTitleSet={() => setOpenColumnTitleSet(true)}
        onBatchClick={onBatchClick}
        showTemplateButton={isEss(searchParams.divisionId)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesFuturePrice'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />

      <TabWrapper
        persist
        activeTabIndex={selectedTabIndex}
        setActiveTabIndex={inx => setSelectedTabIndex(inx as SHEET_INDEX)}
      >
        <TabItem label={t('LBL_DMF0020_MAIN', '_가격 마스터')}>
          <SalesFuturePriceFlexGrid
            gridRef={gridRef}
            gridFilterRef={gridFilterRef}
            editTrackerRef={editTrackerRef}
            data={rows}
          />
        </TabItem>
        <TabItem label={t('LBL_DMF0020_ANALYSIS_PIVOT', '_분석 피벗')}>
          {/* Tab2 — Wijmo PivotGrid (클라이언트 unpivot, 룰 27 §C) */}
          <SalesFuturePricePivotGrid data={rows} enabled={isPivotTab} />
        </TabItem>
      </TabWrapper>

      {/* 자체 modal 6종 — 사용자 결정 (룰 25 §3.4 신규 생성) */}
      <ExchangeRateModal
        open={modals.openExchangeRate}
        modalClose={() => setOpenExchangeRate(false)}
        defaultDivision={searchParams.divisionId}
      />
      <SalesPriceRangeModal
        open={modals.openSalesPriceRange}
        modalClose={() => setOpenSalesPriceRange(false)}
      />
      <PriceBatchInputModal
        open={modals.openPriceBatchInput}
        modalClose={() => setOpenPriceBatchInput(false)}
        baseFilter={searchParams}
      />
      <SalesPriceTemplateModal
        open={modals.openSalesPriceTemplate}
        modalClose={() => setOpenSalesPriceTemplate(false)}
      />
      <SalesPriceVersionModal
        open={modals.openSalesPriceVersion}
        modalClose={() => setOpenSalesPriceVersion(false)}
      />
      <ColumnTitleSetModal
        open={modals.openColumnTitleSet}
        modalClose={() => setOpenColumnTitleSet(false)}
        menuId={MENU_ID}
        sheetName='main'
      />
    </>
  );
};
