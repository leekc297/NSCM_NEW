import dayjs from '@foundation/dayjs';

import {
  CHANGE_REASON_NONE,
  COLUMN,
  CRUD_UPDATE,
  EDIT_MAIN_OFF,
  EDIT_MAIN_ON,
  ELECTRODE_OPERATION_GROUP,
  ELECTRODE_SCALE,
  NON_ELECTRODE_SCALE,
  SO_GROUP_KEY,
} from '../shipment-change-request-plan.constants';

export type GridRowData = Record<string, unknown>;

export const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 파생·전파 셀 기록기.
 *
 * 화면이 `row[binding] = value` 로 직접 쓰면 EditTracker 에 원본이 남지 않아
 *   "값을 원래대로 되돌리면 수정표시(M) 해제" 규칙이 그 셀에만 적용되지 않는다(CommonCheckList 그리드 축).
 *   그래서 파생·전파도 tracker 를 경유한다. tracker 가 없으면(초기화 전) 직접 대입으로 떨어진다.
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

// EDIT_MAIN 은 CRUD_TYPE 과 별개 축이다(CP-12) — 저장 SP 파라미터 editMain 으로 그대로 나간다.
//   자체 행상태 필드(공통 CRUD_TYPE 외 임의 필드) 신설 금지(convert-core §2.4).
export const setEditMain = (row: GridRowData, value: string): void => {
  row[COLUMN.EDIT_MAIN] = value;
};

// 모든 편집 경로가 EDIT_MAIN='Y' 로 마킹한다(R-19, 신호 19건).
export const EDIT_MAIN_TRIGGER_COLUMNS = new Set<string>([
  COLUMN.SHIPMENT_CONFIRM_QTY,
  COLUMN.SHIPMENT_DATE,
  COLUMN.TRANSPORT_MODE,
  COLUMN.INCOTERMS,
  COLUMN.CHANGE_REASON_CODE,
  COLUMN.CHANGE_REASON_DETAIL,
  COLUMN.REMARKS,
  COLUMN.REMARKS2,
  COLUMN.REMARKS3,
  COLUMN.ERP_ATTR1,
  COLUMN.ERP_ATTR2,
  COLUMN.ERP_ATTR3,
]);

// 동일 SO 그룹 — chkSingleProcess 가 체크되면 자기 행만, 해제면 같은 ERP_SO_NO 전 행이 대상(CP-11).
export const soGroupRows = (rows: GridRowData[], row: GridRowData, singleProcess: boolean): GridRowData[] => {
  if (singleProcess) return [row];
  const soNo = str(row[SO_GROUP_KEY]);
  if (!soNo) return [row];
  return rows.filter(r => str(r[SO_GROUP_KEY]) === soNo);
};

// 전파 대상 행을 변경행으로 마킹 — 자체 상태필드가 아니라 공통 CRUD_TYPE 을 쓴다(R-21).
export const markPropagated = (row: GridRowData): void => {
  if (!str(row.CRUD_TYPE)) row.CRUD_TYPE = CRUD_UPDATE;
  setEditMain(row, EDIT_MAIN_ON);
};

/**
 * SHIPMENT_DATE 입력 파생 결과 (R-22 / CP-10).
 *   AS-IS cs:6315~6333 은 `sDate`/`sEta` 를 **둘 다 'yyyy-MM-dd'** 로 만들고 그 문자열을 쓴다 —
 *   한쪽만 'YYYYMMDD' 로 쓰면 같은 그리드에 두 포맷이 섞인다. 전송 시점 정규화(ymd8)와는 별개 축이다.
 */
export interface ShipmentDateDerived {
  /** 정규화된 입력일 — SHIPMENT_DATE / NEW_ETD / NEW_SHIPMENT_DATE 공용. */
  date: string;
  /** 입력일 + NEW_LT_DAY. */
  eta: string;
}

const DISPLAY_DATE_FORMAT = 'YYYY-MM-DD';

