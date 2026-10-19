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
import { EngineToolbar } from './components/EngineToolbar';
import { PlanManagementForm } from './components/PlanManagementForm';
import { PlanManagementGrid } from './components/PlanManagementGrid';
import {
  ACTION,
  ENGINE_POLL_MS,
  MENU_ID,
  MSG,
  REVISION_CANDIDATE_KEYS,
  RUN_REFRESH_MAX_TRIES,
  SHEETS,
} from './plan-management.constants';
import type { PlanRow, RevisionCandidateMap } from './plan-management.types';
import styles from './PlanManagement.module.scss';
import { usePlanManagementStore } from './usePlanManagementStore';
import {
  advanceProgress,
  shouldKeepPolling,
} from './utils/planManagementEngine';
import { hasRunningPlan, isStopEnabled } from './utils/planManagementLock';

const str = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

const sleep = (ms: number) => new Promise<void>(resolve => setTimeout(resolve, ms));

// AS-IS SCP0015_PlanManagement.cs(1655줄) — 설계: .atlas/gscm-design/SCP0015/design/00~03 (DB 실측).
//   상세 매핑: __asis-mapping__.md. 그리드 2개(planMgmt/engineRun) + 비가시 planConfirm 채널.
//   표준 Insert/Delete/Edit/Save 는 AS-IS NO-OP + DB 버튼 미등록 — 비노출 확정(사용자 2026-09-24).
//   RUN(EXECUTE) SP 는 P_RAISE_NOT_MIGRATED(엔진 미이관) — 서버 예외 메시지를 그대로 안내(0단계 확정).
export const PlanManagement = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const planGridRef = useRef<FlexGrid>();
  const planGridFilterRef = useRef<FlexGridFilter>();
  const engineGridRef = useRef<FlexGrid>();
  const engineGridFilterRef = useRef<FlexGridFilter>();

  const initialized = usePlanManagementStore(s => s.initialized);
  const searchParams = usePlanManagementStore(s => s.searchParams);
  const filters = usePlanManagementStore(s => s.filters);
  const weekCurrent = usePlanManagementStore(s => s.weekCurrent);
  const selected = usePlanManagementStore(s => s.selected);
  const staticColumns = usePlanManagementStore(s => s.staticColumns);
  const openSearchArea = usePlanManagementStore(s => s.openSearchArea);
  const setOpenSearchArea = usePlanManagementStore(s => s.setOpenSearchArea);
  const setPlanFilters = usePlanManagementStore(s => s.setPlanFilters);
  const refreshPlanFilters = usePlanManagementStore(s => s.refreshPlanFilters);
  const setEngineFilters = usePlanManagementStore(s => s.setEngineFilters);
  const setConfirmFilters = usePlanManagementStore(s => s.setConfirmFilters);
  const setSelected = usePlanManagementStore(s => s.setSelected);
  const clearFilters = usePlanManagementStore(s => s.clearFilters);
  const fetchStaticColumns = usePlanManagementStore(s => s.fetchStaticColumns);

  // 비동기 핸들러/effect 가 렌더 시점이 아닌 최신 상태를 읽도록 ref 미러(tab-scope 훅은 getState 미제공)
  const selectedRef = useRef(selected);
  selectedRef.current = selected;
  const engineFilterRef = useRef(filters[SHEETS.ENGINE_RUN]);
  engineFilterRef.current = filters[SHEETS.ENGINE_RUN];
  const confirmFilterRef = useRef(filters[SHEETS.PLAN_CONFIRM]);
  confirmFilterRef.current = filters[SHEETS.PLAN_CONFIRM];

  // Engine 진행바(STEP_PROCESS1~4) 클라 로컬 카운터 — 폴링마다 1칸씩(design 03 §3 R20~R22)
  const [progress, setProgress] = useState<ReadonlyMap<string, number>>(new Map());
  // 2초 폴링 on/off — 대상 PLAN 이 실행중(0)/종료중(-2)인 동안만(design 03 §4.4)
  const [pollingActive, setPollingActive] = useState(false);
  // Division 권한 0건 게이트(design 01 §2 행1) — Form 콤보 응답으로 판정, alert 는 1회만
  const [divisionRows, setDivisionRows] = useState<ComboResponse[] | undefined>(undefined);
  const authAlertShownRef = useRef(false);

  const { data: planData, refetch: refetchPlan } = useTabProcQuery<MENU_ID, SHEETS.PLAN_MGMT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_MGMT,
    tabId,
    filters: filters[SHEETS.PLAN_MGMT],
    enabled: !!filters[SHEETS.PLAN_MGMT],
  });

  const { data: engineData, refetch: refetchEngine } = useTabProcQuery<MENU_ID, SHEETS.ENGINE_RUN>({
    menuId: MENU_ID,
    sheetName: SHEETS.ENGINE_RUN,
    tabId,
    filters: filters[SHEETS.ENGINE_RUN],
    enabled: !!filters[SHEETS.ENGINE_RUN],
    // AS-IS timerStatus 2초 폴링(CheckEngineStatus L1586) — TanStack refetchInterval 재설계.
    //   기존 화면 선례 없는 신규 패턴(전역 grep refetchInterval 0건, 2026-09-24 확인).
    queryOptions: { refetchInterval: pollingActive ? ENGINE_POLL_MS : false },
  });

  const { data: confirmData } = useTabProcQuery<MENU_ID, SHEETS.PLAN_CONFIRM>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_CONFIRM,
    tabId,
    filters: filters[SHEETS.PLAN_CONFIRM],
    enabled: !!filters[SHEETS.PLAN_CONFIRM],
  });

  const planRows = useMemo(() => planData?.o_rc ?? [], [planData]);
  const engineRows = useMemo(() => engineData?.o_rc ?? [], [engineData]);

  // REVISION_NO 행별 콤보 후보 — 조회 응답에 7종 전량 동봉(design 03 §1.4, o_rc2~o_rc8)
  const revisionCandidates = useMemo<RevisionCandidateMap>(() => {
    const map: RevisionCandidateMap = {};
    for (const [planType, cursorKey] of Object.entries(REVISION_CANDIDATE_KEYS)) {
      map[planType] = planData?.[cursorKey as 'o_rc2'] ?? [];
    }
    return map;
  }, [planData]);

  const lockCtx = useMemo(
    () => ({ weekCurrent, anyRunning: hasRunningPlan(planRows) }),
    [weekCurrent, planRows]
  );

  // mount — keep-alive 잔존 filters 무효화(stale 자동 발사 방지) + admin 컬럼 메타 1회 조회
  useEffect(() => {
    clearFilters();
    setPollingActive(false);
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Division 권한 0건 — SearchArea disabled + MSG00097 alert 1회 / EngineToolbar disabled(무알림).
  //   두 영역의 알림 정책이 다름에 유의(AS-IS SetDivisionAuthCheck bFlag true/false, design 01 §2 행1)
  const divisionAuthEmpty = divisionRows !== undefined && divisionRows.length === 0;
  useEffect(() => {
    if (!divisionAuthEmpty || authAlertShownRef.current) return;
    authAlertShownRef.current = true;
    void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_AUTH, '_Please select Division.') });
  }, [divisionAuthEmpty, setAlert, t]);

  // Engine 폴링 응답 반영(design 03 §4.4) — 진행바 1칸 전진 + 대상 PLAN 상태를 spdPlan 행/선택
  //   컨텍스트에 동기화, 정상(1)/에러(-1) 종료 시 폴링 중지
  useEffect(() => {
    if (!engineData) return;
    setProgress(prev => advanceProgress(prev, engineData.o_rc ?? []));
    const statusRow = engineData.o_rc2?.[0];
    const status = str(statusRow?.PLAN_STATUS);
    setPollingActive(shouldKeepPolling(status));
    if (!statusRow) return;
    const sel = selectedRef.current;
    if (!sel) return;
    const target = planRows.find(
      r =>
        str(r.MODELING_ID) === sel.modelingId &&
        str(r.DIVISION_ID) === sel.divisionId &&
        str(r.REVISION_NO) === sel.revisionNo
    );
    if (target && str(target.PLAN_STATUS) !== status) {
      target.PLAN_STATUS = status;
      target.PLAN_STATUS_NAME = str(statusRow.PLAN_STATUS_NAME);
      planGridRef.current?.refresh(false);
    }
    if (sel.planStatus !== status) setSelected({ ...sel, planStatus: status });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [engineData]);

  // planConfirm 채널 응답 반영(design 03 §4.3 (2)) — CONFIRM_YN/USER/TIME 을 대상 행에 갱신
  useEffect(() => {
    const info = confirmData?.o_rc?.[0];
    const filter = confirmFilterRef.current;
    if (!info || !filter) return;
    const target = planRows.find(
      r =>
        str(r.MODELING_ID) === filter.modelingId &&
        str(r.DIVISION_ID) === filter.divisionId &&
        str(r.REVISION_NO) === filter.revisionNo
    );
    if (!target) return;
    target.CONFIRM_YN = str(info.CONFIRM_YN);
    target.CONFIRM_USER = str(info.CONFIRM_USER);
    target.CONFIRM_TIME = str(info.CONFIRM_TIME);
    planGridRef.current?.refresh(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [confirmData]);

  // 조회 — 필수값 가드(Division·PlanYear. PlanWeek 는 ConditionNotUseList 로 검사 제외 —
  //   AS-IS FindData_Plan L670 checkRequired early-return, Roslyn 미포착 가드라 누락 주의. design 01 §2 행2)
  const handleSearch = () => {
    if (divisionAuthEmpty) return;
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_AUTH, '_Please select Division.') });
      return;
    }
    if (!searchParams.planYear) return; // AS-IS 는 조회 무시(early-return)
    void fetchStaticColumns(); // CLAUDE.md §2 — 컬럼 메타는 mount + Search 마다 refetch
    setProgress(new Map());
    setPollingActive(false);
    setPlanFilters();
  };

  // 행 더블클릭 → Engine 재조회(AS-IS SpdPlan_CellDoubleClick → FindData_Engin)
  const handleRowDoubleClick = useCallback(
    (row: PlanRow) => {
      const key = {
        modelingId: str(row.MODELING_ID),
        divisionId: str(row.DIVISION_ID),
        revisionNo: str(row.REVISION_NO),
      };
      setSelected({ ...key, planStatus: str(row.PLAN_STATUS) });
      setProgress(new Map());
      setEngineFilters(key);
    },
    [setEngineFilters, setSelected]
  );

  // REVISION_NO 변경 연쇄 4단계(design 03 §4.3): (1) 후보 매칭 로컬 파생 (2) planConfirm 재조회
  //   (3) lock 재계산(행 데이터 파생 — formatItem 재도색) (4) engineRun 재조회
  const handleRevisionChanged = useCallback(
    (row: PlanRow) => {
      const code = str(row.REVISION_NO);
      const candidate = revisionCandidates[str(row.PLAN_TYPE)]?.find(c => str(c.CODE) === code);
      if (candidate) {
        row.PLAN_STATUS_NAME = str(candidate.PLAN_STATUS_NAME);
        row.PLAN_STATUS = str(candidate.PLAN_STATUS);
        row.MODELING_ID = str(candidate.MODELING_ID);
      }
      planGridRef.current?.refresh(false);
      const key = {
        modelingId: str(row.MODELING_ID),
        divisionId: str(row.DIVISION_ID),
        revisionNo: code,
      };
      setConfirmFilters(key);
      setSelected({ ...key, planStatus: str(row.PLAN_STATUS) });
      setProgress(new Map());
      setEngineFilters(key);
    },
    [revisionCandidates, setConfirmFilters, setEngineFilters, setSelected]
  );

  // 저장/실행 공통 — CONFIRM/STOP 은 공용 BUTTON_TYPE 에 없는 MNU_BTN_CD 라 apiClient.post 수동 경로.
  //   payload 는 PROC_M COL_NM 평면 최상위 키 그대로 전송(자매 SCP0009 buildSavePayload 컨벤션).
  //   금지: { data: [payload] } 래핑 — BaseService.makeProcedure 는 최상위 키만 name-lookup 하므로
  //   래핑하면 전 파라미터가 NULL 바인딩되어 0행 UPDATE + 성공 응답이 된다(iter-1 gap-audit G1).
  //   인터셉터가 500/403 도 resolve 하므로 res.status/res.data.code 로 직접 판별(nscm-patterns §5-10).
  //   성공/실패·건수는 O_RESULT_CURSOR 로 판정 — RESULT_CODE 'S'/'F' + RESULT_CNT(성공) / MSG(실패),
  //   PKG_SCP0015 본문 실측(L576-618/755-757/917-919/1074-1076). AS-IS Tables[0].Rows[0][0]=="S" 등가.
  //   RUN 의 P_RAISE_NOT_MIGRATED 예외도 SP 내부 catch 가 'F'+MSG 커서로 반환한다(HTTP 에러 아님).
  const callSaveProc = async (
    action: string,
    payload: Record<string, string>
  ): Promise<{ ok: boolean; count: number; message: string }> => {
    // 응답 키는 PROC_M COL_NM 표기 그대로다(BaseService 는 '@' 제거만 하고 케이스 보존) —
    //   SCM_ADM_PROC_M 실측: 저장 4종 OUT COL_NM='O_RESULT_CURSOR'(대문자). 소문자로 읽으면
    //   상시 undefined 가 되어 'F' 검출·RESULT_CNT 가 전부 무력화된다(iter-2 gap-audit G5).
    const res = await apiClient.post<{
      O_RESULT_CURSOR?: { RESULT_CODE?: string; RESULT_CNT?: number | string; MSG?: string }[];
    }>(`/${MENU_ID}/${SHEETS.PLAN_MGMT}/${action}/call-proc`, payload);
    const cursor = res.data?.result?.O_RESULT_CURSOR?.[0];
    const ok =
      !(res.status >= 400 || Number(res.data?.code)) && str(cursor?.RESULT_CODE) !== 'F';
    const count = Number(cursor?.RESULT_CNT ?? 1);
    return { ok, count, message: str(cursor?.MSG) || str(res.data?.message) };
  };

  const notifySaveResult = (ok: boolean, count: number, message: string) => {
    if (ok) {
      // UI 공통(통합테스트) UC-04 — CRUD 완료 알림은 Alert 아닌 하단 Toast(LGES WDG 표준).
      setToast({
        type: 'success',
        message: t(MSG.SAVE_OK, '_{0} data saved.').replace('{0}', String(count)),
      });
    } else {
      // 실패는 사용자 확인이 필요하므로 alert 유지(커서 MSG 우선).
      void setAlert({ type: 'alert', content: message || t(MSG.SAVE_FAIL, '_Failed to save.') });
    }
  };

  // Stop(btnStop) — confirm(MSG01458) → P_SCP0015_SAVE_PLAN_MST_STOP → 성공/실패 alert 후 재조회
  //   (AS-IS BtnStop_Click L438 + SaveData_PlanStop L1180, design 01 §2 행5~6)
  const execStop = async () => {
    const sel = selectedRef.current;
    if (!sel) return;
    const { ok, count, message } = await callSaveProc(ACTION.STOP, {
      modelingId: sel.modelingId,
      divisionId: sel.divisionId,
      revisionNo: sel.revisionNo,
    });
    notifySaveResult(ok, count, message);
    if (!ok) return;
    refreshPlanFilters();
    if (engineFilterRef.current) void refetchEngine();
  };
  const handleStop = () => {
    if (!selected || !isStopEnabled(selected.planStatus)) return;
    void setAlert({
      type: 'confirm',
      content: t(MSG.STOP_CONFIRM, '_The Plan will be terminated of the Error Status. Do you want to run?'),
      onConfirm: () => void execStop(),
    });
  };

  // RUN(EXECUTE 버튼셀) — 가드(MSG01460) → confirm(MSG01456) → P_SCP0015_SAVE_PLAN_MST_RUN.
  //   현재 TO-BE SP 본문이 P_RAISE_NOT_MIGRATED(PR_SCP_ENG_CONTROL 미이관, design 03 §6 #1) —
  //   실패 시 서버 예외 메시지를 그대로 alert(미구현 안내, 0단계 사용자 확정). convert-sp 후속.
  const execRun = async (row: PlanRow) => {
    const modelingId = str(row.MODELING_ID);
    const planType = str(row.PLAN_TYPE);
    const prevRevision = str(row.REVISION_NO);
    const key = { modelingId, divisionId: str(row.DIVISION_ID), revisionNo: prevRevision };
    const { ok, message } = await callSaveProc(ACTION.EXECUTE, { modelingId, planType });
    if (!ok) {
      void setAlert({ type: 'alert', content: message || t(MSG.SAVE_FAIL, '_Failed to save.') });
      return;
    }
    // 성공 시 Engine 조회 + 새 REVISION 생성 대기 재조회 — AS-IS CallEnginRun 의 UI 블로킹
    //   Thread.Sleep 폴링(최대 10회)을 비동기 반복으로 재설계(design 03 §4.5). filters 불변
    //   재조회라 refetch 직접 호출 허용(저장 성공 후 예외 — nscm-patterns §5-1).
    setSelected({ ...key, planStatus: str(row.PLAN_STATUS) });
    setProgress(new Map());
    setEngineFilters(key);
    for (let attempt = 0; attempt < RUN_REFRESH_MAX_TRIES; attempt++) {
      await sleep(ENGINE_POLL_MS);
      const refreshed = await refetchPlan();
      const target = (refreshed.data?.o_rc ?? []).find(
        r => str(r.MODELING_ID) === modelingId && str(r.PLAN_TYPE) === planType
      );
      if (target && str(target.REVISION_NO) !== prevRevision) {
        // 새 REVISION 감지 — 선택/Engine 컨텍스트를 새 revision 으로 전환해 폴링·진행바가 새 실행을
        //   추적(AS-IS CallEnginRun L494-519: 새 revision 확인 후 FindData_Engin 재조회 등가.
        //   이전 revision 은 PLAN_STATUS 1/-1 이라 폴링이 즉시 끝난다 — iter-1 gap-audit G3)
        const newKey = {
          modelingId: str(target.MODELING_ID),
          divisionId: str(target.DIVISION_ID),
          revisionNo: str(target.REVISION_NO),
        };
        setSelected({ ...newKey, planStatus: str(target.PLAN_STATUS) });
        setProgress(new Map());
        setEngineFilters(newKey);
        break;
      }
    }
  };
  const handleRun = useCallback(
    (row: PlanRow) => {
      // validations #2(MSG00205→MSG01460) — Modeling ID/Plan Type 공백 가드(guardsReturn=true)
      if (!str(row.MODELING_ID) || !str(row.PLAN_TYPE)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.RUN_REQUIRED, '_There is no Modeling ID or Plan Type. Please re-search and try again.'),
        });
        return;
      }
      void setAlert({
        type: 'confirm',
        content: t(MSG.RUN_CONFIRM, '_Do you want to run?'),
        onConfirm: () => void execRun(row),
      });
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [t]
  );

  // CONFIRM 버튼셀 — confirm(MSG01457) → P_SCP0015_SAVE_PLAN_MST_COMFIRM → 성공 시 CONFIRM
  //   정보 재조회(planConfirm 채널 — AS-IS 는 SP 재반환값 SetText, 동일 3컬럼. R18).
  //   주의: 외부 인터페이스 연동(PR_SCP_PLN_INTERFACE_PLAN)은 미이관 — DB 갱신만 된다(design 03 §4.6).
  const execConfirm = async (row: PlanRow) => {
    const key = {
      modelingId: str(row.MODELING_ID),
      divisionId: str(row.DIVISION_ID),
      revisionNo: str(row.REVISION_NO),
    };
    const { ok, count, message } = await callSaveProc(ACTION.CONFIRM, key);
    notifySaveResult(ok, count, message);
    if (ok) setConfirmFilters(key);
  };
  const handleConfirmAction = useCallback(
    (row: PlanRow) => {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_CONFIRM, '_Do you want to confirm?'),
        onConfirm: () => void execConfirm(row),
      });
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [t]
  );

  // 표준 Insert/Delete/Save — AS-IS NO-OP(주석 처리 본문) + DB 버튼 미등록. 비노출(false) 확정
  //   (사용자 2026-09-24, plan.md 0단계 — hasButton DB 게이트와 일관). 근거: __asis-mapping__.md §4
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  const stopEnabled = !divisionAuthEmpty && isStopEnabled(selected?.planStatus);

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
        grid={planGridRef}
        gridFilter={planGridFilterRef}
        dataCount={planRows.length}
        excelFileName='Plan Management'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* AS-IS splitContainer1(상단 spdPlan 334px)/splitContainer2(툴바 51px + spdEngin) —
          상하 드래그 분할. 초기 비율은 334px/전체높이 근사(45:55). design 01 §1 */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={45} minSize={20}>
          <PlanManagementGrid
            gridRef={planGridRef}
            gridFilterRef={planGridFilterRef}
            rows={planRows}
            staticColumns={staticColumns[SHEETS.PLAN_MGMT]}
            candidates={revisionCandidates}
            lockCtx={lockCtx}
            onRunClick={handleRun}
            onConfirmClick={handleConfirmAction}
            onRowDoubleClick={handleRowDoubleClick}
            onRevisionChanged={handleRevisionChanged}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={55} minSize={15}>
          <div className={styles.engineSection}>
            <EngineToolbar
              revisionNo={selected?.revisionNo ?? ''}
              stopEnabled={stopEnabled}
              disabled={divisionAuthEmpty}
              onStop={handleStop}
            />
            <div className={styles.engineGrid}>
              <EngineRunGrid
                gridRef={engineGridRef}
                gridFilterRef={engineGridFilterRef}
                rows={engineRows}
                staticColumns={staticColumns[SHEETS.ENGINE_RUN]}
                progress={progress}
              />
            </div>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
