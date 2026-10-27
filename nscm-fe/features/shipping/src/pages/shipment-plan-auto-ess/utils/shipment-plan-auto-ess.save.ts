// PlanDetail Confirm 저장 payload 조립 (design 03 §4.3) — 순수 함수.
//   주의: PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM(24 IN)은 파라미터가 전건 VARCHAR 라
//   BE 의 JVARCHAR 폴딩(MapUtils.cvtJsonToJVarchar)을 타지 않는다. 본문이 SCM_ARR_SPL_CNT(P_ACTIVE_FLAG,'^')
//   + WHILE LOOP 로 다건을 돌고 UPDATE ... WHERE CONFIRM_ID = V_CONFIRM_ID 로 건별 반영한다(DB ALL_SOURCE
//   L5205~5444 실측). 즉 FE 가 편집 행들을 **컬럼별 '^'-폴딩한 단일 객체**로 보내야 한다 — 행 객체 배열
//   ({data:[]}) 전송(useProcMutation)은 전건 null 바인딩 → P_ACTIVE_FLAG 빈값 → SCM_ARR_SPL_CNT=0 →
//   루프 0회 → 0행 UPDATE 인데 성공 반환(false-success)이다(자매 SSP0060/SSP0015 선례, memory
//   `save-proc-per-column-caret-fold-fe`). payload 키 = SCM_ADM_PROC_M COL_NM(camelCase = all_arguments
//   P_ 제거 + camel, memory `generic-callproc-param-key-must-match-proc-m-colnm`).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행당 activeFlag — CRUD_TYPE(M/I/D). 편집행은 EDIT_MAIN='Y' 만 있고 CRUD_TYPE 공란일 수 있어 'M' 보정
//   (DetailGrid cellEditEnded 는 편집 당사자 행에 EDIT_MAIN 만 세팅, CRUD_TYPE 미세팅). proc 은
//   IF V_ACTIVE_FLAG <> 'I' THEN UPDATE(L5379) 이라 'M' 이면 수정 반영된다. 빈값이면 SCM_ARR_SPL_CNT 집계·
//   루프 자체가 안 돌아 저장이 전무해진다(false-success 근원). AS-IS 의 행 action(I/M/D) 과 같은 값이다.
export const rowActiveFlag = (r: Record<string, unknown>): string => {
  const c = str(r.CRUD_TYPE);
  if (c) return c;
  return str(r.EDIT_MAIN) === 'Y' ? 'M' : '';
};

// PlanDetail Confirm 저장 — P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM (24 IN, '^'-폴딩 단일 객체).
//   키·행매핑은 05_register_proc_m_confirm 의 COL_NM↔그리드 컬럼 실측(= AS-IS SaveData_Detail
//   .cs L2628-2688 DefColumns)을 그대로 따른다. 자매 SSP0060 collectConfirmSaveRows(38 IN)와 동일 규약,
//   키 집합만 SSP0021 24 IN 으로 축소(SSP0021 proc 은 fromSite/toSite/changeReason/productLevel 파라미터 없음 —
//   사이트 정보는 proc 가 CONFIRM_ID 로 내부 재조회, CHANGE_REASON 은 confirm 테이블에 저장 안 함 = AS-IS 동일).
export type ConfirmSaveFolded = Record<string, string>;