/**
 * 파생값 산출. `NEW_LT_DAY` 가 공백이면 파생 자체가 없다(cs:6328) — 임의로 0 으로 보지 않는다.
 *   동일 SO 전파는 **편집 행에서 구한 이 값 하나**를 전 대상 행에 그대로 쓴다(cs:6354~6361) —
 *   대상 행의 LT 로 다시 계산하면 AS-IS 가 쓰지 않는 값이 들어가고 LT 공백 행은 조용히 누락된다.
 */
export const shipmentDateDerivedOf = (
  row: GridRowData,
  inputDate: string
): ShipmentDateDerived | null => {
  const ltDay = str(row[COLUMN.NEW_LT_DAY]).trim();
  if (!inputDate || ltDay === '') return null;
  const lt = Number(ltDay);
  if (!Number.isFinite(lt)) return null;
  // 조회 SP 는 날짜를 'YYYY-MM-DD' 로 반환하고 사용자 입력은 마스크에 따라 갈린다 -> 숫자만 남겨 판정한다.
  const digits = inputDate.replace(/\D/g, '').slice(0, 8);
  const base = dayjs(digits, 'YYYYMMDD');
  if (digits.length !== 8 || !base.isValid()) return null;
  return {
    date: base.format(DISPLAY_DATE_FORMAT),
    eta: base.add(lt, 'day').format(DISPLAY_DATE_FORMAT),
  };
};

/** 파생값을 한 행에 기록한다. AS-IS 는 SHIPMENT_DATE 자신도 정규화 문자열로 덮어쓴다(cs:6341). */
export const writeShipmentDateDerived = (
  row: GridRowData,
  derived: ShipmentDateDerived,
  write: CellWriter = directWrite
): void => {
  write(row, COLUMN.SHIPMENT_DATE, derived.date);
  write(row, COLUMN.NEW_ETD, derived.date);
  write(row, COLUMN.NEW_ETA, derived.eta);
  write(row, COLUMN.NEW_SHIPMENT_DATE, derived.date);
};

// TO_SITE/FROM_SITE 변경 cascade (R-14) — ITEM_ID 가 있을 때만 하위 3열을 비운다.
export const clearBodDerived = (row: GridRowData, write: CellWriter = directWrite): void => {
  write(row, COLUMN.INCOTERMS, '');
  write(row, COLUMN.TRANSPORT_MODE, '');
  write(row, COLUMN.BOD_ID, '');
};

// 셀 값 공백 판정 — **str() 을 쓰지 말 것**. str() 은 문자열/숫자만 값으로 보고 그 외(예: Wijmo 가
//   date 컬럼에 담는 Date 객체)는 '' 로 떨어뜨려, 값이 있는 Shipment Date 를 "없음" 으로 오판한다
//   (사용자 실측 2026-09-29: Shipment Date 채워도 "Please select the Shipment Date first"). Date 객체·
//   숫자·비공백 문자열은 값 있음으로 본다.
const blank = (v: unknown): boolean =>
  v === null || v === undefined || (typeof v === 'string' && v.trim() === '');

// INCOTERMS 선행값 중 **첫 번째로 빠진 필드 라벨** — AS-IS 는 MSG00098 "먼저 {0}을(를) 선택하십시오"
//   로 누락 필드를 특정한다(cs:5103~5120, 순서 Div → From Site → To Site → Model). null 이면 전부 채워짐.
export const firstMissingIncotermsPrereq = (row: GridRowData): string | null => {
  if (blank(row[COLUMN.DIVISION_ID])) return 'Div';
  if (blank(row[COLUMN.FROM_SITE_DESCRIPTION])) return 'From Site';
  if (blank(row[COLUMN.TO_SITE_DESCRIPTION])) return 'To Site';
  if (blank(row[COLUMN.ITEM_ID])) return 'Model';
  return null;
};

// TRANSPORT_MODE 선행값 중 첫 번째로 빠진 필드 라벨(AS-IS 순서 Shipment Date → Incoterms).
export const firstMissingTransportModePrereq = (row: GridRowData): string | null => {
  if (blank(row[COLUMN.SHIPMENT_DATE])) return 'Shipment Date';
  if (blank(row[COLUMN.INCOTERMS])) return 'Incoterms';
  return null;
};

