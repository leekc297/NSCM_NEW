// SSP0060 저장 전 ERP 송신 연쇄 — 하단 Plan Detail 저장과 Request 팝업 저장이 같이 쓴다.
//   AS-IS 원본: SSP0060_ShipmentPlan.cs SaveData_Detail(3109~3406)·GetERPInterface(3840~4065)·
//   NonSoNo(4067)·SoNo(4254)·GetErpSoNoCnt(4473)·GetShipmentStatusChk(4498)·GetErpIFCheckNew(4621~4726)·
//   chkERPIFBlockYn(3560)·ChkConfirmChangeTime(7957),
//   Popup/SSP0060_ShipmentPlanRequestPopup.cs SaveData(401~700)·GetERPInterface(894~1106)·SoNo(1108)·
//   NonSoNo(1282)·GetErpIFCheckNew(1489~1605)·ChkConfirmChangeTime(1726).
//   TO-BE 선례: SSP0015 ShipmentPlanMobilityIt.tsx sendErpAndCompensate.
//
// 실패 처리 규칙
//   - HTTP 403 은 버튼 라우팅/권한 메타 미등록이다(01 SQL 미적용). MSG01125(사용 권한이 없습니다) + 호출 경로로
//     알린다 — 일반 저장 실패(MSG00003)와 구분한다.
//   - 사전검사(단위 시작 전) 단계의 403·HTTP 실패·통신 예외는 아무것도 쓰지 않은 상태라 연쇄 전체를 즉시 멈춘다.
//   - 단위(DRAFTING→송신) 처리 중 예외는 그 단위만 실패로 기록하고(행은 CONFIRM 제외, 요청번호가 있으면 F 와 같이
//     되돌림) 이미 끝난 단위의 확정·보상은 마무리에서 그대로 한다. 403 이면 남은 단위는 돌리지 않는다.
//   - ERP 송신(erpIf) 실패는 AS-IS CallClient catch 와 같이 'C_E' 로 본다.
import type { ComboParam, ComboResponse } from '@foundation/models';

import {
  CHG_BATCH_TYPE,
  ERP_BLOCK_COMBO,
  ERP_CHAIN_BTN,
  ERP_DELETE_FLAG,
  ERP_ERROR_E_TYPE,
  ERP_IF,
  ERP_IF_PATH,
  ERP_IF_SEND_ON,
  IF_CHECK_PARTIAL_OFF,
  IF_CHECK_STATUS_APPLY,
  MENU_ID,
  MSG,
  MSG_CHAIN,
  MSG_ERP,
  SHEETS,
  STANDARD_MANUAL_URL,
} from '../shipment-plan.constants';

import {
  buildDetailErpUnits,
  collectDetailDraftingRows,
  collectRequestDraftingMainRows,
  detailActionOf,
  type DraftingSaveMeta,
  parseErpErrors,
  toYmd8,
} from './shipment-plan.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type Row = Record<string, unknown>;

export interface ProcResponse {
  status: number;
  data?: unknown;
}

export interface ErpChainDeps {
  post: (url: string, body: unknown) => Promise<ProcResponse>;
  getCombo: (params: ComboParam) => Promise<ComboResponse[]>;
  t: (key: string, fallback: string) => string;
  /** 닫힐 때 resolve 되는 알림(순차 표시용). */
  alert: (content: string) => Promise<unknown>;
  /** 예/아니오. 예=true. */
  confirm: (content: string) => Promise<boolean>;
  userId: string;
  timeZone: string;
}

/** 버튼 라우팅·권한 메타 미등록(HTTP 403). path = 호출 경로. */
export class RouteMissingError extends Error {
  constructor(readonly path: string) {
    super(`403 ${path}`);
    this.name = 'RouteMissingError';
  }
}

/** 403 이외의 HTTP 실패·통신 예외 — 연쇄를 멈추고 MSG00003. */
class ProcFailedError extends Error {
  constructor(readonly detail = '') {
    super(detail || 'proc failed');
    this.name = 'ProcFailedError';
  }
}

// 카탈로그 문구의 '{0}' 치환 + 이스케이프 개행('\\n','\\r') 정규화 — ShipmentPlan.tsx fmtMsg 와 같은 처리.
const fmt = (deps: ErpChainDeps, code: string, fallback: string, arg0?: string): string => {
  const raw = deps.t(code, fallback);
  const filled = arg0 === undefined ? raw : raw.replace('{0}', arg0);
  return filled.replace(/\\r/g, '').replace(/\\n/g, '\n');
};

const procUrl = (btn: string): string => `/${MENU_ID}/${SHEETS.MAIN}/${btn}/call-proc`;

const resultOf = (res: ProcResponse): Record<string, unknown> =>
  ((res.data as { result?: Record<string, unknown> } | undefined)?.result ?? {});

const cursor = (res: ProcResponse, key: string): Row[] => {
  const v = resultOf(res)[key];
  return Array.isArray(v) ? (v as Row[]) : [];
};

const isHttpFailed = (res: ProcResponse): boolean =>
  res.status >= 400 || !!Number((res.data as { code?: unknown } | undefined)?.code);

/**
 * main 시트 call-proc 1회. 403 → RouteMissingError, 그 밖의 HTTP 실패·예외 → ProcFailedError.
 *   allowFail=true 면 403 만 던지고 나머지 실패는 응답을 그대로 돌려준다(AS-IS 가 결과를 보지 않는 보상 호출용).
 */
