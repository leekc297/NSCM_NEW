/**
 * Site(init o_rc2)를 선택 Division 으로 좁히는 규칙 — AS-IS RefreshSiteByDivision(SCP0129.cs:261~275)
 *   + GetDivisionChecked(.cs:218~252) 재현:
 *   · 'EE'                → DIVISION_ID IN ('81','40','82')
 *   · 'EE_UC/HM/ST/HD/HG' → '81_UC/81_HM/81_ST/81_HD/81_HG' 매핑 후 일치
 *   · 그 외               → DIVISION_ID = 선택 Division (원값)
 *
 * PlanGroup(o_rc1)·Stage(o_rc7)는 EE 분기 없이 DIVISION_ID 원값 단순일치(.cs:254~283,
 *   RefreshPlanGroupByDivision/RefreshStageByDivision)라 이 유틸을 쓰지 않는다. 형제 SCP0128
 *   safety-stock.util.ts matchSiteByDivision 과 동형(동일 AS-IS 헬퍼).
 */
const EE_SUB_DIVISION_MAP: Record<string, string> = {
  EE_UC: '81_UC',
  EE_HM: '81_HM',
  EE_ST: '81_ST',
  EE_HD: '81_HD',
  EE_HG: '81_HG',
};

export const matchSiteByDivision = (siteDivisionId: unknown, selectedDivision: string): boolean => {
  const sid = typeof siteDivisionId === 'string' ? siteDivisionId : '';
  if (selectedDivision === 'EE') return ['81', '40', '82'].includes(sid);
  return sid === (EE_SUB_DIVISION_MAP[selectedDivision] ?? selectedDivision);
};
