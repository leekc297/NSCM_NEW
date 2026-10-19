/**
 * Division 체크값 매핑 — AS-IS `GetDivisionChecked(pDivision)`(SCP0128_SafetyStock.cs:217~251) 1:1
 * 재현. EE 계열 division 선택 시 Site 필터(RefreshSiteByDivision, .cs:260~274)와 저장 시 Item
 * 유효성 재조회(SaveData, .cs:733~741)가 이 매핑을 거친다 — TO-BE 에 없으면 EE 계열 division
 * 선택 시 Site 필터·Item 검증이 AS-IS 와 어긋난다(goal.md v2 ④-4, plan.md v2 §4 최우선 항목).
 *
 * AS-IS 는 EE 를 Site 필터에서 별도 분기(`DIVISION_ID IN ('81','40','82')`)로 처리하고, 이 함수는
 * EE_UC/EE_HM/EE_ST/EE_HD/EE_HG 5종만 매핑한다(EE 자체는 이 함수를 거치지 않음, .cs:264~272
 * RefreshSiteByDivision 참조) — 호출부에서 EE 분기를 먼저 확인해야 한다.
 */
const DIVISION_CHECKED_MAP: Readonly<Record<string, string>> = {
  EE: '81,82,40',
  EE_UC: '81_UC',
  EE_HM: '81_HM',
  EE_ST: '81_ST',
  EE_HD: '81_HD',
  EE_HG: '81_HG',
};

export const getDivisionChecked = (division: string): string =>
  DIVISION_CHECKED_MAP[division] ?? division;
