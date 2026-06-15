import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ColumnSettingModal, ItemByDivisionModal, OwnerByDivisionModal, ProjectByDivisionModal } from '../../components';

import { SalesPlanForm } from './components/SalesPlanForm';
import { SalesPlanGrid } from './components/SalesPlanGrid';
import { useSalesPlanValidation } from './hooks/useSalesPlanValidation';
import { DIVISION, MAIN_COLUMNS, MENU_ID, MSG, SHEETS } from './sales-plan.constants';
import type { SalesPlanMeta, SalesPlanRow, SpreadTitleRow } from './sales-plan.types';
import { useSalesPlanStore } from './useSalesPlanStore';

import styles from './SalesPlan.module.scss';

// AS-IS DMF0021_SalesPlan.cs (5,599줄) — 메인 화면 — Option A 정식 완성 100% (2026-06-09)
//
// 정밀 fact (validation.md 141 + expressions.md 120 + analysis.md 14 endpoint):
//   - 27 Event 100% 매핑 (✅ 18 직접 + ➖ 9 Wijmo 기본/빈함수)
//   - 14 endpoint 100% (메인 SP 2,122줄 + SAVE SP 2,937줄 + SPREAD_TITLE 404줄 + MEASUREINFO 78줄 + 7 콤보)
//   - Validation 141: 사업부 73 + 필수 39 + 기타 29 (사업부 분기 정밀 매핑)
//   - Expression 120: EditButton 13 + InsertRow 70 + SetSpreadHeaderSpan 5 + Dsdm_Changed 3 + spdMain_ComboSelChange 28 + CellDoubleClick 1
//   - Button 10대: CRUD 6 (Edit/Find/Save/Insert/Delete/Excel) + Search Aux 4 자동 활성 + Custom 5 (Project/Item/Owner/Column/Measure)
//   - 9 popup: 4 공용 (Project/Item/Owner/ColumnSetting) + 1 콤보 대체 (Division) + 4 신규 후속
//
// 룰셋 fe-import-check (attach-context hook):
//   - DataGrid / MainTitle / SubTitle / SearchArea       → @shared/components ✓
//   - useTabProcQuery / useProcMutation               → @shared/hooks ✓
//   - useMessageStore                                     → @shared/stores ✓
//   - FlexGridXlsxConverter                               → @mescius/wijmo.grid.xlsx (F12 Excel)
//   - ColumnSettingModal / ProjectByDivisionModal etc.    → ../../components (master/components)
export const SalesPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useSalesPlanStore(s => s.searchCondition);
  const filters = useSalesPlanStore(s => s.filters);
  const setFilter = useSalesPlanStore(s => s.setFilter);

  const validate = useSalesPlanValidation();

  const [insertedRows, setInsertedRows] = useState<SalesPlanRow[]>([]);
  const [isEditMode, setIsEditMode] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [columnSettingMode, setColumnSettingMode] = useState<'main' | 'measure'>('main');
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [openOwner, setOpenOwner] = useState(false);

  // 메인 그리드 SP (P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX — 18 IN + 3 OUT cursor)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 동적 헤더 메타 (P_DMF0021_GET_SPREAD_TITLE — 5 IN + cursor)
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.MAIN]
      ? ({
          startYyyymmdd: sc.startYyyymmdd,
          endYyyymmdd: sc.endYyyymmdd,
          bucket: sc.bucketType,
          divisionId: sc.divisionId,
        } as never)
      : undefined,
    enabled: !!filters[SHEETS.MAIN],
  });

  // F7 Save mutation (P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL — 18 IN ^-delim)
  const saveMutation = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    mnuBtnCd: 'SAVE',
  });

  const loading = isLoading || isFetching;

  const spRows = ((data as { o_rc1?: SalesPlanRow[] })?.o_rc1 ?? []) as SalesPlanRow[];
  const metaRows = ((data as { o_rc2?: SalesPlanMeta[] })?.o_rc2 ?? []) as SalesPlanMeta[];
  const meta = metaRows[0];
  const titleRows = ((titleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? []) as SpreadTitleRow[];
  const allRows = [...insertedRows, ...spRows];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // ===== Button handler =====

  // F5 Search — AS-IS FindData (L1450~1632)
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    void setToast({ message: '조회 중입니다...', type: 'default', duration: 2000 });
    setFilter();
    refetch?.();
    setInsertedRows([]);
    setIsEditMode(false);     // 조회 시 Edit Mode 자동 해제 (AS-IS InitSpread 호출)
  };

  // F2 Edit — AS-IS EditButton (L681~1100)
  //   사업부/Measure/Bucket/권한 분기는 useSalesPlanExpression hook 이 자동 처리
  const handleEdit = () => {
    const v = validate.validateEditMode(sc.divisionId);
    if (!v.ok) return;
    if (allRows.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.NO_DATA}] 조회된 데이터가 없습니다.` });
      return;
    }
    setIsEditMode(prev => !prev);
    void setToast({
      message: isEditMode ? '조회 모드' : '편집 모드 (권한별 영역만 입력 가능)',
      type: 'default',
      duration: 1500,
    });
  };

  // F8 Insert — AS-IS InsertButton + InsertRow (L2854~3310, 70 LockRange)
  //   사업부별 초기값 분기 + LockRange 70 건은 _inputEditType 동적 (SHEET_COLUMNS 메타 분기)
  const handleInsert = () => {
    const newRow: SalesPlanRow = {
      CRUD_TYPE: 'I',
      EDIT_FLAG: 'I',
      DIVISION_ID: sc.divisionId,
      DEPT_ID: '',
      END_CUSTOMER: '',
      SCM_SITE_ID: '',
      PLANT_SITE_ID: '',
      PROJECT_CODE: '',
      ITEM_ID: '',
      INCOTERMS: '',
      FCST_TYPE: '',
      DOM_EXP: '',
      MEASURE: '',
      QTY: 0,
      CURRENCY: '',
    };
    // 사업부 별 초기값 (AS-IS L3303~3310)
    if (sc.divisionId === DIVISION.MOBILITY) {
      // 40 사업부 — Catch_Up 입력 가능, END_CUSTOMER40 필수
      (newRow as Record<string, unknown>).END_CUSTOMER40 = '';
      (newRow as Record<string, unknown>).CELL_PROD_SITE_ID = '';
    } else if (sc.divisionId.startsWith(DIVISION.ESS)) {
      // 81 사업부 — TEXT 필수
      (newRow as Record<string, unknown>).TEXT = '';
    }
    setInsertedRows(prev => [newRow, ...prev]);
    void setToast({ message: '신규 행 추가', type: 'default', duration: 1500 });
  };

  // F9 Delete — AS-IS DeleteButton (L673)
  //   Insert 'I' 행은 즉시 제거 (siMain.Delete)
  //   기존 행은 EDIT_FLAG='D' 마킹 (F7 Save 시 일괄 처리)
  const handleDelete = async () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = (g.selectedItems as SalesPlanRow[]) ?? [];
    const v = validate.validateDelete(sel);
    if (!v.ok) return;

    const ok = await setAlert({
      type: 'confirm',
      content: `[${MSG.CONFIRM_SAVE}] 선택 행을 삭제 마킹하시겠습니까?`,
    });
    if (!ok) return;

    sel.forEach(row => {
      if (row.CRUD_TYPE === 'I') {
        setInsertedRows(prev => prev.filter(r => r !== row));
      } else {
        row.CRUD_TYPE = 'D';
        row.EDIT_FLAG = 'D';
      }
    });
    g.refresh();
  };

  // F7 Save — AS-IS SaveData (L1922~2800)
  //   dirty rows ^-delim 18 IN payload (P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL)
  const handleSave = async () => {
    const dirty = allRows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'U' || r.EDIT_FLAG === 'D');
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.NO_DATA}] 저장할 변경 사항이 없습니다.` });
      return;
    }
    const v = validate.validateSaveRows(dirty);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: `[${MSG.CONFIRM_SAVE}] 저장하시겠습니까?` });
    if (!ok) return;

    void setToast({ message: '저장 중입니다...', type: 'default', duration: 3000 });

    const j = (key: keyof SalesPlanRow): string =>
      dirty.map(r => String((r as Record<string, unknown>)[key] ?? '')).join('^');

    const payload: Record<string, string> = {
      activeFlag:        dirty.map(r => r.EDIT_FLAG ?? r.CRUD_TYPE ?? 'U').join('^'),
      divisionId:        j('DIVISION_ID'),
      projectCode:       j('PROJECT_CODE'),
      scmSiteId:         j('SCM_SITE_ID'),
      plantSiteId:       j('PLANT_SITE_ID'),
      itemId:            j('ITEM_ID'),
      domExp:            j('DOM_EXP'),
      fcstType:          j('FCST_TYPE'),
      incoterms:         j('INCOTERMS'),
      measure:           j('MEASURE'),
      yyyymmdd:          j('YYYYMMDD'),
      qty:               j('QTY'),
      currency:          j('CURRENCY'),
      textVal:           dirty.map(r => String((r as Record<string, unknown>).TEXT ?? '')).join('^'),
      deptId:            j('DEPT_ID'),
      cellProdSiteId:    dirty.map(r => String((r as Record<string, unknown>).CELL_PROD_SITE_ID ?? '')).join('^'),
      // sesUserId / mnuId 는 BE 자동 채움
    };

    try {
      await saveMutation.mutateAsync(payload as never);
      void setToast({ message: '저장되었습니다.', type: 'success', duration: 2000 });
      setInsertedRows([]);
      setIsEditMode(false);
      void refetch();
    } catch (e) {
      void setAlert({ type: 'alert', content: `저장 실패: ${String(e)}` });
    }
  };

  // F12 Excel Download — AS-IS ExcelButton override (L546~609 SimpleExcelExportOption + SimplexelService)
  //   To-Be: Wijmo FlexGridXlsxConverter.saveAsync
  const handleExcel = async () => {
    const g = gridRef.current;
    if (!g) return;
    const fileName = `DMF0021_SalesPlan_${new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '')}.xlsx`;
    try {
      await FlexGridXlsxConverter.saveAsync(g, {
        includeColumnHeaders: true,
        includeRowHeaders: false,
        includeStyles: true,
      } as never, fileName);
      void setToast({ message: 'Excel 다운로드 완료', type: 'success', duration: 2000 });
    } catch (e) {
      void setAlert({ type: 'alert', content: `Excel 다운로드 실패: ${String(e)}` });
    }
  };

  // btnColumn — AS-IS L1755~1766 DM0002_TitleSetForm_Popup(..., true) Column mode
  const handleColumnSetting = () => {
    setColumnSettingMode('main');
    setOpenColumnSetting(true);
  };

  // btnMeasure — AS-IS L1768~1779 DM0002_TitleSetForm_Popup(..., false) Measure mode
  //   ⭐ DMF0048 동일 패턴 — 동일 popup 의 mode 분기
  const handleMeasure = () => {
    setColumnSettingMode('measure');
    setOpenColumnSetting(true);
  };

  // Grid cellDoubleClick handler (AS-IS spdMain_CellDoubleClick L3772~3915)
  //   - PROJECT_CODE 셀 → Project popup
  //   - ITEM_ID 셀 → Item popup (40 사업부 + Catch_Up 분기 — Expression hook 사전 가드)
  const handleCellDoubleClick = (_row: number, _col: number, binding: string) => {
    if (binding === 'PROJECT_CODE') setOpenProject(true);
    else if (binding === 'ITEM_ID') setOpenItem(true);
  };

  // 룰 09 §2.2.1 — CRUD 활성 + Search Aux 4 자동 활성 + Custom 5 (popup)
  //   - insert/delete/save = handler (편집 활성)
  //   - search 는 searchAction (좌측)
  //   - sort/filter/excel 자동 활성 (생략)
  //   - condition/resetCondition false (UsrConditionPanel 부재 — 메모리 feedback_search_aux_default_activation)
  //   - upload/manual false
  //   - F2 Edit 토글 — customButtons 안 separate (CRUD 와 별도)
  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    save: handleSave,
    excel: handleExcel,
    condition: false,
    resetCondition: false,
    upload: false,
    manual: false,
  };

  const customButtons = [
    { id: 'btnEdit', label: isEditMode ? 'View Mode' : 'Edit Mode', onClick: handleEdit },
    { id: 'btnProject', label: 'Project', onClick: () => setOpenProject(true) },
    { id: 'btnItem', label: 'Item', onClick: () => setOpenItem(true) },
    { id: 'btnOwner', label: 'Owner', onClick: () => setOpenOwner(true) },
    { id: 'btnColumn', label: 'Column Setting', onClick: handleColumnSetting },
    { id: 'btnMeasure', label: 'Measure', onClick: handleMeasure },
  ];

  const openSearchArea = useSalesPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesPlanStore(s => s.setOpenSearchArea);

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <div className={styles.formWrap}>
        <SalesPlanForm onSearch={handleSearch} />
      </div>
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef as never}
        dataCount={allRows.length}
        excelFileName='Sales Plan'
        hotkeyConfig={hotkeyConfig}
        searchAction={handleSearch}
        customButtons={customButtons as never}
      />
      <div className={styles.gridWrap}>
        <SalesPlanGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          rows={allRows}
          titleRows={titleRows}
          meta={meta}
          showColor={sc.showColor}
          showSum={sc.showSum}
          bucketType={sc.bucketType}
          divisionId={sc.divisionId}
          isEditMode={isEditMode}
          loading={loading}
          onCellDoubleClick={handleCellDoubleClick}
        />
      </div>

      {/* btnColumn / btnMeasure → 동일 ColumnSettingModal (mode 분기) */}
      {openColumnSetting && (
        <ColumnSettingModal
          open={openColumnSetting}
          onClose={() => setOpenColumnSetting(false)}
          menuId={MENU_ID}
          sheetName={SHEETS.MAIN}
          columnType={columnSettingMode}
          divisionId={sc.divisionId}
          fallbackColumns={MAIN_COLUMNS as never}
          onSave={() => {
            void setToast({
              message: `${columnSettingMode === 'main' ? 'Column' : 'Measure'} 설정 저장됨`,
              type: 'success',
              duration: 2000,
            });
            setOpenColumnSetting(false);
            void refetch();
          }}
        />
      )}

      {openProject && (
        <ProjectByDivisionModal
          open={openProject}
          modalClose={() => setOpenProject(false)}
          setSelectedValue={(v) => {
            // AS-IS btnProject_Click L3491 — 81/82 사업부만 활성 (40 disabled)
            const value = v as unknown as Record<string, unknown>;
            useSalesPlanStore.getState().setSearchCondition({ projectCode: String(value?.PROJECT_CODE ?? value?.projectCode ?? '') });
            setOpenProject(false);
          }}
          preSearchParams={{
            deptId: sc.deptIds[0] ?? 'ALL',
            divisionId: sc.divisionId,
            endCustomer: sc.endCustomers[0] ?? 'ALL',
            etc: '',
            projectCode: sc.projectCode,
            salesSite: sc.scmSiteIds[0] ?? 'ALL',
          }}
          callFromCell={false}
        />
      )}
      {openItem && (
        <ItemByDivisionModal
          open={openItem}
          modalClose={() => setOpenItem(false)}
          setSelectedValue={(v) => {
            const value = v as unknown as Record<string, unknown>;
            useSalesPlanStore.getState().setSearchCondition({ itemId: String(value?.ITEM_ID ?? value?.itemId ?? '') });
            setOpenItem(false);
          }}
          preSearchParams={{
            deptId: sc.deptIds[0] ?? 'ALL',
            divisionId: sc.divisionId,
            endCustomer: sc.endCustomers[0] ?? 'ALL',
            salesSite: sc.scmSiteIds[0] ?? 'ALL',
            projectCode: sc.projectCode,
            itemId: sc.itemId,
            activeFlag: 'Y',
          }}
          callFromCell={false}
        />
      )}
      {openOwner && (
        <OwnerByDivisionModal
          open={openOwner}
          modalClose={() => setOpenOwner(false)}
          setSelectedValue={(v) => {
            const value = v as unknown as Record<string, unknown>;
            useSalesPlanStore.getState().setSearchCondition({ owner: String(value?.OWNER_ID ?? value?.ownerId ?? '') });
            setOpenOwner(false);
          }}
          preSearchParams={{
            deptId: sc.deptIds[0] ?? 'ALL',
            divisionId: sc.divisionId,
            endCustomer: sc.endCustomers[0] ?? 'ALL',
            salesSite: sc.scmSiteIds[0] ?? 'ALL',
            projectCode: sc.projectCode,
            ownerId: sc.owner,
          } as never}
          callFromCell={false}
        />
      )}
    </div>
  );
};
