// master(WH_IN) 저장 payload 조립 (design 03 §4 — P_SSP0015_SAVE_SHIPMENT_PSI).
//   ⚠️ proc 는 각 IN 파라미터를 '^' 로 접은 다중행 문자열로 받아 루프 처리한다
//   (본문 SCM_ARR_SPL_CNT(P_ACTIVE_FLAG,'^') + WHILE LOOP). BE call-proc(makeProcedure)도 단일 Map 을
//   기대하므로, 편집된 D_ 기간셀(측정치 WH_IN 행)을 컬럼별 '^'-폴딩 '단일 객체'로 보낸다(행 객체 배열 아님 —
//   과거 배열 전송이 저장 에러의 원인, 2026-09-30). 음수는 저장 abort(MSG00084).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface MainSaveMeta {
  divisionId: string;
  planStartYyyymmdd: string;
  userId: string;
}

// 편집 셀 1건의 12 IN 값(폴딩 전 단위). 최종 전송은 컬럼별 '^'-join 단일 객체(MainSaveFolded).
interface MainSaveCell {
  activeFlag: string; // P_ACTIVE_FLAG
  divisionId: string; // P_DIVISION_ID
  fromSite: string; // P_FROM_SITE
  itemId: string; // P_ITEM_ID
  planStartYyyymmdd: string; // P_PLAN_START_YYYYMMDD
  yyyymmdd: string; // P_YYYYMMDD (D_ 컬럼 일자)
  planType: string; // P_PLAN_TYPE
  seq: string; // P_SEQ
  measure: string; // P_MEASURE ('WH_IN')
  qty: string; // P_QTY
  userId: string; // P_USER_ID
  debugMode: string; // P_DEBUG_MODE
}

export type MainSaveFolded = Record<keyof MainSaveCell, string>;

