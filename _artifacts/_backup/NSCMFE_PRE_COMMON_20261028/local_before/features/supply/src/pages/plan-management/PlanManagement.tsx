import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse, HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { EngineRunGrid } from './components/EngineRunGrid';
import { PlanManagementForm } from './components/PlanManagementForm';
import { PlanManagementGrid } from './components/PlanManagementGrid';
import {
  ACTION,
  ACTION_COLUMNS,
  type ActionColumn,
  MENU_ID,
  MSG,
  REVISION_CANDIDATE_KEYS,
  SHEETS,
} from './plan-management.constants';
import type { PlanRow, RevisionCandidateMap } from './plan-management.types';
import styles from './PlanManagement.module.scss';
import { usePlanManagementStore } from './usePlanManagementStore';

const str = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

// 액션 셀버튼 → 통합 SAVE actvCd + 확인 메시지(화면설계서 메시지 코드 표)
const ACTION_CONFIRM: Record<ActionColumn, { msg: string; fallback: string }> = {
  ENGINE_RUN: { msg: MSG.RUN_CONFIRM, fallback: '_Would you like to proceed?' },
  VER_CREATE: { msg: MSG.CREATE_CONFIRM, fallback: '_Do you want to create the Version?' },
  VER_CANCEL: { msg: MSG.CANCEL_CONFIRM, fallback: '_Do you want to cancel this Version?' },
  SHIP_REQ_CREATE: { msg: MSG.SHIP_REQ_CONFIRM, fallback: '_Would you like to proceed?' },
};

