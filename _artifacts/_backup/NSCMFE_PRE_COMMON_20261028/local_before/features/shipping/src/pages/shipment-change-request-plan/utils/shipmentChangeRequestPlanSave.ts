// SSP0200 SaveButton 저장 — PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_CONFIRM_NEW(31 IN) payload 조립.
//
// 이 SP 는 31개 IN 인자가 전부 **CLOB 평면 문자열**이고 행들을 '^' 로 이어 받는다
//   (ALL_ARGUMENTS 실측: P_ACTIVE_FLAG~P_ERP_ATTR3 CLOB, P_USER_ID/P_TIME_ZONE 만 VARCHAR2.
//    PKG 본문 주석 "저장 계열의 '^' 구분 문자열 분리 규칙은 SCM_ARR_SPL_CNT·SCM_ARR_SPL_VAL 과 같다").
//   그래서 `useProcMutation`(행 배열 전송)으로는 바인딩되지 않는다 — BaseService 는 `params.get(COL_NM)`
//   으로 파라미터를 찾는데 행 키는 UPPER_SNAKE 라 31개 전건 NULL 이 되고, 성공 토스트만 뜬다
//   (메모리 scp-clob-save-needs-flat-caret-payload / procedures-dts-save-request-never-typechecked).
//   정본 패턴 = features/supply/.../projectRoute.plantSaveRequest.ts.
//
// 파라미터명은 SCM_ADM_PROC_M.COL_NM 실측(camelCase) 그대로다 — **오타 `aConuntry` 도 그대로 보낸다**.
//   맞춤법을 고치면 그 인자가 NULL 로 바인딩된다(design 03 §4.4).
// 행→인자 대응은 AS-IS 정본 cs:1010~1030(SaveButton) 실측이다. 추측 없음.

import { apiClient } from '@foundation/apis';

import {
  ADMIN_SHEET_NAME,
  BTN_ERP_IFSEQ_MERGE,
  BTN_SAVE_DRAFTING,
  CHANGE_TYPE_CONFIRM,
  CHANGE_TYPE_NEW,
  CHANGE_TYPE_PLAN,
  COLUMN,
  CRUD_INSERT,
  DRAFTING_GROUP_ACTIONS,
  DRAFTING_MODIFY_ACTIONS,
  ERP_IF_CHANGE_TYPE,
  ERP_IF_PATH,
  IFSEQ_MERGE_STATUS,
  MENU_ID,
  SHEETS,
} from '../shipment-change-request-plan.constants';

import { str, type GridRowData } from './shipmentChangeRequestPlanDerive';

export interface SaveResult {
  /** SP o_rc1 1행 1열 — 'S' 성공 / 'N' Model 미조회 / 'F' 저장실패 / 'X' SoldTo·ShipTo 오류. */
  code: 'S' | 'N' | 'F' | 'X' | '';
  /** 'X' 경로의 상세(reason_id + division_id + to_site) 또는 HTTP/BE 오류 문구. */
  message: string;
  /** 통신·false-success 판정 결과. false 면 code 는 신뢰할 수 없다. */
  ok: boolean;
}

interface SaveSession {
  userId: string;
  /** TO-BE UserSession 에 타임존 필드가 없다(실측) — 빈 값으로 보내 SP 기본 처리에 맡긴다. */
  timeZone: string;
}

// 날짜 인자는 8자리 숫자로 보낸다.
//   근거: 이관된 SP 가 토큰을 8자리 VARCHAR 칼럼과 직접 비교한다
//   (PKG_SSP0200 본문 2182~2183 `A.FROM_YYYYMMDD <= V_SHIPMENT_DATE` / SCP_MST_BOD_N_V 실측 '20220411').
//   AS-IS 는 'yyyy-MM-dd HH:mm:ss.fff' 를 보냈지만(MSSQL 은 datetime 변환) 그 문자열을 그대로 보내면
//   하이픈 때문에 범위 비교가 전건 참이 되어 BOD 가 조용히 잘못 잡힌다 — 차이와 근거를 04 에 기록했다.
const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

