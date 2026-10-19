/**
 * SSP0201 신규행(Insert) 저장 체인 — AS-IS `SaveButton()` 의 2·5·6 단계.
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs
 *   SaveButton(L764)
 *     2  SSP0201_GET_CHANGE_REQ_NO            (L783~794)  -> _ChangeReqno 채번
 *     5  SSP0201_SAVE_SHIPMENT_CONFIRM_NEW    (L939)      -> action=='I' 행만 '^' 접어 일괄
 *     6  RESULT_CODE=='S' 이면 (L983~993)
 *          FindData_Main_Nonasync()                       -> **메인 재조회**
 *          GetNewERPInterface()(L3462) -> NewNonSoNo(L3613) -> SAVE_SHIPMENT_REQUEST_DRAFTING
 *
 * **순서를 바꾸면 동작하지 않는다.** DRAFTING SP 는 `P_CONFIRM_ID`(4번 인자)를 요구하는데
 * 신규행의 CONFIRM_ID 는 5단계 CONFIRM_NEW 가 채번한다. 그래서 저장 -> 재조회로 CONFIRM_ID 수령
 * -> 그 다음에 DRAFTING 이다. 하위 그리드(sub/SEARCH = GET_SHIPMENT_REQUEST_DRAFTING)가
 * 바로 이 DRAFTING 레코드를 읽으므로, 6단계를 빼면 저장은 되는데 하위 그리드가 빈다.
 *
 * 재조회 뒤 신규행을 다시 찾는 키는 **ATTRIBUTE10 == 'I'** 다(AS-IS L3475·L3492).
 * 재조회로 그리드가 갈아엎어져 클라 CRUD_TYPE 이 사라지기 때문에, 서버가 ATTRIBUTE10 에
 * 신규 플래그를 실어 보낸다(PKG 본문에 `신규 등록 후 FLAG ATTRIBUTE10 초기화` 주석 + SET NULL 존재).
 *
 * 전송 규약(memory save-proc-per-column-caret-fold-fe):
 *   PROC_M 실측상 두 SAVE 의 대부분 인자가 `DATA_TP_CD='CLOB'` 이다. CLOB 은 BE 가 접지 않으므로
 *   **FE 가 컬럼별로 `arr.join('^')` 해 camelCase 키로** 보내야 한다. 공통 `useProcMutation`
 *   (raw `{data:[rows]}`)으로는 성립하지 않아 `apiClient.post` 를 직접 쓴다.
 *   `userId`/`timeZone`/`userDeptId` 는 VARCHAR 스칼라이고, `call-proc` 은 세션을 주입하지 않으므로
 *   FE 가 실어야 한다.
 */

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../shipment-change-request.constants';

import {
  judgeSaveError,
  judgeSaveResponse,
  readResultCode,
  type SaveOutcome,
} from './shipmentChangeRequestResult';

/** 버튼 코드 — API_M 이 `{MNU_ID}_{SHT_NM}_{MNU_BTN_CD}` 규약으로 이미 등록돼 있다(ora.py 실측).
 *    SSP0201_main_REQ_NO    -> PKG_SSP0201.P_SSP0201_GET_CHANGE_REQ_NO
 *    SSP0201_main_SAVE_NEW  -> PKG_SSP0201.P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW
 *  버튼 매핑·권한은 22_register_new_save_chain_btn_auth.sql 로 등록(사용자 실행). */
export const BTN_REQ_NO = 'REQ_NO';
export const BTN_SAVE_NEW = 'SAVE_NEW';
/** DRAFTING 은 기존 main/SAVE 가 이미 가리킨다(P_SSP0201_SAVE -> SAVE_SHIPMENT_REQUEST_DRAFTING). */
export const BTN_SAVE_DRAFTING = 'SAVE';

/** CLOB 인자의 행 구분자. 수정저장(shipmentChangeRequestModifySave)도 같은 규약이라 함께 쓴다. */
export const FOLD = '^';
export const s = (v: unknown): string => safeString(v).trim();