const callProc = async (
  deps: ErpChainDeps,
  btn: string,
  body: Record<string, string>,
  allowFail = false
): Promise<ProcResponse> => {
  const url = procUrl(btn);
  let res: ProcResponse;
  try {
    res = await deps.post(url, body);
  } catch {
    if (allowFail) return { status: 0 };
    throw new ProcFailedError(url);
  }
  if (res.status === 403) throw new RouteMissingError(url);
  if (!allowFail && isHttpFailed(res)) throw new ProcFailedError(url);
  return res;
};

/** 연쇄 중단 예외를 사용자 안내로 바꾼다. 처리했으면 true. */
export const alertChainError = async (deps: ErpChainDeps, error: unknown): Promise<boolean> => {
  if (error instanceof RouteMissingError) {
    await deps.alert(`${deps.t(MSG_CHAIN.NO_AUTH, '__You do not have permission.')}\n[HTTP 403] ${error.path}`);
    return true;
  }
  await deps.alert(deps.t(MSG.SAVE_FAILED, '__Save failed.'));
  return true;
};

// ── 사전 검사 ──────────────────────────────────────────────────────────────────

/**
 * ERP 중단기간 — AS-IS chkERPIFBlockYn(cs:3560~3583, 팝업 ChkERPIFBlockYn RP:748). BLOCK_YN='Y' 면 MSG00267(→MSG01275) 후
 *   차단. 0행이면 AS-IS 도 통과한다. 콤보 조회 자체가 실패하면(SSP0200 실측 ORA-01830 사례) 판정 근거가 없어
 *   통과시킨다 — 차단으로 올리면 저장이 영구 불가가 된다(SSP0200 passErpBlockGate 와 같은 판단, 알림은 생략).
 */
export const checkErpBlock = async (deps: ErpChainDeps): Promise<boolean> => {
  let first: ComboResponse | undefined;
  try {
    first = (await deps.getCombo({ comboId: ERP_BLOCK_COMBO, segment1: MENU_ID }))?.[0];
  } catch {
    return true;
  }
  if (!first) return true;
  if (str(first.BLOCK_YN ?? first.CODE) !== 'Y') return true;
  await deps.alert(
    fmt(
      deps,
      MSG_CHAIN.ERP_BLOCK_PERIOD,
      '__The SSP shipment change request cannot be used during the ERP system downtime below. {0}',
      str(first.PERIOD ?? first.NAME)
    )
  );
  return false;
};

/**
 * 출하 상태 재검증 — AS-IS GetShipmentStatusChk(cs:4498~4560). 세 커서를 모두 보고 걸린 것마다 안내한 뒤 false.
 *   o_rc1 다른 사용자 변경요청(MSG00248→MSG01258) / o_rc2 Qty 0 삭제(MSG00249→MSG01259) /
 *   o_rc3 ERP DO 생성(MSG00189→MSG01202). [01] 메타 대기 — 미적용이면 403.
 */
export const checkShipmentStatus = async (
  deps: ErpChainDeps,
  divisionId: string,
  confirmId: string
): Promise<boolean> => {
  const res = await callProc(deps, ERP_CHAIN_BTN.GET_SHIPMENT_STATUS, { divisionId, confirmId });
  const ids = (key: string): string =>
    cursor(res, key)
      .map(r => str(r.CONFIRM_ID))
      .filter(Boolean)
      .join(',');
  let ok = true;
  const rc1 = ids('o_rc1');
  if (rc1) {
    ok = false;
    await deps.alert(
      fmt(
        deps,
        MSG_CHAIN.STATUS_OTHER_USER_REQUEST,
        '__A Confirm ID for which another user requested a shipment plan change exists. [ CONFIRM ID : {0} ]',
        rc1
      )
    );
  }
  const rc2 = ids('o_rc2');
  if (rc2) {
    ok = false;
    await deps.alert(
      fmt(
        deps,
        MSG_CHAIN.STATUS_DELETED_QTY0,
        '__A deleted (Qty:0) Confirm ID exists. Please re-search and try again. [ Confirm ID : {0} ]',
        rc2
      )
    );
  }
  const rc3 = ids('o_rc3');
  if (rc3) {
    ok = false;
    await deps.alert(
      fmt(
        deps,
        MSG_CHAIN.STATUS_ERP_DO_CREATED,
        '__In ERP, a DO has been created and the change cannot be requested. {0}',
        rc3
      )
    );
  }
  return ok;
};

/**
 * 같은 SO 전건 조회 여부 — AS-IS GetErpSoNoCnt(cs:4473~4496) + 비교(cs:3868~3884). DB 건수와 화면 행 수가
 *   다르면 MSG00247 후 false. [01] 메타 대기.
 */
export const checkErpSoCount = async (
  deps: ErpChainDeps,
  divisionId: string,
  erpSoNo: string,
  sheetCount: number
): Promise<boolean> => {
  const res = await callProc(deps, ERP_CHAIN_BTN.GET_ERP_SO_NO_CNT, { divisionId, erpSoNo });
  const first = cursor(res, 'o_rc1')[0] ?? cursor(res, 'O_RC1')[0];
  const dbCount = Number(first?.CNT ?? 0); // AS-IS 0행이면 0(cs:4491)
  if (dbCount === sheetCount) return true;
  await deps.alert(
    fmt(
      deps,
      MSG_CHAIN.SO_NO_COUNT_MISMATCH,
      '__Another item created with the same SO number exists.\nChanges must be made identically on an SO number basis.\n[ SO NO : {0} ]',
      erpSoNo
    )
  );
  return false;
};

