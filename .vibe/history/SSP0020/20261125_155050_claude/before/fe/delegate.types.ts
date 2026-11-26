import type { MENU_ID, SHEETS } from './delegate.constants';

// GET SP 반환행 — procedures.d.ts(SSOT) 기반. SSP0020 는 생성 SSOT 에 아직 없어 Base
//   index-signature 로 loose 해석된다(SSP0014 자매와 동일 — 생성 파일은 건드리지 않는다,
//   convert-core §2.2 Hard Boundary). o_rc1=Delegate / o_rc2=Delegated List (design 03 §4-2).
export type DelegateRow = ResponseData<MENU_ID, SHEETS.DELEGATE>;
export type DelegatedRow = ResponseData<MENU_ID, SHEETS.DELEGATED>;

// 위임 설정 입력값 (조회 필터 아님 — GET 은 p_user_id/p_language 만. design 02 §5):
//   clbDivision(다중 체크) + drpPeriod(From/To) + txtDelegatee(입력/팝업). SAVE/UNSET payload 원천.
export interface DelegateInput {
  divisionIds: string[]; // clbDivision 체크된 division (ALL 확장, 저장 대상)
  fromDate: string; // YYYYMMDD (drpPeriod From, human-doc 보완-3 확정)
  toDate: string; // YYYYMMDD (drpPeriod To)
  delegatee: string; // 위임자명(txtDelegatee 입력/팝업 표시)
  delegateeId: string; // 확정 위임자 UserID (팝업 선택 or UserName_Search 검증)
}
