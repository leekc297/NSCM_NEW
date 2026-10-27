// 저장 payload 조립 (design 03 §4.3) — 순수 함수.
//   siMain 시뮬레이션 저장: 편집 마킹된 활성 span 의 D_ 셀(P_SHIP_PLAN_SIMU_ETD 측정치 행)만
//     (row 식별키 + YYYYMMDD + 값) flat 리스트로 조립 — 그리드 전체 전송 금지.
//   siDetail 저장: action∈{I,M} 행의 편집 화이트리스트 컬럼 전송.
//   dirty 판정은 AS-IS ForeColor=Red 대신 EditTracker 원본값 비교(CRUD_TYPE 'M' + 셀/컬럼 diff)로 재현.
//   payload 키 = SCM_ADM_PROC_M COL_NM 실측(2026-09-27 메인세션 ora.py):
//     PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU IN 14키 =
//       activeFlag / divisionId / companyId / plantId / scmSiteId / modelId / itemId /
//       npcItemId / yyyymmdd / qty / planStartYyyymmdd / measure / lastUpdatedBy / electrodeType.
//     SP 본문(ALL_SOURCE PACKAGE BODY:3468~3494) UPDATE/INSERT WHERE 식별키 9개 =
//       DIVISION_ID·COMPANY_ID·PLANT_ID·SCM_SITE_ID·MODEL_ID·ITEM_ID·MEASURE·YYYYMMDD·PLAN_START_YYYYMMDD.
//     필수: plantId/scmSiteId/modelId 누락 시 WHERE 불일치로 UPDATE ROWCOUNT=0·INSERT 0행 =
//       조용한 no-op 저장(저장은 성공처럼 보이나 미반영). 세 컬럼 모두 main 시트 행에 존재(SHEET_COLUMNS 실측).
//     npcItemId 는 INSERT 시 기존 행에서 SELECT(파라미터로 필터 안 함) → 공백 전송 안전(키 정렬용).
//     electrodeType 은 QTY_TO_PCM 환산 조회(:3414)에 쓰이므로 행값 전송.

import dayjs from '@foundation/dayjs';

import { parseDynTag, type DynSpan } from './shipment-plan-electrode.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

export interface MainSaveContext {
  divisionId: string;
  companyId: string;
  planStartYyyymmdd: string; // 선택 Plan Date
  userId: string; // lastUpdatedBy 로 전송
  activeSpan: DynSpan; // 활성 radio span(X/Y/Z) — 이 span 의 D_ 셀만 저장 대상
}

export type MainSaveRow = Record<string, string>;