/**
 * 2분 재변경 잠금 — AS-IS ChkConfirmChangeTime(cs:7957~7980 / RP:1726~1748). Rows[0][0]=='S' 만 통과,
 *   그 외(SP 가 2분 안이면 'X') MSG00404(→MSG01395). AS-IS 와 같은 단독 SCM_SSP_CHECK_CONFIRM_CHANGETIME
 *   (main/CHECK_CONFIRM_CHANGETIME, 01 SQL)을 쓴다 — _DE 판은 항상 'S' 인 빈 껍데기라 쓰지 않는다.
 */
export const checkConfirmChangeTime = async (
  deps: ErpChainDeps,
  confirmIds: string[]
): Promise<boolean> => {
  if (confirmIds.length === 0) return true;
  const res = await callProc(deps, ERP_CHAIN_BTN.CHECK_CONFIRM_CHANGETIME, {
    confirmId: confirmIds.join('^'),
  });
  const first = cursor(res, 'o_rc1')[0];
  const code = str(first?.RESULT_CODE ?? (first ? Object.values(first)[0] : ''));
  if (code === 'S') return true;
  await deps.alert(
    deps.t(
      MSG_CHAIN.CONFIRM_CHANGETIME_LOCK,
      '__Due to ERP I/F, changes can be made after 2 minutes of previous work.'
    )
  );
  return false;
};

// ── ERP 송신과 결과 처리 ────────────────────────────────────────────────────────

/**
 * AS-IS bActiveList / errConfirmList(+errConfrimList2) / F_CE_requestNo 의 TO-BE 묶음.
 *   AS-IS 는 F_CE_requestNo 가 변수 1개(마지막 값)이고 거절(E/S_E)이 있으면 F/C_E 뒤처리를 else-if 로 건너뛴다
 *   (cs:3957~4055). 둘 다 앞 단위의 초안·XIF 'C' 를 고아로 남기는 결함이라 TO-BE 는 단위마다 모아 전부 처리한다.
 */
export interface ErpChainState {
  units: number;
  anySuccess: boolean;
  /** E/S_E 로 ERP 가 거절한 CONFIRM 별 사유 — 오류 적재(ERP_ERROR_CONFIRM) 대상. */
  errors: { confirmId: string; message: string; changeReqNo: string }[];
  /** F/C_E·예외·거절 파싱 0건 단위 — 그 단위 행의 CONFIRM_ID 만 초안 되돌림 + 삭제 반영 재송신. */
  fce: { changeReqNo: string; confirmIds: string[] }[];
  /** CONFIRM 에서 뺄 행 — 실패 단위의 행 전체와 S_E 단위의 거절 행. */
  excludeRows: Set<Row>;
  /**
   * 'B' 2차 적재(IF_CHECK / CHG_BATCH_NEW_C 'B')가 403 이외 이유로 실패한 요청번호 — 기록 후 진행(CONFIRM 유지,
   *   2차 송신만 생략). 연쇄 끝에 MSG01215 로 한 번 알린다.
   */
  stageFailed: string[];
  /** 보상 호출(DELETE_BY_CONFIRM·ERP_ERROR_CONFIRM)이 403 이외 이유로 실패한 요청번호 — MSG01215 로 함께 알린다(검토 #13). */
  compensateFailed: string[];
  /** 단위 처리 중 403 이 난 호출 경로. */
  routeMissing: string[];
  /** 단위 처리 중 403 이외의 HTTP 실패·예외가 있었는가. */
  procFailed: boolean;
}

const newState = (): ErpChainState => ({
  units: 0,
  anySuccess: false,
  errors: [],
  fce: [],
  excludeRows: new Set(),
  stageFailed: [],
  compensateFailed: [],
  routeMissing: [],
  procFailed: false,
});

const confirmIdsOf = (rows: Row[]): string[] =>
  Array.from(
    new Set(rows.map(r => str(r.CONFIRM_ID).trim()).filter(id => id !== '' && id !== '-'))
  );

const recordError = (state: ErpChainState, error: unknown): void => {
  if (error instanceof RouteMissingError) {
    if (!state.routeMissing.includes(error.path)) state.routeMissing.push(error.path);
  } else {
    state.procFailed = true;
  }
};

const markFailed = (state: ErpChainState, rows: Row[]): void => {
  rows.forEach(r => state.excludeRows.add(r));
};

const sendErp = async (
  deps: ErpChainDeps,
  changeReqNo: string
): Promise<{ eType: string; eMessage: string }> => {
  try {
    const erp = await deps.post(ERP_IF_PATH, {
      CHANGE_REQ_NO: changeReqNo,
      CHANGE_TYPE: ERP_IF.CHANGE_TYPE,
      SHIPMENT_STATUS: '',
    });
    if (isHttpFailed(erp)) return { eType: ERP_IF.PI_FAIL, eMessage: '' };
    const r = resultOf(erp) as { E_TYPE?: unknown; E_MESSAGE?: unknown };
    return { eType: str(r.E_TYPE), eMessage: str(r.E_MESSAGE) };
  } catch {
    return { eType: ERP_IF.PI_FAIL, eMessage: '' };
  }
};

const addOnce = (list: string[], v: string): void => {
  if (v && !list.includes(v)) list.push(v);
};

