import type { Point } from '@mescius/wijmo';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcExchangeRate, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { pinInsertedRow, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

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
  buildSetKeyMap,
  findGroupTopIndex,
  type GroupKeyColumn,
  groupKeyBindings,
  setHeadIndexOf,
} from './utils/sales-reports.merge';
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
  const restoreSearchConditions = useSalesReportsStore(s => s.restoreSearchConditions);
  const thisMonth = useSalesReportsStore(s => s.thisMonth);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // Division 기본 선택 (DMF0003/DMF0040/DMF0053 정본 통일). 비어 있을 때만 채움 - 기존 값은 유지.
  const session = useSessionStore(s => s.session);
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    if (sc.divisionId) return;
    const codes = (myDivisions ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchCondition({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [myDivisions, sc.divisionId, session.div, setSearchCondition]);

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

  // 신규 세트 (CRUD_TYPE='I' — 2행 Measure 블록 단위, ETC 전용).
  //   AS-IS InsertRow 는 신규 세트를 맨 위가 아니라 **포커스 행이 속한 세트 바로 위**에 넣는다
  //   (`.cs:931~933`). 그래서 블록마다 "어느 SP 행 **앞**에 붙는지"(anchor)를 함께 들고,
  //   화면 행은 SP 결과 + 블록으로 **매번 계산**한다.
  //   금지: 합쳐진 행 배열을 state 로 들지 말 것 — 재조회가 캐시 히트면 `data` identity 가 그대로라
  //   동기화 effect 가 돌지 않아 그리드가 빈 채로 남는다.
  interface InsertBlock {
    gid: string;
    anchor: SalesReportRow | null; // null = 맨 위
    rows: SalesReportRow[];
  }
  const [insertBlocks, setInsertBlocks] = useState<InsertBlock[]>([]);
  // Insert 직후 포커스를 옮길 신규행(블록 첫 행) — rows 재계산 후 effect 가 소비하고 비운다.
  const focusRowRef = useRef<SalesReportRow | null>(null);
  // Insert 직전 선택돼 있던 컬럼 — handleInsert 시점(= itemsSource 교체 전)에 캡처해 둔다.
  //   포커스 복원 effect 에서 그 시점의 grid.selection.col 을 실시간으로 읽으면, itemsSource
  //   가 이미 바뀌어 wijmo 가 selection 을 초기화한 뒤라 항상 0(맨 왼쪽 No 컬럼)이 된다.
  const focusColRef = useRef<number>(0);
  // Insert 직전 스크롤 위치 — 같은 이유로 캡처해 둔다. itemsSource 교체가 스크롤을 맨 위로
  //   되돌리는데, 그 상태에서 바로 scrollIntoView 하면 신규행이 뷰포트 최상단에 붙어 화면이
  //   방금 보던 위치에서 뚝 떨어진 것처럼 튄다. 복원해 두면 이미 보이는 범위면 아예 안 움직이고,
  //   범위 밖이면 거기서부터 최소한만 스크롤한다.
  const focusScrollRef = useRef<Point | null>(null);

  const mainData = data as { data?: SalesReportRow[] } | undefined;
  useEffect(() => {
    if (!mainData) return;
    // 재조회 = pending insert reset + EditTracker clear (hook #97)
    setInsertBlocks([]);
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  // ⭐ 조회 결과를 **가공하지 않는다** (사용자 확정 2026-08-10:
  //   "특별하게 처리하지말고 조회 시 EDIT_FLAG 을 사용하는 기존 패턴을 그대로 사용").
  //   행 `EDIT_FLAG` 는 SP 가 준 값 그대로 두고, 공용 `DataGrid` 가 컬럼 `_inputEditType` 과 묶어
  //   **색(노란색)과 편집 가능 여부를 하나의 기준으로** 결정한다.
  const spRows = useMemo<SalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  const insertedRows = useMemo(() => insertBlocks.flatMap(b => b.rows), [insertBlocks]);
  const rows = useMemo<SalesReportRow[]>(() => {
    if (insertBlocks.length === 0) return spRows;
    const spSet = new Set(spRows);
    const byAnchor = new Map<SalesReportRow | null, SalesReportRow[]>();
    insertBlocks.forEach(b => {
      // anchor 가 사라진 블록(재조회 직전 등)은 맨 위로 — 조용히 증발하지 않게 한다
      const key = b.anchor && spSet.has(b.anchor) ? b.anchor : null;
      byAnchor.set(key, [...(byAnchor.get(key) ?? []), ...b.rows]);
    });
    const out: SalesReportRow[] = [...(byAnchor.get(null) ?? [])];
    spRows.forEach(r => {
      const ins = byAnchor.get(r);
      if (ins) out.push(...ins);
      out.push(r);
    });
    return out;
  }, [spRows, insertBlocks]);

  // Insert 직후 새 블록 첫 행으로 포커스·스크롤 이동 (DMF0021 SalesPlan 선례 1:1).
  //   필수: 이 복원이 없으면 itemsSource 배열이 새로 바뀔 때 wijmo 가 CollectionView 를 다시
  //   만들면서 선택을 초기화한다 = 매 Insert 마다 포커스가 엉뚱한 행으로 튄다. 이 화면은
  //   `handleInsert` 가 **선택 행**으로 다음 삽입 위치(anchor)를 정하므로, 포커스가 틀어지면
  //   그 다음 행추가가 들어갈 자리까지 함께 어긋난다.
  //   필수: 실패 시 다음 프레임에 한 번 더 시도한다 — 이 시점에 grid.rows 가 아직 새 배열을
  //   반영하지 않았으면 인덱스를 못 찾고 그대로 빠져나간다. 재시도 후에도 못 찾으면 조용히 포기.
  useEffect(() => {
    const target = focusRowRef.current;
    if (!target) return;
    const grid = gridRef.current;
    if (!grid) return;
    const focusTarget = (): boolean => {
      let rowIndex = -1;
      for (let i = 0; i < grid.rows.length; i++) {
        if (grid.rows[i]?.dataItem === target) {
          rowIndex = i;
          break;
        }
      }
      if (rowIndex < 0) return false;
      // itemsSource 교체로 리셋된 스크롤을 Insert 이전 위치로 먼저 되돌린다 
      // — 이미 보이는 범위면 scrollIntoView 가 아무 것도 안 움직인다(맨 위에 붙어 튀는 현상 방지).
      if (focusScrollRef.current) grid.scrollPosition = focusScrollRef.current;
      grid.select(rowIndex, focusColRef.current);
      grid.scrollIntoView(rowIndex, -1);
      return true;
    };
    if (focusTarget()) {
      focusRowRef.current = null;
      return;
    }
    const frame = window.requestAnimationFrame(() => {
      if (focusTarget()) focusRowRef.current = null;
    });
    return () => window.cancelAnimationFrame(frame);
  }, [rows]);

  // ⭐ 세트키 맵 — **병합(보이는 범위)과 저장(쓰이는 범위)의 단일 원천**.
  //   둘이 갈리면 병합 블록이 2행 세트를 넘어가고, wijmo 가 블록 전 행에 값을 쓰면서
  //   "한 칸 고쳤는데 다른 세트까지 바뀌고 정작 저장은 안 되는" 상태가 된다
  //   (근거·AS-IS 대조는 `utils/sales-reports.merge.ts` 상단 주석).
  const setKeys = useMemo(() => buildSetKeyMap(rows), [rows]);

  // mount 시 1회 admin 메타 fetch + persist filters 무효화
  //   필수: F6 저장 조회조건 복원을 먼저 await 한다 — fetchStaticColumns/fetchStaticMeasures 가
  //   조회조건의 divisionId 를 admin 메타 SP 로 넘기므로, 복원된 division 기준으로 받아야 한다.
  useEffect(() => {
    clearFilters();
    void (async () => {
      await restoreSearchConditions();
      await fetchStaticColumns();
      await fetchStaticMeasures();
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 모달 스위치 + ITEM 셀 팝업 대상 행
  const [openModal, setOpenModal] = useState<SalesReportsModalKey | null>(null);
  const [itemTargetRow, setItemTargetRow] = useState<SalesReportRow | null>(null);

  // 저장 진행 상태 — 렌더용 state 와 즉시 판정용 ref 를 함께 둔다(연타는 리렌더 전에 들어온다)
  const [saving, setSaving] = useState(false);
  const savingRef = useRef(false);

  const hasPendingChanges = () =>
    insertedRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  /**
   * 셀 팝업 선택값 반영 — **세트(그룹) 전체**에 쓴다 (2026-08-22 결함 정정).
   *
   * 팝업은 wijmo 편집 경로를 타지 않는다. 그래서 대상 행에 그냥 대입하면 **그 행 하나만** 바뀐다
   * (사용자 리포트 — "다른 컬럼처럼 그룹된 데이터에 안 들어가고 한 row 에만 들어간다").
   * 다른 컬럼은 편집 커밋이 병합 블록(= 세트) 전 행에 쓰이므로 세트가 함께 바뀐다.
   *
   * 필수: 변경 등록(EditTracker)도 여기서 한다. 값만 바꾸면 `getOriginalValues()` 에 안 들어가
   *   저장부가 그 세트를 dirty 로 보지 않아 **조용히 저장에서 빠진다**.
   */
  const applyPopupSelection = (target: SalesReportRow, values: Record<string, unknown>) => {
    const key = setKeys.get(target);
    const members = key ? rows.filter(r => setKeys.get(r) === key) : [target];
    const tracker = editTrackerRef.current as
      | {
          storeChange?: (
            row: unknown,
            binding: string,
            oldValue: unknown,
            newValue: unknown
          ) => void;
        }
      | undefined;
    members.forEach(row => {
      const rec = row as Record<string, unknown>;
      Object.entries(values).forEach(([binding, value]) => {
        const previous = rec[binding];
        if (previous === value) return;
        rec[binding] = value;
        tracker?.storeChange?.(row, binding, previous, value);
      });
    });
    gridRef.current?.invalidate();
  };

  /** 지금 포커스된 행의 dataItem — 병합 셀은 블록 top 이 선택되므로 그 행이 곧 세트 대표다. */
  const focusedRow = (): SalesReportRow | undefined => {
    const g = gridRef.current;
    const r = g?.selection?.row ?? -1;
    if (!g || r < 0) return undefined;
    return g.rows[r]?.dataItem as SalesReportRow | undefined;
  };

  /**
   * 포커스 셀이 속한 **머지 블록의 첫 행** — Insert 앵커 (sales-plan / mkt-fcst 와 같은 규칙).
   *
   * 어느 컬럼을 눌렀는지가 범위를 정한다 — Department 셀이면 그 아래 여러 세트를, Model 셀이면
   * 그 안의 세트만 덮는다(`groupKeyBindings` 주석 참조).
   *
   * 금지: wijmo 컬렉션(`g.columns` / `g.rows`)에 `.map` / `.filter` 를 쓰지 말 것 — Array 파생
   *   클래스라 species 규칙에 따라 새 ObservableArray 가 만들어진다. 인덱스 루프로 복사한다.
   */
  const groupTopRowOf = (index: number): SalesReportRow | null => {
    const g = gridRef.current;
    if (!g || index < 0) return null;
    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const gridRowItems: (SalesReportRow | undefined)[] = [];
    for (let i = 0; i < g.rows.length; i++) {
      gridRowItems.push(g.rows[i]?.dataItem as SalesReportRow | undefined);
    }
    const keyBindings = groupKeyBindings(columns, g.selection.col);
    const top = findGroupTopIndex(gridRowItems, index, keyBindings);
    return (g.rows[top]?.dataItem as SalesReportRow | undefined) ?? null;
  };

  // F5 Search — Version 필수 (FindData L437 MSG00283)
  const handleSearch = () => {
    const vr = validateFind(sc.versionNo);
    if (!vr.ok) {
      void setAlert({ type: 'alert', content: t(vr.msgId!, '_Version을 선택하고 조회하세요.') });
      return;
    }
    setInsertBlocks([]);
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
    setInsertBlocks([]);
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

  // ⭐ Report Type(MDF_TYPE) 변경 = Grid 초기화 (REQ:CHAT-20260820-2, 사용자 지정 2026-08-20).
  //   AS-IS `DMF0044_Sales_Reports.cs` clbType_SelectedIndexChanged 는 `InitSpread()` 로 시트를
  //   통째로 재생성한다 = 화면에 남은 조회결과 소멸. Report Type 은 조회·저장 키(CUTOFF_TYPE)이자
  //   Measure 구성의 전제라, 바뀐 뒤 남은 행을 저장하면 다른 CUTOFF_TYPE 으로 써 버린다.
  const handleReportTypeChange = () => {
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
    // 삽입 후 포커스를 되돌릴 대상 = 새 블록의 첫 행 (아래 rows effect 가 소비).
    focusRowRef.current = block[0] ?? null;
    // itemsSource 가 바뀌기 전인 지금 컬럼을 캡처 — 늦게 읽으면 wijmo 가 이미 선택을 초기화한 뒤다.
    focusColRef.current = Math.max(0, gridRef.current?.selection.col ?? 0);
    focusScrollRef.current = gridRef.current?.scrollPosition ?? null;
    // 신규 블록은 **포커스 셀이 속한 머지 그룹 최상단** 바로 위에 끼운다 (사용자 지시 2026-08-23 —
    //   sales-plan / mkt-fcst 와 같은 규칙). 종전에는 AS-IS `.cs:931~933` 파리티
    //   (SetActiveCell(세트 첫 행) → Insert(2))로 포커스한 2행 세트 바로 위에 넣었는데, 그러면 크게
    //   묶인 병합 덩어리 한가운데가 갈라져 보인다. 포커스가 없으면 맨 위.
    const target = focusedRow();
    const grid = gridRef.current;
    // 정렬이 걸려 있어도 신규 블록이 앵커 옆에 계속 붙어 보이도록 pin 등록(pinInsertedRow).
    //   앵커 계산 자체는 아래 두 분기가 그대로 하고, 여기선 그 결과를 grid 에 등록만 한다.
    const pinBlock = (anchor: SalesReportRow | null) => {
      if (!grid) return;
      block.forEach(row =>
        pinInsertedRow(grid as never, row as never, (anchor as never) ?? undefined)
      );
    };
    if (target?.CRUD_TYPE === 'I') {
      // 포커스가 신규 블록이면 그 블록과 같은 자리에서 **바로 앞**에 끼운다
      const i = insertBlocks.findIndex(b => b.rows.includes(target));
      pinBlock(i < 0 ? null : insertBlocks[i].anchor);
      setInsertBlocks(prev => {
        const idx = prev.findIndex(b => b.rows.includes(target));
        if (idx < 0) return [...prev, { gid, anchor: null, rows: block }];
        return [
          ...prev.slice(0, idx),
          { gid, anchor: prev[idx].anchor, rows: block },
          ...prev.slice(idx),
        ];
      });
      return;
    }
    // 머지 그룹 최상단까지 앵커를 올린 뒤 **세트 첫 행에 맞춰 스냅**한다.
    //   필수: 스냅을 빼지 말 것 — 세트 경계가 아닌 자리에 블록이 끼면 `buildSetKeyMap` 의
    //   `P:floor(idx/size)` 짝이 그 아래로 전부 밀려 병합 범위와 저장 범위가 함께 어긋난다.
    const groupTop = groupTopRowOf(gridRef.current?.selection.row ?? -1) ?? target;
    const anchor = spRows[setHeadIndexOf(spRows, groupTop, setKeys)] ?? null;
    pinBlock(anchor);
    setInsertBlocks(prev => [...prev, { gid, anchor, rows: block }]);
  };

  // F9 Delete — 선택 행이 속한 **2행 세트 전체**를 그리드에서 지운다 (AS-IS DeleteButton `.cs:254~265`).
  //   ⚠ 2026-08-22 결함 정정 — 종전에는 `CRUD_TYPE !== 'I'` 면 조용히 return 해서 **조회행에서
  //     Delete 가 아무 반응도 없었다**. 근거로 삼았던 AS-IS 의 "신규행만" 가드는 원문에서
  //     **주석 처리돼 있다**(`//if (GetText(ActiveRowIndex, Action) != "I") return;`) — 즉 AS-IS 는
  //     조회행도 지운다.
  //   주의: DB 삭제가 아니라 **화면에서만** 제거다(AS-IS `siMain.Delete()` 파리티).
  //     저장 payload 에 삭제 플래그가 없고, 재조회(Search)하면 다시 나온다.
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    // ⚠ 드래그 다중 선택 — `selectedItems[0]` 만 보면 **마지막 포커스 행 하나만** 처리된다
    //   (2026-08-22 리포트). 선택된 행 전부를 대상으로 삼는다.
    const selected = (g.selectedItems ?? []) as SalesReportRow[];
    if (selected.length === 0) return;
    // ETC(Data Type=2) 전용 — Insert 와 같은 범위다. Cutoff 저장 SP(`_C_CF`)에는 ACTIVE_FLAG='D'
    //   처리가 **없어서** D 로 마킹해도 'M'(UPDATE)으로 나가 조용히 안 지워진다.
    if (searched.dataType !== DATA_TYPE.ETC) return; // silent (AS-IS 분기 return 파리티)

    // 선택 행을 각자의 **세트 전체**로 넓힌다(드래그는 여러 세트를 걸친다). 세트 판정은
    //   병합·저장과 같은 `setKeys` 를 쓰므로 보이는 병합 범위와 일치한다.
    const seenKeys = new Set<string>();
    const targets = new Set<SalesReportRow>();
    selected.forEach(r => {
      const key = setKeys.get(r);
      if (!key) {
        targets.add(r);
        return;
      }
      if (seenKeys.has(key)) return; // 같은 세트를 여러 번 훑지 않는다
      seenKeys.add(key);
      rows.forEach(x => {
        if (setKeys.get(x) === key) targets.add(x);
      });
    });

    const dropGids = new Set<string>();
    const dropRows = new Set<SalesReportRow>();
    const markDeleted: SalesReportRow[] = [];
    targets.forEach(r => {
      if (r.CRUD_TYPE !== 'I') {
        markDeleted.push(r);
        return;
      }
      if (r.INSERT_GROUP_ID) dropGids.add(r.INSERT_GROUP_ID);
      else dropRows.add(r);
    });

    // 신규행 — 행 자체를 없앤다
    if (dropGids.size > 0 || dropRows.size > 0) {
      setInsertBlocks(prev =>
        prev
          .map(b =>
            dropGids.has(b.gid)
              ? { ...b, rows: [] }
              : { ...b, rows: b.rows.filter(r => !dropRows.has(r)) }
          )
          .filter(b => b.rows.length > 0)
      );
    }
    // 조회행 — 공용 규약(`GridAction.removeRow`)대로 **status 'D' 마킹**. 행은 화면에 남고
    //   행 헤더에 D 가 뜨며, 저장 때 `activeFlag='D'` 로 나가 SP 가 원장에서 지운다.
    markDeleted.forEach(r => {
      r.CRUD_TYPE = 'D';
    });
    g.invalidate();
  };

  // F7 Save 본체 — Version(MSG00688) + ALL 차단(MSG00681) → Data Type 이원화 '^' bulk →
  //   passthrough → 재조회. 진입점 handleSave 는 아래에 둔다(선언 순서 = no-use-before-define).
  const runSave = async () => {
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

    // 2행 세트 파트너 행 resolve — 세트키는 그리드 병합과 **같은 맵**(`setKeys`)에서 가져온다.
    //   (ETC — INSERT_GROUP_ID 공유 or 인접 SP 행. 규약 전문은 `utils/sales-reports.merge.ts`)
    //   ⭐ AS-IS 는 세트 대표행(짝수 index i)의 값으로 identity·CELL_MODEL_* 를 채운다(L552 `i += 2`).
    //     변경이 홀수행에서 났을 수 있으므로 대표행 여부(isSetHead)까지 함께 넘긴다.
    const membersByKey = new Map<string, SalesReportRow[]>();
    rows.forEach(row => {
      const key = setKeys.get(row) ?? '';
      const bucket = membersByKey.get(key);
      if (bucket) bucket.push(row);
      else membersByKey.set(key, [row]);
    });
    const setInfoOf = (row: SalesReportRow): { pair?: SalesReportRow; isSetHead: boolean } => {
      const members = membersByKey.get(setKeys.get(row) ?? '') ?? [row];
      return { pair: members.find(r => r !== row), isSetHead: members[0] === row };
    };

    // Delete(F9) 마킹 세트 — 변경 기록이 없어도 저장 대상이다(`changedMap` 에 안 들어간다).
    const deletedRows = rows.filter(row => row.CRUD_TYPE === 'D');
    const targets = [
      ...insertedRows.map(row => ({ row, changes: undefined, ...setInfoOf(row) })),
      ...deletedRows.map(row => ({ row, changes: undefined, ...setInfoOf(row) })),
      ...[...changedMap.entries()]
        .filter(([row]) => row.CRUD_TYPE !== 'I' && row.CRUD_TYPE !== 'D')
        .map(([row, changes]) => ({ row, changes, ...setInfoOf(row) })),
    ];
    if (targets.length === 0) {
      // 변경/신규 없음 → toast + 공통 문구 (DMF0003~0007/0020/0072 과 동일 규약).
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }

    // 삭제(D)는 SP 매칭 키에 `SUBSTR(YYYYMMDD,1,6)` 이 있어 **조회 연도 전 월**을 내보내야
    //   세트가 통째로 지워진다(부분 월만 보내면 그 월만 지워진다).
    const monthBindings = spreadTitleRows
      .map(r => String(r.COLUMN_NAME ?? ''))
      .filter(b => /^M_\d{6}$/.test(b))
      .sort();
    const build = isEtc(searched.dataType)
      ? buildEtcSaveRows({ targets, versionNo: searched.versionNo, monthBindings })
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
        setInsertBlocks([]);
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

  // F7 Save 진입점 — REQ:CHAT-20260820-4 (사용자 지정 2026-08-20): 저장은 raw axios('^' bulk)라
  //   react-query 키가 없어 전역 스피너(useIsBusy)가 뜨지 않는다. 저장이 수 분 걸리는 동안 아무
  //   피드백이 없어 사용자가 다른 화면으로 이동한 뒤 완료 메시지가 뒤늦게 뜨는 현상(신고)의 직접 원인.
  //   화면 자체 saving 상태로 오버레이 스피너 · 저장 버튼 비활성 · 중복 클릭 차단 3가지를 건다.
  //   필수: runSave 아래에 둔다 — 위에 두면 no-use-before-define.
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
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && searched.dataType === DATA_TYPE.ETC ? handleInsert : false,
    // ETC(Data Type=2) 전용 — Insert 와 동일 범위. Cutoff 저장 SP(`_C_CF`)는 ACTIVE_FLAG='D'
    //   취급이 0건(AS-IS 실측)이라 Cutoff 에서는 눌러도 저장에 반영되지 않는다.
    //   종전엔 버튼이 보이면서 handleDelete 가 silent return 해 "눌러도 무반응"이었다.
    delete: hasButton('DELETE') && searched.dataType === DATA_TYPE.ETC ? handleDelete : false,
    // 금지: 저장 중이라고 `false` 를 넘기지 말 것 (2026-08-21 결함 정정).
    //   `HotkeyConfig` 의 `false` 는 "비활성"이 아니라 **버튼 미렌더**다 — 공용
    //   `SubTitle.tsx` 가 `{buttonActions.save === false || (<Button .../>)}` 로 그린다.
    //   그래서 저장을 누르면 Save 버튼이 사라졌다가 끝나면 다시 나타났다.
    //   연타는 `savingRef` 가 동기로 막고(handleSave 진입 가드), 진행 표시는
    //   ProgressIndicator 오버레이가 한다 (REQ:CHAT-20260820-17).
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
          onReportTypeChange={handleReportTypeChange}
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
        reportType={searched.mdfType}
        thisMonth={thisMonth}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        setKeys={setKeys}
        onItemCellDblClick={row => {
          setItemTargetRow(row);
          setOpenModal('ITEM');
        }}
      />

      {/* 저장 진행 오버레이 (REQ:CHAT-20260820-4) — '^' bulk 저장은 react-query 밖이라
          전역 스피너가 뜨지 않는다. 화면 스피너로 진행 중임을 알린다. */}
      <ProgressIndicator shape='circular' placement='parent' open={saving} />

      <SalesReportsModals
        divisionId={sc.divisionId}
        year={sc.yyyy}
        mdfType={sc.mdfType}
        versionNo={sc.versionNo}
        openKey={openModal}
        onClose={() => setOpenModal(null)}
        itemTargetRow={itemTargetRow}
        onItemSelect={applyPopupSelection}
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