// 31 IN 인자 ← 행 컬럼 대응(AS-IS cs:1010~1030). 값 그대로 보내는 인자만 여기 둔다.
const PLAIN_PARAM_SOURCE: Record<string, string> = {
  divisionId: COLUMN.DIVISION_ID,
  fromSite: COLUMN.FROM_SITE_DESCRIPTION, // GetValue = 코드값(SCM_SITE_ID)
  toSite: COLUMN.TO_SITE_DESCRIPTION,
  projectCode40: COLUMN.END_CUSTOMER, // 주의: projectCode 와 별개 인자다(div40 분기)
  projectCode: COLUMN.PROJECT_CODE,
  fcstType: COLUMN.FCST_TYPE,
  itemId: COLUMN.ITEM_ID,
  shipmentQty: COLUMN.SHIPMENT_CONFIRM_QTY,
  incoterms: COLUMN.INCOTERMS,
  transportMode: COLUMN.TRANSPORT_MODE,
  lt: COLUMN.NEW_CUSTOMER_LT,
  routeId: COLUMN.NEW_ROUTE_ID,
  bodId: COLUMN.NEW_BOD_ID,
  dCountry: COLUMN.NEW_D_COUNTRY,
  dPortCode: COLUMN.NEW_D_PORT_CODE,
  aConuntry: COLUMN.NEW_A_COUNTRY, // SP 실명 오타 유지
  aPortCode: COLUMN.NEW_A_PORT_CODE,
  toCountry: COLUMN.NEW_TO_COUNTRY,
  toCity: COLUMN.NEW_TO_CITY,
  remarks: COLUMN.REMARKS,
  remarks2: COLUMN.REMARKS2,
  remarks3: COLUMN.REMARKS3,
  erpAttr1: COLUMN.ERP_ATTR1,
  erpAttr2: COLUMN.ERP_ATTR2,
  erpAttr3: COLUMN.ERP_ATTR3,
};

const DATE_PARAM_SOURCE: Record<string, string> = {
  shipmentDate: COLUMN.SHIPMENT_DATE,
  etd: COLUMN.NEW_ETD,
  eta: COLUMN.NEW_ETA,
};

/** SaveButton 대상 행 = `CRUD_TYPE='I'` 만이다(AS-IS cs:1005 `if (action != FlagI) continue`). */
export const saveTargetRows = (rows: GridRowData[]): GridRowData[] =>
  rows.filter(r => str(r.CRUD_TYPE) === CRUD_INSERT);

// SP 반환코드 읽기 — 성공 커서가 RESULT_CODE 외에 부가열(REQUEST_NO/CONFRIMID)을 함께 돌려줄 때
//   위치([0])로 읽으면 부가열을 코드로 오인한다(2026-09-30: DRAFTING 성공인데 REQUEST_NO 'R…' 를
//   실패코드로 오판). call-proc 결과맵은 열 순서를 보장하지 않으므로 **RESULT_CODE 를 이름으로** 읽는다.
//   행 컬럼 키는 getColumnLabel 로 대문자다(BaseService §503). 못 찾을 때만 위치로 폴백한다.
const readResultCode = (row: Record<string, unknown> | undefined): string =>
  row ? str(row.RESULT_CODE ?? row.result_code ?? Object.values(row)[0]) : '';

