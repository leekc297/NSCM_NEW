import type { MENU_ID, SHEETS } from './shipment-change-request-confirm-ssp0003.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SSP0003 는 procedures.d.ts RawProcedureMap 에 등재됨
//   (자기 화면 SHEETS 는 Hard Boundary 허용 범위, convert-core §2.2 / SSP0003-14). request 키는 PROC_M
//   COL_NM 정합으로 강타입화되어 오타가 compile-time 에 검출된다. response 행 shape 은 컬럼 메타 위임이라
//   WijmoRowItem 으로 loose 유지 → MainRow/SubRow 는 종전과 동일하게 동적 컬럼 소비에 열려 있다.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type SubRow = ResponseData<MENU_ID, SHEETS.SUB>;

// 조회조건 (Form 입력 상태 — design 02 §1, 7조건):
export interface SearchCondition {
  divisionIds: string[]; // 다중 + ALL. MyDivisionInEE_SCP + FE 클라 EE 제거(design 02 §2.1)
  fromSiteIds: string[]; // 다중 + ALL (PlantSiteByDivision_SCP, divisionIds cascade)
  status: string; // 단일 + ALL 선두, 기본 'Q'(Requested)
  changeType: string; // 단일 + ALL 선두, 기본 'ALL'. 'P'=컬럼분기 트리거
  requestId: string; // Requestor 다건(콤마) — SsoUserModal 팝업
  itemId: string; // Model 다건(콤마) — MaterialByDivisionModal(COM0013) 팝업
  fromYyyymmdd: string; // Period from (D-14)
  toYyyymmdd: string; // Period to (오늘)
}

// 디테일 폼(영역1 하단, design 01 §2-C) — 마스터 더블클릭 시 detail GET SP o_rc2 바인딩.
//   8필드 읽기전용 + rejectReason 만 입력(반려/자기반려 사유, C3).
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
