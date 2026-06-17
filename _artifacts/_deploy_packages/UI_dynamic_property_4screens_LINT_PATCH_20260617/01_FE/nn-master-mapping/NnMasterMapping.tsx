import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  MergeManager,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  CustomerModal,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from '../../components';

import { NnMasterMappingForm } from './components/NnMasterMappingForm';
import { MAIN_COLUMNS, MENU_ID, type NnColumnMeta, SHEETS } from './nn-master-mapping.constants';
import styles from './NnMasterMapping.module.scss';
import { useNnMasterMappingStore } from './useNnMasterMappingStore';

// 신규 행 type — 기존 SP 결과와 합쳐 grid itemsSource 로 사용 (As-Is L538-602 InsertRow 결과)
type NnRow = Record<string, unknown> & { CRUD_TYPE?: 'I' | 'M' | 'D' };

// As-Is .cs L515 `siMain.SmartColMerge()` 동작 모사 (사용자 요구 2026-06-02):
// "자신의 column 이 같은 값이어도, 좌측의 모든 allowMerging column 도 같은 값일 때만 머지"
// Wijmo 기본 `AllowMerging.Cells` 는 column-independent — 이 클래스가 계층적 머지로 교체.
class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip: boolean = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) {
      return super.getMergedRange(panel, r, c, clip);
    }
    const col = panel.columns[c];
    if (!col || !col.allowMerging) return null;

    // 좌측 (포함) 의 allowMerging=true column 모음
    const mergeColIdx: number[] = [];
    for (let i = 0; i <= c; i++) {
      if (panel.columns[i] && panel.columns[i].allowMerging) mergeColIdx.push(i);
    }
    if (mergeColIdx.length === 0) return null;

    const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
      mergeColIdx.every(ci => {
        const a: unknown = panel.getCellData(rowA, ci, false);
        const b: unknown = panel.getCellData(rowB, ci, false);
        return a === b;
      });

    let r1 = r;
    let r2 = r;
    while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
    const rowCnt = panel.rows.length;
    while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;

    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}