export const buildConfirmNewPayload = (
  targets: GridRowData[],
  session: SaveSession
): Record<string, string> => {
  const acc: Record<string, string[]> = { activeFlag: [] };
  for (const key of Object.keys(PLAIN_PARAM_SOURCE)) acc[key] = [];
  for (const key of Object.keys(DATE_PARAM_SOURCE)) acc[key] = [];

  for (const row of targets) {
    acc.activeFlag.push(CRUD_INSERT);
    for (const [param, column] of Object.entries(PLAIN_PARAM_SOURCE)) {
      acc[param].push(str(row[column]));
    }
    for (const [param, column] of Object.entries(DATE_PARAM_SOURCE)) {
      acc[param].push(ymd8(row[column]));
    }
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');
  // 감사·세션 인자는 행 단위가 아니라 스칼라다(PROC_M 27·28번 = VARCHAR2).
  //   /call-proc 은 세션을 주입하지 않으므로 FE 가 반드시 실어야 한다
  //   (메모리 call-proc-does-not-inject-session-only-call-proc2). 빈 문자열 감사키 금지.
  payload.userId = session.userId;
  payload.timeZone = session.timeZone;
  return payload;
};

/**
 * 저장 실행. 성공 판정은 **SP 반환코드까지** 본다 —
 *   HTTP 200 + `code:0` 이어도 o_rc1 의 첫 칸이 'S' 가 아니면 저장되지 않았다(AS-IS cs:1107~1130).
 *   인터셉터가 500/403 도 resolve 하므로 status/code 분기가 없으면 실패가 성공 토스트로 새어 나간다.
 */
export const submitConfirmNewSave = async (
  targets: GridRowData[],
  session: SaveSession
): Promise<SaveResult> => {
  const payload = buildConfirmNewPayload(targets, session);
  try {
    const res = await apiClient.post<Record<string, Record<string, unknown>[]>>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return { ok: false, code: '', message: str((res.data as { message?: string })?.message) };
    }
    const first = res.data.result?.o_rc1?.[0];
    const code = readResultCode(first);
    if (code === 'X') {
      // SoldTo/ShipTo 코드 누락 상세(AS-IS cs:1140~1164 와 동일 필드).
      const reason = str(first?.reason_id ?? first?.REASON_ID);
      const division = str(first?.division_id ?? first?.DIVISION_ID);
      const site = str(first?.to_site ?? first?.TO_SITE);
      return {
        ok: true,
        code: 'X',
        message: reason ? `${reason} from ${division} - ${site}` : '',
      };
    }
    return { ok: true, code: (code as SaveResult['code']) || '', message: '' };
  } catch (e) {
    return { ok: false, code: '', message: e instanceof Error ? e.message : '' };
  }
};

// ── 신규 저장 2단계: 변경요청 초안 생성(SAVE_SHIPMENT_REQUEST_DRAFTING) ──────────────────
//   AS-IS SaveButton 은 CONFIRM_NEW 성공 후 GetNewERPInterface -> NewNonSoNo(cs:4180) 로
//   방금 만든 확정행(ATTRIBUTE10='I')마다 DRAFTING 저장을 호출한다. 이게 change_req_no 를 부여하고
//   변경요청 헤더/상세를 만들며 원본 확정을 SHIPMENT_STATUS='D' 로 바꿔(SP line 1852) 아래 grid(초안)에
//   조회되게 한다. TO-BE 가 이 2단계를 빠뜨려 신규건이 아래 grid 에 안 나왔다.
//
//   대상 행은 CONFIRM_NEW 직후 재조회한 _N(o_rc1) 결과 중 ATTRIBUTE10='I' 인 것 — 서버가 부여한
//   CONFIRM_ID 가 여기 담겨 있다(신규 저장 전 원본 행에는 없다). 파라미터명은 SCM_ADM_PROC_M 실측(camelCase,
//   오타 newDContry·origionToDivisionId 그대로), 행→인자 대응은 AS-IS cs:4240~4346 실측이다.

// 값 그대로 보내는 per-row 인자 ← _N o_rc1 컬럼.
const DRAFT_PLAIN_SOURCE: Record<string, string> = {
  divisionId: COLUMN.DIVISION_ID,
  confirmId: COLUMN.CONFIRM_ID,
  shipmentQty: COLUMN.SHIPMENT_CONFIRM_QTY,
  fromSite: COLUMN.FROM_SITE,
  newBodId: COLUMN.NEW_BOD_ID,
  newRouteId: COLUMN.NEW_ROUTE_ID,
  newIncoterms: COLUMN.NEW_INCOTERMS,
  newTransportMode: COLUMN.NEW_TRANSPORT_MODE,
  newDContry: COLUMN.NEW_D_COUNTRY, // SP 실명 오타 유지
  newDPortCode: COLUMN.NEW_D_PORT_CODE,
  newACountry: COLUMN.NEW_A_COUNTRY,
  newAPortCode: COLUMN.NEW_A_PORT_CODE,
  newCustomerLt: COLUMN.NEW_CUSTOMER_LT,
  newToCountry: COLUMN.NEW_TO_COUNTRY,
  newToCity: COLUMN.NEW_TO_CITY,
  editRemark: COLUMN.EDIT_REMARKS,
  electrodeYn: COLUMN.ELECTRODE_YN,
  electrodeType: COLUMN.ELECTRODE_TYPE,
  originFromDivisionId: COLUMN.ORIGIN_FROM_DIVISION_ID,
  origionToDivisionId: COLUMN.ORIGIN_TO_DIVISION_ID, // SP 실명 오타 유지
  remarks: COLUMN.REMARKS,
  remarks2: COLUMN.REMARKS2,
  remarks3: COLUMN.REMARKS3,
  changeReasonDetail: COLUMN.CHANGE_REASON_DETAIL,
  erpAttr1: COLUMN.ERP_ATTR1,
  erpAttr2: COLUMN.ERP_ATTR2,
  erpAttr3: COLUMN.ERP_ATTR3,
};

