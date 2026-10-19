export const MENU_ID = 'DMF0043' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * 이 화면의 메뉴 등록 ID (SCM_ADM_MNU_M DMF0043_01 = MNU00031 'Contribution Sales', ROUTE demand/demand-master/contribute-view).
 *
 * 위 MENU_ID('DMF0043')는 호출 배선용이다 — 조회·팝업 프로시저(API_M P_DMF0043_SALES_LIST_GET 등)와 버튼 권한이
 * 부모 메뉴 DMF0043 의 salesList / salesListTitle 시트에 등록돼 있어 그대로 둔다. DMF0043_01 에도 BTN 메타가 있지만
 * 시트명이 다르다(main / mainTitle) — 호출 메뉴를 바꾸면 시트명·procedures.d.ts 까지 함께 옮겨야 한다.
 *
 * 2026-10-08 통합테스트 지적: 상단 경로가 MENU_ID 로 그려져 "Demand > Demand Master > Contribution Rate Reg."(DMF0043 의
 * 이름)가 보였다. 제목·경로·즐겨찾기(MainTitle)만 이 ID 를 쓴다.
 */
export const TITLE_MENU_ID = 'DMF0043_01' as const;

export enum SHEETS {
  MAIN = 'salesList',
  MAIN_TITLE = 'salesListTitle',
  VERSION = 'version',
  RATE_POPUP = 'ratePopup',
  VERSION_POPUP = 'versionPopup',
  TITLE_SET = 'titleSet', // AS-IS DM0002_TitleSetForm_Popup — DMF0002_GET_TITLESET_POPUP
}

// ⭐ 컬럼 개인화(SCM_MST_TITLESET_USER) 조회/저장 키.
//   ⚠️ 팝업 조회(ColumnLayoutModal) · 저장(saveTitleSet) · 진입 복원(fetchUserColumnLayout) 이
//     **셋 다 같은 값**을 써야 한다. 하나라도 다르면 저장은 성공하는데 재진입 조회가 그 행을 못 찾아
//     개인화가 사라진다 (forecast-price 2026-07-27 / sales-monitoring 2026-07-04 동일 사고).
export const TITLESET_SHEET = 'ContributeSalesList';
export const TITLESET_COLUMN_TYPE = 'C';
// AS-IS InitSpread (.cs L146) — 이 화면은 division 고정 '40'.
export const TITLESET_DIVISION = '40';

// const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용)
// 2026-06-19 분리 PR — `DMF0043_GET_CONTRIBUTION_SALES_LIST` SP body 의 OUT cursor
// `p_cursor_main` → `O_RC1` 표준화 (PROC_M 메타 + SP body 동반 변경).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  MAIN_TITLE: 'o_rc1',
  VERSION: 'o_rc1',
  RATE_POPUP: 'o_rc1',
  VERSION_POPUP: 'o_rc1',
  TITLE_SET: 'o_cursor', // P_DMF0002_GET_TITLESET_POPUP 의 OUT cursor
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// AS-IS DMF0043_Contribute_View.cs 의 Validation MSG codes (.cs L287, L335)
export const VALIDATION_MSG = {
  VERSION_REQUIRED: 'MSG00283', // FindData — Version 미선택 (.cs L287)
  NO_RESULT: 'MSG00307', // FindData — 조회 결과 없음 (.cs L335)
} as const;

// AS-IS .cs L234: siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG))
// 사용자 요구 (2026-06-01): 년월(YYYYMM)부터 Biz(DM_BIZ_TYPE)까지 고정 = 9 컬럼
// SP DMF0043_GET_SALES_LIST_SPREAD_TITLE 결과의 첫 9개 (SHEET_COLUMNS DEFAULT_FLAG='Y' DISTINCT 9개)
// ⚠️ 2026-08-11 — 실제 좌측 고정은 이 상수가 아니라 admin SHEET_COLUMNS 의 Fixed 플래그가 정한다
//   (공용 DataGrid wrapper 의 findLastIndex(_fixed)+1). 이 값은 BASE 컬럼 갯수 참고용.
export const BASE_COLUMN_COUNT = 9;
