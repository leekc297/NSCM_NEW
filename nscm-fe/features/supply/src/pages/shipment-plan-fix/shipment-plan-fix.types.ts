import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-fix.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0025 는 GET SP 가 동적 pivot(D_/W_/M_) 을 반환해 컬럼셋이
//   조회기간마다 가변이라 정적 타입 불가 → 자매 SCP0024 처럼 Base 인덱스시그니처 fallback
//   (Record<string, WijmoRowItem> & { CRUD_TYPE?: string })으로 해석한다(procedures.d.ts 미등재).
//   pivot 값/키 컬럼(measure/D_·W_·M_/hidden 키 등)은 GET SP O_RC1 반환에 포함(design 03 §1/§2/§4).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchCondition). design 02 §1 인벤토리 C1~C12 + §5.3 GET SP 10 파라미터 매핑.
export interface SearchCondition {
  divisionId: string; // C1 단일 (cascade 최상위, 필수). EE 여부로 opGroup 콤보 코드셋 스왑
  operationGroupId: string; // C2 단일 (cascade L2). EE=A,E / 비EE=P,A. GET param = bizType
  electrodeTypes: string[]; // C3 다중 (lookup ELECTRODE_TYPE). GET param = electype
  bucket: BUCKET_TYPE; // C4 기본 DAILY. 변경 = 그리드 기간컬럼 visible 토글(재조회 아님)
  fromYyyymmdd: string; // C5 dCalendar from
  toYyyymmdd: string; // C5 dCalendar to
  chkSum: boolean; // C6 SUM 컬럼 가시성 토글 (SP 미전달, 그리드 표시 전용)
  itemId: string; // C7 txtItem_Id (btnItem_Id 팝업이 채움)
}
