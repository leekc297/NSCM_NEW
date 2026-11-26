import {
  CHK_LOCK_CHECK_STATUS,
  CHK_LOCK_UNCHECK_STATUS,
  CHK_PARTIAL_STATUS,
  CHK_PARTIAL_UNCHECK_DETAIL,
  SAVE_STATUS,
  SUB_COL,
} from '../shipment-change-request-confirm-ssp0003.constants';

// AS-IS SSP0003_ShipmentChangeRequestConfirm.cs 의 FindData_Sub(L722-761, CHK 상태머신)·
//   SaveDraftingData(L817-970)·SaveData(L972-1230) 를 순수 함수로 이식. 그리드/네트워크 의존 없음(테스트 가능).
//   컬럼명은 constants.SUB_COL(ora.py SCM_MST_SHEET_COLUMNS 실측)·SAVE SP 파라미터는 ALL_ARGUMENTS 실측 기준.

type Row = Record<string, unknown>;

// 다행 CLOB 인자의 행 구분자. 쉼표가 아니라 '^' 다 — 바꾸면 다행 저장이 조용히 깨진다.
//   근거 1(TO-BE): PKG_SSP0003 BODY 16 `C_DELIMITER CONSTANT VARCHAR2(1 CHAR) := '^'`.
//     F_SPL_CNT/P_SPL_ARR 가 이 문자로만 토큰을 자르므로 "C1,C2" 는 토큰 1개가 된다
//     → P_SSP0003_SAVE_REQ_DE_CONFIRM 의 DE UPDATE 0건 → P_SSP0003_SAVE_REQ_CONFIRM(_40) 의
//     ATTRIBUTE2='A' 건수 0 → V_CHANGE_STATUS:='R'(BODY 893~935). 화면은 성공 토스트인데
//     헤더는 반려로 저장되고 XIF 에는 승인행이 쌓인다(2026-10-26 결함).
//   근거 2(AS-IS): CString.AppendString 의 기본 delimiter 가 "^" 다
//     (GSCM/01.Framework/GSCM.Windows.Forms/Utility/CString.cs:617) — SSP0003_ShipmentChangeRequestConfirm.cs
//     L879~884 가 이 함수로 p_confirm_id/p_new_confirm_id/p_status_detail 을 조립한다.
//   어느 인자가 CLOB(=행 결합)인지는 ALL_ARGUMENTS 실측이다 — VARCHAR2 스칼라(p_item_id·p_from_site·
//     p_yyyymmdd·p_delegatee·p_last_updated_by 등)는 결합하지 않는다. 자매 화면 SSP0200
//     (shipmentChangeRequestPlanSave.ts) 도 같은 규칙으로 '^' 를 쓴다.
const PROC_ROW_DELIMITER = '^';

/** 다행 CLOB 인자 1건 조립 — 1행이면 구분자 없이 값 그대로. */
const joinRows = (values: string[]): string => values.join(PROC_ROW_DELIMITER);

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';

const rowId = (r: Row): string => str(r[SUB_COL.CONFIRM_ID]);

// CHK 활성 여부 — 마스터 SHIPMENT_STATUS 가 else(Q 등)일 때만 사용자 토글 가능(§3.4 #46/#47).
export const isChkEditable = (masterStatus: string): boolean =>
  !(
    (CHK_LOCK_UNCHECK_STATUS as readonly string[]).includes(masterStatus) ||
    (CHK_LOCK_CHECK_STATUS as readonly string[]).includes(masterStatus) ||
    masterStatus === CHK_PARTIAL_STATUS
  );

