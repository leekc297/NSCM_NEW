import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { EtcSalesReportsForm } from './components/EtcSalesReportsForm';
import { EtcSalesReportsGrid } from './components/EtcSalesReportsGrid';
import {
  type EtcSalesReportsModalKey,
  EtcSalesReportsModals,
} from './components/EtcSalesReportsModals';
import { EDIT_MEASURE_LOOKUP, INSERT_ROW_DEFAULTS, measureCntOf, MENU_ID, MSG, SHEETS } from './etc-sales-reports.constants';
import type { MeasureRow, EtcSalesReportRow, SpreadTitleRow } from './etc-sales-reports.types';
import styles from './EtcSalesReports.module.scss';
import { useEtcSalesReportsStore } from './useEtcSalesReportsStore';
import { callSaveEtcReport } from './utils/etc-sales-reports.api';
import { toCellStr } from './utils/etc-sales-reports.gridCombos';
import { buildBulkPayload, buildEtcReportSaveRows, type SaveTarget } from './utils/etc-sales-reports.save';
import {
  validateEditGate,
  validateFind,
  validateVersionForAction,
} from './utils/etc-sales-reports.validate';

// AS-IS DMF0049_Sales_ETC_Reports (Demand > Demand Plan > Etc Sales Reports — 신정본 Forms.UIL 1,727행 1:1).
//   3축 분기: Report Type(SP_W/BP_M) × Data Type(ALL 차단/1=Cutoff/2=ETC) × Division(40/82).
//   조회 = PKG.P_DMF0044_GET_SALES_REPORTS_DATA (Version 필수 MSG00283) / 저장 = Data Type 이원화
//   (ETC 20키 _C / Cutoff 22키 _C_CF '^' bulk) / Insert = ETC 전용 2행 Measure 블록 (GET_MEASURE 원천).
//   커스텀: Version '...'(United)/Measure Show/Exchange Rate(pending 차단 MSG00680)/Text(82 전용).
export const EtcSalesReports = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<EtcSalesReportRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useEtcSalesReportsStore(s => s.searchCondition);
  const setSearchCondition = useEtcSalesReportsStore(s => s.setSearchCondition);
  const filters = useEtcSalesReportsStore(s => s.filters);
  const setFilter = useEtcSalesReportsStore(s => s.setFilter);
  const clearFilters = useEtcSalesReportsStore(s => s.clearFilters);
  const openSearchArea = useEtcSalesReportsStore(s => s.openSearchArea);
  const setOpenSearchArea = useEtcSalesReportsStore(s => s.setOpenSearchArea);
  const staticColumns = useEtcSalesReportsStore(s => s.staticColumns);
  const fetchStaticColumns = useEtcSalesReportsStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useEtcSalesReportsStore(s => s.fetchStaticMeasures);
  const thisMonth = useEtcSalesReportsStore(s => s.thisMonth);
  const resultMonth = useEtcSalesReportsStore(s => s.resultMonth);

  // ⭐ sEditMeasure — 기등록 범용 CMBO 'DM_LOOKUP_DIV'(param1=division, param2=DM_SR_ETC_CURRENCY).
  //   82='SalesAmt_KRW' 1행 / 40·81 빈값 (81 = 창 내에도 전 Measure 잠금 파리티).
  //   ⚠ 2026-08-10 실측 정정: 값을 따옴표로 감싸지 않으면 BE raw 치환에서 식별자로 해석돼
  //     **HTTP 500(-9994 Sql Error)** 이 난다(따옴표 O → 1행 / X → 500). 미따옴표 상태에서는
  //     sEditMeasure 가 항상 빈값이라 82 편집 개방 판정이 통째로 무력화됐다.
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const [editMeasureRows] = useTabComboQueries({
    filters: [
      {
        comboId: 'DM_LOOKUP_DIV',
        param1: q(sc.divisionId),
        param2: q(EDIT_MEASURE_LOOKUP),
      } as never,
    ],
  });
  const sEditMeasure = String((editMeasureRows?.[0] as { CODE?: string } | undefined)?.CODE ?? '');
  const userGroup = useSessionStore.getState().session.userId ?? '';

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
  const [insertedRows, setInsertedRows] = useState<EtcSalesReportRow[]>([]);

  const mainData = data as { data?: EtcSalesReportRow[] } | undefined;
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
  const [openModal, setOpenModal] = useState<EtcSalesReportsModalKey | null>(null);
  const [projectTargetRow, setProjectTargetRow] = useState<EtcSalesReportRow | null>(null);

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

  // F8 Insert — G0 그룹 게이트(MSG00096) 후 division 세트(40=3/81=2/82=1) 블록 삽입
  //   (AS-IS InsertRow L934~939 — GET_MEASURE CODE 순서 강제 세팅. 0건 = 차단).
  const handleInsert = () => {
    const vg = validateEditGate(userGroup, sc.divisionId);
    if (!vg.ok) {
      void setAlert({ type: 'alert', content: t(vg.msgId!, '_권한이 없습니다.') });
      return;
    }
    const measures = measureRows.map(r => toCellStr(r.CODE)).filter(Boolean);
    if (measures.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', 'Measure') });
      return;
    }
    const gid = `I_${Date.now()}`;
    const block: EtcSalesReportRow[] = measures.map(measure => ({
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
    const sel = g.selectedItems[0] as EtcSalesReportRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') return;
    const gid = sel.INSERT_GROUP_ID;
    if (gid) setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    else setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // F7 Save — Version(MSG00688) → G0(MSG00096) → 세트 target 조립 → 35키 '^' bulk 단일 SP →
  //   passthrough → 성공 MSG00002 + 재조회·스크롤 복원 (AS-IS SaveData L633~915)
  const handleSave = async () => {
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({ type: 'alert', content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.') });
      return;
    }
    const vg = validateEditGate(userGroup, sc.divisionId);
    if (!vg.ok) {
      void setAlert({ type: 'alert', content: t(vg.msgId!, '_권한이 없습니다.') });
      return;
    }
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<EtcSalesReportRow, Record<string, unknown>>
        | undefined) ?? new Map<EtcSalesReportRow, Record<string, unknown>>();

    // 세트 단위 target 조립 — INSERT_GROUP_ID(신규) / DATA_SEQ+인접(기존. [C20210506-000051] DATA_SEQ 우선)
    const allRows: EtcSalesReportRow[] = [...insertedRows, ...(mainData?.data ?? [])];
    const setKeyOf = (row: EtcSalesReportRow, idx: number): string => {
      if (row.INSERT_GROUP_ID) return `I:${row.INSERT_GROUP_ID}`;
      const seq = row.DATA_SEQ != null && row.DATA_SEQ !== '' ? String(row.DATA_SEQ) : '';
      if (seq) return `S:${seq}`;
      const cnt = Math.max(1, measureCntOf(sc.divisionId));
      return `P:${Math.floor(idx / cnt)}`; // fallback — 세트 크기 단위 인접 그룹
    };
    // 변경/신규가 속한 세트 수집
    const dirtyKeys = new Set<string>();
    allRows.forEach((row, idx) => {
      if (row.CRUD_TYPE === 'I' || changedMap.has(row)) dirtyKeys.add(setKeyOf(row, idx));
    });
    const setMap = new Map<string, SaveTarget>();
    allRows.forEach((row, idx) => {
      const key = setKeyOf(row, idx);
      if (!dirtyKeys.has(key)) return;
      if (!setMap.has(key)) setMap.set(key, { setRows: [], isInsert: row.CRUD_TYPE === 'I' });
      setMap.get(key)!.setRows.push({ row, changes: changedMap.get(row) });
    });
    const targets = [...setMap.values()];
    if (targets.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    const monthBindings = spreadTitleRows
      .map(r => String(r.COLUMN_NAME ?? ''))
      .filter(b => /^M_\d{6}$/.test(b))
      .sort();
    const build = buildEtcReportSaveRows({
      targets,
      versionNo: sc.versionNo,
      resultMonth,
      monthBindings,
    });
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
    const payload = buildBulkPayload(build.rows);
    if (!payload) return;
    try {
      const res = await callSaveEtcReport(payload);
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

  // Exchange Rate  // SubTitle 공통버튼 (미명시 = DefaultButtonActions 자동, hook #64)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — 아이콘 2종 (DMF0049 는 환율 버튼 없음 — AS-IS 미보유)
  // ⭐ 아이콘 버튼 표준 순서 = **환율 → 컬럼설정 → 메저** (hook #120, 2026-08-10 사용자 재확정).
  //   3종 중 일부만 있는 화면도 **남은 것들의 상대 순서**를 지킨다 → 여기서는 컬럼설정 → 메저.
  const customButtons = [
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

  const spRows = useMemo<EtcSalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  const rows: EtcSalesReportRow[] = useMemo(
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
        <EtcSalesReportsForm
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

      <EtcSalesReportsGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        planResult={sc.planResult}
        mdfType={sc.mdfType}
        yyyy={sc.yyyy}
        thisMonth={thisMonth}
        sEditMeasure={sEditMeasure}
        userGroup={userGroup}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        onProjectCellDblClick={row => {
          setProjectTargetRow(row);
          setOpenModal('PROJECT');
        }}
      />

      <EtcSalesReportsModals
        divisionId={sc.divisionId}
        mdfType={sc.mdfType}
        openKey={openModal}
        onClose={() => setOpenModal(null)}
        projectTargetRow={projectTargetRow}
        onVersionSelect={(versionNo, label) => {
          setSearchCondition({ versionNo, versionLabel: label });
        }}
      />
    </div>
  );
};