/** AS-IS `Convert.ToDateTime(...).ToString("yyyy-MM-dd HH:mm:ss.fff")` 와 같은 형식.
 *  그리드는 'YYYYMMDD' 또는 'YYYY-MM-DD' 를 담으므로 느슨하게 파싱한다. 파싱 실패면 ''(SP 가 판정).
 *  수정저장도 **같은 변환**을 써야 한다 — 복사하면 두 경로의 날짜 형식이 조용히 갈린다. */
export const toSpDateTime = (v: unknown): string => {
  const raw = s(v);
  if (!raw) return '';
  const d = raw.length === 8 && /^\d{8}$/.test(raw) ? dayjs(raw, 'YYYYMMDD') : dayjs(raw);
  return d.isValid() ? d.format('YYYY-MM-DD HH:mm:ss.SSS') : '';
};

type Row = Record<string, unknown>;

// 응답 판정은 `utils/shipmentChangeRequestResult.ts` 의 judgeSaveResponse/judgeSaveError 하나로 통일했다.
//   종전의 `httpFailed`(HTTP/BE code) + `resultCodeOf`(SP RESULT_CODE) 2분기를 대체한다.
//   ok/fail 외에 **unknown**(판정 근거 없음)이 생겼고, 세 함수 모두 unknown 을 성공으로 올리지 않는다.

// ─────────────────────────────────────────────────────────────────────────────
// 2단계 — 변경요청번호 채번
// ─────────────────────────────────────────────────────────────────────────────
/**
 * AS-IS L783~794: `SSP0201_GET_CHANGE_REQ_NO(p_user_id)` 후
 *   `if (Tables[0].Rows[0][0] == "S") _ChangeReqno = Rows[0][1];`
 * SP 커서(PKG BODY L1064~1067)는 `RESULT_CODE`(='S') + `CHANGE_REQ_NO`('R'+YYYYMMDD+6자리) 2컬럼.
 * 실패해도 AS-IS 는 멈추지 않고 _ChangeReqno 를 null 로 둔 채 진행한다 — 같은 거동으로 ''를 돌려준다.
 */
