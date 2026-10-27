// SSP0021 하단 Plan Detail 저장 전 ERP 송신 연쇄 — 화면 컴포넌트에서 분리한 순수 흐름(의존성 주입, 단위 테스트 대상).
//   AS-IS 원본: SSP0021_ShipmentPlan.cs SaveData_Detail(L2521~2756)·chkERPIFBlockYn(L2922~2945)·
//   GetERPInterface(L3202~3427)·NonSoNo(L3429)·SoNo(L3616)·GetErpSoNoCnt(L3835)·GetShipmentStatusChk(L3860)·
//   GetErpIFCheckNew(L3983~4094)·ChkConfirmChangeTime(L6556).
//   TO-BE 선례: SSP0015 ShipmentPlanMobilityIt.tsx sendErpAndCompensate, SSP0060 utils/shipment-plan.erpChain.ts.
//
// 순서
//   ⓪ ERP 중단기간(SSPBlockCheckIF_SCP, cs L2539) — 'Y' 면 MSG01275 후 중단. 0행·조회 실패는 통과.
//   ① 행마다 GET_SHIPMENT_STATUS(cs L3225) · SO 있으면 GET_ERP_SO_NO_CNT 와 화면 행수 비교(cs L3229~3245)
//   ② CHECK_CONFIRM_CHANGETIME — 2분 잠금(cs L3262~3269)
//   ③ 송신 단위(SO 없는 행 1건 / 같은 SO 전체)마다 DRAFTING → 요청번호 → erpIf(REQ,'C','')
//      S: IF_CHECK('B' 적재) + 2차 송신 / S_E: 거절 CONFIRM 만 초안 되돌림 + 2차 / E: 단위 전체 되돌림·제외 /
//      F·C_E, IF_CHECK 403, 거절인데 CONFIRM_ID 를 못 읽음: F 경로(루프 뒤 단위별 되돌림 + 삭제 반영 송신 + MSG01215)
//   ④ ERP 오류 적재(ERP_ERROR_CONFIRM) + MSG01208(cs L3331~3367), F·C_E 단위별 보상 + MSG01215(cs L3368~3417)
//   ⑤ 호출부가 반환된 행으로 planDetail/SAVE(CONFIRM) 를 부른다(cs L2602~2700).
//
// 실패 처리
//   - 송신 전 단계(⓪~② 와 첫 DRAFTING)의 HTTP 403 은 버튼 라우팅·권한 미등록(01 SQL 미적용)이다.
//     MSG01125 + 호출 경로로 알리고 멈춘다. 403 외 실패·예외는 MSG00003 으로 알리고 멈춘다.
//   - 송신이 시작된 뒤에는 중간에 멈추지 않는다. 앞 단위가 이미 ERP 에 갔으므로 실패는 단위별로 기록하고
//     루프 뒤에 보상·안내를 모두 한다(중간 중단 시 앞 단위 CONFIRM·보상이 사라지는 문제 방지).
//   - 보상 호출(DELETE_BY_CONFIRM, ERP_ERROR_CONFIRM)과 IF_CHECK 의 응답도 검사한다. 실패하면
//     403 은 MSG01125 + 경로, 그 외는 MSG01215(요청번호)로 알린다. 조용히 성공으로 넘기지 않는다.
import type { ComboParam, ComboResponse } from '@foundation/models';

import {
  BTN_CHECK_CONFIRM_CHANGETIME,
  BTN_DELETE_DRAFTING_BY_CONFIRM,
  BTN_ERP_ERROR_CONFIRM,
  BTN_GET_ERP_SO_NO_CNT,
  BTN_GET_SHIPMENT_STATUS,
  BTN_IF_CHECK,
  BTN_SAVE_DRAFTING,
  ERP_BLOCK_COMBO,
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
  SHEETS,
} from '../shipment-plan-auto-ess.constants';

