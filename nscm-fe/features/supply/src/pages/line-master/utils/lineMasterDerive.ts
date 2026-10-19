import { RACK_SUFFIX } from '../line-master.constants';

// SCM_SITE_ID 신규행 콤보 선택 시 파생 (design 03 §3.1 #5 — cs:751 SetCombinationValue).
//   콤보 반환행 = { CODE, NAME, OPERATION_ID }. SCM_SITE_ID=CODE, SITE_DESCRIPTION=NAME, OPERATION_ID=OPERATION_ID.
//   OPERATION_ID 는 이후 RACK_YN='Y' 접미사(deriveOperationId)의 기준값이 된다.
export interface SiteComboOption {
  CODE: string;
  NAME: string;
  OPERATION_ID: string;
}

export interface SiteDerived {
  SCM_SITE_ID: string;
  SITE_DESCRIPTION: string;
  OPERATION_ID: string;
}

export const deriveSiteSelection = (opt: SiteComboOption): SiteDerived => ({
  SCM_SITE_ID: opt.CODE,
  SITE_DESCRIPTION: opt.NAME,
  OPERATION_ID: opt.OPERATION_ID,
});

// RACK_YN 변경 시 OPERATION_ID 파생 (design 03 §3.1 #6 — cs:795):
//   'Y' 이면 기준 OPERATION_ID 에 '_R1' 접미사(중복 부착 방지) / 'N' 이면 접미사 제거.
//   baseOperationId = SCM_SITE_ID 선택으로 채워진 순수 OPERATION_ID (접미사 이전 원본).
export const deriveOperationIdByRack = (baseOperationId: string, rackYn: string): string => {
  const base = baseOperationId.endsWith(RACK_SUFFIX)
    ? baseOperationId.slice(0, -RACK_SUFFIX.length)
    : baseOperationId;
  return rackYn === 'Y' ? `${base}${RACK_SUFFIX}` : base;
};
