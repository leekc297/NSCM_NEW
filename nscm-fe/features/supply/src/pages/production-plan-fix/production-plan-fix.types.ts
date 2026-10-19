import type { BUCKET_TYPE, MENU_ID, SHEETS } from './production-plan-fix.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0024 는 GET SP 가 동적 pivot(D_/W_/M_) 을 반환해 컬럼셋이
//   조회기간마다 가변이라 정적 타입 불가 → 자매 SCP0013/SCP0020 처럼 Base 인덱스시그니처 fallback
//   (Record<string, WijmoRowItem> & { CRUD_TYPE?: string })으로 해석한다(procedures.d.ts 미등재).
//   pivot 값/편집판정에 쓰는 컬럼(MEASURE/D_·W_·M_ 등)은 GET SP 반환에 포함(design 03 §2.3/§4).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 + §5.3 GET SP 9 파라미터 매핑.
export interface SearchCondition {
  divisionId: string; // C1 단일 (cascade 최상위, 필수). EE 여부로 opGroup 콤보 코드셋 스왑
  operationGroupId: string; // C2 단일 (cascade L2). EE=A,E / 비EE=P,A
  plantSiteIds: string[]; // C3 다중 (cascade L3)
  lineIds: string[]; // C4 다중 (cascade L4, '-' sentinel → 제외)
  electrodeTypes: string[]; // C5 다중 (lookup ELECTRODE_TYPE, ALL→NULL)
  bucket: BUCKET_TYPE; // C6 기본 DAILY (D_ 편집 band 노출). 변경=그리드 기간컬럼 visible 토글(재조회 아님)
  fromYyyymmdd: string; // C7 dCalendar from
  toYyyymmdd: string; // C7 dCalendar to
  itemId: string; // C8 txtItemId (btnItemId 팝업이 채움)
  chkSum: boolean; // C13 SUM(W_/M_ 롤업) 컬럼 가시성 토글 (SP 미전달, 그리드 표시 전용)
}
