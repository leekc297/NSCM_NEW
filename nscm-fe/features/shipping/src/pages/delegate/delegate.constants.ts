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

// TO-BE MSG 코드 — **AS-IS 번호를 그대로 쓰지 않는다**(convert-core Hook #114 / memory
//   asis-msg-number-must-be-remapped-to-registered-tobe-code). AS-IS 번호는 TO-BE 에서
//   다른 문구를 점유하거나 비어 있어, 그대로 쓰면 화면에 영문 fallback 이 그대로 노출된다.
//
// 2026-10-15 전건 재실측으로 확정 — AS-IS `TB_FX_MessageInfo`(asis.py) 문구를 TO-BE
//   `SCM_ADM_MSG_M`(ora.py) 에서 **문구 1:1 역조회**해 찾은 TO-BE 코드다. 전건 KO/EN/CN 3언어
//   USE_YN='Y' 등록 확인. (이전 회차의 "9종 미등록" 판정은 번호로만 조회한 오진이었다.)
//
//   AS-IS → TO-BE        | 문구(KO)
//   MSG00097 → MSG00667  | 권한을 가진 Division이 없습니다.        ← 무권한(R3)
//   MSG00299 → MSG01302  | 선택된 Division ID가 없습니다.         ← Division 미체크
//   MSG00105 → MSG00700  | 중첩된 기간이 있습니다.
//   MSG00296 → MSG01299  | 수임자의 다른 위임 현황이 있습니다.
//   MSG00297 → MSG01300  | 중첩된 기간에 수임받은 현황이 있습니다.
//   MSG00298 → MSG01301  | Delegatee를 입력해 주세요.
//   MSG00300 → MSG01303  | 리스트에서 선택 후 설정해제 해주세요.
//   MSG00301 → MSG01304  | 사용자를 찾지 못했습니다. 검색창을 여시겠습니까?
//   MSG00302 → MSG01305  | 다중검색된 User입니다. 검색창을 여시겠습니까?
//   MSG00305 → MSG01308  | 위임자와 수임자가 동일 합니다.
//   MSG00134 → MSG01153  | 날짜 선택 후 입력하세요.
//   MSG00004 → MSG00672  | {0}개의 데이터가 저장되었습니다.        ← TO-BE MSG00004 는 "수정한 내용이 없습니다"
//   MSG00284 → MSG01288  | 실행중 에러가 발생했습니다.             ← TO-BE MSG00284 는 "Grid 가 준비되지 않았습니다"
//   MSG00219 → MSG01230  | 시작일자가 종료일자보다 늦을 수 없습니다. (AS-IS MSG00219 는 TO-BE 미등록 — 재매핑)
//
//   주의: **MSG00097 을 Division 미체크에 쓰면 안 된다.** TO-BE MSG00097 문구는
//   "Division 을 선택하세요"(= AS-IS MSG00299 의미)라서, 무권한 사용자에게 선택할 Division 이
//   아예 없는데 "선택하세요" 라고 안내하게 된다. 두 용도를 MSG00667/MSG01302 로 분리한다.
//   defaultValue 는 카탈로그 로드 실패용 폴백이며 위 실측 EN 문구와 동일하게 맞춘다.
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // {0}개의 데이터가 저장되었습니다 (저장/해제 성공, 건수) ← AS-IS MSG00004
  EXEC_ERROR: 'MSG01288', // 실행중 에러가 발생했습니다 (저장/해제 실패) ← AS-IS MSG00284
  NO_DIVISION_AUTH: 'MSG00667', // 권한을 가진 Division이 없습니다 (R3 무권한) ← AS-IS MSG00097
  REQUIRE_DIVISION: 'MSG01302', // 선택된 Division ID가 없습니다 (미체크) ← AS-IS MSG00299
  OVERLAP_PERIOD: 'MSG00700', // 중첩된 기간이 있습니다 ← AS-IS MSG00105
  DELEGATEE_REQUIRED: 'MSG01301', // Delegatee를 입력해 주세요 ← AS-IS MSG00298
  DELEGATEE_SELF: 'MSG01308', // 위임자와 수임자가 동일 합니다 ← AS-IS MSG00305
  PERIOD_REQUIRED: 'MSG01153', // 날짜 선택 후 입력하세요 ← AS-IS MSG00134
  PERIOD_REVERSED: 'MSG01230', // 시작일자가 종료일자보다 늦을 수 없습니다 ← AS-IS MSG00219(미등록) 재매핑
  DELEGATEE_OTHER: 'MSG01299', // 수임자의 다른 위임 현황이 있습니다 ← AS-IS MSG00296
  OVERLAP_RECEIVED: 'MSG01300', // 중첩된 기간에 수임받은 현황이 있습니다 ← AS-IS MSG00297
  UNSET_NONE_SELECTED: 'MSG01303', // 리스트에서 선택 후 설정해제 해주세요 ← AS-IS MSG00300
  // AS-IS UserName_Search(cs:799-816) 의 위임자 검색 프롬프트(Yes/No) — 저장/해제 confirm 이 아니다
  //   (AS-IS BtnSave/BtnUnSet 은 확인창 없이 직접 실행, cs:352/564 — gap-resolve iter-1 정정).
  DELEGATEE_MULTI: 'MSG01305', // 다중검색된 User입니다. 검색창을 여시겠습니까? ← AS-IS MSG00302
  DELEGATEE_NOTFOUND: 'MSG01304', // 사용자를 찾지 못했습니다. 검색창을 여시겠습니까? ← AS-IS MSG00301
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
