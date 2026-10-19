import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useDirtyReset, useMessageStore, useSessionStore } from '@shared/stores';

import { SalesPlanForm } from './components/SalesPlanForm';
import { SalesPlanGrid } from './components/SalesPlanGrid';
import { type SalesPlanModalKey, SalesPlanModals } from './components/SalesPlanModals';
import { BUCKET_TYPE, INSERT_ROW_DEFAULTS, MENU_ID, MSG, SHEETS } from './sales-plan.constants';
import type { MeasureInfoRow, SalesPlanRow, SpreadTitleRow } from './sales-plan.types';
import { useSalesPlanStore } from './useSalesPlanStore';
import { callSaveSalesPlan, formatSaveErrorText } from './utils/sales-plan.api';
import { resolveSalesPlanAuthGroup } from './utils/sales-plan.auth';
import {
  findGroupTopIndex,
  type GroupKeyColumn,
  groupKeyBindings,
  mergeInsertedRows,
  type PendingInsert,
} from './utils/sales-plan.insertAnchor';
import { buildSavePayload, buildUnfoldRows } from './utils/sales-plan.save';
import { useSalesPlanValidation } from './utils/sales-plan.validate';

// AS-IS DMF0021_SalesPlan (Demand > Demand Plan > Sales Plan / 판매계획 — Forms.UIL 5,599줄 정본 1:1).
//   Division 3종(40/81*/82) 단일 화면 — 조회 = PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX
//   (17 IN + 커서 3: data/calendar/editAuth) / 저장 = P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL(18키 '^' bulk —
//   수량 배분(월→주→일)·중복검증·MERGE 는 SP 내장, FE 재구현 금지) / 동적 3단 헤더 = GET_SPREAD_TITLE.
//   구조 골격 = forecast-price(DMF0082), 그리드·유틸 실체 = mkt-fcst(DMF0003) — 2026-07-14 플랜 확정.
//   SubTitle 공통버튼: search/insert/delete/save + excel/filter/sort/condition/reset(자동, hook #64) +
//   커스텀 2종(Column Setting / Measure Select icon-only). EDIT(F2)는 상시편집 + editLock 으로 대체.
export const SalesPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<SalesPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const sc = useSalesPlanStore(s => s.searchCondition);
  const setSearchCondition = useSalesPlanStore(s => s.setSearchCondition);
  const filters = useSalesPlanStore(s => s.filters);
  const setFilter = useSalesPlanStore(s => s.setFilter);
  const clearFilters = useSalesPlanStore(s => s.clearFilters);
  const openSearchArea = useSalesPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useSalesPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useSalesPlanStore(s => s.fetchStaticColumns);
  const clearUserColumnLayout = useSalesPlanStore(s => s.clearUserColumnLayout);
  const fetchStaticMeasures = useSalesPlanStore(s => s.fetchStaticMeasures);
  const staticMeasures = useSalesPlanStore(s => s.staticMeasures);
  const setCalendarInfo = useSalesPlanStore(s => s.setCalendarInfo);
  const calendarInfo = useSalesPlanStore(s => s.calendarInfo);
  const editAuth = useSalesPlanStore(s => s.editAuth);
  const dayRangeApplied = useSalesPlanStore(s => s.dayRangeApplied);
  const applyDayRange = useSalesPlanStore(s => s.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). 마운트 시 persist 된 stale filters 로
  //   SP 가 자동 발사되어 NULL payload 사고 차단 (DMF0003 2026-06-29 계보). Search 클릭 후에만 enable.
  const [hasSearched, setHasSearched] = useState(false);
  const [isPending, setIsPending] = useState(false);

  // ⭐ 기본 Period — PR_GET_DAY_RANGE o_rc2 (당월 1일~+6개월 말일. AS-IS drpPeriod.InitValue L511 1:1)
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '6' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  //   Reset Condition(F10) 후 재적용 필수: F10 은 dayRangeApplied 를 false 로 되돌리지만, dayRange
  //   쿼리는 staleTime=Infinity 캐시라 재활성화해도 dayRangeData 참조가 그대로다. deps 가
  //   dayRangeData 뿐이면 effect 가 다시 돌지 않아 기간이 클라 기본값에 멈춘다. dayRangeApplied 를
  //   deps 에 넣어 F10 직후 캐시된 서버 구간을 다시 적용한다(초기 진입·새로고침과 동일 경로).
  useEffect(() => {
    if (dayRangeApplied) return;
    const range = (dayRangeData as { o_rc2?: { DAY_RANGE?: string }[] })?.o_rc2?.[0]?.DAY_RANGE;
    if (range) applyDayRange(range);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData, dayRangeApplied]);

  // 메인 그리드 SP — P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX (17 IN + 커서 3). wide format.
  const { data, refetch, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 3단 헤더 SP — P_DMF0021_GET_SPREAD_TITLE (4 IN). 기간 컬럼(M_/W_/D_) 구조의 1차 소스.
  const { data: spreadTitleData, isFetching: isSpreadTitleFetching } = useTabProcQuery<
    MENU_ID,
    SHEETS.SPREAD_TITLE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [];

  // Insert 행 Measure 콤보 — P_DMF0021_GET_SALES_PLAN_MEASUREINFO (division 종속, 기본 SalesAmt_LOC).
  const measureInfoFilters = useMemo(() => ({}), []);
  const { data: measureInfoData } = useTabProcQuery<MENU_ID, SHEETS.MEASURE_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.MEASURE_INFO,
    tabId,
    filters: measureInfoFilters,
    enabled: true,
  });
  const measureInfoRows = (measureInfoData as { data?: MeasureInfoRow[] } | undefined)?.data ?? [];

  // P_USERINFO 권한 그룹 — AS-IS NowGroupID 등가. CMBO 'SalesPlanUserAuthGroup' 결과가 정본이며,
  // session.groupId(유령 필드)는 참조하지 않는다 (UI분석서 v2.1 시트9 C29 — ghost field 사고 대응).
  const [authGroupCombo] = useTabComboQueries({
    filters: ['SalesPlanUserAuthGroup'],
  });
  const setAuthGroup = useSalesPlanStore(s => s.setAuthGroup);
  const authGroup = useSalesPlanStore(s => s.authGroup);
  const comboReady = authGroupCombo !== undefined;
  useEffect(() => {
    setAuthGroup(resolveSalesPlanAuthGroup(authGroupCombo));
  }, [authGroupCombo, setAuthGroup]);
  // ⭐ race 방어 (2026-07-15 — 40 RTF 편집불가 사고): 콤보 도착 전 Search(또는 persist filters 재사용)로
  //   userGroup=사용자ID 조회가 이미 나갔으면 editAuth='N' 응답이 화면에 남는다 → 그룹 확정(변경) 시
  //   filters 재생성(setFilter — 새 queryKey)으로 자동 재조회해 editAuth 를 갱신.
  useEffect(() => {
    if (comboReady && filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboReady, authGroup]);

  // 신규 행 추적 (CRUD_TYPE='I') — 행 + 표시 위치를 정하는 앵커(머지 블록 첫 행) 쌍.
  //   배열 순서 = 누른 순서. 같은 앵커에 여러 건이 걸리면 누른 순서대로 위에서 아래로 쌓인다.
  const [insertedRows, setInsertedRows] = useState<PendingInsert[]>([]);
  // 저장/검증/모달 등 "행" 만 필요한 곳의 입력 — 앵커는 화면 표시 전용이라 payload 에 나가지 않는다.
  const insertRowList = useMemo<SalesPlanRow[]>(() => insertedRows.map(p => p.row), [insertedRows]);
  // Insert 직후 포커스를 옮길 신규행 — rows 재계산 후 effect 가 소비하고 비운다.
  const focusRowRef = useRef<SalesPlanRow | null>(null);

  // 이탈 가드(조회·탭 닫기·팝업 닫기) 확인 시 화면이 들고 있는 신규행 state 도 함께 버린다.
  //   그리드 되돌리기는 DataGrid 가 자동 등록하지만, 그것은 itemsSource 배열에서 'I' 행을 지울 뿐이라
  //   insertedRows 가 살아 있으면 다음 렌더의 rows useMemo 가 버린 행을 그대로 되살린다.
  useDirtyReset(() => setInsertedRows([]));

  // ⭐ MAIN 커서 2/3 (calendar 기준일 / editAuth 편집권한) 을 store 에 보관 — editLock cutoff·Insert 게이트.
  type Cal = NonNullable<typeof calendarInfo>;
  type Auth = NonNullable<typeof editAuth>;
  const mainData = data as
    | { data?: SalesPlanRow[]; calendar?: Cal[] | Cal; editAuth?: Auth[] | Auth }
    | undefined;
  useEffect(() => {
    if (!mainData) return;
    const pick = <T,>(v: T[] | T | undefined): T | null =>
      Array.isArray(v) ? (v[0] ?? null) : (v ?? null);
    setCalendarInfo(pick(mainData.calendar), pick(mainData.editAuth));
    // 재조회 = pending insert reset + EditTracker clear (hook #97)
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  // ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline) + persist 된 이전 filters 무효화.
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 셀 모달 state (PROJECT 81·82 / ITEM 40+Catch_Up — AS-IS spdMain_CellDoubleClick L3834/3863)
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupRow, setPopupRow] = useState<SalesPlanRow | null>(null);

  // Column / Measure 선택 모달 open state
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ----- validation (조회 V-S1~S3 / Bucket V-E3 / 저장 V-V1 — division 분기) -----
  const validation = useSalesPlanValidation();
  const isWorkInProgress = !comboReady || isFetching || isSpreadTitleFetching || isPending;
  const blockIfWorking = (): boolean => {
    if (!isWorkInProgress) return false;
    void setAlert({
      type: 'alert',
      content: t(MSG.WORK_IN_PROGRESS, '_The previous operation is still in progress.'),
    });
    return true;
  };

  // 변경분 존재 여부 — Bucket 변경 가드(MSG00227) 입력 (신규 행 + EditTracker 변경 셀)
  const hasPendingChanges = () =>
    insertedRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // F5 Search — AS-IS FindData(L1450~1632) 1:1 검증(V-S1~S3) 후 조회.
  //   ⚠️ refetch?.() 직접 호출 금지 — stale closure filters 로 첫 호출 NULL payload 사고
  //   (memory feedback_search_refetch_stale_closure). setFilter(queryKey 변경) + enabled 만으로 fetch.
  //   [공통 C2 2026-08-14 정정] 수정 중 재조회 가드(확인 팝업)는 여기서 하지 않는다. 조회 진입점
  //   두 곳(SearchArea 조회 버튼 · SubTitle F5)이 이미 공통 가드 confirmIfDirtyKey(..., 'search') 로
  //   감싸 confirm + 편집분 되돌리기까지 수행한다. 화면이 같은 검사를 한 번 더 하면 팝업이 2연속으로
  //   뜬다 — 공통 가드가 확인 직후 그리드만 되돌리고 화면 state(insertedRows)는 남기기 때문에 여기
  //   검사가 다시 걸린다(2번째 팝업은 MSG00703 = 닫기 문구라 "이 화면을 닫으시겠습니까?" 로 뜬다).
  //   화면 state 정리는 위 useDirtyReset 등록이 담당한다 (DMF0082 ForecastPrice 선례 1:1).
  const handleSearch = () => {
    if (blockIfWorking()) return;
    const vr = validation.validateFind(sc);
    if (!vr.ok) {
      // V-S3 — 3년 초과 시 종료일 = 시작일+3년 보정 (AS-IS L1481 Value2 보정 후 차단)
      if (vr.adjustedEnd) setSearchCondition({ endYyyymmdd: vr.adjustedEnd });
      return;
    }
    // void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // Column/Measure 설정 저장 = Grid 초기화 의무 (사용자 요구 2026-08-05).
  //   저장 즉시 표시 컬럼/메저가 바뀌므로, 이전 설정으로 조회해 둔 rows 를 그대로 두면
  //   화면의 컬럼 구성과 데이터가 어긋난다. 그리드를 공백으로 되돌리고 재조회는 Search 로만
  //   (division 변경 초기화와 동일 정책, mkt-fcst MktFcst.tsx 정본).
  //   필수: removeQueries([tabId]) — queryKey 는 filters '값' 기반이라 동일 조건으로 다시
  //   Search 하면 전역 staleTime=Infinity 캐시가 이전 설정으로 받은 rows 를 그대로 돌려준다.
  const clearGridOnSettingChange = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
  };

  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset —
  //   재조회는 Search 버튼). filters 도 무효화해 stale payload 재사용 차단 + division 종속 메타 재fetch.
  const handleDivisionChange = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    // 컬럼 개인화 무효화 — TITLESET_USER 는 division 무관 1벌인데 컬럼 세트는 division 별로 다르다.
    //   비우지 않으면 이전 division 레이아웃이 새 division 컬럼을 전부 숨긴다.
    clearUserColumnLayout();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  /**
   * 선택한 셀이 속한 머지 블록의 첫 행 — Insert 앵커. (DMF0082 groupTopRowOf 이식)
   *
   * 판정 입력은 그리드가 실제로 그리고 있는 것에서 뽑는다: 표시 순서(개인화로 바뀐다) · 표시 여부 ·
   * 필터/정렬이 반영된 행 순서(`g.rows`). 조회 응답 배열(spRows)이 아니다 — 사용자가 본 화면상의
   * 블록과 어긋나면 안 된다.
   *
   * 범위 축 = 선택한 컬럼(`g.selection.col`). Sales Site 셀은 그 안의 여러 Model 블록을, Model 셀은
   *   그 안의 Incoterms 블록을, Incoterms 셀은 measure 블록만 덮는다. 축은 groupKeyBindings 에
   *   인덱스 그대로 넘긴다 (binding 이름 역탐색 금지 — 표시/비표시 목록을 따로 만드는 순간 인덱스가
   *   밀려 조용히 폴백으로 떨어진다).
   *
   * 금지: wijmo 컬렉션(`g.columns`/`g.rows`)에 `.map`/`.filter` 를 쓰지 말 것 — Array 상속이라
   *   species 규약(`new ObservableArray(length)`)으로 새 ObservableArray 를 만들며 결과가 깨진다.
   *   인덱스 루프로 순수 배열에 복사한 뒤 다룬다.
   */
  const groupTopRowOf = (index: number): SalesPlanRow | null => {
    const g = gridRef.current;
    if (!g || index < 0) return null;

    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      // visible 미지정(undefined)은 표시로 본다 — 잘못 빼면 축이 통째로 폴백된다.
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const gridRowItems: (SalesPlanRow | undefined)[] = [];
    for (let i = 0; i < g.rows.length; i++) {
      gridRowItems.push(g.rows[i]?.dataItem as SalesPlanRow | undefined);
    }

    const keyBindings = groupKeyBindings(columns, g.selection.col);
    const top = findGroupTopIndex(gridRowItems, index, keyBindings);
    return (g.rows[top]?.dataItem as SalesPlanRow | undefined) ?? null;
  };

  // F8 Insert — AS-IS InsertRow(L2831~3382) 1:1.
  //   권한 게이트: EDIT_AUTH_SALESAMT_LOC='Y'(기타매출 편집권한자)만 — 무권한 silent 무시(L2854).
  //   기본값: MEASURE=SalesAmt_LOC(L2926) + FCST_TYPE=ETC 고정(L2944). Daily 버킷 = 편집 불가(MSG00361).
  const handleInsert = () => {
    if (isPending) return;
    if ((editAuth?.EDIT_AUTH_SALESAMT_LOC ?? '') !== 'Y') return; // silent (AS-IS L2854~2857)
    if (sc.bucketType === BUCKET_TYPE.DAILY) {
      void setAlert({
        type: 'alert',
        content: t(MSG.DAILY_EDIT_BLOCK, '_Daily 버킷에서는 편집할 수 없습니다.'),
      });
      return;
    }
    const newRow: SalesPlanRow = {
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: `I_${Date.now()}`,
      DIVISION_ID: sc.divisionId,
      ...INSERT_ROW_DEFAULTS,
    };
    // 앵커 = 선택한 셀이 속한 머지 블록의 첫 행 — 그 바로 위에 놓는다 (앵커 null = 그리드 맨 위).
    //   [통합테스트 35번] 앵커가 포커스 행 자체면 그룹 중간(measure 2~3번째)을 찍었을 때 신규행이
    //   measure 사이에 낀다. 요구는 "data Group 제일 위로 / 선택한 값의 병합한 데이터 위로".
    //   배열 끝에 붙여 누른 순서를 유지한다 — 같은 앵커에 연속 Insert 시 누른 순서대로 쌓인다.
    const anchorRow = groupTopRowOf(gridRef.current?.selection.row ?? -1);
    setInsertedRows(prev => [...prev, { row: newRow, anchor: anchorRow }]);
    focusRowRef.current = newRow;
    // 필터를 걸어 둔 채 Insert 해도 필터는 유지한다. 신규행이 필터 조건에 걸려 숨는 문제는
    //   SalesPlanGrid 의 keepRowVisibleUnderFilter 재등록이 담당한다 (DMF0020 배선 1:1).
    //   금지: 여기서 gridFilter.clear() 를 부르지 말 것 — 사용자가 건 필터가 통째로 풀린다.
  };

  // F9 Delete — AS-IS DeleteButton(L673~679) 1:1 — Action='I'(신규 삽입행)만 즉시 제거.
  //   DB 조회행은 무동작(silent) — 저장행 삭제는 셀 0 저장(SP 'D' 전환) 경로만 (DMF0082 와 상이).
  const handleDelete = () => {
    if (isPending) return;
    const g = gridRef.current;
    if (!g) return;
    // ⚠ 드래그 다중 선택 — `selectedItems[0]` 만 보면 **마지막 포커스 행 하나만** 지워진다
    //   (2026-08-22 리포트). 선택된 행 전부를 대상으로 삼는다.
    const selected = (g.selectedItems ?? []) as SalesPlanRow[];
    const insertSel = selected.filter(r => r.CRUD_TYPE === 'I'); // 조회행은 무동작 (AS-IS L675)
    if (insertSel.length === 0) return; // silent (AS-IS L675 — I 행 외 무동작)
    const gids = new Set(
      insertSel.map(r => r.INSERT_GROUP_ID).filter((v): v is string => Boolean(v))
    );
    const singles = new Set(insertSel.filter(r => !r.INSERT_GROUP_ID));
    // 삭제 대상이 다른 신규행의 앵커였다면 그 앵커를 삭제 행의 앵커로 승계시킨다.
    //   (승계하지 않으면 앵커 유실로 딸린 행들이 그리드 맨 위로 튄다.)
    setInsertedRows(prev => {
      const isRemoved = (p: PendingInsert) =>
        (!!p.row.INSERT_GROUP_ID && gids.has(p.row.INSERT_GROUP_ID)) || singles.has(p.row);
      const inherited = new Map<SalesPlanRow, SalesPlanRow | null>();
      prev.filter(isRemoved).forEach(p => inherited.set(p.row, p.anchor));
      if (inherited.size === 0) return prev;
      // 승계 대상이 또 삭제된 행이면 살아 있는 앵커가 나올 때까지 타고 올라간다(순환 가드 포함).
      const resolve = (anchor: SalesPlanRow | null): SalesPlanRow | null => {
        const seen = new Set<SalesPlanRow>();
        let cur = anchor;
        while (cur && inherited.has(cur) && !seen.has(cur)) {
          seen.add(cur);
          cur = inherited.get(cur) ?? null;
        }
        return cur;
      };
      return prev
        .filter(p => !isRemoved(p))
        .map(p => (p.anchor && inherited.has(p.anchor) ? { ...p, anchor: resolve(p.anchor) } : p));
    });
  };

  // F7 Save — AS-IS SaveData(L1922~2828) 1:1. ⚠ 저장확인 없음 — 즉시 저장 (MSG00012 부재, 사용자 확정).
  //   검증(V-V1 필수 13종) → 18키 '^' bulk 조립(Catch_Up 음수/라인 변경 0건 조립 검증) →
  //   apiClient.post 직접 → 결과 '^' 토큰 분해(MSG 코드 추출) → 성공 MSG00002 + 재조회(스크롤 복원).
  const handleSave = async () => {
    if (blockIfWorking()) return;
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const savedSelection = gridRef.current?.selection
      ? { row: gridRef.current.selection.row, col: gridRef.current.selection.col }
      : null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<SalesPlanRow, Record<string, unknown>>
        | undefined) ?? new Map<SalesPlanRow, Record<string, unknown>>();
    const editedRows = [...changedMap.keys()].filter(r => r.CRUD_TYPE !== 'I');

    // (0) 변경 0건 + 필수 13종 division×measure 분기 (MSG00004 / MSG00429 {0})
    const vr = validation.validateSaveRows(
      [...insertRowList, ...editedRows],
      sc.divisionId,
      staticColumns
    );
    if (!vr.ok) return;

    // (1) (행 × 변경 기간셀) unfold — 활성 버킷 셀만, 빈값→'0'→'D', Catch_Up 음수/라인 무변경 검증
    const build = buildUnfoldRows({
      insertedRows: insertRowList,
      editedChanges: changedMap,
      divisionId: sc.divisionId,
      bucketType: sc.bucketType,
      msg: { catchupMinZero: MSG.CATCHUP_MIN_ZERO, lineNoChange: MSG.LINE_NO_CHANGE },
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
    const auditUserId = useSessionStore.getState().session.userId ?? '';
    const payload = buildSavePayload(build.rows, auditUserId);
    if (!payload) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }

    // void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    setIsPending(true);
    try {
      const res = await callSaveSalesPlan(payload);
      if (!res.ok) {
        // SP 반환 '^' 토큰 처리 — AS-IS L2776~2788 [E20250520-000572] 1:1.
        //   코드 검출: MSG_M 다국어 변환 후 '^' 뒤 토큰을 {0} 자리에 치환 (formatSaveErrorText).
        //   코드 미검출: SP 오류문 원문을 그대로 띄운다 (AS-IS else 분기 MessageBox.Show 대응).
        const reason = res.msgCode
          ? formatSaveErrorText(t(res.msgCode, res.msgCode), res.addMessage, res.msgCode)
          : res.addMessage || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      await (refetch?.() ?? Promise.resolve());
      // 재조회 후 스크롤 위치 복원 (AS-IS FindData(false, updRow, actCol) 셀 위치 복원 — best-effort)
      if (savedScroll || savedSelection) {
        window.requestAnimationFrame(() => {
          const g = gridRef.current;
          if (!g) return;
          if (savedScroll) g.scrollPosition = savedScroll;
          if (savedSelection && g.rows.length > 0 && g.columns.length > 0) {
            const row = Math.min(Math.max(savedSelection.row, 0), g.rows.length - 1);
            const col = Math.min(Math.max(savedSelection.col, 0), g.columns.length - 1);
            g.select(row, col);
            g.scrollIntoView(row, col);
          }
        });
      }
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setIsPending(false);
    }
  };

  // SubTitle 공통버튼 — 미명시(sort/filter/condition/resetCondition/excel)는 DefaultButtonActions 자동 (hook #64).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 2종 — Column Setting / Measure Select (icon-only. AS-IS btnColumn L4427 / btnMeasure L4440)
  const customButtons = [
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
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  const spRows = useMemo<SalesPlanRow[]>(() => mainData?.data ?? [], [mainData]);
  // ⭐ measure 행 필터는 서버(TITLESET 'M') 단일 출처 — 모달 OK 의 saveTitleSet('M') + invalidate 재조회로
  //   반영 (클라이언트 measure 행 필터 금지 — DMF0003 종속 메저 잘림 사고 계보).
  // 조회행 + 신규행 병합 — 신규행은 앵커(= 선택 셀이 속한 머지 블록의 첫 행) 바로 위에 놓는다.
  //   앵커가 사라진 경우(재조회로 객체 참조 교체 등)는 맨 위로 폴백 — 행이 증발하지 않게 한다.
  const rows: SalesPlanRow[] = useMemo(
    () => mergeInsertedRows(spRows, insertedRows),
    [insertedRows, spRows]
  );

  // Insert 직후 새 행으로 포커스·스크롤 이동 — 신규행이 그리드 중간(선택 블록 맨 위)에 생기므로
  //   이동이 없으면 사용자가 새 행을 찾아 스크롤해야 한다.
  //   필수: 실패 시 다음 프레임에 한 번 더 시도한다. itemsSource 가 바뀌면 wijmo 는 스크롤을 0 으로
  //   되돌리는데, 이 시점에 grid.rows 가 아직 새 배열을 반영하지 않았으면 findIndex 가 -1 이라 그대로
  //   빠져나가 화면이 맨 위에 머문다. 재시도 후에도 못 찾으면 조용히 포기(다음 Insert 에 영향 없음).
  useEffect(() => {
    const target = focusRowRef.current;
    if (!target) return;
    const grid = gridRef.current;
    if (!grid) return;
    const focusTarget = (): boolean => {
      const rowIndex = grid.rows.findIndex(r => r.dataItem === target);
      if (rowIndex < 0) return false;
      grid.select(rowIndex, Math.max(0, grid.selection.col));
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

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <SalesPlanForm
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
        excelFileName='SalesPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <SalesPlanGrid
        rows={rows}
        gridRef={gridRef as never}
        tabId={tabId}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        currentYyyymmdd={filters[SHEETS.MAIN]?.nowYyyymmdd ?? ''}
        startYyyymmdd={filters[SHEETS.SPREAD_TITLE]?.startYyyymmdd ?? ''}
        endYyyymmdd={filters[SHEETS.SPREAD_TITLE]?.endYyyymmdd ?? ''}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        calendarInfo={calendarInfo}
        editAuth={editAuth}
        measureInfoRows={measureInfoRows}
        staticMeasures={staticMeasures}
        onPopupCellDblClick={(modalKey, row) => {
          setPopupRow(row);
          if (modalKey === 'ITEM') setOpenItem(true);
          else setOpenProject(true);
        }}
      />

      {/* 모달 4종 — 셀 PROJECT/ITEM + Column/Measure Setting (components/SalesPlanModals — 진입 분리) */}
      <SalesPlanModals
        divisionId={sc.divisionId}
        openProject={openProject}
        openItem={openItem}
        openColumnSetting={openColumnSetting}
        openMeasureSelect={openMeasureSelect}
        popupRow={popupRow}
        onClose={(key: SalesPlanModalKey) =>
          ({
            PROJECT: setOpenProject,
            ITEM: setOpenItem,
            COLUMN: setOpenColumnSetting,
            MEASURE: setOpenMeasureSelect,
          })[key](false)
        }
        applyToInsertRow={patch => {
          const popupGroupId = popupRow?.INSERT_GROUP_ID;
          if (!popupGroupId) return;
          // 셀 팝업 반영은 행 객체를 새로 만든다 — 그 행을 앵커로 잡고 있던 다른 신규행의 참조도
          //   같이 갈아끼워야 한다. 안 그러면 앵커 유실로 딸린 행이 그리드 맨 위로 튄다.
          setInsertedRows(prev => {
            const replaced = new Map<SalesPlanRow, SalesPlanRow>();
            const next = prev.map(p => {
              if (p.row.INSERT_GROUP_ID !== popupGroupId) return p;
              const row: SalesPlanRow = { ...p.row, ...patch };
              replaced.set(p.row, row);
              return { ...p, row };
            });
            if (replaced.size === 0) return prev;
            return next.map(p => {
              const swapped = p.anchor ? replaced.get(p.anchor) : undefined;
              return swapped ? { ...p, anchor: swapped } : p;
            });
          });
          setPopupRow(null);
        }}
        onSettingChanged={clearGridOnSettingChange}
      />
    </>
  );
};
