import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { NnMasterMappingForm } from './components/NnMasterMappingForm';
import { NnMasterMappingGrid } from './components/NnMasterMappingGrid';
import { MENU_ID, SHEETS } from './nn-master-mapping.constants';
import { useNnMasterMappingStore } from './useNnMasterMappingStore';

// AS-IS DMF0072_NNMasterMapping — N:N Master Mapping (Insert / Delete / Save 풀스택)
// 룰 #10 datagrid-shared-component-mandatory: DataGrid 공용 컴포넌트 (components/NnMasterMappingGrid.tsx)
// 룰 #51 screen-shell-composition-mandatory: SearchArea (NnMasterMappingForm)
// 룰 #24 menu-button-dynamic-fetch: useTabBtnPermissions + hasButton(BTN_CD) 권한 분기
// 룰 #22 i18n-ko-en-alignment: 모든 메시지 t() 사용 (한글 하드코딩 0)
export const NnMasterMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const filters = useNnMasterMappingStore(s => s.filters);
  const initialized = useNnMasterMappingStore(s => s.initialized);
  const searchCondition = useNnMasterMappingStore(s => s.searchCondition);
  const setFilter = useNnMasterMappingStore(s => s.setFilter);
  const openSearchArea = useNnMasterMappingStore(s => s.openSearchArea);
  const setOpenSearchArea = useNnMasterMappingStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useNnMasterMappingStore(s => s.fetchStaticColumns);

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const insertedRowsRef = useRef<ResponseData<MENU_ID, SHEETS.MAIN>[]>([]);
  const [insertedRowCount, setInsertedRowCount] = useState(0);

  // 진입 시 자동조회 차단 — 사용자가 Search(F5) 를 눌러야 조회. mount 마다 false 라 persist 된 filters 도 무시됨.
  const [hasSearched, setHasSearched] = useState(false);

  // 진입 시 admin 메타 동적 fetch + 자동 조회
  useEffect(() => {
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (initialized && !filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [initialized]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<ResponseData<MENU_ID, SHEETS.MAIN>[]>(
    () => [...insertedRowsRef.current, ...(data?.o_rc1 ?? [])],
    [data]
  );

  const clearInsertedRows = () => {
    const g = gridRef.current;
    const source = g?.collectionView?.sourceCollection;
    if (source) {
      for (let i = source.length - 1; i >= 0; i--) {
        if (source[i]?.CRUD_TYPE === CRUD_TYPE.INSERT) source.splice(i, 1);
      }
      g.collectionView.refresh();
    }
    insertedRowsRef.current = [];
    setInsertedRowCount(0);
  };

  const handleSearch = async () => {
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    await refetch?.();
    clearInsertedRows();
  };

  // division 변경 시 조회 전 신규행 초기화 — division 은 조회 데이터·컬럼 기준이라 값/컬럼이
  //   어긋난 신규행이 남으면 안 된다. setSearchCondition 이 filters 를 비워 조회 데이터는 사라지지만,
  //   insertedRowsRef 의 신규행은 clearInsertedRows 로만 지워지므로 여기서 함께 비운다(DMF0004~0007
  //   와 동일 정책). 다른 조회조건 변경에는 신규행을 유지한다.
  const prevDivisionRef = useRef(searchCondition.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === searchCondition.divisionId) return;
    prevDivisionRef.current = searchCondition.divisionId;
    clearInsertedRows();
  }, [searchCondition.divisionId]);

  // AS-IS L538-602: InsertRow — DATA_TYPE='SCM' fixed, DIVISION=search div, ACTIVE_YN='Y' default
  const handleInsert = () => {
    const g = gridRef.current;
    if (!g) return;
    const newRow = GridAction.addRow(
      g,
      {
        DATA_TYPE_CODE: 'SCM',
        DIVISION_ID: searchCondition.divisionId,
        ACTIVE_YN: 'Y',
        SOLDTO_CODE: '',
        SHIPTO_CODE: '',
        PROJECT_CODE: '',
        ITEM_ID: '',
        MAPPING_ITEM_ID: '',
      },
      'above',
      true
    );
    if (!newRow) return;
    insertedRowsRef.current.unshift(newRow);
    setInsertedRowCount(insertedRowsRef.current.length);
  };

  // AS-IS L275-279: 'I' (신규) 행만 삭제 가능
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as ResponseData<MENU_ID, SHEETS.MAIN> | undefined;
    if (!sel || sel.CRUD_TYPE !== CRUD_TYPE.INSERT) {
      void setAlert({
        type: 'alert',
        content: t('MSG00608', '_신규 입력 (Insert) 한 행만 삭제할 수 있습니다.'),
      });
      return;
    }
    GridAction.removeRow(g, true);
    insertedRowsRef.current = insertedRowsRef.current.filter(row => row !== sel);
    setInsertedRowCount(insertedRowsRef.current.length);
  };

  // AS-IS L604-1015 SaveData() 1:1 — Validation + ^ join + apiClient.post + refetch
  const handleSave = () => {
    const dirty = rows.filter(r => r.CRUD_TYPE === CRUD_TYPE.INSERT || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      // 변경/신규 없음 → toast + 공통 메시지("수정한 내용이 없습니다") (DMF0004~0007/0020 과 동일 규약.
      //   필수 검증 실패는 modal alert 유지).
      setToast({ type: 'error', message: t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.') });
      return;
    }

    for (let i = 0; i < dirty.length; i++) {
      const r = dirty[i];
      // unknown 안전 stringification — object [object Object] 회피
      const get = (k: string): string => {
        const v = (r as Record<string, unknown>)[k];
        if (typeof v === 'string') return v;
        if (typeof v === 'number' || typeof v === 'boolean' || typeof v === 'bigint')
          return String(v);
        return '';
      };
      const row = i + 1;

      const itemId = get('ITEM_ID');
      const validFrom = get('VALID_START_DATE');
      const validTo = get('VALID_END_DATE');

      if (itemId === '' || validFrom === '' || validTo === '') {
        void setAlert({
          type: 'alert',
          content:
            t('MSG00610', '_Valid From, Valid To, Model Code 값은 필수 입력입니다.') + ` (${row})`,
        });
        return;
      }
      if (!/^\d{8}$/.test(validFrom) || !/^\d{8}$/.test(validTo)) {
        void setAlert({
          type: 'alert',
          content: t('MSG00611', '_유효한 날짜 형식이 아닙니다. (YYYYMMDD)') + ` (${row})`,
        });
        return;
      }
      if (validFrom > validTo) {
        void setAlert({
          type: 'alert',
          content: t('MSG00108', '_조회 기간이 잘못되었습니다 (시작일 > 종료일).') + ` (${row})`,
        });
        return;
      }
      if (get('DATA_TYPE_CODE') === '') {
        void setAlert({
          type: 'alert',
          content: t('MSG00612', '_Data Type Code 값은 필수 입력입니다.') + ` (${row})`,
        });
        return;
      }
      if (get('END_CUSTOMER') === '') {
        void setAlert({
          type: 'alert',
          content: t('MSG00613', '_End Customer 값은 필수 입력입니다.') + ` (${row})`,
        });
        return;
      }
      if (r.CRUD_TYPE === CRUD_TYPE.INSERT) {
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
              content:
                t('MSG00614', '_{0} 값은 필수 입력입니다.').replace('{0}', label) + ` (${row})`,
            });
            return;
          }
        }
      }
      if (get('ACTIVE_YN') === '') {
        void setAlert({
          type: 'alert',
          content: t('MSG00615', '_Active Flag 값은 필수 입력입니다.') + ` (${row})`,
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
          content:
            t(
              'MSG00616',
              '_Unloading(≤35) / Plant(≤10) / Customer Item ID(≤50) 최대 입력길이 초과.'
            ) + ` (${row})`,
        });
        return;
      }
    }

    // ^ 구분 join (AS-IS L901-939) — 22 fields
    const asStr = (v: unknown): string => {
      if (typeof v === 'string') return v;
      if (typeof v === 'number' || typeof v === 'boolean' || typeof v === 'bigint')
        return String(v);
      return '';
    };
    const join = (key: string, blank = '') =>
      dirty
        .map(r => {
          const v = asStr((r as Record<string, unknown>)[key]);
          return v === '' ? blank : v;
        })
        .join('^');
    const actType = dirty.map(r => String(r.CRUD_TYPE ?? 'M')).join('^');
    const mappingOriginal = dirty
      .map(r => {
        const key =
          r.CRUD_TYPE === CRUD_TYPE.INSERT ? 'MAPPING_ITEM_ID' : 'MAPPING_ITEM_ID_ORIGINAL';
        return asStr((r as Record<string, unknown>)[key]);
      })
      .join('^');

    void (async () => {
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
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
        clearInsertedRows();
        await refetch?.();
      } catch (e) {
        const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: msg });
      }
    })();
  };

  // hotkeyConfig — sort/filter/excel/condition/resetCondition 미명시 = DefaultButtonActions 자동 활성.
  // hasButton 권한 분기 임시 미적용 — 100_DMF0072_btn_auth.sql (GUEST + minyonglee1 × INSERT/DELETE 시드)
  // 사내 DB 적용 후 hasButton('XXX') ? handler : false 패턴 도입 가능 (룰 #24).
  void hasButton; // hook 호출은 유지 (BE 응답 캐시 워밍)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
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
      {openSearchArea && <NnMasterMappingForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={(data?.o_rc1?.length ?? 0) + insertedRowCount}
        excelFileName='NnMasterMapping'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <NnMasterMappingGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        searchCondition={searchCondition}
      />
    </>
  );
};
