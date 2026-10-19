/**
 * SSP0201 기존행(수정) 저장 — AS-IS `GetERPInterface()` 의 **2번째 루프**.
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs
 *   GetERPInterface(L3541) 2번 루프 — `action != 'I'` 인 행을 DRAFTING SP 로 저장한다.
 *     ERP_SO_NO 없음 -> `NonSoNo(i, action)`        — 행마다 1콜
 *     ERP_SO_NO 있음 -> `SoNo(i, action, erpSoNo…)` — 같은 SO 전 행을 묶어 1콜(중복 가드)
 *   어느 쪽이든 `CHANGE_TYPE='P'` 행은 제외된다.
 *
 * **왜 `useProcMutation` 을 쓰면 안 되나** (이 파일이 존재하는 이유):
 *   공용 `useProcMutation` 은 `{ data: [행…] }` 형태로 보낸다. 그 경로는 BE 가 `JVARCHAR` 메타를 보고
 *   행 배열을 인자로 펼치는데, `P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING` 의 PROC_M 에는 `JVARCHAR`
 *   항목이 **없다**. 그래서 37개 인자가 전부 NULL 로 바인딩되고, SP 는 NULL 입력으로도 예외 없이
 *   끝나 `RESULT_CODE='S'` 를 돌려준다 — **아무것도 저장되지 않았는데 성공 토스트가 뜨는** 상태였다.
 *   신규행 경로(`submitNewDrafting`)와 같이 **평탄 객체로 `apiClient.post`** 해야 인자가 실린다.
 *
 * 전송 규약(PROC_M 실측 — 신규행 경로와 동일한 SP 라 인자 집합도 같다):
 *   37 IN 중 **VARCHAR2 5개가 스칼라**(changeType·userId·userDeptId·changeReqNo·programId),
 *   나머지 **32개가 CLOB** = 행 단위다. SP 가 `F_SPL_CNT(P_ACTIVE_FLAG)` 로 루프 수를 정하고 전 CLOB 를
 *   그 수로 split 하므로 **32개 토큰 수가 전부 같아야 한다** — 한 인자만 어긋나도 값이 행 경계를 넘어
 *   밀려서 ERP 전송행에 잘못된 출하일·수량이 적재된다. 빈 값도 자리를 지켜 join 한다.
 *
 * 신규행 경로(`submitNewDrafting`)와 **원천 컬럼이 5개 다르다** — 재사용하면 조용히 틀린다:
 *   activeFlag        <- 행 CRUD_TYPE   (신규는 'I' 고정)
 *   changeType        <- 'C' 고정        (신규는 'N')
 *   editMain          <- 행 EDIT_MAIN   (신규는 'Y' 고정)
 *   newIncoterms      <- INCOTERMS      (신규는 NEW_INCOTERMS)
 *   newTransportMode  <- TRANSPORT_MODE (신규는 NEW_TRANSPORT_MODE)
 */

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  PLAN_TYPE_PLAN,
  SHEETS,
} from '../shipment-change-request.constants';

import { BTN_SAVE_DRAFTING, FOLD, s, toSpDateTime } from './shipmentChangeRequestNewSave';
import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type SaveOutcome,
} from './shipmentChangeRequestResult';

type Row = Record<string, unknown>;

/** `changeType` 스칼라 고정값 — AS-IS 가 수정 저장에 'C'(Confirm)를 박아 보낸다. */
const CHANGE_TYPE_CONFIRM = 'C';

/** 수정저장 **대상** action — AS-IS `if (action != FlagI)` 가 'I' 를 제외한 나머지다. */
const MODIFY_ACTIONS: readonly string[] = [CRUD_TYPE.MODIFY, CRUD_TYPE.DELETE];
/**
 * SO 묶음 **멤버** 자격 — AS-IS 는 I/M/D 전부를 같은 SO 묶음에 담는다.
 *   현재 호출부는 신규행이 0건일 때만 이 경로를 타므로 'I' 는 사실상 걸리지 않지만, AS-IS 규칙을
 *   그대로 둔다(신규+수정 혼재 처리가 들어오는 다음 단계에서 이 자격이 실제로 쓰인다).
 */
const GROUP_ACTIONS: readonly string[] = [CRUD_TYPE.INSERT, CRUD_TYPE.MODIFY, CRUD_TYPE.DELETE];