import {
  buildDraftingUnits,
  collectDraftingSaveRows,
  erpSoNoOf,
  type ErpErrorItem,
  parseErpErrors,
  rowActiveFlag,
} from './shipment-plan-auto-ess.save';

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
  /** 예/아니오 확인. onYes 는 '예' 클릭 처리 안에서 바로 불린다(새 탭 열기용). */
  confirm: (content: string, onYes?: () => void) => Promise<unknown>;
  /** 'X'(기준정보 미등록) 안내의 '예' — 사내 매뉴얼 열기. */
  openManual: () => void;
  userId: string;
  timeZone: string;
  /** DRAFTING title — AS-IS siDetail.ActiveSheet.SheetName(cs L3469). */
  title: string;
}

// 카탈로그 문구의 '{0}' 치환 + 이스케이프 개행 정규화 — ShipmentPlanAutoEss.tsx fmtMsg 와 같은 처리.
const fmt = (deps: ErpChainDeps, code: string, fallback: string, arg0?: string): string => {
  const raw = deps.t(code, fallback);
  const filled = arg0 === undefined ? raw : raw.replace('{0}', arg0);
  return filled.replace(/\\r/g, '').replace(/\\n/g, '\n');
};

export const procPath = (btn: string): string => `/${MENU_ID}/${SHEETS.MAIN}/${btn}/call-proc`;

// 인터셉터가 403·500 도 resolve 하므로 HTTP 상태와 code 를 함께 본다(np §5-10).
const isFailed = (res: ProcResponse): boolean =>
  res.status >= 400 || !!Number((res.data as { code?: unknown } | undefined)?.code);

const resultOf = (res: ProcResponse): Record<string, unknown> =>
  (res.data as { result?: Record<string, unknown> } | undefined)?.result ?? {};

const cursor = (res: ProcResponse, key: string): Row[] => {
  const v = resultOf(res)[key];
  return Array.isArray(v) ? (v as Row[]) : [];
};

/** 예외는 status 0 응답으로 바꾼다 — 호출부가 상태로만 판단하게 한다. */
const safePost = async (deps: ErpChainDeps, url: string, body: unknown): Promise<ProcResponse> => {
  try {
    return await deps.post(url, body);
  } catch {
    return { status: 0 };
  }
};

/** 403 안내 문구 — MSG01125("사용 권한이 없습니다.") + 버튼 경로(SSP0021/main/{버튼코드}). */
export const routeMissingText = (deps: ErpChainDeps, btn: string): string =>
  `${deps.t(MSG.BTN_NO_AUTH, '__You do not have permission.')}\n[HTTP 403] ${MENU_ID}/${SHEETS.MAIN}/${btn}`;

/** 송신 전 단계 실패 안내 — 403 이면 MSG01125 + 경로, 그 외 MSG00003. */
const alertStepFailure = async (deps: ErpChainDeps, btn: string, res: ProcResponse): Promise<void> => {
  await deps.alert(
    res.status === 403 ? routeMissingText(deps, btn) : deps.t(MSG.SAVE_FAILED, '__Save failed.')
  );
};

// ── ⓪ ERP 중단기간 ─────────────────────────────────────────────────────────────

/**
 * AS-IS chkERPIFBlockYn(cs L2922~2945): Data_SCP.Common(SSPBlockCheckIF, false, "SSP0021") 첫 행 BLOCK_YN='Y' 면
 *   MSG00267(→ TO-BE MSG01275, {0}=PERIOD) 후 저장 중단. 0행이면 통과. SSP0060 checkErpBlock 과 같은 콤보·판단을
 *   화면 안에 둔다. 콤보 조회 자체가 실패하면 판정 근거가 없어 통과시킨다(차단으로 올리면 저장이 영구 불가 —
 *   SSP0060·SSP0200 과 같은 판단).
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
      MSG.ERP_BLOCK_PERIOD,
      '__The SSP shipment change request cannot be used during the ERP system downtime below. {0}',
      str(first.PERIOD ?? first.NAME)
    )
  );
  return false;
};

// ── ①② 사전 검사 ──────────────────────────────────────────────────────────────

/**
 * 행 순서대로 상태 재검증 + SO 건수(cs L3215~3259). 신규(I) 행은 상태 검사를 하지 않는다(cs L3223).
 *   AS-IS 는 EDIT_MAIN='Y' 인 행의 CONFIRM_ID 로 부른다(cs L3221~3222). 세 커서를 차례로 모두 알린 뒤 멈춘다
 *   (cs L3878~3918). 같은 SO 는 전건이 한 화면에 조회돼 있어야 SO 단위로 바꿀 수 있다(MSG00247).
 */