// SCP0134 Plan Management (신규 PKG_SCP0134). 설계: .atlas/gscm-design/SCP0134/human-doc/화면설계서.
//   상단 Main Grid(계획 수립 + 액션) / 하단 Detail Grid(선택 Version 엔진 진행). 저장 4종은 통합 SP
//   P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN(actvCd A01~A04) — 현재 엔진호출 미이관 스텁('S' 반환).
export const PlanManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const mainGridRef = useRef<FlexGrid>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const detailGridRef = useRef<FlexGrid>();
  const detailGridFilterRef = useRef<FlexGridFilter>();

  const initialized = usePlanManagementStore(s => s.initialized);
  const searchParams = usePlanManagementStore(s => s.searchParams);
  const filters = usePlanManagementStore(s => s.filters);
  const staticColumns = usePlanManagementStore(s => s.staticColumns);
  const openSearchArea = usePlanManagementStore(s => s.openSearchArea);
  const setOpenSearchArea = usePlanManagementStore(s => s.setOpenSearchArea);
  const setMainFilters = usePlanManagementStore(s => s.setMainFilters);
  const refreshMainFilters = usePlanManagementStore(s => s.refreshMainFilters);
  const setDetailFilters = usePlanManagementStore(s => s.setDetailFilters);
  const setSelected = usePlanManagementStore(s => s.setSelected);
  const clearFilters = usePlanManagementStore(s => s.clearFilters);
  const fetchStaticColumns = usePlanManagementStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = usePlanManagementStore(s => s.restoreSearchConditions);

  // Division 권한 0건 게이트 — Form 콤보 응답으로 판정, alert 1회만
  const [divisionRows, setDivisionRows] = useState<ComboResponse[] | undefined>(undefined);
  const authAlertShownRef = useRef(false);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN_GRID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_GRID,
    tabId,
    filters: filters[SHEETS.MAIN_GRID],
    enabled: !!filters[SHEETS.MAIN_GRID],
  });

  const { data: detailData, refetch: refetchDetail } = useTabProcQuery<MENU_ID, SHEETS.DETAIL_GRID>({
    menuId: MENU_ID,
    sheetName: SHEETS.DETAIL_GRID,
    tabId,
    filters: filters[SHEETS.DETAIL_GRID],
    enabled: !!filters[SHEETS.DETAIL_GRID],
  });

  // Main Grid 행 — 설계서 컬럼명 바인딩용 별칭(STATUS/UPDATE_TIME/UPDATE_USER ← 커서 필드)
  const planRows = useMemo<PlanRow[]>(
    () =>
      (mainData?.o_rc ?? []).map(r => ({
        ...r,
        STATUS: str(r.PLAN_STATUS_NAME),
        UPDATE_TIME: str(r.CONFIRM_TIME),
        UPDATE_USER: str(r.CONFIRM_USER),
      })),
    [mainData]
  );
  const engineRows = useMemo(() => detailData?.o_rc ?? [], [detailData]);

  // REVISION_NO 행별 콤보 후보 — 조회 응답에 o_rc2~o_rc5 동봉(PR/MA/SE/FN)
  const revisionCandidates = useMemo<RevisionCandidateMap>(() => {
    const map: RevisionCandidateMap = {};
    for (const [planType, cursorKey] of Object.entries(REVISION_CANDIDATE_KEYS)) {
      map[planType] = mainData?.[cursorKey as 'o_rc2'] ?? [];
    }
    return map;
  }, [mainData]);

  // mount — keep-alive 잔존 filters 무효화 + admin 컬럼 메타 1회 조회 + F6 저장 조회조건 복원(1회)
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Division 권한 0건 — SearchArea disabled + MSG00097 alert 1회
  const divisionAuthEmpty = divisionRows !== undefined && divisionRows.length === 0;
  useEffect(() => {
    if (!divisionAuthEmpty || authAlertShownRef.current) return;
    authAlertShownRef.current = true;
    void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_AUTH, '_Please select Division.') });
  }, [divisionAuthEmpty, setAlert, t]);

  // 조회 — 필수값 가드(Division·Year. PlanWeek 는 선택)
  const handleSearch = () => {
    if (divisionAuthEmpty) return;
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_AUTH, '_Please select Division.') });
      return;
    }
    if (!searchParams.planYear) return;
    void fetchStaticColumns(); // CLAUDE.md §2 — 컬럼 메타는 mount + Search 마다 refetch
    setMainFilters();
  };

  // 통합 저장 — PKG_SCP0134.P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN(actvCd). O_RESULT_CURSOR 로 성패 판정.
  //   금지: { data:[payload] } 래핑(makeProcedure 최상위 키 name-lookup) / 소문자 커서키.
  const callSaveProc = async (
    payload: Record<string, string>
  ): Promise<{ ok: boolean; count: number; message: string }> => {
    const res = await apiClient.post<{
      O_RESULT_CURSOR?: { RESULT_CODE?: string; RESULT_CNT?: number | string; MSG?: string }[];
    }>(`/${MENU_ID}/${SHEETS.MAIN_GRID}/${ACTION.EXECUTE}/call-proc`, payload);
    const cursor = res.data?.result?.O_RESULT_CURSOR?.[0];
    const ok = !(res.status >= 400 || Number(res.data?.code)) && str(cursor?.RESULT_CODE) !== 'F';
    const count = Number(cursor?.RESULT_CNT ?? 1);
    return { ok, count, message: str(cursor?.MSG) || str(res.data?.message) };
  };

  const execAction = async (row: PlanRow, col: ActionColumn) => {
    const { ok, count, message } = await callSaveProc({
      modelingId: str(row.MODELING_ID),
      divisionId: str(row.DIVISION_ID),
      planType: str(row.PLAN_TYPE),
      actvCd: ACTION_COLUMNS[col].actv,
      revisionNo: str(row.REVISION_NO),
    });
    if (!ok) {
      void setAlert({ type: 'alert', content: message || t(MSG.SAVE_FAIL, '_Failed to save.') });
      return;
    }
    // UI 공통 — CRUD 완료 알림은 하단 Toast(LGES WDG 표준)
    setToast({ type: 'success', message: t(MSG.SAVE_OK, '_{0} data saved.').replace('{0}', String(count)) });
    refreshMainFilters();
    if (filters[SHEETS.DETAIL_GRID]) void refetchDetail();
  };

  const handleAction = useCallback(
    (row: PlanRow, col: ActionColumn) => {
      // Modeling ID/Plan Type 공백 가드(설계서 Run 재검색 안내)
      if (!str(row.MODELING_ID) || !str(row.PLAN_TYPE)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.RUN_REQUIRED, '_There is no Modeling ID or Plan Type. Please re-search and try again.'),
        });
        return;
      }
      const { msg, fallback } = ACTION_CONFIRM[col];
      void setAlert({ type: 'confirm', content: t(msg, fallback), onConfirm: () => void execAction(row, col) });
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [t, filters]
  );

  // 상단 행 선택(클릭) → Detail(Engine) 조회(division+revision). 설계서 "상단 Grid Version 선택에 따른"
  const handleRowSelect = useCallback(
    (row: PlanRow) => {
      // Revision No 공백이면 하단 Detail(Engine) 조회하지 않고 기존 데이터도 초기화(사용자 2026-10-15)
      const revisionNo = str(row.REVISION_NO);
      if (!revisionNo) {
        setSelected(null);
        setDetailFilters(undefined);
        return;
      }
      const key = { divisionId: str(row.DIVISION_ID), revisionNo };
      setSelected({ ...key, modelingId: str(row.MODELING_ID), planStatus: str(row.PLAN_STATUS) });
      setDetailFilters(key);
    },
    [setDetailFilters, setSelected]
  );

  // REVISION_NO 변경 → 후보 매칭 로컬 파생 + Detail 재조회
  const handleRevisionChanged = useCallback(
    (row: PlanRow) => {
      const code = str(row.REVISION_NO);
      const candidate = revisionCandidates[str(row.PLAN_TYPE)]?.find(c => str(c.CODE) === code);
      if (candidate) {
        row.PLAN_STATUS_NAME = str(candidate.PLAN_STATUS_NAME);
        row.STATUS = str(candidate.PLAN_STATUS_NAME);
        row.PLAN_STATUS = str(candidate.PLAN_STATUS);
        row.MODELING_ID = str(candidate.MODELING_ID);
      }
      mainGridRef.current?.refresh(false);
      const key = { divisionId: str(row.DIVISION_ID), revisionNo: code };
      setSelected({ ...key, modelingId: str(row.MODELING_ID), planStatus: str(row.PLAN_STATUS) });
      setDetailFilters(key);
    },
    [revisionCandidates, setDetailFilters, setSelected]
  );

  // 표준 Insert/Delete/Save 비노출 — 조회만(설계서 버튼: 기본 기능 + 조회)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlanManagementForm
        onSearch={handleSearch}
        disabled={divisionAuthEmpty}
        onDivisionRows={setDivisionRows}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={planRows.length}
        excelFileName='Plan Management'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          <PlanManagementGrid
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            rows={planRows}
            staticColumns={staticColumns[SHEETS.MAIN_GRID]}
            candidates={revisionCandidates}
            onAction={handleAction}
            onRowSelect={handleRowSelect}
            onRevisionChanged={handleRevisionChanged}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={50} minSize={15}>
          <div className={styles.engineGrid}>
            <EngineRunGrid
              gridRef={detailGridRef}
              gridFilterRef={detailGridFilterRef}
              rows={engineRows}
              staticColumns={staticColumns[SHEETS.DETAIL_GRID]}
            />
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