const DRAFT_DATE_SOURCE: Record<string, string> = {
  shipmentDate: COLUMN.SHIPMENT_DATE,
  newEtdDate: COLUMN.NEW_ETD,
  newEtaDate: COLUMN.NEW_ETA,
};

export interface DraftingNewSession {
  userId: string;
  /** 로그인 사용자 부서(요청부서). requestInfo.requestDeptId — 초안 헤더 REQUEST_DEPT 로 저장된다. */
  userDeptId: string;
  /** 채번(GET_CHANGE_REQ_NO) 결과. 신규 초안 1건의 변경요청번호(AS-IS _ChangeReqno). */
  changeReqNo: string;
}

/** ATTRIBUTE10='I'(방금 생성분)만 초안 대상이다 — AS-IS cs:4061 `if (action != FlagI) continue`. */
export const draftingNewTargets = (rows: GridRowData[]): GridRowData[] =>
  rows.filter(r => str(r[COLUMN.ATTRIBUTE10]) === CRUD_INSERT);

export const buildDraftingNewPayload = (
  targets: GridRowData[],
  session: DraftingNewSession
): Record<string, string> => {
  const acc: Record<string, string[]> = {
    activeFlag: [],
    editMain: [],
    changeReasonCode: [],
    title: [],
  };
  for (const key of Object.keys(DRAFT_PLAIN_SOURCE)) acc[key] = [];
  for (const key of Object.keys(DRAFT_DATE_SOURCE)) acc[key] = [];

  for (const row of targets) {
    acc.activeFlag.push(CRUD_INSERT); // 'I'(cs:4239 p_active_flag=action)
    acc.editMain.push('Y'); // cs:4258 p_edit_main='Y'
    // cs:4272 change_reason_code 는 '-' 제거(콤보 더미 '-' 를 저장하지 않는다).
    acc.changeReasonCode.push(str(row[COLUMN.CHANGE_REASON_CODE]).replace(/-/g, ''));
    // 신규 초안의 title 은 이후 요청확정에서 채운다(AS-IS 는 SheetName 을 넣지만 무의미) — 빈 값.
    acc.title.push('');
    for (const [param, column] of Object.entries(DRAFT_PLAIN_SOURCE)) {
      acc[param].push(str(row[column]));
    }
    for (const [param, column] of Object.entries(DRAFT_DATE_SOURCE)) {
      acc[param].push(ymd8(row[column]));
    }
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');
  // scalar 인자(PROC_M DATA_TYPE=VARCHAR2): changeType/userId/userDeptId/changeReqNo/programId.
  payload.changeType = CHANGE_TYPE_NEW; // 'N'
  payload.userId = session.userId;
  payload.userDeptId = session.userDeptId;
  payload.changeReqNo = session.changeReqNo;
  payload.programId = MENU_ID;
  return payload;
};

/**
 * 신규 확정행을 변경요청 초안으로 승격(2단계). 성공 판정은 SP o_rc1 첫 칸 'S'.
 *   실패해도 확정(1단계)은 이미 저장됐다 — 호출부는 초안 실패만 알린다(AS-IS "신규 생성 요청 실패").
 */
export const submitDraftingNewSave = async (
  targets: GridRowData[],
  session: DraftingNewSession
): Promise<SaveResult> => {
  if (targets.length === 0) return { ok: true, code: 'S', message: '' };
  const payload = buildDraftingNewPayload(targets, session);
  try {
    const res = await apiClient.post<Record<string, Record<string, unknown>[]>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SAVE_DRAFTING}/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return { ok: false, code: '', message: str((res.data as { message?: string })?.message) };
    }
    const first = res.data.result?.o_rc1?.[0];
    const code = readResultCode(first);
    if (code === 'X') {
      // BOD/SoldTo·ShipTo 미해소 상세(SP line 1429 RESULT_CODE='X' + REASON_ID/DIVISION_ID/TO_SITE).
      //   CONFIRM_NEW 의 'X' 처리와 동일하게 사유를 담아 실패 안내가 원인을 드러내게 한다.
      const reason = str(first?.reason_id ?? first?.REASON_ID);
      const division = str(first?.division_id ?? first?.DIVISION_ID);
      const site = str(first?.to_site ?? first?.TO_SITE);
      return { ok: true, code: 'X', message: reason ? `${reason} (${division} - ${site})` : '' };
    }
    return { ok: true, code: (code as SaveResult['code']) || '', message: '' };
  } catch (e) {
    return { ok: false, code: '', message: e instanceof Error ? e.message : '' };
  }
};