/**
 * siMain 시뮬레이션 저장 대상 수집 — 편집된 (활성 span) D_ 셀만 flat 행으로.
 *   originalOf: EditTracker 가 보관한 행별 "변경된 컬럼 원본값" 맵(그 키 중 활성 span D_ 만 diff).
 *   음수(MSG00225)는 negatives 로 분리 — 호출부가 저장 자체를 abort 한다.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  ctx: MainSaveContext
): { payload: MainSaveRow[]; negatives: { row: Record<string, unknown>; day: string }[] } => {
  const payload: MainSaveRow[] = [];
  const negatives: { row: Record<string, unknown>; day: string }[] = [];

  rows.forEach(row => {
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    if (!original) return;
    Object.keys(original).forEach(binding => {
      const tag = parseDynTag(binding);
      // 활성 span 의 일자(D_) 셀만 — W_/M_(Sum)·비활성 span 은 저장 대상 아님(03 §2.2)
      // if (!tag || tag.span !== ctx.activeSpan || tag.bucket !== 'D') return;
      // UOM(X_) 칸만 저장 — Cell·Pancake 환산값이 UOM QTY 로 저장되지 않게 한다
      if (!tag || tag.span !== ctx.activeSpan || tag.span !== 'X' || tag.bucket !== 'D') return;
      // 빈 셀은 0 으로 저장하지 않고 제외(AS-IS 동일).
      if (str(row[binding]).trim() === '') return;
      const current = num(row[binding]);
      const before = num(original[binding]);
      if (current === before) return;
      if (current < 0) {
        negatives.push({ row, day: binding });
        return;
      }
      payload.push({
        // PROC_M COL_NM 14키 (순서·키명 SP 계약 일치). 식별 9키는 SP WHERE 대상.
        activeFlag: 'M',
        divisionId: ctx.divisionId,
        companyId: ctx.companyId,
        plantId: str(row.PLANT_ID),
        scmSiteId: str(row.SCM_SITE_ID),
        modelId: str(row.MODEL_ID),
        itemId: str(row.ITEM_ID),
        npcItemId: str(row.NPC_ITEM_ID), // 기존 행 SELECT — 공백이면 SP 가 원본 값 유지
        yyyymmdd: tag.ymd, // '[X|Y|Z]_D_20260901' → '20260901'
        qty: String(current),
        planStartYyyymmdd: ctx.planStartYyyymmdd,
        measure: str(row.MEASURE), // P_SHIP_PLAN_SIMU_ETD
        lastUpdatedBy: ctx.userId,
        electrodeType: str(row.ELECTRODE_TYPE), // QTY_TO_PCM 환산 조회 키
      });
    });
  });

  return { payload, negatives };
};

export interface DetailSaveContext {
  userId: string;
}

// yyyy-MM-dd HH:mm:ss.fff 포맷 — AS-IS p_shipment_date(cs:2588). SHIPMENT_DATE 가 날짜(yyyyMMdd·yyyy-MM-dd)든
//   일시 문자열이든 숫자만 추려 날짜부 8자리 + 시간부(없으면 00:00:00.000)로 정규화한다.
const toShipmentDate = (v: unknown): string => {
  const s = str(v).trim();
  if (s === '') return '';
  const digits = s.replace(/\D/g, '');
  if (digits.length < 8) return s; // 파싱 불가 — 원문 그대로(서버 검증에 맡김)
  const ymd = digits.slice(0, 8);
  const y = ymd.slice(0, 4);
  const mo = ymd.slice(4, 6);
  const d = ymd.slice(6, 8);
  const rest = digits.slice(8).padEnd(9, '0'); // HHmmssfff
  const hh = rest.slice(0, 2);
  const mi = rest.slice(2, 4);
  const ss = rest.slice(4, 6);
  const fff = rest.slice(6, 9);
  return `${y}-${mo}-${d} ${hh}:${mi}:${ss}.${fff}`;
};

// 확정 SAVE SP 27 IN 의 camelCase COL_NM(SCM_ADM_PROC_M SORT_ORD) ← AS-IS 수집 컬럼 매핑(cs:2582~2607).
//   값 추출기는 (row)=>string. activeFlag/userId/checkNeedYn 는 아래 collectDetailSaveRows 에서 별도 처리.
const DETAIL_SAVE_FIELDS: { key: string; from: (row: Record<string, unknown>) => string }[] = [
  { key: 'divisionId', from: r => str(r.DIVISION_ID) },
  { key: 'confirmId', from: r => str(r.CONFIRM_ID) },
  { key: 'shipmentQty', from: r => str(r.SHIPMENT_CONFIRM_QTY) },
  { key: 'shipmentDate', from: r => toShipmentDate(r.SHIPMENT_DATE) },
  { key: 'newBodId', from: r => str(r.NEW_BOD_ID) },
  { key: 'newRouteId', from: r => str(r.NEW_ROUTE_ID) },
  { key: 'newEtdDate', from: r => str(r.NEW_ETD) },
  { key: 'newEtaDate', from: r => str(r.NEW_ETA) },
  { key: 'newIncoterms', from: r => str(r.INCOTERMS) },
  { key: 'newTransportMode', from: r => str(r.TRANSPORT_MODE) },
  { key: 'newDContry', from: r => str(r.NEW_D_COUNTRY) }, // 주의: COL_NM 철자 newDContry(AS-IS 오타 그대로)
  { key: 'newDPortCode', from: r => str(r.NEW_D_PORT_CODE) },
  { key: 'newACountry', from: r => str(r.NEW_A_COUNTRY) },
  { key: 'newAPortCode', from: r => str(r.NEW_A_PORT_CODE) },
  { key: 'newCustomerLt', from: r => str(r.NEW_CUSTOMER_LT) },
  { key: 'newToCountry', from: r => str(r.NEW_TO_COUNTRY) },
  { key: 'newToCity', from: r => str(r.NEW_TO_CITY) },
  { key: 'remarks', from: r => str(r.REMARKS) },
  { key: 'remarks2', from: r => str(r.REMARKS2) },
  { key: 'remarks3', from: r => str(r.REMARKS3) },
  { key: 'editMain', from: r => str(r.EDIT_MAIN) },
  { key: 'factoryId', from: r => str(r.FACTORY_ID) },
  { key: 'packageType', from: r => str(r.PACKAGE_TYPE) },
  { key: 'domExp', from: r => str(r.DOM_EXP) },
];

/**
 * siDetail(shtPlanDetail) 확정 저장 payload — AS-IS SaveData(cs:2582~2607) 재현.
 *   SP = PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(27 IN, 전부 VARCHAR). 다건 행을 `^`-fold 한다
 *   (AS-IS CString.AppendString — 각 IN 을 한 문자열에 행 구분 '^' 로 접음). BE BaseService 는 VARCHAR 를
 *   그대로 바인딩하므로(JVARCHAR 만 서버 fold) FE 가 미리 접어 **단일 객체** 1건을 call-proc POST 한다
 *   (자매 SCP0132 전용 fold 빌더 패턴). action∈{I,M,D} 행만 대상(그 외 skip).
 *   activeFlag=CRUD_TYPE(I/M/D), userId=세션 스칼라, checkNeedYn='Y'(상수). dirty 0건이면 null.
 */
