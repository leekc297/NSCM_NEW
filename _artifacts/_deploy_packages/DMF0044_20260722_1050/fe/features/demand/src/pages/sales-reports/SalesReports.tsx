import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesReportsForm } from './components/SalesReportsForm';
import { SalesReportsGrid } from './components/SalesReportsGrid';
import {
  type SalesReportsModalKey,
  SalesReportsModals,
} from './components/SalesReportsModals';
import { DATA_TYPE, INSERT_ROW_DEFAULTS, MENU_ID, MSG, SHEETS } from './sales-reports.constants';
import type { MeasureRow, SalesReportRow, SpreadTitleRow } from './sales-reports.types';
import styles from './SalesReports.module.scss';
import { useSalesReportsStore } from './useSalesReportsStore';
import { callSaveCutoff, callSaveEtc } from './utils/sales-reports.api';
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
  const spreadTitleRows = (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [];

  // Measure 2행 블록 정의 — PKG.P_DMF0044_GET_MEASURE (Insert 강제 세팅 원천 — GetCellNumbersByRow multiful=2)
  const { data: measureData } = useTabProcQuery<MENU_ID, SHEETS.MEASURE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MEASURE,
    tabId,
    filters: filters[SHEETS.MEASURE],
    enabled: hasSearched && !!filters[SHEETS.MEASURE],
  });
  const measureRows = useMemo<MeasureRow[]>(
    () => ((measureData as { data?: MeasureRow[] } | undefined)?.data ?? []),
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
  const handleSearch = () => {
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

  // ⭐ Division 변경 = Grid 초기화 + CRUD reset (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F8 Insert — Data Type=2(ETC) 전용 (AS-IS InsertRow L973 분기 return).
  //   2행 Measure 블록 삽입 — GET_MEASURE 결과(CODE 2행) 강제 세팅 (L1021~1025. 0건 = 차단).
  const handleInsert = () => {
    if (sc.dataType !== DATA_TYPE.ETC) return; // silent (AS-IS 분기 return 파리티)
    const measures = measureRows.map(r => toCellStr(r.CODE)).filter(Boolean);
    if (measures.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', 'Measure') });
      return;
    }
    const gid = `I_${Date.now()}`;
    const block: SalesReportRow[] = measures.map(measure => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      DIVISION_ID: sc.divisionId,
      MEASURE: measure,
      ...INSERT_ROW_DEFAULTS,
    }));
    setInsertedRows(prev => [...block, ...prev]);
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
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({ type: 'alert', content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.') });
      return;
    }
    const va = validateNotAll(sc.dataType);
    if (!va.ok) {
      void setAlert({ type: 'alert', content: t(va.msgId!, '_Data Type 이 ALL 인 상태에서는 편집할 수 없습니다.') });
      return;
    }
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<SalesReportRow, Record<string, unknown>>
        | undefined) ?? new Map<SalesReportRow, Record<string, unknown>>();

    // 2행 세트 파트너 행 resolve (ETC — INSERT_GROUP_ID 공유 or 인접 SP 행)
    const allRows: SalesReportRow[] = [...insertedRows, ...(mainData?.data ?? [])];
    const pairOf = (row: SalesReportRow): SalesReportRow | undefined => {
      if (row.INSERT_GROUP_ID) {
        return allRows.find(r => r !== row && r.INSERT_GROUP_ID === row.INSERT_GROUP_ID);
      }
      const idx = allRows.indexOf(row);
      // AS-IS 2행 세트 = 짝수행+홀수행 (i, i+1) — 인접 행이 파트너
      const cand = idx % 2 === 0 ? allRows[idx + 1] : allRows[idx - 1];
      return cand;
    };

    const targets = [
      ...insertedRows.map(row => ({ row, changes: undefined, pair: pairOf(row) })),
      ...[...changedMap.entries()]
        .filter(([row]) => row.CRUD_TYPE !== 'I')
        .map(([row, changes]) => ({ row, changes, pair: pairOf(row) })),
    ];
    if (targets.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }

    const build = isEtc(sc.dataType)
      ? buildEtcSaveRows({ targets, versionNo: sc.versionNo })
      : buildCutoffSaveRows({ targets, versionNo: sc.versionNo });
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
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_TARGET, '_저장할 대상 데이터가 없습니다.') });
      return;
    }
    const payload = buildBulkPayload(build.rows as unknown as Record<string, string>[]);
    if (!payload) return;

    try {
      const res = isEtc(sc.dataType) ? await callSaveEtc(payload) : await callSaveCutoff(payload);
      if (res.message) void setAlert({ type: 'alert', content: res.message });
      else if (res.ok) void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
      if (res.ok) {
        setInsertedRows([]);
        editTrackerRef.current?.clearChanges();
        await (refetch?.() ?? Promise.resolve());
        if (savedScroll && gridRef.current) gridRef.current.scrollPosition = savedScroll;
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
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
      void setAlert({ type: 'alert', content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.') });
      return;
    }
    setOpenModal('EXCHANGE');
  };

  // Textbox (82 전용) — Version 필수(MSG00688, AS-IS L1472)
  const handleTextbox = () => {
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({ type: 'alert', content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.') });
      return;
    }
    setOpenModal('TEXTBOX');
  };

  // SubTitle 공통버튼 (미명시 = DefaultButtonActions 자동, hook #64)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && sc.dataType === DATA_TYPE.ETC ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') || hasButton('SAVE_CF') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — Exchange Rate / Text(82 전용 — AS-IS lci_btnTextBox D-1) + Column/Measure 아이콘
  const customButtons = [
    ...(hasButton('EXCHANGE_RATE')
      ? [
          {
            label: t('LBL00661', 'Exchange Rate'),
            title: t('LBL00661', 'Exchange Rate'),
            action: handleExchangeRate,
            buttonLabel: t('LBL00661', 'Exchange Rate'),
          },
        ]
      : []),
    ...(hasButton('TEXTBOX') && sc.divisionId === '82'
      ? [
          {
            label: 'Text',
            title: 'Text',
            action: handleTextbox,
            buttonLabel: 'Text',
          },
        ]
      : []),
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenModal('COLUMN'),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
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

  const spRows = useMemo<SalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  const rows: SalesReportRow[] = useMemo(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

  return (
    <div className={styles.container}>
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

      <SalesReportsGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        dataType={sc.dataType}
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
        onVersionSelect={(versionNo, label) => {
          setSearchCondition({ versionNo, versionLabel: label });
        }}
      />
    </div>
  );
};