// ── 기존 확정행 "수정" 저장: GetERPInterface 2번째 루프 ─────────────────────────────────────
//   AS-IS SaveButton 의 수정 저장은 `GetERPInterface()`(cs:3541) **안**에 있다. 그 메서드는 이름과 달리
//   검증만 하는 게 아니다 — 1번 루프(cs:3553~3591)가 출하상태·SO건수·날짜형식을 검증하고,
//   **2번 루프(cs:3593~3640)가 `action != 'I'` 인 행을 실제로 DRAFTING SP 로 저장한다**:
//     erpSoNo 없음 → `NonSoNo(i, action)`(cs:4111)          — 단일행 1콜
//     erpSoNo 있음 → `SoNo(i, action, erpSoNo, …)`(cs:4312) — 같은 SO 전 행 묶어 1콜(중복 가드 cs:4320)
//   TO-BE 는 1번 루프만 `useShipmentChangeRequestPlanPreChecks.checkErpInterface` 로 이식하고
//   2번 루프를 빠뜨려 **수정 저장이 영구 무동작**이었다(2026-10-03 원인 확정).
//
//   서버 계약(ora.py 실측 2026-10-03): PKG_SSP0200.P_SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING IN 39 —
//     CLOB 34개가 행 단위('^' 결합) + VARCHAR2 5개가 스칼라(changeType/userId/userDeptId/changeReqNo/programId).
//     SP 본문이 `V_MAX_LOOP_CNT := F_SPL_CNT(P_ACTIVE_FLAG)`(body 1310)로 루프 수를 정하고 전 CLOB 를
//     그 수로 split 하므로 **34개 토큰 수가 전부 같아야 한다** — 어긋나면 행이 밀려 ERP 전송행이 오염된다.
//     activeFlag≠'I' 분기(body 1859~1868)가 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW('C', …)` 로
//     XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 에 전송행을 적재한다 — 수정 1회 = 전송행 1건 누적이 AS-IS 정상 동작이다.
//
//   신규 2단계(buildDraftingNewPayload)와 **원천 컬럼이 다르다** — 재사용하면 조용히 틀린다:
//     newIncoterms      ← INCOTERMS      (신규는 NEW_INCOTERMS)       cs:4414 / 4176
//     newTransportMode  ← TRANSPORT_MODE (신규는 NEW_TRANSPORT_MODE)  cs:4415 / 4177
//     activeFlag        ← 행 CRUD_TYPE   (신규는 'I' 고정)             cs:4403 / 4239
//     editMain          ← 행 EDIT_MAIN   (신규는 'Y' 고정)             cs:4423 / 4258
//     changeType        ← 'C' 고정        (신규는 'N')                  cs:4461 / 4221
//     title             ← 시트명          (신규는 빈 값)                cs:4436