/**
 * 초안 되돌림 — SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM (cs:4657~4669 / 4031~4043).
 *   AS-IS 는 결과를 보지 않는다. TO-BE 는 403 은 던지고(호출부가 경로 안내), 그 밖의 실패는 요청번호를
 *   compensateFailed 에 모아 MSG01215 로 알린다(검토 #13 — 초안이 안 지워졌는데 조용히 넘어가지 않게).
 */
const deleteDraftingByConfirm = async (
  deps: ErpChainDeps,
  state: ErpChainState,
  confirmIds: string[],
  changeReqNo: string
): Promise<void> => {
  if (confirmIds.length === 0) return;
  const res = await callProc(
    deps,
    ERP_CHAIN_BTN.DELETE_DRAFTING_BY_CONFIRM,
    {
      confirmId: confirmIds.join('^'),
      changeRequestNo: changeReqNo,
      delFlag: ERP_DELETE_FLAG,
      userId: deps.userId, // PROC 메타 키 userId (lastUpdatedBy 는 NULL 바인딩 — 결함 D-1)
      timeZone: deps.timeZone,
      ifSendFlag: ERP_IF_SEND_ON,
      changeType: ERP_IF.CHANGE_TYPE,
    },
    true
  );
  if (res.status === 0 || isHttpFailed(res)) addOnce(state.compensateFailed, changeReqNo);
};

/**
 * 요청번호 1건 송신 + 결과 분기 — AS-IS GetErpIFCheckNew(cs:4621~4726 / RP:1489~1605).
 *   S     → stageB(2차 적재 'B') → 2차 송신 → 성공
 *   S_E   → 거절 CONFIRM 만 초안 되돌림·CONFIRM 제외 → stageB → 2차 송신 → 성공(남은 행으로 진행)
 *   E     → 단위 행 전체 초안 되돌림(검토 N7) → 실패
 *   F/C_E → 그 단위를 fce 로 보관 → 실패. 되돌림은 finishErpChain 에서 한다.
 *   E/S_E 인데 E_MESSAGE 에서 CONFIRM_ID 를 하나도 못 읽으면 거절 대상을 알 수 없으므로 F 와 같이 처리한다
 *   (단위 전체 되돌림 + MSG01215, CONFIRM 제외 — 무안내 중단·거절분 확정 방지).
 *   stageB 가 false(403 이외 HTTP 실패·RESULT_CODE≠S)면 **기록 후 진행**한다 — 2차 송신만 건너뛰고 성공으로 보아
 *   CONFIRM 대상에 남기며, 요청번호를 stageFailed 에 모아 연쇄 끝에 MSG01215 로 알린다. 근거: 기준 구현 SSP0015
 *   (ShipmentPlanMobilityIt.tsx sendErpAndCompensate stageAndResend)가 IF_CHECK 실패 시 2차 송신만 생략하고 진행하며,
 *   ERP 는 이미 'C' 요청을 받았으므로 초안을 되돌리면 ERP 쪽 요청이 고아가 된다. AS-IS 도 CHG_BATCH 결과를 보지
 *   않는다(cs:4683~4693). SSP0021·SSP0023 과 같은 처리. 403 은 stageB 가 던지고 processUnit 이 받는다.
 *   반환값 = 성공 여부(실패면 호출부가 단위 행을 CONFIRM 에서 뺀다).
 */
const sendAndJudge = async (
  deps: ErpChainDeps,
  state: ErpChainState,
  changeReqNo: string,
  unitRows: Row[],
  stageB: () => Promise<boolean>
): Promise<boolean> => {
  const asFce = (): boolean => {
    state.fce.push({ changeReqNo, confirmIds: confirmIdsOf(unitRows) });
    return false;
  };
  const stageAndResend = async (): Promise<boolean> => {
    if (await stageB()) {
      await sendErp(deps, changeReqNo); // 2차 송신 결과는 AS-IS 도 보지 않는다(cs:4693/4723)
    } else {
      addOnce(state.stageFailed, changeReqNo); // 기록 후 진행 — 2차 송신 생략, CONFIRM 유지
    }
    state.anySuccess = true;
    return true;
  };

  const { eType, eMessage } = await sendErp(deps, changeReqNo);
  if (eType === ERP_IF.ERROR || eType === ERP_IF.PARTIAL_ERROR) {
    // 이 단위의 CONFIRM_ID 와 맞는 항목만 거절로 본다. parseErpErrors 는 ':' 없는 문구를 통째로 ID 로 읽으므로
    //   걸러야 "거절 ID 를 못 읽음(R7 → F 경로)"이 제대로 잡힌다(자매 SSP0021 erpChain 과 같은 처리).
    const unitIds = new Set(confirmIdsOf(unitRows));
    const parsed = parseErpErrors(eMessage).filter(p => unitIds.has(p.confirmId));
    if (parsed.length === 0) return asFce();
    parsed.forEach(p => state.errors.push({ ...p, changeReqNo }));
    const rejected = new Set(parsed.map(p => p.confirmId));
    unitRows.forEach(r => {
      if (rejected.has(str(r.CONFIRM_ID).trim())) state.excludeRows.add(r);
    });
    if (eType === ERP_IF.ERROR) {
      // E — 요청 전체가 거절됐다. E_MESSAGE 에 안 나열된 CONFIRM 의 초안도 남지 않게 단위 행 전체를 되돌린다
      //   (검토 N7). 오류 적재(ERP_ERROR_CONFIRM)는 위에서 모은 파싱 ID 기준 그대로다.
      await deleteDraftingByConfirm(deps, state, confirmIdsOf(unitRows), changeReqNo);
      return false;
    }
    await deleteDraftingByConfirm(deps, state, [...rejected], changeReqNo); // S_E — 거절분만
    return stageAndResend();
  }
  if (eType === ERP_IF.NO_DATA || eType === ERP_IF.PI_FAIL) return asFce();
  return stageAndResend(); // 'S' 또는 빈 값(SSP0015 와 같이 정상으로 본다)
};