export const fetchChangeReqNo = async (userId: string): Promise<string> => {
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_REQ_NO}/call-proc`,
      { userId }
    );
    // ok 가 아니면(fail·unknown 모두) 채번 실패로 본다 — AS-IS 도 멈추지 않고 빈 값으로 진행한다.
    if (judgeSaveResponse(res) !== 'ok') return '';
    const rows =
      (res.data as { result?: { o_rc1?: Row[] } } | undefined)?.result?.o_rc1 ?? ([] as Row[]);
    return s(rows[0]?.CHANGE_REQ_NO);
  } catch {
    return '';
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// 5단계 — 신규행 일괄 저장(CONFIRM_NEW)
// ─────────────────────────────────────────────────────────────────────────────
/**
 * AS-IS L888~980: `action == 'I'` 행만 모아 29 인자로 1회 호출.
 *   컬럼 대응은 cs L901~928 `CString.AppendString` 순서 그대로다. 특히:
 *     p_from_site      <- FROM_SITE_DESCRIPTION   (DESCRIPTION 열을 보낸다 — Insert 복사와 반대축)
 *     p_to_site        <- TO_SITE_DESCRIPTION
 *     p_project_code40 <- END_CUSTOMER            (div40 의 프로젝트 자리)
 *     p_project_code   <- PROJECT_CODE
 *   NEW_* 7종(lt/route/bod/country/port)은 "프로시저에서 다시 setting 함"(cs L915 주석)이라
 *   화면값을 그대로 실어 보내면 된다.
 */
export interface ConfirmNewResult {
  /** 'S' 성공 / 'N' Model 미조회 / 'F' 판가 미입력 / 'X' 확인필요 / '' 판정 근거 없음·HTTP 실패 */
  code: string;
  /** 통일 판정값. `code` 는 'N'/'F' 분기 메시지용이라 남기고, 성공 여부는 이 값으로 본다. */
  outcome: SaveOutcome;
}

export const submitConfirmNew = async (
  inserted: Row[],
  scalars: { userId: string; timeZone: string }
): Promise<ConfirmNewResult> => {
  const acc: Record<string, string[]> = {
    activeFlag: [],
    divisionId: [],
    fromSite: [],
    toSite: [],
    projectCode40: [],
    projectCode: [],
    fcstType: [],
    itemId: [],
    shipmentDate: [],
    shipmentQty: [],
    incoterms: [],
    transportMode: [],
    lt: [],
    etd: [],
    eta: [],
    routeId: [],
    bodId: [],
    dCountry: [],
    dPortCode: [],
    aConuntry: [], // PROC_M 실측 철자(오타 포함) 그대로 — 바꾸면 바인드 실패
    aPortCode: [],
    toCountry: [],
    toCity: [],
    remarks: [],
    remarks2: [],
    remarks3: [],
    shiptoCode: [],
  };

  for (const r of inserted) {
    acc.activeFlag.push('I');
    acc.divisionId.push(s(r.DIVISION_ID));
    acc.fromSite.push(s(r.FROM_SITE_DESCRIPTION));
    acc.toSite.push(s(r.TO_SITE_DESCRIPTION));
    acc.projectCode40.push(s(r.END_CUSTOMER));
    acc.projectCode.push(s(r.PROJECT_CODE));
    acc.fcstType.push(s(r.FCST_TYPE));
    acc.itemId.push(s(r.ITEM_ID));
    acc.shipmentDate.push(toSpDateTime(r.SHIPMENT_DATE));
    acc.shipmentQty.push(s(r.SHIPMENT_CONFIRM_QTY));
    acc.incoterms.push(s(r.INCOTERMS));
    acc.transportMode.push(s(r.TRANSPORT_MODE));
    acc.lt.push(s(r.NEW_CUSTOMER_LT));
    acc.etd.push(s(r.NEW_ETD));
    acc.eta.push(s(r.NEW_ETA));
    acc.routeId.push(s(r.NEW_ROUTE_ID));
    acc.bodId.push(s(r.NEW_BOD_ID));
    acc.dCountry.push(s(r.NEW_D_COUNTRY));
    acc.dPortCode.push(s(r.NEW_D_PORT_CODE));
    acc.aConuntry.push(s(r.NEW_A_COUNTRY));
    acc.aPortCode.push(s(r.NEW_A_PORT_CODE));
    acc.toCountry.push(s(r.NEW_TO_COUNTRY));
    acc.toCity.push(s(r.NEW_TO_CITY));
    acc.remarks.push(s(r.REMARKS));
    acc.remarks2.push(s(r.REMARKS2));
    acc.remarks3.push(s(r.REMARKS3));
    acc.shiptoCode.push(s(r.TO_SITE_SHIPTO_CODE));
  }

  const payload: Record<string, string> = {};
  for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join(FOLD);
  // VARCHAR 스칼라 — call-proc 은 세션을 주입하지 않는다.
  payload.userId = scalars.userId;
  //   timeZone: TO-BE UserSession 에 타임존 필드가 없다. 자매 SSP0200/shipment-working-day 와
  //   동일하게 빈 값으로 보낸다(SP 가 FN_MULTY_TIME 으로 보정). 세션 확장 시 교체.
  payload.timeZone = scalars.timeZone;

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SAVE_NEW}/call-proc`,
      payload
    );
    const outcome = judgeSaveResponse(res);
    // unknown 은 본문을 믿을 수 없다는 뜻이라 code 를 읽지 않는다(엉뚱한 'N'/'F' 메시지 방지).
    return { code: outcome === 'unknown' ? '' : readResultCode(res.data), outcome };
  } catch (error) {
    return { code: '', outcome: judgeSaveError(error) };
  }
};

// ─────────────────────────────────────────────────────────────────────────────
// 6단계 — **신규 전용 조회**로 CONFIRM_ID 수령 후 DRAFTING 기록 (NewNonSoNo)
// ─────────────────────────────────────────────────────────────────────────────
/**
 * 신규행 재조회는 **메인 조회(SEARCH)가 아니라 전용 SP(_N)** 를 쓴다.
 *
 * 메인 조회 SP(`P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST`)는 `CHANGE_TYPE <> 'N'` 조건이라 방금 만든
 * 신규행이 결과에 **없다**. 종전 구현은 `refetchMain()` 으로 재조회했기 때문에 DRAFTING 대상이 항상
 * 0건이 되고, 0건이면 실패도 0건이라 **아무것도 만들지 않았는데 성공 토스트가 떴다**(2026-10-12 원인 확정).
 * AS-IS 도 같은 이유로 신규 전용 조회(`_N`, `CHANGE_TYPE='N'`)를 따로 부른다.
 */