/**
 * 편집된 WH_IN 측정치 행의 D_ 셀을 컬럼별 '^'-폴딩 단일 객체로 조립한다.
 *   originalOf: EditTracker 원본값 조회(변경 셀만 대상). negatives: 음수 셀 목록.
 *   변경 셀이 없으면 payload=null.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  dayBindings: string[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  meta: MainSaveMeta
): { payload: MainSaveFolded | null; negatives: string[] } => {
  const cells: MainSaveCell[] = [];
  const negatives: string[] = [];
  rows.forEach(row => {
    if (str(row.MEASURE) !== 'WH_IN') return;
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    dayBindings.forEach(binding => {
      const current = row[binding];
      const orig = original?.[binding];
      if (orig === undefined) return; // 변경 셀만
      // D_ 기간셀은 수치/문자 primitive — str() 정규화로 비교(no-base-to-string 회피)
      if (str(current) === str(orig)) return;
      const qty = Number(current ?? 0);
      const yyyymmdd = binding.slice(2);
      if (qty < 0) {
        negatives.push(`${str(row.ITEM_ID)}:${yyyymmdd}`);
        return;
      }
      cells.push({
        // proc P_SSP0015_SAVE_SHIPMENT_PSI 은 activeFlag='M'(수정)·'I'(삽입)일 때만 DML 실행(본문 IF V_ACTIVE_FLAG
        //   = 'M' OR 'I'). 편집 셀은 수정이므로 'M'. 'U' 는 no-op 라 "성공인데 미저장" 사고(2026-09-30).
        activeFlag: 'M',
        divisionId: meta.divisionId,
        fromSite: str(row.FROM_SITE),
        itemId: str(row.ITEM_ID),
        planStartYyyymmdd: meta.planStartYyyymmdd,
        yyyymmdd,
        planType: str(row.PLAN_TYPE),
        seq: str(row.SEQ),
        measure: 'WH_IN',
        qty: String(qty),
        userId: meta.userId,
        debugMode: 'F',
      });
    });
  });
  if (cells.length === 0) return { payload: null, negatives };
  // 컬럼별 '^'-폴딩 — proc 이 파라미터마다 같은 개수의 세그먼트를 기대(SCM_ARR_SPL_CNT 기준 루프).
  const fold = (k: keyof MainSaveCell): string => cells.map(c => c[k]).join('^');
  const payload: MainSaveFolded = {
    activeFlag: fold('activeFlag'),
    divisionId: fold('divisionId'),
    fromSite: fold('fromSite'),
    itemId: fold('itemId'),
    planStartYyyymmdd: fold('planStartYyyymmdd'),
    yyyymmdd: fold('yyyymmdd'),
    planType: fold('planType'),
    seq: fold('seq'),
    measure: fold('measure'),
    qty: fold('qty'),
    userId: fold('userId'),
    debugMode: fold('debugMode'),
  };
  return { payload, negatives };
};

// 날짜 입력값을 YYYYMMDD 로 정규화한다. 숫자 8자리가 아니거나 없는 날짜면 null.
export const toValidYmd = (v: unknown): string | null => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  if (digits.length !== 8) return null;
  const y = Number(digits.slice(0, 4));
  const m = Number(digits.slice(4, 6));
  const d = Number(digits.slice(6, 8));
  const date = new Date(y, m - 1, d);
  if (date.getFullYear() !== y || date.getMonth() !== m - 1 || date.getDate() !== d) return null;
  return digits;
};

// 날짜를 yyyy-MM-dd 로 맞춘다. 날짜로 읽을 수 없으면 원래 값 그대로
const toDashYmd = (v: unknown): string => {
  const ymd = toValidYmd(v);
  return ymd ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : str(v);
};

// ────────────────────────────────────────────────────────────────────────────────────────
// 수정행 변경요청 초안 저장 — P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING (35 IN, '^'-폴딩 단일 객체)
// ────────────────────────────────────────────────────────────────────────────────────────
// AS-IS 는 수정행 저장에서 **CONFIRM_40 이 아니라 이 proc 을 먼저** 부른다(cs:7011/7015). 이것이
//   CHG_REQ·CHG_REQ_DE 를 INSERT 하고 CHANGE_REQ_NO 를 채번해 돌려주며(O_RC1 REQUEST_NO, BODY L9679),
//   그 안에서 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('C', V_MAX_REQ_NO) 로 XIF 'C' 행까지 적재한다(BODY L9667).
//   CONFIRM_40 은 그 뒤 단계로, SSP_ANL_SHIP_CONFIRM·PLAN_40·이력·메일만 건드리고 XIF INSERT 는 없다 —
//   둘은 쓰는 표가 달라 중복 저장이 아니다.
// 파라미터 35개는 ALL_ARGUMENTS 실측 순서·이름이 AS-IS cs:7020~7056 과 일치한다.
//   행별 폴딩 값의 원천 컬럼도 AS-IS 루프(cs:6967~6994) 그대로다.
export interface DraftingSaveMeta {
  userId: string;
  /** AS-IS `UserInfoContext.Current[Dept_ID]`(cs:6943). TO-BE 세션에 부서 필드가 없어 공란이다(잔여). */
  userDeptId: string;
  /** AS-IS `siDetail.ActiveSheet.SheetName`(cs:6959) — 디테일 시트 이름. */
  title: string;
  /** AS-IS `this.Name`(cs:6961) — 화면 식별자. */
  programId: string;
}

export type DraftingSaveFolded = Record<string, string>;