export const collectDetailSaveRows = (
  rows: Record<string, unknown>[],
  ctx: DetailSaveContext
): Record<string, string> | null => {
  const activeFlags: string[] = [];
  const cols: Record<string, string[]> = {};
  DETAIL_SAVE_FIELDS.forEach(f => (cols[f.key] = []));

  rows.forEach(row => {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M' && crud !== 'D') return;
    activeFlags.push(crud);
    DETAIL_SAVE_FIELDS.forEach(f => cols[f.key].push(f.from(row)));
  });

  if (activeFlags.length === 0) return null;

  const payload: Record<string, string> = {
    activeFlag: activeFlags.join('^'),
    userId: ctx.userId, // 스칼라 — P_USER_ID 는 세션 1값(행별 접지 않음)
    checkNeedYn: 'Y', // 상수 — AS-IS p_check_need_yn "Y"(cs:2606)
  };
  DETAIL_SAVE_FIELDS.forEach(f => (payload[f.key] = cols[f.key].join('^')));
  return payload;
};

// ====================================================================================
// 저장 전 검증 (AS-IS Validation_Check cs:2860~3070 · GetERPInterface cs:3072~3151).
//   FE 재현 가능 항목만 — 서버 SP 의존(MSG00189/247/248/249/404)은 SP 내부가 최종 방어.
//   반환 = { msgId, arg? } | null. i18next 보간이 아니라 `{0}` 문자열 replace 이므로 arg 는 호출부가 치환.
// ====================================================================================

/** 검증 위반 1건 — 메시지 코드와 `{0}` 치환값(선택). */
export interface SaveViolation {
  msgId: string;
  arg?: string;
}

// SHIPMENT_DATE 를 YYYYMMDD 8자리로 — 숫자만 추려 앞 8자리. 8자리 미만이면 undefined(형식 오류).
const shipDigits = (v: unknown): string | undefined => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  return digits.length === 8 ? digits : undefined;
};

/**
 * 출하일 D±기간 제한 + 날짜형식 검증 — AS-IS Validation_Check cs:2895~2901(MSG00194) ·
 *   GetERPInterface cs:3123~3128(MSG00049). 변경(M)/신규(I) 행의 SHIPMENT_DATE 만 대상.
 *   dDay = CHANGE_REQ_DAY lookup 기준일수(음수, 예 -56). 상한=오늘+|dDay|, 하한=오늘+dDay.
 *   **dDay===undefined(룩업 미도착)면 날짜범위 검증 생략** — 임의 기본값으로 전건 차단하지 않는다
 *   (자매 useShipmentChangeRequestValidation 와 동일 가드). 날짜형식 검증은 dDay 와 무관히 수행.
 *   MSG 매핑: DATE_OVER_MAX(MSG01206, arg=dDay) / INVALID_DATE_FORMAT(MSG01081, arg=입력문자열).
 */
