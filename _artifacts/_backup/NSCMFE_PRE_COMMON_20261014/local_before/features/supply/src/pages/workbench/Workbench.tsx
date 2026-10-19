// SCP0125 Workbench — 5탭 편집 화면. 최상위 래퍼 div 금지(hook #132 §1-2, V24).
//
// AS-IS 근거: SCP0125_Workbench.cs (2404라인) / .Designer.cs (523라인)
//   레이아웃 Designer:460~471 · 툴바 5종 cs:484~528 · 탭 전환 가드 cs:2054~2067 ·
//   Insert cs:719~833 · Delete cs:494~510 · Save cs:836~1960

import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { WorkbenchForm } from './components/WorkbenchForm';
import { WorkbenchGrid } from './components/WorkbenchGrid';
import { useWorkbenchData } from './hooks/useWorkbenchData';
import { useWorkbenchValidation } from './hooks/useWorkbenchValidation';
import { useWorkbenchStore } from './useWorkbenchStore';
import { isRowDeletable } from './utils/workbench.editLock';
import { buildInsertRow } from './utils/workbench.insert';
import { buildSavePayload, isDirtyRow } from './utils/workbench.save';
import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  MSG,
  resolvePlanDateMode,
  resolveSheet,
  TAB_ORDER,
  TABS,
  usesVersion,
} from './workbench.constants';

