// SDM1010 화면의 이름표 — 다른 모든 파일이 여기서 import 한다.
// (참고: GUIDE_신규화면_개발_SalesSite.md Step 2)

// 화면 고유 ID. BE API 경로(/admin/menu/SDM1010/column)와 procedures.d.ts 의
// RawProcedureMap 키의 기준이 된다.
export const MENU_ID = 'SDM1010' as const;
export type MENU_ID = typeof MENU_ID;

// 서버로 보낼 sheet 이름(요청). 화면설계서의 프로시저명과 1:1 대응:
//   PROJECT(설계서 TAB1) → P_SDM1010_GET/SAVE_TAB1_PJT_REG,
//   MY_PROJECT(설계서 TAB2) → P_SDM1010_GET_TAB2_PJT_LIST,
//   POPUP_* → 권한관리/My Work 팝업 시트의 P_SDM1010_GET/SAVE_POP_* 프로시저.
export enum SHEETS {
  /** 화면설계서 TAB1 — 프로젝트 등록(편집 가능한 프로젝트 마스터 그리드) */
  PROJECT = 'project',
  /** 화면설계서 TAB2 — 나의 프로젝트 현황(조회 전용, 내가 권한 가진 프로젝트 목록) */
  MY_PROJECT = 'myProject',
  /** 권한관리 팝업 — 조직도(부서 트리) */
  POPUP_ORG = 'popupOrg',
  /** 권한관리 팝업 — 선택한 조직 노드에 속한 사용자 목록 */
  POPUP_USER = 'popupUser',
  /** 권한관리 팝업 — 쓰기/읽기 권한 목록. 패키지의 WRITE/READ 프로시저를 각각 사용한다. */
  POPUP_AUTH_WRITE = 'popupAuthWrite',
  POPUP_AUTH_READ = 'popupAuthRead',
  /** 권한관리 팝업 — 권한 요청(승인/반려 대상) 리스트 */
  POPUP_AUTH_REQ = 'popupAuthReq',
  /** My Work 팝업 — 샘플 일정 상세 (상세 내역은 화면설계서상 "추가 정의 필요") */
  POPUP_MY_WORK = 'popupMyWork',
}

// 서버 응답 result 안의 데이터 키(응답). 요청명(SHEETS)과 다를 수 있다.
export enum RESPONSE_SET {
  PROJECT = 'projectList',
  MY_PROJECT = 'myProjectList',
  POPUP_ORG = 'orgList',
  POPUP_USER = 'userList',
  POPUP_AUTH_WRITE = 'authWriteList',
  POPUP_AUTH_READ = 'authReadList',
  POPUP_AUTH_REQ = 'authRequestList',
  POPUP_MY_WORK = 'scheduleList',
}

// 탭 인덱스 — PROJECT(설계서 TAB1, 프로젝트 등록) / MY_PROJECT(설계서 TAB2, 나의 프로젝트 현황).
// 상단 그리드 row 더블클릭으로 하단 탭을 여는 sales-site 의 master-detail 구조와 달리,
// 이 화면은 두 탭이 서로 독립된 조회조건 결과/그리드를 갖는 "동급(peer) 탭" 구조다
// (화면설계서 레이아웃 시트 — 두 탭 모두 자체 SP 를 갖고, 조회조건(SearchArea)만 공유).
export enum SHEET_INDEX {
  PROJECT,
  MY_PROJECT,
}