export const precheckRows = async (
  deps: ErpChainDeps,
  dirty: Row[],
  gridRows: Row[]
): Promise<boolean> => {
  const idList = (cur: Row[]): string =>
    cur
      .map(c => str(c.CONFIRM_ID).trim())
      .filter(Boolean)
      .join(',');
  const soCnt = new Map<string, number>();
  for (const row of dirty) {
    const divisionId = str(row.DIVISION_ID);
    const statusConfirmId = str(row.EDIT_MAIN) === 'Y' ? str(row.CONFIRM_ID).trim() : '';
    if (rowActiveFlag(row) !== 'I' && statusConfirmId) {
      const st = await safePost(deps, procPath(BTN_GET_SHIPMENT_STATUS), {
        divisionId,
        confirmId: statusConfirmId,
      });
      if (isFailed(st)) {
        await alertStepFailure(deps, BTN_GET_SHIPMENT_STATUS, st);
        return false;
      }
      const hits: [string, string, Row[]][] = [
        [
          MSG.STATUS_OTHER_USER_REQUEST,
          '__A Confirm ID for which another user requested a shipment plan change exists. {0}',
          cursor(st, 'o_rc1'),
        ],
        [MSG.STATUS_DELETED_QTY0, '__A deleted (Qty:0) Confirm ID exists. {0}', cursor(st, 'o_rc2')],
        [
          MSG.STATUS_ERP_DO_CREATED,
          '__In ERP, a DO has been created and the change cannot be requested. {0}',
          cursor(st, 'o_rc3'),
        ],
      ];
      let blocked = false;
      for (const [code, fallback, cur] of hits) {
        if (cur.length === 0) continue;
        blocked = true;
        await deps.alert(fmt(deps, code, fallback, idList(cur)));
      }
      if (blocked) return false;
    }
    const so = erpSoNoOf(row);
    if (!so) continue;
    const key = `${divisionId}|${so}`;
    let dbCnt = soCnt.get(key);
    if (dbCnt === undefined) {
      const r = await safePost(deps, procPath(BTN_GET_ERP_SO_NO_CNT), { divisionId, erpSoNo: so });
      if (isFailed(r)) {
        await alertStepFailure(deps, BTN_GET_ERP_SO_NO_CNT, r);
        return false;
      }
      dbCnt = Number(cursor(r, 'o_rc1')[0]?.CNT ?? 0);
      soCnt.set(key, dbCnt);
    }
    const sheetCnt = gridRows.filter(r => erpSoNoOf(r) === so).length;
    if (dbCnt !== sheetCnt) {
      await deps.alert(
        fmt(
          deps,
          MSG.SO_NO_COUNT_MISMATCH,
          '__Another item created with the same SO number exists. [ SO NO : {0} ]',
          so
        )
      );
      return false;
    }
  }
  return true;
};

/** 2분 잠금 — 변경 행 전체의 CONFIRM_ID 를 '^' 로 접어 1회(cs L3256·L3262~3269). 'S' 만 통과. */
export const checkChangeTime = async (deps: ErpChainDeps, confirmIds: string[]): Promise<boolean> => {
  if (confirmIds.length === 0) return true;
  const chk = await safePost(deps, procPath(BTN_CHECK_CONFIRM_CHANGETIME), {
    confirmId: confirmIds.join('^'),
  });
  if (isFailed(chk)) {
    await alertStepFailure(deps, BTN_CHECK_CONFIRM_CHANGETIME, chk);
    return false;
  }
  if (str(cursor(chk, 'o_rc1')[0]?.RESULT_CODE) !== 'S') {
    await deps.alert(
      fmt(
        deps,
        MSG.CONFIRM_CHANGETIME_LOCK,
        '__Due to ERP I/F, changes can be made after 2 minutes of previous work.'
      )
    );
    return false;
  }
  return true;
};