/** 값 그대로 보내는 per-row 인자 ← shtMain 행 컬럼(AS-IS SoNo cs:4404~4442 / NonSoNo cs:4167~4208). */
const MODIFY_PLAIN_SOURCE: Record<string, string> = {
  divisionId: COLUMN.DIVISION_ID,
  confirmId: COLUMN.CONFIRM_ID,
  shipmentQty: COLUMN.SHIPMENT_CONFIRM_QTY,
  fromSite: COLUMN.FROM_SITE,
  newBodId: COLUMN.NEW_BOD_ID,
  newRouteId: COLUMN.NEW_ROUTE_ID,
  newIncoterms: COLUMN.INCOTERMS, // 주의: NEW_INCOTERMS 아님(cs:4414)
  newTransportMode: COLUMN.TRANSPORT_MODE, // 주의: NEW_TRANSPORT_MODE 아님(cs:4415)
  newDContry: COLUMN.NEW_D_COUNTRY, // SP 실명 오타 유지
  newDPortCode: COLUMN.NEW_D_PORT_CODE,
  newACountry: COLUMN.NEW_A_COUNTRY,
  newAPortCode: COLUMN.NEW_A_PORT_CODE,
  newCustomerLt: COLUMN.NEW_CUSTOMER_LT,
  newToCountry: COLUMN.NEW_TO_COUNTRY,
  newToCity: COLUMN.NEW_TO_CITY,
  editMain: COLUMN.EDIT_MAIN,
  editRemark: COLUMN.EDIT_REMARKS,
  electrodeYn: COLUMN.ELECTRODE_YN,
  electrodeType: COLUMN.ELECTRODE_TYPE,
  originFromDivisionId: COLUMN.ORIGIN_FROM_DIVISION_ID,
  origionToDivisionId: COLUMN.ORIGIN_TO_DIVISION_ID, // SP 실명 오타 유지
  remarks: COLUMN.REMARKS,
  remarks2: COLUMN.REMARKS2,
  remarks3: COLUMN.REMARKS3,
  changeReasonDetail: COLUMN.CHANGE_REASON_DETAIL,
  erpAttr1: COLUMN.ERP_ATTR1,
  erpAttr2: COLUMN.ERP_ATTR2,
  erpAttr3: COLUMN.ERP_ATTR3,
};

const MODIFY_DATE_SOURCE: Record<string, string> = {
  shipmentDate: COLUMN.SHIPMENT_DATE,
  newEtdDate: COLUMN.NEW_ETD,
  newEtaDate: COLUMN.NEW_ETA,
};

export interface DraftingModifySession {
  userId: string;
  /** 로그인 사용자 부서(AS-IS `UserInfoContext.Current["Dept_ID"]` cs:4354). */
  userDeptId: string;
  /** 채번(GET_CHANGE_REQ_NO) 결과 = AS-IS `_ChangeReqno`(cs:4493). 빈 값이면 SP 가 자체 채번한다(body 1298~1307). */
  changeReqNo: string;
}

/**
 * AS-IS 2번 루프의 호출 단위를 그대로 복원한다 —
 *   ERP_SO_NO 가 있는 수정행은 **같은 SO 묶음 1콜**(`SoNo`), 없는 수정행은 **행마다 1콜**(`NonSoNo`).
 *   어느 쪽이든 CHANGE_TYPE='P' 행은 제외된다(cs:3602 / cs:4393).
 *
 * 묶음 멤버는 `source` 전체에서 찾는다 — 사용자가 직접 건드리지 않은 같은 SO 의 행도 AS-IS 가 함께
 *   싣는다(cs:4384~4399 가 `siMain` 전 행을 돌며 `strSoNo == erpSoNo` 를 모은다). 단 멤버 자격은
 *   action I/M/D 뿐이라(cs:4388) 미변경 행은 들어오지 않는다.
 *
 * AS-IS 차이(의도적 교정, 사용자 승인 2026-10-03): `SoNo` 는 `chkSingleProcess` 체크 시
 *   `iCallChk > 1` 이면 `return true` 로 **2번째 이후 SO 묶음을 조용히 건너뛴다**(cs:4316~4318).
 *   서로 다른 SO 2건을 수정하면 한쪽이 저장되지 않고 성공처럼 끝나므로 복제하지 않는다 —
 *   여기서는 체크 여부와 무관하게 모든 묶음을 저장한다. 근거·영향은 04 에 기록했다.
 */