// CHANGE_REASON_CODE 취소값 판정 — AS-IS 는 `'-'` **하나만** 취소로 본다.
//   cs:5872 `if (sNewChangeReasonCode == "-")` 단일 비교이고 공백은 else 로 빠져
//   `EDIT_MAIN='Y'` 가 찍힌다(cs:5880·5905). 설계 R-19/CP-12 서술은 "'-' 또는 공백" 이었으나
//   정본 직접 read 결과가 달라 AS-IS 를 따른다 — 공백까지 취소로 보면 사용자가 사유를 지운 행이
//   저장 대상에서 조용히 빠져 AS-IS 보다 저장 범위가 좁아진다.
export const isChangeReasonCleared = (code: string): boolean => code === CHANGE_REASON_NONE;

// CHANGE_REASON_CODE 연동 (R-24) — '-'/공백 선택 시 Detail 을 비우고 EDIT_MAIN='N'.
export const applyChangeReasonCode = (
  row: GridRowData,
  code: string,
  write: CellWriter = directWrite
): void => {
  if (isChangeReasonCleared(code)) {
    write(row, COLUMN.CHANGE_REASON_DETAIL, '');
    setEditMain(row, EDIT_MAIN_OFF);
    return;
  }
  setEditMain(row, EDIT_MAIN_ON);
};

/**
 * 동일 SO 대상 행에 CHANGE_REASON_CODE 를 전파한다 (AS-IS cs:5890~5906).
 *   '-'/공백이면 대상 행도 Detail 을 비우고 `EDIT_MAIN='N'` 이다 — 취소 의도가 저장 대상 확대로
 *   뒤집히지 않도록 `CRUD_TYPE` 강제 마킹(markPropagated)도 하지 않는다(CP-12 / R-19 예외).
 * 반환값 = 이 대상 행을 변경행으로 마킹해야 하는지 여부.
 */
export const propagateChangeReason = (
  target: GridRowData,
  code: string,
  detail: string,
  write: CellWriter = directWrite
): boolean => {
  write(target, COLUMN.CHANGE_REASON_CODE, code);
  if (isChangeReasonCleared(code)) {
    write(target, COLUMN.CHANGE_REASON_DETAIL, '');
    setEditMain(target, EDIT_MAIN_OFF);
    return false;
  }
  write(target, COLUMN.CHANGE_REASON_DETAIL, detail);
  return true;
};

// Reason Detail 입력 전 Reason Code 선행 필수 (MSG00287).
export const isReasonCodeMissing = (row: GridRowData): boolean => {
  const code = str(row[COLUMN.CHANGE_REASON_CODE]);
  return !code || code === CHANGE_REASON_NONE;
};

// 수량 소수자리 — 행 OPERATION_GROUP='E'(전극) 3자리 / 그 외 0자리(§2.3 S1, CP-6).
//   OPERATION_GROUP 은 GET SP 가 행마다 반환하지만 컬럼 메타에는 없다 -> 컬럼을 만들지 않고 행으로 읽는다.
//   편집 중 재판정(S2/S3/S5)은 SSP0200_GET_ITEM_FROM_BOD 미이관이라 이번 회차 미구현이다.
export const qtyScaleOf = (row: GridRowData): number =>
  str(row[COLUMN.OPERATION_GROUP]) === ELECTRODE_OPERATION_GROUP
    ? ELECTRODE_SCALE
    : NON_ELECTRODE_SCALE;

// 동일 SO 부분선택 검출 (C10 / MSG00247) — 선택 건수와 그룹 전체 건수가 다르면 부분선택이다.
export const hasPartialSoSelection = (rows: GridRowData[], selected: GridRowData[]): boolean => {
  const selectedBySo = new Map<string, number>();
  for (const row of selected) {
    const soNo = str(row[SO_GROUP_KEY]);
    if (!soNo) continue;
    selectedBySo.set(soNo, (selectedBySo.get(soNo) ?? 0) + 1);
  }
  for (const [soNo, count] of selectedBySo) {
    const total = rows.filter(r => str(r[SO_GROUP_KEY]) === soNo).length;
    if (total !== count) return true;
  }
  return false;
};