// 조회 직후 CHK 초기 체크셋(§3.4 / AS-IS L722-761) — store checkedIds(string[]) 로 반환:
//   E/O/R/S → 전행 해제 / D/A → 전행 체크 / P → STATUS_DETAIL ∈ {R,E,S} 해제·else 체크 / else(Q) → 전행 체크.
export const computeInitialCheckedIds = (rows: Row[], masterStatus: string): string[] => {
  if ((CHK_LOCK_UNCHECK_STATUS as readonly string[]).includes(masterStatus)) return []; // 전행 해제
  if (masterStatus === CHK_PARTIAL_STATUS) {
    return rows
      .filter(r => !(CHK_PARTIAL_UNCHECK_DETAIL as readonly string[]).includes(str(r[SUB_COL.STATUS_DETAIL])))
      .map(rowId);
  }
  // D/A 및 else(Q) → 전행 체크
  return rows.map(rowId);
};

export interface ChkCount {
  checked: number;
  unchecked: number;
}

export const countChk = (rows: Row[], checkedIds: Set<string>): ChkCount => {
  let checked = 0;
  let unchecked = 0;
  for (const r of rows) {
    if (checkedIds.has(rowId(r))) checked += 1;
    else unchecked += 1;
  }
  return { checked, unchecked };
};

// AS-IS ChkDraftingData(L1644-1699) — 액션별 전체체크/체크0 가드. ok=false 면 msgKey 로 alert 후 차단.
export const checkDraftingData = (
  action: string,
  count: ChkCount,
  rejectReason: string
): { ok: boolean; msg?: 'APPROVE_TARGET_REQUIRED' | 'REJECT_REASON_REQUIRED' | 'REJECT_ALL_REQUIRED' | 'SELF_REJECT_ALL_REQUIRED' } => {
  if (action === SAVE_STATUS.APPROVED) {
    if (count.checked === 0) return { ok: false, msg: 'APPROVE_TARGET_REQUIRED' }; // MSG00420
    if (count.unchecked > 0 && rejectReason.trim() === '')
      return { ok: false, msg: 'REJECT_REASON_REQUIRED' }; // MSG00181
    return { ok: true };
  }
  if (action === SAVE_STATUS.REJECT) {
    if (count.unchecked > 0) return { ok: false, msg: 'REJECT_ALL_REQUIRED' }; // MSG00421
    return { ok: true };
  }
  if (action === SAVE_STATUS.SELF_REJECT) {
    if (count.unchecked > 0) return { ok: false, msg: 'SELF_REJECT_ALL_REQUIRED' }; // MSG00422
    return { ok: true };
  }
  return { ok: true };
};

// AS-IS change_status 산출(L908-918 / L1146-1154): A 는 체크/미체크 카운트로 A/R/P, 그 외는 액션 그대로.
export const decideChangeStatus = (action: string, count: ChkCount): string => {
  if (action !== SAVE_STATUS.APPROVED) return action; // R/S/O
  if (count.checked > 0 && count.unchecked === 0) return SAVE_STATUS.APPROVED;
  if (count.checked === 0 && count.unchecked > 0) return SAVE_STATUS.REJECT;
  return SAVE_STATUS.PARTIAL; // 부분 승인
};

// NEW_BASE_CONFIRM_YN='Y' 행의 CONFIRM_ID(승인 base 선정, L840-846). 없으면 ''.
const findBaseConfirmId = (rows: Row[]): string => {
  const base = rows.find(r => str(r[SUB_COL.NEW_BASE_CONFIRM_YN]) === 'Y');
  return base ? rowId(base) : '';
};

// AS-IS SaveDraftingData(L817-942) → PKG_SSP0003.P_SSP0003_SAVE_REQ_DE_CONFIRM (7 IN, ALL_ARGUMENTS 실측).
//   전행 순회: p_confirm_id=base(전행 동일)·p_new_confirm_id=행 CONFIRM_ID·p_status_detail(A:체크A/미체크R, 그 외 status).
export const buildDeConfirmPayload = (
  rows: Row[],
  checkedIds: Set<string>,
  action: string,
  changeStatus: string,
  ctx: { changeReqNo: string; rejectReason: string; userId: string }
): Record<string, string> => {
  const base = findBaseConfirmId(rows);
  const confirmId: string[] = [];
  const newConfirmId: string[] = [];
  const statusDetail: string[] = [];
  for (const r of rows) {
    const isChk = checkedIds.has(rowId(r));
    confirmId.push(base);
    newConfirmId.push(rowId(r));
    statusDetail.push(action === SAVE_STATUS.APPROVED ? (isChk ? 'A' : 'R') : action);
  }
  return {
    changeRequestNo: ctx.changeReqNo,
    changeStatus,
    rejectReason: ctx.rejectReason,
    confirmId: joinRows(confirmId),
    newConfirmId: joinRows(newConfirmId),
    lastUpdatedBy: ctx.userId,
    statusDetail: joinRows(statusDetail),
  };
};

