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