export const Workbench = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [
    useRef<FlexGrid>(),
    useRef<FlexGrid>(),
    useRef<FlexGrid>(),
    useRef<FlexGrid>(),
    useRef<FlexGrid>(),
  ];
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];
  const editTrackerRefs = [
    useRef<EditTracker>(),
    useRef<EditTracker>(),
    useRef<EditTracker>(),
    useRef<EditTracker>(),
    useRef<EditTracker>(),
  ];
  const savingRef = useRef(false);

  const searchParams = useWorkbenchStore(state => state.searchParams);
  const setSearchParams = useWorkbenchStore(state => state.setSearchParams);
  const openSearchArea = useWorkbenchStore(state => state.openSearchArea);
  const setOpenSearchArea = useWorkbenchStore(state => state.setOpenSearchArea);
  const activeTab = useWorkbenchStore(state => state.activeTab);
  const setActiveTab = useWorkbenchStore(state => state.setActiveTab);
  const staticColumns = useWorkbenchStore(state => state.staticColumns);
  const fetchStaticColumns = useWorkbenchStore(state => state.fetchStaticColumns);
  const setFilters = useWorkbenchStore(state => state.setFilters);
  const clearFilters = useWorkbenchStore(state => state.clearFilters);

  // SAVE SP 의 `P_USER_ID`(감사컬럼 원천) — `/call-proc` 은 세션을 주입하지 않으므로 FE 가 싣는다.
  //   선례 capa-line-master/CapaLineMaster.tsx:47.
  const sessionUserId = useSessionStore(state => state.session.userId);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  /**
   * 편집 권한 단일 축 — 규범 convert-core §2.4(편집모드 기본 ON, 권한은 화면 오픈 시 1회).
   * AS-IS 의 Edit 버튼 모드토글(cs:484~528 `override EditButton` / `siMain.IsLock`)은 **미이식**이다
   * (판정 근거 goal.md §8 / 기록 design/04_react-gap.md · `__asis-mapping__.md`). 컬럼 단위 잠금은
   * `utils/workbench.editLock.ts` 가 계속 담당한다 — 모드가 아니라 컬럼 속성이므로 유지된다.
   */
  const canEdit = hasButton('EDIT');
  const { saveWithValidation } = useSaveWithValidation();
  const { validateSaveRows } = useWorkbenchValidation();
  const { setAlert, setToast } = useMessageStore.getState();

  const { init, isGmDivision, isUcDivision, rowsByTab, isFetching, comboRowsByTab, deriveSources } =
    useWorkbenchData(tabId);

  const planDateMode = resolvePlanDateMode(activeTab, isGmDivision);

  /**
   * 조회·신규행 기준일 단일 원천 — B2 결정(goal.md §7): 표시 위젯 · 조회 기준일 · 신규행 CUTOFF
   * 기준일이 **항상 일치**해야 한다. AS-IS 는 이 3축이 4지점에서 어긋난다(§5 K2 / §6 U2) —
   * 의도적 정정이며 `runtime-parity-gate` 에 기록한다.
   */
  const planStartYyyymmdd = useMemo(
    () =>
      planDateMode === 'daily' ? searchParams.planDateDaily : searchParams.planStartYyyymmdd,
    [planDateMode, searchParams.planDateDaily, searchParams.planStartYyyymmdd]
  );

  // mount 1회 — keep-alive 탭에 남은 stale filters 로 자동 발사되는 것을 막고(§5-7)
  //   admin 컬럼 메타를 받는다(5 sheetNm).
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // R02 — 조회 가드. 이 화면에서 실제로 발동하는 분기는 Division 옵션 0건뿐이고
  //   필수(`*`) 조회조건은 0건이다(V02/W17). Division 미선택이면 조회하지 않는다.
  const handleSearch = useCallback(() => {
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTHORITY, '_No authority assigned.'),
      });
      return;
    }
    // G08 — AS-IS 는 조회마다 헤더를 재구성한다 → 컬럼 메타를 Search 시마다 refetch.
    void fetchStaticColumns();
    setFilters(
      resolveSheet(activeTab, isUcDivision),
      planStartYyyymmdd,
      usesVersion(activeTab) ? searchParams.versionNo : ''
    );
    // R07 "조회 후 조회모드 복귀"는 미이식이다 — 규범 §2.4 로 모드축 자체가 없어졌다(§5 K3 도 무효).
    //   조회 결과의 편집 가능 범위는 `canEdit` × 컬럼 속성이 결정한다.
  }, [
    searchParams.divisionId,
    searchParams.versionNo,
    activeTab,
    isUcDivision,
    planStartYyyymmdd,
    fetchStaticColumns,
    setFilters,
    setAlert,
    t,
  ]);

  // R05 — Division 변경: 하위 콤보 재계산 + **5탭 그리드 전부 비움**(AS-IS ClearDataSource cs:1997).
  const handleDivisionChange = useCallback(
    (divisionId: string) => {
      setSearchParams({ divisionId, planStartYyyymmdd: '', versionNo: '' });
      clearFilters();
    },
    [setSearchParams, clearFilters]
  );

  // R06 — Plan Date(주) 변경: Version 만 재계산되고 그리드는 5탭 전부 비워진다(cs:2004).
  const handlePlanDateChange = useCallback(
    (planStart: string) => {
      setSearchParams({ planStartYyyymmdd: planStart, versionNo: '' });
      clearFilters();
    },
    [setSearchParams, clearFilters]
  );

  /**
   * R09·R10 탭 전환 가드 — `TabWrapper` 는 `setActiveTabIndex` 를 무조건 호출하므로 veto 는
   * **이 함수 안에만** 둔다(`onTabClick` 이중 배선 금지, §5 K8). 공용 `Tab.tsx` 는 수정하지 않는다.
   */
  const handleTabChange = useCallback(
    (index: number) => {
      if (isFetching) return; // R09 — 조회 중이면 무메시지 차단
      const grid = gridRefs[activeTab].current;
      // 편집 중인 셀을 먼저 커밋해 `CRUD_TYPE` 마킹을 확정한다(커밋 전 전환 시 dirty 판정 누락 방지).
      grid?.finishEditing();
      const source = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      // R10 대체 규칙(goal.md §8 확정) — 편집이 기본 ON 이라 AS-IS 의 "편집 중(IsLock==false)" 조건은
      //   상시 참이 되어 그대로 쓰면 탭 전환이 영구 차단된다. AS-IS 의 의도(미저장 변경 유실 방지)를
      //   보존하도록 **미저장 변경(dirty)이 1건 이상일 때만** 차단한다. 판정은 `CRUD_TYPE` 전용이다.
      if (source.some(isDirtyRow)) {
        // {0} = 현재 시트명.
        void setAlert({
          type: 'alert',
          content: t(MSG.SHEET_CHANGE_BLOCKED, {
            defaultValue: 'You are modifying {0} and can not change the sheet.',
          }).replace('{0}', ADMIN_SHEET_NAME[activeTab]),
        });
        return;
      }
      setActiveTab(TAB_ORDER[index] ?? TABS.MKT_FCST);
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [isFetching, activeTab, setActiveTab, setAlert, t]
  );

  /**
   * R11·R12·R13 신규행 — EDIT 권한이 없으면 무동작(AS-IS D12 의 모드 게이트를 `canEdit` 로 재표현).
   * 기본값의 division 은 **확정 searchParams** 기준이다(조회 전 filters 는 비어 있어 하드코딩 폴백으로
   * 새는 사고를 막는다).
   */
  const handleInsert = useCallback(() => {
    if (!canEdit) return;
    const grid = gridRefs[activeTab].current;
    if (!grid) return;

    GridAction.addRow(
      grid,
      buildInsertRow(activeTab, {
        divisionId: searchParams.divisionId,
        versionNo: searchParams.versionNo,
        planStartYyyymmdd,
        // Elec. Demand 의 PLAN_START 는 AS-IS 도 GM 분기가 없어 항상 주단위 콤보다(cs:788).
        planStartWeekly: searchParams.planStartYyyymmdd,
        versionAll: init.versionAll,
      })
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    activeTab,
    canEdit,
    searchParams.divisionId,
    searchParams.versionNo,
    searchParams.planStartYyyymmdd,
    planStartYyyymmdd,
    init.versionAll,
  ]);

  /**
   * R14 삭제 — 4중 가드: 활성 그리드 존재 / 선택 행 필수(D03) / `CHG_TYPE` 값이 있는 행만(D11).
   * 원본행(CHG_TYPE 공백)은 삭제하지 않는다.
   */
  const handleDelete = useCallback(() => {
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    const selected = grid.selection?.row ?? -1;
    if (selected < 0) return;
    const dataItem = grid.rows[selected]?.dataItem as Record<string, unknown> | undefined;
    // D11 — 원본행(CHG_TYPE 공백) 삭제 금지. 판정은 editLock 순수함수 1곳에서만 한다.
    if (!isRowDeletable(dataItem)) return;
    GridAction.removeRow(grid);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab]);

  /**
   * SAVE 전송 — `SCM_ADM_PROC_M` IN 이 행축 전건 CLOB 평면 파라미터라 `useProcMutation`(`{data: rows}`)
   * 으로는 바인딩되지 않는다(BE `makeProcedure` 는 배열을 결합하지 않는다) → 평면 payload 직접 전송.
   * `sesUserId`(SP `P_USER_ID`)는 `/call-proc` 이 주입하지 않으므로 세션값을 FE 가 싣는다.
   * false-success 판별 필수(§5-10) — 인터셉터가 500/CODE≠0 도 resolve 한다.
   */
  const sendSave = useCallback(
    async (rows: Record<string, unknown>[]) => {
      if (savingRef.current) return;
      // 감사키 빈문자열 금지 — 세션이 없으면 전송하지 않는다(NULL/'' 로 원장이 적재되는 것을 막는다).
      if (!sessionUserId) {
        void setAlert({
          type: 'alert',
          content: t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
        return;
      }
      const payload = buildSavePayload(activeTab, rows, searchParams.divisionId, sessionUserId);
      if (!payload) return;

      savingRef.current = true;
      try {
        const sheet = resolveSheet(activeTab, isUcDivision);
        const response = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${sheet}/SAVE/call-proc`,
          payload
        );
        if (response.status >= 400 || Number(response.data?.code)) {
          void setAlert({
            type: 'alert',
            content:
              (response.data as { message?: string })?.message?.trim() ||
              t(MSG.SAVE_FAIL, '_Failed to save.'),
          });
          return;
        }
        // 저장 성공 = Toast(설계 01_layout.md §4 V25 · hook #132 — alert 금지).
        //
        // 건수는 전송 행수를 쓴다. SP OUT `O_RESULT_CNT`(4 SAVE 전건 존재, 실측)는 성공 시
        //   `V_MAX_LOOP_CNT`(= `^` 평면 payload 의 토큰 수 = 전송 행수)를 담아 값이 동일하고,
        //   BE `/call-proc` 은 스칼라 OUT 을 응답에 싣지 않는다(`BaseService.makeProcedure`:676~689 가
        //   CURSOR 만 `@` 키로 등록 → `selectList`:95~99 이 `@` 키만 result 에 복사). 스칼라 OUT 전달은
        //   `call-proc-stream` 경로에만 있어 FE 단독으로는 읽을 수 없다 — 04 리포트 잔여 기록.
        setToast({
          type: 'success',
          message: t(MSG.SAVE_RESULT, '_{0} data saved.').replace(
            '{0}',
            String(rows.length)
          ),
        });
        // 저장 후 조회 축·활성 탭을 보존한 재조회(hook #131) + 편집 상태 정리.
        //   "조회모드 복귀"는 없다(규범 §2.4 — 모드축 미이식).
        editTrackerRefs[activeTab].current?.clearChanges();
        handleSearch();
      } finally {
        savingRef.current = false;
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [
      activeTab,
      isUcDivision,
      searchParams.divisionId,
      sessionUserId,
      handleSearch,
      setAlert,
      setToast,
      t,
    ]
  );

  /**
   * R15 저장 — 3중 가드(EDIT 권한 / 빈 그리드는 Toast) 후 검증 39건 → `^` 결합 payload.
   * `CRUD_TYPE` 마킹 행만 대상이며 자체 행상태 필드는 쓰지 않는다.
   * AS-IS D13("Edit 모드 아니면 return")은 모드가 아니라 `canEdit` 로 재표현한다(규범 §2.4).
   */
  const handleSave = useCallback(() => {
    if (!canEdit) return;
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    grid.finishEditing();

    const source = (grid.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // D14 — 빈 그리드면 Toast(alert 아님, hook #132 §3).
    if (source.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }

    const dirty = source.filter(isDirtyRow);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }

    // ④ 4계층 중 저장 필수검증 — 공용 메타 검증(현재 `INPUT_TP_CD` 전건 'S' 라 무발동)과
    //   화면 명시 검증(정본)을 함께 건다. 순서: 메타 검증 통과 후 화면 검증 → 전송.
    saveWithValidation(dirty, staticColumns[activeTab], () => {
      const validated = validateSaveRows(activeTab, source, {
        divisionId: searchParams.divisionId,
        projectAll: init.projectAll,
        projectCode40All: init.projectCode40All,
        itemAll: init.itemAll,
      });
      if (!validated) return;
      if (validated.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_CHANGE, '_No changes to save.'),
        });
        return;
      }
      void sendSave(validated);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    activeTab,
    canEdit,
    staticColumns,
    searchParams.divisionId,
    init,
    validateSaveRows,
    saveWithValidation,
    sendSave,
  ]);

  // 툴바 5종 — `01_layout.md §2.3` 확정값. NO-OP override 0건이라 전부 실동작이다.
  //   키 생략 금지: insert/delete 를 빼면 공용 기본 addRow/removeRow 가 살아나 권한이 없어도 동작한다.
  //   모드 게이트였던 `isEditMode` 는 규범 §2.4 에 따라 `canEdit`(EDIT 권한)로 치환했다.
  //
  //   Excel 도 같은 함정에 걸린다(2026-09-26 정정). AS-IS override 가 없으니 공용 기본 동작을
  //   살리는 것 자체는 맞지만, **키를 통째로 생략하면 권한축까지 같이 죽는다** — 공용 `SubTitle` 이
  //   `{...DefaultButtonActions, ...hotkeyConfig}` 로 병합하고 내부에 `hasButton` 필터가 없어서
  //   `SCM_ADM_MNU_BTN_MPG_M` 의 EXCEL 7행 + 그룹권한 28행을 회수해도 버튼이 그대로 동작한다
  //   (memory `subtitle-insert-delete-omit-defaults-live-noop` — "미등록 = 버튼 미노출" 은 오해).
  //   → 권한이 있으면 공용 기본을 그대로 쓰고(`{}`), 없을 때만 `false` 로 끈다. 형제 SCP0123
  //     `plan-control/PlanControl.tsx` 와 같은 형태다. `excel: undefined` 는 금지(죽은 키가 되어
  //     기본 액션이 되살아난다). CLAUDE.md §2 체크 3항("hotkeyConfig 는 hasButton 조건부") 충족.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && canEdit ? handleInsert : false,
    delete: hasButton('DELETE') && canEdit ? handleDelete : false,
    save: hasButton('SAVE') && canEdit ? handleSave : false,
    manual: false,
    upload: false,
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  // Edit 토글 버튼(`customButtons`)은 두지 않는다 — 규범 §2.4 로 모드 토글 자체가 미이식이다.
  //   `EDIT` 버튼코드 메타(`SCM_ADM_MNU_BTN_MPG_M`)는 위 `canEdit` 권한축이므로 등록은 유지한다
  //   (goal.md §8 "Edit 토글 버튼" 행 · `05_register.sql` 등록분 삭제 금지).

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <WorkbenchForm
          init={init}
          isGmDivision={isGmDivision}
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          onPlanDateChange={handlePlanDateChange}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={rowsByTab[activeTab].length}
        excelFileName='Workbench'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams as unknown as Record<keyof object, string>}
      />
      {/* `persist` = 5탭 콘텐츠 상시 마운트 → AS-IS FpSpread 가 시트별 데이터·편집상태를 각자
          보유하는 것과 등가(V26/V27). 탭 캡션은 admin `SHEET_NAME` 이다(AS-IS AddSheet 명칭). */}
      <TabWrapper persist activeTabIndex={activeTab} setActiveTabIndex={handleTabChange}>
        {TAB_ORDER.map(tab => (
          <TabItem key={ADMIN_SHEET_NAME[tab]} label={ADMIN_SHEET_NAME[tab]}>
            <WorkbenchGrid
              tab={tab}
              rows={rowsByTab[tab]}
              gridRef={gridRefs[tab]}
              gridFilterRef={gridFilterRefs[tab]}
              editTrackerRef={editTrackerRefs[tab]}
              staticColumns={staticColumns[tab]}
              comboRows={comboRowsByTab[tab]}
              deriveSources={deriveSources}
              canEdit={canEdit}
              divisionId={searchParams.divisionId}
              onFocus={() => setActiveTab(tab)}
            />
          </TabItem>
        ))}
      </TabWrapper>
    </>
  );
};