export const draftingModifyGroups = (source: GridRowData[]): GridRowData[][] => {
  const isConvertible = (row: GridRowData): boolean =>
    str(row[COLUMN.CHANGE_TYPE]) !== CHANGE_TYPE_PLAN;
  const groups: GridRowData[][] = [];
  const seenSoNo = new Set<string>();

  for (const row of source) {
    if (!DRAFTING_MODIFY_ACTIONS.includes(str(row.CRUD_TYPE))) continue;
    if (!isConvertible(row)) continue;

    const soNo = str(row[COLUMN.ERP_SO_NO]).trim();
    if (!soNo) {
      groups.push([row]); // NonSoNo — 단일행
      continue;
    }
    if (seenSoNo.has(soNo)) continue; // SoNo 중복 가드(cs:4320~4330)
    seenSoNo.add(soNo);
    groups.push(
      source.filter(
        r =>
          str(r[COLUMN.ERP_SO_NO]).trim() === soNo &&
          DRAFTING_GROUP_ACTIONS.includes(str(r.CRUD_TYPE)) &&
          isConvertible(r)
      )
    );
  }
  return groups;
};

export const buildDraftingModifyPayload = (
  group: GridRowData[],
  session: DraftingModifySession
): Record<string, string> => {
  const acc: Record<string, string[]> = { activeFlag: [], changeReasonCode: [], title: [] };
  for (const key of Object.keys(MODIFY_PLAIN_SOURCE)) acc[key] = [];
  for (const key of Object.keys(MODIFY_DATE_SOURCE)) acc[key] = [];

  for (const row of group) {
    acc.activeFlag.push(str(row.CRUD_TYPE)); // cs:4403 p_active_flag=action
    // cs:4434 — 콤보 더미 '-' 를 저장하지 않는다(신규 경로와 동일 규칙).
    acc.changeReasonCode.push(str(row[COLUMN.CHANGE_REASON_CODE]).replace(/-/g, ''));
    // cs:4436 은 시트명을 행마다 반복해 싣는다(AppendString 자기참조로 N토큰이 된다).
    acc.title.push(ADMIN_SHEET_NAME[SHEETS.MAIN]);
    for (const [param, column] of Object.entries(MODIFY_PLAIN_SOURCE)) {
      acc[param].push(str(row[column]));
    }
    for (const [param, column] of Object.entries(MODIFY_DATE_SOURCE)) {
      acc[param].push(ymd8(row[column]));
    }
  }

  const payload: Record<string, string> = {};
  for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');
  // scalar 인자(ALL_ARGUMENTS VARCHAR2 5건).
  payload.changeType = CHANGE_TYPE_CONFIRM; // 'C' 고정 — cs:4461 / 4221
  payload.userId = session.userId;
  payload.userDeptId = session.userDeptId;
  payload.changeReqNo = session.changeReqNo;
  payload.programId = MENU_ID;
  return payload;
};

/**
 * 수정행 묶음 1건을 변경요청 초안으로 저장한다. 성공 판정은 o_rc1 RESULT_CODE 'S' 까지 본다 —
 *   HTTP 200 + code:0 이어도 'S' 가 아니면 저장되지 않았다(AS-IS cs:4507~4546).
 *   'X' 는 BOD(Trans mode·Incoterms) 무효(cs:4525 MSG00293).
 */
