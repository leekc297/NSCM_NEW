import { CellType, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import { useQueryClient } from '@foundation/query-client';
import { useSaveWithValidation } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ACTION_COLUMN,
  ACTIVITY,
  LBL,
  MASTER_VALIDATION_MENU_ID,
  MENU_ID,
  MSG,
  MSG_FALLBACK,
  RESPONSE_SET,
  RUN_STATUS,
  SHEETS,
} from '../plan-control.constants';
import type { PlanControlRow } from '../plan-control.types';
import { usePlanControlStore } from '../usePlanControlStore';
import {
  isPreStepCompleted,
  resolveSaveMessage,
  resolveSavePlanId,
  str,
} from '../utils/planControl.activity';

interface Args {
  tabId: string;
  gridRef: MutableRefObject<FlexGrid<PlanControlRow> | undefined>;
  rows: PlanControlRow[];
  // 조회 시점에 확정된 planStartYyyymmdd(모드 분기 결과). 저장·단건재조회가 같은 값을 써야 한다.
  planStartYyyymmdd: string;
  // 툴바 Save 는 비노출이고(AS-IS NO-OP) SAVE 버튼권한은 CONFIRM 셀 실행의 대리 게이트다(R12·R25).
  hasSavePermission: boolean;
  // 조회/저장 중 상호작용 차단(X15, AS-IS CanModelChange=false).
  isBusy: boolean;
}

