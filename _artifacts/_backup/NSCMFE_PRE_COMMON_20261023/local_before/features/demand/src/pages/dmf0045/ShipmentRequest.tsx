import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentRequestForm } from './components/ShipmentRequestForm';
import { ShipmentRequestGrid } from './components/ShipmentRequestGrid';
import { type ShipmentModalKey, ShipmentRequestModals } from './components/ShipmentRequestModals';
import { type BUCKET_TYPE, INSERT_ROW_DEFAULTS, MENU_ID, MSG, SHEETS } from './dmf0045.constants';
import type { ActiveSheet, ShipmentRequestRow, SpreadTitleRow } from './dmf0045.types';
import { useShipmentRequestStore } from './useShipmentRequestStore';
import {
  callSaveShipmentRequest,
  formatSaveErrorText,
} from './utils/dmf0045.api';
import { applyBohFrontFill } from './utils/dmf0045.bohFrontFill';
import { canOpenBodPopup } from './utils/dmf0045.editLock';
import { buildSavePayload, buildUnfoldRows } from './utils/dmf0045.save';
import { SEARCH_COMBO } from './utils/dmf0045.searchCombos';
import { useShipmentRequestValidation } from './utils/dmf0045.validate';

// AS-IS DMF0045_ShipmentRequest (Demand > Demand Plan > Shipment Request / 출하요청 —
//   GSCM.DM.Plan.UIL 2,305줄 정본 1:1).
//   Division 3종(40 Mobility / 81* Automotive / 82 ESS) 단일 화면 — 시트 2개(Pack Biz / Cell Biz).
//   조회 = PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST(11 IN + 커서 2: data/result) /
//   저장 = P_DMF0045_SAVE_SHIPMENT_REQUEST(13 CLOB '^' bulk + P_CREATED_BY) /
//   동적 기간 헤더 = GET_SPREAD_TITLE(5 IN). 구조 골격 = sales-plan(DMF0021) 정본.
//   SubTitle 공통버튼: search/insert/delete/save + excel/filter/sort/condition/reset(자동, hook #64) +
//   커스텀 2종(Column Setting / Measure Select icon-only). EDIT(F2)는 상시편집(convert-core §2.4)으로 대체.
export const ShipmentRequest = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<ShipmentRequestRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const validation = useShipmentRequestValidation();

  const sc = useShipmentRequestStore(s => s.searchCondition);
  const setSearchCondition = useShipmentRequestStore(s => s.setSearchCondition);
  const setBucketType = useShipmentRequestStore(s => s.setBucketType);
  const activeSheet = useShipmentRequestStore(s => s.activeSheet);
  const filters = useShipmentRequestStore(s => s.filters);
  const setFilter = useShipmentRequestStore(s => s.setFilter);
  const clearFilters = useShipmentRequestStore(s => s.clearFilters);
  const openSearchArea = useShipmentRequestStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentRequestStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentRequestStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentRequestStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useShipmentRequestStore(s => s.restoreSearchConditions);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // Division 기본 선택 (sales-plan/DMF0003/DMF0020 정본 통일). 세션 division 이 MyDivision 목록에
  //   있으면 그것, 없으면 목록 첫 행. sc.divisionId 가 비어 있을 때만 채운다(사용자 선택 보존).
  const session = useSessionStore(s => s.session);
  const [divisionRows] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  useEffect(() => {
    if (sc.divisionId) return;
    const codes = (divisionRows ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchCondition({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [divisionRows, sc.divisionId, session.div, setSearchCondition]);

  // 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). 마운트 시 persist 된 stale filters 로 SP 가
  //   자동 발사되어 NULL payload 사고 차단 (sales-plan 계보). Search 클릭 후에만 enable.
  const [hasSearched, setHasSearched] = useState(false);
  const [isPending, setIsPending] = useState(false);

  // GridAction.addRowSet/removeRow 는 itemsSource 를 직접 splice 하고 setState 를 호출하지 않는다 —
  //   Insert/Delete 이후 파생값(pendingRows 등)을 갱신하려면 강제 리렌더가 필요하다.
  const [, forceGridRerender] = useState(0);

  // 메인 그리드 SP — P_DMF0045_GET_SHIPMENT_REQUEST (11 IN + 커서 2). PIVOT wide format.
  //   URL sheet 세그먼트는 등록 시트명(activeSheet=Pack Biz/Cell Biz)이어야 한다 — BE 는
  //   PR_GET_PROC_INFO_LIST 가 (mnuId, shtNm, mnuBtnCd) SELECT INTO 로 프로시저를 해소하는데,
  //   미등록 shtNm('data')은 SCM_ADM_MNU_BTN_MPG_M 매칭 0행 -> NO_DATA_FOUND(ORA-01403)로 조회 실패한다.
  //   SEARCH 버튼은 Pack Biz/Cell Biz 로 등록돼 있고(같은 API_URL) SAVE 경로도 activeSheet 를 쓴다.
  //   응답 키는 SP OUT 커서의 등록 COL_NM 그대로다 — call-proc 경로(execBtn→makeProcedure→
  //   selectList)는 커서를 COL_NM 키로 노출하고 useTabProcQuery 는 result 를 가공 없이 반환한다.
  //   SCM_ADM_PROC_M 실측상 P_DMF0045_GET_SHIPMENT_REQUEST 의 실데이터 커서 COL_NM 은 'o_rc1'
  //   (o_result_cursor 는 PROC_RESULT 상태 커서). 자매 화면(DMF0021/0042)은 'data' 로 등록됐으나
  //   DMF0045 만 'o_rc1' 이라, mainData 를 o_rc1 키로 읽어야 한다(불일치 시 조용히 빈 그리드).
  const { data, refetch, isFetching } = useTabProcQuery<MENU_ID, ActiveSheet>({
    menuId: MENU_ID,
    sheetName: activeSheet,
    tabId,
    filters: filters.data,
    enabled: hasSearched && !!filters.data,
  });

  // 동적 기간 헤더 SP — P_DMF0045_GET_SPREAD_TITLE (5 IN). 기간 컬럼(M_/W_/D_) 구조의 1차 소스.
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
  // 참조 고정 필수: useMemo 없이 ?? [] 로 만들면 조회조건 타이핑마다 부모 리렌더 시 매번 새 배열이
  //   되어 Grid spreadTitle prop 참조가 바뀐다 → 동적 헤더 재생성(깜빡임). 캐시가 실제로 바뀔 때만.
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    // GET_SPREAD_TITLE 실데이터 커서 COL_NM 도 'o_rc1'(SCM_ADM_PROC_M 실측) — mainData 와 동일 규약.
    () => (spreadTitleData as { o_rc1?: SpreadTitleRow[] } | undefined)?.o_rc1 ?? [],
    [spreadTitleData]
  );

  const mainData = data as { o_rc1?: ShipmentRequestRow[] } | undefined;
  // BOH(WH_BOH_PLAN/WH_BOH_REQ) 행은 첫 D_ 값을 선행 M_/W_ 에 파생 표기(design 03 §3 Set_SumValues).
  //   순수 파생이라 조회 rows 를 표시 전 1회 가공한다(BOH 행 없으면 원본 참조 그대로 통과 = no-op).
  const rows = useMemo<ShipmentRequestRow[]>(
    () => applyBohFrontFill(mainData?.o_rc1 ?? []),
    [mainData]
  );
  // 신규(Insert) 행 — 저장 필수값 검증·조립 대상. Grid collectionView 에 직접 물려 있어 rows 파생.
  const pendingRows = rows.filter(r => r.CRUD_TYPE === 'I');
  useEffect(() => {
    // 재조회 = EditTracker clear (hook #97). 신규행은 itemsSource 교체로 함께 사라진다.
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  // mount 시 1회 admin 메타 fetch (동적 속성관리 baseline) + persist 된 이전 filters 무효화 +
  //   SubTitle F6 저장 조회조건 복원(재진입/새로고침 시 저장 조건 유지, 저장분 없으면 기본값).
  useEffect(() => {
    clearFilters();
    void restoreSearchConditions();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 활성 시트(Pack Biz ↔ Cell Biz) 전환 시 division 종속 컬럼/measure 메타 재fetch.
  useEffect(() => {
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeSheet]);

  // 셀 모달 state (PROJECT_CODE→SCM0002 / TR_MODE→DMF0046 BOD / ITEM_ID→DMF0047 —
  //   AS-IS spdMain_CellDoubleClick, design 03 §3).
  const [openProject, setOpenProject] = useState(false);
  const [openBod, setOpenBod] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupRow, setPopupRow] = useState<ShipmentRequestRow | null>(null);

  // 참조 고정 필수: 인라인 함수로 넘기면 부모 리렌더마다 새 참조가 되어 Grid 의 wijmo 핸들러 설치
  //   effect 가 재실행된다(그리드 통째 재드로우). setter 는 useState 참조 보장이라 deps 는 비운다.
  const handlePopupCellDblClick = useCallback(
    (modalKey: ShipmentModalKey, row: ShipmentRequestRow) => {
      // BOD(DMF0046) 팝업은 ITEM_ID(Model) 선입력 전제 — 공란이면 오픈 취소 + MSG 차단.
      //   AS-IS spdMain_CellDoubleClick(cs 1312-1393): Model 미입력 시 MSG00098 로 막고 팝업 미오픈.
      //   TR_MODE 셀 아이콘/편집색은 isInsertModalCell 로 상시 노출하되 실제 오픈만 이 게이트가 담당.
      if (modalKey === 'BOD' && !canOpenBodPopup(row)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.ITEM_REQUIRED_FOR_BOD, '_Please select a Model first.'),
        });
        return;
      }
      setPopupRow(row);
      if (modalKey === 'ITEM') setOpenItem(true);
      else if (modalKey === 'BOD') setOpenBod(true);
      else setOpenProject(true);
    },
    [setAlert, t]
  );

  // Column / Measure 선택 모달 open state
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  const isWorkInProgress = isFetching || isSpreadTitleFetching || isPending;
  const blockIfWorking = (): boolean => {
    if (!isWorkInProgress) return false;
    void setAlert({
      type: 'alert',
      content: t(MSG.WORK_IN_PROGRESS, '_The previous operation is still in progress.'),
    });
    return true;
  };

  // 미저장 변경 존재 판정 — 신규 I 행 또는 EditTracker 변경 셀 (handleBucketChange 와 동일 축).
  const hasPendingChanges = (): boolean =>
    pendingRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // Search 실제 수행 — 편집 폐기 후 조회. (F5 wrapper 의 confirm 통과분/무변경분 공용 진입점)
  //   주의: refetch 직접 호출 금지 — stale closure filters 로 첫 호출 NULL payload 사고
  //   (memory: 파라미터 의존 자동 재조회). setFilter(queryKey 변경) + enabled 만으로 fetch.
  const runSearch = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F5 Search — AS-IS FindData 1:1. Division 미선택 가드(MSG00097) 후 조회.
  //   UI 공통 UC-02: 미저장 변경 중 재조회 시 MSG00703 confirm 후에만 편집 폐기·조회
  //   (AS-IS 는 confirm 없이 재조회하나 전 화면 공통 요구로 신설 — shipment-plan-electrode 정본).
  const handleSearch = () => {
    if (blockIfWorking()) return;
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Division is required.') });
      return;
    }
    if (hasPendingChanges()) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_RESEARCH_UNSAVED, '_There are unsaved changes. Do you want to search again?'),
        onConfirm: runSearch,
      });
      return;
    }
    runSearch();
  };

  // Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory: division 변경 grid 초기화 —
  //   재조회는 Search 버튼). filters 도 무효화해 stale payload 재사용 차단 + division 종속 메타 재fetch.
  const handleDivisionChange = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // Bucket 변경 가드 — 변경분(신규 I 행 또는 EditTracker 변경 셀) 존재 시 MSG00227 차단
  //   (AS-IS cboBucketType_Click, design 03 §3). TO-BE 상시편집이라 '편집모드'가 없어 pending 변경
  //   유무로 판정한다(validate.validateBucketChange). 통과 시에만 store 반영 — setBucketType 이
  //   헤더 기간 구조(GET_SPREAD_TITLE payload)를 setFilter 와 동일 규칙으로 재구성한다.
  const handleBucketChange = (next: BUCKET_TYPE) => {
    if (next === sc.bucketType) return;
    const hasPendingChanges =
      pendingRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;
    if (!validation.validateBucketChange(hasPendingChanges).ok) return;
    setBucketType(next);
  };

  // Column/Measure 설정 저장 = Grid 초기화 의무 (sales-plan clearGridOnSettingChange 정본).
  //   저장 즉시 표시 컬럼/measure 가 바뀌므로 이전 설정으로 조회한 rows 는 화면 구성과 어긋난다 —
  //   그리드를 비우고 재조회는 Search 로만. 주의: division 변경과 달리 메타 refetch/개인화 clear 는
  //   하지 않는다(설정 저장은 개인화를 '만드는' 동작 — 모달이 이미 fetchStaticColumns 재조회한다).
  //   필수: removeQueries([tabId]) — queryKey 는 filters 값 기반이라 동일 조건 재Search 시 전역
  //   staleTime=Infinity 캐시가 이전 설정으로 받은 rows 를 그대로 돌려준다.
  const handleSettingChanged = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
  };

  // F7 Save — AS-IS SaveData(cs 1922~2828) 1:1. 저장확인 없음 — 즉시 저장(sales-plan 규약).
  //   (0) D_ 정규화 조립(신규 값 D_ + EditTracker 변경 D_) — W_/M_ 은 편집 시점 grid 에서 D_ 전개됨.
  //   (1) 검증: 변경 0건(MSG00004 toast) + 필수 7종(+81 TO_SITE) + 음수 qty(MSG00085). 중복=SP 위임.
  //   (2) 13키 '^' bulk payload → callSaveShipmentRequest(활성 시트 경로). P_CREATED_BY BE 자동주입.
  //   (3) 결과 '^' 토큰 분해(formatSaveErrorText) / 성공 MSG00002 toast + 재조회(스크롤 복원).
  const handleSave = async () => {
    if (blockIfWorking()) return;
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const savedSelection = gridRef.current?.selection
      ? { row: gridRef.current.selection.row, col: gridRef.current.selection.col }
      : null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<ShipmentRequestRow, Record<string, unknown>>
        | undefined) ?? new Map<ShipmentRequestRow, Record<string, unknown>>();

    // (0) (행 × 변경 D_ 셀) unfold — 신규는 값 존재 D_, 수정은 EditTracker 변경 D_ (빈값→'0'→'D').
    const saveRows = buildUnfoldRows({
      insertedRows: pendingRows,
      editedChanges: changedMap,
      divisionId: sc.divisionId,
    });

    // (1) 검증 — 변경 0건 / 필수 7종(+81 조건부 TO_SITE) / 음수 qty
    const vr = validation.validateSaveRows(pendingRows, saveRows, sc.divisionId);
    if (!vr.ok) return;

    const payload = buildSavePayload(saveRows);
    if (!payload) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }

    setIsPending(true);
    try {
      const res = await callSaveShipmentRequest(activeSheet, payload);
      if (!res.ok) {
        // SP 반환 '^' 토큰 처리 — 코드 검출 시 MSG_M 변환 후 {0} 치환, 미검출 시 SP 원문(fallback).
        const reason = res.msgCode
          ? formatSaveErrorText(t(res.msgCode, res.msgCode), res.addMessage, res.msgCode)
          : res.addMessage || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      await (refetch?.() ?? Promise.resolve());
      // 재조회 후 스크롤/셀 위치 복원 (AS-IS FindData 위치 복원 — best-effort)
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
    } catch (error) {
      // call-proc SP 실패는 공용 responseInterceptor 가 O_RESULT_CURSOR[0].CODE 로 throw 하기도 한다
      //   (memory). 그 경우 여기서 잡아 사용자에게 알린다(무음 실패 방지).
      const message = error instanceof Error ? error.message : '';
      void setAlert({
        type: 'alert',
        content: message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
    } finally {
      setIsPending(false);
    }
  };

  // F8 Insert — AS-IS InsertRow 1:1. 신규행(CRUD_TYPE='I') 1행 추가.
  //   기본값: DIVISION_ID=선택 division(#10 잠금) + MEASURE='SHIP_REQ'(#11) + INSERT_ROW_DEFAULTS.
  //   주의: sales-plan 처럼 groupKey(buildGroupKeyOf) 를 넘기지 않는다 — DMF0045 머지는
  //   HierarchicalMergeManager 가 Insert 행(CRUD_TYPE='I')을 머지에서 제외하므로 신규행은 병합
  //   그룹에 끼지 않는다(dmf0045.merge.ts isInsertRow → null). 앵커 축이 없으니 그대로 above 삽입.
  const handleInsert = () => {
    if (isPending) return;
    const g = gridRef.current;
    if (!g) return;
    const newRow: ShipmentRequestRow = {
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: `I_${Date.now()}`,
      DIVISION_ID: sc.divisionId,
      ...INSERT_ROW_DEFAULTS,
    };
    const added = GridAction.addRowSet(
      g as unknown as FlexGridType<WijmoRowItem>,
      [newRow] as unknown as Partial<WijmoRowItem>[],
      'above',
      { preserveMergeManager: true }
    ) as unknown as ShipmentRequestRow[] | undefined;
    const target = added?.[0];
    if (target) {
      for (let i = 0; i < g.rows.length; i++) {
        if (g.rows[i]?.dataItem !== target) continue;
        g.select(i, Math.max(0, g.selection.col));
        g.scrollIntoView(i, -1);
        break;
      }
    }
    // addRowSet 은 setState 를 호출하지 않으므로 강제 리렌더 — rows(=spRows) 재계산 유도.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — AS-IS DeleteButton 1:1 — Action='I'(신규 삽입행)만 즉시 제거. DB 조회행 무동작(silent).
  //   저장행 삭제는 셀 0 저장(SP 'D' 전환) 경로만 — 여기서는 신규행만.
  const handleDelete = () => {
    if (isPending) return;
    const g = gridRef.current;
    if (!g) return;
    GridAction.removeRow(g as unknown as FlexGridType<WijmoRowItem>, true, true);
    forceGridRerender(v => v + 1);
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

  // 커스텀 2종 — Column Setting / Measure Select (icon-only. AS-IS btnColumn / btnMeasure).
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
            label: t('LBL00310', '_Measure'),
            title: t('LBL00310', '_Measure'),
            action: () => setOpenMeasureSelect(true),
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
        <ShipmentRequestForm
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          onBucketChange={handleBucketChange}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentRequest'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <ShipmentRequestGrid
        rows={rows}
        gridRef={gridRef as never}
        tabId={tabId}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        activeSheet={activeSheet}
        startYyyymmdd={filters[SHEETS.SPREAD_TITLE]?.startYyyymmdd ?? ''}
        endYyyymmdd={filters[SHEETS.SPREAD_TITLE]?.endYyyymmdd ?? ''}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        onPopupCellDblClick={handlePopupCellDblClick}
      />

      {/* 모달 5종 — 셀 PROJECT/BOD/ITEM + Column/Measure Setting (진입 분리) */}
      <ShipmentRequestModals
        divisionId={sc.divisionId}
        activeSheet={activeSheet}
        fromYyyymmdd={filters[SHEETS.SPREAD_TITLE]?.startYyyymmdd ?? ''}
        openProject={openProject}
        openBod={openBod}
        openItem={openItem}
        openColumnSetting={openColumnSetting}
        openMeasureSelect={openMeasureSelect}
        popupRow={popupRow}
        onClose={(key: ShipmentModalKey) =>
          ({
            PROJECT: setOpenProject,
            BOD: setOpenBod,
            ITEM: setOpenItem,
            COLUMN: setOpenColumnSetting,
            MEASURE: setOpenMeasureSelect,
          })[key](false)
        }
        applyToInsertRow={patch => {
          const popupGroupId = popupRow?.INSERT_GROUP_ID;
          if (!popupGroupId) return;
          // 신규행은 grid.collectionView.sourceCollection(=rows)에 직접 물려 있으므로 객체를 새로
          //   만들지 않고 그 자리에서 갱신한다 — 새 객체로 바꾸면 그 행을 참조하던 pin 이 끊긴다.
          const target = rows.find(r => r.INSERT_GROUP_ID === popupGroupId);
          if (target) {
            Object.assign(target as Record<string, unknown>, patch);
            gridRef.current?.invalidate();
          }
          setPopupRow(null);
        }}
        onSettingChanged={handleSettingChanged}
      />
    </>
  );
};
