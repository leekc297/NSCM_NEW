import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { EtcSalesReportsForm } from './components/EtcSalesReportsForm';
import { EtcSalesReportsGrid } from './components/EtcSalesReportsGrid';
import {
  type EtcSalesReportsModalKey,
  EtcSalesReportsModals,
} from './components/EtcSalesReportsModals';
import {
  dataScaleOf,
  EDIT_MEASURE_LOOKUP,
  INSERT_ROW_DEFAULTS,
  measureCntOf,
  MENU_ID,
  MSG,
  SHEETS,
} from './etc-sales-reports.constants';
import type { MeasureRow, EtcSalesReportRow, SpreadTitleRow } from './etc-sales-reports.types';
import { useEtcSalesReportsStore } from './useEtcSalesReportsStore';
import { callSaveEtcReport } from './utils/etc-sales-reports.api';
import { toCellStr } from './utils/etc-sales-reports.gridCombos';
import {
  buildBulkPayload,
  buildEtcReportSaveRows,
  type SaveTarget,
} from './utils/etc-sales-reports.save';
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
  const queryClient = useQueryClient();

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
  // ⚠ useMemo — 아래 dynScale 의 의존성이 매 렌더 바뀌지 않도록 참조를 고정한다
  //   (`?? []` 가 매번 새 배열을 만든다).
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [],
    [spreadTitleData]
  );

  // ⭐ REQ:CHAT-20260820-16 — 저장 payload 의 수량 자릿수도 **표시와 같은 메타**를 원천으로 쓴다.
  //   원천 = GET_SPREAD_TITLE 동적 M_ 분기의 DATA_SCALE_NUMBER (전 월 컬럼이 같은 값이라 첫 행이면 족하다).
  const dynScale = useMemo(
    () =>
      dataScaleOf(
        spreadTitleRows.find(r => /^M_\d{6}$/.test(String(r.COLUMN_NAME ?? '')))?.DATA_SCALE_NUMBER
      ),
    [spreadTitleRows]
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
    // void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
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

  const clearGridOnSettingChange = () => {
    setHasSearched(false); // 쿼리 disable — Search 전까지 자동 재조회 안 함
    setInsertedRows([]); // CRUD(신규행) reset
    editTrackerRef.current?.clearChanges(); // 편집 추적 reset
    clearFilters(); // filters[MAIN/SPREAD_TITLE/MEASURE] 무효화 (enabled=false)
    queryClient.removeQueries({ queryKey: [tabId] }); // 이전 조회 결과 캐시 제거
  };

  // ⭐ REQ:CHAT-20260820-15 — 조회조건 변경 시 그리드 초기화 (AS-IS `InitSpread()` 파리티).
  //   AS-IS 가 초기화 핸들러를 **실제로 등록한 조회조건은 3개뿐**이다
  //   (`DMF0049_Sales_ETC_Reports.Designer.cs:225/331/369` 등록 실측):
  //     · clbType(Report Type)  `.cs:1530~1539` — InitSpread(); txtSPVersion.Text = null;
  //                              → 버전 초기화는 Form 의 set({versionNo:'',versionLabel:''}) 이 담당
  //     · clbDivision           `.cs:1556~1564` — GetMeasure(); InitSpread(); DefineProperty()  (기구현)
  //     · clbPlanResult         `.cs:1566~1573` — InitSpread(); DefineProperty()
  //   ⚠ Year(usrYear)는 AS-IS 에 SelectedIndexChanged 등록이 **0건**이다(.cs/.Designer.cs grep 실측
  //     2026-08-20) → 초기화 대상에서 제외한다. 임의로 넣으면 AS-IS 에 없는 동작을 만드는 것이다.
  const handleReportTypeChange = () => clearGridOnSettingChange();
  const handlePlanResultChange = () => clearGridOnSettingChange();

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
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', 'Measure'),
      });
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

  // ⭐ REQ:CHAT-20260820-17 — 저장은 raw axios('^' bulk)라 react-query 키가 없어 **전역 스피너가
  //   뜨지 않는다**. 진행 피드백이 없으면 사용자가 연타하거나 다른 화면으로 이동한 뒤 완료 알림을 받는다.
  //   ⇒ 화면 자체 saving 상태로 ①오버레이 스피너 ②저장 버튼 비활성 ③중복 클릭 차단
  //   (형제 정본 = 같은 날 적용된 sales-reports/SalesReports.tsx:234~245).
  const [saving, setSaving] = useState(false);
  const savingRef = useRef(false);

  // F7 Save — Version(MSG00688) → G0(MSG00096) → 세트 target 조립 → 35키 '^' bulk 단일 SP →
  //   passthrough → 성공 MSG00002 + 재조회·스크롤 복원 (AS-IS SaveData L633~915)
  const runSave = async () => {
    const vv = validateVersionForAction(sc.versionNo);
    if (!vv.ok) {
      void setAlert({
        type: 'alert',
        content: t(vv.msgId!, '_Version을 검색 후 조회하신 후에 입력이 가능합니다.'),
      });
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
      scale: dynScale,
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
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_SAVE_TARGET, '_저장할 대상 데이터가 없습니다.'),
      });
      return;
    }
    const payload = buildBulkPayload(build.rows);
    if (!payload) return;
    try {
      const res = await callSaveEtcReport(payload);
      // ⭐ REQ:CHAT-20260820-17 — **성공은 Toast**, SP passthrough 메시지·예외는 Alert 유지
      //   (hook #132 §3 — CRUD 완료 알림은 하단 중앙 Toast 후 자동 소멸. 실패는 사용자가 닫아야 한다).
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

  const handleSave = async () => {
    if (savingRef.current) return; // 연타 차단 — 같은 payload 2회 저장 방지
    savingRef.current = true;
    setSaving(true);
    try {
      await runSave();
    } finally {
      savingRef.current = false;
      setSaving(false);
    }
  };

  // Exchange Rate  // SubTitle 공통버튼 (미명시 = DefaultButtonActions 자동, hook #64)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    // 저장 진행 중에는 버튼 자체를 비활성 (REQ:CHAT-20260820-17 — savingRef 와 2중 차단)
    save: hasButton('SAVE') && !saving ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — 아이콘 1종 (DMF0049 는 환율 버튼 없음 — AS-IS 미보유)
  // ⭐ 아이콘 버튼 표준 순서 = **환율 → 컬럼설정 → 메저** (hook #120, 2026-08-10 사용자 재확정).
  //   3종 중 일부만 있는 화면도 **남은 것들의 상대 순서**를 지킨다 → 여기서는 메저만 남는다.
  const customButtons = [
    // ⛔ Grid Column Set 버튼 **숨김** (2026-08-11 사용자 지시 — DMF0044 2026-08-10 선례 동일).
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

  const spRows = useMemo<EtcSalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  const rows: EtcSalesReportRow[] = useMemo(
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
        <EtcSalesReportsForm
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          onReportTypeChange={handleReportTypeChange}
          onPlanResultChange={handlePlanResultChange}
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

      {/* 저장 진행 오버레이 (REQ:CHAT-20260820-17) — '^' bulk 저장은 react-query 밖이라
          전역 스피너가 뜨지 않는다. 화면 스피너로 진행 중임을 알린다. */}
      <ProgressIndicator shape='circular' placement='parent' open={saving} />

      <EtcSalesReportsModals
        divisionId={sc.divisionId}
        mdfType={sc.mdfType}
        openKey={openModal}
        onClose={() => setOpenModal(null)}
        onGridReset={clearGridOnSettingChange}
        projectTargetRow={projectTargetRow}
        onVersionSelect={(versionNo, label) => {
          setSearchCondition({ versionNo, versionLabel: label });
        }}
      />
    </>
  );
};
