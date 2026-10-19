// SDM1010 화면의 이름표 — 다른 모든 파일이 여기서 import 한다.
// (참고: GUIDE_신규화면_개발_SalesSite.md Step 2)

// 화면 고유 ID. BE API 경로(/admin/menu/SDM1020/column)와 procedures.d.ts 의
// RawProcedureMap 키의 기준이 된다.
export const MENU_ID = 'SDM1020' as const;
export type MENU_ID = typeof MENU_ID;

// SDM1020 Project List (SDM > SDM_Project > Project List — ROUTE_PATH 'sdm/project-list').
//   ⭐ 정본 원천 = 화면설계서 xlsx (AS-IS GSCM 대응 화면 부재 — 순수 신규, hook #134) +
//     메타 등재 계약 `_artifacts/_apply_corporate/SDM1020_META_20260819/_CONTRACT.md` (배선 단일 원천).
//   단일 그리드(탭 없음) — **저장 버튼 없음**: 그리드 수정('M')은 [등록요청]에 의해서만 저장 (P-25).
//   SP 3본 = PKG_SDM1020 (P_SDM1020_GET_PJT_LIST / BTN_REQ_PJT_REG / REQ_PJT_AUTH).
//   권한관리 모달 = SDM1010 `ProjectAuthRegModal` 공용 승격분 재사용 (`features/sdm/src/components/`
//   — 모달 내부 MENU_ID 는 SDM1010 유지: POP1_* 메타·권한 소유).

// 서버로 보낼 sheet 이름(요청). 화면설계서의 프로시저명과 1:1 대응:
export enum SHEETS {
  MAIN = 'Project List', // SHT_NM 실명(공백 포함) — API_ID 시트 토큰은 'main' (계약 ② — DMF0003 'Mkt Fcst' 전례)
  /** 화면설계서 — 프로젝트 조회/변경(편집 가능한 프로젝트 마스터 그리드) */
  PROJECT = 'project',
  /** 권한관리 팝업 — 조직도(부서 트리) */
  POPUP_ORG = 'popupOrg',
  /** 권한관리 팝업 — 선택한 조직 노드에 속한 사용자 목록 */
  POPUP_USER = 'popupUser',
  /** 권한관리 팝업 — 쓰기/읽기 권한 목록. 패키지의 WRITE/READ 프로시저를 각각 사용한다. */
  POPUP_AUTH_WRITE = 'popupAuthWrite',
  POPUP_AUTH_READ = 'popupAuthRead',
  /** 권한관리 팝업 — 권한 요청(승인/반려 대상) 리스트 */
  POPUP_AUTH_REQ = 'popupAuthReq',
}

// 커서명 'data' (PROC_M 실등재 — SDM1010 RESPONSE_SET 용법 동일. period 는 o_rc1/o_rc2)
// 서버 응답 result 안의 데이터 키(응답). 요청명(SHEETS)과 다를 수 있다.
export enum RESPONSE_SET {
  DATA = 'data',
  PROJECT = 'projectList',
  POPUP_ORG = 'orgList',
  POPUP_USER = 'userList',
  POPUP_AUTH_WRITE = 'authWriteList',
  POPUP_AUTH_READ = 'authReadList',
  POPUP_AUTH_REQ = 'authRequestList',
}

// 커스텀/링크 버튼 BTN_CD (계약 ② — hasButton 게이트 축. SEARCH/EXCEL/FILTER/SORT 는 공통 버튼)
export const BTN = {
  REQ: 'REQ', // 등록요청 — PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG (행별 단건 — '^' join 금지)
  AUTHREQ: 'AUTHREQ', // 권한요청 링크 — PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH
} as const;

// 나의 권한 도메인 (lookup SPMS_DPJT_AUTH_TYPE + GET 커서 파생 'NONE' — REQUEST 상태 치환 포함)
export const AUTH_TYPE = {
  ADMIN: 'ADMIN', // 권한관리 링크 행 (P-02)
  WRITE: 'WRITE',
  READ: 'READ',
  NONE: 'NONE',
} as const;

// ⭐ 권한요청 체크박스 서버 3상태 문자열 (P-04 — GET 커서 DPJT_AUTH_REQ_WRITE/_READ 단일 원천.
//   FE 하드코딩 파생 금지: DISABLED=편집 잠금(ADMIN·WRITE CONFIRM) / CHECKED=요청 진행 중 / UNCHECKED=선택 가능)
export { CHECK_STATE as REQ_CHECK } from '../../lib/grid';

