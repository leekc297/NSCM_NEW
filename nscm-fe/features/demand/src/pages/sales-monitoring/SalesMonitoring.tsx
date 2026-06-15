import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ColumnSettingModal } from '../../components';

import { SalesMonitoringForm } from './components/SalesMonitoringForm';
import { SalesMonitoringGrid } from './components/SalesMonitoringGrid';
import { useSalesMonitoringValidation } from './hooks/useSalesMonitoringValidation';
import { MAIN_COLUMNS, MENU_ID, MSG, SHEETS } from './sales-monitoring.constants';
import type { SalesMonitoringMeta, SalesMonitoringRow, SpreadTitleRow } from './sales-monitoring.types';
import { useSalesMonitoringStore } from './useSalesMonitoringStore';

import styles from './SalesMonitoring.module.scss';

// AS-IS DMF0048_SalesMonitoring.cs (2,181줄) — 메인 화면
//
// 정밀 fact (Option A 정정 — 2026-06-08):
//   - 21 Event / 2 PKG SP + 콤보 7 + 공통 4 / 23 Validation / 7 Expression
//   - Sheet 1 (shtMain "Sales Monitoring") / 51 cols (5 DefColumns 그룹)
//   - ⚠️ 이전 "read-only" 판단 정정: 실제 D_ 컬럼 편집 가능 (Dsdm_Changed L1390~1544)
//     + Save 시 fnValidation 중복 PK 검증 (L1600~1726, Division 81/82/40 분기)
//   - Popup: DM0002_TitleSetForm_Popup 1 종 (btnColumn 'true' / btnMeasure 'false' 동일 popup, mode 만 분기)
//   - spdMain_CellDoubleClick (L1385~1388) **빈 함수** — wiring 제거 (AS-IS 동작 X)
//   - btnProject_Click (L1082) — Division 81/82 일 때만 popup 호출 (40 일 때 disabled)
//   - btnItemId_Click (L1101) — 항상 호출 가능
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0048_SalesMonitoring/ (8 MD)
//   - __asis-mapping__.md: 본 폴더 (4축 100%)
//
// 룰셋 fe-import-check (attach-context hook 2026-06-08):
//   - DataGrid / MainTitle / SubTitle / SearchArea       → @shared/components ✓
//   - useTabProcQuery / useProcMutation               → @shared/hooks ✓
//   - useMessageStore / useSessionStore                   → @shared/stores ✓
//   - FlexGridXlsxConverter                               → @mescius/wijmo.grid.xlsx (F12 Excel)
//   - ColumnSettingModal / ProjectByDivisionModal         → ../../components (master/components)
export const SalesMonitoring = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesMonitoringRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useSalesMonitoringStore(s => s.searchCondition);
  const filters = useSalesMonitoringStore(s => s.filters);
  const setFilter = useSalesMonitoringStore(s => s.setFilter);

  const validate = useSalesMonitoringValidation();

  // Modal open state — btnColumn / btnMeasure (AS-IS 동일 popup, mode 만 분기)
  //   AS-IS L1755 btnColumn_Click: DM0002_TitleSetForm_Popup(sProgram_Id, sheet, true)  → columnType='main'
  //   AS-IS L1768 btnMeasure_Click: DM0002_TitleSetForm_Popup(sProgram_Id, sheet, false) → columnType='measure'
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [columnSettingMode, setColumnSettingMode] = useState<'main' | 'measure'>('main');

  // 신규 행 추적 (현재 read-only 기준이지만 AS-IS 는 D_ 편집 가능 — Save 활성 시 useState 필요)
  const [insertedRows, _setInsertedRows] = useState<SalesMonitoringRow[]>([]);

  // 메인 그리드 SP (P_DMF0048_GET_DM_PLN_SALES_MONITORING — 22 IN + 3 OUT cursor)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 동적 헤더 메타 (P_DMF0048_GET_SPREAD_TITLE — 6 IN + dual OUT, standalone SP)
  //   ⭐ 2026-06-07 standalone 분리 — API_URL = 'P_DMF0048_GET_SPREAD_TITLE'
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
          // sesUserId / mnuId 는 BE 자동 채움
        } as never)
      : undefined,
    enabled: !!filters[SHEETS.MAIN],
  });

  // F7 Save mutation (AS-IS SaveData — D_ 편집 cell 일괄 저장)
  //   ⚠️ 본 화면 SAVE SP 가 PKG body 에 미정의 (확인 필요). 메타 SQL 에 SAVE API_M 없음.
  //   현재 wiring 만, 실 동작은 SAVE SP 추가 등록 후 활성.
  const _saveMutation = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    mnuBtnCd: 'SAVE',
  });

  const loading = isLoading || isFetching;

  const spRows = ((data as { o_rc1?: SalesMonitoringRow[] })?.o_rc1 ?? []) as SalesMonitoringRow[];
  const metaRows = ((data as { o_rc2?: SalesMonitoringMeta[] })?.o_rc2 ?? []) as SalesMonitoringMeta[];
  const meta = metaRows[0];
  const titleRows = ((titleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? []) as SpreadTitleRow[];
  const allRows = [...insertedRows, ...spRows];

  useEffect(() => {
    if (!filters[SHEETS.MAIN] && sc.divisionId) setFilter();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // ===== Button handler =====

  // F5 Search — AS-IS FindData (L615~)
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    void setToast({ message: '조회 중입니다...', type: 'default', duration: 2000 });
    setFilter();
    refetch?.();
  };

  // F12 Excel Download — AS-IS ExcelButton override (L546~609, SimpleExcelExportOption + SimplexelService)
  //   To-Be: Wijmo FlexGridXlsxConverter.saveAsync
  const handleExcel = async () => {
    const g = gridRef.current;
    if (!g) return;
    const fileName = `DMF0048_SalesMonitoring_${new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '')}.xlsx`;
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

  // btnColumn — AS-IS L1755~1766 DM0002_TitleSetForm_Popup(... , true) — Column 설정 mode
  const handleColumnSetting = () => {
    setColumnSettingMode('main');
    setOpenColumnSetting(true);
  };

  // btnMeasure — AS-IS L1768~1779 DM0002_TitleSetForm_Popup(... , false) — Measure 선택 mode
  //   ⭐ 정정: 별도 modal 아니라 동일 popup 의 mode 분기 (columnType='measure')
  const handleMeasure = () => {
    setColumnSettingMode('measure');
    setOpenColumnSetting(true);
  };

  // F7 Save — AS-IS SaveData (read-only 시 비활성)
  //   ⏳ TODO: PKG_DMF0048 의 SAVE SP 등록 후 활성. 현재는 메타 SQL 에 SAVE API_M 없음.
  const _handleSave = () => {
    void setAlert({
      type: 'alert',
      content: 'Save 기능은 PKG_DMF0048 의 SAVE SP 등록 후 활성됩니다.',
    });
  };

  // 룰 09 §2.2.1 공통 버튼 기본 표시 정책:
  //   - search/sort/filter/excel 자동 활성 (생략)
  //   - insert/delete/save false (현재는 SAVE SP 미등록 → save false 유지)
  //   - condition/resetCondition false (UsrConditionPanel 부재)
  //   - excel 은 handleExcel 명시 (Wijmo XlsxConverter 사용)
  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    excel: handleExcel,
    condition: false,
    resetCondition: false,
    upload: false,
    manual: false,
  };

  // AS-IS btnColumn (L1755) / btnMeasure (L1768) — customButtons
  //   ⭐ AS-IS 두 버튼 모두 DM0002_TitleSetForm_Popup 동일 popup, mode 만 다름
  const customButtons = [
    { id: 'btnColumn', label: 'Column Setting', onClick: handleColumnSetting },
    { id: 'btnMeasure', label: 'Measure', onClick: handleMeasure },
  ];

  return (
    <div className={styles.container}>
      <MainTitle title={title} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef as never}
        dataCount={allRows.length}
        excelFileName='Sales Monitoring'
        hotkeyConfig={hotkeyConfig}
        searchAction={handleSearch}
        customButtons={customButtons as never}
      />
      <div className={styles.formWrap}>
        <SalesMonitoringForm onSearch={handleSearch} />
      </div>
      <div className={styles.gridWrap}>
        <SalesMonitoringGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          rows={allRows}
          titleRows={titleRows}
          meta={meta}
          showColor={sc.showColor}
          showSum={sc.showSum}
          bucketType={sc.bucketType}
          loading={loading}
        />
      </div>

      {/* btnColumn / btnMeasure → 동일 ColumnSettingModal (mode 분기)
          AS-IS DM0002_TitleSetForm_Popup(sProgram_Id, sheet, bool isColumnMode, divisionId)
            - true  : Column Setting (columnType='main')
            - false : Measure 선택 (columnType='measure')
          MSG00265 동등 후속: 저장 후 InitSpread(true) → refetch */}
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
              message: `[${MSG.INSERT_ONLY_BUCKET ?? 'MSG00227'}] ${columnSettingMode === 'main' ? 'Column' : 'Measure'} 설정 저장됨`,
              type: 'success',
              duration: 2000,
            });
            setOpenColumnSetting(false);
            void refetch();
          }}
        />
      )}
    </div>
  );
};
