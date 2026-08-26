import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcExchangeRate, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { keepRowVisibleUnderFilter } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesReportsForm } from './components/SalesReportsForm';
import { SalesReportsGrid } from './components/SalesReportsGrid';
import { type SalesReportsModalKey, SalesReportsModals } from './components/SalesReportsModals';
import { DATA_TYPE, INSERT_ROW_DEFAULTS, MENU_ID, MSG, SHEETS } from './sales-reports.constants';
import type { MeasureRow, SalesReportRow, SpreadTitleRow } from './sales-reports.types';
import { resolveSearchedCondition, useSalesReportsStore } from './useSalesReportsStore';
import { callSaveCutoff, callSaveEtc } from './utils/sales-reports.api';
import { isDiv82 } from './utils/sales-reports.division';
import { toCellStr } from './utils/sales-reports.gridCombos';
import {
  buildBulkPayload,
  buildCutoffSaveRows,
  buildEtcSaveRows,
  isEtc,
} from './utils/sales-reports.save';
import {
  validateFind,
  validateNoPending,
  validateNotAll,
  validateVersionForAction,
} from './utils/sales-reports.validate';

// AS-IS DMF0044_Sales_Reports (Demand > Demand Plan > Sales Reports / MDF Reports — 신정본 1,483행 1:1).
//   3축 분기: Report Type(SP_W/BP_M) × Data Type(ALL 차단/1=Cutoff/2=ETC) × Division(40/82).
//   조회 = PKG.P_DMF0044_GET_SALES_REPORTS_DATA (Version 필수 MSG00283) / 저장 = Data Type 이원화
//   (ETC 20키 _C / Cutoff 22키 _C_CF '^' bulk) / Insert = ETC 전용 2행 Measure 블록 (GET_MEASURE 원천).
//   커스텀: Version '...'(United)/Measure Show/Exchange Rate(pending 차단 MSG00680)/Text(82 전용).
export const SalesReports = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<SalesReportRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useSalesReportsStore(s => s.searchCondition);
  const setSearchCondition = useSalesReportsStore(s => s.setSearchCondition);
  const filters = useSalesReportsStore(s => s.filters);
  const setFilter = useSalesReportsStore(s => s.setFilter);
  const clearFilters = useSalesReportsStore(s => s.clearFilters);
  const openSearchArea = useSalesReportsStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesReportsStore(s => s.setOpenSearchArea);
  const staticColumns = useSalesReportsStore(s => s.staticColumns);
  const fetchStaticColumns = useSalesReportsStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useSalesReportsStore(s => s.fetchStaticMeasures);
  const thisMonth = useSalesReportsStore(s => s.thisMonth);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 (Search 클릭 후에만 enable — DMF0003 계보)
  const [hasSearched, setHasSearched] = useState(false);

  // 편집/저장 게이트 기준 = "조회한" 조건 (filters = Search 클릭 시점 스냅샷).
  //   금지: 게이트에 sc(조회조건 폼)를 쓰지 말 것 — ALL 로 조회한 뒤 Data Type 콤보만 바꿔도
  //   재조회 없이 그리드가 편집 가능해진다(2026-08-12 사고). 폼은 화면 입력용으로만 쓴다.
  const searched = resolveSearchedCondition(filters[SHEETS.MAIN]);

  // 메인 조회 — PKG.P_DMF0044_GET_SALES_REPORTS_DATA (9 IN, 커서 data/result)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 월 헤더 — DMF0044_GET_SPREAD_TITLE (선택연도 1/1~12/31)
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  // memo 필수 — `?? []` 를 렌더마다 새로 만들면 Grid 의 dynColMetas/dynBindings 가 매번 새 identity 가 되어
  //   그리드 재구성 effect 가 헛돈다 (onItemCellDblClickRef 와 같은 계열).
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [],
    [spreadTitleData]
  );

  // Measure 2행 블록 정의 — PKG.P_DMF0044_GET_MEASURE (Insert 강제 세팅 원천 — GetCellNumbersByRow multiful=2)
  const { data: measureData } = useTabProcQuery<MENU_ID, SHEETS.MEASURE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MEASURE,
    tabId,
    filters: filters[SHEETS.MEASURE],
    enabled: hasSearched && !!filters[SHEETS.MEASURE],
  });
  const measureRows = useMemo<MeasureRow[]>(
    () => (measureData as { data?: MeasureRow[] } | undefined)?.data ?? [],
    [measureData]
  );

  // 신규 행 (CRUD_TYPE='I' — 2행 Measure 블록 단위, ETC 전용)
  const [insertedRows, setInsertedRows] = useState<SalesReportRow[]>([]);

  const mainData = data as { data?: SalesReportRow[] } | undefined;
  useEffect(() => {
    if (!mainData) return;
    // 재조회 = pending insert reset + EditTracker clear (hook #97)
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  // mount 시 1회 admin 메타 fetch + persist filters 무효화
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 모달 스위치 + ITEM 셀 팝업 대상 행
  const [openModal, setOpenModal] = useState<SalesReportsModalKey | null>(null);
  const [itemTargetRow, setItemTargetRow] = useState<SalesReportRow | null>(null);

  const hasPendingChanges = () =>
    insertedRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // F5 Search — Version 필수 (FindData L437 MSG00283)
  const handleSearch = async () => {
    // ⭐ [공통 UC-02, hook #133] 수정 중 재조회 = MSG00703 confirm. 취소면 조회하지 않는다
    //   (미저장 편집이 조용히 사라지는 것을 막는다). 2026-08-15 보완.
    if (hasPendingChanges()) {
      const proceed = await setAlert({
        type: 'confirm',
        content: t('MSG01016', '_수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?'),
      });
      if (!proceed) return;
    }
    const vr = validateFind(sc.versionNo);
    if (!vr.ok) {
      void setAlert({ type: 'alert', content: t(vr.msgId!, '_Version을 선택하고 조회하세요.') });
      return;
    }
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // Grid 초기화 규약 — 조회 결과의 전제(Division·Measure 구성)가 바뀌면 화면에 남은 결과는
  //   새 전제와 어긋나므로 비운다. 미저장 편집도 함께 버린다 — 남겨 두면 바뀐 전제로 저장된다.
  //   clearFilters() 가 filters[MAIN] 을 없애면 useTabProcQuery 가 disabled 되어 rows 가 비고,
  //   편집 게이트도 미조회 = ALL(전면 잠금)로 떨어진다. 다시 보려면 Search 를 눌러야 한다.
  const resetGrid = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
  };

  // Division 변경 = Grid 초기화 + CRUD reset (memory feedback_division_change_grid_reset).
  //   컬럼/Measure 메타가 division 종속이라 함께 다시 받는다.
  const handleDivisionChange = () => {
    resetGrid();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F8 Insert — Data Type=2(ETC) 전용 (AS-IS InsertRow L973 분기 return).
  //   2행 Measure 블록 삽입 — GET_MEASURE 결과(CODE 2행) 강제 세팅 (L1021~1025. 0건 = 차단).
  const handleInsert = () => {
    // 조회한 Data Type 기준 (폼 콤보만 ETC 로 바꾼 상태에서는 삽입 불가)
    if (searched.dataType !== DATA_TYPE.ETC) return; // silent (AS-IS 분기 return 파리티)
    // ⭐ 중복 제거 필수 (2026-08-10 실사고 — Insert 시 16행 생성).
    //   `P_DMF0044_GET_MEASURE` 가 `SCM_ADM_USER_MNU_EDIT_AUTH_V` 를 **INNER JOIN** 하는데
    //   조인 조건이 measure 의 `DIVISION_ID` 콤마목록(8개)과 사용자 보유 권한(8행)이라
    //   **measure 2행 × 권한 8행 = 16행**이 돌아온다(실측). SP 도 EXISTS+MAX 로 정정하지만,
    //   FE 는 "measure 목록"이라는 의미상 **중복이 있을 수 없으므로** 여기서도 방어한다.
    const measures = [...new Set(measureRows.map(r => toCellStr(r.CODE)).filter(Boolean))];
    if (measures.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', 'Measure'),
      });
      return;
    }
    const gid = `I_${Date.now()}`;
    const block: SalesReportRow[] = measures.map(measure => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      DIVISION_ID: searched.divisionId,
      // CUTOFF_TYPE = 조회한 Report Type (2026-08-11 실사고 정정).
      //   신규행에 이 값이 없으면 저장 payload 가 빈값이 되어
      //     (1) ETC 원장 INSERT 가 ORA-01400 (CUTOFF_TYPE NOT NULL)
      //     (2) SP 의 `IF v_cutoff_type = 'REPORT_SP_W'` 분기가 통째로 skip 되어
      //         PLAN 저장까지 조용히 무동작(성공 토스트만 뜨고 아무 데도 안 써짐)
      //   GET 도 `R.CUTOFF_TYPE = P_MDF_TYPE` 로 거르므로 조회에 쓴 값이어야 재조회에 보인다.
      CUTOFF_TYPE: searched.mdfType,
      MEASURE: measure,
      ...INSERT_ROW_DEFAULTS,
    }));
    setInsertedRows(prev => [...block, ...prev]);
    // ⭐ [공통 UC-01, hook #133] 필터가 걸린 상태에서도 **필터를 유지한 채** 신규행이 보여야 한다.
    //   ⛔ 필터 clear 금지 — 사용자가 걸어둔 필터까지 날아간다(2026-08-14 요구 역전).
    //   신규행만 필터 예외로 등록한다(공용 `keepRowVisibleUnderFilter` — 유일 정본).
    const grid = gridRef.current as unknown as FlexGridType<WijmoRowItem> | null;
    if (grid) block.forEach(row => keepRowVisibleUnderFilter(grid, row as unknown as WijmoRowItem));
  };

  // F9 Delete — 신규(I) 2행 블록 전체 삭제. DB 조회행 무동작(silent — AS-IS Delete action 가드)
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as SalesReportRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') return;
    const gid = sel.INSERT_GROUP_ID;
    if (gid) setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    else setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // F7 Save — Version(MSG00688) + ALL 차단(MSG00681) → Data Type 이원화 '^' bulk → passthrough → 재조회
  const handleSave = async () => {
    // 저장도 조회한 조건으로 판정한다 — 폼만 바꾼 상태에서 저장하면 화면 데이터와 다른
    //   Version/Data Type 으로 써 버린다(payload 20키 _C 와 22키 _C_CF 가 갈린다).
    const vv = validateVersionForAction(searched.versionNo);
    if (!vv.ok) {
      void setAlert({
        type: 'alert',
        content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.'),
      });
      return;
    }
    const va = validateNotAll(searched.dataType);
    if (!va.ok) {
      void setAlert({
        type: 'alert',
        content: t(va.msgId!, '_Data Type 이 ALL 인 상태에서는 편집할 수 없습니다.'),
      });
      return;
    }
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<SalesReportRow, Record<string, unknown>>
        | undefined) ?? new Map<SalesReportRow, Record<string, unknown>>();

    // 2행 세트 파트너 행 resolve (ETC — INSERT_GROUP_ID 공유 or 인접 SP 행)
    //   ⭐ AS-IS 는 세트 대표행(짝수 index i)의 값으로 identity·CELL_MODEL_* 를 채운다(L552 `i += 2`).
    //     변경이 홀수행에서 났을 수 있으므로 대표행 여부(isSetHead)까지 함께 넘긴다.
    const allRows: SalesReportRow[] = [...insertedRows, ...(mainData?.data ?? [])];
    const setInfoOf = (row: SalesReportRow): { pair?: SalesReportRow; isSetHead: boolean } => {
      if (row.INSERT_GROUP_ID) {
        const members = allRows.filter(r => r.INSERT_GROUP_ID === row.INSERT_GROUP_ID);
        return { pair: members.find(r => r !== row), isSetHead: members[0] === row };
      }
      const idx = allRows.indexOf(row);
      const isSetHead = idx % 2 === 0;
      return { pair: allRows[isSetHead ? idx + 1 : idx - 1], isSetHead };
    };

    const targets = [
      ...insertedRows.map(row => ({ row, changes: undefined, ...setInfoOf(row) })),
      ...[...changedMap.entries()]
        .filter(([row]) => row.CRUD_TYPE !== 'I')
        .map(([row, changes]) => ({ row, changes, ...setInfoOf(row) })),
    ];
    if (targets.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }

    const build = isEtc(searched.dataType)
      ? buildEtcSaveRows({ targets, versionNo: searched.versionNo })
      : buildCutoffSaveRows({ targets, versionNo: searched.versionNo });
    if (build.error) {
      void setAlert({
        type: 'alert',
        content: t(build.error.msgId ?? MSG.SAVE_ERROR, '_{0} 값은 필수 입력 항목입니다.').replace(
          '{0}',
          build.error.detail ?? ''
        ),
      });
      return;
    }
    if (build.rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_SAVE_TARGET, '_저장할 대상 데이터가 없습니다.'),
      });
      return;
    }
    const payload = buildBulkPayload(build.rows as unknown as Record<string, string>[]);
    if (!payload) return;

    try {
      const res = isEtc(searched.dataType)
        ? await callSaveEtc(payload)
        : await callSaveCutoff(payload);
      // 성공은 Toast, 실패/SP 메시지는 Alert (자매 화면 business-plan·sales-plan 동일 규약)
      if (res.message) void setAlert({ type: 'alert', content: res.message });
      else if (res.ok)
        void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      if (res.ok) {
        setInsertedRows([]);
        editTrackerRef.current?.clearChanges();
        await (refetch?.() ?? Promise.resolve());
        if (savedScroll && gridRef.current) gridRef.current.scrollPosition = savedScroll;
      }
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // Exchange Rate — pending 차단(MSG00680, AS-IS L1431 MSG00142 용법) + Version 필수(MSG00688)
  const handleExchangeRate = () => {
    const vp = validateNoPending(hasPendingChanges());
    if (!vp.ok) {
      void setAlert({ type: 'alert', content: t(vp.msgId!, '_변경 중에는 수행할 수 없습니다.') });
      return;
    }
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({
        type: 'alert',
        content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.'),
      });
      return;
    }
    setOpenModal('EXCHANGE');
  };

  // Textbox (82 전용) — Version 필수(MSG00688, AS-IS L1472)
  const handleTextbox = () => {
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({
        type: 'alert',
        content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.'),
      });
      return;
    }
    setOpenModal('TEXTBOX');
  };

  // SubTitle 공통버튼 (미명시 = DefaultButtonActions 자동, hook #64)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? () => void handleSearch() : false,
    insert: hasButton('INSERT') && searched.dataType === DATA_TYPE.ETC ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') || hasButton('SAVE_CF') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — Text(82 전용 — AS-IS lci_btnTextBox D-1) + Exchange Rate/Column/Measure 아이콘
  //   ⭐ 배치 규약 (hook #120, 사용자 명시 2026-07-30): 텍스트 버튼 먼저, 그 뒤 아이콘 버튼을
  //      왼쪽부터 **환율 → Grid Column Set → Measure** 순서로 고정. 환율은 항상 아이콘 형태.
  const customButtons = [
    ...(hasButton('TEXTBOX') && isDiv82(sc.divisionId)
      ? [
          {
            label: 'Text',
            title: 'Text',
            action: handleTextbox,
            buttonLabel: 'Text',
          },
        ]
      : []),
    // ⭐ 아이콘 버튼 표준 순서 = **환율 → 컬럼설정 → 메저** (hook #120, 2026-08-10 사용자 재확정).
    //   권한으로 일부가 빠져도 남은 것들의 상대 순서는 그대로 유지된다.
    ...(hasButton('EXCHANGE_RATE')
      ? [
          {
            label: t('LBL00661', 'Exchange Rate'),
            title: t('LBL00661', 'Exchange Rate'),
            action: handleExchangeRate,
            iconComponent: <IcExchangeRate />,
            buttonLabel: '',
          },
        ]
      : []),
    // ⛔ Grid Column Set 버튼 **숨김** (2026-08-10 사용자 지시).
    //   BTN_MPG 메타에는 COLUMN_SETUP 이 남아 있으나 이 화면에서는 노출하지 않는다.
    //   모달(`COLUMN`)과 배선은 그대로 두어 되돌릴 때 이 블록만 복원하면 된다.
    //   ⚠ 다시 노출하려면 아래 주석 블록 + `IcGridColumnSetup` import 를 함께 되살린다
    //     (권한은 메타가 이미 허용 — hasButton('COLUMN_SETUP') = true).
    // ...(hasButton('COLUMN_SETUP')
    //   ? [{ label: t('LBL00605', 'Column Setting'), title: t('LBL00605', 'Column Setting'),
    //        action: () => setOpenModal('COLUMN'), iconComponent: <IcGridColumnSetup />,
    //        buttonLabel: '' }]
    //   : []),
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenModal('MEASURE'),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  // ⭐ 조회 결과를 **가공하지 않는다** (사용자 확정 2026-08-10:
  //   "특별하게 처리하지말고 조회 시 EDIT_FLAG 을 사용하는 기존 패턴을 그대로 사용").
  //   행 `EDIT_FLAG` 는 SP 가 준 값 그대로 두고, 공용 `DataGrid` 가 컬럼 `_inputEditType` 과 묶어
  //   **색(노란색)과 편집 가능 여부를 하나의 기준으로** 결정한다.
  const spRows = useMemo<SalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  const rows: SalesReportRow[] = useMemo(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <SalesReportsForm
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          onOpenVersionModal={() => setOpenModal('VERSION')}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesReports'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* 편집 게이트(evalSalesReportCell)는 조회한 조건만 본다. 미조회 시 division 은 폼 값으로
          폴백한다 — 그리드는 비어 있고 셀 콤보만 미리 받아 두면 되기 때문. */}
      <SalesReportsGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={searched.divisionId || sc.divisionId}
        dataType={searched.dataType}
        thisMonth={thisMonth}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        onItemCellDblClick={row => {
          setItemTargetRow(row);
          setOpenModal('ITEM');
        }}
      />

      <SalesReportsModals
        divisionId={sc.divisionId}
        year={sc.yyyy}
        mdfType={sc.mdfType}
        versionNo={sc.versionNo}
        openKey={openModal}
        onClose={() => setOpenModal(null)}
        itemTargetRow={itemTargetRow}
        // Measure 선택 적용 = 조회 Measure 구성 변경 → Grid 초기화 (사용자 지시 2026-08-12).
        //   남은 결과는 이전 Measure 세트 기준이라 새 구성과 어긋난다. 재조회는 사용자가 Search 로.
        onMeasureApply={resetGrid}
        onVersionSelect={(versionNo, label) => {
          setSearchCondition({ versionNo, versionLabel: label });
        }}
      />
    </>
  );
};
