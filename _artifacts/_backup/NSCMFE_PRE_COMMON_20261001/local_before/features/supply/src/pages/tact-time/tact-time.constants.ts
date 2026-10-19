export const MENU_ID = 'SCP0020' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0020_TactTime (2 그리드 spdMain(Plant/Packer 2탭) + spdExcept):
//   설계 근거: .atlas/gscm-design/SCP0020/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP 4종 : SCP.SCP0020_GET_TACT_TIME(_OSP) / _EXCEPT(_OSP)
//   - SAVE SP 4종: SCP.SCP0020_SAVE_TACT_TIME(_OSP) / _EXCEPT(_OSP)
//   - 조회조건 cascade: cboDivision -> clbPlantSite(다중) -> clbLine(다중), 모드(Plant/Packer) 분기
//   - 그리드 편집잠금 white-list 32건 / 파생 Auto-Sync / Insert 기본값 (03 §3)
export enum SHEETS {
  PLANT = 'plant', // spdMain Plant 시트 (siMain index0, 33컬럼)
  PACKER = 'packer', // spdMain Packer 시트 (siMain index1, 18컬럼) — AS-IS 실사용 탭
  EXCEPT = 'except', // spdExcept 예외/기간 (siExcept, 27컬럼)
  ITEM_SEARCH = 'itemSearch', // btnItemId -> SCM0002 Item 검색 팝업
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  PLANT: 'o_rc1',
  PACKER: 'o_rc1',
  EXCEPT: 'o_rc1',
  ITEM_SEARCH: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   shtMain='Plant' / shtPacker='Packer' / shtExcept='Tact Time Except'. 라우팅 SHEETS value 와 분리.
//   확인 필요: 컬럼 메타 admin 등록 여부 미확정(census 존재하나 layout 속성/등록상태 미확인, design 03 §6).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.PLANT]: 'Plant',
  [SHEETS.PACKER]: 'Packer',
  [SHEETS.EXCEPT]: 'Tact Time Except',
};

// spdMain 탭 모드 — AS-IS siMain.ActiveSheet(Plant index0 / Packer index1).
//   조회조건 cascade 공급 경로가 이 모드로 갈린다(design 02 §3 결합 승격). 기본 = PACKER
//   (AS-IS 는 Plant 탭 숨김 Visible=false, Packer 기본 — design 01 D-3 / 03 §6-3 Plant 표시정책 확인 필요).
export enum TACT_MODE {
  PLANT = 'PLANT',
  PACKER = 'PACKER',
}

// division 특수 잠금 코드 (Plant 시트 편집분기, design 03 §3.2 #8/#9 — cs:573/577).
//   42/44 = ITEM_UOM~TACT_TIME 잠금 / 그 외 = DAILY_CAPACITY~UOM_CONVERT_VALUE 잠금.
export const LOCK_DIVISIONS = ['42', '44'] as const;
// 전극(Electrode) OPERATION_GROUP 코드 — LANE_QTY 편집/필수 + JUMBO_MIN 파생 트리거 (design 03).
export const OPERATION_GROUP_ELECTRODE = 'E';
// Packer 조회조건 plant site 원장 division 하드코딩 (AS-IS cs:202, design 02 §2.2 — 의미 확인 필요).
export const PACKER_PLANT_DIVISIONS = '40,81,82';

// TACT_TIME clamp/기본값 (design 03 §3.3 checkMaxValue — cs:1124-1248).
export const MIN_TACT_TIME = 0.01;
export const DEFAULT_TACT_TIME_MAX = 30000;
export const MAX_TACT_TIME_FALLBACK = 50000;

// 컬럼 메타 (룰 12 §11.7). _ctrlType/_inputEditType/_comboKey — GSCM CellType 이관 수용처.
//   편집가능 여부의 최종 판정은 정적 _inputEditType 이 아니라 utils/tactTimeEditLock 의 white-list(행 데이터 기반).
//   여기 _inputEditType 는 baseline: 'S'=항상 잠금(감사/키) / 'O'=편집후보(white-list 가 세부 판정).
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _ctrlType?:
    | 'FPText'
    | 'FPModal'
    | 'FPComboBox'
    | 'FPCheckBox'
    | 'FPDate'
    | 'FPDateTime'
    | 'FPNumber'
    | 'FPNumberText';
  _inputEditType?: 'S' | 'O';
  _comboKey?: string;
}

