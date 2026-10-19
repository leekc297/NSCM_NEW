// 조회조건 6종 = AS-IS cboDivision/cboPlanGroup/clbPlant/cboCompleted/dCalendar(From/To) 그대로.
//   메인 SP 파라미터 6개(procedures.d.ts SCP0124.main.request)와 1:1. AS-IS `usrConditionPanel1`
//   하위에 Activity/Process 조회조건은 없다 — `dtActivityCdAll`/`dtProcessCdAll`(cs:44·46)은 어느
//   컨트롤에도 바인딩되지 않는 미사용 로드이고(InitControls·FindData_Main 미참조, 그리드는 read-only·
//   셀콤보 0건) 조회 필터가 아니다. 그래서 두 필드를 두지 않는다.
export interface SearchParamProps {
  divisionId: string;
  planGroupId: string;
  plantId: string;
  completedYn: string;
  startDate: string;
  endDate: string;
}