export const collectConfirmSaveRows = (
  dirty: Record<string, unknown>[],
  userId: string
): ConfirmSaveFolded | null => {
  if (dirty.length === 0) return null;
  const activeFlagOf = rowActiveFlag;
  // proc camelCase 파라미터(SORT_ORD 1~24) → 행 컬럼. 상수(''/'Y')는 행마다 반복 폴딩.
  //   단 P_USER_ID(22)는 스칼라로 보낸다(아래). SP 가 행별로 쪼개지 않고 그대로 저장한다.
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: activeFlagOf, // 1  P_ACTIVE_FLAG (CRUD_TYPE)
    divisionId: r => str(r.DIVISION_ID), // 2  P_DIVISION_ID
    confirmId: r => str(r.CONFIRM_ID), // 3  P_CONFIRM_ID (UPDATE 키)
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY), // 4  P_SHIPMENT_QTY
    // 5  P_SHIPMENT_DATE — 'YYYYMMDD' 로 정규화해 보낸다(그리드 값은 '2026-10-15' 대시 포맷).
    //   proc 의 BOD 경로 조회(SCP_MST_BOD_N_V)가 저장 전 필수 게이트인데
    //   `A.FROM_YYYYMMDD <= V_SHIPMENT_DATE AND A.TO_YYYYMMDD >= V_SHIPMENT_DATE` 를 **대시 제거 전** 값으로
    //   비교한다 → '20260101' <= '2026-10-15' 가 문자열상 거짓('-'(0x2D) < '0'(0x30))이라 0건 → V_*_TEMP
    //   NULL → 'X' 조기반환(저장 실패). 자매 SSP0060 proc 은 2026.10.16(AJS)에 이 비교를
    //   `<= REPLACE(SUBSTR(V_SHIPMENT_DATE,1,10),'-','')` 로 인라인 정규화해 고쳤으나 SSP0021 proc 에는
    //   그 패치가 누락돼 있다(ora.py 실측: 대시 0건 / '20261015' 1건). proc 가 내부에서도 같은
    //   REPLACE(SUBSTR) 정규화를 하므로(UPDATE 직전) FE 선정규화는 안전·forward-compatible 하다
    //   (DB 측 proc 파리티 패치 시 no-op). 그 패치가 배포되면 이 slice/replace 는 제거 가능.
    shipmentDate: r => str(r.SHIPMENT_DATE).slice(0, 10).replace(/-/g, ''),
    newBodId: r => str(r.NEW_BOD_ID), // 6  P_NEW_BOD_ID
    newRouteId: r => str(r.NEW_ROUTE_ID), // 7  P_NEW_ROUTE_ID
    newEtdDate: r => str(r.NEW_ETD), // 8  P_NEW_ETD_DATE
    newEtaDate: r => str(r.NEW_ETA), // 9  P_NEW_ETA_DATE
    newIncoterms: r => str(r.INCOTERMS), // 10 P_NEW_INCOTERMS
    newTransportMode: r => str(r.TRANSPORT_MODE), // 11 P_NEW_TRANSPORT_MODE
    newDContry: r => str(r.NEW_D_COUNTRY), // 12 P_NEW_D_CONTRY (proc 파라미터 철자 그대로)
    newDPortCode: r => str(r.NEW_D_PORT_CODE), // 13 P_NEW_D_PORT_CODE
    newACountry: r => str(r.NEW_A_COUNTRY), // 14 P_NEW_A_COUNTRY
    newAPortCode: r => str(r.NEW_A_PORT_CODE), // 15 P_NEW_A_PORT_CODE
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT), // 16 P_NEW_CUSTOMER_LT
    newToCountry: r => str(r.NEW_TO_COUNTRY), // 17 P_NEW_TO_COUNTRY
    newToCity: r => str(r.NEW_TO_CITY), // 18 P_NEW_TO_CITY
    remarks: r => str(r.REMARKS), // 19 P_REMARKS
    remarks2: r => str(r.REMARKS2), // 20 P_REMARKS2
    remarks3: r => str(r.REMARKS3), // 21 P_REMARKS3
    checkNeedYn: () => 'Y', // 23 P_CHECK_NEED_YN (AS-IS 상수 'Y' 강제 — SSP0021_ShipmentPlan.cs)
    editMain: r => str(r.EDIT_MAIN), // 24 P_EDIT_MAIN
  };
  const payload: ConfirmSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = dirty.map(getter).join('^');
  }
  // 22 P_USER_ID — 세션 사용자 1값(스칼라). 행마다 접으면 안 된다.
  //   PKG_SSP0021.P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM 은 P_USER_ID 를 SCM_ARR_SPL 로 분해하지 않고
  //   CONFIRM.LAST_UPDATED_BY·CONFIRM_H·CHG_REQ.REQUEST_USER/CREATED_BY·CHG_REQ_DE 에 그대로 넣고,
  //   부서도 `WHERE USER_ID = P_USER_ID` 로 조회한다. 접어 보내면 'id^id^id' 가 저장되고 부서가 빈다
  //   (SSP0015 결함 D-2 와 같은 원인, dev R20261026542927). 자매 SSP0060 SP 는 첫 토큰만 쓰도록
  //   방어돼 있지만 이 SP 에는 없다(2026-10-27 패키지 본문 확인).
  payload.userId = userId;
  return payload;
};

