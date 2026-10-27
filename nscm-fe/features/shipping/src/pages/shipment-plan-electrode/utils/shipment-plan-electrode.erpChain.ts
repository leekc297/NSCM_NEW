// SSP0023 하단 Plan Detail 저장 — 확정(CONFIRM) 전 ERP 송신 연쇄.
//   AS-IS SSP0023_ShipmentPlanElectrode.cs(Forms.UIL) SaveData_Detail(cs:2512~2757) → chkERPIFBlockYn(cs:2515, 2764~2787)
//   → GetERPInterface(cs:3122~3353) → NonSoNo/SoNo(cs:3742~4176) → GetErpIFCheckNew(cs:4293~4405).
//   TO-BE 선례: SSP0015 ShipmentPlanMobilityIt.tsx sendErpAndCompensate, SSP0060 utils/shipment-plan.erpChain.ts(deps 주입).
//   화면 컴포넌트 클로저에 두면 분기 테스트가 안 돼 deps 주입 모듈로 뺐다(정적 검토 R10, 2026-10-27).
//
// 실패 처리 규칙
//   - HTTP 403 = 버튼 라우팅·권한 메타 미등록(DB 의뢰 01 SQL 미적용). MSG01125(사용 권한이 없습니다) + 호출 경로로
//     알린다 — 일반 저장 실패(MSG00003)와 구분한다. ERP 송신 전 단계의 403 은 연쇄를 멈춘다.
//   - CONFIRM 대상은 "성공 묶음 행 + 묶음에 안 들어간 행(I·P)" 뿐이다. 초안 실패('X'·비'S'·요청번호 없음·예외),
//     ERP 전건 거절(E), F·C_E 묶음의 행은 전부 빼고, 일부 거절(S_E)은 거절된 CONFIRM_ID 행만 뺀다
//     (정적 검토 R3 결정 — SSP0021 excludedRows 와 같은 처리. AS-IS 는 거절 ID 만 뺐다 cs:2593~2605).
import type { ComboParam, ComboResponse } from '@foundation/models';

import {
  ADMIN_SHEET_NAME,
  DRAFTING_BTN,
  DRAFTING_SHEET,
  ERP_BLOCK_COMBO,
  ERP_CHAIN_BTN,
  ERP_DELETE_FLAG,
  ERP_ERROR_E_TYPE,
  ERP_IF_CHANGE_TYPE,
  ERP_IF_ERROR,
  ERP_IF_PARTIAL_ERROR,
  ERP_IF_PATH,
  ERP_IF_PI_FAIL,
  ERP_IF_SEND_ON,
  ERP_IF_SUCCESS,
  IF_CHECK_PARTIAL_OFF,
  IF_CHECK_STATUS_APPLY,
  MENU_ID,
  MSG,
  MSG_ERP,
  PROGRAM_ID,
  SHEETS,
} from '../shipment-plan-electrode.constants';

import {
  buildDraftingGroups,
  collectChangeTimeIds,
  collectDraftingPayload,
  collectSoCountChecks,
  collectStatusCheckKeys,
  firstResultCode,
  hasZeroQtyPoToDelete,
  parseErpErrors,
  readCursor,
} from './shipment-plan-electrode.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const uniqStr = (values: string[]): string[] =>
  Array.from(new Set(values.filter(v => v !== '' && v !== '-')));
const idOf = (r: Row): string => str(r.CONFIRM_ID).trim();

type Row = Record<string, unknown>;

export interface ProcResponse {
  status: number;
  data?: unknown;
}

export interface ErpChainDeps {
  post: (url: string, body: unknown) => Promise<ProcResponse>;
  getCombo: (params: ComboParam) => Promise<ComboResponse[]>;
  t: (key: string, fallback: string) => string;
  /** 닫힐 때 resolve 되는 알림(순차 표시). */
  alert: (content: string) => Promise<unknown>;
  /** 예/아니오. 예=true. */
  confirm: (content: string) => Promise<boolean>;
  /** 기준정보 매뉴얼 열기(AS-IS AddHelpButton "Standard Information SSP Manual"). */
  openManual: () => void;
  /** 사용자 버튼 권한(useTabBtnPermissions.hasButton) — 송신 전 사전 확인용. */
  hasButton: (btn: string) => boolean;
  userId: string;
  timeZone: string;
}

