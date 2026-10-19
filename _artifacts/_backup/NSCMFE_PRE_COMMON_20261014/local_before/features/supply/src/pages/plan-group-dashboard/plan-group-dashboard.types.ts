export interface SearchParamProps {
  divisionId: string;
  planGroupId: string;
  plantId: string;
  completedYn: string;
  startDate: string;
  endDate: string;
  // usrConditionPanel1 하위 상세조건 — comboCalls#2/#3(ActivityCode_SCP_ALL/LookupCommon)이 이
  // 화면의 조회조건 필터인지 그리드 코드→명 변환용인지 boundControl 미확정(02_search-combo.md
  // §2.2/§7-4). 메인 SP 파라미터 6개(procedures.d.ts SCP0124.main.request)에 포함되지 않으므로
  // 값을 담는 UI 필드만 두고 setFilters() 시 SP 파라미터로 보내지 않는다 — 확인 필요.
  activityCode: string;
  processCode: string;
}
