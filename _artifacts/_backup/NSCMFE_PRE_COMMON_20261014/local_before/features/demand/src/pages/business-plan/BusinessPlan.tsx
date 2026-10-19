import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  INSERT_MEASURE_COMBO_ID,
  INSERT_ROW_DEFAULTS,
  MENU_ID,
  MSG,
  SHEETS,
} from './business-plan.constants';
import type { BusinessPlanRow, SpreadTitleRow } from './business-plan.types';
import { BusinessPlanForm } from './components/BusinessPlanForm';
import { BusinessPlanGrid } from './components/BusinessPlanGrid';
import { type BusinessPlanModalKey, BusinessPlanModals } from './components/BusinessPlanModals';
import { useBusinessPlanStore, thisWeekMonday } from './useBusinessPlanStore';
import { callSaveBusinessPlan, callSetPrice } from './utils/business-plan.api';
import { buildCutoff, buildValidWindow, dynKindOf } from './utils/business-plan.editLock';
import { measureBlockOf } from './utils/business-plan.gridCombos';
import { type GroupKeyColumn, groupKeyBindings } from './utils/business-plan.insertAnchor';
import { buildSavePayload, buildUnfoldRows } from './utils/business-plan.save';
import { useBusinessPlanValidation } from './utils/business-plan.validate';

