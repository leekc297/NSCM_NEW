import type { MENU_ID, SHEETS } from './shipment-change-request.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SSP0201 은 generated procedures.d.ts 에 아직 없어
//   Base index-signature 로 loose 해석된다(SSP0014 자매와 동일 — 생성 SSOT 파일은 건드리지 않는다,
//   convert-core §2.2 Hard Boundary). PKG_SSP0201 배포(convert-sp) 후 SSOT 재생성 시 정밀 타입화.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type SubRow = ResponseData<MENU_ID, SHEETS.SUB>;

// 조회조건 (Form 입력 상태 — design 02 §1, 9조건):
export interface SearchCondition {
  divisionId: string; // R3: '40' 고정 + disabled
  fromSiteIds: string[]; // 다중 + ALL (CN-1 콤보)
  toSiteIds: string[]; // 다중 + ALL
  changeType: string; // Plan Type 단일, 기본 'C', ALL 없음
  status: string; // 단일, P 제외 + ALL 선두, 기본 ALL
  itemId: string; // Model 다건(개행) + SSP0026 팝업
  fromYyyymmdd: string; // Period from (SCM0001_GET_SCP_DAY_PERIOD)
  toYyyymmdd: string; // Period to
  erpSoNo: string; // ERP SO No 다건(개행)
  confirmId: string; // Confirm ID 다건(개행)
}

// 요청정보 폼(영역1 하단, design 01 §1 panel1) — 변경요청 완료 시 필수 4항목.
export interface RequestInfo {
  requestNo: string; // hidden 내부 상태(R5) — 화면 비노출
  title: string; // Title* (필수)
  requestor: string; // Requestor (세션 사용자, 읽기전용)
  requestDeptName: string; // Dept Name (읽기전용)
  approval: string; // Approval* 승인자명 (btnApprovalUser 팝업)
  approvalId: string; // 승인자 ID(내부)
  appDeptName: string; // 승인부서명
  changeReason: string; // Change Reason* (cboChangeReason)
  reasonDetail: string; // Reason Detail* (txtReasonDetail)
}
