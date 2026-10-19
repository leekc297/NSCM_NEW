// New Plan 팝업(AS-IS SCM0002_ShipmentPlanInsertPopup) — SCP0009(FG)/SCP0010(SEMI) 공용 모달.
//   호출 화면은 context.programId('FG'|'SEMI')와 menuId 만 넘긴다. 내부 분기(Project Code 표시/숨김,
//   toSite 마스터, Operation Group 콤보 등)는 programId 로 처리된다.
export { NewPlanModal } from './NewPlanModal';
export type { NewPlanContext, NewPlanProgramId } from './newPlan';