// AS-IS DMF0042_1_BizPlan (Demand > Demand Plan > Business Plan / 사업계획 — 3,477줄 정본 1:1).
//   Division 3종(40/81*/82) 단일 화면 — 조회 = DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA(16 IN + 커서 2:
//   data/calendar[40 유효구간]) / 저장 = PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST(19키 '^' bulk —
//   CAR/CELL/ENERGY·금액 파생은 SP 내장, FE 재구현 금지 — F-2 ①) / 동적 3단(연/분기/월) = GET_SPREAD_TITLE.
//   구조 골격 = sales-plan(DMF0021) — 2026-07-15 플랜 §E 확정.
//   SubTitle 공통버튼: search/insert/delete/save + excel/filter/sort/condition/reset(자동, hook #64) +
//   커스텀 6종(Set Price / Exchange Rate / Ver. Cutoff / Replace + Column Setting / Measure Select —
//   전부 노출 F-2 ②). EDIT(F2)는 상시편집 + editLock 으로 대체.
export const BusinessPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<BusinessPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const sc = useBusinessPlanStore(s => s.searchCondition);
  const setSearchCondition = useBusinessPlanStore(s => s.setSearchCondition);
  const filters = useBusinessPlanStore(s => s.filters);
  const setFilter = useBusinessPlanStore(s => s.setFilter);
  const clearFilters = useBusinessPlanStore(s => s.clearFilters);
  const openSearchArea = useBusinessPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useBusinessPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useBusinessPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useBusinessPlanStore(s => s.fetchStaticColumns);
  const clearUserColumnLayout = useBusinessPlanStore(s => s.clearUserColumnLayout);
  const fetchStaticMeasures = useBusinessPlanStore(s => s.fetchStaticMeasures);
  const fetchSearchConditions = useBusinessPlanStore(s => s.fetchSearchConditions);
  const setCutoffWindow = useBusinessPlanStore(s => s.setCutoffWindow);
  const cutoffWindow = useBusinessPlanStore(s => s.cutoffWindow);
  const dayRangeApplied = useBusinessPlanStore(s => s.dayRangeApplied);
  const applyDayRange = useBusinessPlanStore(s => s.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). Search 클릭 후에만 enable (DMF0003 계보).
  const [hasSearched, setHasSearched] = useState(false);

  // GridAction.addRowSet/removeRow 는 itemsSource 배열을 직접 splice/remove 하고 setState 를
  //   호출하지 않는다 — React 리렌더가 안 일어나면 이 컴포넌트가 파생하는 값(pendingRows 등)이
  //   Insert/Delete 이후에도 그 이전 렌더 시점 값에 멈춰 있는다. handleInsert/handleDelete
  //   끝에서 이 카운터를 올려 강제로 한 번 리렌더시킨다.
  const [, forceGridRerender] = useState(0);

  // ⭐ 기본 Period — PR_GET_DAY_RANGE o_rc2 (당월 1일~+7개월 말일. AS-IS GetDayRange p_month=7 L308)
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '7' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  //   Reset Condition(F10) 후 재적용 필수: F10 은 dayRangeApplied 를 false 로 되돌리지만, dayRange
  //   쿼리는 staleTime=Infinity 캐시라 재활성화해도 dayRangeData 참조가 그대로다. deps 가
  //   dayRangeData 뿐이면 effect 가 다시 돌지 않아 기간이 makeInitSearch 클라 기본값(당월+7개월 말일)에
  //   멈춘다 — 서버 dayRange(정본)와 한 달 어긋난 값. dayRangeApplied 를 deps 에 넣어 F10 직후
  //   캐시된 서버 구간을 다시 적용한다(초기 진입·새로고침과 동일 경로).
  useEffect(() => {
    if (dayRangeApplied) return;
    const range = (dayRangeData as { o_rc2?: { DAY_RANGE?: string }[] })?.o_rc2?.[0]?.DAY_RANGE;
    if (range) applyDayRange(range);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData, dayRangeApplied]);

  // 메인 그리드 SP — DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA (16 IN + 커서 2). wide format.
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 3단(연/분기/월) 헤더 SP — DMF0042_GET_SPREAD_TITLE.
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  // 참조 고정 필수: useMemo 없이 ?? [] 로 만들면 조회조건 타이핑/드롭다운마다 부모가 리렌더될 때
  //   매번 새 배열이 되어 Grid spreadTitle prop 참조가 바뀐다 → dynColMetas useMemo(deps: spreadTitle)
  //   재계산 → 동적 3단 헤더(mainDynamicColumns) 재생성 → wijmo 헤더 재드로우(깜빡임). spreadTitleData
  //   (react-query 캐시, staleTime=Infinity)가 실제로 바뀔 때만 새 참조가 되도록 고정한다.
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [],
    [spreadTitleData],
  );

  // Insert Measure 블록 원천 — CMBO 'DMF0042_BP_Measure' (AS-IS dtMeasure 1:1).
  //   ⚠ divisionId 는 반드시 넘긴다. 등록 SQL 이
  //       AND (NVL(TRIM(@divisionId),'-') = '-' OR INSTR(','||DIVISION_ID||',', ','||@divisionId||',') > 0)
  //     라서 미전달이면 앞 조건이 참이 되어 **전 사업부 Measure 9건이 통째로** 내려온다.
  //     SELECT 가 COLUMN_NAME/COLUMN_LABEL_NAME 뿐이라 DIVISION_ID 가 없어 클라 필터로는 못 막는다
  //     (measureBlockOf 는 키 미보유 행을 관대 통과시킨다) — 서버 필터가 유일한 게이트다.
  //   2026-08-21 실측: 40 에서 Insert 시 4건이 아니라 9건(MKT_FCST·KRW·USD·SalesAmt_USD·CAR_QTY 포함)이
  //     추가됐다. 그 5종은 설계서 [Measure 규칙] 시트의 '목록 제외 (전 사업부)' 로, 조회에는 나와도
  //     신규 행으로는 만들어지지 않아야 한다.
  //   값 quoting 의무 — BE makeComboQuery 는 @키를 raw 치환한다.
  const measureFilters = useMemo(
    () => [{ comboId: INSERT_MEASURE_COMBO_ID, divisionId: `'${sc.divisionId}'` }],
    [sc.divisionId]
  );
  const [measureComboRows] = useTabComboQueries({ filters: measureFilters as never });

  // ⭐ P_USERINFO 권한 그룹 — 세션 그룹 부재(유령 필드) → CMBO 'BizPlanUserAuthGroup'(P5) 1행 주입.
  const [authGroupCombo] = useTabComboQueries({ filters: ['BizPlanUserAuthGroup'] });
  const setAuthGroup = useBusinessPlanStore(s => s.setAuthGroup);
  const authGroup = useBusinessPlanStore(s => s.authGroup);
  useEffect(() => {
    const first = (authGroupCombo ?? [])[0] as { CODE?: string } | undefined;
    if (first?.CODE) setAuthGroup(String(first.CODE));
  }, [authGroupCombo, setAuthGroup]);
  // ⭐ race 방어 (DMF0021 2026-07-15 사고 계보): 콤보 도착 전 조회가 이미 나갔으면 그룹 확정 시
  //   filters 재생성(setFilter — 새 queryKey)으로 자동 재조회.
  useEffect(() => {
    if (authGroup && filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [authGroup]);

  /**
   * 클릭한 셀 기준 병합 축 컬럼(keyBindings)으로 groupKey 함수를 만든다 — GridAction.addRowSet/
   * removeRow 의 groupKey 옵션에 그대로 넘긴다. 누른 컬럼까지의 정적 컬럼을 키로 삼는다
   * (groupKeyBindings). MEASURE 자신이나 동적 기간 컬럼을 눌렀으면 MEASURE 직전까지로 폴백
   * = measure 만 다른 블록 전체. "신규행에서 눌렀으면 그 신규 세트의 원래 앵커를 그대로 쓴다"
   * 는 옛 groupTopRowOf 의 분기는 resolveInsertAnchor 의 pin 체이스(진입부 치환)가 대신한다.
   */
  const buildGroupKeyOf = (g: FlexGridType<BusinessPlanRow>): ((row: BusinessPlanRow) => string) => {
    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      // visible 미지정(undefined)은 표시로 본다 — 잘못 빼면 축이 통째로 폴백된다.
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const keyBindings = groupKeyBindings(columns, g.selection.col);
    return (row: BusinessPlanRow) => {
      if (keyBindings.length === 0) return '';
      const rec = row as Record<string, string>;
      // 값이 전부 빈 문자열이어도 key 가 falsy 로 접히지 않도록 접두사를 붙인다 —
      //   resolveInsertAnchor 는 groupKey 가 falsy 면 walk 자체를 건너뛴다.
      return `K:${keyBindings.map(binding => rec[binding] ?? '').join('')}`;
    };
  };

  // ⭐ MAIN 커서 2 (40 편집 유효구간 — 81/82 NULL 방어) 를 store 에 보관.
  type Cal = NonNullable<typeof cutoffWindow>;
  const mainData = data as { data?: BusinessPlanRow[]; calendar?: Cal[] | Cal } | undefined;
  useEffect(() => {
    if (!mainData) return;
    const pick = <T,>(v: T[] | T | undefined): T | null =>
      Array.isArray(v) ? (v[0] ?? null) : (v ?? null);
    setCutoffWindow(pick(mainData.calendar));
    // 재조회 = EditTracker clear (hook #97). 신규 세트는 grid.collectionView.sourceCollection
    //   (=spRows) 에 직접 물려 있어 itemsSource 자체가 재조회로 교체되며 함께 사라진다.
    editTrackerRef.current?.clearChanges();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  const spRows = useMemo<BusinessPlanRow[]>(() => mainData?.data ?? [], [mainData]);
  // ⭐ measure 행 필터는 서버(TITLESET 'M') 단일 출처 — 모달 OK 의 saveTitleSet('M') + invalidate 재조회.
  // 신규 세트는 GridAction.addRowSet 이 spRows(=grid.collectionView.sourceCollection)에 직접
  //   splice 하므로 별도 병합이 필요 없다 — rows 는 spRows 참조 그대로다(handleInsert 참고).
  const rows: BusinessPlanRow[] = spRows;
  // 저장/검증 등 "행" 만 필요한 곳의 입력.
  //   ⚠️ useMemo 로 [rows] 에 의존시키지 않는다 — addRowSet/removeRow 가 rows(=spRows) 를
  //   같은 배열 참조에 splice/remove 하므로 배열 identity 가 절대 바뀌지 않고, [rows] 의존
  //   메모는 최초 계산값에 영원히 고정된다(Insert/Delete 가 반영 안 됨 — 2026-09-17 리뷰 발견).
  //   매 렌더 새로 거른다 — 행 수가 적어 비용 문제 없다.
  const pendingRows = rows.filter(r => r.CRUD_TYPE === 'I');

  // ⭐ mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화.
  //   순서 필수: 저장된 조회조건(F6) 복원이 Division 을 바꿀 수 있고, 컬럼/메저 메타는 divisionId 로
  //   서버에서 갈라진다. 복원을 await 하지 않으면 이전 Division 기준 메타를 받아 놓고 아무도
  //   다시 받지 않는다(컬럼 재조회는 Search·Division 변경 경로에만 있다).
  useEffect(() => {
    clearFilters();
    void (async () => {
      await fetchSearchConditions();
      await fetchStaticColumns();
      await fetchStaticMeasures();
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ⭐ editLock cutoff — 금주 월요일 (조회 p_now_yyyymmdd 동일 원천) + 40 유효구간(커서 2)
  const cutoff = useMemo(() => buildCutoff(thisWeekMonday()), []);
  const validWindow = useMemo(() => buildValidWindow(cutoffWindow ?? null), [cutoffWindow]);

  // 셀 모달 state (PROJECT 81·82 / ITEM 전 division — AS-IS spdMain_CellDoubleClick L1640~1797)
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupGroupId, setPopupGroupId] = useState<string | null>(null);
  // 더블클릭한 그 행 — 팝업 사전 검색조건(Team/End Customer/Sales Site/Project) 의 원천.
  //   반영 대상은 블록 전 행(popupGroupId)이지만 조회조건은 사용자가 클릭한 행의 값을 쓴다.
  const [popupRow, setPopupRow] = useState<BusinessPlanRow | null>(null);

  // 모달 open state — Column/Measure/Exchange/Cutoff/Replace
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);
  const [openExchangeRate, setOpenExchangeRate] = useState(false);
  const [openCutoff, setOpenCutoff] = useState(false);
  const [openReplace, setOpenReplace] = useState(false);
  const [replaceRange, setReplaceRange] = useState<{ from: string; to: string }>({
    from: '',
    to: '',
  });

  // ----- validation (조회 V-S1~S3 / Bucket V-E3 / 저장 V-V1 / pending 차단) -----
  const validation = useBusinessPlanValidation();

  // 변경분 존재 여부 — Bucket 변경(MSG00227)·커스텀 버튼 pending 차단(MSG00680) 입력
  const hasPendingChanges = () =>
    pendingRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // F5 Search — AS-IS FindData(L684~799) 1:1 검증(V-S1~S3) 후 조회.
  //   ⚠ refetch?.() 직접 호출 금지 — stale closure NULL payload 사고 (memory feedback_search_refetch_stale_closure).
  const handleSearch = () => {
    const vr = validation.validateFind(sc);
    if (!vr.ok) {
      // V-S3 — 6년 초과 시 종료일 = 시작일+6년 보정 (AS-IS L711 Value2 보정 후 차단)
      if (vr.adjustedEnd) setSearchCondition({ endYyyymmdd: vr.adjustedEnd });
      return;
    }
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // Column 설정 저장 = Grid 초기화 의무 (AS-IS btnColumn_Click L2807~2817 OK -> InitSpread).
  //   저장 즉시 표시 컬럼이 바뀌므로, 이전 설정으로 조회해 둔 rows 를 그대로 두면 화면의 컬럼
  //   구성과 데이터가 어긋난다. 그리드를 공백으로 되돌리고 재조회는 Search 로만
  //   (division 변경 초기화와 동일 정책, sales-plan SalesPlan.tsx clearGridOnSettingChange 정본).
  //   필수: removeQueries([tabId]) — queryKey 는 filters '값' 기반이라 동일 조건으로 다시 Search 하면
  //   전역 staleTime=Infinity 캐시가 이전 설정으로 받은 rows 를 그대로 돌려준다.
  const clearGridOnSettingChange = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
  };

  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    // ⭐ 컬럼 개인화 무효화 — TITLESET_USER 는 division 무관 1벌인데 컬럼 세트는 division 별로 다르다.
    //   비우지 않으면 이전 division 레이아웃이 새 division 컬럼을 전부 숨긴다.
    clearUserColumnLayout();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F8 Insert — AS-IS InsertRow(L1150~1417) 1:1: Measure 블록(division별 measure 전 행) 삽입.
  //   콤보 미적재(0건) = MSG00113 차단 (메타 주도 — 하드코딩 fallback 금지).
  const handleInsert = () => {
    const measures = measureBlockOf(
      (measureComboRows ?? []) as unknown as Record<string, unknown>[],
      sc.divisionId
    );
    if (measures.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.'),
      });
      return;
    }
    const g = gridRef.current;
    if (!g) return;
    const gid = `I_${Date.now()}`;
    const block: BusinessPlanRow[] = measures.map(measure => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      DIVISION_ID: sc.divisionId,
      MEASURE: measure,
      ...INSERT_ROW_DEFAULTS,
    }));
    // 앵커·정렬 고정·필터 예외 등록은 GridAction.addRowSet(groupKey=buildGroupKeyOf) 이 전부
    //   처리한다 — 블록을 세트 전체에 대해 앵커를 **한 번만** 계산해 원자적으로 앵커 바로 위에
    //   통째로 놓는다. 배열 끝에 붙여 누른 순서를 유지한다 — 같은 앵커에 연속 Insert 시 누른
    //   순서대로 쌓인다(resolveInsertAnchor 의 pin 체이스). 필터는 건드리지 않는다
    //   (2026-08-21 사용자 요구 "filter 가 풀리면 안됩니다") — addRowSet 이 신규행을 필터 예외로
    //   등록해 필터를 유지한 채 보이게 한다.
    const added = GridAction.addRowSet(
      g as unknown as FlexGridType<WijmoRowItem>,
      block as unknown as Partial<WijmoRowItem>[],
      'above',
      {
        groupKey: buildGroupKeyOf(g) as unknown as (row: WijmoRowItem) => string,
        preserveMergeManager: true,
      }
    ) as unknown as BusinessPlanRow[] | undefined;
    const target = added?.[0];
    if (!target) return;
    for (let i = 0; i < g.rows.length; i++) {
      if (g.rows[i]?.dataItem !== target) continue;
      g.select(i, Math.max(0, g.selection.col));
      g.scrollIntoView(i, -1);
      break;
    }
    // addRowSet 이 setState 를 호출하지 않으므로 강제 리렌더 — pendingRows 를 최신 rows 로
    //   다시 계산시킨다.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — AS-IS DeleteButton(L525~537) 1:1 — Action='I' Measure 블록 전체 삭제.
  //   DB 조회행은 무동작(silent). 블록 전체 삭제·앵커 유실 시 재해석은 GridAction.removeRow 의
  //   groupKey 옵션(INSERT_GROUP_ID)이 처리한다 — 클릭한 행이 세트의 일부만이어도 같은
  //   INSERT_GROUP_ID 를 가진 나머지 형제 행까지 함께 지운다(sales-plan handleDelete 참고).
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as BusinessPlanRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') return; // silent (AS-IS L527)
    const gid = sel.INSERT_GROUP_ID;

    // ⭐ 삭제 세트의 EditTracker 기록 제거 (2026-08-26 리포트 — "행추가 후 삭제했는데 Exchange Rate 가
    //   '변경 중인 데이터가 있어 수행할 수 없습니다' 로 막힘").
    //   공용 EditTracker 는 **신규행도 원본을 기록한다** — CRUD_TYPE='I' 는 마킹(M) 만 건너뛸 뿐
    //   _originalValues 에는 그대로 들어간다(editTracker.ts storeChange). 그래서 행을 지워도 기록이
    //   남아 hasPendingChanges() 가 영영 true 가 되고, pending 게이트를 쓰는 버튼
    //   (Exchange Rate / Ver. Cutoff / Replace / Set Price / Bucket 변경)이 전부 막힌다.
    //   clearChanges() 는 기존행 수정분까지 지우므로 삭제 대상 세트만 골라 지운다.
    const originals = editTrackerRef.current?.getOriginalValues() as
      | Map<BusinessPlanRow, Record<string, unknown>>
      | undefined;
    if (originals) {
      const toPurge = gid ? spRows.filter(r => r.INSERT_GROUP_ID === gid) : [sel];
      toPurge.forEach(r => originals.delete(r));
    }

    GridAction.removeRow(g as unknown as FlexGridType<WijmoRowItem>, true, true, {
      groupKey: row => (row as unknown as BusinessPlanRow).INSERT_GROUP_ID ?? '',
    });
    forceGridRerender(v => v + 1);
  };

  // F7 Save — AS-IS SaveData(L801~1148) 1:1. 검증(V-V1) → 19키 '^' bulk 조립(중복 MSG00043) →
  //   PKG SAVE 직접 호출 → 결과 passthrough → 성공 MSG00002 + 재조회(스크롤 복원).
  const handleSave = async () => {
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<BusinessPlanRow, Record<string, unknown>>
        | undefined) ?? new Map<BusinessPlanRow, Record<string, unknown>>();
    const editedRows = [...changedMap.keys()].filter(r => r.CRUD_TYPE !== 'I');

    // (0) 변경 0건 + 필수값 division 분기 (MSG00004 / MSG00429 {0})
    const vr = validation.validateSaveRows([...pendingRows, ...editedRows], sc.divisionId);
    if (!vr.ok) return;

    // (1) (행 × M_ 기간셀) unfold — 빈값→'0'→'D', 중복 키 검증(MSG00043)
    const build = buildUnfoldRows({
      insertedRows: pendingRows,
      editedChanges: changedMap,
      divisionId: sc.divisionId,
      msg: { duplicateKey: MSG.DUPLICATE_KEY },
    });
    if (build.error) {
      void setAlert({
        type: 'alert',
        content: t(build.error.msgId, `_${build.error.msgId}`).replace(
          '{0}',
          build.error.param ?? ''
        ),
      });
      return;
    }
    // 감사 2키(createdBy/lastUpdatedBy)는 세션 userId 로 FE 가 싣는다 — BE call-proc 경로는
    //   요청 파라미터에 없는 COL_NM 을 null 로 바인딩한다 (business-plan.save.ts 주석 참조).
    const payload = buildSavePayload(build.rows, useSessionStore.getState().session.userId ?? '');
    if (!payload) {
      // 저장 대상 0건 (AS-IS L1087 MSG00275 → MSG00676)
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_SAVE_TARGET, '_저장할 대상 데이터가 없습니다.'),
      });
      return;
    }

    try {
      const res = await callSaveBusinessPlan(payload);
      if (!res.ok) {
        // SP 오류문 passthrough (AS-IS L1138 sRet MessageBox 1:1)
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      await (refetch?.() ?? Promise.resolve());
      if (savedScroll) {
        window.requestAnimationFrame(() => {
          const g = gridRef.current;
          if (g) g.scrollPosition = savedScroll;
        });
      }
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // ⭐ Set Price — 가격→금액 환산 (AS-IS btnSetPrice: MSG00678 confirm → SP → 재조회)
  const handleSetPrice = async () => {
    // [개선] pending 차단 (2026-07-21 사용자 승인 — AS-IS 는 가드 전무라 미저장 변경이 재조회로 소실.
    //   Exchange/Cutoff/Replace 와 MSG00680 통일. 파리티 이탈 의도 명시.)
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(MSG.SET_PRICE_CONFIRM, '_변경된 환율을 적용하시겠습니까?'),
    });
    if (!confirmed) return;
    const res = await callSetPrice(sc.divisionId);
    // 반환 메시지 passthrough (AS-IS L3133 GMessageBox 1:1)
    if (res.message) {
      void setAlert({ type: 'alert', content: res.message });
    } else if (res.ok) {
      // ⭐ 2026-08-06 — SP 가 메시지를 안 돌려주는 경우(실측: result.DATARESULT=[] / data=null) 화면에
      //   피드백이 하나도 없어 "버튼이 안 먹는다"로 보였다. AS-IS 는 SP 반환문을 항상 띄우는 전제라
      //   메시지 부재를 고려하지 않은 것. 무반응 대신 완료 토스트로 최소 피드백 보장.
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
    }
    if (res.ok) await (refetch?.() ?? Promise.resolve());
  };

  // ⭐ Exchange Rate — pending 변경 시 차단(AS-IS L2989 MSG00142 → MSG00680) → 모달 → 닫으면 재조회
  const handleExchangeRate = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    setOpenExchangeRate(true);
  };

  // ⭐ Ver. Cutoff — ADMIN·DM ADMIN 게이트(P4 — hasButton) + pending 차단 (AS-IS L2840~2866)
  const handleCutoff = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    setOpenCutoff(true);
  };

  // ⭐ Replace — 게이트 + pending 차단 + 조회 0행 차단 + 선택 M_ 범위 → from/to (AS-IS L3382~3474)
  const handleReplace = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    const spRowsNow = mainData?.data ?? [];
    if (spRowsNow.length === 0) {
      // AS-IS L3408 인라인 리터럴 1:1
      void setAlert({ type: 'alert', content: '데이터 조회 후 다시 시도해 주시기 바랍니다.' });
      return;
    }
    // 선택 셀 범위의 M_ 태그 → from/to yyyymm (미선택/비 M_ = 조회기간 전체 — AS-IS L3422~3450)
    const g = gridRef.current;
    let from = sc.startYyyymmdd.slice(0, 6);
    let to = sc.endYyyymmdd.slice(0, 6);
    if (g) {
      const selection = g.selection;
      const tags: string[] = [];
      for (
        let c = Math.min(selection.col, selection.col2);
        c <= Math.max(selection.col, selection.col2);
        c++
      ) {
        const b = g.columns[c]?.binding ?? '';
        if (dynKindOf(b) === 'M') tags.push(b.slice(2));
      }
      if (tags.length > 0) {
        tags.sort();
        from = tags[0];
        to = tags[tags.length - 1];
      }
    }
    setReplaceRange({ from, to });
    setOpenReplace(true);
  };

  // SubTitle 공통버튼 — 미명시(sort/filter/condition/resetCondition/excel)는 DefaultButtonActions 자동.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 6종 — Set Price/Exchange Rate/Ver. Cutoff/Replace(F-2 ② 전부 노출 — 권한은 P4 hasButton)
  //   + Column Setting/Measure Select (icon-only). 라벨 = 기존 LBL 재사용, 부재 시 영문 리터럴
  //   (신규 LBL 채번 금지 — DMF0021 확정 승계).
  const customButtons = [
    ...(hasButton('SET_PRICE')
      ? [
          {
            label: 'Set Price',
            title: 'Set Price',
            action: () => void handleSetPrice(),
            buttonLabel: 'Set Price',
          },
        ]
      : []),
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
    ...(hasButton('CUTOFF')
      ? [
          {
            label: 'Ver. Cutoff',
            title: 'Ver. Cutoff',
            action: handleCutoff,
            buttonLabel: 'Ver. Cutoff',
          },
        ]
      : []),
    ...(hasButton('REPLACE')
      ? [
          {
            label: 'Replace',
            title: 'Replace',
            action: handleReplace,
            buttonLabel: 'Replace',
          },
        ]
      : []),
    // ...(hasButton('MEASURE_SELECT')
    //   ? [
    //       {
    //         label: t('LBL00310', '_Measure'),
    //         title: t('LBL00310', '_Measure'),
    //         action: () => setOpenMeasureSelect(true),
    //         iconComponent: <IcMeasureSelect />,
    //         buttonLabel: '',
    //       },
    //     ]
    //   : []),
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenColumnSetting(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  // 참조 고정 필수: 인라인 함수로 넘기면 조회조건 타이핑/드롭다운마다 부모가 리렌더될 때 매번
  //   새 함수 참조가 되어, Grid 의 wijmo 핸들러 설치 effect(deps 에 onPopupCellDblClick 포함 —
  //   더블클릭 핸들러가 이를 참조)가 재실행된다. 그 effect 는 formatItem/beginningEdit 등 전 핸들러
  //   재등록 + mergeManager 재생성 + g.invalidate(true) 를 하므로 그리드 전체가 재드로우된다(통째
  //   깜빡임). setter 는 전부 useState 참조 보장이라 deps 는 비운다.
  const handlePopupCellDblClick = useCallback(
    (modalKey: 'PROJECT' | 'ITEM', row: BusinessPlanRow) => {
      setPopupGroupId(row.INSERT_GROUP_ID ?? null);
      // open 과 같은 이벤트에서 함께 세팅 — 팝업은 open 이 true 가 되는 렌더의
      //   preSearchParams 를 한 번만 읽는다(useEffect deps=[open]). 순서가 갈리면 빈 조건으로 열린다.
      setPopupRow(row);
      if (modalKey === 'ITEM') setOpenItem(true);
      else setOpenProject(true);
    },
    [],
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
        <BusinessPlanForm
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          hasPendingChanges={hasPendingChanges}
          validation={validation}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='BusinessPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <BusinessPlanGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        cutoff={cutoff}
        validWindow={validWindow}
        onPopupCellDblClick={handlePopupCellDblClick}
      />

      {/* 모달 7종 — 셀 PROJECT/ITEM + Column/Measure + Exchange/Cutoff/Replace (components 분리 의무) */}
      <BusinessPlanModals
        divisionId={sc.divisionId}
        period={{ start: sc.startYyyymmdd, end: sc.endYyyymmdd }}
        replaceRange={replaceRange}
        openProject={openProject}
        openItem={openItem}
        openColumnSetting={openColumnSetting}
        openMeasureSelect={openMeasureSelect}
        openExchangeRate={openExchangeRate}
        openCutoff={openCutoff}
        openReplace={openReplace}
        popupRow={popupRow}
        onClose={(key: BusinessPlanModalKey) => {
          if (key === 'ITEM' || key === 'PROJECT') setPopupRow(null);
          const closers: Record<BusinessPlanModalKey, (v: boolean) => void> = {
            PROJECT: setOpenProject,
            ITEM: setOpenItem,
            COLUMN: setOpenColumnSetting,
            MEASURE: setOpenMeasureSelect,
            EXCHANGE: setOpenExchangeRate,
            CUTOFF: setOpenCutoff,
            REPLACE: setOpenReplace,
          };
          closers[key](false);
        }}
        onRefetch={() => void (refetch?.() ?? Promise.resolve())}
        applyToInsertBlock={patch => {
          // 셀 모달 반영 — 같은 Measure 블록(INSERT_GROUP_ID) 전 행에 키 컬럼 patch (AS-IS 블록 공유 키)
          if (!popupGroupId) return;
          // 신규 세트는 grid.collectionView.sourceCollection(=spRows)에 직접 물려 있으므로 객체를
          //   새로 만들지 않고 그 자리에서 갱신한다 — 새 객체로 바꾸면 그 행을 앵커로 삼은 다른
          //   신규 세트의 pin(anchor 참조)이 끊긴다.
          const members = spRows.filter(r => r.INSERT_GROUP_ID === popupGroupId);
          if (members.length > 0) {
            members.forEach(row => Object.assign(row as Record<string, unknown>, patch));
            gridRef.current?.invalidate();
          }
          setPopupGroupId(null);
        }}
        onSettingChanged={clearGridOnSettingChange}
      />
    </>
  );
};
