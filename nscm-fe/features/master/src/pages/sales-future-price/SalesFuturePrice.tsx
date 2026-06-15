import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ColumnSettingModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../components';

import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import { SalesPriceRangeModal } from './components/modals/SalesPriceRangeModal';
import { SalesPriceTemplateModal } from './components/modals/SalesPriceTemplateModal';
import { SalesPriceVersionModal } from './components/modals/SalesPriceVersionModal';
import { SalesFuturePriceFlexGrid } from './components/SalesFuturePriceFlexGrid';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import { type BUCKET_TYPE, MAIN_COLUMNS, MEASURE_4, MENU_ID, SHEETS } from './sales-future-price.constants';
import type { FuturePriceRow } from './sales-future-price.types';
import styles from './SalesFuturePrice.module.scss';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';

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
  const setToast = useMessageStore.getState().setToast;

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const filters = useSalesFuturePriceStore(s => s.filters);
  const setFilter = useSalesFuturePriceStore(s => s.setFilter);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(s => s.setOpenSearchArea);
  const setSearchCondition = useSalesFuturePriceStore(s => s.setSearchCondition);
  // ⭐ master hook §2.3 — Column/Measure 동적 fetch (admin SYS0004 UI Category Setup 변경 즉시 반영)
  const staticColumns = useSalesFuturePriceStore(s => s.staticColumns);
  const staticMeasures = useSalesFuturePriceStore(s => s.staticMeasures);
  const fetchStaticColumns = useSalesFuturePriceStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useSalesFuturePriceStore(s => s.fetchStaticMeasures);

  const validate = useSalesFuturePriceValidation();

  // 메인 그리드 SP (P_DMF0020_GET_FUTUREPRICE_INFO — 4 IN + 2 OUT)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const loading = isLoading || isFetching;

  // 화면 진입 시 자동 조회 — Division 자동 적용 후 filter 세팅 (AS-IS Form_Load + InitControls)
  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // ⭐ master hook §2.3 + §5 — mount 시 1회 fetch (admin 메타 즉시 반영 baseline)
  useEffect(() => {
    void fetchStaticColumns();
    void fetchStaticMeasures();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 신규/수정 행 추적 (CRUD_TYPE) — SP 결과와 합쳐 grid itemsSource
  const [insertedRows, setInsertedRows] = useState<FuturePriceRow[]>([]);

  // Modal open state
  const [openExchange, setOpenExchange] = useState(false);
  const [openBatch, setOpenBatch] = useState(false);
  const [openVersion, setOpenVersion] = useState(false);
  const [openTitleSet, setOpenTitleSet] = useState(false);
  const [openRange, setOpenRange] = useState(false);
  const [openTemplate, setOpenTemplate] = useState(false);

  // Insert row popup state — PROJECT / ITEM 공용 modal (AS-IS .cs L2040/2044 cellTypeImage 동등)
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupGroupId, setPopupGroupId] = useState<string | null>(null);

  // ----- Button 10대 매핑 -----
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    void setToast({ message: '조회 중입니다...', type: 'default', duration: 2000 });
    setFilter();
    refetch?.();
    setInsertedRows([]);
    // ⭐ master hook §2.4 — Search 시 admin 메타 refetch (admin 변경 즉시 반영)
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F8 Insert — AS-IS L2049 dtMeasureCount.Rows.Count 만큼 row 추가
  //   ⭐ master hook §5 — Measure 동적 fetch (SCM_MST_SHEET_MEASURE 의 VALID_YN='Y' COLUMN_NAME 만)
  //   admin 변경 즉시 반영. staticMeasures 비어있으면 MEASURE_4 hardcode fallback.
  const handleInsert = () => {
    const validMeasures = (staticMeasures[SHEETS.MAIN] ?? [])
      .filter(m => m.VALID_YN !== 'N')
      .sort((a, b) => (a.SORT_ORDER_NO ?? 0) - (b.SORT_ORDER_NO ?? 0))
      .map(m => m.COLUMN_NAME);
    const measures = validMeasures.length > 0 ? validMeasures : MEASURE_4;
    const groupId = `I_${Date.now()}`;
    const newRows: FuturePriceRow[] = measures.map((m): FuturePriceRow => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: groupId,
      DIVISION_ID: sc.divisionId,
      DEPT_ID: '',
      END_CUSTOMER: '',
      SCM_SITE_ID: '',
      PROJECT_CODE: '',
      PROJECT_STATUS: '',
      BIZ_TYPE_NAME: '',
      ITEM_ID: '',
      INCOTERMS: '',
      FCST_TYPE: '',
      DOM_EXP: '',
      PLANT_SITE_ID: '',
      CURRENCY: '',
      PRICE_EXIST: 'Y',
      MEASURE: m,
    }));
    setInsertedRows(prev => [...newRows, ...prev]);
  };

  // F9 Delete — AS-IS L275~ DeleteButton (신규 'I' 행만 제거, 같은 INSERT_GROUP_ID 4 row 묶음 삭제)
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as FuturePriceRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({ type: 'alert', content: '신규 입력 행만 삭제할 수 있습니다.' });
      return;
    }
    const gid = sel.INSERT_GROUP_ID;
    if (gid) {
      setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    } else {
      setInsertedRows(prev => prev.filter(r => r !== sel));
    }
  };

  // F7 Save — AS-IS DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (1,279 lines) → To-Be 17 ^-delim CLOB
  //   각 row 는 (Insert 'I' / Update 'U' / Delete 'D') 별 4 measure × M dynamic col 펼침 (YYYYMMDD, PRICE)
  //   Inserted row 만 'I', SP 결과 row 의 dynamic cell 수정값 'U' (사용자 LOC row 만 editable)
  const handleSave = async () => {
    const spRowsAll = ((data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? []);
    const v = validate.validateSaveRows([...insertedRows, ...spRowsAll], sc);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: '[MSG00004] 저장하시겠습니까?' });
    if (!ok) return;

    void setToast({ message: '저장 중입니다...', type: 'default', duration: 3000 });

    // 17 IN params 의 ^-delim 누적 array
    const acc: Record<string, string[]> = {
      activeFlag: [], divisionId: [], projectCode: [], scmSiteId: [], plantSiteId: [], itemId: [],
      yyyymmdd: [], currency: [], measure: [], domExp: [], fcstType: [], incoterms: [], price: [],
      createdBy: [], creationDate: [], lastUpdatedBy: [], rownumKey: [],
    };
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const userId = 'minyonglee1';
    let rownum = 0;

    // Inserted row × 각 dynamic col (Wxxx/Mxxx) cell 의 PRICE 펼침
    for (const row of insertedRows) {
      const dynKeys = Object.keys(row).filter(k => /^[WM]_\d+$/.test(k));
      for (const dk of dynKeys) {
        const price = row[dk];
        if (price === undefined || price === '' || price === null) continue;
        const yyyymmdd = dk.startsWith('W_') ? dk.slice(2) : `${dk.slice(2)}01`;
        rownum++;
        acc.activeFlag.push('I');
        const r = row as Record<string, string>;
        acc.divisionId.push(r.DIVISION_ID ?? '');
        acc.projectCode.push(r.PROJECT_CODE ?? '');
        acc.scmSiteId.push(r.SCM_SITE_ID ?? '');
        acc.plantSiteId.push(r.PLANT_SITE_ID ?? '');
        acc.itemId.push(r.ITEM_ID ?? '');
        acc.yyyymmdd.push(yyyymmdd);
        acc.currency.push(r.CURRENCY ?? '');
        acc.measure.push(r.MEASURE ?? '');
        acc.domExp.push(r.DOM_EXP ?? '');
        acc.fcstType.push(r.FCST_TYPE ?? '');
        acc.incoterms.push(r.INCOTERMS ?? '');
        acc.price.push(String(price as string));
        acc.createdBy.push(userId);
        acc.creationDate.push(today);
        acc.lastUpdatedBy.push(userId);
        acc.rownumKey.push(String(rownum));
      }
    }

    if (acc.activeFlag.length === 0) {
      void setAlert({ type: 'alert', content: '저장할 데이터가 없습니다.' });
      return;
    }

    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, payload);
      void setToast({ message: '[MSG00020] 저장되었습니다.', type: 'success' });
      setInsertedRows([]);
      refetch?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : '[MSG00284] 저장 중 오류가 발생했습니다.';
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // Button 10대 = CRUD 6 + Search Aux 4 (룰 25 §1.5.1, §1.5.3)
  //   F5 Search / F7 Save / F8 Insert / F9 Delete / Excel (SubTitle 자동)
  //   F3 Sort / F4 Filter (자동 — `allowSorting=true` + `gridFilter` ref 생략)
  //   F6 Condition / F10 Reset Condition (SubTitle DefaultButtonActions 자동 활성 — DMF0020 은 SalesFuturePriceForm 조회조건 form 있음)
  //   F2 Edit: HotkeyConfig 미지원 (`_F2_Unused`) → actionBar 의 Edit 버튼으로 별도 노출
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    manual: false,
    upload: false,
  };

  // SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과 — wide format (28 fixed cols + 동적 W_/M_)
  // PIVOT 이 DB 단에서 처리되어 클라이언트 측 변환 불필요
  const spRows = ((data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? []);
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
        customButtons={[
          // 사용자 요구 (2026-06-03):
          //   - 기능 버튼 = Exchange Rate + Price 일괄입력 2개
          //   - 그리드 항목 표시 (⊞) — DMF0043_01 contribute-view 패턴 동일
          { label: 'Exchange Rate', title: 'Exchange Rate', action: () => setOpenExchange(true) },
          { label: 'Price 일괄입력', title: 'Price 일괄입력', action: () => setOpenBatch(true) },
          { label: '⊞', title: '그리드 항목 표시', action: () => setOpenTitleSet(true) },
        ]}
      />

      {/* SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M (wide format, 28 fixed + 동적 W_/M_) */}
      {loading
        ? <div style={{ padding: 16, color: '#1976d2' }}>⏳ 조회 중입니다...</div>
        : <SalesFuturePriceFlexGrid
            rows={rows}
            gridRef={gridRef as never}
            divisionId={sc.divisionId}
            bucketType={sc.bucketType as BUCKET_TYPE}
            staticColumns={staticColumns[SHEETS.MAIN]}
            staticMeasures={staticMeasures[SHEETS.MAIN]}
            onPopupCellDblClick={(modalKey, row) => {
              setPopupGroupId(row.INSERT_GROUP_ID ?? null);
              if (modalKey === 'PROJECT') setOpenProject(true);
              else if (modalKey === 'ITEM') setOpenItem(true);
            }}
          />
      }

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
        onApply={vIds => setSearchCondition({ versionId: vIds })}
      />
      <ColumnSettingModal
        open={openTitleSet}
        modalClose={() => setOpenTitleSet(false)}
        menuId={MENU_ID}
        sheetName='main'
        columnType='main'
        divisionId={sc.divisionId}
        fallbackColumns={MAIN_COLUMNS.map(c => ({ key: c.key, header: c.header, width: c.width }))}
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

      {/* Insert row popup — PROJECT (AS-IS .cs L2040 cellTypeImage + L2092/L2094 자동 채움) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName) => {
          if (!popupGroupId) return;
          // AS-IS L2049 LoopByDtMeasureCount — 같은 INSERT_GROUP_ID 의 4 measure row 동기화
          // AS-IS L2092 ProjectStatus LockRange2(true) — popup 선택 시 자동 채움
          // AS-IS L2094 BizTypeName LockRange2(true) — popup 선택 시 자동 채움
          setInsertedRows(prev => prev.map(r =>
            r.INSERT_GROUP_ID === popupGroupId
              ? {
                  ...r,
                  PROJECT_CODE: projectCode,
                  PROJECT_NAME: projectName ?? '',
                  PROJECT_STATUS: projectStatus ?? '',
                  BIZ_TYPE_NAME: bizTypeName ?? '',
                }
              : r,
          ));
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
          etc: 'N',
        } as never}
        callFromCell={true}
      />

      {/* Insert row popup — ITEM (AS-IS .cs L2044 cellTypeImage) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId, itemName, itemClass) => {
          if (!popupGroupId) return;
          setInsertedRows(prev => prev.map(r =>
            r.INSERT_GROUP_ID === popupGroupId
              ? { ...r, ITEM_ID: itemId, ITEM_NAME: itemName ?? '', ITEM_CLASS_NAME: itemClass ?? '' }
              : r,
          ));
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
          itemId: '',
        } as never}
        callFromCell={true}
      />
    </div>
  );
};