/**
 * 단위 1건 처리 — DRAFTING(draft) → [afterDraft] → 송신·판정. 예외는 단위 안에서 받는다(검토 R2):
 *   앞 단위가 이미 ERP 송신·'B' 적재까지 끝났는데 뒤 단위 예외로 연쇄 전체가 끊기면 앞 단위가 확정도 보상도 안 된다.
 *   예외 단위는 행을 CONFIRM 에서 빼고, 요청번호를 이미 받았으면 F 와 같이 되돌린다. 403 이면 true 를 돌려
 *   호출부가 남은 단위를 멈추게 한다(같은 메타 미등록이라 뒤 단위도 같은 403 이다 — 송신만 늘어난다).
 *   'B' 적재 단계의 403 도 여기로 온다(되돌림). 403 은 IF_CHECK 가 아예 돌지 않아 'B' XIF 행이 없으므로 1분 배치가
 *   다시 집을 것이 없다 — 비403 실패(기록 후 진행)와 달리 확정하면 ERP 확정이 영영 안 간다. 그래서 삭제 반영
 *   송신(ifSendFlag 'Y' + erpIf)으로 ERP 'C' 요청을 거둬들이는 되돌림을 유지한다.
 */
const processUnit = async (
  deps: ErpChainDeps,
  state: ErpChainState,
  unitRows: Row[],
  steps: {
    /** 초안 저장. 업무 실패(이미 안내함)면 '' 를 돌려준다. */
    draft: () => Promise<string>;
    afterDraft?: (changeReqNo: string) => Promise<void>;
    stageB: (changeReqNo: string) => Promise<boolean>;
  }
): Promise<boolean> => {
  state.units += 1;
  let changeReqNo = '';
  try {
    changeReqNo = await steps.draft();
    if (!changeReqNo) {
      markFailed(state, unitRows);
      return false;
    }
    if (steps.afterDraft) await steps.afterDraft(changeReqNo);
    const reqNo = changeReqNo;
    const ok = await sendAndJudge(deps, state, reqNo, unitRows, () => steps.stageB(reqNo));
    if (!ok) markFailed(state, unitRows);
    return false;
  } catch (error) {
    recordError(state, error);
    markFailed(state, unitRows);
    if (changeReqNo && !state.fce.some(f => f.changeReqNo === changeReqNo)) {
      state.fce.push({ changeReqNo, confirmIds: confirmIdsOf(unitRows) });
    }
    return error instanceof RouteMissingError;
  }
};

/**
 * 연쇄 마무리 — AS-IS GetERPInterface 뒤처리(cs:3957~4055 / RP:1013~1094).
 *   ① ERP 거절 행이 있으면 오류 적재(ERP_ERROR_CONFIRM) + MSG00197(→MSG01208).
 *   ② F/C_E·예외 단위가 있으면 단위마다 그 단위 행만 초안 되돌림 + ERP 재송신(삭제 반영, cs:4047).
 *      그 요청번호와 'B' 적재 실패(기록 후 진행) 요청번호를 모아 MSG00204(→MSG01215, {0}=요청번호 목록) 1회.
 *      F·C_E 는 AS-IS 하단 저장처럼 한 문구로 안내한다(cs:4052).
 *   ①·② 는 둘 다 수행한다(AS-IS else-if 결함 미이식, 검토 R1).
 *   ③ 단위 처리 중 403 이 있었으면 MSG01125 + 경로, 그 밖의 예외는 MSG00003.
 *   진행 여부 = 단위가 없거나(신규·P 행만) 성공 단위가 하나라도 있다(cs:3946~3955). 실패 단위 행은 excludeRows 로
 *   CONFIRM 에서 빠진다. 주의: AS-IS 는 F/C_E 가 하나라도 있으면 성공 단위까지 확정하지 않는다(bReturn=false) —
 *   이미 ERP 송신·'B' 적재가 끝난 성공 단위를 확정하지 않으면 ERP 와 계획이 어긋나 TO-BE 는 성공분을 확정한다.
 */
