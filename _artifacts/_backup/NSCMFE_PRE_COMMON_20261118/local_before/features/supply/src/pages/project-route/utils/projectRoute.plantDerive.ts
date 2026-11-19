// SCP0006 Plant 파생값(design/03 §3.2 R-ORG).
//   FROM/TO_YYYYMMDD 셀 변경 시 ORG_FROM/ORG_TO/MERGE_DATE 를 세팅한다. 저장검증(N1~N9)이
//   ORG_*·MERGE_DATE 기준으로 판정하므로 이 파생이 검증의 전제다(design/03 R-ORG).

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

export { toYmd8 };