// ===== §1.1 Plant 시트 (census 33컬럼, design 03 §1.1) =====
export const PLANT_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_ID', header: 'Plant Site', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_NAME', header: 'Plant Site Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  // OPERATION_GROUP_ID = 숨김열(행별) — ='E' 전극 분기 트리거 (design 03 §1.1 #4)
  { key: 'OPERATION_GROUP_ID', header: 'Op Group', width: 80, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OPERATION_ID', header: 'Operation', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OPERATION_NAME', header: 'Operation Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'MODEL_SITE', header: 'Model Site', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 110, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  // LINE_ID combo (design 03 §1.1 #10) — INPUT_STATUS='M' 잠금
  { key: 'LINE_ID', header: 'Line', width: 90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'LineByOperation' },
  { key: 'PRIORITY', header: 'Priority', width: 70, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'TACT_TIME', header: 'Tact Time', width: 90, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'YIELD', header: 'Yield', width: 70, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'VALID_YN', header: 'Valid', width: 60, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'ITEM_UOM', header: 'UOM', width: 70, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'UOM_CONVERT_VALUE', header: 'UOM Convert', width: 90, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'LANE_QTY', header: 'Lane Qty', width: 80, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'JUMBO_MIN', header: 'Jumbo Min', width: 90, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'DAILY_CAPACITY', header: 'Daily Capacity', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'INPUT_STATUS', header: 'Input Status', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'EXCEPT_YN', header: 'Except', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ACTUAL_CAPACITY', header: 'Actual Capacity', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'ACTUAL_OUTPUT', header: 'Actual Output', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'FROM_ACTUAL_CAPACITY', header: 'From Actual Cap.', width: 110, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'TO_ACTUAL_CAPACITY', header: 'To Actual Cap.', width: 110, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'EFFECTIVE_DATA_COUNT', header: 'Eff. Data Count', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'BIG_TACT_TIME', header: 'Big Tact Time', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'BIG_LAST_UPDATE_DATE', header: 'Big Last Update', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'BOM_MIN_DUE_DATE', header: 'BOM Min Due', width: 110, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Updated By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
];

// ===== §1.2 Packer 시트 (census 18컬럼, design 03 §1.2) =====
export const PACKER_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'SITE_DESCRIPTION', header: 'Site', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_ID', header: 'Plant Site', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 110, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OPERATION_ID', header: 'Operation', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  // LINE_ID combo (design 03 §1.2 #7) — INPUT_STATUS='I' 편집 / 'M' 잠금
  { key: 'LINE_ID', header: 'Line', width: 90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'LineByOperationOsp' },
  { key: 'PRIORITY', header: 'Priority', width: 70, align: 'R', _ctrlType: 'FPNumberText', _inputEditType: 'O' },
  { key: 'TACT_TIME', header: 'Tact Time', width: 90, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'YIELD', header: 'Yield', width: 70, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'S' },
  { key: 'DAILY_CAPACITY', header: 'Daily Capacity', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'INPUT_STATUS', header: 'Input Status', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'EXCEPT_YN', header: 'Except', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OSP_YN', header: 'OSP', width: 55, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Updated By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
];

// ===== §1.3 Tact Time Except 시트 (census 27컬럼, design 03 §1.3) =====
//   ORG_* 7컬럼 = 예외 저장 수정 전 복합키 (숨김, row 원본 스냅샷 보존 — design 03 §4.3)
export const EXCEPT_COLUMNS: MainColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div', width: 60, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_ID', header: 'Plant Site', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'PLANT_SITE_NAME', header: 'Plant Site Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 110, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OPERATION_ID', header: 'Operation', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'OPERATION_NAME', header: 'Operation Name', width: 120, align: 'L', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LINE_ID', header: 'Line', width: 90, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'S', _comboKey: 'LineByOperation' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'C', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'TACT_TIME', header: 'Tact Time', width: 90, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'YIELD', header: 'Yield', width: 70, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'DAILY_CAPACITY', header: 'Daily Capacity', width: 100, align: 'R', _ctrlType: 'FPNumber', _inputEditType: 'O' },
  { key: 'TACT_TIME_START_DATE', header: 'Start Date', width: 100, align: 'C', _ctrlType: 'FPDate', _inputEditType: 'O' },
  { key: 'TACT_TIME_END_DATE', header: 'End Date', width: 100, align: 'C', _ctrlType: 'FPDate', _inputEditType: 'O' },
  { key: 'EXCEPT_COMMENT', header: 'Comment', width: 150, align: 'L', _ctrlType: 'FPText', _inputEditType: 'O' },
  { key: 'USE_YN', header: 'Use', width: 55, align: 'C', _ctrlType: 'FPComboBox', _inputEditType: 'O', _comboKey: 'YesOrNo' },
  { key: 'INPUT_STATUS', header: 'Input Status', width: 80, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Updated By', width: 90, align: 'C', _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Update Date', width: 130, align: 'C', _ctrlType: 'FPDateTime', _inputEditType: 'S' },
  { key: 'ORG_DIVISION_ID', header: 'Org Div', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_PLANT_SITE_ID', header: 'Org Plant', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_ITEM_ID', header: 'Org Item', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_OPERATION_ID', header: 'Org Op', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_LINE_ID', header: 'Org Line', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_TACT_TIME_START_DATE', header: 'Org Start', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
  { key: 'ORG_TACT_TIME_END_DATE', header: 'Org End', width: 60, align: 'C', visible: false, _ctrlType: 'FPText', _inputEditType: 'S' },
];

// Except 저장 수정 전 복합키 컬럼 (row 원본 스냅샷 보존 — design 03 §4.3)
export const EXCEPT_ORG_KEYS = [
  'ORG_DIVISION_ID',
  'ORG_PLANT_SITE_ID',
  'ORG_ITEM_ID',
  'ORG_OPERATION_ID',
  'ORG_LINE_ID',
  'ORG_TACT_TIME_START_DATE',
  'ORG_TACT_TIME_END_DATE',
] as const;

// ====================================================================================
// 조회조건 콤보 ID
// ====================================================================================
// design 02 §5.2 전환 계약. SCM_ADM_CMBO_SQL_M 실측(2026-09-25 ora.py): 콤보 본문은 등록되어 있으며
//   (예: LineByOperationOsp -> SCM_MST_LINE_OSP CODE/NAME/DIVISION_ID/SCM_SITE_ID), SQL_NM 은 AS-IS
//   @Code 를 담은 설명 문자열이라 FE comboId 와 1:1 문자열 일치가 아니다(comboId->본문 매핑은 BE 소관).
//   잘못된 comboId 는 조용히 0행(nscm-patterns §3.3)이라 화면은 깨지지 않는다.
export const COMBO = {
  // AS-IS SCP0020 Division 바인딩 = BLUtils.GetDivisionESS(false,"") = ESS 사업부만(ATTRIBUTE3='82').
  //   Division_SCP = UP_FX_GetCommonDataList_SCP @Code='Division'(FN_GET_DIVISION, ATTRIBUTE3 반환).
  //   ESS-only 는 화면에서 ATTRIBUTE3='82' 로 재현(combo-semantic-parity-no-name-reuse, TactTimeForm).
  DIVISION: 'Division_SCP',
  PLANT_SITE_PLANT: 'PlantSiteByDivision_SCP', // Plant 모드 (AS-IS _SCP proc — 도메인 suffix, cascade-combo-filter §0-N)
  PLANT_SITE_PACKER: 'PlantByDivisionOperOsp3_SCP', // Packer 모드 (AS-IS UP_FX_GetCommonDataList_SCP @Code='PlantByDivisionOperOsp3') — 파라미터 divisionId=40,81,82 / operationGroup=P / param3=Y
  LINE_PLANT: 'LineByOperation', // Plant 모드 (AS-IS 공통 proc — 무접미 유지, 그리드 셀콤보 공유)
  LINE_PACKER: 'LineByPlantPacker_SCP', // Packer 모드 (_SCP)
  VALID: 'YesOrNo', // 공통 Y/N (census cmbo_sql 배포 확인)
} as const;
// cboOperationGroup — lookup code (design 02 §2.4)
export const OPERATION_GROUP_LOOKUP = 'OPERATION_GROUP';

// AS-IS Validation MSG ID 매핑 (design 00 §2b, 고유 15종):
//   MSG00002 [{}] 필수 / MSG00004 저장확인 / MSG00006 성공 / MSG00043 결과경고 /
//   MSG00048 날짜범위 / MSG00049 날짜형식 / MSG00072 상한 / MSG00085 하한 /
//   MSG00105 중첩기간 / MSG00108 시작<종료 / MSG00109 읽기전용 / MSG00161 Insert /
//   MSG00193 필수(>0) / MSG00199 작업중데이터 / MSG00203 Max clamp
// MSG 코드 = TO-BE SCM_ADM_MSG_M 실측 역매핑 (2026-09-10). AS-IS MSG 번호와 TO-BE 번호 체계가 달라 재매핑함.
//   'TO-BE 미등록' 표기 = 등가 메시지가 SCM_ADM_MSG_M 에 없어 영문 defaultValue 로 표시됨(추후 등록 필요, 엉뚱한 한글 매핑 회피).
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} 값은 필수 입력 항목입니다.
  CONFIRM_SAVE: 'MSG00617', // {0} 행을 저장하시겠습니까?
  SAVE_SUCCESS: 'MSG00002', // 성공적으로 저장되었습니다.
  SAVE_RESULT: 'MSG00043', // 저장시 중복 오류가 발생하였습니다. {0}
  DATE_RANGE: 'MSG00048', // SCM_ADM_MSG_M 등록 확인(2026-09-25 ora.py 실측 KO/EN/CN) — 영문 defaultValue 는 미조회 대비 fallback
  DATE_FORMAT: 'MSG00611', // 유효한 날짜 형식이 아닙니다. (YYYYMMDD)
  RANGE_MAX: 'MSG01036', // {0} 이하의 값만 입력 가능합니다. (SCM_ADM_MSG_M 등록 2026-09-15 KO/EN/CN — AS-IS 이하 규칙, YIELD 상한 100)
  RANGE_MIN: 'MSG00085', // {0} 이상의 값만 입력 가능합니다.
  PERIOD_OVERLAP: 'MSG00105', // SCM_ADM_MSG_M 등록 확인(2026-09-25 ora.py 실측 KO/EN/CN) — 영문 defaultValue 는 미조회 대비 fallback
  START_END_ORDER: 'MSG00108', // 조회 기간이 잘못되었습니다 (시작일 > 종료일).
  READ_ONLY: 'MSG00109', // 읽기전용 상태입니다.
  INSERT_GUIDE: 'MSG00662', // 조회 후 수정 모드로 가능합니다. (SCM_ADM_MSG_M 실측 2026-09-14 KO/EN/CN 등록 — 신규행 추가 사전조건 안내)
  REQUIRED_POSITIVE: 'MSG01035', // {0} 초과의 값만 입력 가능합니다. (SCM_ADM_MSG_M 등록 2026-09-15 KO/EN/CN — AS-IS 초과 규칙 {0}=0, PRIORITY/TACT_TIME>0. 구 MSG00225 "0 이상/수량" 은 초과 의미 불일치라 교체)
  WORKING_DATA_EXIST: 'MSG00137', // 이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.
  TACT_MAX_CLAMP: 'MSG00203', // SCM_ADM_MSG_M 미등록 확인(2026-09-25 ora.py 실측 0행) — 영문 fallback. 등록 필요.
} as const;

// YIELD 범위 (design 03 §4.3 — MSG00085 하한 / MSG00072 상한)
export const YIELD_MIN = 1;
export const YIELD_MAX = 100;
// Except 날짜 하한 (design 03 §4.3 — MSG00048 >=17530101)
export const EXCEPT_DATE_MIN = '17530101';