// 변경사유 필수 판정 — AS-IS Validation_Check(SSP0021_ShipmentPlan.cs L2961~3186, SSP0060 동일 구조).
//   수정 행('M')은 출하수량·출하일·운송수단 중 하나라도 바뀌었을 때만 사유를 요구한다(MSG00285 → TO-BE MSG01289).
//   비고(REMARKS·REMARKS2)만 바뀐 행과 신규 행('I')은 사유 검사를 하지 않는다(신규 행 분기 L3189~ 에 사유 검사 없음).
//   original 은 EditTracker 가 보관한 "현재 값과 다른 컬럼의 원본값" 맵이라, 키가 있으면 그 컬럼이 바뀐 것이다
//   (되돌리면 키가 지워진다). 종전엔 저장 대상 전 행에 사유를 강제했다(결함 B10).
export const SHIPMENT_CHANGE_KEYS = ['SHIPMENT_CONFIRM_QTY', 'SHIPMENT_DATE', 'TRANSPORT_MODE'] as const;

export const needsChangeReason = (
  row: Record<string, unknown>,
  original: Record<string, unknown> | undefined
): boolean => {
  if (str(row.CRUD_TYPE) === 'I') return false;
  if (!original) return false;
  return SHIPMENT_CHANGE_KEYS.some(key => key in original);
};

// 날짜를 yyyy-MM-dd 로 맞춘다. 숫자 8자리가 아니면 원래 값 그대로(SSP0015 save.ts toDashYmd 와 같은 규칙).
//   DRAFTING SP 는 출하일을 REPLACE(SUBSTR(V_SHIPMENT_DATE,1,10),'-','') 로 정규화한다(PKG_SSP0021 L4682~4684, L4822).
const toDashYmd = (v: unknown): string => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  return digits.length === 8 ? `${digits.slice(0, 4)}-${digits.slice(4, 6)}-${digits.slice(6, 8)}` : str(v);
};

// ERP_SO_NO 가 '' 또는 '-' 이면 SO 없음. '-' 는 PKG_SSP0021 L3885 가 계획(P) 행에 채우는 자리표시다.
export const erpSoNoOf = (r: Record<string, unknown>): string => {
  const so = str(r.ERP_SO_NO).trim();
  return so === '-' ? '' : so;
};

// ────────────────────────────────────────────────────────────────────────────────────────
// 변경요청 초안 — P_SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING (34 IN, '^'-폴딩 단일 객체)
// ────────────────────────────────────────────────────────────────────────────────────────
// 파라미터는 pkg_ssp0021_spec.sql(2026-10-27 덤프) 실측 34개다. SSP0015 의 35키에서 shiptoCode 만 없다.
//   PROC_M COL_NM 은 01_ERP연쇄_버튼라우팅_PROC메타_추가.sql L150~216 과 같다(newDContry·origionToDivisionId 오타 그대로).
//   행 값의 원천 컬럼은 AS-IS NonSoNo(SSP0021_ShipmentPlan.cs L3478~3515)·SoNo(L3679~3735) 그대로다.
//   SP 는 호출 1회에 요청번호 1개를 채번한다(PKG_SSP0021 L4748 SEQ1_SSP_ANL_SHIP_CHG_REQ_NO, L4991 CHG_BATCH('C'), L5002 REQUEST_NO 반환).
export interface DraftingSaveMeta {
  userId: string;
  /** AS-IS UserInfoContext[Dept_ID](cs:3455). TO-BE 세션에 부서 필드가 없어 공란이다. */
  userDeptId: string;
  /** AS-IS siDetail.ActiveSheet.SheetName(cs:3469, 3513) = "Shipment Plan Detail". */
  title: string;
  /** AS-IS this.Name(cs:3471, 3515). TO-BE 는 SSP0015 와 같이 화면 ID 를 보낸다(로그 프로그램명에만 쓰인다). */
  programId: string;
}