// ── ③ 송신 ────────────────────────────────────────────────────────────────────

/** ERP 송신 — AS-IS FN_ERP_UIWebService(RequestNo,"C","")(cs L3991). HTTP 실패·예외는 C_E(CallClient catch). */
export const sendErp = async (
  deps: ErpChainDeps,
  reqNo: string
): Promise<{ eType: string; eMessage: string }> => {
  const erp = await safePost(deps, ERP_IF_PATH, {
    CHANGE_REQ_NO: reqNo,
    CHANGE_TYPE: ERP_IF_CHANGE_TYPE,
    SHIPMENT_STATUS: '',
  });
  if (isFailed(erp)) return { eType: ERP_IF_PI_FAIL, eMessage: '' };
  const r = resultOf(erp) as { E_TYPE?: unknown; E_MESSAGE?: unknown };
  return { eType: str(r.E_TYPE), eMessage: str(r.E_MESSAGE) };
};

/** 단계 호출 실패 기록 — 루프 뒤에 모아서 알린다. */
export interface StepFailure {
  btn: string;
  status: number;
  changeReqNo: string;
}

export interface ErpChainOutcome {
  /** false 면 CONFIRM 을 하지 않는다. */
  proceed: boolean;
  /** CONFIRM 대상 행(ERP 거절 CONFIRM_ID 행·초안 실패 단위 행 제외). */
  confirmRows: Row[];
}

const STOP: ErpChainOutcome = { proceed: false, confirmRows: [] };

/**
 * ⓪~④ 전체. 반환 confirmRows 로 호출부가 CONFIRM(planDetail/SAVE) 를 부른다.
 *   dirty = 하단 변경 행(EDIT_MAIN='Y' 또는 CRUD_TYPE), gridRows = 하단 전체 행(SO 행수 비교용).
 */
