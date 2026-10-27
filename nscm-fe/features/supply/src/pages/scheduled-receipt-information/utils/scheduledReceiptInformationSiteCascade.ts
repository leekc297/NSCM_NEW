// WijmoRowItem 등 전역 타입은 import 불필요(다른 화면 util 과 동일).
import type { ComboResponse } from '@foundation/models';

/**
 * Plant Site 콤보 전용 사업부 확장 — AS-IS GetDivisionChecked(.cs:257-291) + RefreshSiteByDivision
 *   EE 분기(.cs:354-362) 재현: EE 집계 사업부는 Site 를 구성 사업부로 확장한다(EE→81/40/82,
 *   EE_xx→81_xx). PlanGroup/ChildMaterial 은 AS-IS 가 원값 필터라 확장 대상이 아니다.
 *   검색조건 Site(Form)와 그리드 셀 Plant Site(VirtualBomGrid) 가 같은 규칙을 써야 하므로 util 로 둔다.
 */
const EE_SITE_EXPAND: Record<string, string[]> = {
  EE: ['81', '82', '40'],
  EE_UC: ['81_UC'],
  EE_HM: ['81_HM'],
  EE_ST: ['81_ST'],
  EE_HD: ['81_HD'],
  EE_HG: ['81_HG'],
};

export const siteDivisionFilter = (divisionId: string): string[] => {
  if (!divisionId) return [];
  return EE_SITE_EXPAND[divisionId] ?? [divisionId];
};

/**
 * 그리드 셀 Plant Site 콤보 후보 — 콤보 응답(PlantSiteSir, 전 사업부)을 행 Division 으로 좁히고
 *   CODE 중복제거(AS-IS CopyPlantSite 의 Distinct(CODE,NAME), first-wins). 그리드 셀 DataMap 의
 *   원본 행으로 쓴다.
 *   그리드 셀 콤보는 메타 attribute2='DIVISION_ID:DIVISION_ID' 단순일치로는 EE→구성 사업부 확장을
 *   표현할 수 없어(filterComboRowsByRowItem 은 정확일치) 화면이 직접 DataMap 을 만들어 덮는다
 *   (형제 SCP0129 demandExceptionSiteCascade 동형).
 */
export const pickSiteRowsForDivision = (
  rows: ComboResponse[],
  divisionId: string
): ComboResponse[] => {
  const allowed = siteDivisionFilter(divisionId);
  const seen = new Set<string>();
  const out: ComboResponse[] = [];
  for (const row of rows) {
    if (allowed.length && !allowed.includes(row.DIVISION_ID)) continue;
    if (seen.has(row.CODE)) continue;
    seen.add(row.CODE);
    out.push(row);
  }
  return out;
};