export type DraftingSaveFolded = Record<string, string>;

// PKG_SSP0021 DRAFTING 의 V_PROGRAM_NAME VARCHAR2(150) — title 폴딩 길이 상한(BODY L4528).
const PROGRAM_NAME_MAX_BYTES = 150;

export const collectDraftingSaveRows = (
  rows: Record<string, unknown>[],
  meta: DraftingSaveMeta
): DraftingSaveFolded | null => {
  if (rows.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: rowActiveFlag, // 1
    divisionId: r => str(r.DIVISION_ID), // 2
    confirmId: r => str(r.CONFIRM_ID), // 3
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY), // 4
    shipmentDate: r => toDashYmd(r.SHIPMENT_DATE), // 5 (AS-IS 'yyyy-MM-dd HH:mm:ss.fff', SP 가 앞 10자리만 씀)
    fromSite: r => str(r.FROM_SITE), // 6
    newBodId: r => str(r.NEW_BOD_ID), // 7
    newRouteId: r => str(r.NEW_ROUTE_ID), // 8
    newEtdDate: r => toDashYmd(r.NEW_ETD), // 9
    newEtaDate: r => toDashYmd(r.NEW_ETA), // 10
    newIncoterms: r => str(r.INCOTERMS), // 11 (AS-IS 도 INCOTERMS 컬럼을 보낸다, cs:3487)
    newTransportMode: r => str(r.TRANSPORT_MODE), // 12
    newDContry: r => str(r.NEW_D_COUNTRY), // 13 P_NEW_D_CONTRY (proc 철자 그대로)
    newDPortCode: r => str(r.NEW_D_PORT_CODE), // 14
    newACountry: r => str(r.NEW_A_COUNTRY), // 15
    newAPortCode: r => str(r.NEW_A_PORT_CODE), // 16
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT), // 17
    newToCountry: r => str(r.NEW_TO_COUNTRY), // 18
    newToCity: r => str(r.NEW_TO_CITY), // 19
    editMain: r => str(r.EDIT_MAIN), // 20
    editRemark: r => str(r.EDIT_REMARKS), // 21
    electrodeYn: r => str(r.ELECTRODE_YN), // 24
    electrodeType: r => str(r.ELECTRODE_TYPE), // 25
    originFromDivisionId: r => str(r.ORIGIN_FROM_DIVISION_ID), // 26
    origionToDivisionId: r => str(r.ORIGIN_TO_DIVISION_ID), // 27 P_ORIGION_TO_DIVISION_ID (proc 철자 그대로)
    remarks: r => str(r.REMARKS), // 28
    remarks2: r => str(r.REMARKS2), // 29
    remarks3: r => str(r.REMARKS3), // 30
    // 31 — AS-IS 가 '-' 를 지워 보낸다(cs:3510, 3729 `.Replace("-", "")`). 콤보의 '-' 선두행이 빈값이 되고,
    //   SP 는 빈값이면 'T07' 로 채운다(PKG_SSP0021 L4592~4594).
    changeReasonCode: r => str(r.CHANGE_REASON_CODE).replace(/-/g, ''),
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL), // 32
    // 33 — 행마다 접는다. SP 가 SCM_ARR_SPL_VAL(P_TITLE) 로 행별로 자른다(PKG_SSP0021 L4567).
    title: () => meta.title,
  };
  const payload: DraftingSaveFolded = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = rows.map(getter).join('^');
  }
  // 33 title 길이 방어 — SP 선언부 `V_PROGRAM_NAME VARCHAR2(150) := P_PROGRAM_ID || '-' || P_TITLE`
  //   (PKG_SSP0021 BODY L4528)가 접힌 title 전체를 붙인다. 150바이트를 넘으면 선언부 대입이라 예외 처리도
  //   못 잡고 ORA-06502 로 BE 500 이 난다('Shipment Plan Detail'^… 이면 같은 SO 6행 남짓부터).
  //   넘을 때만 첫 행에 title 을 두고 나머지 행은 빈 값으로 보낸다(행 수·순서는 유지 — 빈 행의 요청 제목은
  //   'Change on ' 만 남는다). DB 의뢰 03b(SUBSTRB 가드)가 적용되면 이 분기는 타지 않아도 된다.
  if (new TextEncoder().encode(`${meta.programId}-${payload.title}`).length > PROGRAM_NAME_MAX_BYTES) {
    payload.title = rows.map((_, i) => (i === 0 ? meta.title : '')).join('^');
  }
  // 22 userId · 23 userDeptId · 34 programId 는 요청 1건에 1값이다 — 스칼라(결함 D-2).
  //   SP 가 '^' 로 분해하지 않고 CHG_REQ.REQUEST_USER·REQUEST_DEPT·CREATED_BY 등에 그대로 넣는다(PKG_SSP0021 L4787~4799).
  payload.userId = meta.userId;
  payload.userDeptId = meta.userDeptId;
  payload.programId = meta.programId;
  return payload;
};