export const BTN_SEARCH_NEW = 'SEARCH_NEW';

/**
 * SEARCH_NEW 본문 11키.
 *   DB 실측(ALL_ARGUMENTS, `P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N`): IN 11개로
 *   `P_DIVISION_ID · P_FROM_SITE · P_ERP_SO_NO · P_ITEM_ID · P_FROM_YYYYMMDD · P_TO_YYYYMMDD ·
 *    P_STATUS · P_CHANGE_TYPE · P_LANGUAGE · P_DEBUG_MODE · P_TO_SITE` — `P_CONFIRM_ID` 가 **없다**.
 *
 * **11키 중 실제로 WHERE 에 쓰이는 건 4개뿐이다**(PKG_SSP0201 BODY 실측, _N 본문 622~851):
 *   LIVE  `P_DIVISION_ID`(823~825 split IN) · `P_FROM_YYYYMMDD`(821) · `P_TO_YYYYMMDD`(822) ·
 *         `P_LANGUAGE`(V_LANGUAGE 로 라벨 조인 7곳)
 *   DEAD  `P_FROM_SITE` · `P_ERP_SO_NO` · `P_ITEM_ID` · `P_STATUS` · `P_CHANGE_TYPE` ·
 *         `P_DEBUG_MODE` · `P_TO_SITE` — 본문 참조 0회(선언만 있고 WHERE 에 없다).
 *         SP 주석도 그렇게 말한다: "AS-IS 에서 모델·출발지 조건은 주석이라 사업부 조건만 살아 있다"(616).
 *   WHERE 에 박힌 고정 조건: `CHANGE_TYPE='N'` · `SHIPMENT_STATUS='C'` · `CONFIRM_ID LIKE 'R%'` ·
 *         `QTY > 0` · `TRIM(SHIPMENT_STATUS) IS NOT NULL`.
 *
 * 따라서 **좁힐 수 있는 축은 사업부 + 기간뿐**이고, 그래서 아래 두 가지가 따라온다:
 *   1) 조회 범위는 **화면 조회조건이 아니라 저장한 신규행의 날짜 범위**로 잡는다
 *      (`buildNewRowSearchFilterFromRows`) — 화면 기간 밖에 출하일을 넣으면 0건이 된다.
 *   2) "이번 저장분" 한정은 조회로 불가능하므로 **FE 가 행을 대조**한다
 *      (`pickOwnNewDraftingTargets`).
 */
export interface NewRowSearchFilter {
  divisionId?: unknown;
  fromSite?: unknown;
  erpSoNo?: unknown;
  itemId?: unknown;
  fromYyyymmdd?: unknown;
  toYyyymmdd?: unknown;
  status?: unknown;
  changeType?: unknown;
  language?: unknown;
  toSite?: unknown;
}

/** `P_DEBUG_MODE` 고정값 — 이 feature 공통 규약('F'). */
const DEBUG_MODE = 'F';

export const buildNewRowSearchPayload = (filter: NewRowSearchFilter): Record<string, string> => ({
  divisionId: s(filter.divisionId),
  fromSite: s(filter.fromSite),
  erpSoNo: s(filter.erpSoNo),
  itemId: s(filter.itemId),
  fromYyyymmdd: s(filter.fromYyyymmdd),
  toYyyymmdd: s(filter.toYyyymmdd),
  status: s(filter.status),
  changeType: s(filter.changeType),
  language: s(filter.language),
  debugMode: DEBUG_MODE,
  toSite: s(filter.toSite),
});

/** 'YYYY-MM-DD' / 'YYYYMMDD' / Date 문자열 -> 8자리 숫자. SP 의 `A.YYYYMMDD` 와 같은 축. */
export const toYmd8 = (v: unknown): string => s(v).replace(/\D/g, '').slice(0, 8);