export const submitDraftingModifySave = async (
  group: GridRowData[],
  session: DraftingModifySession
): Promise<SaveResult & { requestNo: string }> => {
  const payload = buildDraftingModifyPayload(group, session);
  try {
    const res = await apiClient.post<Record<string, Record<string, unknown>[]>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SAVE_DRAFTING}/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return {
        ok: false,
        code: '',
        message: str((res.data as { message?: string })?.message),
        requestNo: '',
      };
    }
    const first = res.data.result?.o_rc1?.[0];
    const code = readResultCode(first);
    // 요청번호는 이름으로 읽는다(열 순서 비보장) — SP 가 RESULT_CODE + REQUEST_NO 2열을 돌려준다(body 1874~1877).
    const requestNo = str(first?.REQUEST_NO ?? first?.request_no ?? '');
    if (code === 'X') {
      const reason = str(first?.reason_id ?? first?.REASON_ID);
      const division = str(first?.division_id ?? first?.DIVISION_ID);
      const site = str(first?.to_site ?? first?.TO_SITE);
      return {
        ok: true,
        code: 'X',
        message: reason ? `${reason} (${division} - ${site})` : '',
        requestNo,
      };
    }
    return { ok: true, code: (code as SaveResult['code']) || '', message: '', requestNo };
  } catch (e) {
    return { ok: false, code: '', message: e instanceof Error ? e.message : '', requestNo: '' };
  }
};

/**
 * 동일 SO 다건 수정 시 ERP 전송행 IFSEQNO 병합 — AS-IS `if (iCount > 1) GetErpIFSeqMerge(sRequestNo)`
 *   (cs:4514). 한 요청번호 아래 전송행이 2건 이상일 때만 부른다. 실패해도 저장은 유효하므로
 *   AS-IS 와 같이 조용히 넘긴다(cs:4725 catch 가 false 만 돌려주고 호출부가 무시한다).
 *   이 SP 는 o_rc1 이 없고 O_RESULT_CURSOR 만 있다(PROC_M 실측) — 성공 판정은 HTTP/code 까지다.
 */
export const submitErpIfSeqMerge = async (changeRequestNo: string): Promise<boolean> => {
  if (!changeRequestNo) return false;
  try {
    // 제네릭은 `result` 페이로드 — 이 SP 는 o_rc1 이 없어 읽을 커서가 없다(판정은 래퍼의 code 까지).
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_ERP_IFSEQ_MERGE}/call-proc`,
      { changeRequestNo, status: IFSEQ_MERGE_STATUS }
    );
    return !(res.status >= 400 || Number(res.data?.code));
  } catch {
    return false;
  }
};

export interface ErpIfResult {
  /** AS-IS `service.RtFlag` 등가. 빈 문자열이면 판정 불가(호출 실패). */
  eType: string;
  /** AS-IS `service.ReErrorMsg` 등가 — '^' 구분 `confirmId:msg` 목록. */
  eMessage: string;
  /** 호출 자체의 성공 여부. false 면 eType 을 신뢰할 수 없다. */
  ok: boolean;
}

/**
 * ERP I/F(SAP PI) 전송 — AS-IS `GetErpIFCheckNew(RequestNo)`(cs:4623) 의 TO-BE 등가.
 *   `FN_ERP_UIWebService(RequestNo, "C", "")` 3인자가 BE 공통 창구의 body 3키로 매핑된다.
 *   BE 가 응답 XML 말단을 `{ E_TYPE, E_MESSAGE }` 로 파싱해 준다(WebServiceCommonService).
 *   미구현 잔여: E_TYPE 'S_E'/'E' 일 때 AS-IS 가 수행하는 초안 롤백
 *   (`SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`)은 그 SP 가 TO-BE 미배포라 미배선이다 —
 *   사유만 노출한다(04 확인필요).
 */
export const submitErpInterface = async (changeReqNo: string): Promise<ErpIfResult> => {
  try {
    // 제네릭은 `result` 페이로드만이다 — `res.data` 가 공용 `{code, message, result}` 래퍼다.
    //   래퍼를 제네릭에 또 쓰면 `res.data.result` 가 래퍼 타입이 되어 E_TYPE 이 사라진다.
    const res = await apiClient.post<{ E_TYPE?: unknown; E_MESSAGE?: unknown }>(ERP_IF_PATH, {
      CHANGE_REQ_NO: changeReqNo,
      CHANGE_TYPE: ERP_IF_CHANGE_TYPE,
      SHIPMENT_STATUS: '',
    });
    if (res.status >= 400 || Number(res.data?.code)) {
      return { ok: false, eType: '', eMessage: '' };
    }
    const result = res.data?.result;
    return { ok: true, eType: str(result?.E_TYPE), eMessage: str(result?.E_MESSAGE) };
  } catch {
    return { ok: false, eType: '', eMessage: '' };
  }
};
