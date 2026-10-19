import { CRUD_TYPE } from '@foundation/constants';
import { safeString } from '@foundation/utils';

/**
 * Customer FCST Master(DMF0007) 중복 검사 두 가지 — AS-IS DMF0007_CustFcstMaster.cs
 * shtMainFCSTDataModel_Changed(L1202~1465) 1:1. 위반 시 MSG00136 「동일 구간에 하나의 Y만 가능합니다.」
 * 후 입력을 취소한다(AS-IS SetText "").
 *
 *   ① 행 키 중복(L1222~1256): 신규(I) 행의 키 셀(Division, End Customer, Sales Site, Group, Measure)이
 *      바뀌었을 때, Division·End Customer·Sales Site·Group 네 칸이 다 차 있으면 그리드 전체에서
 *      다섯 키(네 칸 + Measure)가 같은 행을 센다. 자기 자신 포함 2행 이상이면 중복. Measure 는 비어
 *      있어도 비교에 들어간다(AS-IS 동일 — 같은 사이트에 Measure 를 아직 안 고른 신규 2행도 걸린다).
 *   ② 같은 구간 Y 하나(L1421~1455): 날짜 칸(D_yyyymmdd)에 Y 가 들어오면, 네 키(Division·End
 *      Customer·Sales Site·Group — Measure 는 보지 않는다)가 같은 행 중 그 날짜 칸이 Y 인 행을 센다.
 *      자기 자신 포함 2행 이상이면 중복. 신규·기존 행 구분 없이 본다.
 *
 * 왜 화면이 막아야 하는가. 같은 사이트·같은 주에 두 Measure 가 유효(Y)로 저장되면 이후 수요 생성이
 * 실패하거나 이중 반영될 수 있다. TO-BE 저장 SP 와 공용 검증에는 이 규칙이 없다(2026-10-07 리포트).
 */

export const PERIOD_KEY_BINDINGS = [
  'DIVISION_ID',
  'CUSTOMER_CODE',
  'SCM_SITE_ID',
  'MEASURE_GROUP',
] as const;
export const ROW_KEY_BINDINGS = [...PERIOD_KEY_BINDINGS, 'MEASURE'] as const;
export type RowKeyBinding = (typeof ROW_KEY_BINDINGS)[number];

/** 날짜 칸 binding 접두 — utils/CustomerFcstMasterDateColumns 가 `D_yyyymmdd` 로 만든다. */
export const DATE_BINDING_PREFIX = 'D_';
export const isDateBinding = (binding: string): boolean => binding.startsWith(DATE_BINDING_PREFIX);
export const isRowKeyBinding = (binding: string): binding is RowKeyBinding =>
  (ROW_KEY_BINDINGS as readonly string[]).includes(binding);

type KeyRow = Record<string, unknown> & { CRUD_TYPE?: unknown };

const cellText = (value: unknown): string => safeString(value).trim();

const sameOn = (a: KeyRow, b: KeyRow, bindings: readonly string[]): boolean =>
  bindings.every(binding => cellText(a[binding]) === cellText(b[binding]));

/**
 * ① 신규 행 키 중복 — 네 키가 모두 차 있는 신규 행에 대해, 다섯 키가 같은 행이 자기 외에 또 있으면 true.
 *   신규 행이 아니거나 네 키 중 빈 칸이 있으면 검사하지 않는다(AS-IS 조건 그대로).
 */
export const hasDuplicateRowKey = (rows: readonly KeyRow[], row: KeyRow): boolean => {
  if (row.CRUD_TYPE !== CRUD_TYPE.INSERT) return false;
  if (PERIOD_KEY_BINDINGS.some(binding => cellText(row[binding]) === '')) return false;
  let count = 0;
  for (const other of rows) {
    if (sameOn(other, row, ROW_KEY_BINDINGS)) count += 1;
  }
  return count > 1;
};

/**
 * ② 같은 구간 Y 하나 — 그 날짜 칸이 Y 인 행 중 네 키가 같은 행이 자기 외에 또 있으면 true.
 *   호출부는 편집된 셀 값이 Y 일 때만 부른다. 네 키 중 빈 칸이 있으면 비교 대상이 모호하므로
 *   검사하지 않는다(AS-IS 는 그 전에 필수값 안내로 멈춘다).
 */
export const hasOtherYInPeriod = (
  rows: readonly KeyRow[],
  row: KeyRow,
  dateBinding: string
): boolean => {
  if (!isDateBinding(dateBinding)) return false;
  if (PERIOD_KEY_BINDINGS.some(binding => cellText(row[binding]) === '')) return false;
  let count = 0;
  for (const other of rows) {
    if (cellText(other[dateBinding]) !== 'Y') continue;
    if (sameOn(other, row, PERIOD_KEY_BINDINGS)) count += 1;
  }
  return count > 1;
};
