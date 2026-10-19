/**
 * AS-IS SCP0121_OwnerPopup — 부모 화면 SCP0121_PlanGroupMaster 의 Owner(담당자) 선택 팝업.
 * 좌(후보 Owner Base) / 우(선택 Owner User) 두 그리드 셔틀(transfer) 모달, 두 그리드 읽기전용, 콤보 0.
 *
 * 데이터 SP 는 이 팝업 전용 PKG_SCP0121.P_SCP0121_GET_OWNER_DATA_POPUP 이므로 MENU_ID 는 SCP0121.
 * 공통 OwnerModal(COM0004)과 재사용하지 않는다 — COM0004 SP 는 (a) division 권한필터가 제거돼
 * 전 사용자를 반환하고 (b) 검색 3번째 컬럼이 DEPT_NAME_KO 가 아니라 USER_NAME_EN 이며 (c) UserName 이
 * 이름+직급 결합이 아니고 (d) Base/User 서버분리(p_owner_id)가 없어, 그대로 쓰면 후보 범위가 조용히
 * 달라진다(convert-core §2.6 콤보/SP 의미 패리티). 상세: design/02_search-combo.md §2.3.
 */
export const OWNER_POPUP_MENU_ID = 'SCP0121' as const;
export type OWNER_POPUP_MENU_ID = typeof OWNER_POPUP_MENU_ID;

/**
 * 단일 SP 호출로 2 커서(o_rc1=Base 후보 / o_rc2=User 기선택)를 받는다 — procedures.d.ts SCP0121.ownerPopup.
 * 데이터 SP 미배포(convert-sp 후속) 상태이며 런타임 조회는 배포 후 붙는다.
 */
export enum OWNER_POPUP_SHEETS {
  OWNER = 'ownerPopup',
}

/**
 * 그리드 컬럼 메타는 이 팝업이 아니라 공통 타이틀셋 PROGRAM_ID='DMF000' 의 시트에 등록돼 있다
 * (SCM_MST_SHEET_COLUMNS, 각 시트 6컬럼 — design/03_grid-columns.md §1-A 실측). 두 그리드 동일 메타.
 * 하드코딩 금지(ui-category-setup) — ownerSelectModalStore.fetchStaticColumns 가 admin 메타로 fetch.
 */
export const OWNER_COLUMN_PROGRAM_ID = 'DMF000';
export const OWNER_COLUMN_SHEET_NAME = 'Owner Base';

// DB 검증된 라벨 코드(SCM_ADM_MSG_M MSG_TP_CD='LBL'). 값=LBL 코드.
export const LBL = {
  USER_ID_NAME: 'LBL00339',
  SEARCH: 'LBL00112',
  // 모달/팝업 SearchArea 전용 Search 라벨 — 메인 상단 SearchArea(SEARCH=LBL00112)와 코드가 다르다.
  SEARCH_POPUP: 'LBL00664',
  OK: 'LBL00716',
  CANCEL: 'LBL00107',
} as const;