// 조회조건 lookup 타입 (SCM0001_GET_LOOKUP_VALUES 도메인 — SDM1010 Form 소비 패턴 동일)
export const LOOKUP = {
  AUTH_TYPE: 'SPMS_DPJT_AUTH_TYPE',
  REG_STATUS: 'SPMS_DPJT_REG_STATUS',
} as const;

// ⭐ MSG 매핑 — 계약 ③ 확정 (재사용 8 + 신규 MSG01002~01006. 팝업 내부 MSG 는 모달(SDM1010) 소유)
export const MSG = {
  DIVISION_REQUIRED: 'MSG00097', // Division 필수 (P-09)
  DATE_INVERTED: 'MSG00108', // 등록 완료일 필수·역전 (P-10)
  NO_CHANGES: 'MSG00004', // 수정된 내용 없음 (P-06 — 근사 재사용 확정)
  NO_CHECKED: 'MSG00709', // 선택 항목 없음 (P-07)
  REQ_CONFIRM: 'MSG00709', // 등록/변경 confirm (P-08)
  REQ_DONE: 'MSG00712', // 등록요청 성공 (toast)
  REQ_FAIL: 'MSG00711', // 등록요청 실패
  PENDING_SEARCH_CONFIRM: 'MSG00703', // 수정 pending 중 재조회 confirm (UC-02)
  AUTHREQ_EMPTY: 'MSG01002', // 권한요청 항목 없음 (P-11)
  AUTHREQ_CONFIRM: 'MSG01003', // 권한요청 confirm (P-12)
  AUTHREQ_CANCEL_CONFIRM: 'MSG01004', // 권한요청 취소 confirm (P-12 취소 경로 — D12)
  AUTHREQ_DONE: 'MSG01005', // 권한요청 성공 (toast)
  AUTHREQ_FAIL: 'MSG01006', // 권한요청 실패
} as const;

// TAG 렌더 메타 ATTRIBUTE1 값 (SDM1010 관례 — CT 'S'+ATTRIBUTE1 'TAG')
export const TAG_ATTR = 'TAG' as const;

// FPModal 셀 메타 ATTRIBUTE1 → 모달 배선 (계약 ④ DPJT_AUTH_MGMT — 하드코딩 바인딩 금지)
export const MODAL_ATTR = {
  AUTH_REG: 'ProjectAuthRegModal',
} as const;

// FE 파생 권한요청 링크 컬럼 ATTRIBUTE1 (계약 ④ DPJT_AUTH_REQ_LINK — 커서 미반환·D1 개명)
export const REQ_ACTION_ATTR = 'REQ_ACTION' as const;

// SP 가 링크 봉인 행에 내려주는 표시값 (P-02/P-03 — '-' = 비노출. ADMIN 행은 ''(NULL) = 노출)
export const LINK_SEALED = '-' as const;
// ⭐ D2 커서명 불일치 보정 오버라이드 — TAG 3요소(값/NAME/COLOR)의 커서 실컬럼 매핑.
//   DPJT_AUTH_REQ_STATUS 의 NAME/COLOR 는 커서 실명 `DPJT_AUTH_REQ_WRITE_NAME`/`_WRITE_COLOR_TYPE`
//   (정오표 D2 — 메타를 커서명으로 정합한 계약 ④와 동일 축). 미등재 바인딩은 관례 함수로 폴백.
export const TAG_SOURCE: Record<string, { name: string; color: string }> = {
  DPJT_REG_STATUS: { name: 'DPJT_REG_STATUS_NAME', color: 'DPJT_REG_STATUS_COLOR_TYPE' },
  DPJT_AUTH_REQ_STATUS: {
    name: 'DPJT_AUTH_REQ_WRITE_NAME',
    color: 'DPJT_AUTH_REQ_WRITE_COLOR_TYPE',
  },
};

// ⭐ 행 CELL_TYPE 종속 셀 콤보 (CF-11 — Cell Type 변경 시 Stack Method clear + dataMap 스왑.
//   토큰 @divisionId/@cellType — 빈값 NVL 가드 전체 반환, 'ALL' 센티널 아님: 따옴표 빈 문자열 전달)
export const CELLTYPE_SCOPED_COMBO = 'StackMethodByCellType' as const;
export const CELL_TYPE_BINDING = 'CELL_TYPE' as const;
export const STACK_METHOD_BINDING = 'STACK_METHOD' as const;

// 권한요청 체크박스 바인딩 쌍 (P-05 상호배타 — 하나 CHECKED 시 반대쪽 UNCHECKED)
export const REQ_CHECK_BINDINGS = {
  WRITE: 'DPJT_AUTH_REQ_WRITE',
  READ: 'DPJT_AUTH_REQ_READ',
} as const;
