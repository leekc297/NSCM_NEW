import type { MENU_ID, SHEETS } from './shipment-plan-confirm-detail.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SSP0012 는 generated procedures.d.ts 에 아직 없어
//   Base index-signature 로 loose 해석된다(SSP0201/SSP0014 자매와 동일 — 생성 SSOT 파일은 건드리지 않는다,
//   convert-core §2.2 Hard Boundary). PKG_SSP0012 배포(convert-sp) 후 SSOT 재생성 시 정밀 타입화.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1, 7조건):
export interface SearchCondition {
  divisionIds: string[]; // Division 다중 + 클라 필터 EE 제외(cascade parent)
  fromSiteIds: string[]; // From Site 다중 + ALL (cascade child, EE/비-EE 재조회 분기)
  itemId: string; // Model 다건(개행) + SCM0002_ItembyDivisionPopup 팝업
  fromYyyymmdd: string; // Period from (기본 오늘, SCM0001_GET_SCP_DAY_PERIOD)
  toYyyymmdd: string; // Period to (기본 오늘 +55영업일)
  soldToParty: string; // Sold To Party 자유 텍스트
  shipToParty: string; // Ship To Party 자유 텍스트
}

// 드릴다운 팝업 대상(design 03 W9/W10) — 셀 클릭 시 페이지가 캡처하는 파라미터.
export type DrilldownKind = 'BOD' | 'REQUEST';
export interface DrilldownParams {
  kind: DrilldownKind;
  // BOD: divisionId(EE면 originFromDivisionId) + bodId. REQUEST: changeReqNo.
  divisionId?: string;
  bodId?: string;
  changeReqNo?: string;
}
