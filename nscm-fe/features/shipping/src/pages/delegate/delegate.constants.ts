export const MENU_ID = 'SSP0020' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0020_Delegate (2-sheet spdMain: Delegate / Delegated List):
//   설계 근거: .atlas/gscm-design/SSP0020/design/00_checklist.md ~ 03_grid-columns.md + 07_human-doc.
//   상세 매핑: __asis-mapping__.md.
//   - GET   SP : PKG_SSP0020.P_GET_DELEGATE   (2커서 o_rc1=Delegate / o_rc2=Delegated List)  [미배포]
//   - SAVE  SP : PKG_SSP0020.P_SAVE_DELEGATE  (division ^-split 후 division 별 INSERT VALID_YN='Y') [미배포]
//   - UNSET SP : PKG_SSP0020.P_SAVE_UNSET     (CHK 선택행 soft-delete VALID_YN='N', 동일키 ^-배칭)  [미배포]
//   - CHECK SP : PKG_SSP0020.P_USER_CHECK     (위임자 실존 검증 = AS-IS UP_FX_GetSSPUserUseInfoList) [미배포]
//   PKG_SSP0020 는 2026-09-22 실측 MISSING → 저장/해제/조회 런타임 실행체인은 convert-sp 후속.
//   FE 는 목표 PKG 이름으로 API/권한을 선배선(convert-core §2.3 예외, guide 2.8/2.9).
export enum SHEETS {
  DELEGATE = 'Delegate', // shtMain    <- GET o_rc1 ("내가 위임한 목록", 선택/해제 대상)
  DELEGATED = 'Delegated List', // shtMainList <- GET o_rc2 ("내가 위임받은 목록", view-only)
}

// GET 은 단일 호출로 2커서 반환 — o_rc1=Delegate, o_rc2=Delegated List (design 03 §4-2, 단일 'main' 표준 아님).
export const RESPONSE_SET = {
  DELEGATE: 'o_rc1',
  DELEGATED: 'o_rc2',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin SCM_MST_SHEET_COLUMNS SHEET_NAME (AS-IS SpdSheet 그대로, design 03 §0 — 16행 실측 배포됨).
//   SHEETS value 와 동일 문자열이나(우연) 별개 개념 — 컬럼 메타 조회/버튼 라우팅 스코프 키.
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.DELEGATE]: 'Delegate',
  [SHEETS.DELEGATED]: 'Delegated List',
};

// UI 선택 칼럼(그리드 CHK) — DataGrid useCheckbox(Selector) 가 rowHeader 체크박스 + 헤더 전체선택을
//   제공한다. AS-IS 는 CHK 가 시트 첫 칼럼(SpdMain_CellClick 헤더 토글=전행선택, design 03 §3 #14~17)
//   이나 TO-BE 는 선택 상태를 데이터가 아닌 그리드 상태(row.isSelected)로 분리한다(SSOT 오염 방지).
//   따라서 렌더 컬럼에서 CHK 메타는 제외한다(선택 UI 는 Selector 가 대체 — 이중 체크박스 방지).
export const CHK_COLUMN = 'CHK';

// TO-BE MSG 코드 — SCM_ADM_MSG_M 문구 역조회로 확정(Hook #114). AS-IS 번호를 그대로 쓰지 않는다.
//   실측(2026-09-22, ora.py SCM_ADM_MSG_M LANG_CD KO/EN):
//     MSG00672 = "{0}개의 데이터가 저장되었습니다." / "{0} data saved."      (건수 플레이스홀더 — 저장/해제 성공)
//     MSG00004 = "수정한 내용이 없습니다." / "No changes to save."           (변경 없음)  ※ AS-IS 는 성공용이나 TO-BE 문구는 다름 → 성공에 쓰지 않음
//     MSG00284 = "Grid 가 준비되지 않았습니다." / "The grid is not ready."   ※ AS-IS 는 '완료'용이나 TO-BE 문구 상이 → 사용하지 않음
//     MSG00003 = "저장에 실패하였습니다." / "Failed to save."
//     MSG00097 = "Division 을 선택하세요." / "Please select Division."       (무권한 R3 + division 미체크 MSG00299 등가)
//     MSG00105 = "중첩된 기간이 있습니다." / "There are overlapping periods." (중첩 기간)
//   아래 8종은 TO-BE SCM_ADM_MSG_M 에 미존재(2026-09-22 실측 0건) → AS-IS 코드를 key 로 두되
//     영문 defaultValue fallback 으로 노출한다(엉뚱한 기존 코드 재사용 금지). 정식 등록은 후속(Top11 #11).
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // 저장/해제 성공 (건수)
  NO_CHANGES: 'MSG00004', // 변경 없음
  SAVE_FAIL: 'MSG00003', // 저장 실패
  REQUIRE_DIVISION: 'MSG00097', // Division 무권한/미체크 (R3 + MSG00299 등가)
  OVERLAP_PERIOD: 'MSG00105', // 중첩 기간 (위임)
  DELEGATEE_REQUIRED: 'MSG00298', // 위임자명 공백 (TO-BE 미존재 — fallback)
  DELEGATEE_SELF: 'MSG00305', // 위임자==본인 (TO-BE 미존재 — fallback)
  PERIOD_REQUIRED: 'MSG00134', // 기간 공백 (TO-BE 미존재 — fallback)
  PERIOD_REVERSED: 'MSG00219', // From>To (TO-BE 미존재 — fallback)
  DELEGATEE_OTHER: 'MSG00296', // 수임자 타 위임 현황 (TO-BE 미존재 — fallback)
  OVERLAP_RECEIVED: 'MSG00297', // 중첩 기간 수임 현황 (TO-BE 미존재 — fallback)
  UNSET_NONE_SELECTED: 'MSG00300', // 해제 대상 미선택 (TO-BE 미존재 — fallback)
  // MSG00302/00301 은 AS-IS UserName_Search(cs:799-816)의 위임자 검색 프롬프트다 —
  //   302=다중검색 "검색창 여시겠습니까?"(cs:802) / 301=미검색 "검색창 여시겠습니까?"(cs:811).
  //   설계 00 §4f 가 저장/해제 confirm 으로 오독했으나 AS-IS BtnSave/BtnUnSet 은 확인 다이얼로그 없이
  //   직접 실행한다(cs:352/564) → 저장/해제 confirm 미사용, 검색 프롬프트 용도로 정정(gap-resolve iter-1).
  DELEGATEE_MULTI: 'MSG00302', // 위임자 다중검색 → 검색창 열기? (TO-BE 미존재 — fallback)
  DELEGATEE_NOTFOUND: 'MSG00301', // 위임자 미검색 → 검색창 열기? (TO-BE 미존재 — fallback)
} as const;