export const collectDraftingSaveRows = (
  dirty: Record<string, unknown>[],
  meta: DraftingSaveMeta
): DraftingSaveFolded | null => {
  if (dirty.length === 0) return null;
  const activeFlagOf = (r: Record<string, unknown>): string => {
    const c = str(r.CRUD_TYPE);
    if (c) return c;
    return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
  };
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: activeFlagOf,
    divisionId: r => str(r.DIVISION_ID),
    confirmId: r => str(r.CONFIRM_ID),
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY),
    shipmentDate: r => toDashYmd(r.SHIPMENT_DATE),
    fromSite: r => str(r.FROM_SITE),
    newBodId: r => str(r.NEW_BOD_ID),
    newRouteId: r => str(r.NEW_ROUTE_ID),
    newEtdDate: r => toDashYmd(r.NEW_ETD),
    newEtaDate: r => toDashYmd(r.NEW_ETA),
    newIncoterms: r => str(r.INCOTERMS),
    newTransportMode: r => str(r.TRANSPORT_MODE),
    newDContry: r => str(r.NEW_D_COUNTRY), // proc 파라미터 철자가 CONTRY 다(원본 유지)
    newDPortCode: r => str(r.NEW_D_PORT_CODE),
    newACountry: r => str(r.NEW_A_COUNTRY),
    newAPortCode: r => str(r.NEW_A_PORT_CODE),
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT),
    newToCountry: r => str(r.NEW_TO_COUNTRY),
    newToCity: r => str(r.NEW_TO_CITY),
    editMain: r => str(r.EDIT_MAIN),
    editRemark: r => str(r.EDIT_REMARKS),
    electrodeYn: r => str(r.ELECTRODE_YN),
    electrodeType: r => str(r.ELECTRODE_TYPE),
    originFromDivisionId: r => str(r.ORIGIN_FROM_DIVISION_ID),
    origionToDivisionId: r => str(r.ORIGIN_TO_DIVISION_ID), // proc 파라미터 철자가 ORIGION 이다
    remarks: r => str(r.REMARKS),
    remarks2: r => str(r.REMARKS2),
    remarks3: r => str(r.REMARKS3),
    // AS-IS 가 '-' 를 제거해 보낸다(cs:6993 `.Replace("-", "")`) — 사유코드에 하이픈이 섞인 표기 방어.
    changeReasonCode: r => str(r.CHANGE_REASON_CODE).replace(/-/g, ''),
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL),
    shiptoCode: r => str(r.TO_SITE_SHIPTO_CODE),
    title: () => meta.title,
  };
  const payload: DraftingSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  // 사용자·부서·화면 ID 는 요청 1건에 1값이다 — 행마다 접지 않고 스칼라로 보낸다(결함 D-2).
  //   P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING 은 이 값들을 '^' 로 분해하지 않고 CHG_REQ 의
  //   REQUEST_USER·REQUEST_DEPT·CREATED_BY 와 CHG_REQ_DE.LAST_UPDATED_BY 에 그대로 넣는다.
  //   종전엔 행 수만큼 접혀 'id^id^id'·'^^' 가 저장됐다(dev R20261026542927, 2026-10-26).
  //   자매 SSP0200 초안 저장(shipmentChangeRequestPlanSave)도 이 셋을 스칼라로 보낸다.
  payload.userId = meta.userId;
  payload.userDeptId = meta.userDeptId;
  payload.programId = meta.programId;
  return payload;
};

// Confirm Detail 저장 — P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 (24 IN, '^'-폴딩 단일 객체).
//   proc 파라미터가 전건 VARCHAR 라 BE execBtn 의 JVARCHAR 폴딩을 안 타고(makeProcedure 는 단일 Map 에서
//   camelCase 키를 꺼냄), 본문이 SCM_ARR_SPL_CNT(P_ACTIVE_FLAG,'^') WHILE LOOP 로 다중행을 돈다 →
//   FE 가 dirty 행을 컬럼별 '^'-폴딩한 단일 객체로 보내야 한다(배열 {data:[]} 전송은 전건 null → 미저장).
//   행→파라미터 매핑은 AS-IS SSP0015.cs SaveData_Detail_Packer L5503~5526 그대로.
export type ConfirmSaveFolded = Record<string, string>;