/**
 * 저장한 신규행들이 **모두 들어오는 최소 기간**(출하일 min~max).
 *   화면 조회조건의 기간을 쓰면 안 된다 — 사용자가 조회기간 밖의 출하일로 신규행을 만들면
 *   `A.YYYYMMDD BETWEEN` 에 걸려 0건이 되고, SAVE_NEW 는 이미 성공한 뒤라 실패 alert 가 뜬다.
 *   그 상태에서 사용자가 다시 Save 하면 **CONFIRM_NEW 가 또 돌아 중복 생성된다**(사용자 신고 2026-10-12).
 */
export const newRowSearchRange = (inserted: Row[]): { from: string; to: string } => {
  const dates = inserted.map(r => toYmd8(r.SHIPMENT_DATE)).filter(Boolean).sort();
  return { from: dates[0] ?? '', to: dates[dates.length - 1] ?? '' };
};

/**
 * 재조회 조건을 **저장한 신규행에서** 만든다(화면 조회조건을 쓰지 않는다).
 *   살아 있는 축만 채운다 — 사업부(행에서 수집) + 기간(행 출하일 min~max) + 언어(라벨).
 *   DEAD 7키는 빈 값으로 둔다: 화면값을 실으면 "좁혀진다"고 오해하게 만드는데 SP 는 무시한다.
 */
export const buildNewRowSearchFilterFromRows = (
  inserted: Row[],
  language: string
): NewRowSearchFilter => {
  const { from, to } = newRowSearchRange(inserted);
  const divisions = [...new Set(inserted.map(r => s(r.DIVISION_ID)).filter(Boolean))];
  return {
    divisionId: divisions.join(','), // SP 가 STRING_SPLIT(',') 으로 IN 절을 만든다
    fromYyyymmdd: from,
    toYyyymmdd: to,
    language,
    // 아래 6키는 _N 본문 참조 0회 — 계약(11키)만 지키고 값은 비운다.
    fromSite: '',
    toSite: '',
    erpSoNo: '',
    itemId: '',
    status: '',
    changeType: '',
  };
};

export interface NewRowSearchResult {
  /** `result.o_rc1` 행 — 신규행(CHANGE_TYPE='N') 목록. */
  rows: Row[];
  /**
   * 통일 판정값. **주의: 이건 조회 SP 라 `o_rc1` 이 데이터 행이고 `RESULT_CODE` 열이 없다.**
   * 그래서 정상 응답도 공통 판정이 `unknown` 을 준다 — `'fail'`(HTTP 오류·BE 봉투 비0)만 하드 실패로
   * 보고, 그 밖은 **행 수로 판정**한다(호출부의 `isDraftingTargetsComplete`).
   */
  outcome: SaveOutcome;
}