// 공통버튼/커스텀버튼 코드 — 05_register.sql 의 SCM_ADM_MNU_BTN_MPG_M 과 1:1.
export const BTN = {
  SEARCH: 'SEARCH',
  SAVE: 'SAVE',
  UNSET: 'UNSET',
  USER_CHECK: 'USER_CHECK',
} as const;

// 조회조건/입력/버튼 라벨 — 전건 SCM_ADM_MSG_M 문구 역조회로 확정(2026-09-22, Hook #114).
//   design 02 §4.5 확정 3건(Division/Period/Delegatee) + 버튼 라벨(Search/Save/UnSet) 실측.
export const LBL = {
  DIVISION: 'LBL00001', // Division
  PERIOD: 'LBL00013', // Period
  DELEGATEE: 'LBL01069', // Delegatee
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  SAVE: 'LBL00111', // Save
  UNSET: 'LBL01128', // UnSet
} as const;

// 조회조건 Division 콤보 (design 02 §2.1 — TO-BE Oracle 실측 SQL_ID, EE 포함·권한필터·ALL 없음).
//   이름 유사 MyDivision(EE 제외) 재사용 금지(convert-core §2.6 — EE 필터 유무로 후보집합 상이).
export const COMBO = {
  DIVISION: 'MyDivisionInEE_SCP',
} as const;

// constants ColumnMeta -> DataGrid staticColumns fallback (admin SCM_MST_SHEET_COLUMNS 미fetch 시).
//   실측: SSP0020 컬럼 메타 16행(Delegate 8 + Delegated List 8) 배포됨 → 통상 admin 본이 authoritative.
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _cell?: 'date' | 'datetime';
}

// Delegate (rs1) 표시 8칼럼 (CHK 는 Selector 가 대체하므로 렌더 제외 — CHK_COLUMN). design 03 §1-A.
//   폭·정렬은 DB메타(SCM_MST_SHEET_COLUMNS 16행)가 authoritative — 아래는 admin fetch 실패 시
//   fallback 이며 DB메타(design 03 §1) 실측값과 동일하게 맞춘다(파리티).
export const DELEGATE_COLUMNS: ColumnMeta[] = [
  { key: 'CHK', header: '', width: 25, align: 'C' },
  { key: 'DIVISION_ID', header: 'Div', width: 40, align: 'C' },
  { key: 'FROM_DATE', header: 'From', width: 80, align: 'C', _cell: 'date' },
  { key: 'TO_DATE', header: 'To', width: 80, align: 'C', _cell: 'date' },
  { key: 'DELEGATEE', header: 'Delegatee', width: 150, align: 'L' },
  { key: 'VALID', header: 'Valid', width: 60, align: 'C' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 150, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 150, align: 'L', _cell: 'datetime' },
];

// Delegated List (rs2) 표시 8칼럼 — 5번=DELEGATOR(위임원), CHK VISIBLE_FLAG=N(숨김·view-only). design 03 §1-B.
//   fallback 폭은 DB메타 실측(DELEGATOR 100·LAST_UPDATED_BY 100)과 동일하게 맞춘다.
export const DELEGATED_COLUMNS: ColumnMeta[] = [
  { key: 'CHK', header: '', width: 25, align: 'C', visible: false },
  { key: 'DIVISION_ID', header: 'Div', width: 40, align: 'C' },
  { key: 'FROM_DATE', header: 'From', width: 80, align: 'C', _cell: 'date' },
  { key: 'TO_DATE', header: 'To', width: 80, align: 'C', _cell: 'date' },
  { key: 'DELEGATOR', header: 'Delegator', width: 100, align: 'L' },
  { key: 'VALID', header: 'Valid', width: 60, align: 'C' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 100, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 150, align: 'L', _cell: 'datetime' },
];