/**
 * 호출 단위를 복원한다 — 자매 SSP0200 `draftingModifyGroups` 와 **같은 규칙**을 이 폴더에 복제한 것이다
 *   (화면 간 import 금지, CORE-05 Hard Boundary). 원본: shipment-change-request-plan/utils/
 *   shipmentChangeRequestPlanSave.ts.
 *
 *   ERP_SO_NO 없음 -> 행마다 1묶음(NonSoNo) · 있음 -> 같은 SO 전 행 1묶음(SoNo, 중복 가드).
 *   CHANGE_TYPE='P' 행은 양쪽 모두에서 제외한다.
 *
 * AS-IS 차이(의도적 교정 — 자매 SSP0200 과 같은 판단): AS-IS `SoNo` 는 `iCallChk > 1` 이면
 *   2번째 이후 SO 묶음을 **조용히 건너뛴다**. 서로 다른 SO 2건을 수정하면 한쪽이 저장되지 않고
 *   성공처럼 끝나므로 복제하지 않는다 — 여기서는 모든 묶음을 저장한다.
 */
export const draftingModifyGroups = (source: Row[]): Row[][] => {
  const isConvertible = (row: Row): boolean => s(row.CHANGE_TYPE) !== PLAN_TYPE_PLAN;
  const groups: Row[][] = [];
  const seenSoNo = new Set<string>();

  for (const row of source) {
    if (!MODIFY_ACTIONS.includes(s(row.CRUD_TYPE))) continue;
    if (!isConvertible(row)) continue;

    const soNo = s(row.ERP_SO_NO);
    if (!soNo) {
      groups.push([row]); // NonSoNo — 단일행
      continue;
    }
    if (seenSoNo.has(soNo)) continue; // SoNo 중복 가드
    seenSoNo.add(soNo);
    groups.push(
      source.filter(
        r => s(r.ERP_SO_NO) === soNo && GROUP_ACTIONS.includes(s(r.CRUD_TYPE)) && isConvertible(r)
      )
    );
  }
  return groups;
};

/**
 * 값 그대로 보내는 per-row 인자 <- 행 컬럼(28건).
 *   키 철자는 **PROC_M 실측 그대로**다. `newDContry`·`origionToDivisionId` 는 DB 쪽 오타인데
 *   고치면 바인드에 실패해 NULL 이 들어간다 — 교정 금지. (`newACountry` 는 정상 철자다.)
 */
const PLAIN_SOURCE: Record<string, string> = {
  divisionId: 'DIVISION_ID',
  confirmId: 'CONFIRM_ID',
  shipmentQty: 'SHIPMENT_CONFIRM_QTY',
  fromSite: 'FROM_SITE', // 코드열(FROM_SITE) — CONFIRM_NEW 의 DESCRIPTION 축과 다르다
  newBodId: 'NEW_BOD_ID',
  newRouteId: 'NEW_ROUTE_ID',
  newEtdDate: 'NEW_ETD', // 신규 경로와 동일하게 날짜 변환 없이 보낸다
  newEtaDate: 'NEW_ETA',
  newIncoterms: 'INCOTERMS', // 주의: NEW_INCOTERMS 아님(수정 경로의 축)
  newTransportMode: 'TRANSPORT_MODE', // 주의: NEW_TRANSPORT_MODE 아님
  newDContry: 'NEW_D_COUNTRY', // PROC_M 철자 그대로(오타 유지)
  newDPortCode: 'NEW_D_PORT_CODE',
  newACountry: 'NEW_A_COUNTRY',
  newAPortCode: 'NEW_A_PORT_CODE',
  newCustomerLt: 'NEW_CUSTOMER_LT',
  newToCountry: 'NEW_TO_COUNTRY',
  newToCity: 'NEW_TO_CITY',
  editMain: 'EDIT_MAIN', // 주의: 신규처럼 'Y' 로 고정하지 않는다 — 행 값이다
  editRemark: 'EDIT_REMARKS',
  electrodeYn: 'ELECTRODE_YN',
  electrodeType: 'ELECTRODE_TYPE',
  originFromDivisionId: 'ORIGIN_FROM_DIVISION_ID',
  origionToDivisionId: 'ORIGIN_TO_DIVISION_ID', // PROC_M 철자 그대로(오타 유지)
  remarks: 'REMARKS',
  remarks2: 'REMARKS2',
  remarks3: 'REMARKS3',
  changeReasonDetail: 'CHANGE_REASON_DETAIL',
  shiptoCode: 'TO_SITE_SHIPTO_CODE',
};

