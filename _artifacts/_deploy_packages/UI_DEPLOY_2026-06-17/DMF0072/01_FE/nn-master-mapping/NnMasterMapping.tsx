import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { NnMasterMappingForm } from './components/NnMasterMappingForm';
import { type NnRow, NnMasterMappingGrid } from './components/NnMasterMappingGrid';
import { NnMasterMappingModals } from './components/NnMasterMappingModals';
import { MAIN_COLUMNS, MENU_ID, SHEETS } from './nn-master-mapping.constants';
import styles from './NnMasterMapping.module.scss';
import { useNnMasterMappingStore } from './useNnMasterMappingStore';

// ⭐ 룰 12 §1.5 — Form / Grid / Modal 3 sub-component 분리 후 본체 = 상태 + 핸들러 + composition.
//   DMF0004 (sales-site) 표준 구조 그대로. AS-IS DMF0072_NNMasterMapping.cs 로직 1:1 보존.
export const NnMasterMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<NnRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter>(null);

  const filters = useNnMasterMappingStore(s => s.filters);
  const searchCondition = useNnMasterMappingStore(s => s.searchCondition);
  const setFilter = useNnMasterMappingStore(s => s.setFilter);
  const openSearchArea = useNnMasterMappingStore(s => s.openSearchArea);
  const setOpenSearchArea = useNnMasterMappingStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useNnMasterMappingStore(s => s.fetchStaticColumns);

  // ⭐ master hook §3 / menu-button-dynamic-fetch §2.1 — 동적 권한 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 화면 진입 시 staticColumns 1회 fetch (DMF0004 표준)
  useEffect(() => {
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 화면 진입 시 자동 조회 (사용자 요구 2026-06-01)
  useEffect(() => {
    if (!filters[SHEETS.MAIN]) setFilter();
  }, [filters, setFilter]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const [insertedRows, setInsertedRows] = useState<NnRow[]>([]);

  const spRows = (data as { o_rc1?: NnRow[] })?.o_rc1 ?? [];
  const rows: NnRow[] = [...insertedRows, ...spRows];

  const handleSearch = async () => {
    setFilter();
    void fetchStaticColumns();
    await refetch?.();
    setInsertedRows([]);
  };

  const handleInsert = () => {
    const g = gridRef.current;
    if (!g) return;
    // As-Is L538-602: InsertRow 안 DATA_TYPE='SCM' fixed, DIVISION=search div, ACTIVE_YN='Y' default
    const newRow: NnRow = {
      CRUD_TYPE: 'I',
      DATA_TYPE_CODE: 'SCM',
      DIVISION_ID: searchCondition.divisionId,
      ACTIVE_YN: 'Y',
      SOLDTO_CODE: '',
      SHIPTO_CODE: '',
      PROJECT_CODE: '',
      ITEM_ID: '',
      MAPPING_ITEM_ID: '',
    };
    setInsertedRows(prev => [newRow, ...prev]);
    setTimeout(() => {
      if (g.collectionView) {
        g.collectionView.refresh();
      } else {
        g.invalidate();
      }
    }, 50);
  };

  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as NnRow | undefined;
    if (!sel || (sel && sel.CRUD_TYPE !== 'I')) {
      globalThis.alert('신규 입력 (Insert) 한 행만 삭제할 수 있습니다.');
      return;
    }
    setInsertedRows(prev => prev.filter(r => r !== sel));
    g.invalidate();
  };

  // Phase B-Save: As-Is .cs L604-1015 SaveData() 1:1 변환
  const handleSave = () => {
    const setAlert = useMessageStore.getState().setAlert;
    const dirty: NnRow[] = rows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '저장할 행이 없습니다' });
      return;
    }

    // Validation — As-Is L667-896 의 모든 체크
    for (let i = 0; i < dirty.length; i++) {
      const r = dirty[i];
      const get = (k: string) => (r as Record<string, string>)[k] ?? '';

      const itemId = get('ITEM_ID');
      const validFrom = get('VALID_START_DATE');
      const validTo = get('VALID_END_DATE');

      if (itemId === '' || validFrom === '' || validTo === '') {
        void setAlert({
          type: 'alert',
          content: `[MSG00002] Valid From, Valid To, Model Code 값은 필수 입력입니다. (행 ${i + 1})`,
        });
        return;
      }
      if (!/^\d{8}$/.test(validFrom) || !/^\d{8}$/.test(validTo)) {
        void setAlert({
          type: 'alert',
          content: `[MSG00049] 유효한 날짜 형식이 아닙니다. (행 ${i + 1}, YYYYMMDD)`,
        });
        return;
      }
      if (validFrom > validTo) {
        void setAlert({
          type: 'alert',
          content: `[MSG00108] 시작일자가 종료일자보다 늦을 수 없습니다. (행 ${i + 1})`,
        });
        return;
      }
      if (get('DATA_TYPE_CODE') === '') {
        void setAlert({
          type: 'alert',
          content: `[MSG00002] Excel/RPA(DATA_TYPE_CODE) 값은 필수 입력입니다. (행 ${i + 1})`,
        });
        return;
      }
      if (get('END_CUSTOMER') === '') {
        void setAlert({
          type: 'alert',
          content: `[MSG00002] END_CUSTOMER 값은 필수 입력입니다. (행 ${i + 1})`,
        });
        return;
      }
      if (r.CRUD_TYPE === 'I') {
        const mustFields: Array<[string, string]> = [
          ['SOLDTO_CODE', 'SOLDTO'],
          ['SHIPTO_CODE', 'SHIPTO'],
          ['PROJECT_CODE', 'PROJECT_CODE'],
          ['SCM_SITE_ID', 'SCM_SITE_ID'],
          ['FCST_TYPE', 'FCST_TYPE'],
          ['INCOTERMS', 'INCOTERMS'],
          ['DOM_EXP', 'DOM_EXP'],
        ];
        for (const [key, label] of mustFields) {
          if (get(key) === '') {
            void setAlert({
              type: 'alert',
              content: `[MSG00002] ${label} 값은 필수 입력입니다. (행 ${i + 1})`,
            });
            return;
          }
        }
      }
      if (get('ACTIVE_YN') === '') {
        void setAlert({
          type: 'alert',
          content: `[MSG00002] ACTIVE_FLAG 값은 필수 입력입니다. (행 ${i + 1})`,
        });
        return;
      }
      if (
        get('UNLOADING_POINT').length > 35 ||
        get('CUSTOMER_PLANT').length > 10 ||
        get('CUSTOMER_ITEM_ID').length > 50
      ) {
        void setAlert({
          type: 'alert',
          content: `[Length] UNLOADING(≤35)/PLANT(≤10)/CUSTOMER_ITEM_ID(≤50) 최대 입력길이 초과 (행 ${i + 1})`,
        });
        return;
      }
    }

    // ^ 구분 join (As-Is L901-939) — 22 fields
    const join = (key: string, blank = '') =>
      dirty
        .map(r => {
          const v = (r as Record<string, string>)[key] ?? '';
          return v === '' ? blank : v;
        })
        .join('^');

    const actType = dirty.map(r => r.CRUD_TYPE ?? 'M').join('^');
    const mappingOriginal = dirty
      .map(r => {
        const v =
          r.CRUD_TYPE === 'I'
            ? ((r as Record<string, string>)['MAPPING_ITEM_ID'] ?? '')
            : ((r as Record<string, string>)['MAPPING_ITEM_ID_ORIGINAL'] ?? '');
        return v;
      })
      .join('^');

    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: `${dirty.length} 행을 저장하시겠습니까?`,
      });
      if (!ok) return;
      try {
        await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, {
          divisionId: searchCondition.divisionId,
          companyId: join('COMPANY_ID'),
          actType,
          custFcstType: join('DATA_TYPE_CODE'),
          endCustomer: join('END_CUSTOMER'),
          custUnload: join('UNLOADING_POINT', ' '),
          custPlant: join('CUSTOMER_PLANT', ' '),
          soldto: join('SOLDTO_CODE'),
          shipto: join('SHIPTO_CODE'),
          projectCode: join('PROJECT_CODE'),
          scmSiteId: join('SCM_SITE_ID'),
          fcstType: join('FCST_TYPE'),
          incoterms: join('INCOTERMS'),
          domExp: join('DOM_EXP'),
          custItemId: join('CUSTOMER_ITEM_ID', ' '),
          mdmCode: join('ITEM_ID'),
          mappingItemId: join('MAPPING_ITEM_ID'),
          mappingItemIdOriginal: mappingOriginal,
          activeFlag: join('ACTIVE_YN'),
          validFrom: join('VALID_START_DATE'),
          validTo: join('VALID_END_DATE'),
        });
        void setAlert({ type: 'alert', content: '[MSG00020] 저장되었습니다.' });
        setInsertedRows([]);
        await refetch?.();
      } catch (e) {
        const msg = e instanceof Error ? e.message : '[MSG00284] 저장 중 오류가 발생했습니다.';
        void setAlert({ type: 'alert', content: msg });
      }
    })();
  };

  // ⭐ master hook §3 — `hasButton(BTN_CD)` 조건부 callback. admin USE_YN='N' 즉시 비활성.
  const hotkeyConfig: HotkeyConfig = useMemo(
    () => ({
      search: hasButton('SEARCH') ? handleSearch : false,
      insert: hasButton('INSERT') ? handleInsert : false,
      save: hasButton('SAVE') ? handleSave : false,
      delete: hasButton('DELETE') ? handleDelete : false,
      manual: false,
      upload: false,
    }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [hasButton]
  );

  // Phase B-3 dblClick popup state — CRUD_TYPE='I' (신규) 행만 popup (MAPPING_ITEM_ID 는 'M' 도 가능)
  const [clickedRow, setClickedRow] = useState<number | null>(null);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);
  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // Grid 의 dblClick 콜백 — column meta 의 _ctrlType='FPModal' + _modalKey 기반 분기
  const handleCellDoubleClick = (g: FlexGridType<NnRow>, e: { row: number; col: number }) => {
    const dataItem = g.rows[e.row]?.dataItem as NnRow | undefined;
    const binding = g.columns[e.col]?.binding;
    if (!dataItem || !binding) return;

    const meta = MAIN_COLUMNS.find(c => c.key === binding);
    if (!meta || (meta && meta._ctrlType !== 'FPModal')) return;

    const isInsert = dataItem.CRUD_TYPE === 'I';
    const isMapping = meta._inputEditType === 'M';
    if (!isInsert && !isMapping) return;

    setClickedRow(e.row);
    setClickedBinding(binding);
    switch (meta._modalKey) {
      case 'customerByDivisionModal':
        setOpenCustomerModal(true);
        break;
      case 'projectByDivisionModal':
        setOpenProjectModal(true);
        break;
      case 'itemByDivisionModal':
        setOpenItemModal(true);
        break;
    }
  };

  // Modal 선택 콜백 — clicked row 의 cell 에 값 set + grid invalidate
  const setRowCell = (binding: string, value: string) => {
    const g = gridRef.current;
    if (g === null || clickedRow === null) return;
    const dataItem = g.rows[clickedRow]?.dataItem as NnRow | undefined;
    if (!dataItem) return;
    (dataItem as Record<string, unknown>)[binding] = value;
    g.collectionView.refresh();
  };

  const handleCustomerSelect = (soldTo: string, _soldDesc: string, shipTo: string) => {
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
        <NnMasterMappingGrid
          gridRef={gridRef}
          rows={rows}
          onCellDoubleClick={handleCellDoubleClick}
        />
      </div>
      <NnMasterMappingModals
        divisionId={searchCondition.divisionId}
        deptId={searchCondition.deptId}
        endCustomer={searchCondition.endCustomer}
        scmSiteId={searchCondition.scmSiteId}
        clickedBinding={clickedBinding}
        openCustomerModal={openCustomerModal}
        openProjectModal={openProjectModal}
        openItemModal={openItemModal}
        setOpenCustomerModal={setOpenCustomerModal}
        setOpenProjectModal={setOpenProjectModal}
        setOpenItemModal={setOpenItemModal}
        onCustomerSelect={handleCustomerSelect}
        onProjectSelect={handleProjectSelect}
        onItemSelect={handleItemSelect}
      />
    </div>
  );
};