export const NnMasterMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<NnRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useNnMasterMappingStore(s => s.filters);
  const searchCondition = useNnMasterMappingStore(s => s.searchCondition);
  const setFilter = useNnMasterMappingStore(s => s.setFilter);
  const openSearchArea = useNnMasterMappingStore(s => s.openSearchArea);
  const setOpenSearchArea = useNnMasterMappingStore(s => s.setOpenSearchArea);
  // ⭐ UI 동적 속성관리 (master hook §4) — admin SYS0004 UI Category Setup 메타 동적 fetch
  const staticColumns = useNnMasterMappingStore(s => s.staticColumns);
  const fetchStaticColumns = useNnMasterMappingStore(s => s.fetchStaticColumns);

  // 화면 진입 시 자동 조회 + admin 메타 fetch (사용자 요구 2026-06-01 + master hook §2.3)
  useEffect(() => {
    if (!filters[SHEETS.MAIN]) setFilter();
    void fetchStaticColumns();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // ⭐ mergedColumns — admin 메타 (visible/width/label) override + MAIN_COLUMNS 확장 속성 (_ctrlType/_modalKey/_inputEditType) fallback.
  //   DMF0020 SalesFuturePriceFlexGrid mergedColumns 패턴 동일.
  const mergedColumns = useMemo<(NnColumnMeta & { visible?: boolean })[]>(() => {
    const sc = staticColumns?.[SHEETS.MAIN] ?? [];
    if (sc.length === 0) return MAIN_COLUMNS.map(c => ({ ...c, visible: true }));
    return sc.map(s => {
      const fb = MAIN_COLUMNS.find(m => m.key === s.colNm);
      return {
        key: s.colNm,
        header: s.colLblNm || fb?.header || s.colNm,
        width: s.colWth ?? fb?.width ?? 100,
        merge: fb?.merge ?? false,
        visible: s.visible !== false,
        _ctrlType: (s.cellCtrlObjTpCd as NnColumnMeta['_ctrlType']) ?? fb?._ctrlType,
        _inputEditType: (s.inputTpCd as NnColumnMeta['_inputEditType']) ?? fb?._inputEditType,
        _modalKey: fb?._modalKey,   // _modalKey 는 code-side 매핑 유지 (admin meta 미관리)
      };
    });
  }, [staticColumns]);
  const visibleColumns = useMemo(() => mergedColumns.filter(c => c.visible !== false), [mergedColumns]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // Phase B-2: Insert / Delete handler — As-Is .cs L538-602 InsertRow / L275-279 DeleteButton 1:1
  // 신규 행 별도 state 로 관리 (CRUD_TYPE='I'). 저장은 Phase 후속 — SAVE handler 미구현
  // ⚠️ handleSearch 가 setInsertedRows 사용 → use-before-define 회피 위해 위로 이동
  const [insertedRows, setInsertedRows] = useState<NnRow[]>([]);

  const handleSearch = () => {
    setFilter();
    void refetch?.();
    setInsertedRows([]);
    // ⭐ master hook §2.4 — Search 시 admin 메타 refetch (admin 변경 즉시 반영)
    void fetchStaticColumns();
  };

  const handleInsert = () => {
    // As-Is L538-602: InsertRow 안 DATA_TYPE='SCM' fixed, DIVISION=search div, ACTIVE_YN='Y' default
    const newRow: NnRow = {
      CRUD_TYPE: 'I',
      DATA_TYPE_CODE: 'SCM',
      DIVISION_ID: searchCondition.divisionId,
      ACTIVE_YN: 'Y',
    };
    setInsertedRows(prev => [newRow, ...prev]);
  };

  const handleDelete = () => {
    // As-Is L275-279: 'I' (신규) 행만 삭제. selected row 의 CRUD_TYPE='I' 인 경우만 제거
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as NnRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      // 신규 행만 삭제 가능 (As-Is L277 조건)
      window.alert('신규 입력 (Insert) 한 행만 삭제할 수 있습니다.');
      return;
    }
    setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // Phase B-Save: As-Is .cs L604-1015 SaveData() 1:1 변환
  //   - 'I' (신규) / 'M' (수정) 행만 처리
  //   - Validation: 빈 값 / 날짜 / 필수 / 길이 (As-Is L667-896)
  //   - ^ 구분 join (As-Is L901-939) — 22 fields
  //   - SP 호출 DMF0072_SAVE_NNMASTER_MAPPING (As-Is L949-975 / To-Be PROC_M 22 IN + 2 OUT cursor)
  //   - 성공 시 자동 재조회 (As-Is L997 FindButton)
  //   - useProcMutation array wrap 회피 — apiClient.post 직접 호출 (ContributeMain 패턴)
  const handleSave = () => {
    const setAlert = useMessageStore.getState().setAlert;
    // 신규 (CRUD_TYPE='I') + 수정 (CRUD_TYPE='M') 행 모두 처리. 현 단계는 신규만 (수정 토글 별도)
    const dirty: NnRow[] = insertedRows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '저장할 행이 없습니다. (Insert 후 저장)' });
      return;
    }

    // Validation — As-Is L667-896 의 모든 체크
    for (let i = 0; i < dirty.length; i++) {
      const r = dirty[i];
      const get = (k: string) => ((r as Record<string, string>)[k] ?? '');

      const itemId = get('ITEM_ID');
      const validFrom = get('VALID_START_DATE');
      const validTo = get('VALID_END_DATE');

      // L690-712: 빈 값 체크 (ITEM_ID + VALID_START + VALID_END)
      if (itemId === '' || validFrom === '' || validTo === '') {
        void setAlert({ type: 'alert', content: `[MSG00002] Valid From, Valid To, Model Code 값은 필수 입력입니다. (행 ${i + 1})` });
        return;
      }
      // L715-737: 날짜 유효성
      if (!/^\d{8}$/.test(validFrom) || !/^\d{8}$/.test(validTo)) {
        void setAlert({ type: 'alert', content: `[MSG00049] 유효한 날짜 형식이 아닙니다. (행 ${i + 1}, YYYYMMDD)` });
        return;
      }
      // L725-729: 시작일 <= 종료일
      if (validFrom > validTo) {
        void setAlert({ type: 'alert', content: `[MSG00108] 시작일자가 종료일자보다 늦을 수 없습니다. (행 ${i + 1})` });
        return;
      }
      // L787-792: DATA_TYPE_CODE 필수
      if (get('DATA_TYPE_CODE') === '') {
        void setAlert({ type: 'alert', content: `[MSG00002] Excel/RPA(DATA_TYPE_CODE) 값은 필수 입력입니다. (행 ${i + 1})` });
        return;
      }
      // L793-798: END_CUSTOMER 필수
      if (get('END_CUSTOMER') === '') {
        void setAlert({ type: 'alert', content: `[MSG00002] END_CUSTOMER 값은 필수 입력입니다. (행 ${i + 1})` });
        return;
      }
      // L826-876: 신규 ('I') 행만 추가 필수
      if (r.CRUD_TYPE === 'I') {
        const mustFields: Array<[string, string]> = [
          ['SOLDTO_CODE', 'SOLDTO'], ['SHIPTO_CODE', 'SHIPTO'],
          ['PROJECT_CODE', 'PROJECT_CODE'], ['SCM_SITE_ID', 'SCM_SITE_ID'],
          ['FCST_TYPE', 'FCST_TYPE'], ['INCOTERMS', 'INCOTERMS'], ['DOM_EXP', 'DOM_EXP'],
        ];
        for (const [key, label] of mustFields) {
          if (get(key) === '') {
            void setAlert({ type: 'alert', content: `[MSG00002] ${label} 값은 필수 입력입니다. (행 ${i + 1})` });
            return;
          }
        }
      }
      // L878-883: ACTIVE_YN 필수
      if (get('ACTIVE_YN') === '') {
        void setAlert({ type: 'alert', content: `[MSG00002] ACTIVE_FLAG 값은 필수 입력입니다. (행 ${i + 1})` });
        return;
      }
      // L887-896: 길이 체크
      if (get('UNLOADING_POINT').length > 35
          || get('CUSTOMER_PLANT').length > 10
          || get('CUSTOMER_ITEM_ID').length > 50) {
        void setAlert({ type: 'alert', content: `[Length] UNLOADING(≤35)/PLANT(≤10)/CUSTOMER_ITEM_ID(≤50) 최대 입력길이 초과 (행 ${i + 1})` });
        return;
      }
    }

    // ^ 구분 join (As-Is L901-939) — 22 fields. 빈 값 처리:
    //   Cust 3개 (UNLOAD/PLANT/CUST_ITEM) 는 빈 값 시 ' ' (공백 1자), 나머지는 ''
    const join = (key: string, blank = '') =>
      dirty.map(r => {
        const v = ((r as Record<string, string>)[key] ?? '');
        return v === '' ? blank : v;
      }).join('^');

    const actType = dirty.map(r => r.CRUD_TYPE ?? 'M').join('^');
    const mappingOriginal = dirty.map(r => {
      // L918-925: 신규는 MAPPING_ITEM_ID 그대로, 수정은 MAPPING_ITEM_ID_ORIGINAL
      const v = r.CRUD_TYPE === 'I'
        ? ((r as Record<string, string>)['MAPPING_ITEM_ID'] ?? '')
        : ((r as Record<string, string>)['MAPPING_ITEM_ID_ORIGINAL'] ?? '');
      return v;
    }).join('^');

    void (async () => {
      const ok = await setAlert({ type: 'confirm', content: `${dirty.length} 행을 저장하시겠습니까?` });
      if (!ok) return;
      try {
        await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, {
          // PROC_M 22 IN args (BE 가 sesUserId 자동 채움. p_result_cursor/p_error_cursor 는 OUT)
          divisionId: searchCondition.divisionId,   // L952: 화면 search div (clbDivisions.ControlValues)
          companyId: join('COMPANY_ID'),
          actType,
          custFcstType: join('DATA_TYPE_CODE'),     // L955 P_CUST_FCST_TYPE = DATA_TYPE_CODE
          endCustomer: join('END_CUSTOMER'),
          custUnload: join('UNLOADING_POINT', ' '), // L905 빈 값 ' '
          custPlant: join('CUSTOMER_PLANT', ' '),
          soldto: join('SOLDTO_CODE'),
          shipto: join('SHIPTO_CODE'),
          projectCode: join('PROJECT_CODE'),
          scmSiteId: join('SCM_SITE_ID'),
          fcstType: join('FCST_TYPE'),
          incoterms: join('INCOTERMS'),
          domExp: join('DOM_EXP'),
          custItemId: join('CUSTOMER_ITEM_ID', ' '),
          mdmCode: join('ITEM_ID'),                 // L967 P_MDM_CODE = ITEM_ID
          mappingItemId: join('MAPPING_ITEM_ID'),
          mappingItemIdOriginal: mappingOriginal,
          activeFlag: join('ACTIVE_YN'),
          validFrom: join('VALID_START_DATE'),
          validTo: join('VALID_END_DATE'),
        });
        void setAlert({ type: 'alert', content: '[MSG00020] 저장되었습니다.' });
        setInsertedRows([]);
        void refetch?.();
      } catch (e) {
        const msg = e instanceof Error ? e.message : '[MSG00284] 저장 중 오류가 발생했습니다.';
        void setAlert({ type: 'alert', content: msg });
      }
    })();
  };

  // ⭐ UI 동적 속성관리 — Menu Button (master hook §3): admin USE_YN 즉시 반영
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save:   hasButton('SAVE')   ? handleSave   : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  // Phase B-3: dblClick popup handler — column meta 의 _ctrlType='FPModal' + _modalKey 기반 분기
  //   - CRUD_TYPE='I' (신규 행) 에서만 popup (MAPPING_ITEM_ID 는 'M' 도 가능)
  //   - column meta 의 _modalKey 로 switch (룰 12 §11.7 표준)
  const [clickedRow, setClickedRow] = useState<number | null>(null);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);
  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // dblClick handler — 최신 state 추적 위해 useRef (initialized 의 stale closure 회피)
  const dblClickRef = useRef<(g: FlexGridType<NnRow>, e: { row: number; col: number }) => void>(() => undefined);
  dblClickRef.current = (g, e) => {
    const dataItem = g.rows[e.row]?.dataItem as NnRow | undefined;
    const binding = g.columns[e.col]?.binding;
    if (!dataItem || !binding) return;

    const meta = MAIN_COLUMNS.find(c => c.key === binding);
    if (!meta || meta._ctrlType !== 'FPModal') return;

    // CRUD_TYPE 가드 — MAPPING_ITEM_ID (M) 은 신규/수정 모두 / 그 외 IM 은 신규만
    const isInsert = dataItem.CRUD_TYPE === 'I';
    const isMapping = meta._inputEditType === 'M';
    if (!isInsert && !isMapping) return;

    setClickedRow(e.row);
    setClickedBinding(binding);
    switch (meta._modalKey) {
      case 'customerByDivisionModal': setOpenCustomerModal(true); break;
      case 'projectByDivisionModal':  setOpenProjectModal(true);  break;
      case 'itemByDivisionModal':     setOpenItemModal(true);     break;
    }
  };

  // Modal 선택 콜백 — clicked row 의 cell 에 값 set + grid invalidate
  const setRowCell = (binding: string, value: string) => {
    const g = gridRef.current;
    if (g === null || clickedRow === null) return;
    const dataItem = g.rows[clickedRow]?.dataItem as NnRow | undefined;
    if (!dataItem) return;
    (dataItem as Record<string, unknown>)[binding] = value;
    g.invalidate();
  };

  const handleCustomerSelect = (soldTo: string, _soldDesc: string, shipTo: string) => {
    // CustomerModal 은 SOLDTO + SHIPTO 동시 반환 — clicked binding 기준 동작
    if (clickedBinding === 'SOLDTO_CODE') {
      setRowCell('SOLDTO_CODE', soldTo);
      if (shipTo) setRowCell('SHIPTO_CODE', shipTo);
    } else if (clickedBinding === 'SHIPTO_CODE') {
      setRowCell('SHIPTO_CODE', shipTo || soldTo);
    }
    setOpenCustomerModal(false);
  };

  const handleProjectSelect = (projects: string) => {
    setRowCell('PROJECT_CODE', projects);
    setOpenProjectModal(false);
  };

  const handleItemSelect = (items: string) => {
    if (clickedBinding) setRowCell(clickedBinding, items);
    setOpenItemModal(false);
  };

  const spRows = (data as { o_rc1?: NnRow[] })?.o_rc1 ?? [];
  const rows: NnRow[] = [...insertedRows, ...spRows];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <NnMasterMappingForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='NnMasterMapping'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <div className={styles.gridContainer}>
        <FlexGrid
          className={styles.grid}
          initialized={(g: FlexGridType<Record<string, unknown>>) => {
            if (gridRef && 'current' in gridRef) {
              (gridRef as { current: FlexGridType<Record<string, unknown>> | null }).current = g;
            }
            // As-Is .cs L515 `siMain.SmartColMerge()` 계층적 동작 (사용자 요구 2026-06-02):
            //   - allowMerging=true column 의 cell 머지
            //   - 좌측 모든 allowMerging column 도 같은 값일 때만 머지 (column-dependent)
            g.allowMerging = AllowMerging.Cells;
            g.mergeManager = new HierarchicalMergeManager();

            // 룰 12 §11.7 + hook grid-column-meta-mandatory.md (2026-06-02 적용):
            //   column meta 의 _inputEditType + _ctrlType 기반 cell coloring 자동 토글
            //   - _inputEditType='S' → wj-cell-non-editable (#f1f4f3 회색)
            //   - _inputEditType='M'/'O'/'IM'/'IO' → wj-cell-editable (#fff8cd 노란) — CRUD 상태 무관 시각
            //   - _ctrlType='FPModal' → wj-cell-popup (우측 OpenInNew 아이콘)
            // 표준 DataGrid 래퍼의 dataGridUtils.ts:181-224 formatEditableColumns 동작 시범 적용
            g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
              if (e.panel.cellType !== CellType.Cell) return;
              const col = e.panel.columns[e.col];
              if (!col || !col.binding) return;
              const meta = MAIN_COLUMNS.find(c => c.key === col.binding);
              if (!meta) return;

              // CRUD_TYPE='I' (신규 행) 추적 — IM/IO 컬럼은 신규 시에만 편집 가능 표시
              const dataItem = e.panel.rows[e.row]?.dataItem as NnRow | undefined;
              const isInsert = dataItem?.CRUD_TYPE === 'I';

              const isEditable =
                meta._inputEditType === 'M' ||
                meta._inputEditType === 'O' ||
                ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && isInsert);
              const isReadOnly =
                meta._inputEditType === 'S' ||
                ((meta._inputEditType === 'IM' || meta._inputEditType === 'IO') && !isInsert);
              // popup cell — 신규 행 (IM) 또는 MAPPING_ITEM_ID ('M') 일 때만 ↗ 아이콘 표시
              const isPopup =
                meta._ctrlType === 'FPModal' &&
                ((meta._inputEditType === 'M') || isInsert);

              toggleClass(e.cell, 'wj-cell-editable', isEditable);
              toggleClass(e.cell, 'wj-cell-non-editable', isReadOnly);
              toggleClass(e.cell, 'wj-cell-popup', isPopup);
            });

            // Phase B-3: dblClick popup handler — column meta 의 _modalKey 분기
            // wijmo 버전별 itemDoubleClick event 가드 + DOM dblclick fallback
            const dblG = (g as unknown as { itemDoubleClick?: { addHandler?: (fn: (s: unknown, e: { panel: { cellType: CellType }; row: number; col: number }) => void) => void } }).itemDoubleClick;
            if (dblG && typeof dblG.addHandler === 'function') {
              dblG.addHandler((_s, e) => {
                if (e.panel.cellType !== CellType.Cell) return;
                dblClickRef.current(g, { row: e.row, col: e.col });
              });
            } else if (g.hostElement) {
              g.hostElement.addEventListener('dblclick', () => {
                const sel = g.selection;
                if (sel && sel.row >= 0 && sel.col >= 0) {
                  dblClickRef.current(g, { row: sel.row, col: sel.col });
                }
              });
            }
          }}
          itemsSource={rows}
          autoGenerateColumns={false}
        >
          {/* ⭐ visibleColumns — admin SYS0004 visible=false 컬럼은 자동 제외, width/header 도 admin 메타 반영.
              _ctrlType / _inputEditType / _modalKey 등 확장 속성은 formatItem/dblClick 안 MAIN_COLUMNS fallback 으로 처리. */}
          {visibleColumns.map(c => (
            <FlexGridColumn
              key={c.key}
              binding={c.key}
              header={c.header}
              width={c.width}
              // 룰 12 §11.7: _inputEditType='S' 또는 FPModal 컬럼은 키보드 편집 차단
              // FPModal 은 dblClick 으로만 (formatItem 의 wj-cell-popup 처리)
              isReadOnly={c._inputEditType === 'S' || c._ctrlType === 'FPModal'}
              allowMerging={c.merge ?? false}
            />
          ))}
        </FlexGrid>
      </div>

      {/* Phase B-3: Customer/Project/Item Modal — column meta 의 _modalKey 기반 호출 */}
      <CustomerModal
        open={openCustomerModal}
        modalClose={() => setOpenCustomerModal(false)}
        setSelectedValue={handleCustomerSelect}
        divisionId={searchCondition.divisionId}
      />
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: searchCondition.endCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          etc: 'N',
        } as never}
        callFromCell={true}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={handleItemSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: searchCondition.endCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          itemId: '',
        } as never}
        callFromCell={true}
        headerTitle={clickedBinding === 'MAPPING_ITEM_ID' ? 'Mapping Item Popup' : 'Model/Nickname Popup'}
      />
    </div>
  );
};
