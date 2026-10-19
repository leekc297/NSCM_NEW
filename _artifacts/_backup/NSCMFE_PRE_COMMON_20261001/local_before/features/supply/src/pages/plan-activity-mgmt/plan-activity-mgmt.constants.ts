export const MENU_ID = 'SCP0122' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0122_PlanActivityMgmt (단일 그리드 CRUD 마스터):
//   설계 근거: .atlas/gscm-design/SCP0122/design/00_checklist.md ~ 03_grid-columns.md
//   - GET  SP : SCP.SCP0122_GET_PLAN_ACTIVITY_MGMT (15컬럼 반환)
//   - SAVE SP : SCP.SCP0122_SAVE_PLAN_ACTIVITY_MGMT (캐럿(^)접기 7파라미터, I/M/D 물리삭제)
//   - 조회조건 콤보 3 : Division_SCP / PlanGroup_SCP_ALL(필터형 cascade) / LookupCommon(OPMZ_PRS_CD)
//   - 그리드 셀콤보 1 : OPMZ_ACTV_NAME(ActivityCode) + Auto-Sync 파생 6 (design 03 §3-R3)
//   - 편집가능 실컬럼 2 : OPMZ_ACTV_SEQ / OPMZ_ACTV_NAME (컬럼 메타 INPUT_TP_CD 재현, 상수이식 금지)
//   - Edit 버튼 미이식 (asis_to_tobe §11 전 화면 공통 결정) — hotkeyConfig 에 edit 키 미배치
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (GET 15컬럼 반환)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin SCM_MST_SHEET_COLUMNS SHEET_NAME (AS-IS 원본명 그대로, DB 실측). 컬럼 메타 조회 sheetNm.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Plan Activity Mgmt',
};

// 조회조건 콤보 ID (convert-core §2.6 의미 패리티 — 이름 유사 재사용 금지, DB 실측 확정 design 02 §2).
//   Division  = Division_SCP      (권한필터, EE 포함 — MyDivision 재사용 금지)
//   PlanGroup = PlanGroup_SCP_ALL (全件 + FE division 필터 + NAME 정렬)
//   Process   = LookupCommon      (@lookupType='OPMZ_PRS_CD', 정적)
export const COMBO = {
  DIVISION: 'Division_SCP',
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
  PROCESS: 'LookupCommon',
} as const;
export const PROCESS_LOOKUP_TYPE = 'OPMZ_PRS_CD';

// 그리드 셀콤보(OPMZ_ACTV_NAME) — SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE 실측값.
//   콤보 본문 = ActivityCode_SCP_ALL 와 동일(lookup OPMZ_ACTV_CD, 7컬럼 반환) — 05_register.sql 등록.
export const ACTIVITY_CODE_COMBO = 'ActivityCode';

// Auto-Sync 파생 컬럼 (OPMZ_ACTV_NAME 콤보 선택 시 콤보행 값 복사 — design 03 §3-R3).
export const ACTIVITY_SYNC_COLUMNS = [
  'LINK_UI_TYPE',
  'PROGRAM_NAME',
  'CONFIRM_YN',
  'AUTO_YN',
  'OPTION_YN',
] as const;

// 신규행(Insert) 기본값 컬럼 (검색조건 콤보 값/텍스트 복사 — design 03 §3-R6, convert-core §2.4).
export const OPMZ_ACTV_NAME = 'OPMZ_ACTV_NAME';
export const OPMZ_ACTV_CD = 'OPMZ_ACTV_CD';

// 다국어 LABEL (SCM_ADM_MSG_M 실측 — design 02 §4.5, 전부 존재 / 신규 0).
export const LBL = {
  DIVISION: 'LBL00641',
  PLAN_GROUP: 'LBL00002',
  PROCESS: 'LBL00059',
} as const;

// MSG 코드 = TO-BE SCM_ADM_MSG_M 실측 역매핑 (hook #114 — AS-IS 번호 그대로 쓰지 않는다).
//   NO_AUTH_DIVISION : AS-IS MSG00097("권한 Division 없음")은 TO-BE MSG00097("Please select Division.")
//                      와 의미가 달라 문구 역조회로 MSG00667(KO "권한을 가진 Division이 없습니다") 사용.
//   NO_CHANGE        : TO-BE MSG00004 = "No changes to save." (의미 일치).
//   SAVE_SUCCESS     : MSG00002 = "Saved successfully."
//   DUPLICATE        : AS-IS MSG00443 은 TO-BE 미등록 → 의미 등가 MSG00428("신규 입력 데이터 중 중복").
export const MSG = {
  NO_AUTH_DIVISION: 'MSG00667',
  NO_CHANGE: 'MSG00004',
  SAVE_SUCCESS: 'MSG00002',
  DUPLICATE: 'MSG00428',
} as const;