export const fetchNewRowsForDrafting = async (
  filter: NewRowSearchFilter
): Promise<NewRowSearchResult> => {
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SEARCH_NEW}/call-proc`,
      buildNewRowSearchPayload(filter)
    );
    const outcome = judgeSaveResponse(res);
    if (outcome === 'fail') return { rows: [], outcome };
    const rows =
      (res.data as { result?: { o_rc1?: Row[] } } | undefined)?.result?.o_rc1 ?? ([] as Row[]);
    return { rows, outcome };
  } catch (error) {
    return { rows: [], outcome: judgeSaveError(error) };
  }
};

/**
 * AS-IS `GetNewERPInterface`(L3462) 대상 선별:
 *   ATTRIBUTE10 == 'I'  AND  CHANGE_TYPE != 'P'  AND  ERP_SO_NO 공백
 * ('P'=Plan 타입 제외는 cs L3499, SO 있는 건은 이 경로 대상 아님 — cs L3504)
 */
export const pickNewDraftingTargets = (rows: Row[]): Row[] =>
  rows.filter(
    r => s(r.ATTRIBUTE10) === 'I' && s(r.CHANGE_TYPE) !== 'P' && s(r.ERP_SO_NO) === ''
  );

/**
 * 저장한 신규행을 재조회 결과에서 다시 찾기 위한 식별 키.
 *   `CONFIRM_ID` 는 쓸 수 없다 — 그게 바로 5단계가 채번해서 6단계에 받아오려는 값이다.
 *   그래서 **사용자가 입력한 값**으로 맞춘다. CONFIRM_NEW 가 INSERT 하는 컬럼 중
 *   화면 입력에서 그대로 오는 것들이다(BODY 2700~2756 실측).
 */
export const newRowIdentityKey = (row: Row): string =>
  [
    s(row.DIVISION_ID),
    s(row.ITEM_ID),
    toYmd8(row.SHIPMENT_DATE),
    s(row.SHIPMENT_CONFIRM_QTY),
  ].join('|');

/**
 * DRAFTING 대상을 **이번 저장분으로 한정**한다.
 *
 * `pickNewDraftingTargets` 만으로는 한정되지 않는다 — 이유는 두 가지다(PKG_SSP0201 BODY 실측):
 *   1. `_N` 조회의 WHERE 에 **`ATTRIBUTE10` 조건이 없다**. 사업부+기간 안의 모든
 *      `CHANGE_TYPE='N'` 행이 돌아오고, 'I' 선별은 FE 가 한다.
 *   2. `ATTRIBUTE10='I'` 는 CONFIRM_NEW 가 리터럴로 박고(2756), **그 행의 DRAFTING 이 돌 때까지
 *      남는다**(`UPDATE … SET ATTRIBUTE10=NULL WHERE CONFIRM_ID=V_CONFIRM_ID`, 1930~1932).
 *      즉 이전 저장이 DRAFTING 전에 끊겼거나(브라우저 종료·실패) **다른 사용자가 같은 사업부·기간에
 *      신규행을 만들어 두면** 그 행들이 'I' 로 남아 함께 잡힌다.
 *
 * 그대로 두면 내가 만들지 않은 행이 **이번 changeReqNo 로 DRAFTING 되고**, 건수 검사
 * (`isDraftingTargetsComplete`)도 그 유령 행 덕에 통과해 버린다.
 *
 * 그래서 두 축으로 좁힌다:
 *   · 요청자 — CONFIRM_NEW 가 REQUESTOR 에 `P_USER_ID` 를 넣는다(2755). 타 사용자 배제.
 *   · 식별 키 다중도 상한 — 같은 키를 내가 넣은 개수만큼만 가져간다. 남는 'I' 행(stale)은 버린다.
 */
/**
 * 조회 결과의 `REQUESTOR` 가 이 사용자인지.
 *
 * **원시 user id 비교는 틀린다.** `_N` 이 돌려주는 `REQUESTOR` 는 BODY 760~761 이
 *   `<사용자명> || NVL2(<사용자명>, '(' || A.REQUESTOR || ')', NULL)`
 * 로 만든 **표시 문자열**이다 — `홍길동(U1)` 꼴이고, 사용자 마스터 조인(I)이 비면 앞뒤가 모두 NULL 이라
 * **컬럼 전체가 NULL** 로 온다. 그래서 `=== userId` 로 비교하면 **전건이 탈락**한다.
 *
 * 판정: `(userId)` 포함 여부. 빈 값이면 판정 불가로 보아 통과시키고 키 대조에만 맡긴다
 * — 사용자 마스터에 없는 계정의 저장을 막아버리지 않기 위함이다.
 */
const isOwnRequestor = (row: Row, userId: string): boolean => {
  const requestor = s(row.REQUESTOR);
  if (!requestor) return true; // 조인 미스 — 요청자 축으로는 판정 불가
  return requestor.includes(`(${userId})`);
};

export const pickOwnNewDraftingTargets = (
  rows: Row[],
  inserted: Row[],
  userId: string
): Row[] => {
  const remaining = new Map<string, number>();
  for (const r of inserted) {
    const key = newRowIdentityKey(r);
    remaining.set(key, (remaining.get(key) ?? 0) + 1);
  }

  const picked: Row[] = [];
  for (const row of pickNewDraftingTargets(rows)) {
    // userId 가 빈 값이면(세션 유실) 사용자 축으로 걸러낼 수 없다 — 그때는 키 대조만 적용한다.
    if (userId && !isOwnRequestor(row, userId)) continue;
    const key = newRowIdentityKey(row);
    const left = remaining.get(key) ?? 0;
    if (left <= 0) continue; // 이번 저장분이 아니다(이전 저장의 잔여 'I' 행 등)
    remaining.set(key, left - 1);
    picked.push(row);
  }
  return picked;
};

/**
 * DRAFTING 대상이 **저장한 신규행 수를 채우는지** — 못 채우면 성공이 아니다.
 *
 * 0건이면 실패도 0건이 되어 "전건 성공" 으로 읽히는 것이 바로 종전 false-success 의 형태였다.
 * 조회가 저장 건수보다 적게 돌아오는 것도(부분 누락) 성공으로 보지 않는다 — 누락된 행은 DRAFTING
 * 기록이 없어 하위 그리드에 나타나지 않고, 사용자는 저장됐다고 믿은 채 넘어간다.
 */
export const isDraftingTargetsComplete = (targets: Row[], insertedCount: number): boolean =>
  targets.length > 0 && targets.length >= insertedCount;

/**
 * AS-IS `NewNonSoNo`(L3613~3801) — 행 1건당 1회 호출. 37 인자.
 *   리터럴 고정: `p_change_type = 'N'`(L3737) · `p_edit_main = 'Y'`(L3690, 행값 무시하고 덮어씀)
 *   `p_change_reason_code` 는 '-' 를 제거해 보낸다(L3703 `.Replace("-","")`).
 *   `p_title` = 시트명, `p_program_id` = 폼 이름.
 *   계산만 하고 **보내지 않는** 값: p_status_chk_confirm_id · p_factory_id/p_package_type/p_dom_exp(전부 "").
 */
export const submitNewDrafting = async (
  row: Row,
  changeReqNo: string,
  scalars: { userId: string; userDeptId: string }
): Promise<boolean> => {
  const payload: Record<string, string> = {
    activeFlag: 'I',
    changeType: 'N', // AS-IS 리터럴
    divisionId: s(row.DIVISION_ID),
    confirmId: s(row.CONFIRM_ID), // 5단계가 채번한 값 — 재조회로 받아온다
    shipmentQty: s(row.SHIPMENT_CONFIRM_QTY),
    shipmentDate: toSpDateTime(row.SHIPMENT_DATE),
    fromSite: s(row.FROM_SITE), // 주의: 여기는 코드열(FROM_SITE)이다 — CONFIRM_NEW 와 축이 다르다
    newBodId: s(row.NEW_BOD_ID),
    newRouteId: s(row.NEW_ROUTE_ID),
    newEtdDate: s(row.NEW_ETD),
    newEtaDate: s(row.NEW_ETA),
    newIncoterms: s(row.NEW_INCOTERMS),
    newTransportMode: s(row.NEW_TRANSPORT_MODE),
    newDContry: s(row.NEW_D_COUNTRY), // PROC_M 철자 그대로
    newDPortCode: s(row.NEW_D_PORT_CODE),
    newACountry: s(row.NEW_A_COUNTRY),
    newAPortCode: s(row.NEW_A_PORT_CODE),
    newCustomerLt: s(row.NEW_CUSTOMER_LT),
    newToCountry: s(row.NEW_TO_COUNTRY),
    newToCity: s(row.NEW_TO_CITY),
    editMain: 'Y', // AS-IS 리터럴(L3690)
    editRemark: s(row.EDIT_REMARKS),
    userId: scalars.userId,
    userDeptId: scalars.userDeptId,
    electrodeYn: s(row.ELECTRODE_YN),
    electrodeType: s(row.ELECTRODE_TYPE),
    originFromDivisionId: s(row.ORIGIN_FROM_DIVISION_ID),
    origionToDivisionId: s(row.ORIGIN_TO_DIVISION_ID), // PROC_M 철자 그대로
    remarks: s(row.REMARKS),
    remarks2: s(row.REMARKS2),
    remarks3: s(row.REMARKS3),
    changeReqNo,
    changeReasonCode: s(row.CHANGE_REASON_CODE).replace(/-/g, ''),
    changeReasonDetail: s(row.CHANGE_REASON_DETAIL),
    title: 'Shipment Change Request', // AS-IS siMain.ActiveSheet.SheetName
    programId: MENU_ID,
    shiptoCode: s(row.TO_SITE_SHIPTO_CODE),
  };

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BTN_SAVE_DRAFTING}/call-proc`,
      payload
    );
    // ok 만 true — fail·unknown 둘 다 false 로 접어 성공 토스트가 뜨지 않게 한다.
    return judgeSaveResponse(res) === 'ok';
  } catch {
    return false;
  }
};
