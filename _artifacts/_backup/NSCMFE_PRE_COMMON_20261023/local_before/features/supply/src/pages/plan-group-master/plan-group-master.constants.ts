export const MENU_ID = 'SCP0121' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  // 메인 편집 그리드 (GET/SAVE PLAN_GROUP_LINE). BE 프로시저 라우팅 키(BTN_MPG.SHT_NM).
  MAIN = 'main',
  // 조회조건 6커서 공급 — 공용 SP PKG_COM0000.P_SCP0121_GET_SEARCH_INFO (API_ID SCP0121_SEARCH_INFO_GET).
  SEARCH_INFO = 'searchInfo',
}

// 단일 cursor 표준. searchInfo 는 named cursor(PROC_M COL_NM) 라 RESPONSE_SET 미사용.
export const RESPONSE_SET = { MAIN: 'o_rc1' } as const;

// admin UI Category Setup 의 SHEET_NAME (AS-IS 원본명 그대로 — SHEETS value 와 별개).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Plan Group Master',
};

// 그리드 11컬럼(DB 메타 SCM_MST_SHEET_COLUMNS, PROGRAM_ID='SCP0121', sheet 'Plan Group Master').
export const COLUMNS = {
  DIVISION_ID: 'DIVISION_ID',
  PLANT_ID: 'PLANT_ID',
  FACTORY_ID: 'FACTORY_ID',
  FACTORY_NAME: 'FACTORY_NAME',
  LINE_ID: 'LINE_ID',
  LINE_NAME: 'LINE_NAME',
  OPERATION_ID: 'OPERATION_ID',
  OPMZ_PLAN_GR_ID: 'OPMZ_PLAN_GR_ID',
  OPMZ_PLAN_GR_ITEM_ID: 'OPMZ_PLAN_GR_ITEM_ID',
  PRE_PLAN_GR_ID: 'PRE_PLAN_GR_ID',
  PRE_PLAN_GR_ITEM_ID: 'PRE_PLAN_GR_ITEM_ID',
} as const;

// Insert 시 현재행에서 복사하는 키 컬럼(1~7). AS-IS SetValue(insCell, defaultData) + LockRange (03_grid §3-b W5).
export const INSERT_COPY_COLUMNS: readonly string[] = [
  COLUMNS.DIVISION_ID,
  COLUMNS.PLANT_ID,
  COLUMNS.FACTORY_ID,
  COLUMNS.FACTORY_NAME,
  COLUMNS.LINE_ID,
  COLUMNS.LINE_NAME,
  COLUMNS.OPERATION_ID,
];

// convert-react 가 canEdit 시 editable 로 보정하는 컬럼(메타는 전건 INPUT_TP_CD='S' — 03_grid §6-1 확인필요 해소).
export const EDITABLE_COLUMNS: readonly string[] = [
  COLUMNS.OPMZ_PLAN_GR_ID,
  COLUMNS.OPMZ_PLAN_GR_ITEM_ID,
];

// 전체선택 sentinel (SRCH-06). 체크리스트 미선택/전체 → 조회 파라미터 공백.
export const ALL = 'ALL' as const;

// Model(OPMZ_PLAN_GR_ITEM_ID) 공백 → All('-') 치환 (03_grid §3-d action 판정).
export const ALL_MODEL = '-' as const;

// 그리드 셀콤보 — OPMZ_PLAN_GR_ID (SCM_ADM_CMBO_SQL_M.SQL_ID='PlanGroup', CODE/NAME/DIVISION_ID).
export const PLAN_GROUP_COMBO_ID = 'PlanGroup' as const;

// 조회조건 Division 콤보 — Division_SCP (권한필터 EE 포함, 02 §2-A). Division_SCP_NoEE/MyDivision 오매핑 금지.
export const DIVISION_COMBO_ID = 'Division_SCP' as const;

// 저장 payload 구분자 — AS-IS SAVE SP 는 SCM_ARR_SPL_VAL(...,'^',...) 로 분리 (03_grid §3-d).
export const SAVE_DELIM = '^' as const;

// 주의: 코드는 TO-BE 번들 실문구로 역매핑했다(GAP-11). AS-IS MSG 번호 재사용 금지 —
//   TO-BE 번들은 같은 번호에 다른 문구를 담아, AS-IS 번호를 그대로 쓰면 저장성공에 "변경없음"이
//   뜨는 안티패턴이 된다(asis-tobe-msg-code-divergence). 각 코드의 EN/KO 실문구는 실측일 2026-10-13
//   기준 public/locales(= SCM_ADM_MSG_M 동기본) 대조값이다.
export const MSG = {
  // Division 권한 0건 → SearchArea disable + 경고 (01_layout R2, SetDivisionAuthCheck 등가).
  //   MSG00097 = "Please select Division." / "Division 을 선택하세요." (문구 일치 — 유지).
  REQUIRE_DIVISION: 'MSG00097',
  // 신규행 Plan Group 필수 (W9). MSG00013 = "Please enter the required fields." / "필수 입력란을 입력해 주세요."
  //   AS-IS MSG00001 은 TO-BE 에서 "Would you like to save it?" 라 재사용 금지.
  REQUIRE_PLAN_GROUP: 'MSG00013',
  // 동일 키 중복 (W10). MSG00060 = "Duplicate key exists." / "중복된 키가 존재합니다."
  //   AS-IS MSG00443 은 TO-BE 미등록(0행)이라 재사용 불가.
  DUPLICATE_KEY: 'MSG00060',
  // 저장 성공 N건 (W13). MSG00672 = "{0} data saved." / "{0}개의 데이터가 저장되었습니다." ({0}=저장 건수).
  //   AS-IS MSG00004 는 TO-BE 에서 "No changes to save." 라 재사용 시 성공 toast 에 "변경없음" 이 뜬다.
  SAVE_SUCCESS: 'MSG00672',
  // 변경 없음 toast. MSG00004 = "No changes to save." / "수정한 내용이 없습니다." (MSG-08 표준 변경없음 코드).
  //   비표준 키 'MSG_NO_CHANGE'(미등록) 제거.
  NO_CHANGE: 'MSG00004',
  // 저장 실패 alert (W14 = SP 반환 에러문자열). 서버 메시지 우선, 없으면 MSG00618 =
  //   "An error occurred while saving." / "저장 중 오류가 발생했습니다." (자매 shipment-working-day 규약).
  //   AS-IS MSG00005 는 TO-BE 에서 "Please save your changes first." 라 재사용 금지.
  SAVE_FAIL: 'MSG00618',
  // W11/W12 literal — AS-IS 번호 없는 화면 고유 메시지. TO-BE SCM_ADM_MSG_M 역조회 0행(2026-10-13 실측).
  //   MSG-05: 미등록 코드는 자체 채번·INSERT 금지 → 서버 담당자 등록 요청(SPEC.msg_ids 인벤토리, 04 기록).
  //   등록 전까지 '_' 접두 fallback(MSG-03) 유지 — EN 은 동작, KO/CN 은 등록 후 지역화된다.
  ALL_MODEL_MIX: '_SCP0121_ALL_MODEL_MIX',
  MULTI_PLAN_GROUP_ALL: '_SCP0121_MULTI_PLAN_GROUP_ALL',
} as const;

// 조회조건 라벨 (02 §4.5 — 전건 기존 LBL, 신규채번 0).
export const LABELS = {
  DIVISION: 'LBL00641',
  OPERATION: 'LBL00009',
  PLANT: 'LBL00030',
  BUILDING: 'LBL00008',
  LINE: 'LBL00010',
  PLAN_GROUP: 'LBL00002',
} as const;
