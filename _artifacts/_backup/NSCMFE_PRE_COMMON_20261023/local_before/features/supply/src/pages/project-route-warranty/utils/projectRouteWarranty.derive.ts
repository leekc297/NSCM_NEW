// SCP0048 파생값(design/03 §3.2).
//   PLANT_SITE_ID 선택 시 마지막 문자 = TACT_TIME_FLAG(R-D1). 표시문자열 합성은 셀콤보 NAME 이
//   'DIV||SITE||DESC|| Y/N'(design/03 §3.1) 이라 last-char 가 Y/N 이다.
//   주의: AS-IS 의 ORG_FROM/ORG_TO/MERGE_DATE 는 FE 파생 대상이 아니다. ORG_* 는 서버 GET 이
//   A.FROM_YYYYMMDD/A.TO_YYYYMMDD 원본(YYYYMMDD)으로 내려주는 검증용 working 컬럼이고(design/03
//   §1 col20/21), FROM/TO_YYYYMMDD 표시는 YYYY-MM-DD(FPDateText)다. TO-BE 저장검증은 ORG_* 가
//   없으면 FROM/TO 를 toYmd8 로 정규화해 동일 8자리를 얻는다(useProjectRouteWarrantyValidation
//   fromOf/toOf). 저장 SP 도 P_FROM/TO_YYYYMMDD 만 받고 ORG_*/MERGE_DATE 는 받지 않으므로 FE 파생이
//   불필요하다.

import { safeString } from '@foundation/utils';

/** 하이픈 제거 후 8자리 숫자만. 그 외는 빈 문자열. */
const toYmd8 = (value: unknown): string => {
  const digits = safeString(value).replace(/\D/g, '');
  return digits.length === 8 ? digits : '';
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
