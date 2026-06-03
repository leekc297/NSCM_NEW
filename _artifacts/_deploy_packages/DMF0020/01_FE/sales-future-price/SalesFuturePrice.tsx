import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesFuturePriceFlexGrid } from './components/SalesFuturePriceFlexGrid';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { ColumnTitleSetModal } from './components/modals/ColumnTitleSetModal';
import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import { SalesPriceRangeModal } from './components/modals/SalesPriceRangeModal';
import { SalesPriceTemplateModal } from './components/modals/SalesPriceTemplateModal';
import { SalesPriceVersionModal } from './components/modals/SalesPriceVersionModal';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import { useDivisionRole } from './hooks/useSalesFuturePriceExpression';
import { MAIN_COLUMNS, MENU_ID, SHEETS } from './sales-future-price.constants';
import type { FuturePriceRow, SpreadTitleDateRow } from './sales-future-price.types';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';

import styles from './SalesFuturePrice.module.scss';

// AS-IS DMF0020_SalesFuturePrice.cs (3,969줄 Forms.UIL/Master 정본) — 메인 화면
//   - 24 Event (Form_Load / clbDivisions_Change / btnExchangeRate_Click / btnSavePricePeriod_Click / ...)
//   - 18 PKG SP + 12 Common Lookup
//   - 71 메인 Validation + 12 POPUP Validation
//   - 9 Expression (SUM headers / 동적 컬럼 / 3단 머지 / Visible 분기 / EditFlag)
//   - 7 POPUP (Exchange/Price Batch/Version/Owner/ColumnTitleSet/Range/Template)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/ (9 MD)
//   - 메타: To-be_v2_converted/08_Screen_Registration/registrations/03_DMF0020_Registration.sql (7-BLOCK)
//   - __asis-mapping__.md: 본 폴더 + Doc/_analysis 폴더 cross-ref
//
// 룰 25 §1.5.1 (Button 10대) — CRUD 6 + Aux 4:
//   F2 Edit / F5 Search / F7 Save / F8 Insert / F9 Delete / F12 Excel  (CRUD)
//   F3 Sort (자동) / F4 Filter (자동) / F6 Condition (false — 패널 없음) / F10 Reset (false)
// 룰 12 §11.7 — column meta 기반 cell coloring + popup cell
// 룰 12 §11.6 — HierarchicalMergeManager (SmartColMerge 동등, SalesFuturePriceFlexGrid 안 정의)
export const SalesFuturePrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<FuturePriceRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const filters = useSalesFuturePriceStore(s => s.filters);
  const setFilter = useSalesFuturePriceStore(s => s.setFilter);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(s => s.setOpenSearchArea);

  const role = useDivisionRole(sc.divisionId);
  const validate = useSalesFuturePriceValidation();

  // 메인 그리드 SP (P_DMF0020_GET_FUTUREPRICE_INFO — 4 IN + 2 OUT)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 동적 시간축 컬럼 메타 (P_DMF0020_GET_SPREAD_TITLE_DATE — 별도 sheet 등록 후 연동 예정)
  // 현재는 빈 배열 처리 → 32 고정 컬럼만 표시
  const titleDate: SpreadTitleDateRow[] | undefined = undefined;

  // 화면 진입 시 자동 조회 — Division 자동 적용 후 filter 세팅 (AS-IS Form_Load + InitControls)
  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // 신규/수정 행 추적 (CRUD_TYPE) — SP 결과와 합쳐 grid itemsSource
  const [insertedRows, setInsertedRows] = useState<FuturePriceRow[]>([]);
  const [selectedGroupKey, setSelectedGroupKey] = useState('');

  // Modal open state
  const [openExchange, setOpenExchange] = useState(false);
  const [openBatch, setOpenBatch] = useState(false);
  const [openVersion, setOpenVersion] = useState(false);
  const [openTitleSet, setOpenTitleSet] = useState(false);
  const [openRange, setOpenRange] = useState(false);
  const [openTemplate, setOpenTemplate] = useState(false);

  // ----- Button 10대 매핑 -----
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    setFilter();
    refetch?.();
    setInsertedRows([]);
  };

  // F8 Insert — AS-IS L2007~ InsertRow (Division 분기 + Combo Cell 설정)
  const handleInsert = () => {
    const newRow: FuturePriceRow = {
      CRUD_TYPE: 'I',
      DIVISION_ID: sc.divisionId,
      DEPT_ID: '',
      TEAM_INCHARGE: '',
    };
    setInsertedRows(prev => [newRow, ...prev]);
  };

  // F9 Delete — AS-IS L275~ DeleteButton (신규 'I' 행만 제거 가능)
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as FuturePriceRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({ type: 'alert', content: '신규 입력 행만 삭제할 수 있습니다.' });
      return;
    }
    setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // F7 Save — AS-IS L1551~ SaveData (Validation + ^ 구분 join + SP 호출)
  const handleSave = async () => {
    const all = [...insertedRows, ...(((data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? []) as FuturePriceRow[])];
    const v = validate.validateSaveRows(all, sc);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: '[MSG00004] 저장하시겠습니까?' });
    if (!ok) return;

    try {
      // P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL — 17 IN (^ 구분 join)
      // 본 단계는 메타 등록 단계 — SP 호출은 후속 phase 보강
      await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, {
        divisionId: sc.divisionId,
        // TODO: 17 IN ^ join (rows → ^ delim string)
      });
      void setAlert({ type: 'alert', content: '[MSG00020] 저장되었습니다.' });
      setInsertedRows([]);
      refetch?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : '[MSG00284] 저장 중 오류가 발생했습니다.';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // F2 Edit — AS-IS L876~ EditButton (Version 가드 + 복사 대상 선택)
  const handleEdit = () => {
    const g = gridRef.current;
    const sel = g?.selectedItems[0] as FuturePriceRow | undefined;
    const v = validate.validateEdit(sel, sc);
    if (!v.ok) return;
    // Edit mode 진입 — 새 신규 행 추가 (선택 row 복사)
    if (sel) {
      const copy: FuturePriceRow = { ...sel, CRUD_TYPE: 'I' };
      setInsertedRows(prev => [copy, ...prev]);
    }
  };

  // Button 10대 = CRUD 6 + Search Aux 4 (룰 25 §1.5.1, §1.5.3)
  //   F5 Search / F7 Save / F8 Insert / F9 Delete / Excel (SubTitle 자동)
  //   F3 Sort / F4 Filter (자동 — `allowSorting=true` + `gridFilter` ref 생략)
  //   F6 Condition (UsrConditionPanel 0건 → false, 메모리 feedback_search_aux_default_activation)
  //   F10 Reset Condition (false)
  //   F2 Edit: HotkeyConfig 미지원 (`_F2_Unused`) → actionBar 의 Edit 버튼으로 별도 노출
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  // Cell dblClick — popup cell (FPModal) 분기 (룰 12 §11.7)
  const [clickedRow, setClickedRow] = useState<number | null>(null);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);

  const handleCellDoubleClick = (_g: FlexGridType<FuturePriceRow>, row: number, col: number) => {
    const g = _g;
    const dataItem = g.rows[row]?.dataItem as FuturePriceRow | undefined;
    const binding = g.columns[col]?.binding;
    if (!dataItem || !binding) return;

    const meta = MAIN_COLUMNS.find(c => c.key === binding);
    if (!meta || meta._ctrlType !== 'FPModal') return;

    const isInsert = dataItem.CRUD_TYPE === 'I';
    if (!isInsert) return;   // 신규 행에서만 popup

    setClickedRow(row);
    setClickedBinding(binding);
    // TODO: meta._modalKey 분기 (Project / Item / Owner) — 공용 modal 호출
  };

  // SP 결과 + 신규 행 결합
  const spRows = (((data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? []) as FuturePriceRow[]);
  const rows: FuturePriceRow[] = [...insertedRows, ...spRows];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <SalesFuturePriceForm
          onSearch={handleSearch}
          onVersionOpen={() => setOpenVersion(true)}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesFuturePrice'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      {/* 기능 버튼 바 — Edit(F2 대체) / Price 일괄입력 / Exchange Rate / Batch / Column Setting / Range / Template (ESS only) */}
      <div className={styles.actionBar}>
        <button type='button' onClick={handleEdit} className={styles.actionBtn}>Edit (F2 대체)</button>
        <button type='button' onClick={() => setOpenBatch(true)} className={styles.actionBtn}>Price 일괄입력</button>
        <button type='button' onClick={() => setOpenExchange(true)} className={styles.actionBtn}>Exchange Rate</button>
        <button type='button' onClick={() => setOpenRange(true)} className={styles.actionBtn}>Sales Price Range</button>
        {role.showTemplate && (
          <button type='button' onClick={() => setOpenTemplate(true)} className={styles.actionBtn}>Excel Template</button>
        )}
        <button type='button' onClick={() => setOpenTitleSet(true)} className={styles.iconBtn} title='Grid Column Setting'>⚙</button>
        <span className={styles.divHint}>Div: {sc.divisionId} {role.isEss && '(ESS)'}</span>
      </div>

      <SalesFuturePriceFlexGrid
        rows={rows}
        titleDate={titleDate}
        bucketType={sc.bucketType}
        selectedGroupKey={selectedGroupKey}
        gridRef={gridRef}
        onSelectGroup={setSelectedGroupKey}
        onCellDoubleClick={handleCellDoubleClick}
      />

      {/* POPUP 6종 */}
      <ExchangeRateModal
        open={openExchange}
        modalClose={() => setOpenExchange(false)}
        defaultDivision={sc.divisionId}
        defaultPeriod={{ start: sc.startYyyymmdd.slice(0, 6), end: sc.endYyyymmdd.slice(0, 6) }}
      />
      <PriceBatchInputModal
        open={openBatch}
        modalClose={() => setOpenBatch(false)}
        defaultDivision={sc.divisionId}
        defaultPeriod={{ start: sc.startYyyymmdd, end: sc.endYyyymmdd }}
        onSaveResult={() => refetch?.()}
      />
      <SalesPriceVersionModal
        open={openVersion}
        modalClose={() => setOpenVersion(false)}
        defaultDivision={sc.divisionId}
        onApply={vIds => useSalesFuturePriceStore.getState().setSearchCondition({ versionId: vIds })}
      />
      <ColumnTitleSetModal
        open={openTitleSet}
        modalClose={() => setOpenTitleSet(false)}
        onSave={() => { /* TODO: SCM_USR_TITLE_SET 영구 저장 */ }}
      />
      <SalesPriceRangeModal
        open={openRange}
        modalClose={() => setOpenRange(false)}
        defaultDivision={sc.divisionId}
        defaultPeriod={{ start: sc.startYyyymmdd, end: sc.endYyyymmdd }}
      />
      <SalesPriceTemplateModal
        open={openTemplate}
        modalClose={() => setOpenTemplate(false)}
        defaultDivision={sc.divisionId}
      />
    </div>
  );
};