export const checkShipmentDate = (
  rows: Record<string, unknown>[],
  dDay: number | undefined,
  msg: { INVALID_DATE_FORMAT: string; DATE_OVER_MAX: string }
): SaveViolation | null => {
  const dMax = dDay === undefined ? undefined : dayjs().startOf('day').add(Math.abs(dDay), 'day');
  const dMin = dDay === undefined ? undefined : dayjs().startOf('day').add(dDay, 'day');
  for (const row of rows) {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M') continue;
    const raw = str(row.SHIPMENT_DATE).trim();
    if (raw === '') continue; // 필수 공백검증이 선행 — 여기선 형식만
    const digits = shipDigits(raw);
    const d = digits ? dayjs(digits, 'YYYYMMDD') : undefined;
    if (!d?.isValid()) return { msgId: msg.INVALID_DATE_FORMAT, arg: raw };
    if (dMax && dMin && (d.isAfter(dMax) || d.isBefore(dMin))) {
      return { msgId: msg.DATE_OVER_MAX, arg: String(dDay) };
    }
  }
  return null;
};

/**
 * 변경사항 없는데 사유 입력됨 — AS-IS Validation_Check no-change branch cs:2968~3065(MSG00286).
 *   수정(M) 행에서 CHANGE_REASON_CODE 가 채워졌는데(자동 'T07' 세팅분은 제외) 편집 화이트리스트
 *   컬럼이 원본과 하나도 안 바뀌었으면 위반. 원본은 EditTracker originalOf 로 대조.
 *   arg={0}=첫 변경사유 컬럼의 화면 라벨(호출부가 헤더 치환) — 여기선 바인딩명을 돌려주고 호출부가 라벨화.
 *   신규(I)/삭제(D)는 대상 아님(변경 개념 없음).
 */
