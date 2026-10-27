// SSP0201 편집 파생 (design 03 §3.2 value 108건 중 FE 소관 규칙).
//   핵심축: EDIT_MAIN 플래그('Y'=변경/'N'=취소) + SO No 그룹 전파(같은 ERP_SO_NO 전행 동일변경).
//   전파는 두 갈래다(설계 §3.2 / AS-IS 실측):
//     - 값 전파: SHIPMENT_DATE(+NEW_ETD/ETA/NEW_SHIPMENT_DATE 파생) / TRANSPORT_MODE /
//               CHANGE_REASON_CODE(+DETAIL) / CHANGE_REASON_DETAIL — 형제 행에 **값을 복사**한다.
//     - 행상태만 전파: REMARKS / REMARKS2 / SHIPMENT_CONFIRM_QTY — 형제 행을 **변경행으로만** 마킹
//               (CRUD_TYPE='M' + EDIT_MAIN='Y'), 값은 복사하지 않는다(AS-IS cs:5640-5666).
//   주의: TRANSPORT_MODE 의 NEW_ROUTE_ID/NEW_BOD_ID/NEW_*_PORT/NEW_LT_DAY 등 경로·BOD 파생은
//     AS-IS 에서도 주석이라 저장 SP 로 이관됐다(§3.2 :4979-5016). SHIPMENT_DATE 의 NEW_ETD/ETA/
//     NEW_SHIPMENT_DATE 는 AS-IS 가 FE 에서 세팅하므로(cs:5539-5558, 주석 아님) 여기서 파생한다.
//   SSP0201 은 chkSingleProcess 가 없어(Form 미노출) 항상 SO 전파다 — singleProcess 분기 없음.

import { CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';

import { EDIT_MAIN_FLAG, LBL, SO_GROUP_KEY } from '../shipment-change-request.constants';

export type GridRowData = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const CHANGE_REASON_NONE = '-';
const DISPLAY_DATE_FORMAT = 'YYYY-MM-DD';

/**
 * 파생·전파 셀 기록기 — 화면이 `row[binding] = value` 로 직접 쓰면 EditTracker 에 원본이 남지 않아
 *   "값을 원래대로 되돌리면 수정표시 해제" 규칙과 **CRUD_TYPE 마킹**이 그 셀에 적용되지 않는다.
 *   그래서 파생·전파도 tracker 를 경유한다(값 복사 + CRUD_TYPE 세팅). tracker 가 없으면 직접 대입.
 */
export type CellWriter = (row: GridRowData, binding: string, value: unknown) => void;

export const directWrite: CellWriter = (row, binding, value) => {
  row[binding] = value;
};

interface ChangeStore {
  storeChange: (row: never, binding: string, oldValue: never, newValue: never) => void;
}

export const trackedWriter = (tracker: ChangeStore | undefined): CellWriter => {
  if (!tracker) return directWrite;
  return (row, binding, value) => {
    const prev = row[binding];
    if (prev === value) return;
    tracker.storeChange(row as never, binding, prev as never, value as never);
    row[binding] = value;
  };
};

// EDIT_MAIN 플래그 세팅(파생마다 'Y', CHANGE_REASON_CODE 취소 시 'N').
export const setEditMain = (row: GridRowData, flag: 'Y' | 'N'): void => {
  row[EDIT_MAIN_FLAG] = flag;
};

// 전파 대상 행을 변경행으로 마킹 — 자체 상태필드가 아니라 공통 CRUD_TYPE 을 쓴다(R-21, AS-IS StringAction='M').
//   신규행('I')은 유지하고, 미편집 기존행만 'M' 으로 올린다.
export const markPropagated = (row: GridRowData): void => {
  if (!str(row.CRUD_TYPE)) row.CRUD_TYPE = CRUD_TYPE.MODIFY;
  setEditMain(row, 'Y');
};

// 값까지 전파하는 트리거 컬럼(설계 §3.2 — SHIPMENT_DATE/TRANSPORT_MODE/CHANGE_REASON).
export const VALUE_PROPAGATION = new Set<string>([
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'CHANGE_REASON_CODE',
  'CHANGE_REASON_DETAIL',
]);

// 행상태만 전파하는 트리거 컬럼(설계 §3.2 — REMARKS/REMARKS2/SHIPMENT_CONFIRM_QTY). 값은 복사하지 않는다.
export const STATUS_PROPAGATION = new Set<string>([
  'REMARKS',
  'REMARKS2',
  'SHIPMENT_CONFIRM_QTY',
]);

// SO No 그룹 전파 대상 행 집합 — ERP_SO_NO 있으면 같은 SO 전행, 없으면 자기행만(design 03 §3.2).
export const soGroupRows = (
  allRows: GridRowData[],
  changedRow: GridRowData
): GridRowData[] => {
  const soNo = str(changedRow[SO_GROUP_KEY]);
  if (!soNo) return [changedRow];
  return allRows.filter(r => str(r[SO_GROUP_KEY]) === soNo);
};

/**
 * SHIPMENT_DATE 입력 파생 (설계 §3.2:230 / AS-IS cs:5514-5558).
 *   NEW_LT_DAY 가 공백이면 파생이 없다(cs:5528 return) — 임의로 0 으로 보지 않는다.
 *   동일 SO 전파는 **편집 행에서 구한 이 값 하나**를 전 대상 행에 그대로 쓴다(cs:5553-5558).
 */
export interface ShipmentDateDerived {
  date: string;
  eta: string;
}

export const shipmentDateDerivedOf = (
  row: GridRowData,
  inputDate: unknown
): ShipmentDateDerived | null => {
  const ltDay = str(row.NEW_LT_DAY).trim();
  if (ltDay === '') return null;
  const lt = Number(ltDay);
  if (!Number.isFinite(lt)) return null;
  // FPDate 에디터는 **Date 객체**를, 조회·붙여넣기는 **문자열**을 커밋한다 — 둘 다 받는다.
  //   str() 로만 받으면 Date 가 '' 로 떨어져 파생·전파가 조용히 생략된다(리뷰 #3, SSP0200 blank 함정과 동일 축).
  const digits = inputDate instanceof Date ? '' : str(inputDate).replace(/\D/g, '').slice(0, 8);
  const base = inputDate instanceof Date ? dayjs(inputDate) : dayjs(digits, 'YYYYMMDD');
  if (!(inputDate instanceof Date) && digits.length !== 8) return null;
  if (!base.isValid()) return null;
  return {
    date: base.format(DISPLAY_DATE_FORMAT),
    eta: base.add(lt, 'day').format(DISPLAY_DATE_FORMAT),
  };
};

/** 파생값을 한 행에 기록 — AS-IS 는 SHIPMENT_DATE 자신도 정규화 문자열로 덮어쓴다(cs:5541). */
export const writeShipmentDateDerived = (
  row: GridRowData,
  derived: ShipmentDateDerived,
  write: CellWriter = directWrite
): void => {
  write(row, 'SHIPMENT_DATE', derived.date);
  write(row, 'NEW_ETD', derived.date);
  write(row, 'NEW_ETA', derived.eta);
  write(row, 'NEW_SHIPMENT_DATE', derived.date);
};

// CHANGE_REASON_CODE 취소값 판정 — AS-IS 는 '-' 하나만 취소로 본다(cs:5087 단일 비교).
export const isChangeReasonCleared = (code: string): boolean => code === CHANGE_REASON_NONE;

// CHANGE_REASON_CODE 변경 파생(자기행) — '-'이면 DETAIL clear + EDIT_MAIN='N'(design 03 §3.2 :5067).
export const applyChangeReasonCode = (
  row: GridRowData,
  code: string,
  write: CellWriter = directWrite
): void => {
  if (isChangeReasonCleared(code)) {
    write(row, 'CHANGE_REASON_DETAIL', '');
    setEditMain(row, 'N');
    return;
  }
  setEditMain(row, 'Y');
};

/**
 * 동일 SO 대상 행에 CHANGE_REASON_CODE 를 전파한다(AS-IS cs:5087-5100).
 *   '-'이면 대상 행도 DETAIL 을 비우고 EDIT_MAIN='N' — 취소 의도가 저장 대상 확대로 뒤집히지 않도록
 *   markPropagated(CRUD 강제)는 하지 않는다(반환 false).
 * 반환값 = 이 대상 행을 변경행으로 마킹해야 하는지 여부.
 */
export const propagateChangeReason = (
  target: GridRowData,
  code: string,
  detail: string,
  write: CellWriter = directWrite
): boolean => {
  write(target, 'CHANGE_REASON_CODE', code);
  if (isChangeReasonCleared(code)) {
    write(target, 'CHANGE_REASON_DETAIL', '');
    setEditMain(target, 'N');
    return false;
  }
  write(target, 'CHANGE_REASON_DETAIL', detail);
  return true;
};

// 셀 값 공백 판정 — str() 은 Date 객체 등을 '' 로 떨어뜨려 오판하므로 별도 판정(자매 SSP0200 동일).
const blank = (v: unknown): boolean =>
  v === null || v === undefined || (typeof v === 'string' && v.trim() === '');

// From/To Site·Incoterms 변경 cascade — 하위 파생 3열 clear(AS-IS cs:4780-4782/4934-4935, 설계 §3.2 :237).
//   FindData_BOD 재조회는 저장 SP 소관이라 FE 는 clear 만 한다(NEW_* 파생과 동일 규약).
export const clearBodDerived = (row: GridRowData, write: CellWriter = directWrite): void => {
  write(row, 'INCOTERMS', '');
  write(row, 'TRANSPORT_MODE', '');
  write(row, 'BOD_ID', '');
};

/**
 * 선행값 안내 라벨 — MSG00098 "먼저 {0}을(를) 선택하십시오" 의 {0} 에 넣을 필드명.
 *   `lbl` 이 있으면 화면이 i18n(t)으로 번역하고, 없으면 `fallback` 영문을 그대로 쓴다
 *   (AS-IS 는 GetTerm 으로 번역한다 — 리뷰 #3).
 */
export interface PrereqLabel {
  lbl: string;
  fallback: string;
}

// INCOTERMS 선행값 중 **첫 번째로 빠진 필드** — AS-IS cs:4895-4932(순서 Div→From Site→To Site→Model).
export const firstMissingIncotermsPrereq = (row: GridRowData): PrereqLabel | null => {
  if (blank(row.DIVISION_ID)) return { lbl: LBL.DIVISION, fallback: 'Div' };
  if (blank(row.FROM_SITE_DESCRIPTION)) return { lbl: LBL.FROM_SITE, fallback: 'From Site' };
  if (blank(row.TO_SITE_DESCRIPTION)) return { lbl: LBL.TO_SITE, fallback: 'To Site' };
  if (blank(row.ITEM_ID)) return { lbl: LBL.MODEL_NICKNAME, fallback: 'Model' };
  return null;
};

// TRANSPORT_MODE 선행값 중 첫 번째로 빠진 필드 — AS-IS cs:4963-4982(순서 Shipment Date→Incoterms).
//   (후보 없음 MSG00293 은 TRANSPORT_MODE 가 메타 셀콤보라 후보 목록이 공용 DataGrid 안에 있어 제외.)
export const firstMissingTransportModePrereq = (row: GridRowData): PrereqLabel | null => {
  if (blank(row.SHIPMENT_DATE)) return { lbl: LBL.SHIPMENT_DATE, fallback: 'Shipment Date' };
  if (blank(row.INCOTERMS)) return { lbl: '', fallback: 'Incoterms' }; // LBL.INCOTERMS 미등록 → fallback
  return null;
};

// TO_SITE 변경 선행값 — From Site 선행 필수(AS-IS cs:4795-4801, MSG00098).
export const firstMissingToSitePrereq = (row: GridRowData): PrereqLabel | null =>
  blank(row.FROM_SITE_DESCRIPTION) ? { lbl: LBL.FROM_SITE, fallback: 'From Site' } : null;

// 실질 변경 컬럼(AS-IS SSP_Main_Validation cs:3204-3208) — 기존행에서 이 컬럼이 바뀌면 사유코드 T07 대상.
//   (REMARKS/REMARKS2 는 제외 — AS-IS 는 비고만 변경 시 T07 을 붙이지 않는다, cs:3217 분기.)
export const T07_TRIGGER_COLUMNS = new Set<string>([
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'INCOTERMS',
  'TO_SITE_SHIPTO_CODE',
]);

/**
 * 실질 변경한 **수정행**에 사유코드 자동 세팅 — AS-IS SSP_Main_Validation(cs:3211-3215) 등가.
 *   CHANGE_REASON_CODE 가 비었거나 '-' 면 'T07' 로 채운다. 사유 컬럼은 30_fix 로 숨겨져 수동 입력
 *   경로가 없으므로, 이 자동 세팅이 없으면 실질 변경 수정행이 **사유 빈 채로 저장**된다(리뷰 높음).
 *   신규행('I')은 대상 아님(AS-IS 는 action='M' 수정행만 처리).
 *   **directWrite**(EditTracker 미경유)로 쓴다 — T07 자체가 행을 dirty 로 만들지 않아야, 사용자가
 *   실질 변경을 원복하면 EditTracker 가 그 행을 저장 대상에서 빼준다(AS-IS 의 "변경 없으면 unmark"
 *   cs:3265-3283 와 저장 결과가 같아진다).
 */
export const applyAutoReasonCode = (row: GridRowData): void => {
  if (str(row.CRUD_TYPE) === CRUD_TYPE.INSERT) return;
  const code = str(row.CHANGE_REASON_CODE);
  if (!code || code === CHANGE_REASON_NONE) row.CHANGE_REASON_CODE = 'T07';
};

// erp_status='C'(DO 생성됨) 변경 차단 판정(MSG00189, design 03 §3.2 :5584).
export const isErpLocked = (row: GridRowData): boolean => str(row.ERP_STATUS) === 'C';

// CHANGE_REASON_DETAIL 입력 전 REASON_CODE 선행 필수(MSG00287, design 03 §3.2 :5529).
export const isReasonCodeMissing = (row: GridRowData): boolean => {
  const code = str(row.CHANGE_REASON_CODE);
  return !code || code === CHANGE_REASON_NONE;
};

// C8: AS-IS 가 "변경"으로 치는 출하필드 7종(SSP_Main_Validation cs:3193-3199 비교목록).
//   CHANGE_REASON_CODE 는 이 목록에 없다 — 사유만 바꾼 행은 '변경 없음'으로 판정된다.
export const SHIPMENT_CHANGE_FIELDS = new Set<string>([
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
  'INCOTERMS',
  'REMARKS2',
  'REMARKS',
  'TO_SITE_SHIPTO_CODE',
]);

const hasShipmentFieldChange = (changedBindings: Iterable<string>): boolean => {
  for (const binding of changedBindings) {
    if (SHIPMENT_CHANGE_FIELDS.has(binding)) return true;
  }
  return false;
};

/**
 * C8 — 변경 없이 Change_Reason 만 입력된 **첫 행의 1-based 행번호**(없으면 null).
 *   AS-IS SSP_Main_Validation(cs:3265-3355)이 저장 시 MSG00286 으로 막는 케이스다(TO-BE MSG01290).
 *   `changedBindingsOf(row)` = 그 행에서 원본 대비 실제로 바뀐 바인딩 목록(EditTracker.getOriginalValues
 *   기준 — 값을 되돌리면 목록에서 빠진다). 출하필드 실변경이 하나도 없는데 사유코드가 들어간 수정행을
 *   찾되, 같은 ERP_SO_NO 그룹에 실변경 형제가 있으면 전파된 사유이므로 제외한다(cs:3299-3338).
 */
export const firstReasonWithoutChangeRow = (
  allRows: GridRowData[],
  changedBindingsOf: (row: GridRowData) => string[]
): number | null => {
  for (let i = 0; i < allRows.length; i++) {
    const row = allRows[i];
    // AS-IS 는 StringAction=='M'(수정) 행만 검사한다 — 신규행·미편집행은 대상 아님.
    if (str(row.CRUD_TYPE) === CRUD_TYPE.INSERT) continue;
    const modified = str(row.CRUD_TYPE) === CRUD_TYPE.MODIFY || str(row[EDIT_MAIN_FLAG]) === 'Y';
    if (!modified) continue;
    if (hasShipmentFieldChange(changedBindingsOf(row))) continue;
    if (isReasonCodeMissing(row)) continue;
    // 같은 ERP_SO_NO 그룹에 실변경 형제가 있으면 전파된 사유다 — 차단하지 않는다.
    const soNo = str(row[SO_GROUP_KEY]);
    if (
      soNo &&
      allRows.some(
        r => str(r[SO_GROUP_KEY]) === soNo && hasShipmentFieldChange(changedBindingsOf(r))
      )
    ) {
      continue;
    }
    return i + 1;
  }
  return null;
};