// ERP 송신 단위 — AS-IS GetERPInterface 두 번째 루프(cs:3274~3310).
//   신규(I) 행과 CHANGE_TYPE='P' 행은 건너뛴다. SO 없는 행은 1행이 1단위(NonSoNo, cs:3429),
//   SO 있는 행은 같은 SO 의 변경 행 전부가 1단위(SoNo, cs:3616 — 같은 SO 를 앞에서 이미 처리했으면 건너뜀(cs:3621)).
//   단위마다 DRAFTING 1회 → 요청번호 1개 → ERP 송신 1회다.
export const buildDraftingUnits = (dirty: Record<string, unknown>[]): Record<string, unknown>[][] => {
  const units: Record<string, unknown>[][] = [];
  const doneSo = new Set<string>();
  const skip = (r: Record<string, unknown>): boolean => str(r.CHANGE_TYPE) === 'P';
  for (const row of dirty) {
    if (skip(row)) continue;
    if (rowActiveFlag(row) === 'I') continue;
    const so = erpSoNoOf(row);
    if (!so) {
      units.push([row]);
      continue;
    }
    if (doneSo.has(so)) continue;
    doneSo.add(so);
    // SoNo(cs:3679~3735) 는 같은 SO 의 변경 행을 접는다(CHANGE_TYPE='P' 제외). 신규(I) 행은 넣지 않는다 —
    //   AS-IS 는 action≠I 인 행만 송신 단위로 삼는다(cs:3289). Insert 는 CONFIRM_ID 를 복사하므로 I 행이 섞이면
    //   DRAFTING 에 원본과 같은 CONFIRM_ID 가 'I' 로 한 번 더 들어간다. I 행은 CONFIRM(SAVE) 'I' 경로로만 저장된다.
    units.push(dirty.filter(r => !skip(r) && rowActiveFlag(r) !== 'I' && erpSoNoOf(r) === so));
  }
  return units;
};

// ERP 응답 E_MESSAGE 파싱 — AS-IS GetErpIFCheckNew(cs:3998~4012): 끝 '^' 제거, '^' 분리, ':' 앞이 CONFIRM_ID.
export interface ErpErrorItem {
  confirmId: string;
  message: string;
}

export const parseErpErrors = (eMessage: string): ErpErrorItem[] => {
  const body = eMessage.endsWith('^') ? eMessage.slice(0, -1) : eMessage;
  if (body.trim() === '') return [];
  return body
    .split('^')
    .map(part => {
      const at = part.indexOf(':');
      return at < 0
        ? { confirmId: part.trim(), message: '' }
        : { confirmId: part.slice(0, at).trim(), message: part.slice(at + 1).trim() };
    })
    .filter(e => e.confirmId !== '');
};
