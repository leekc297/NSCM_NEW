// SCP0027 파생값(design/03 §3.3).
//   FROM/TO_YYYYMMDD 셀 변경 시 ORG_FROM/ORG_TO/MERGE_DATE 세팅(R-ORG, 검증 N1~N6 전제).
//   PLANT_SITE_ID 선택 시 마지막 문자 = TACT_TIME_FLAG(R-TACT). 셀콤보 NAME 이
//   'DIV||SITE||DESC|| Y/N'(design/03 §1 col5 ElecRoutePlantByOperation_SCP) 이라 last-char 가 Y/N 이다.

import { safeString } from '@foundation/utils';

/** 하이픈 제거 후 8자리 숫자만. 그 외는 빈 문자열. */
const toYmd8 = (value: unknown): string => {
  const digits = safeString(value).replace(/\D/g, '');
  return digits.length === 8 ? digits : '';
};

/** 8자리 YYYYMMDD 가 달력에 실제로 있는 날짜인지(예: 99999999, 20260230 은 false). */
export const isCalendarYmd8 = (ymd8: string): boolean => {
  if (!/^\d{8}$/.test(ymd8)) return false;
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6));
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
};

const daysInMonth = (y: number, m: number): number => new Date(Date.UTC(y, m, 0)).getUTCDate();

/**
 * 입력 중인 날짜 8칸(빈칸 null)이 아직 유효한 날짜가 될 수 있는지. AS-IS FarPoint 날짜 셀처럼
 *   월 13, 일 32, 2월 30일처럼 달력에 없는 값을 만드는 키 입력을 막는 데 쓴다.
 */
export const isPartialYmdValid = (slots: (string | null)[]): boolean => {
  const num = (from: number, to: number) => {
    const part = slots.slice(from, to);
    return part.every(c => c != null) ? Number(part.join('')) : null;
  };
  const year = num(0, 4);
  const month = num(4, 6);
  const day = num(6, 8);
  if (year === 0) return false;
  if (slots[4] != null && Number(slots[4]) > 1) return false;
  if (month != null && (month < 1 || month > 12)) return false;
  if (slots[6] != null && Number(slots[6]) > 3) return false;
  if (day != null) {
    const max = month == null ? 31 : daysInMonth(year ?? 2000, month);
    if (day < 1 || day > max) return false;
  }
  return true;
};

/** FROM/TO → { ORG_FROM_YYYYMMDD, ORG_TO_YYYYMMDD, MERGE_DATE }. */
export const deriveOrgDates = (
  fromValue: unknown,
  toValue: unknown
): { ORG_FROM_YYYYMMDD: string; ORG_TO_YYYYMMDD: string; MERGE_DATE: string } => {
  const orgFrom = toYmd8(fromValue);
  const orgTo = toYmd8(toValue);
  return {
    ORG_FROM_YYYYMMDD: orgFrom,
    ORG_TO_YYYYMMDD: orgTo,
    MERGE_DATE: orgFrom + orgTo,
  };
};

/**
 * PLANT_SITE_ID 셀 콤보 NAME 마지막 문자 = TACT_TIME_FLAG(design/03 R-TACT).
 *   콤보 NAME 이 '...Y' | '...N' 형태라 마지막 글자를 그대로 취한다. Y/N 외는 빈값.
 */
export const deriveTactTimeFlag = (plantSiteDisplay: unknown): string => {
  const text = safeString(plantSiteDisplay).trim();
  if (text.length === 0) return '';
  const last = text.charAt(text.length - 1).toUpperCase();
  return last === 'Y' || last === 'N' ? last : '';
};

export { toYmd8 };