export interface ErpChainInput {
  /** 변경행(EDIT_MAIN='Y' 또는 CRUD_TYPE 있음). */
  dirty: Row[];
  /** 하단 그리드 전체 행(SO 건수 비교용). */
  allRows: Row[];
}

/** null = 확정하지 않는다. 그 외 = confirmRows 로 확정한다(비어 있으면 호출부가 확정 호출 없이 끝낸다). */
export type ErpChainResult = { confirmRows: Row[] } | null;

const procUrl = (sheet: string, btn: string): string => `/${MENU_ID}/${sheet}/${btn}/call-proc`;
const resultOf = (res: ProcResponse): unknown =>
  (res.data as { result?: unknown } | undefined)?.result;
const isHttpFailed = (res: ProcResponse): boolean =>
  res.status >= 400 || !!Number((res.data as { code?: unknown } | undefined)?.code);

export const runErpChain = async (
  deps: ErpChainDeps,
  input: ErpChainInput
): Promise<ErpChainResult> => {
  const { dirty, allRows } = input;
  const say = (code: string, fallback: string, arg0?: string): string => {
    const raw = deps.t(code, fallback);
    return arg0 === undefined ? raw : raw.replace('{0}', arg0);
  };
  const alertNoRoute = (sheet: string, btn: string) =>
    deps.alert(
      `${say(MSG.NO_BUTTON_AUTH, '_You do not have permission.')}\n[${MENU_ID}/${sheet}/${btn}]`
    );
  const alertSaveFailed = (content?: string) =>
    deps.alert(content || say(MSG.SAVE_FAILED, '__Save failed.'));

  /** 송신 전 조회 단계 1회. 403·HTTP 실패·예외면 안내 후 null. */
  const precheck = async (btn: string, body: Record<string, unknown>): Promise<unknown> => {
    let res: ProcResponse;
    try {
      res = await deps.post(procUrl(SHEETS.MAIN, btn), body);
    } catch {
      await alertSaveFailed();
      return null;
    }
    if (res.status === 403) {
      await alertNoRoute(SHEETS.MAIN, btn);
      return null;
    }
    if (isHttpFailed(res)) {
      await alertSaveFailed();
      return null;
    }
    return resultOf(res) ?? {};
  };

  // ERP 실시간 송신 — AS-IS FN_ERP_UIWebService(RequestNo, "C", "")(cs:4301). 호출 실패는 CallClient catch 처럼 C_E.
  const sendErp = async (reqNo: string): Promise<{ eType: string; eMessage: string }> => {
    try {
      const erp = await deps.post(ERP_IF_PATH, {
        CHANGE_REQ_NO: reqNo,
        CHANGE_TYPE: ERP_IF_CHANGE_TYPE,
        SHIPMENT_STATUS: '',
      });
      if (isHttpFailed(erp)) return { eType: ERP_IF_PI_FAIL, eMessage: '' };
      const r = resultOf(erp) as { E_TYPE?: unknown; E_MESSAGE?: unknown } | null | undefined;
      return { eType: str(r?.E_TYPE), eMessage: str(r?.E_MESSAGE) };
    } catch {
      return { eType: ERP_IF_PI_FAIL, eMessage: '' };
    }
  };

  // 보상 호출 결과 — 정적 검토 R8: 응답 상태를 본다. 403 은 경로 안내, 그 밖의 실패는 요청번호로 MSG01215.
  //   forbiddenPaths 는 `sheet/btn` 을 모아 연쇄 끝에 경로별 1회만 안내한다(2차 검토 N6 — 묶음마다 반복 안내 방지).
  const forbiddenPaths = new Set<string>();
  const systemErrorReqNos = new Set<string>();
  const callCompensation = async (
    btn: string,
    body: Record<string, unknown>,
    reqNos: string[]
  ): Promise<void> => {
    try {
      const res = await deps.post(procUrl(SHEETS.MAIN, btn), body);
      if (res.status === 403) {
        forbiddenPaths.add(`${SHEETS.MAIN}/${btn}`);
        return;
      }
      if (isHttpFailed(res)) reqNos.forEach(n => systemErrorReqNos.add(n));
    } catch {
      reqNos.forEach(n => systemErrorReqNos.add(n));
    }
  };

  // 초안 되돌림 — AS-IS SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(cs:4329~4337, cs:3319~3327).
  //   보상 키는 userId(PROC 메타 COL_NM, 결함 D-1 — lastUpdatedBy 는 NULL 바인딩).
  const compensate = async (reqNo: string, confirmIds: string[]): Promise<void> => {
    if (confirmIds.length === 0) return;
    await callCompensation(
      ERP_CHAIN_BTN.DELETE_DRAFTING_BY_CONFIRM,
      {
        confirmId: confirmIds.join('^'),
        changeRequestNo: reqNo,
        delFlag: ERP_DELETE_FLAG,
        userId: deps.userId,
        timeZone: deps.timeZone,
        ifSendFlag: ERP_IF_SEND_ON,
        changeType: ERP_IF_CHANGE_TYPE,
      },
      [reqNo]
    );
  };

  // 2차 적재 + 2차 송신 — AS-IS CHG_BATCH('B', REQ_NO) + FN_ERP 재호출(cs:4352~4365 S_E, cs:4382~4395 S).
  //   PKG_SSP0003.P_SSP0003_SAVE_REQ_IF_CHECK(changeStatus 'A' + changeType 'C' → V_STATUS 'B')를 main/IF_CHECK 로
  //   빌린다(SSP0015 선례). 403 은 'forbidden'(호출부가 보상·중단). 그 밖의 실패·예외는 'failed' — 세 화면 공통
  //   정책(2차 검토 N2): 2차 송신만 건너뛰고 확정은 진행하되, 요청번호를 모아 연쇄 끝에 MSG01215 로 알린다
  //   (AS-IS 는 CHG_BATCH 결과를 보지 않는다 cs:4355~4365. XIF 'B' 미적재분은 사용자가 요청번호로 확인한다).
  const stageAndResend = async (reqNo: string): Promise<'ok' | 'failed' | 'forbidden'> => {
    try {
      const res = await deps.post(procUrl(SHEETS.MAIN, ERP_CHAIN_BTN.IF_CHECK), {
        changeRequestNo: reqNo,
        changeStatus: IF_CHECK_STATUS_APPLY,
        timeZone: deps.timeZone,
        changeType: ERP_IF_CHANGE_TYPE,
        partialApproval: IF_CHECK_PARTIAL_OFF,
      });
      if (res.status === 403) return 'forbidden';
      if (isHttpFailed(res)) return 'failed';
    } catch {
      return 'failed';
    }
    await sendErp(reqNo);
    return 'ok';
  };

  // ── ⓪ ERP 중단기간 — AS-IS chkERPIFBlockYn(cs:2515, 2764~2787) Data_SCP.Common(SSPBlockCheckIF, "SSP0023").
  //   BLOCK_YN='Y' 면 MSG00267(→MSG01275, {0}=PERIOD) 후 중단. 0행이면 AS-IS 도 통과. 조회 실패는 판정 근거가 없어
  //   통과시킨다(SSP0060 checkErpBlock·SSP0200 passErpBlockGate 와 같은 판단 — 차단하면 저장이 영구 불가).
  try {
    const first = (await deps.getCombo({ comboId: ERP_BLOCK_COMBO, segment1: MENU_ID }))?.[0];
    if (first && str(first.BLOCK_YN ?? first.CODE) === 'Y') {
      await deps.alert(
        say(
          MSG.ERP_BLOCK_PERIOD,
          '__The SSP shipment change request cannot be used during the ERP system downtime below. {0}',
          str(first.PERIOD ?? first.NAME)
        )
      );
      return null;
    }
  } catch {
    /* 통과 */
  }

  const statusKeys = collectStatusCheckKeys(dirty);
  const soChecks = collectSoCountChecks(dirty, allRows);
  const changeTimeIds = collectChangeTimeIds(dirty);
  const groups = buildDraftingGroups(dirty);

  // 사전 권한 확인 — 부를 단계의 버튼이 사용자 권한 목록에 없으면 ERP 에 아무것도 보내기 전에 멈춘다.
  //   송신 뒤 403 이면 초안·송신이 반쯤 남기 때문이다(보상 2종·IF_CHECK 까지 미리 본다).
  //   DRAFTING(requestDraftingMain/SAVE)은 BTN_CD 가 planDetail/SAVE 와 같은 'SAVE' 라 hasButton 으로 구분이 안 된다
  //   — 첫 묶음(송신 전) 런타임 403 으로 잡는다(정적 검토 #18).
  const needed: string[] = [];
  if (statusKeys) needed.push(ERP_CHAIN_BTN.GET_SHIPMENT_STATUS);
  if (soChecks.length > 0) needed.push(ERP_CHAIN_BTN.GET_ERP_SO_NO_CNT);
  if (changeTimeIds) needed.push(ERP_CHAIN_BTN.CHECK_CONFIRM_CHANGETIME);
  if (groups.length > 0) {
    needed.push(
      ERP_CHAIN_BTN.IF_CHECK,
      ERP_CHAIN_BTN.DELETE_DRAFTING_BY_CONFIRM,
      ERP_CHAIN_BTN.ERP_ERROR_CONFIRM
    );
  }
  const missing = needed.find(btn => !deps.hasButton(btn));
  if (missing) {
    await alertNoRoute(SHEETS.MAIN, missing);
    return null;
  }

  // ── ① 상태 재검증 — AS-IS GetShipmentStatusChk(cs:3451~3514). 커서 3개 중 하나라도 있으면 중단.
  if (statusKeys) {
    const result = await precheck(ERP_CHAIN_BTN.GET_SHIPMENT_STATUS, statusKeys);
    if (result === null) return null;
    const statusMsgs: [number, string, string][] = [
      [1, MSG.STATUS_OTHER_USER_REQUEST, '__A Confirm ID for which another user requested a shipment plan change exists. {0}'],
      [2, MSG.STATUS_DELETED_QTY0, '__A deleted (Qty:0) Confirm ID exists. {0}'],
      [3, MSG.STATUS_ERP_DO_CREATED, '__In ERP, a DO has been created and the change cannot be requested. {0}'],
    ];
    for (const [n, msgId, fallback] of statusMsgs) {
      const ids = uniqStr(readCursor(result, n).map(idOf)).join(',');
      if (ids) {
        await deps.alert(say(msgId, fallback, ids));
        return null;
      }
    }
  }

  // ── ② SO 건수 — AS-IS GetErpSoNoCnt(cs:3516~3539) vs 화면 같은 SO 행수(cs:3154). 다르면 MSG00247.
  for (const chk of soChecks) {
    const result = await precheck(ERP_CHAIN_BTN.GET_ERP_SO_NO_CNT, {
      divisionId: chk.divisionId,
      erpSoNo: chk.erpSoNo,
    });
    if (result === null) return null;
    const dbCnt = Number(readCursor(result, 1)[0]?.CNT ?? 0);
    if (dbCnt !== chk.sheetCount) {
      await deps.alert(
        say(
          MSG.SO_NO_COUNT_MISMATCH,
          '__Another item created with the same SO number exists. [ SO NO : {0} ]',
          chk.erpSoNo
        )
      );
      return null;
    }
  }

  // ── ③ Confirm Qty 0 PO 삭제 확인 — AS-IS cs:3186~3189(MSG00325, No 면 중단). 상태·SO 검사 뒤, 2분 잠금 앞.
  if (hasZeroQtyPoToDelete(dirty)) {
    const ok = await deps.confirm(
      say(MSG.QTY_ZERO_PO_DELETE, '_A PO with Confirm Qty of 0 will be deleted. Proceed?')
    );
    if (!ok) return null;
  }

  // ── ④ 2분 잠금 — AS-IS ChkConfirmChangeTime(cs:6774~6797) 'S' 만 통과, 그 외 MSG00404(→MSG01395).
  if (changeTimeIds) {
    const result = await precheck(ERP_CHAIN_BTN.CHECK_CONFIRM_CHANGETIME, { confirmId: changeTimeIds });
    if (result === null) return null;
    if (firstResultCode(result) !== 'S') {
      await deps.alert(
        say(
          MSG.CONFIRM_CHANGETIME_LOCK,
          '__Due to ERP I/F, changes can be made after 2 minutes of previous work.'
        )
      );
      return null;
    }
  }

  // ── ⑤ 묶음별 초안 → ERP 송신 → 결과 처리. AS-IS 는 한 묶음이 실패해도 다음 묶음을 계속 돈다(cs:3202~3243).
  const errs: { confirmId: string; message: string; reqNo: string }[] = [];
  const fce: { reqNo: string; confirmIds: string[] }[] = [];
  const excludedRows = new Set<Row>(); // 확정에서 뺄 행(실패 묶음 전체 + S_E 거절 행)
  let anyActive = false; // AS-IS bActiveList 에 true 가 하나라도 있으면 진행(cs:3246~3255)
  let sentAny = false; // ERP 로 한 번이라도 보냈는가 — 송신 전 403 만 연쇄 전체를 멈춘다
  // 송신 뒤 403(DRAFTING·IF_CHECK) — 같은 라우트라 뒤 묶음도 막힌다. 이후 묶음은 처리하지 않고 확정에서도 뺀다
  //   (2차 검토 N3·SSP0060 N1 회귀 패턴 — 초안·송신을 안 탄 묶음 행이 확정되면 안 된다).
  let halted = false;
  for (const group of groups) {
    const excludeGroup = () => group.rows.forEach(r => excludedRows.add(r));
    if (halted) {
      excludeGroup();
      continue;
    }
    const draftPayload = collectDraftingPayload(group.rows, {
      userId: deps.userId,
      userDeptId: '', // AS-IS Dept_ID(cs:3768). TO-BE 세션에 부서 필드가 없다(SSP0015 와 같은 잔여)
      title: ADMIN_SHEET_NAME[SHEETS.PLAN_DETAIL] ?? '',
      programId: PROGRAM_ID,
    });
    if (!draftPayload) continue;
    let resDraft: ProcResponse;
    try {
      resDraft = await deps.post(procUrl(DRAFTING_SHEET, DRAFTING_BTN), draftPayload);
    } catch {
      excludeGroup();
      await alertSaveFailed();
      continue;
    }
    if (resDraft.status === 403) {
      // 아직 송신 전이면 바로 안내하고 연쇄를 멈춘다. 송신 뒤면 이 묶음과 남은 묶음을 빼고 끝에서 1회 안내한다.
      if (!sentAny) {
        await alertNoRoute(DRAFTING_SHEET, DRAFTING_BTN);
        return null;
      }
      forbiddenPaths.add(`${DRAFTING_SHEET}/${DRAFTING_BTN}`);
      excludeGroup();
      halted = true;
      continue;
    }
    const draftHttpOk = !isHttpFailed(resDraft);
    const draftResult = resultOf(resDraft);
    const draftRow = readCursor(draftResult, 1)[0];
    const draftCode = draftHttpOk ? firstResultCode(draftResult) : '';
    const reqNo = str(draftRow?.REQUEST_NO);
    if (draftCode === 'X') {
      // AS-IS cs:3910~3922 / 4144~4156 — MSG00324(예 → 기준정보 매뉴얼). TO-BE 는 확정 'X' 와 같은 MSG01321.
      excludeGroup();
      const open = await deps.confirm(
        say(MSG.STD_INFO_NOT_REGISTERED, '_기준정보가 등록되어 있지 않습니다. 참고자료를 열람하시겠습니까?')
      );
      if (open) deps.openManual();
      continue;
    }
    if (draftCode !== 'S' || !reqNo) {
      // AS-IS cs:3923~3939 MSG00284(보안 조치로 일반 문구) / cs:3903~3907 요청번호 없음(무안내).
      //   TO-BE 는 SP 오류 문구가 있으면 보이고 없으면 저장 실패로 알린다.
      excludeGroup();
      const errMsg = draftHttpOk
        ? str(draftRow?.ERR_MESSAGE) || str(readCursor(draftResult, 2)[0]?.ERR_MESSAGE)
        : '';
      await alertSaveFailed(errMsg);
      continue;
    }

    const groupIds = uniqStr(group.rows.map(idOf));
    sentAny = true;
    // 2차 적재 결과 처리 — 403 이면 이미 'C' 를 받은 ERP 를 되돌려야 하므로 F 와 같이 보상(초안 되돌림 + 삭제 반영
    //   재송신, 아래 ⑥)하고 이 묶음을 빼며 남은 묶음은 처리하지 않는다(2차 검토 N3). 비403 실패는 기록 후 진행(N2).
    //   반환: 이 묶음을 확정 대상으로 남겨도 되는가.
    const afterStage = async (remainIds: string[]): Promise<boolean> => {
      const stage = await stageAndResend(reqNo);
      if (stage === 'forbidden') {
        forbiddenPaths.add(`${SHEETS.MAIN}/${ERP_CHAIN_BTN.IF_CHECK}`);
        excludeGroup();
        fce.push({ reqNo, confirmIds: remainIds });
        halted = true;
        return false;
      }
      if (stage === 'failed') systemErrorReqNos.add(reqNo);
      return true;
    };
    const { eType, eMessage } = await sendErp(reqNo);
    // 이 묶음의 CONFIRM_ID 와 맞는 항목만 거절로 본다. parseErpErrors 는 ':' 없는 문구를 통째로 ID 로 읽으므로
    //   걸러야 "거절 ID 를 못 읽음(R7 → F 경로)"이 제대로 잡힌다(자매 SSP0021 erpChain 과 같은 처리).
    const groupIdSet = new Set(groupIds);
    const parsed =
      eType === ERP_IF_ERROR || eType === ERP_IF_PARTIAL_ERROR
        ? parseErpErrors(eMessage).filter(e => groupIdSet.has(e.confirmId))
        : [];
    if (!eType || eType === ERP_IF_SUCCESS) {
      // 정상 — AS-IS cs:4380~4398. CHG_BATCH('B') + 2차 송신 후 진행.
      if (await afterStage(groupIds)) anyActive = true;
    } else if ((eType === ERP_IF_ERROR || eType === ERP_IF_PARTIAL_ERROR) && parsed.length > 0) {
      // 거절 — AS-IS cs:4303~4372. 오류 적재(ERP_ERROR_CONFIRM)는 E_MESSAGE 에 나열된 ID 기준이다.
      parsed.forEach(e => errs.push({ ...e, reqNo }));
      if (eType === ERP_IF_ERROR) {
        // 전건 거절 — 이 묶음은 확정하지 않는다(AS-IS bFlag=false). 초안 되돌림은 묶음 전체 ID 로 한다:
        //   AS-IS 는 나열된 ID 만 지우지만(cs:4320~4331) 나열 안 된 행의 초안이 고아로 남는다(2차 검토 N7).
        await compensate(reqNo, groupIds);
        excludeGroup();
      } else {
        // S_E — 거절된 CONFIRM 만 되돌리고 그 행만 뺀 뒤, 남은 성공분으로 2차 적재·송신 후 진행(AS-IS bFlag=true)
        const rejected = new Set(parsed.map(e => e.confirmId));
        await compensate(reqNo, [...rejected]);
        group.rows.forEach(r => {
          if (rejected.has(idOf(r))) excludedRows.add(r);
        });
        if (await afterStage(groupIds.filter(id => !rejected.has(id)))) anyActive = true;
      }
    } else {
      // F · C_E — AS-IS cs:4374~4379 F_CE_requestNo 기록. 보상은 아래 ⑥.
      //   E/S_E 인데 E_MESSAGE 에서 CONFIRM_ID 를 하나도 못 읽은 경우도 여기로 온다(정적 검토 R7) — 무엇이 거절됐는지
      //   모르므로 묶음 전체를 되돌리고 MSG01215 로 알린다. 확정에서도 뺀다.
      excludeGroup();
      fce.push({ reqNo, confirmIds: groupIds });
    }
  }

  // ── ⑥ 결과 처리 — AS-IS GetERPInterface cs:3257~3343.
  if (errs.length > 0) {
    // 오류 적재(cs:3266~3289) + MSG00197(→MSG01208). 보상 키는 userId(결함 D-1).
    await callCompensation(
      ERP_CHAIN_BTN.ERP_ERROR_CONFIRM,
      {
        changeRequestNo: errs.map(e => e.reqNo).join('^'),
        confirmId: errs.map(e => e.confirmId).join('^'),
        eType: ERP_ERROR_E_TYPE,
        eMessage: errs.map(e => e.message).join('^'),
        userId: deps.userId,
      },
      uniqStr(errs.map(e => e.reqNo))
    );
    await deps.alert(
      say(
        MSG_ERP.ISSUE,
        '__ERP cannot be processed due to an ISSUE. {0}',
        errs.map(e => `${e.confirmId}:${e.message}`).join('\n')
      )
    );
  }
  // F · C_E 보상 — AS-IS cs:3294~3343: 초안 되돌림 + FN_ERP 재송신("삭제 처리", cs:3335) + MSG00204(→MSG01215).
  //   AS-IS 는 마지막 F/C_E 요청 1건만, 거절(errs)이 없을 때만 되돌리고 MSG00204 를 띄운다(F_CE_requestNo 덮어쓰기).
  //   TO-BE 는 고아 초안이 남지 않게 F/C_E 요청 전부를 되돌리고, 거절 안내와 별개로 요청번호를 알린다.
  for (const f of fce) {
    await compensate(f.reqNo, f.confirmIds);
    await sendErp(f.reqNo);
    systemErrorReqNos.add(f.reqNo);
  }
  for (const path of forbiddenPaths) {
    const [sheet, btn] = path.split('/');
    await alertNoRoute(sheet, btn);
  }
  if (systemErrorReqNos.size > 0) {
    await deps.alert(
      say(MSG_ERP.SYSTEM_ERROR, '__System error. Request No : {0}', [...systemErrorReqNos].join(', '))
    );
  }
  // 주의: AS-IS 는 F/C_E 가 하나라도 있으면 확정 전체를 안 한다(cs:3342 bReturn=false). TO-BE 는 정적 검토 R3 결정에 따라
  //   F/C_E 묶음 행만 확정에서 빼고, 송신에 성공한 묶음은 확정한다 — 이미 ERP 에 반영된 묶음을 확정하지 않으면
  //   ERP 와 SCM 원장이 어긋나기 때문이다.
  // AS-IS: 묶음이 없으면(신규행만 등) bReturn 초기값 true 로 확정 진행. 묶음이 있으면 하나라도 송신 성공해야 진행.
  if (groups.length > 0 && !anyActive) return null;
  return { confirmRows: dirty.filter(r => !excludedRows.has(r)) };
};
