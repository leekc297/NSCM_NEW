// SCP0048 파생값(design/03 §3.2).
//   FROM/TO_YYYYMMDD 셀 변경 시 ORG_FROM/ORG_TO/MERGE_DATE 세팅(R-ORG, 검증 N1~N9 전제).
//   PLANT_SITE_ID 선택 시 마지막 문자 = TACT_TIME_FLAG(R-D1). 표시문자열 합성은 셀콤보 NAME 이
//   'DIV||SITE||DESC|| Y/N'(design/03 §3.1) 이라 last-char 가 Y/N 이다.

import { safeString } from '@foundation/utils';

/** 하이픈 제거 후 8자리 숫자만. 그 외는 빈 문자열. */
const toYmd8 = (value: unknown): string => {
  const digits = safeString(value).replace(/\D/g, '');
  return digits.length === 8 ? digits : '';
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
 * PLANT_SITE_ID 셀 콤보 NAME 마지막 문자 = TACT_TIME_FLAG(design/03 R-D1).
 *   콤보 NAME 이 '...Y' | '...N' 형태라 마지막 글자를 그대로 취한다. Y/N 외는 빈값.
 */
export const deriveTactTimeFlag = (plantSiteDisplay: unknown): string => {
  const text = safeString(plantSiteDisplay).trim();
  if (text.length === 0) return '';
  const last = text.charAt(text.length - 1).toUpperCase();
  return last === 'Y' || last === 'N' ? last : '';
};

export { toYmd8 };