export interface DraftingModifySession {
  userId: string;
  /** 로그인 사용자 부서(AS-IS `UserInfoContext.Current["Dept_ID"]`). */
  userDeptId: string;
  /** 채번(GET_CHANGE_REQ_NO) 결과 = AS-IS `_ChangeReqno`. 스칼라라 묶음 전체가 한 번호를 공유한다. */
  changeReqNo: string;
}

/**
 * 묶음 1건의 전송 payload(37키 평탄 객체)를 만든다.
 *   32개 행단위 키는 `group.length` 만큼의 토큰을 갖고, 5개 스칼라는 결합하지 않는다.
 */
export const buildDraftingModifyPayload = (
  group: Row[],
  session: DraftingModifySession
): Record<string, string> => {
  // 행단위 32키 = PLAIN_SOURCE 28 + 아래 특수 4(activeFlag·changeReasonCode·title·shipmentDate).
  const acc: Record<string, string[]> = {
    activeFlag: [],
    changeReasonCode: [],
    title: [],
    shipmentDate: [],
  };
  for (const key of Object.keys(PLAIN_SOURCE)) acc[key] = [];

  for (const row of group) {
    acc.activeFlag.push(s(row.CRUD_TYPE)); // 신규는 'I' 고정 — 여기는 행 값(M/D)이다
    // 콤보 더미 '-' 는 저장하지 않는다(신규 경로와 동일 규칙).
    acc.changeReasonCode.push(s(row.CHANGE_REASON_CODE).replace(/-/g, ''));
    // title 은 스칼라가 아니다 — AS-IS 가 시트명을 행마다 반복해 싣는다.
    acc.title.push(ADMIN_SHEET_NAME[SHEETS.MAIN]);
    acc.shipmentDate.push(toSpDateTime(row.SHIPMENT_DATE));
    for (const [param, column] of Object.entries(PLAIN_SOURCE)) acc[param].push(s(row[column]));
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join(FOLD);
  // 스칼라 5건(ALL_ARGUMENTS VARCHAR2) — 행 수와 무관하게 결합하지 않는다.
  payload.changeType = CHANGE_TYPE_CONFIRM;
  payload.userId = session.userId;
  payload.userDeptId = session.userDeptId;
  payload.changeReqNo = session.changeReqNo;
  payload.programId = MENU_ID;
  return payload;
};

export interface ModifySaveResult {
  /** 통일 판정값(shipmentChangeRequestResult). 'ok' 만 저장 성공이다. */
  outcome: SaveOutcome;
  /** SP RESULT_CODE — 'X'(BOD/Trans mode 무효) 분기 메시지용. unknown 이면 ''. */
  code: string;
  /** 이 묶음이 실은 행 수 — 성공 토스트의 실제 건수 누적용. */
  rowCount: number;
}

/**
 * 수정행 묶음 1건을 변경요청 초안으로 저장한다.
 *   성공 판정은 공통 `judgeSaveResponse` 에 맡긴다 — HTTP 200 + code:0 이어도 RESULT_CODE 가 'S' 가
 *   아니면 저장되지 않았다. 'X'(BOD 무효)는 'S' 가 아니므로 **fail** 로 떨어진다.
 */
export const submitDraftingModifySave = async (
  group: Row[],
  session: DraftingModifySession
): Promise<ModifySaveResult> => {
  const payload = buildDraftingModifyPayload(group, session);
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SAVE_DRAFTING}/call-proc`,
      payload
    );
    const outcome = judgeSaveResponse(res);
    // unknown 은 본문을 믿을 수 없다는 뜻이라 code 를 읽지 않는다(엉뚱한 'X' 메시지 방지).
    return {
      outcome,
      code: outcome === 'unknown' ? '' : readResultCode(res.data),
      rowCount: group.length,
    };
  } catch (error) {
    return { outcome: judgeSaveError(error), code: '', rowCount: group.length };
  }
};