// AS-IS SpdMain_CellClick(cs:887~1184, 약 300줄) + CellDoubleClick + ComboSelChange.
//   Page 파일 ≤400줄 규약(hook #9)상 여기로 분리한다. buttonGuards B01~B41 + X19·X20 전건 구현.
export const usePlanControlCellActions = ({
  tabId,
  gridRef,
  rows,
  planStartYyyymmdd,
  hasSavePermission,
  isBusy,
}: Args) => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const findMenuPath = useSessionStore(state => state.findMenuPath);
  // 저장 payload 의 감사 사용자. 필수: `/call-proc`(execBtn) 는 세션을 주입하지 않는다 — 주입은
  //   `/call-proc2` 전용이다(GeneralController.java:83 `params.put("sesUserId", ...)`, callProc 는 58-60행에서
  //   mnuId/shtNm/mnuBtnCd 만 넣는다). FE 가 안 실으면 BaseService 가 P_USER_ID 를 NULL 로 바인딩하고
  //   SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M.CREATED_BY·LAST_UPDATED_BY(둘 다 NOT NULL 실측)에서 저장이 전건 실패한다.
  //   자매 SCP0122 plan-activity-mgmt(PlanActivityMgmt.tsx:40)와 동일 패턴.
  const sessionUserId = useSessionStore(state => state.session.userId);
  const { setAlert, setToast } = useMessageStore.getState();

  const searchParams = usePlanControlStore(state => state.searchParams);
  const masterValidation = usePlanControlStore(state => state.masterValidation);
  const setEngineRunContext = usePlanControlStore(state => state.setEngineRunContext);
  const staticColumns = usePlanControlStore(state => state.staticColumns[SHEETS.PLAN_CONTROL]);

  // 메타 기반 필수검증(INPUT_TP_CD=M/IM 또는 라벨 `*`). 이 화면은 현재 29컬럼 전건 'S' 라 대상이 0건이지만
  //   배선을 빼면 B1-d 로 'O'/'M' 이 들어올 때 검증이 사문화된다(SCP0020 실사고 — convert-core §2.4).
  const { saveWithValidation } = useSaveWithValidation();

  const savingRef = useRef(false);

  const alertMsg = useCallback(
    (msgId: string, fallback: string) => {
      void setAlert({ type: 'alert', content: t(msgId, fallback) });
    },
    [setAlert, t]
  );
  // confirm 은 Promise<boolean> — "No" 면 그 자리에서 중단한다(AS-IS DialogResult.No return).
  const confirmMsg = useCallback(
    (msgId: string, fallback: string) => setAlert({ type: 'confirm', content: t(msgId, fallback) }),
    [setAlert, t]
  );
  const alertSelectPlanId = useCallback(() => {
    // MSG01122 "Select {0}." — DB·번들 문구는 단일 중괄호 `{0}` 이고 i18next 기본 보간은 `{{ }}` 라
    //   options 로 넘기면 치환되지 않는다. 저장소 관례대로 .replace 로 치환한다(hook #114 축).
    const content = t(MSG.SELECT_REQUIRED, '_Select {0}.').replace(
      '{0}',
      t(LBL.PLAN_ID, '_Plan ID')
    );
    void setAlert({ type: 'alert', content });
  }, [setAlert, t]);

  // 타 화면 MDI 오픈(X17 GoPage) — AS-IS 선행 더미 조회(UP_FX_GetGSCMAuthenticationMenuList,
  //   "메뉴 숨김오픈 회피용 의미없는 조회")는 미이식한다. 권한 없는/미등록 메뉴면 무동작
  //   (AS-IS GoPage 도 빈 catch 로 조용히 넘어간다, cs:828).
  const openScreen = useCallback(
    (programId: string) => {
      const target = programId.trim();
      if (!target) return;
      if (!findMenuPath(target)) return;
      void navigate(`/view/${encodeURIComponent(target)}`);
    },
    [findMenuPath, navigate]
  );

  // 단건 상태 재조회 — 같은 GET SP 를 actvCd/planId 지정으로 호출하면 4컬럼만 돌아온다(design 03 §4.4).
  const fetchSingleStatus = useCallback(
    async (actvCd: string, planId: string): Promise<PlanControlRow | undefined> => {
      const res = await apiClient.callProc<MENU_ID, SHEETS.PLAN_CONTROL>(
        MENU_ID,
        SHEETS.PLAN_CONTROL,
        BUTTON_TYPE.SEARCH,
        {
          divisionId: searchParams.divisionId,
          planGroupId: searchParams.planGroupId,
          planStartYyyymmdd,
          actvCd,
          planId,
        }
      );
      if (res.code !== '0') return undefined;
      return res.result?.[RESPONSE_SET.PLAN_CONTROL]?.[0];
    },
    [planStartYyyymmdd, searchParams.divisionId, searchParams.planGroupId]
  );

  // 저장(SAVE SP IN 7) — prsCd 는 행 값, planGrId 는 조회조건이다. 출처를 섞으면 안 된다(design 03 §4.5).
  //   7번째 sesUserId 는 FE 가 직접 싣는다(위 sessionUserId 주석 — call-proc 세션 자동주입 없음).
  const saveActivity = useCallback(
    async (row: PlanControlRow): Promise<boolean> => {
      if (savingRef.current) return false;
      // 공용 필수검증을 먼저 통과해야 저장한다. 검증 실패 시 mutate 콜백이 호출되지 않으므로
      //   passed 가 false 로 남고 여기서 중단한다(saveWithValidation 은 동기 호출이다).
      let passed = false;
      saveWithValidation([row], staticColumns ?? [], () => {
        passed = true;
      });
      if (!passed) return false;

      savingRef.current = true;
      try {
        const payload = {
          divisionId: searchParams.divisionId,
          planStartYyyymmdd,
          prsCd: str(row.OPMZ_PRS_CD),
          planGrId: searchParams.planGroupId,
          actvCd: str(row.OPMZ_ACTV_CD),
          planId: resolveSavePlanId(row),
          // 키명은 SCM_ADM_PROC_M.COL_NM 실측값 그대로다(IN SORT_ORD 7 = sesUserId → P_USER_ID).
          //   다른 이름으로 보내면 BE 가 값을 못 찾아 조용히 NULL 바인딩한다.
          sesUserId: sessionUserId ?? '',
        };
        const res = await apiClient.post<unknown>(
          `/${MENU_ID}/${SHEETS.PLAN_CONTROL}/${BUTTON_TYPE.SAVE}/call-proc`,
          payload
        );
        const body = res.data as { code?: string | number; message?: string } | undefined;
        // false-success 판별 — 인터셉터가 500/403 도 resolve 한다(convert-core §2.4).
        if (res.status >= 400 || Number(body?.code)) {
          void setToast({
            type: 'error',
            message: str(body?.message) || t(MSG.SAVE_FAILED, '_Save failed.'),
          });
          return false;
        }
        // 성공 문구는 Activity 별로 갈리며, 해당 없는 Activity 는 AS-IS 도 문구가 없다(빈 문자열).
        const msgId = resolveSaveMessage(row);
        if (msgId) {
          void setToast({ type: 'success', message: t(msgId, MSG_FALLBACK[msgId] ?? '') });
        }
        // 저장 성공 후 planControl·engineRun 두 시트를 함께 갱신한다(R29 — AS-IS FindData_Main 끝에서
        //   InitSpread(siSub) 까지 수행). 한쪽만 갱신하면 하단 Status 가 낡은 값으로 남는다.
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        return true;
      } finally {
        savingRef.current = false;
      }
    },
    [
      planStartYyyymmdd,
      queryClient,
      saveWithValidation,
      searchParams.divisionId,
      searchParams.planGroupId,
      sessionUserId,
      setToast,
      staticColumns,
      t,
      tabId,
    ]
  );

  // CONFIRM 독립 실행 경로(indp_yn='Y') — B12~B22 + W-GEN default.
  const runIndependent = useCallback(
    async (row: PlanControlRow) => {
      const actvCd = str(row.OPMZ_ACTV_CD);
      const status = str(row.OPMZ_ACTV_RUN_STAT_CD);

      // B13 — 완료건 재실행을 조용히 차단한다(메시지 없음). A009 만 다회 실행을 허용한다.
      if (status === RUN_STATUS.COMPLETED && actvCd !== ACTIVITY.SEMI_CUTOFF) return;

      if (str(row.CONFIRM_YN) === 'Y') {
        // B15~B17 — A001(Master Validation)만 추가 선행 가드를 둔다.
        if (actvCd === ACTIVITY.MASTER_VALIDATION) {
          if (!masterValidation.isValidSearch) {
            alertMsg(MSG.MASTER_VALIDATION_REQUIRED, '_Please proceed with Master Validation.');
            return;
          }
          if (masterValidation.criticalCnt > 0) {
            alertMsg(
              MSG.MASTER_VALIDATION_CRITICAL,
              '_There are a number of Master Validation Critical violations.'
            );
            return;
          }
        }
        // B18 — A007·A008 도 CONFIRM_YN='Y' 라 이 경로를 그대로 탄다(W-GEN).
        if (!(await confirmMsg(MSG.CONFIRM_CONFIRM, '_Do you want to confirm?'))) return;
        await saveActivity(row);
        return;
      }

      // B19·B20 Release / B21·B22 Semi Cut-off — 그 외에는 확인창 없이 바로 저장한다(cs:1051-1054).
      //   임의로 확인창을 추가하지 않는다.
      if (actvCd === ACTIVITY.RELEASE) {
        if (!(await confirmMsg(MSG.CONFIRM_RELEASE, '_Do you want to release?'))) return;
      } else if (actvCd === ACTIVITY.SEMI_CUTOFF) {
        if (!(await confirmMsg(MSG.CONFIRM_RUN, '_Do you want to run?'))) return;
      }
      await saveActivity(row);
    },
    [alertMsg, confirmMsg, masterValidation, saveActivity]
  );

  // CONFIRM 비독립 실행 경로(indp_yn != 'Y') — X20 · B23~B38.
  const runDependent = useCallback(
    async (row: PlanControlRow) => {
      const actvCd = str(row.OPMZ_ACTV_CD);
      const status = str(row.OPMZ_ACTV_RUN_STAT_CD);
      const planId = str(row.OPMZ_PLAN_ID);

      // X20 — Plan ID 생성 팝업(plan_id=''). B3 결정에 따라 모달 본체는 이번 회차 범위 밖이라
      //   오픈 지점까지만 배선한다(04_react-gap.md 에 미구현 명시).
      if (actvCd === ACTIVITY.CREATE_PLAN_ID) return;

      if (actvCd === ACTIVITY.ENGINE_RUN) {
        // B24 — 이미 처리된 Plan ID(상태가 붙어 있으면 재요청 불가).
        if (
          status === RUN_STATUS.COMPLETED ||
          status === RUN_STATUS.WAITING ||
          status === RUN_STATUS.RUNNING ||
          status === RUN_STATUS.ERROR
        ) {
          alertMsg(MSG.PLAN_ID_ALREADY_PROCESSED, MSG_FALLBACK[MSG.PLAN_ID_ALREADY_PROCESSED]);
          return;
        }
        if (!planId) {
          alertSelectPlanId(); // B25
          return;
        }
        if (!(await confirmMsg(MSG.CONFIRM_RUN, '_Do you want to run?'))) return; // B26
        if (await saveActivity(row)) setEngineRunContext({ actvCd, planId });
        return;
      }

      if (actvCd === ACTIVITY.PLAN_OUT_REVIEW || actvCd === ACTIVITY.FP_TARGET_IF) {
        if (!planId) {
          alertSelectPlanId(); // B28 · B35
          return;
        }
        // B29·B36 — 선행 Engine Run(A003) 상태를 같은 GET SP 로 다시 확인한다.
        const preStep = await fetchSingleStatus(ACTIVITY.ENGINE_RUN, planId);
        if (preStep && str(preStep.OPMZ_ACTV_RUN_STAT_CD) !== RUN_STATUS.COMPLETED) {
          alertMsg(MSG.ENGINE_RUN_NOT_EXECUTED, MSG_FALLBACK[MSG.ENGINE_RUN_NOT_EXECUTED]); // B30 · B37
          return;
        }
        // B31·B32 — A004 만 자기 행이 이미 완료면 재실행 확인을 받는다.
        //   A005 는 같은 상황에서도 실행 확인(MSG01456)뿐이다(B38) — 임의 통일 금지.
        if (actvCd === ACTIVITY.PLAN_OUT_REVIEW && status === RUN_STATUS.COMPLETED) {
          if (!(await confirmMsg(MSG.CONFIRM_RERUN, '_This Plan ID has already been executed.')))
            return;
        } else if (!(await confirmMsg(MSG.CONFIRM_RUN, '_Do you want to run?'))) {
          return; // B33 · B38
        }
        await saveActivity(row);
        return;
      }

      // 비독립 default — 현재 lookup(OPMZ_ACTV_CD 9행) 기준으로 INDP_YN='N' 인 Activity 는
      //   A002~A005 뿐이라 여기 도달하지 않는다. AS-IS 도 대응 분기가 없어 무동작이므로 그대로 둔다.
    },
    [
      alertMsg,
      alertSelectPlanId,
      confirmMsg,
      fetchSingleStatus,
      saveActivity,
      setEngineRunContext,
    ]
  );

  const handleConfirmCell = useCallback(
    async (row: PlanControlRow) => {
      // R12·R25 — SAVE 버튼권한이 없으면(SCP Planner) 실행하지 않는다. 조회는 계속 가능하다.
      //   주의: 조용히 return 하면 안 된다. CONFIRM 셀 캡션은 권한과 무관하게 그려지므로
      //   (PlanControlGrid formatItem — ACTION_NAME 이 있으면 버튼체) 권한 없는 사용자에게는
      //   "버튼은 보이는데 눌러도 아무 일이 없는" 상태가 된다. 툴바 버튼은 공용 SubTitle 이
      //   false 일 때 렌더를 생략해 주지만 그리드 액션 셀에는 그 공용 보호가 없다.
      if (!hasSavePermission) {
        alertMsg(MSG.NO_SAVE_PERMISSION, '_You do not have permission.');
        return;
      }

      // B09·B10·B11 — 첫 Activity(seq='1')가 아니고 A004·A005 가 아니면 선행 Activity 완료를 확인한다.
      if (str(row.OPMZ_ACTV_SEQ) !== '1') {
        const actvCd = str(row.OPMZ_ACTV_CD);
        if (actvCd !== ACTIVITY.PLAN_OUT_REVIEW && actvCd !== ACTIVITY.FP_TARGET_IF) {
          if (!isPreStepCompleted(rows, actvCd)) {
            alertMsg(MSG.PRE_ACTIVITY_NOT_DONE, MSG_FALLBACK[MSG.PRE_ACTIVITY_NOT_DONE]);
            return;
          }
        }
      }

      // B12 — 독립/비독립 경로 분기. 이 축이 편집·색상·저장 파라미터를 모두 가른다.
      if (str(row.OPMZ_PLAN_ID_INDP_YN) === 'Y') await runIndependent(row);
      else await runDependent(row);
    },
    [alertMsg, hasSavePermission, rows, runDependent, runIndependent]
  );

  const handleLinkCell = useCallback(
    (row: PlanControlRow) => {
      const actvCd = str(row.OPMZ_ACTV_CD);
      const planId = str(row.OPMZ_PLAN_ID);

      // X19 — A001 은 SCP0039 Master Validation 을 연다. AS-IS 는 모달 반환값으로 criticalCnt/
      //   warningCnt 를 받아 isValidSearch 를 세웠으나, TO-BE SCP0039 는 모달이 아니라 독립 화면이라
      //   반환 계약이 없다(04_react-gap.md ERROR 기재). 여기서는 화면 오픈까지만 재현한다.
      if (actvCd === ACTIVITY.MASTER_VALIDATION) {
        openScreen(MASTER_VALIDATION_MENU_ID);
        return;
      }

      // B03·B04 — A002 Plan ID Info 조회 팝업. planId 가 비었거나 상태가 C 가 아니면 **조용히**
      //   무동작이다(메시지 금지). 팝업 본체는 B3 결정으로 이번 회차 범위 밖.
      if (actvCd === ACTIVITY.CREATE_PLAN_ID) return;

      // B05·B06 — A003 LINK 는 **선택 행 컨텍스트만 보관하고 하단 Status 를 조회**한다. 저장하지 않는다.
      //   AS-IS cs:949-962 는 `this.nSelRowSpdMain = e.Row`(선택된 셀 위치 = 행 인덱스 보관) 후
      //   FindData_Sub 만 호출하며 SaveData 호출부가 없다(SaveData 의 호출부는 cs:1035·1044·1051·1054·
      //   1095·1143·1180 전부 CONFIRM 버튼셀 경로). 설계 03 §3.4 B05 의 "선택행 저장" 서술은 그
      //   AS-IS 주석을 DB 저장으로 오독한 것이며, 저장을 끼우면 Status 링크 클릭만으로
      //   SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M INSERT + LTST_RUN_OPMZ_PLAN_ID 갱신이 일어난다(데이터 결함).
      //   Engine Run 실행은 CONFIRM 셀(B23~B26)만 담당한다 — 아래 더블클릭 경로와도 이제 동일하다.
      if (actvCd === ACTIVITY.ENGINE_RUN) {
        if (!planId) {
          alertSelectPlanId();
          return;
        }
        setEngineRunContext({ actvCd, planId });
        return;
      }

      // B07 — default. A007·A008 처럼 전용 분기가 없는 Activity 는 LINK_ADDRESS 화면으로 이동한다.
      //   actv_cd 화이트리스트로 좁히면 이 둘이 조용히 죽는다(W-GEN).
      openScreen(str(row.LINK_ADDRESS));
    },
    [alertSelectPlanId, openScreen, setEngineRunContext]
  );

  const rowAt = useCallback(
    (grid: FlexGrid<PlanControlRow>, rowIndex: number): PlanControlRow | undefined =>
      grid.rows[rowIndex]?.dataItem as PlanControlRow | undefined,
    []
  );

  // E05 CellClick — LINK / CONFIRM / OPMZ_PLAN_ID 3컬럼 분기. OPMZ_PLAN_ID 클릭 분기는 AS-IS 가
  //   전부 주석(cs:974-981)이라 TO-BE 도 무동작이다(편집은 콤보 셀 자체가 처리).
  const handleGridClick = useCallback(
    (mouseEvent: MouseEvent) => {
      const grid = gridRef.current;
      if (!grid || isBusy) return;
      // B01 — 빈 그리드면 전체 무동작.
      if (rows.length <= 0) return;
      const hit = grid.hitTest(mouseEvent);
      if (hit.cellType !== CellType.Cell || hit.row < 0) return;
      const row = rowAt(grid, hit.row);
      if (!row) return;
      const binding = grid.columns[hit.col]?.binding;
      if (binding === ACTION_COLUMN.LINK) handleLinkCell(row);
      else if (binding === ACTION_COLUMN.CONFIRM) void handleConfirmCell(row);
    },
    [gridRef, handleConfirmCell, handleLinkCell, isBusy, rowAt, rows.length]
  );

  // E06 CellDoubleClick — A003 행이면 Status 조회 + 폴링 시작, 그 외에는 선택행 초기화(AS-IS -1).
  //   초기화를 빠뜨리면 폴링이 엉뚱한 행을 갱신한다.
  const handleGridDoubleClick = useCallback(
    (mouseEvent: MouseEvent) => {
      const grid = gridRef.current;
      if (!grid || isBusy) return;
      if (rows.length <= 0) return; // B39
      const hit = grid.hitTest(mouseEvent);
      if (hit.cellType !== CellType.Cell || hit.row < 0) return;
      const row = rowAt(grid, hit.row);
      if (!row) return;
      // B40
      if (str(row.OPMZ_ACTV_CD) !== ACTIVITY.ENGINE_RUN) {
        setEngineRunContext(null);
        return;
      }
      const planId = str(row.OPMZ_PLAN_ID);
      if (!planId) {
        alertSelectPlanId(); // B41
        return;
      }
      setEngineRunContext({ actvCd: ACTIVITY.ENGINE_RUN, planId });
    },
    [alertSelectPlanId, gridRef, isBusy, rowAt, rows.length, setEngineRunContext]
  );

  // E07 ComboSelChange 등가 — Plan ID 셀 값이 바뀌면 그 **행의 값**으로 단건 재조회해 4컬럼을 갱신한다
  //   (G18~G21). 조회조건이 아니라 행 값을 쓴다 — 조회조건으로 바꾸면 Plan Group 이 다른 행에서 틀린다.
  //   폴링 경로(3컬럼)와 달리 STAT_NAME 까지 갱신한다.
  const handleCellEditEnded = useCallback(
    (grid: FlexGrid<PlanControlRow>, e: CellRangeEventArgs) => {
      if (grid.columns[e.col]?.binding !== ACTION_COLUMN.PLAN_ID) return;
      const row = rowAt(grid, e.row);
      if (!row) return;
      const planId = str(row.OPMZ_PLAN_ID);
      void (async () => {
        const res = await apiClient.callProc<MENU_ID, SHEETS.PLAN_CONTROL>(
          MENU_ID,
          SHEETS.PLAN_CONTROL,
          BUTTON_TYPE.SEARCH,
          {
            divisionId: str(row.DIVISION_ID),
            planGroupId: str(row.OPMZ_PLAN_GR_ID),
            planStartYyyymmdd: str(row.PLAN_START_YYYYMMDD),
            actvCd: str(row.OPMZ_ACTV_CD),
            planId,
          }
        );
        if (res.code !== '0') return;
        const status = res.result?.[RESPONSE_SET.PLAN_CONTROL]?.[0];
        // AS-IS cs:1303 은 `if (ds.Tables[0].Rows.Count > 0)` 가드 안에서만 SetValue 한다 — 0행이면
        //   기존 4컬럼 값을 그대로 유지한다. 가드가 없으면 조회 0행에서 화면 값이 공백으로 지워진다.
        if (!status) return;
        row.OPMZ_ACTV_RUN_STAT_CD = str(status.OPMZ_ACTV_RUN_STAT_CD);
        row.OPMZ_ACTV_RUN_STAT_NAME = str(status.OPMZ_ACTV_RUN_STAT_NAME);
        row.LAST_UPDATE_DATE = str(status.LAST_UPDATE_DATE);
        row.LAST_UPDATED_BY = str(status.LAST_UPDATED_BY);
        grid.collectionView?.refresh();
      })();
    },
    [rowAt]
  );

  return { handleGridClick, handleGridDoubleClick, handleCellEditEnded };
};
