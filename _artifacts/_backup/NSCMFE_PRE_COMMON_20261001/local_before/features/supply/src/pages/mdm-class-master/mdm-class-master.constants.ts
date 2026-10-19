export const MENU_ID = 'SCP0087' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0087_MDMClassMaster (단일 FpSpread "MDM Class Master"):
//   설계 근거: .atlas/gscm-design/SCP0087/design/00_checklist.md ~ 03_grid-columns.md + 07.
//   - GET SP : SCP.SCP0087_GET_MDM_CLASS_MASTER (p_class_id/p_class_name/p_use_flag/debug_mode)
//   - SAVE SP: SCP0087_SAVE_MDM_CLASS_MASTER_ROW_DATASET (TVP @SCP0087, UPDATE-only 3컬럼)
//   - 조회조건: Class ID(like) / Class Name(like) / Use Flag(YesOrNo + FE addAll, default Y)
//   - 화면단위 편집모드: 조회직후 전열 read-only, Edit 눌러야 ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL 3컬럼 편집(design 01 §2)
//   - Insert 비활성 / Delete no-op (design 01 R13/R14)
export enum SHEETS {
  MAIN = 'main', // 단일 sheet — SP 라우팅 키(SHT_NM). procedures.d.ts SCP0087.main 과 정합.
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   PROGRAM_ID='SCP0087' SHEET_NAME='MDM Class Master' 23행 등록 확인(실측). 라우팅 SHEETS value 와 분리.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'MDM Class Master',
};

// AS-IS 편집 컬럼(LockRange cs:172 — ITEM_TYPE~PROCESS_DETAIL 3컬럼). Edit 모드일 때만 편집.
//   그 외 20컬럼은 읽기전용(admin 메타 INPUT_TP_CD='S'). design 03 §3 R3 / 01 §2 R7.
export const EDITABLE_COLUMNS = ['ITEM_TYPE', 'PROCESS_GROUP', 'PROCESS_DETAIL'] as const;

// 라벨 i18n (design 02 §4.5 / §3.4 — SCM_ADM_MSG_M 실측 TO-BE 코드, AS-IS 번호 직이식 금지).
export const LBL = {
  CLASS_ID: 'LBL00017', // Class ID (KO/EN/CN 등재)
  CLASS_NAME: 'LBL00035', // Class Name (KO/EN/CN 등재)
  USE_FLAG: 'LBL01131', // Use Flag (KO/EN/CN 등재)
  SEARCH: 'LBL00664', // Search
} as const;

// AS-IS Validation/피드백 MSG (design 00 §4f / 01 V6·V7 / 03 §4.4):
//   AS-IS MSG00004(저장건수)/MSG00003(서버에러)는 AS-IS 번호 — TO-BE SCM_ADM_MSG_M 역조회로 재매핑(Hook #114).
//   TO-BE 실측: MSG00002="Saved successfully." / MSG00003="Failed to save." / MSG00004="No changes to save."
//   저장 성공/실패 토스트는 useProcMutation 기본 onSuccess/onError(MSG00002/MSG00003)가 처리 — 여기선 NO_CHANGE 만 화면 사용.
export const MSG = {
  NO_CHANGE: 'MSG00004', // No changes to save. (저장대상 0건 가드)
  SAVE_SUCCESS: 'MSG00002', // Saved successfully. (useProcMutation 기본 onSuccess — 참조용)
  SAVE_FAIL: 'MSG00003', // Failed to save. (useProcMutation 기본 onError — 참조용)
} as const;

// Use Flag 콤보 — TO-BE SCM_ADM_CMBO_SQL_M 'YesOrNo'(Y/N 2건, 등록확인). "ALL" 은 FE addAll 로 prepend(design 02 §2.3).
export const USE_FLAG_COMBO = 'YesOrNo';
export const USE_FLAG_ALL = 'ALL';
export const USE_FLAG_DEFAULT = 'Y'; // AS-IS cs:107 기본값

// 컬럼 메타 (fallback — admin SCM_MST_SHEET_COLUMNS 미조회 시). admin 등록본이 있으면 그걸 authoritative 로 사용.
//   _inputEditType: 'S'=읽기전용(감사/키/읽기컬럼) / 'O'=편집후보(Edit 모드 + isEditing 게이트에서 편집).
//   sClsLblNm: 2단 헤더 상단 그룹(Level 1~4). 단일컬럼은 sClsLblNm=header(세로 2행 span, columnMapping TWO_DEPTH).
export interface MainColumnMeta {
  key: string;
  header: string; // 하단(2행) COLUMN_LABEL_NAME
  sClsLblNm: string; // 상단(1행) SMALL_CLASS_LABEL_NAME
  width: number;
  align: 'L' | 'C' | 'R';
  fixed?: boolean;
  _ctrlType?: 'FPNumber' | 'FPDateTime';
  _inputEditType: 'S' | 'O';
}

// design 03 §1 사양표(DB 실측 23행) 그대로. VERSION/BASIC_NICKNAME_PACK 이식 제외(design 03 §1 주의, 07 §2 G1).
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'CLASS_ID', header: 'Class ID', sClsLblNm: 'Class ID', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'ITEM_TYPE', header: 'Item Type', sClsLblNm: 'Item Type', width: 150, align: 'L', _inputEditType: 'O' },
  { key: 'PROCESS_GROUP', header: 'Process Group', sClsLblNm: 'Process Group', width: 150, align: 'L', _inputEditType: 'O' },
  { key: 'PROCESS_DETAIL', header: 'Process Detail', sClsLblNm: 'Process Detail', width: 150, align: 'L', _inputEditType: 'O' },
  { key: 'CLASS_NAME', header: 'Class Name', sClsLblNm: 'Class Name', width: 200, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL', header: 'Level', sClsLblNm: 'Level', width: 50, align: 'C', fixed: true, _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'LEVEL_1_CODE', header: 'Code', sClsLblNm: 'Level 1', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_1_NAME', header: 'Name', sClsLblNm: 'Level 1', width: 150, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_1_ID', header: 'ID', sClsLblNm: 'Level 1', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_2_CODE', header: 'Code', sClsLblNm: 'Level 2', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_2_NAME', header: 'Name', sClsLblNm: 'Level 2', width: 150, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_2_ID', header: 'ID', sClsLblNm: 'Level 2', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_3_CODE', header: 'Code', sClsLblNm: 'Level 3', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_3_NAME', header: 'Name', sClsLblNm: 'Level 3', width: 150, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_3_ID', header: 'ID', sClsLblNm: 'Level 3', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_4_CODE', header: 'Code', sClsLblNm: 'Level 4', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_4_NAME', header: 'Name', sClsLblNm: 'Level 4', width: 150, align: 'L', _inputEditType: 'S' },
  { key: 'LEVEL_4_ID', header: 'ID', sClsLblNm: 'Level 4', width: 80, align: 'L', _inputEditType: 'S' },
  { key: 'USE_FLAG', header: 'Use Flag', sClsLblNm: 'Use Flag', width: 50, align: 'C', _inputEditType: 'S' },
  { key: 'INSERT_ID', header: 'Insert ID', sClsLblNm: 'Insert ID', width: 100, align: 'C', _inputEditType: 'S' },
  { key: 'INSERT_TIME', header: 'Insert Time', sClsLblNm: 'Insert Time', width: 120, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'UPDATE_ID', header: 'Update ID', sClsLblNm: 'Update ID', width: 100, align: 'C', _inputEditType: 'S' },
  { key: 'UPDATE_TIME', header: 'Update Time', sClsLblNm: 'Update Time', width: 120, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
];