const finishErpChain = async (deps: ErpChainDeps, state: ErpChainState): Promise<boolean> => {
  const safe = async (fn: () => Promise<unknown>): Promise<void> => {
    try {
      await fn();
    } catch (error) {
      recordError(state, error);
    }
  };
  if (state.errors.length > 0) {
    await safe(async () => {
      const res = await callProc(
        deps,
        ERP_CHAIN_BTN.ERP_ERROR_CONFIRM,
        {
          changeRequestNo: state.errors.map(e => e.changeReqNo).join('^'),
          confirmId: state.errors.map(e => e.confirmId).join('^'),
          eType: ERP_ERROR_E_TYPE,
          eMessage: state.errors.map(e => e.message).join('^'),
          userId: deps.userId, // PROC 메타 키 userId (결함 D-1)
        },
        true
      );
      if (res.status === 0 || isHttpFailed(res)) {
        state.errors.forEach(e => addOnce(state.compensateFailed, e.changeReqNo)); // 검토 #13
      }
    });
    await deps.alert(
      fmt(
        deps,
        MSG_ERP.ISSUE,
        '__ERP cannot be processed due to the ISSUE below. Please retry after ERP is resolved.\n{0}',
        state.errors.map(e => `${e.confirmId}:${e.message}`).join('\n')
      )
    );
  }
  for (const f of state.fce) {
    if (f.confirmIds.length === 0) continue;
    await safe(() => deleteDraftingByConfirm(deps, state, f.confirmIds, f.changeReqNo));
    await sendErp(deps, f.changeReqNo); // 삭제 처리 송신(cs:4047 / RP:1088)
  }
  // F/C_E·예외 되돌림 요청번호, 'B' 적재 실패(기록 후 진행), 보상 호출 실패 요청번호를 MSG01215 한 번으로 알린다.
  const systemErrorReqNos = Array.from(
    new Set([
      ...state.fce.map(f => f.changeReqNo),
      ...state.stageFailed,
      ...state.compensateFailed,
    ])
  );
  if (systemErrorReqNos.length > 0) {
    await deps.alert(
      fmt(deps, MSG_ERP.SYSTEM_ERROR, '__System error. Request No : {0}', systemErrorReqNos.join(', '))
    );
  }
  if (state.routeMissing.length > 0) {
    await deps.alert(
      `${deps.t(MSG_CHAIN.NO_AUTH, '__You do not have permission.')}\n${state.routeMissing
        .map(p => `[HTTP 403] ${p}`)
        .join('\n')}`
    );
  } else if (state.procFailed) {
    await deps.alert(deps.t(MSG.SAVE_FAILED, '__Save failed.'));
  }
  return state.units === 0 || state.anySuccess;
};

/** 'X'(기준정보 미등록) — AS-IS MSG00324 예/아니오 → 매뉴얼(cs:4219~4227). TO-BE MSG01321. */
const confirmManual = async (deps: ErpChainDeps): Promise<void> => {
  const yes = await deps.confirm(
    deps.t(
      MSG.STD_INFO_NOT_REGISTERED,
      '_기준정보가 등록되어 있지 않습니다. 참고자료를 열람하시겠습니까?'
    )
  );
  if (yes) window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer');
};

export interface ErpChainResult {
  /** CONFIRM(planDetail/SAVE) 로 진행해도 되는가. */
  proceed: boolean;
  /**
   * CONFIRM 에서 뺄 행(검토 R3) — DRAFTING 'X'·실패·요청번호 없음, E, F/C_E, 거절 파싱 0건, 'B' 적재 실패,
   *   예외 단위의 행 전체와 S_E 의 거절 행. 신규 'I'·CHANGE_TYPE 'P' 행은 단위가 아니라 여기 들지 않는다.
   */
  excludeRows: Set<Row>;
  /** ERP 가 거절한 CONFIRM_ID — AS-IS errConfrimList2 비교(cs:3217~3228 / RP:522~533)대로 같은 ID 의 행도 뺀다. */
  excludeConfirmIds: Set<string>;
}

const stopped = (): ErpChainResult => ({
  proceed: false,
  excludeRows: new Set(),
  excludeConfirmIds: new Set(),
});

const resultFrom = async (deps: ErpChainDeps, state: ErpChainState): Promise<ErpChainResult> => {
  const proceed = await finishErpChain(deps, state);
  return {
    proceed,
    excludeRows: state.excludeRows,
    excludeConfirmIds: new Set(state.errors.map(e => e.confirmId)),
  };
};

/**
 * IF_CHECK — AS-IS PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('B', REQ_NO)(cs:4683/4713) 대용.
 *   PKG_SSP0003.P_SSP0003_SAVE_REQ_IF_CHECK 는 changeStatus='A' + changeType='C' 에서 V_STATUS='B' 로
 *   CHG_BATCH 만 하고 COMMIT 한다(PKG_SSP0003 BODY 1850~1882). SSP0015 선례와 같은 값. [01] 메타 대기.
 */
const stageByIfCheck = async (deps: ErpChainDeps, changeReqNo: string): Promise<boolean> => {
  const res = await callProc(
    deps,
    ERP_CHAIN_BTN.IF_CHECK,
    {
      changeRequestNo: changeReqNo,
      changeStatus: IF_CHECK_STATUS_APPLY,
      timeZone: deps.timeZone,
      changeType: ERP_IF.CHANGE_TYPE,
      partialApproval: IF_CHECK_PARTIAL_OFF,
    },
    true
  );
  if (isHttpFailed(res) || res.status === 0) return false;
  const code = str(cursor(res, 'o_result_cursor')[0]?.RESULT_CODE);
  return code === '' || code === 'S';
};

/**
 * 하단 Plan Detail 저장 전 연쇄 — AS-IS SaveData_Detail → GetERPInterface(cs:3840~4065).
 *   순서: ERP 중단기간 → 행별 [상태 재검증 → SO 건수 → 날짜] → 2분 잠금 → 단위별 [DRAFTING → erpIf →
 *   IF_CHECK → 2차 송신 | 보상] → 마무리(오류 적재 / F·C_E 되돌림). 반환값으로 CONFIRM 진행 여부와 제외 행을 준다.
 *   사전검사(단위 시작 전) 단계의 403·HTTP 실패는 아무것도 쓰지 않은 상태라 즉시 중단한다.
 */