export const checkReasonWithoutChange = (
  rows: Record<string, unknown>[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  autoReasonCode: string,
  msgId: string
): SaveViolation | null => {
  for (const row of rows) {
    if (str(row.CRUD_TYPE) !== 'M') continue;
    const reason = str(row.CHANGE_REASON_CODE).trim();
    // 사용자가 명시 입력한 사유만 대상 — 자동 세팅 기본값('T07')·공백·'-'는 "사유 입력됨"이 아니다.
    if (reason === '' || reason === '-' || reason === autoReasonCode) continue;
    const original = originalOf(row);
    if (!original) continue; // 원본 미확보 시 판정 보류(false-block 방지)
    // 편집 화이트리스트 중 CHANGE_REASON 계열을 뺀 컬럼이 하나라도 바뀌었으면 "변경 있음".
    const changed = Object.keys(original).some(
      col =>
        col !== 'CHANGE_REASON_CODE' &&
        col !== 'CHANGE_REASON_DETAIL' &&
        str(row[col]) !== str(original[col])
    );
    if (!changed) return { msgId, arg: 'CHANGE_REASON_CODE' };
  }
  return null;
};

/**
 * Confirm Qty 0 PO 삭제 대상 존재 여부 — AS-IS GetERPInterface cs:3107~3139(MSG00325).
 *   ERP_SO_NO 가 있고 SHIPMENT_CONFIRM_QTY==0 인 변경/신규/삭제 행이 하나라도 있으면 true.
 *   호출부가 confirm(Yes/No) 띄워 No 면 저장 abort. (MSG01322 는 confirm 문구.)
 */
export const hasZeroQtyPoToDelete = (rows: Record<string, unknown>[]): boolean =>
  rows.some(row => {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M' && crud !== 'D') return false;
    return str(row.ERP_SO_NO).trim() !== '' && num(row.SHIPMENT_CONFIRM_QTY) === 0;
  });

// ====================================================================================
// 하단 Plan Detail 저장의 ERP 연쇄 — AS-IS SaveData_Detail(cs:2512~2757) → GetERPInterface(cs:3122~3353)
//   → NonSoNo/SoNo(cs:3742~4176) → GetErpIFCheckNew(cs:4293~4405) 의 순수 조립부.
//   호출 순서와 분기는 ShipmentPlanElectrode.tsx runErpChain 이 담당하고, 여기에는 행 → 파라미터 변환만 둔다.
//   선례: SSP0015 utils/shipment-plan-mobility-it.save.ts collectDraftingSaveRows.
// ====================================================================================

/**
 * 커서 행 읽기 — 이 화면 SP 는 OUT 커서 키 대소문자가 SP 마다 다르다.
 *   PKG_SSP0023 자체 SP(GET_SHIPMENT_STATUS·GET_ERP_SO_NO_CNT·SAVE_..._DRAFTING·SAVE_..._CONFIRM)는 O_RC1,
 *   공용 래퍼(DELETE_..._BY_CONFIRM·ERP_ERROR_CONFIRM)와 CHECK_CONFIRM_CHANGETIME 은 o_rc1 이다(proc_meta 2026-10-27).
 *   둘 다 읽는다. n = 커서 번호(1부터).
 */
export const readCursor = (result: unknown, n = 1): Record<string, unknown>[] => {
  const r = result as Record<string, unknown> | null | undefined;
  const rows = r?.[`O_RC${n}`] ?? r?.[`o_rc${n}`];
  return Array.isArray(rows) ? (rows as Record<string, unknown>[]) : [];
};

/** 커서 첫 행의 결과 코드 — RESULT_CODE 가 없으면 AS-IS 처럼 첫 컬럼 값(`Rows[0][0]`)을 쓴다. */
export const firstResultCode = (result: unknown, n = 1): string => {
  const row = readCursor(result, n)[0];
  if (!row) return '';
  return str(row.RESULT_CODE ?? Object.values(row)[0]);
};

// SO 없음 판정 — AS-IS 는 IsNullOrWhiteSpace 만 보지만, TO-BE 상세 SP 는 계획 전용 행에 '-' 를 채운다
//   (P_SSP0023_GET_SHIPMENT_PLAN_DETAIL BODY 2765 `'-' AS ERP_SO_NO`). 두 값 모두 SO 없음으로 본다.
const soOf = (r: Record<string, unknown>): string => {
  const so = str(r.ERP_SO_NO).trim();
  return so === '-' ? '' : so;
};
const confirmIdOf = (r: Record<string, unknown>): string => {
  const id = str(r.CONFIRM_ID).trim();
  return id === '-' ? '' : id;
};
const isActionRow = (r: Record<string, unknown>): boolean => {
  const crud = str(r.CRUD_TYPE);
  return crud === 'I' || crud === 'M' || crud === 'D';
};
const uniq = (values: string[]): string[] => Array.from(new Set(values.filter(v => v !== '')));

/**
 * 상태 재검증 대상 — AS-IS GetERPInterface cs:3135~3144.
 *   AS-IS 는 변경행마다 GetShipmentStatusChk(division, p_status_chk_confirm_id) 를 부르는데, confirm id 는
 *   EDIT_MAIN='Y' 인 행에서만 채운다(cs:3141~3142). EDIT_MAIN 이 아닌 행은 빈 값(또는 직전 값)이라 새로 걸리는
 *   것이 없다. SP 는 두 인자를 '^' 로 분해하므로(BODY 195~215 STRING_SPLIT) 한 번에 묶어 보낸다.
 */
export const collectStatusCheckKeys = (
  rows: Record<string, unknown>[]
): { divisionId: string; confirmId: string } | null => {
  const target = rows.filter(r => isActionRow(r) && str(r.EDIT_MAIN) === 'Y' && confirmIdOf(r) !== '');
  if (target.length === 0) return null;
  return {
    divisionId: uniq(target.map(r => str(r.DIVISION_ID).trim())).join('^'),
    confirmId: uniq(target.map(confirmIdOf)).join('^'),
  };
};

/**
 * SO 건수 검증 대상 — AS-IS GetERPInterface cs:3148~3168. 변경행의 SO 별 1회.
 *   sheetCount 는 화면 전체 행 중 같은 SO 행수(cs:3154) — 호출부가 DB 건수(GET_ERP_SO_NO_CNT CNT)와 비교한다.
 */
export const collectSoCountChecks = (
  dirty: Record<string, unknown>[],
  allRows: Record<string, unknown>[]
): { divisionId: string; erpSoNo: string; sheetCount: number }[] => {
  const seen = new Set<string>();
  const out: { divisionId: string; erpSoNo: string; sheetCount: number }[] = [];
  dirty.forEach(r => {
    if (!isActionRow(r)) return;
    const so = soOf(r);
    if (so === '' || seen.has(so)) return;
    seen.add(so);
    out.push({
      divisionId: str(r.DIVISION_ID),
      erpSoNo: so,
      sheetCount: allRows.filter(x => soOf(x) === so).length,
    });
  });
  return out;
};

/**
 * 2분 잠금 확인 대상 — AS-IS GetERPInterface cs:3180(변경행 전건 CONFIRM_ID '^' 폴딩) → cs:3192~3200.
 *   AS-IS 는 신규(I)행도 포함한다(복사 원본의 CONFIRM_ID 를 가진다). 빈 값과 '-' 만 뺀다.
 */
export const collectChangeTimeIds = (rows: Record<string, unknown>[]): string =>
  uniq(rows.filter(isActionRow).map(confirmIdOf)).join('^');

/**
 * 변경요청 초안 묶음 — AS-IS GetERPInterface cs:3202~3243.
 *   - CHANGE_TYPE='P'(Plan) 행 제외(cs:3211), 신규(I) 행 제외(cs:3215 action != I).
 *   - SO 없는 행은 행 하나가 한 묶음(NonSoNo cs:3742).
 *   - SO 있는 행은 같은 SO 의 변경행 전부가 한 묶음(SoNo cs:4013~4078), SO 첫 행에서 한 번만.
 *   주의: AS-IS SoNo(cs:3951~3961)는 "화면 앞쪽 행(변경 여부 무관)에 같은 SO 가 있으면" 건너뛴다. 그래서 앞쪽
 *     미변경 행과 SO 를 공유하는 변경행은 초안·송신 없이 확정만 된다. TO-BE 는 변경행 기준으로 묶어 이 누락을
 *     만들지 않는다(같은 SO 의 첫 변경행에서 한 번).
 */
export const buildDraftingGroups = (
  dirty: Record<string, unknown>[]
): { erpSoNo: string; rows: Record<string, unknown>[] }[] => {
  const targets = dirty.filter(
    r => isActionRow(r) && str(r.CHANGE_TYPE) !== 'P' && str(r.CRUD_TYPE) !== 'I'
  );
  const groups: { erpSoNo: string; rows: Record<string, unknown>[] }[] = [];
  const bySo = new Map<string, { erpSoNo: string; rows: Record<string, unknown>[] }>();
  targets.forEach(r => {
    const so = soOf(r);
    if (so === '') {
      groups.push({ erpSoNo: '', rows: [r] });
      return;
    }
    const g = bySo.get(so);
    if (g) {
      g.rows.push(r);
      return;
    }
    const created = { erpSoNo: so, rows: [r] };
    bySo.set(so, created);
    groups.push(created);
  });
  return groups;
};

export interface DraftingSaveMeta {
  userId: string;
  /** AS-IS UserInfoContext[Dept_ID](cs:3768). TO-BE 세션에 부서 필드가 없어 공란이다. */
  userDeptId: string;
  /** AS-IS siDetail.ActiveSheet.SheetName(cs:3782) = "Shipment Plan Detail". SP 가 'Change on ' 을 붙인다. */
  title: string;
  /** AS-IS this.Name(cs:3784). SP 본문은 이 값을 쓰지 않는다(BODY 4119~ 선언만). */
  programId: string;
}

/**
 * 변경요청 초안 payload — PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING(37 IN, proc_meta
 *   SSP0023/requestDraftingMain/SAVE). 행 값은 '^' 폴딩(SP 가 SCM_ARR_SPL_VAL 로 행마다 꺼냄, BODY 4269~4302).
 *   userId·userDeptId·programId 는 요청 1건에 1값이라 스칼라(결함 D-2). title 은 SP 가 행마다 잘라 쓰므로
 *   (BODY 4276 `SCM_ARR_SPL_VAL(P_TITLE, …)`) 행 수만큼 폴딩한다.
 *   원천 컬럼은 AS-IS NonSoNo(cs:3796~3838)·SoNo(cs:4032~4071) 와 같다.
 *   주의: AS-IS SoNo 는 p_shipment_date 를 행마다 두 번 붙여(cs:4036·4037) 배열이 어긋난다. TO-BE 는 한 번만 붙인다.
 */
export const collectDraftingPayload = (
  rows: Record<string, unknown>[],
  meta: DraftingSaveMeta
): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const map: Record<string, (r: Record<string, unknown>) => string> = {
    activeFlag: r => str(r.CRUD_TYPE),
    divisionId: r => str(r.DIVISION_ID),
    confirmId: r => str(r.CONFIRM_ID),
    shipmentQty: r => str(r.SHIPMENT_CONFIRM_QTY),
    shipmentDate: r => toShipmentDate(r.SHIPMENT_DATE), // AS-IS yyyy-MM-dd HH:mm:ss.fff(cs:3786)
    fromSite: r => str(r.FROM_SITE),
    newBodId: r => str(r.NEW_BOD_ID),
    newRouteId: r => str(r.NEW_ROUTE_ID),
    newEtdDate: r => str(r.NEW_ETD),
    newEtaDate: r => str(r.NEW_ETA),
    newIncoterms: r => str(r.INCOTERMS),
    newTransportMode: r => str(r.TRANSPORT_MODE),
    newDContry: r => str(r.NEW_D_COUNTRY), // 주의: COL_NM 철자 newDContry(원본 그대로)
    newDPortCode: r => str(r.NEW_D_PORT_CODE),
    newACountry: r => str(r.NEW_A_COUNTRY),
    newAPortCode: r => str(r.NEW_A_PORT_CODE),
    newCustomerLt: r => str(r.NEW_CUSTOMER_LT),
    newToCountry: r => str(r.NEW_TO_COUNTRY),
    newToCity: r => str(r.NEW_TO_CITY),
    editMain: r => str(r.EDIT_MAIN), // SP 는 'Y'/'N' 행만 초안에 넣는다(BODY 4471)
    editRemark: r => str(r.EDIT_REMARKS),
    electrodeYn: r => str(r.ELECTRODE_YN),
    electrodeType: r => str(r.ELECTRODE_TYPE),
    originFromDivisionId: r => str(r.ORIGIN_FROM_DIVISION_ID),
    origionToDivisionId: r => str(r.ORIGIN_TO_DIVISION_ID), // 주의: COL_NM 철자 origion(원본 그대로)
    remarks: r => str(r.REMARKS),
    remarks2: r => str(r.REMARKS2),
    remarks3: r => str(r.REMARKS3),
    changeReasonCode: r => str(r.CHANGE_REASON_CODE).replace(/-/g, ''), // AS-IS .Replace("-","")(cs:3828)
    changeReasonDetail: r => str(r.CHANGE_REASON_DETAIL),
    title: () => meta.title,
    factoryId: r => str(r.FACTORY_ID),
    packageType: r => str(r.PACKAGE_TYPE),
    domExp: r => str(r.DOM_EXP),
  };
  const payload: Record<string, string> = {};
  for (const [key, getter] of Object.entries(map)) {
    payload[key] = rows.map(getter).join('^');
  }
  payload.userId = meta.userId;
  payload.userDeptId = meta.userDeptId;
  payload.programId = meta.programId;
  return payload;
};

/**
 * ERP 거절 내역 해석 — AS-IS GetErpIFCheckNew cs:4308~4322.
 *   E_MESSAGE = `confirmId:msg^confirmId:msg^`. 끝 '^' 제거 후 '^' 로 나누고 첫 ':' 앞을 CONFIRM_ID 로 본다
 *   (AS-IS 는 Split(':') 라 메시지에 ':' 가 있으면 잘린다 — 첫 ':' 기준으로 보정, SSP0015 와 같음).
 */
export const parseErpErrors = (eMessage: string): { confirmId: string; message: string }[] => {
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
