import type { MENU_ID, SHEETS } from './shipment-model-pic.constants';

// 그리드 행 — procedures.d.ts 기반. GET SP 반환 21컬럼 (design 03 §1/§4).
//   B-7 로 `configs/types/procedures.d.ts` 에 SSP0014.main 을 손으로 등재해(요청 7필드 + o_rc1 21열,
//   SCM_ADM_PROC_M·SCM_MST_SHEET_COLUMNS 실측) 이제 Base index-signature loose 해석이 아니다.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1):
//   Division*(단일,필수) / OperationGroup(단일+ALL) / FromSite(다중+ALL) / Valid(단일+ALL)
//   / Model(다건 ^) / UserId(LIKE 텍스트).
export interface SearchCondition {
  divisionId: string;
  operationGroup: string; // ALL sentinel = 전체
  fromSiteIds: string[];
  validYn: string; // ALL sentinel = 전체
  itemId: string; // 다건 (txtItemId — btnItemId SCM0002 팝업이 채움, 콤마 구분)
  userId: string; // LIKE 텍스트 (User ID(Name), GET SP 6필드 OR)
}

// ====================================================================================
// SAVE / USER_CHECK 계약 (B-7) — 화면 로컬 타입
// ====================================================================================
// 생성 SSOT(`configs/types/procedures.d.ts`)에 SSP0014 가 아직 없고, 그 파일은 생성물이라
//   이 activity 가 손으로 고치지 않는다(convert-core §2.2 Hard Boundary / G50 은 SSOT 재생성 과제).
//   대신 payload 오타를 컴파일에서 잡도록 **화면 로컬**로 정의하고 `apiClient.post<Res, Req>` 의
//   두 제네릭을 모두 지정한다. Record 조립 + 강제 캐스팅은 금지(키 오타가 통과한다).
//
// 필드 14개·순서·타입은 `SCM_ADM_PROC_M` 실측(ora.py 2026-09-28,
//   PROC_NM='PKG_SSP0014.P_SSP0014_SAVE_MODEL_PIC', COL_TP_CD='IN', SORT_ORD 1~14):
//   1 activeFlag(CLOB) 2 divisionId 3 fromSite 4 itemId 5 userId 6 validYn
//   7 createId(**VARCHAR 단일 스칼라** — '^' join 금지) 8 partLeader 9 teamLeader
//   10~14 mailUser1~5. 7번을 제외한 13개가 '^' 구분 다건 CLOB 이다.
export interface SaveRequest {
  activeFlag: string;
  divisionId: string;
  fromSite: string;
  itemId: string;
  userId: string;
  validYn: string;
  createId: string;
  partLeader: string;
  teamLeader: string;
  mailUser1: string;
  mailUser2: string;
  mailUser3: string;
  mailUser4: string;
  mailUser5: string;
}

// SAVE 결과커서 1행. 성공/실패에 따라 존재하는 컬럼이 다르므로 전부 optional 이다
//   (본문 실측: 성공 RESULT_CODE·RESULT_CNT·CODE·MSG / 실패 RESULT_CODE·ERR_MESSAGE·CODE·MSG).
export interface SaveResultRow {
  RESULT_CODE?: string;
  RESULT_CNT?: number | string;
  ERR_MESSAGE?: string;
  CODE?: string;
  MSG?: string;
}

// USER_CHECK 요청 — CHECK proc IN 은 userId(CLOB) 단일, '^' 구분 다건(C_DELIMITER='^').
export interface UserCheckRequest {
  userId: string;
}
