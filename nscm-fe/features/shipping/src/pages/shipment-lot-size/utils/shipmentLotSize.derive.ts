import { DEFAULT_REVERT } from '../shipment-lot-size.constants';

type Row = Record<string, unknown>;

// 문자열/숫자 -> 정수(빈값/비수치 = null). 빈 셀과 0 을 구분해야 auto-sync/검증이 정확하다.
export const toIntOrNull = (v: unknown): number | null => {
  if (typeof v !== 'string' && typeof v !== 'number') return null;
  const s = String(v).trim();
  if (s === '') return null;
  const n = Number(s);
  return Number.isFinite(n) ? Math.trunc(n) : null;
};

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// INCREMENT = LOT_SIZE auto-sync 파생 (design 03 §3-16, cs:735).
//   LOT_SIZE 편집 시 INCREMENT 가 비었거나 LOT_SIZE < INCREMENT 면 INCREMENT 를 LOT_SIZE 로 맞춘다.
//   반환: 새 INCREMENT 값(변경 불필요면 null). 호출부가 null 이 아니면 EditTracker.storeChange + 셀 반영.
export const computeIncrementSync = (row: Row): number | null => {
  const lot = toIntOrNull(row.LOT_SIZE);
  if (lot === null) return null;
  const inc = toIntOrNull(row.INCREMENT);
  if (inc === null || lot < inc) return inc === lot ? null : lot;
  return null;
};

// 기본값 회귀 판정 (design 03 §3-13, cs:594): M행이 (LOT='' & INC='' & VALID='Y' & SPLIT='N')면
//   변경취소로 간주 → 호출부가 CRUD_TYPE 해제(미변경). 신규행('I')은 대상 아님.
export const isDefaultRevertRow = (row: Row): boolean =>
  s(row.LOT_SIZE).trim() === '' &&
  s(row.INCREMENT).trim() === '' &&
  s(row.VALID_YN).trim().toUpperCase() === DEFAULT_REVERT.VALID_YN &&
  s(row.SPLIT_YN).trim().toUpperCase() === DEFAULT_REVERT.SPLIT_YN;
