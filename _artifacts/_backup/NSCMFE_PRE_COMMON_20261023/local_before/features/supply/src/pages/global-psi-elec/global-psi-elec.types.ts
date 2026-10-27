import type { MENU_ID, SHEETS } from './global-psi-elec.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0095 는 procedures.d.ts 미등재라 Base 인덱스시그니처
//   fallback(Record<string, WijmoRowItem>)으로 해석된다(자매 SCP0100/SCP0111 동일). pivot 값(D_/W_/M_ 기간칼럼)은
//   메인 SP 가 동적 emit 하므로 정적 타입 열거가 불가 — 자매와 동일하게 fallback 을 정본으로 쓴다(04_react-gap §SSOT).
export type GlobalPsiElecRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건(Form 입력 상태 — searchCondition). design 02 §1 인벤토리 6조건 + §5 GET 11-param 매핑.
//   순수 조회 — 저장/입력 필드 없음. chkSum 은 AS-IS Visible=false(미노출) — 상태만 보유(design 03 §2.2 확인필요 #2).
export interface SearchCondition {
  divisionId: string; // cboDivision — EE 전극 사업부(FE ATTRIBUTE3='EE' 필터). 다중선택 콤마구분. p_division_id
  company: string; // cboCompany — COMPANY_EE 다중선택. 값=COMPANY_NAME. p_company
  itemId: string; // txtItem_Id — ElecMaterialPopup 이 채움. p_item_id
  planStartYyyymmdd: string; // cboPlanDate — DATE_WEEKLY(division cascade). p_yyyymmdd. 단일선택
  fromYyyymmdd: string; // dCalendar From — Period(기본 W52). p_from_yyyymmdd
  toYyyymmdd: string; // dCalendar To — Period(기본 W52). p_to_yyyymmdd
  bucket: string; // cboBucketType — DAILY/WEEKLY(기본)/MONTHLY. D_/W_/M_ pivot visible 토글(조회 파라미터 아님)
  chkSum: boolean; // chkSum — AS-IS Visible=false 미노출(design 03 §2.2). 상태만 보유(SUM 컬럼 토글 근거)
}