export const runDetailErpChain = async (
  deps: ErpChainDeps,
  args: { dirty: Row[]; allRows: Row[]; meta: DraftingSaveMeta }
): Promise<ErpChainResult> => {
  const { dirty, allRows, meta } = args;
  try {
    if (!(await checkErpBlock(deps))) return stopped();

    // 1번째 루프(cs:3853~3895) — 행별 상태 재검증·SO 건수·날짜 형식
    const soChecked = new Set<string>();
    for (const row of dirty) {
      const action = detailActionOf(row);
      if (action !== 'I' && action !== 'M' && action !== 'D') continue;
      const divisionId = str(row.DIVISION_ID);
      // AS-IS 는 EDIT_MAIN='Y' 행의 CONFIRM_ID 만 상태검사에 쓴다(cs:3859~3864).
      const confirmId = str(row.CONFIRM_ID).trim();
      if (action !== 'I' && str(row.EDIT_MAIN) === 'Y' && confirmId) {
        if (!(await checkShipmentStatus(deps, divisionId, confirmId))) return stopped();
      }
      const so = str(row.ERP_SO_NO).trim();
      if (so && !soChecked.has(so)) {
        soChecked.add(so);
        const sheetCount = allRows.filter(r => str(r.ERP_SO_NO).trim() === so).length;
        if (!(await checkErpSoCount(deps, divisionId, so, sheetCount))) return stopped();
      }
      if (!toYmd8(row.SHIPMENT_DATE)) {
        await deps.alert(
          fmt(deps, MSG_CHAIN.INVALID_DATE_FORMAT, '__This is not a valid date format. {0}', '')
        );
        return stopped();
      }
    }

    // 2분 잠금(cs:3898~3908) — 변경행 전건 CONFIRM_ID
    if (!(await checkConfirmChangeTime(deps, confirmIdsOf(dirty)))) return stopped();
  } catch (error) {
    await alertChainError(deps, error);
    return stopped();
  }

  // 2번째 루프(cs:3910~3944) — 단위별 DRAFTING → ERP. 단위 예외는 processUnit 안에서 받는다.
  const state = newState();
  const units = buildDetailErpUnits(dirty);
  for (let i = 0; i < units.length; i += 1) {
    const unit = units[i];
    const halt = await processUnit(deps, state, unit, {
      draft: async () => {
        const payload = collectDetailDraftingRows(unit, meta);
        if (!payload) return '';
        const res = await callProc(deps, ERP_CHAIN_BTN.SAVE_DRAFTING, payload);
        const d1 = cursor(res, 'o_rc1')[0];
        const code = str(d1?.RESULT_CODE);
        if (code === 'X') {
          await confirmManual(deps); // cs:4219~4230
          return '';
        }
        if (code !== 'S') {
          // cs:4232~4247 MSG00284(보안조치로 상세 숨김) — TO-BE 는 SP ERR_MESSAGE 가 있으면 함께 보인다.
          const err = str(d1?.ERR_MESSAGE) || str(cursor(res, 'o_rc2')[0]?.ERR_MESSAGE);
          await deps.alert(err || deps.t(MSG.SAVE_FAILED, '__Save failed.'));
          return '';
        }
        return str(d1?.REQUEST_NO); // 빈 값 = cs:4206~4216 요청번호 없음(무음 실패)
      },
      stageB: changeReqNo => stageByIfCheck(deps, changeReqNo),
    });
    if (halt) {
      // 403 으로 멈추면 아직 돌지 않은 단위의 행도 CONFIRM 에서 뺀다 — 초안·ERP 없이 확정되면 안 된다(검토 N1).
      units.slice(i + 1).forEach(u => markFailed(state, u));
      break;
    }
  }
  return resultFrom(deps, state);
};

// ── Request 팝업 ────────────────────────────────────────────────────────────────

/**
 * 팝업 SO 행 보류 판정. AS-IS 팝업 SoNo 는 DRAFTING_MAIN 뒤 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('C', REQ_NO)
 *   (RP:1253) 로 XIF 'C' 행을 적재하는데, TO-BE 에는 이 SP 의 'C' 경로를 부를 버튼 라우팅이 없다
 *   (IF_CHECK 는 'B'/'A'/'D' 만 만든다 — PKG_SSP0003 BODY 1850~1870). 'C' 적재 없이 송신하면 ERP 가 받을 행이
 *   없으므로, SO 행은 이번 저장에서 빼고(ERP·CONFIRM 모두) 사용자에게 알린다.
 */
export const splitRequestRowsBySo = (rows: Row[]): { soRows: Row[]; nonSoRows: Row[] } => ({
  soRows: rows.filter(r => str(r.ERP_SO_NO).trim() !== ''),
  nonSoRows: rows.filter(r => str(r.ERP_SO_NO).trim() === ''),
});

/**
 * 팝업 저장 확인 전 검사 — AS-IS SaveData(RP:401~440): ERP 중단기간 → 전 행 상태 재검증(RP:429~436).
 *   (엔진 진행 검사 SSP0003_GET_SSP_PLAN_PROCESSING_CHECK MSG00291 RP:707~730 은 TO-BE 메타가 없어 보류.)
 */
