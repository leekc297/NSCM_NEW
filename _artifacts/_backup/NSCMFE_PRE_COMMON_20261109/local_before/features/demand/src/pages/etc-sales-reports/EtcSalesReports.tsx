import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
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
  MENU_ID,
  MSG,
  SHEETS,
} from './etc-sales-reports.constants';
import type { MeasureRow, EtcSalesReportRow, SpreadTitleRow } from './etc-sales-reports.types';
import { useEtcSalesReportsStore } from './useEtcSalesReportsStore';
import { callSaveEtcReport } from './utils/etc-sales-reports.api';
import { toCellStr } from './utils/etc-sales-reports.gridCombos';
import { buildSetKeyMap, type GroupKeyColumn, groupKeyBindings } from './utils/etc-sales-reports.merge';
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
  const restoreSearchConditions = useEtcSalesReportsStore(s => s.restoreSearchConditions);
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

  // Division 기본 선택 (DMF0003/DMF0040/DMF0044 정본 통일). 비어 있을 때만 채움 - 기존 값은 유지.
  //   store 초기값이 빈 값이라(useEtcSalesReportsStore initSearch) 진입 시 세션 division 이
  //   FilterMyDivision(카탈로그 MyDivision) 목록에 있으면 그것, 없으면 목록 첫 행이 세팅된다
  //   (AS-IS 진입 시 콤보 첫 항목 자동선택 파리티).
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

  // GridAction.addRowSet 는 itemsSource 배열을 직접 splice 하고 setState 를 호출하지 않는다 —
  //   React 리렌더가 안 일어나면 이 컴포넌트가 파생하는 값(insertedRows/setKeys 등)이
  //   Insert/Delete 이후에도 그 이전 렌더 시점 값에 멈춰 있는다. handleInsert/handleDelete
  //   끝에서 이 카운터를 올려 강제로 한 번 리렌더시킨다.
  const [, forceGridRerender] = useState(0);

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

  const mainData = data as { data?: EtcSalesReportRow[] } | undefined;
  useEffect(() => {
    if (!mainData) return;
    // 재조회 = EditTracker clear (hook #97). 신규 세트는 grid.collectionView.sourceCollection
    //   (=spRows) 에 직접 물려 있어 itemsSource 자체가 재조회로 교체되며 함께 사라진다.
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  const spRows = useMemo<EtcSalesReportRow[]>(() => mainData?.data ?? [], [mainData]);
  // 신규 세트는 GridAction.addRowSet 이 spRows(=grid.collectionView.sourceCollection)에 직접
  //   splice 하므로 별도 병합이 필요 없다 — rows 는 spRows 참조 그대로다(handleInsert 참고).
  const rows: EtcSalesReportRow[] = spRows;
  // ⚠️ 아래 두 값은 useMemo 로 [rows] 에 의존시키지 않는다 — addRowSet 이 rows(=spRows) 를
  //   같은 배열 참조에 splice 하므로 배열 identity 가 절대 바뀌지 않고, [rows] 의존 메모는
  //   최초 계산값에 영원히 고정된다(Insert/Delete 가 반영 안 됨 — 2026-09-17 리뷰 발견).
  //   매 렌더 새로 계산한다 — 행 수가 적어 비용 문제 없다.
  const insertedRows = rows.filter(r => r.CRUD_TYPE === 'I');

  // ⭐ 세트키 맵 — **병합(보이는 범위)과 저장(쓰이는 범위)의 단일 원천**.
  //   둘이 갈리면 병합 블록이 세트를 넘어가고, wijmo 가 블록 전 행에 값을 쓰면서
  //   "한 칸 고쳤는데 다른 세트까지 바뀌고 정작 저장은 안 되는" 상태가 된다
  //   (근거·AS-IS 대조는 `utils/etc-sales-reports.merge.ts` 상단 주석).
  const setKeys = buildSetKeyMap(rows, sc.divisionId);

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
  const [openModal, setOpenModal] = useState<EtcSalesReportsModalKey | null>(null);
  const [projectTargetRow, setProjectTargetRow] = useState<EtcSalesReportRow | null>(null);

  const hasPendingChanges = () =>
    insertedRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // ⭐ 그리드 memo 유지용 안정 콜백 — 인라인 함수를 넘기면 매 렌더 새 참조가 되어 EtcSalesReportsGrid
  //   memo 가 깨진다(Version 등 검색 입력이 키 입력마다 store 를 갱신 → 부모 리렌더 → 그리드 깜빡임).
  const handleProjectCellDblClick = useCallback((row: EtcSalesReportRow) => {
    setProjectTargetRow(row);
    setOpenModal('PROJECT');
  }, []);

  // F5 Search — Version 필수 (FindData L437 MSG00283)
  const handleSearch = () => {
    const vr = validateFind(sc.versionNo);
    if (!vr.ok) {
      void setAlert({ type: 'alert', content: t(vr.msgId!, '_Version을 선택하고 조회하세요.') });
      return;
    }
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // ⭐ Division 변경 = Grid 초기화 + CRUD reset (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  const clearGridOnSettingChange = () => {
    setHasSearched(false); // 쿼리 disable — Search 전까지 자동 재조회 안 함
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

  /**
   * 셀 팝업 선택값 반영 — **세트(그룹) 전체**에 쓴다 (2026-08-22 결함 정정, DMF0044 동반).
   *
   * 팝업은 wijmo 편집 경로를 타지 않는다. 그래서 대상 행에 그냥 대입하면 **그 행 하나만** 바뀐다.
   * 다른 컬럼은 편집 커밋이 병합 블록(= 세트) 전 행에 쓰이므로 세트가 함께 바뀐다.
   *
   * 필수: 변경 등록(EditTracker)도 여기서 한다. 값만 바꾸면 `getOriginalValues()` 에 안 들어가
   *   `runSave` 의 `changedMap.has(row)` 가 false → 그 세트가 저장 대상에서 조용히 빠진다.
   */
  const applyPopupSelection = (target: EtcSalesReportRow, values: Record<string, unknown>) => {
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

  /**
   * 클릭한 셀 기준 병합 축 컬럼(keyBindings)으로 groupKey 함수를 만든다 — GridAction.addRowSet
   * 의 groupKey 옵션에 그대로 넘긴다. 판정 축은 옛 groupTopRowOf 와 동일 규칙
   * (`groupKeyBindings` 가 클릭 컬럼을 축으로 정적 컬럼 목록을 고른다).
   */
  const buildGroupKeyOf = (
    g: FlexGridType<EtcSalesReportRow>
  ): ((row: EtcSalesReportRow) => string) => {
    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const keyBindings = groupKeyBindings(columns, g.selection.col);
    return (row: EtcSalesReportRow) => {
      if (keyBindings.length === 0) return '';
      const rec = row as Record<string, string>;
      // 값이 전부 빈 문자열이어도 key 가 falsy 로 접히지 않도록 접두사를 붙인다 —
      //   resolveInsertAnchor 는 groupKey 가 falsy 면 walk 자체를 건너뛴다.
      return `K:${keyBindings.map(binding => rec[binding] ?? '').join('')}`;
    };
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
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', 'Measure'),
      });
      return;
    }
    const g = gridRef.current;
    if (!g) return;
    const gid = `I_${Date.now()}`;
    const block: EtcSalesReportRow[] = measures.map(measure => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      DIVISION_ID: sc.divisionId,
      MEASURE: measure,
      ...INSERT_ROW_DEFAULTS,
    }));
    // 신규 블록은 **포커스 셀이 속한 머지 그룹 최상단** 바로 위에 끼운다 (사용자 지시 2026-08-23 —
    //   sales-plan / mkt-fcst 와 같은 규칙). 포커스가 없으면 맨 위. 포커스가 이미 다른 신규
    //   블록(미저장)이면 GridAction.addRowSet 이 그 블록의 등록된 앵커까지 자동으로 타고 올라가
    //   같은 자리에 이어 쌓는다(resolveInsertAnchor 의 pin 체이스).
    const added = GridAction.addRowSet(
      g as unknown as FlexGridType<WijmoRowItem>,
      block as unknown as Partial<WijmoRowItem>[],
      'above',
      {
        groupKey: buildGroupKeyOf(g) as unknown as (row: WijmoRowItem) => string,
        preserveMergeManager: true,
      }
    ) as unknown as EtcSalesReportRow[] | undefined;
    const target = added?.[0];
    if (!target) return;
    for (let i = 0; i < g.rows.length; i++) {
      if (g.rows[i]?.dataItem !== target) continue;
      g.select(i, Math.max(0, g.selection.col));
      g.scrollIntoView(i, -1);
      break;
    }
    // addRowSet 이 setState 를 호출하지 않으므로 강제 리렌더 — insertedRows/setKeys 등을
    //   최신 rows 로 다시 계산시킨다.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — 선택 행이 속한 **세트 전체**를 그리드에서 지운다 (AS-IS DeleteButton `.cs:282~333`).
  //   ⚠ 2026-08-22 결함 정정 — 종전에는 `CRUD_TYPE !== 'I'` 면 조용히 return 해서 **조회행에서
  //     Delete 가 아무 반응도 없었다**. 근거로 삼았던 AS-IS 의 "신규행만" 가드는 원문에서
  //     **주석 처리돼 있다**(`//if (GetText(ActiveRowIndex, Action) != "I") return;`) — 즉 AS-IS 는
  //     조회행도 지운다(40 은 measure cnt 만큼, 그 외는 GetCellNumbersByRow 세트 단위).
  //   주의: DB 삭제가 아니라 **화면에서만** 제거다(AS-IS `siMain.Delete()` 파리티).
  //     저장 payload 에 삭제 플래그가 없고, 재조회(Search)하면 다시 나온다.
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    // ⚠ 드래그 다중 선택 — `selectedItems[0]` 만 보면 **마지막 포커스 행 하나만** 처리된다
    //   (2026-08-22 리포트). 선택된 행 전부를 대상으로 삼는다.
    const selected = (g.selectedItems ?? []) as EtcSalesReportRow[];
    if (selected.length === 0) return;

    // 선택 행을 각자의 **세트 전체**로 넓힌다(드래그는 여러 세트를 걸친다). 세트 판정은
    //   병합·저장과 같은 `setKeys` 를 쓰므로 보이는 병합 범위와 일치한다.
    const seenKeys = new Set<string>();
    const targets = new Set<EtcSalesReportRow>();
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
    const dropRows = new Set<EtcSalesReportRow>();
    const markDeleted: EtcSalesReportRow[] = [];
    targets.forEach(r => {
      if (r.CRUD_TYPE !== 'I') {
        markDeleted.push(r);
        return;
      }
      if (r.INSERT_GROUP_ID) dropGids.add(r.INSERT_GROUP_ID);
      else dropRows.add(r);
    });

    // 신규행 — 행 객체 자체를 grid.collectionView 에서 없앤다(GridAction.removeRow 와 동일 방식).
    //   dropGids 는 targets 로 안 걸린 같은 세트의 형제 행까지 마저 훑는다(방어적 sweep).
    if (dropGids.size > 0 || dropRows.size > 0) {
      const toRemove = new Set<EtcSalesReportRow>(dropRows);
      spRows.forEach(r => {
        if (r.INSERT_GROUP_ID && dropGids.has(r.INSERT_GROUP_ID)) toRemove.add(r);
      });
      toRemove.forEach(r => g.editableCollectionView.remove(r));
      g.editableCollectionView.commitEdit();
    }
    // 조회행 — 공용 규약(`GridAction.removeRow`)대로 **status 'D' 마킹**. 행은 화면에 남고
    //   행 헤더에 D 가 뜨며, 저장 때 `activeFlag='D'` 로 나가 SP 가 원장에서 지운다
    //   (`PKG_DMF0049` — `DELETE ... WHERE B.ACTIVE_FLAG='D'`).
    markDeleted.forEach(r => {
      r.CRUD_TYPE = 'D';
    });
    g.invalidate();
    // 이 핸들러도 setState 를 호출하지 않으므로 강제 리렌더 — insertedRows/setKeys 등을
    //   최신 rows 로 다시 계산시킨다.
    forceGridRerender(v => v + 1);
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

    // 세트 단위 target 조립 — 세트키는 그리드 병합과 **같은 맵**(`setKeys`)에서 가져온다.
    //   INSERT_GROUP_ID(신규) / DATA_SEQ(기존. [C20210506-000051] DATA_SEQ 우선) / 인접 fallback.
    const allRows = rows;
    const keyOf = (row: EtcSalesReportRow): string => setKeys.get(row) ?? '';
    // 변경/신규/삭제가 속한 세트 수집
    const dirtyKeys = new Set<string>();
    allRows.forEach(row => {
      if (row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'D' || changedMap.has(row))
        dirtyKeys.add(keyOf(row));
    });
    const setMap = new Map<string, SaveTarget>();
    allRows.forEach(row => {
      const key = keyOf(row);
      if (!dirtyKeys.has(key)) return;
      if (!setMap.has(key)) {
        setMap.set(key, {
          setRows: [],
          isInsert: row.CRUD_TYPE === 'I',
          // Delete(F9) 마킹 세트 — 세트 전 행이 D 이므로 첫 행으로 판정해도 된다
          isDelete: row.CRUD_TYPE === 'D',
        });
      }
      setMap.get(key)!.setRows.push({ row, changes: changedMap.get(row) });
    });
    const targets = [...setMap.values()];
    if (targets.length === 0) {
      // 변경/신규 없음 → toast + 공통 문구 (DMF0003~0007/0020/0072 과 동일 규약).
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
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
    // 금지: 저장 중이라고 `false` 를 넘기지 말 것 (2026-08-21 결함 정정).
    //   `HotkeyConfig` 의 `false` 는 "비활성"이 아니라 **버튼 미렌더**다 — 공용
    //   `SubTitle.tsx` 가 `{buttonActions.save === false || (<Button .../>)}` 로 그린다.
    //   그래서 저장을 누르면 Save 버튼이 사라졌다가 끝나면 다시 나타났다.
    //   연타는 `savingRef` 가 동기로 막고(handleSave 진입 가드), 진행 표시는 아래
    //   ProgressIndicator 오버레이가 한다 (REQ:CHAT-20260820-17).
    save: hasButton('SAVE') ? () => void handleSave() : false,
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
            label: t('LBL00310', '_Measure'),
            title: t('LBL00310', '_Measure'),
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
        setKeys={setKeys}
        onProjectCellDblClick={handleProjectCellDblClick}
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
        onProjectSelect={applyPopupSelection}
        onVersionSelect={(versionNo, label) => {
          setSearchCondition({ versionNo, versionLabel: label });
        }}
      />
    </>
  );
};
