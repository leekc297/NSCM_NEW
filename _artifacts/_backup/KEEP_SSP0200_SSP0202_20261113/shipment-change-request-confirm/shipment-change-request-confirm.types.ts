import type { MENU_ID, SHEETS } from './shipment-change-request-confirm.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SSP0202 는 generated procedures.d.ts 에 아직 없어
//   Base index-signature 로 loose 해석된다(자매 SSP0201 과 동일 — 생성 SSOT 파일은 건드리지 않는다,
//   convert-core §2.2 Hard Boundary). PKG_SSP0202 배포(convert-sp) 후 SSOT 재생성 시 정밀 타입화.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type SubRow = ResponseData<MENU_ID, SHEETS.SUB>;

// 조회조건 (Form 입력 상태 — design 02 §1, 7조건):
export interface SearchCondition {
  divisionId: string; // C1: '40' 고정 + disabled
  fromSiteIds: string[]; // 다중 + ALL (FromSiteByDivisionOspPack)
  status: string; // 단일 + ALL 선두, 기본 'Q'(Requested)
  changeType: string; // 단일 + ALL 선두, 기본 'ALL'. 'P'=컬럼분기 트리거
  requestId: string; // Requestor 다건(콤마) — SsoUserModal 팝업
  itemId: string; // Model 다건(콤마) — MaterialByDivisionModal(COM0013) 팝업
  fromYyyymmdd: string; // Period from (D-14)
  toYyyymmdd: string; // Period to (오늘)
}

// 디테일 폼(영역1 하단, design 01 §2 B1) — 마스터 더블클릭 시 detail GET SP Tables[1] 바인딩.
//   8필드 읽기전용 + rejectReason 만 입력(반려/자기반려 사유, B4).
export interface ConfirmDetail {
  requestNo: string; // CHANGE_REQ_NO
  title: string; // REQUEST_TITLE
  requestor: string; // REQUEST_USER
  requestDeptName: string; // REQUEST_DEPT
  approval: string; // APPROVAL_USER
  appDeptName: string; // APPROVAL_DEPT_NAME
  changeReason: string; // CHANGE_REASON_CODE(표시)
  reasonDetail: string; // CHANGE_REASON_DETAIL
}