export const runErpChain = async (
  deps: ErpChainDeps,
  dirty: Row[],
  gridRows: Row[]
): Promise<ErpChainOutcome> => {
  if (!(await checkErpBlock(deps))) return STOP;
  if (!(await precheckRows(deps, dirty, gridRows))) return STOP;
  const allConfirmIds = Array.from(
    new Set(dirty.map(r => str(r.CONFIRM_ID).trim()).filter(id => id !== '' && id !== '-'))
  );
  if (!(await checkChangeTime(deps, allConfirmIds))) return STOP;

  const excludedIds = new Set<string>(); // AS-IS errConfrimList2 — ERP 가 거절한 CONFIRM_ID(cs L4011)
  const excludedRows = new Set<Row>(); // 초안 저장에 실패한 단위의 행
  const erpErrors: (ErpErrorItem & { changeReqNo: string })[] = []; // AS-IS errConfirmList(cs L4007)
  // AS-IS 는 F·C_E 요청번호를 칸 1개(F_CE_requestNo, cs L4066)에 담아 마지막 단위만 보상한다.
  //   TO-BE 는 단위별로 모아 전부 보상한다(그 단위 행의 CONFIRM_ID 만).
  const fce: { changeReqNo: string; confirmIds: string[] }[] = [];
  const stepFailures: StepFailure[] = [];
  let anyActive = false; // AS-IS bActiveList 에 true 가 있는가(cs L3320~3329)
  let lastOk = true; // AS-IS 루프의 마지막 bReturn
  let sentAny = false; // ERP 송신이 한 번이라도 일어났는가(이후 403 은 중단하지 않고 기록)

  // 초안 되돌림 — AS-IS SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(cs L4019~4031, L3393~3405).
  //   PROC 메타 키는 userId 다(lastUpdatedBy 로 보내면 NULL 바인딩 — 결함 D-1).
  const deleteDrafting = async (confirmIds: string[], reqNo: string): Promise<void> => {
    if (confirmIds.length === 0) return;
    const res = await safePost(deps, procPath(BTN_DELETE_DRAFTING_BY_CONFIRM), {
      confirmId: confirmIds.join('^'),
      changeRequestNo: reqNo,
      delFlag: ERP_DELETE_FLAG,
      userId: deps.userId,
      timeZone: deps.timeZone,
      ifSendFlag: ERP_IF_SEND_ON,
      changeType: ERP_IF_CHANGE_TYPE,
    });
    if (isFailed(res)) {
      stepFailures.push({ btn: BTN_DELETE_DRAFTING_BY_CONFIRM, status: res.status, changeReqNo: reqNo });
    }
  };

  // 2차 적재 + 2차 송신 — AS-IS CHG_BATCH('B', REQ)(cs L4045·L4075) + FN_ERP 재호출(cs L4055·L4085).
  //   TO-BE 는 SSP0015 와 같이 PKG_SSP0003.P_SSP0003_SAVE_REQ_IF_CHECK 를 빌려 쓴다.
  //   - 403: 메타 미등록이라 'B' XIF 행이 아예 생기지 않고 1분 배치로도 복구되지 않는다. 확정하면 ERP 와 고정
  //     불일치가 되므로 호출부가 그 단위를 F 경로(초안 되돌림 + 삭제 반영 송신 + CONFIRM 제외)로 보낸다
  //     (SSP0060·SSP0023 과 같은 판단). 안내는 루프 뒤 MSG01125+경로 1회 + MSG01215(요청번호).
  //   - 그 밖의 실패: AS-IS 는 적재 결과를 보지 않고 진행하므로 단위는 성공으로 두되, 실패를 기록해
  //     루프 뒤 MSG01215(요청번호)로 알린다(2차 송신은 건너뜀).
  //   반환 false = 403(호출부가 F 경로로 처리).
  const stageAndResend = async (reqNo: string): Promise<boolean> => {
    const res = await safePost(deps, procPath(BTN_IF_CHECK), {
      changeRequestNo: reqNo,
      changeStatus: IF_CHECK_STATUS_APPLY,
      timeZone: deps.timeZone,
      changeType: ERP_IF_CHANGE_TYPE,
      partialApproval: IF_CHECK_PARTIAL_OFF,
    });
    if (isFailed(res)) {
      stepFailures.push({ btn: BTN_IF_CHECK, status: res.status, changeReqNo: reqNo });
      return res.status !== 403;
    }
    await sendErp(deps, reqNo);
    return true;
  };

  // F 경로 — 단위 행 전체를 CONFIRM 에서 빼고, 보상(초안 되돌림 + 삭제 반영 송신 + MSG01215)은 루프 뒤에 한다.
  const markFce = (unit: Row[], reqNo: string, confirmIds: string[]): void => {
    fce.push({ changeReqNo: reqNo, confirmIds });
    unit.forEach(r => excludedRows.add(r));
    lastOk = false;
  };

  for (const unit of buildDraftingUnits(dirty)) {
    const unitIds = unit.map(r => str(r.CONFIRM_ID).trim()).filter(Boolean);
    const payload = collectDraftingSaveRows(unit, {
      userId: deps.userId,
      // AS-IS UserInfoContext[Dept_ID](cs L3455). TO-BE 세션에 부서가 없어 공란이다(잔여).
      userDeptId: '',
      title: deps.title,
      programId: MENU_ID,
    });
    if (!payload) continue;
    const res = await safePost(deps, procPath(BTN_SAVE_DRAFTING), payload);
    if (res.status === 403 && !sentAny) {
      // 메타 미등록 — 아직 송신한 단위가 없으니 여기서 멈춘다(단위마다 같은 403).
      await deps.alert(routeMissingText(deps, BTN_SAVE_DRAFTING));
      return STOP;
    }
    const d1 = cursor(res, 'o_rc1')[0];
    const reqNo = str(d1?.REQUEST_NO);
    // AS-IS cs L3564~3610: 'S' + 요청번호 → 송신 / 'X' → MSG00324(TO-BE MSG01321)+매뉴얼 / 그 외 MSG00284.
    //   AS-IS 는 실패 단위가 있어도 다른 단위가 성공하면 실패 단위 행까지 CONFIRM 한다. TO-BE 는 초안·ERP 없이
    //   원장이 바뀌지 않도록 실패 단위 행을 CONFIRM 에서 뺀다.
    if (isFailed(res) || str(d1?.RESULT_CODE) !== 'S' || !reqNo) {
      unit.forEach(r => excludedRows.add(r));
      lastOk = false;
      if (res.status === 403) {
        // 송신 뒤 403 — 중단하지 않고 단위 실패로 기록한다. 뒤 단위도 같은 403 이므로 안내는 루프 뒤 1회
        //   (stepFailures 가 403 을 버튼별로 한 번만 알린다).
        stepFailures.push({ btn: BTN_SAVE_DRAFTING, status: 403, changeReqNo: '' });
      } else if (str(d1?.RESULT_CODE) === 'X') {
        await deps.confirm(
          deps.t(MSG.STD_INFO_NOT_REGISTERED, '_기준정보가 등록되어 있지 않습니다. 참고자료를 열람하시겠습니까?'),
          deps.openManual
        );
      } else {
        await deps.alert(
          str(d1?.ERR_MESSAGE) ||
            str(cursor(res, 'o_rc2')[0]?.ERR_MESSAGE) ||
            deps.t(MSG.SAVE_FAILED, '__Save failed.')
        );
      }
      continue;
    }

    sentAny = true;
    const { eType, eMessage } = await sendErp(deps, reqNo);
    if (!eType || eType === ERP_IF_SUCCESS) {
      // 정상(cs L4070~4089) — 2차 적재 + 2차 송신. IF_CHECK 403 이면 F 경로.
      if (!(await stageAndResend(reqNo))) {
        markFce(unit, reqNo, unitIds);
        continue;
      }
      anyActive = true;
      lastOk = true;
      continue;
    }
    if (eType === ERP_IF_ERROR || eType === ERP_IF_PARTIAL_ERROR) {
      // cs L3993~4061 — S_E 는 거절된 CONFIRM 만 초안 되돌림 후 남은 성공분으로 2차 적재·송신하고 진행.
      //   E(전건 거절)는 E_MESSAGE 에 일부 CONFIRM_ID 만 나열돼도 단위 전체가 거절된 것이다 — 단위 행 전체를
      //   CONFIRM 에서 빼고 단위 전체 CONFIRM_ID 로 되돌린다(SSP0060·SSP0023 과 같은 판단). 오류 적재는 파싱된 ID 기준.
      // 이 단위의 CONFIRM_ID 로 확인되는 항목만 쓴다. ':' 없는 문구는 parseErpErrors 가 통째로 ID 로 읽으므로
      //   단위 ID 와 맞춰 봐야 "못 읽음" 을 가릴 수 있다.
      const items = parseErpErrors(eMessage).filter(e => unitIds.includes(e.confirmId));
      if (items.length === 0) {
        // 거절인데 CONFIRM_ID 를 하나도 못 읽으면 어느 행이 거절됐는지 알 수 없다 — F 경로로 단위 전체를
        //   되돌리고 CONFIRM 에서 뺀다. IF_CHECK·2차 송신은 하지 않는다(SSP0060·SSP0023 과 같은 판단).
        markFce(unit, reqNo, unitIds);
        continue;
      }
      items.forEach(e => {
        erpErrors.push({ ...e, changeReqNo: reqNo });
        excludedIds.add(e.confirmId);
      });
      if (eType === ERP_IF_ERROR) {
        unit.forEach(r => excludedRows.add(r));
        await deleteDrafting(unitIds, reqNo);
        lastOk = false;
        continue;
      }
      const rejected = new Set(items.map(e => e.confirmId));
      await deleteDrafting(Array.from(rejected), reqNo);
      if (!(await stageAndResend(reqNo))) {
        // 남은 성공분도 'B' 적재가 안 됐으니 F 경로로 되돌린다(거절분은 위에서 이미 되돌림).
        markFce(
          unit,
          reqNo,
          unitIds.filter(id => !rejected.has(id))
        );
        continue;
      }
      anyActive = true;
      lastOk = true;
      continue;
    }
    // F · C_E(cs L4064~4067) — 보상은 루프 뒤에서 단위별로 한다.
    markFce(unit, reqNo, unitIds);
  }

  // ④ 결과 처리(cs L3320~3417). 진행 여부 = 마지막 단위 결과, 성공 단위가 하나라도 있으면 진행.
  const proceed = lastOk || anyActive;
  if (erpErrors.length > 0) {
    const res = await safePost(deps, procPath(BTN_ERP_ERROR_CONFIRM), {
      changeRequestNo: erpErrors.map(e => e.changeReqNo).join('^'),
      confirmId: erpErrors.map(e => e.confirmId).join('^'),
      eType: ERP_ERROR_E_TYPE,
      eMessage: erpErrors.map(e => e.message).join('^'),
      userId: deps.userId, // PROC 메타 키는 userId(결함 D-1)
    });
    if (isFailed(res)) {
      Array.from(new Set(erpErrors.map(e => e.changeReqNo))).forEach(changeReqNo =>
        stepFailures.push({ btn: BTN_ERP_ERROR_CONFIRM, status: res.status, changeReqNo })
      );
    }
  }
  if (erpErrors.length > 0) {
    const lines = erpErrors.map(e => `${e.confirmId}:${e.message}`);
    await deps.alert(
      fmt(deps, MSG_ERP.ISSUE, '__ERP cannot be processed due to an ISSUE. {0}', lines.join('\n'))
    );
  }
  // F·C_E — AS-IS 는 ERP 오류 목록이 있으면 이 보상을 건너뛰고(else if, cs L3368) 마지막 요청번호 하나만,
  //   변경 행 전체 CONFIRM_ID 로 지운다(cs L3370~3409). TO-BE 는 오류 목록과 무관하게, 단위마다 그 단위 행의
  //   CONFIRM_ID 로 지우고 삭제 반영 송신(cs L3409)까지 한다.
  if (fce.length > 0) {
    for (const f of fce) {
      await deleteDrafting(f.confirmIds, f.changeReqNo);
      await sendErp(deps, f.changeReqNo);
    }
    await deps.alert(
      fmt(
        deps,
        MSG_ERP.SYSTEM_ERROR,
        '__System error. Request No : {0}',
        fce.map(f => f.changeReqNo).join(', ')
      )
    );
    // AS-IS 는 여기서 저장 전체를 멈춘다(bReturn=false). TO-BE 는 F·C_E 단위 행을 CONFIRM 에서 이미 뺐으므로
    //   이미 ERP 에 간 다른 성공 단위는 CONFIRM 까지 간다(진행 여부는 위 proceed 그대로).
  }
  // 보상·적재 호출 실패 안내 — 403 은 MSG01125 + 경로, 그 외는 MSG01215(요청번호).
  if (stepFailures.length > 0) {
    const forbidden = Array.from(
      new Set(stepFailures.filter(f => f.status === 403).map(f => f.btn))
    );
    for (const btn of forbidden) await deps.alert(routeMissingText(deps, btn));
    const others = Array.from(
      new Set(stepFailures.filter(f => f.status !== 403).map(f => f.changeReqNo))
    );
    if (others.length > 0) {
      await deps.alert(
        fmt(deps, MSG_ERP.SYSTEM_ERROR, '__System error. Request No : {0}', others.join(', '))
      );
    }
  }
  if (!proceed) return STOP;

  // ⑤ CONFIRM 대상 — ERP 가 거절한 CONFIRM_ID 행·실패 단위 행은 뺀다(cs L2613~2627).
  return {
    proceed: true,
    confirmRows: dirty.filter(r => !excludedRows.has(r) && !excludedIds.has(str(r.CONFIRM_ID).trim())),
  };
};