// AS-IS SaveData(L972-1230) → PKG_SSP0003.P_SSP0003_SAVE_REQ_CONFIRM(_40) (36 IN, ALL_ARGUMENTS 실측).
//   A: 체크행만 NEW_* CLOB 에 '^' 누적(미체크 continue) / R·S·O: NEW_* 공란 + p_division_id=행0.
//   반환 is40 = p_division_id 앞2 '40'(L1125) → SAVE_40 라우팅.
export const buildConfirmPayload = (
  rows: Row[],
  checkedIds: Set<string>,
  action: string,
  changeStatus: string,
  ctx: {
    changeReqNo: string;
    rejectReason: string;
    changeType: string;
    delegatee: string;
    delegateeDept: string;
    userId: string;
    /**
     * 사용자 TZ 코드(`sessionTimeZone(session)` = SCM_ADM_USER_M.TMZ_CD).
     *   이 화면에서는 전달만 한다 — PKG_SSP0003 의 FN_MULTY_TIME 호출이 전부 주석 처리돼 있어
     *   현재 동작 영향이 없다(APPROVAL_TIME·LAST_UPDATE_DATE = SYSDATE).
     */
    timeZone: string;
  }
): { payload: Record<string, string>; is40: boolean } => {
  const base = findBaseConfirmId(rows);
  const count = countChk(rows, checkedIds);

  const acc: Record<string, string[]> = {
    confirmId: [],
    divisionId: [],
    newConfirmId: [],
    newEtdDate: [],
    newEtaDate: [],
    newQty: [],
    newShipDate: [],
    newYn: [],
    newBodId: [],
    newRouteId: [],
    newIncoterms: [],
    newDContry: [],
    newDPortCode: [],
    newACountry: [],
    newAPortCode: [],
    newToCountry: [],
    newToCity: [],
    newLtDay: [],
    newTransportMode: [],
    remarks: [],
    remarks2: [],
    remarks3: [],
    erpAttr1: [],
    erpAttr2: [],
    erpAttr3: [],
  };

  let itemId = '';
  let fromSite = '';
  let yyyymmdd = '';

  if (action === SAVE_STATUS.APPROVED) {
    itemId = str(rows[0]?.[SUB_COL.ITEM_ID]);
    fromSite = str(rows[0]?.[SUB_COL.FROM_SITE]);
    yyyymmdd = str(rows[0]?.[SUB_COL.NEW_SHIPMENT_DATE]);
    for (const r of rows) {
      if (!checkedIds.has(rowId(r))) continue; // 미체크(Reject) 행은 승인 payload 제외(L1070-1072)
      acc.confirmId.push(base);
      acc.divisionId.push(str(r[SUB_COL.DIVISION_ID]));
      acc.newConfirmId.push(rowId(r));
      acc.newEtdDate.push(str(r[SUB_COL.NEW_ETD]));
      acc.newEtaDate.push(str(r[SUB_COL.NEW_ETA]));
      const qty = str(r[SUB_COL.NEW_SHIPMENT_CONFIRM_QTY]);
      // AS-IS L1086-1089: 공란이면 그대로, 값이면 Int64 정수화.
      acc.newQty.push(qty === '' ? '' : String(Math.trunc(Number(qty))));
      acc.newShipDate.push(str(r[SUB_COL.NEW_SHIPMENT_DATE]));
      acc.newYn.push(str(r[SUB_COL.NEW_YN]));
      acc.newBodId.push(str(r[SUB_COL.NEW_BOD_ID]));
      acc.newRouteId.push(str(r[SUB_COL.NEW_ROUTE]));
      acc.newIncoterms.push(str(r[SUB_COL.NEW_INCOTERMS]));
      acc.newDContry.push(str(r[SUB_COL.NEW_D_COUNTRY]));
      acc.newDPortCode.push(str(r[SUB_COL.NEW_D_PORT_CODE]));
      acc.newACountry.push(str(r[SUB_COL.NEW_A_COUNTRY]));
      acc.newAPortCode.push(str(r[SUB_COL.NEW_A_PORT_CODE]));
      acc.newToCountry.push(str(r[SUB_COL.NEW_TO_COUNTRY]));
      acc.newToCity.push(str(r[SUB_COL.NEW_TO_CITY]));
      acc.newLtDay.push(str(r[SUB_COL.NEW_LT_DAY]));
      acc.newTransportMode.push(str(r[SUB_COL.NEW_TRANSPORT_MODE]));
      acc.remarks.push(str(r[SUB_COL.REMARKS]));
      acc.remarks2.push(str(r[SUB_COL.REMARKS2]));
      acc.remarks3.push(str(r[SUB_COL.REMARKS3]));
      acc.erpAttr1.push(str(r[SUB_COL.ERP_ATTR1]));
      acc.erpAttr2.push(str(r[SUB_COL.ERP_ATTR2]));
      acc.erpAttr3.push(str(r[SUB_COL.ERP_ATTR3]));
    }
  }

  // p_division_id: A 이고 체크행 있으면 체크행 '^' 목록, 아니면 행0 단일(L1119-1122).
  let divisionId = joinRows(acc.divisionId);
  if (action !== SAVE_STATUS.APPROVED || (count.checked === 0 && count.unchecked > 0)) {
    divisionId = str(rows[0]?.[SUB_COL.DIVISION_ID]);
  }
  const is40 = divisionId.slice(0, 2) === '40';

  const payload: Record<string, string> = {
    // VARCHAR2 스칼라 인자(ALL_ARGUMENTS 실측 position 1~3·5~7·26~28·32~33) — 행 결합하지 않는다.
    changeRequestNo: ctx.changeReqNo,
    changeStatus,
    rejectReason: ctx.rejectReason,
    divisionId,
    itemId,
    fromSite,
    yyyymmdd,
    // 이하 CLOB 인자 — 전부 PROC_ROW_DELIMITER('^') 결합이다.
    confirmId: joinRows(acc.confirmId),
    newConfirmId: joinRows(acc.newConfirmId),
    newEtdDate: joinRows(acc.newEtdDate),
    newEtaDate: joinRows(acc.newEtaDate),
    newQty: joinRows(acc.newQty),
    newShipDate: joinRows(acc.newShipDate),
    newYn: joinRows(acc.newYn),
    newBodId: joinRows(acc.newBodId),
    newRouteId: joinRows(acc.newRouteId),
    newIncoterms: joinRows(acc.newIncoterms),
    newDContry: joinRows(acc.newDContry),
    newDPortCode: joinRows(acc.newDPortCode),
    newACountry: joinRows(acc.newACountry),
    newAPortCode: joinRows(acc.newAPortCode),
    newToCountry: joinRows(acc.newToCountry),
    newToCity: joinRows(acc.newToCity),
    newLtDay: joinRows(acc.newLtDay),
    newTransportMode: joinRows(acc.newTransportMode),
    lastUpdatedBy: ctx.userId,
    timeZone: ctx.timeZone,
    changeType: ctx.changeType,
    remarks: joinRows(acc.remarks),
    remarks2: joinRows(acc.remarks2),
    remarks3: joinRows(acc.remarks3),
    delegatee: ctx.delegatee,
    delegateeDept: ctx.delegateeDept,
    erpAttr1: joinRows(acc.erpAttr1),
    erpAttr2: joinRows(acc.erpAttr2),
    erpAttr3: joinRows(acc.erpAttr3),
  };
  return { payload, is40 };
};