export const runRequestPreChecks = async (
  deps: ErpChainDeps,
  allRows: Row[]
): Promise<boolean> => {
  try {
    if (!(await checkErpBlock(deps))) return false;
    for (const row of allRows) {
      const confirmId = str(row.CONFIRM_ID).trim();
      if (!confirmId) continue;
      if (!(await checkShipmentStatus(deps, str(row.DIVISION_ID), confirmId))) return false;
    }
    return true;
  } catch (error) {
    await alertChainError(deps, error);
    return false;
  }
};

/**
 * 팝업 저장 연쇄 — AS-IS GetERPInterface(RP:894~1106), Non-SO 행만(SO 행은 splitRequestRowsBySo 로 보류).
 *   행별: 날짜 형식(RP:945~950) → 2분 잠금(RP:957~966, CHECK_CONFIRM_CHANGETIME) →
 *   행마다 [DRAFTING_MAIN(requestDraftingMain/SAVE, RP:1385) → CHG_BATCH_NEW_C('C')(RP:1408) →
 *   erpIf → CHG_BATCH_NEW_C('B')(RP:1551/1582) → 2차 송신 | 보상] → 마무리.
 *   상태 재검증은 확인창 전에 전 행으로 이미 했다(runRequestPreChecks) — AS-IS 가 여기서 한 번 더 하는 중복은 생략.
 */
export const runRequestErpChain = async (
  deps: ErpChainDeps,
  args: { rows: Row[]; meta: { userId: string; title: string; programId: string } }
): Promise<ErpChainResult> => {
  const { rows, meta } = args;
  try {
    for (const row of rows) {
      if (!toYmd8(row.NEW_SHIPMENT_DATE)) {
        await deps.alert(
          fmt(deps, MSG_CHAIN.INVALID_DATE_FORMAT, '__This is not a valid date format. {0}', '')
        );
        return stopped();
      }
    }
    if (!(await checkConfirmChangeTime(deps, confirmIdsOf(rows)))) return stopped();
  } catch (error) {
    await alertChainError(deps, error);
    return stopped();
  }

  const state = newState();
  for (let i = 0; i < rows.length; i += 1) {
    const row = rows[i];
    const confirmId = str(row.CONFIRM_ID).trim();
    const halt = await processUnit(deps, state, [row], {
      draft: async () => {
        const payload = collectRequestDraftingMainRows([row], meta);
        if (!payload) return '';
        // DRAFTING_MAIN — 하단 Detail 의 DRAFTING 과 다른 SP(13 IN). 등록됨.
        const url = `/${MENU_ID}/${SHEETS.REQUEST_DRAFTING_MAIN}/SAVE/call-proc`;
        let res: ProcResponse;
        try {
          res = await deps.post(url, payload);
        } catch {
          throw new ProcFailedError(url);
        }
        if (res.status === 403) throw new RouteMissingError(url);
        if (isHttpFailed(res)) throw new ProcFailedError(url);
        // AS-IS NonSoNo 는 결과를 보지 않는다(RP:1385~1405, 판정부 주석). TO-BE 는 'X'/'F' 를 그냥 넘기지 않는다.
        const d1 = cursor(res, 'o_rc1')[0];
        const code = str(d1?.RESULT_CODE);
        if (code === 'X') {
          await confirmManual(deps);
          return '';
        }
        if (code && code !== 'S') {
          const err = str(cursor(res, 'o_rc2')[0]?.ERR_MESSAGE);
          await deps.alert(err || deps.t(MSG.SAVE_FAILED, '__Save failed.'));
          return '';
        }
        // 요청번호 = 행 CHANGE_REQ_NO 고정(AS-IS p_change_seq, RP:1335) — Main Save 가 만든 초안 번호로 팝업 행 전부
        //   같다. DRAFTING_MAIN 은 기존 초안을 UPDATE 만 하고 채번하지 않으며, O_RC1 REQUEST_NO 는 V_MAX_REQ_NO 를
        //   대입하지 않아 항상 NULL 이다(PKG_SSP0060 BODY 5067~5265, 5105 선언·5212 반환) — 그래서 SP 반환값은 쓰지 않는다.
        //   번호가 없으면 AS-IS 는 빈 번호로 CHG_BATCH_NEW_C 를 부른 뒤 MSG00284(RP:1417~1422). TO-BE 는 빈 번호
        //   적재 없이 실패 안내한다.
        const reqNo = str(row.CHANGE_REQ_NO).trim();
        if (!reqNo) await deps.alert(deps.t(MSG.SAVE_FAILED, '__Save failed.'));
        return reqNo;
      },
      // CHG_BATCH_NEW_C('C') — XIF 'C' 적재(RP:1406~1414). 결과는 AS-IS 도 보지 않는다(HTTP 실패는 단위 예외).
      afterDraft: async changeReqNo => {
        await callProc(deps, ERP_CHAIN_BTN.CHG_BATCH_NEW_C, {
          changeType: CHG_BATCH_TYPE.REQUEST,
          changeReqNo,
          confirmId,
        });
      },
      stageB: async changeReqNo => {
        const r = await callProc(
          deps,
          ERP_CHAIN_BTN.CHG_BATCH_NEW_C,
          { changeType: CHG_BATCH_TYPE.CONFIRM, changeReqNo, confirmId },
          true
        );
        return !(isHttpFailed(r) || r.status === 0);
      },
    });
    if (halt) {
      markFailed(state, rows.slice(i + 1)); // 남은 행은 CONFIRM 제외(검토 N1)
      break;
    }
  }
  return resultFrom(deps, state);
};