export const collectConfirmSaveRows = (
  dirty: Record<string, unknown>[],
  userId: string
): ConfirmSaveFolded | null => {
  if (dirty.length === 0) return null;
  // 행당 activeFlag — CRUD_TYPE(M/I/D). 편집행은 EDIT_MAIN='Y' 만 있고 CRUD_TYPE 공란일 수 있어 'M' 보정.
  const activeFlagOf = (r: Record<string, unknown>): string => {
    const c = str(r.CRUD_TYPE);
    if (c) return c;
    return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
  };
  // proc camelCase 파라미터 → 행 컬럼(AS-IS 매핑). userId/checkNeedYn 은 상수(행마다 반복 폴딩).
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: activeFlagOf,
    divisionId: r => str(r.DIVISION_ID),
    confirmId: r => str(r.CONFIRM_ID),
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY),
    // shipmentDate: r => str(r.SHIPMENT_DATE), // proc 가 SUBSTR(1,10)+REPLACE('-') 로 정규화
    // proc 는 '-' 만 제거하므로 '2026.10.29' 같은 값은 ORA-01858. yyyy-MM-dd 로 맞춰 보낸다
    shipmentDate: r => toDashYmd(r.SHIPMENT_DATE),
    newBodId: r => str(r.NEW_BOD_ID),
    newRouteId: r => str(r.NEW_ROUTE_ID),
    // newEtdDate: r => str(r.NEW_ETD),
    // newEtaDate: r => str(r.NEW_ETA),
    newEtdDate: r => toDashYmd(r.NEW_ETD),
    newEtaDate: r => toDashYmd(r.NEW_ETA),
    newIncoterms: r => str(r.INCOTERMS),
    newTransportMode: r => str(r.TRANSPORT_MODE),
    newDContry: r => str(r.NEW_D_COUNTRY),
    newDPortCode: r => str(r.NEW_D_PORT_CODE),
    newACountry: r => str(r.NEW_A_COUNTRY),
    newAPortCode: r => str(r.NEW_A_PORT_CODE),
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT),
    newToCountry: r => str(r.NEW_TO_COUNTRY),
    newToCity: r => str(r.NEW_TO_CITY),
    remarks: r => str(r.REMARKS),
    remarks2: r => str(r.REMARKS2),
    remarks3: r => str(r.REMARKS3),
    userId: () => userId,
    checkNeedYn: () => 'Y',
    editMain: r => str(r.EDIT_MAIN),
    // Packer 저장(SAVE_..._CONFIRM_PACKER)만 받는 추가 파라미터. _40 proc 은 이름 매칭이라 무시(무해).
    shiptoCode: r => str(r.TO_SITE_SHIPTO_CODE),
  };
  const payload: ConfirmSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  // userId 는 감사컬럼(P_USER_ID 스칼라) — SP 가 '^' 분해 없이 CREATED_BY/CHG_REQ 에 그대로 넣으므로
  //   폴딩하면 안 된다(결함 D-2, SSP0060 collectRequestConfirmSaveRows 동일 수정). 위 루프가 N행만큼 접은
  //   값을 단일 userId 로 복구한다 — 종전 누락으로 XIF CREATED_BY 가 "userId^…" 로 적재됐다(2026-11-11).
  payload.userId = userId;
  return payload;
};

// Hold stock 저장 - P_SSP0015_SAVE_BLOCK_STOCK_DATA (13 IN, '^'-폴딩 단일 객체).
//   proc 가 P_ACTIVE_FLAG 를 '^' 로 잘라 루프를 돈다. 행 배열로 보내면 0건 처리 후 성공만 반환한다.
//   plan 3종은 AS-IS 와 같이 master 활성행 값이다(SSP0015.cs L5926~5928).
export interface HoldSaveMeta {
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  userId: string;
}

export type HoldSaveFolded = Record<string, string>;

export const collectHoldSaveRows = (
  dirty: Record<string, unknown>[],
  meta: HoldSaveMeta
): HoldSaveFolded | null => {
  if (dirty.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: r => str(r.CRUD_TYPE),
    holdId: r => str(r.HOLD_ID),
    planStartYyyymmdd: () => meta.planStartYyyymmdd,
    planType: () => meta.planType,
    seq: () => meta.seq,
    divisionId: r => str(r.DIVISION_ID),
    fromSite: r => str(r.FROM_SITE),
    itemId: r => str(r.ITEM_ID),
    holdYyyymmdd: r => toValidYmd(r.HOLD_YYYYMMDD) ?? '',
    releaseYyyymmdd: r => toValidYmd(r.RELEASE_YYYYMMDD) ?? '',
    holdQty: r => str(r.HOLD_QTY),
    remarks: r => str(r.REMARKS),
    userId: () => meta.userId,
  };
  const payload: HoldSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  return payload;
};
