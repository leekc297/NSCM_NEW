export const MENU_ID = 'SCP0105' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0105_CAPA_Speed_Plan (CAPA Speed Plan, 메뉴 Title "Speed Plan"):
//   설계 근거: .atlas/gscm-design/SCP0105/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   한 스프레드(spdMain) 안에 ASSEMBLY/ELTR 2시트가 있고 DivisionType 라디오가 시트를 전환한다(03 §0).
//   - GET  SP : PKG_SCP0105.P_SCP0105_GET_CAPA_SPEED_PLAN_{CURRENT|1ST_CUTOFF}_{ASSEMBLY|ELTR} (4변형)
//   - SAVE SP : PKG_SCP0105.P_SCP0105_SAVE_CAPA_SPEED_PLAN_{ASSEMBLY|ELTR} (2변형, ^/; 직렬화)
//   - TITLE SP: PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE (SCP0104/0105/0106/0107/0108 공용 TVF)
//   - 행 추가 : 없음. AS-IS InsertButton() 본문이 빈 구현이다(cs:1463~1465, 03 R-15)
//   - SP 미배포(goal.md 2): PKG_SCP0105 all_objects 0건 -> 조회/저장 런타임 미완(convert-sp 후속)
export enum SHEETS {
  ASSEMBLY = 'ASSEMBLY', // spdMain Sheets[0] — DivisionType Cell / Module·Pack (cs:1302)
  ELTR = 'ELTR', // spdMain Sheets[1] — DivisionType Electrode (cs:1303)
  SPREAD_TITLE = 'spreadTitle', // 동적 기간 헤더 전용(그리드 아님) — 03 §2.5 TO-BE 매핑
}

/** 데이터 그리드가 되는 시트 — SPREAD_TITLE 은 헤더 메타 전용이라 제외한다. */
export type GridSheet = SHEETS.ASSEMBLY | SHEETS.ELTR;

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  ASSEMBLY: 'o_rc1',
  ELTR: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE) SHEET_NAME.
//   AS-IS `_division_type_name` 이 그대로 p_sheet_name 으로 가고 DB SHEET_NAME 과 대소문자까지 같다(03 §0).
export const ADMIN_SHEET_NAME: Record<GridSheet, string> = {
  [SHEETS.ASSEMBLY]: 'ASSEMBLY',
  [SHEETS.ELTR]: 'ELTR',
};

// ====================================================================================
// DivisionType (조회조건 라디오) — AS-IS ScpCapa.DivisionType(ScpCapa.cs:20~25)
// ====================================================================================
//   AS-IS 는 SelectedIndex(0/1/2) 정수를 쓰지만 TO-BE 는 의미를 잃지 않게 문자열 enum 으로 둔다.
export const DIVISION_TYPE = {
  ELTR: 'ELTR', // SelectedIndex 0
  CELL: 'CELL', // SelectedIndex 1
  MODULE_PACK: 'MODULE_PACK', // SelectedIndex 2
} as const;
export type DivisionType = (typeof DIVISION_TYPE)[keyof typeof DIVISION_TYPE];

/**
 * 초기 선택값 = Cell.
 *
 * AS-IS Designer 는 `SelectedIndex` 를 세팅하지 않아 DevExpress 기본값 `-1`(무선택)로 시작한다.
 * 그 상태는 `_sheet_idx=1`(ELTR) 인데 `_shop_group='P'`(Module/Pack) 라는 비정합이라(02 §4.2),
 * 사용자 확정(2026-09-23, goal.md §5-6 BLK-4)으로 정합 상태인 `Cell` 을 채택했다 — 재판단 금지.
 */
export const DEFAULT_DIVISION_TYPE: DivisionType = DIVISION_TYPE.CELL;

/** AS-IS ScpCapa.GetShopGroupId(CAPA:111~135) — 마스터 슬라이스의 SHOP_GROUP_ID 필터축. */
export const SHOP_GROUP_ID: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: 'E',
  [DIVISION_TYPE.CELL]: 'A',
  [DIVISION_TYPE.MODULE_PACK]: 'P',
};

/** AS-IS `_sheet_idx`(cs:1283~1296) — DivisionType 이 곧 시트다. 탭이 아니라 스위치(03 R-01). */
export const SHEET_BY_DIVISION_TYPE: Record<DivisionType, GridSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.ASSEMBLY,
};

// ====================================================================================
// 조회조건 콤보 SQL_ID (design 02 §2 — ora.py 실측 2026-09-23)
// ====================================================================================
//   SCP 접미어 규약(convert-core §2.6): Data_SCP.Common -> `X_SCP` / CommonAll -> `X_SCP_ALL`.
//   이름이 비슷한 범용 콤보(`Division`/`DivisionByUser`/`DummyCapaLineMaster_SCP_ALL`) 재사용 금지 —
//   후보 집합이 조용히 달라진다(convert-core §2.6 의미 패리티).
export const COMBO = {
  DIVISION: 'Division_SCP', // 권한필터 O. cboDivision (02 §2.1)
  CAPA_VERSION: 'CapaVersion_SCP_ALL', // 결과셋 1건에서 4파생 (02 §2.2)
  PROGRESS_STATUS: 'CapaProgressStatus_SCP_ALL', // lookup SCP/CAPA_PROG_STAT (02 §2.3)
  LINE_MASTER_ASSEMBLY: 'CapaLineMaster_SCP_ALL', // Cell/Module·Pack 마스터 (02 §2.4)
  LINE_MASTER_ELTR: 'CapaLineMasterEE_SCP_ALL', // Electrode 마스터 (02 §2.4)
  OPERATION_ELECTRODE_TYPE: 'OperationElectrodeType_SCP_ALL', // ELTR Line Type + 셀 콤보 (02 §2.5)
} as const;

/** AS-IS BLUtils.GetDivisionWithoutEE(BLUtils.cs:107~116) — 이관 CMBO WHERE 에 없어 FE 재현(02 §2.1). */
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

/** AS-IS `dtOperationAll` 후처리 `CODE <> 'AFFFF'` — Formation 더미 Operation 제외(02 §2.4). */
export const FORMATION_OPERATION_ID = 'AFFFF';

/** AS-IS GetElectrodeOperationFilter 의 ELTR 분기 대체값(ScpCapaBL.cs:634~652, 02 §2.5). */
export const ELTR_DEFAULT_OPERATION_ID = 'E2000';

/** AS-IS GetSortedCode(BL:81~136) — `DMY_` 접두 항목을 목록 맨 뒤로 후치(02 §3.3). */
export const DUMMY_CODE_PREFIX = 'DMY_';

/** 마스터 슬라이스의 `CODE <> '-'` 제외값(02 §3.3 GetFilterSite/Plant/Factory/Line). */
export const EMPTY_CODE = '-';

/**
 * 다중선택 체크리스트의 "무선택 = 전체" sentinel.
 * 공용 `CustomDropdown multiple allOption` 이 전체선택/전체해제에서 이 값을 돌려준다.
 * AS-IS `UsrCheckedList.ControlValues` 의 `"ALL"` 과 같은 자리다(02 §3.4).
 */
export const ALL_SENTINEL = 'ALL';

/** 후보 목록이 0건일 때 서버로 보내는 값 — 결과셋이 비도록 강제한다(AS-IS CString:554~581, 02 §3.4). */
export const NONE_SENTINEL = 'NONE';

// ====================================================================================
// 진행상태(PROG_STAT) — lookup SCP/CAPA_PROG_STAT 실측 4코드 (02 §2.3)
// ====================================================================================
//   표시문구는 lookup 이 원천이라 하드코딩하지 않는다. 여기 상수는 "판정에 쓰는 코드" 뿐이다.
export const PROGRESS_STATUS = {
  PRE: '-',
  CURRENT: '0',
  FIRST_CUTOFF: '1',
  SECOND_CUTOFF: '2',
} as const;

/**
 * Edit 진입이 차단되는 진행상태 — Current('0') 인 버전만 편집 가능(01 L-11, cs:1789~1794).
 * 판정 기준은 Status 콤보 선택값이 아니라 **그 버전의 현재 진행상태**(`PROG_STAT`)다.
 */
export const READ_ONLY_PROGRESS_STATUS: readonly string[] = [
  PROGRESS_STATUS.PRE,
  PROGRESS_STATUS.FIRST_CUTOFF,
  PROGRESS_STATUS.SECOND_CUTOFF,
];

/** AS-IS `_sheet_status`(cs:552~573) — GET SP 변형 선택자. '2' 는 Status 목록에서 제외돼 도달 불가. */
export const SHEET_STATUS: Record<string, string> = {
  [PROGRESS_STATUS.PRE]: 'CURRENT',
  [PROGRESS_STATUS.CURRENT]: 'CURRENT',
  [PROGRESS_STATUS.FIRST_CUTOFF]: '1ST_CUTOFF',
  [PROGRESS_STATUS.SECOND_CUTOFF]: '',
};

/** Plan Type 파생값 — `BIZ_PLAN_USE_YN='Y'` 면 BP, 아니면 RP(기본). AS-IS ScpCapaBL:654~691. */
export const PLAN_TYPE = { BIZ: 'BP', ROLLING: 'RP' } as const;

// ====================================================================================
// 그리드 컬럼 키 (design 03 §1 — DB 메타 63행의 COLUMN_NAME)
// ====================================================================================
//   컬럼 "목록"은 admin 메타가 원천이다. 여기 상수는 **코드가 의미를 읽는 컬럼**만 이름으로 고정한다
//   (lock 판정·산식 입력·저장 payload). 컬럼 배열을 코드로 복제하지 않는다(hook #130).
export const COLUMN = {
  IDX: 'IDX',
  VER_ID: 'VER_ID',
  VER_SEQ: 'VER_SEQ',
  DIVISION_ID: 'DIVISION_ID',
  COMPANY_ID: 'COMPANY_ID',
  SITE_ID: 'SITE_ID',
  PLANT_ID: 'PLANT_ID',
  FACTORY_ID: 'FACTORY_ID',
  LINE_ID: 'LINE_ID',
  OPERATION_ID: 'OPERATION_ID',
  ELTR_LN_TP_CD: 'ELTR_LN_TP_CD',
  EQUIPMENT_ID: 'EQUIPMENT_ID',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  MSR_TP_CD: 'MSR_TP_CD',
  MEASURE_NAME: 'MEASURE_NAME',
  PFRSLT_QTY: 'PFRSLT_QTY',
  BASE_QTY: 'BASE_QTY',
  ELTR_QTY: 'ELTR_QTY',
  MMS_CF: 'MMS_CF',
  UI_UPD_YN: 'UI_UPD_YN',
  EDITABLE_YN: 'EDITABLE_YN',
  NICK_NAME_DUMMY_YN: 'NICK_NAME_DUMMY_YN',
  MEASURE_COLOR: 'MEASURE_COLOR',
} as const;

/** 동적 기간 컬럼 접두 — 월 `M_01yyyymm` / 연 `Y_yyyy` (03 §2.2). */
export const PERIOD_PREFIX = { MONTH: 'M_', YEAR: 'Y_' } as const;

/**
 * 기간 컬럼의 짝 컬럼 접미 — 이 값이 0/공백이면 그 기간 셀은 잠긴다(03 §2.6).
 * 화면에는 안 보이지만 행 데이터에는 반드시 실려 있어야 한다. 빼면 편집 판정이 통째로 무너진다.
 */
export const ASSIGN_PRIORITY_SUFFIX = '_ASSIGN_PRIORITY';

/** 좌측 고정(frozen) 경계 — AS-IS `_fixed_column_name = DefColumns.IDX`(cs:175~185). */
export const FIXED_COLUMN = COLUMN.IDX;

// ====================================================================================
// Measure (SCM_MST_SHEET_MEASURE 7행 — design 03 §1.4)
// ====================================================================================
export const MEASURE = {
  EQP_NBU: 'EQP_NBU',
  MMS: 'MMS',
  PPM_AVG: 'PPM_AVG',
  TTT: 'TTT',
  CPM: 'CPM',
  PPM: 'PPM',
  EQP_SPED: 'EQP_SPED',
} as const;

/**
 * Measure 행 배경색 대상 — AS-IS Set_MeasureColor(cs:2111~2145)는 ASSEMBLY 시트에서만 실행되고
 * `MEASURE_NAME` 열부터 마지막 열까지 칠한다. ELTR 은 `_sheet_idx==0` 가드로 미실행.
 */
export const MEASURE_COLOR_TARGETS: readonly string[] = [
  MEASURE.MMS,
  MEASURE.PPM_AVG,
  MEASURE.TTT,
  MEASURE.CPM,
];

// Measure 행 배경색 값 `220,220,220` 자체는 `components/CapaSpeedPlanGrid.module.scss` 의
//   `.measureRow` 가 갖는다(inline style 금지 — convert-core §2.1 #5). 메타 `MEASURE_COLOR` 는
//   `192,192,192` 이지만 AS-IS 코드가 그 값을 쓰지 않고 220 으로 덮어쓰므로 런타임 표시색은 220 이다
//   (03 R-12·C-04). 사용자 확정(2026-09-23, goal.md §5-6 BLK-7): 코드값 채택, 메타는 고치지 않는다.

/**
 * 숫자 소수자릿수 — 메타 `DATA_SCALE_NUMBER` 가 63행 전건 NULL 이라 메타로 풀 수 없다(03 §1 공통).
 * AS-IS 는 코드 Dictionary 로 measure 별 자릿수를 준다(cs:1707~1742).
 * 주의: `PPM_AVG` 는 AS-IS dict 에 없다 — 없는 것이 AS-IS 동작이라 넣지 않는다.
 */
export const ASSEMBLY_SCALE_EDIT: Record<string, number> = {
  [MEASURE.EQP_NBU]: 10,
  [MEASURE.MMS]: 10,
  [MEASURE.TTT]: 10,
  [MEASURE.CPM]: 10,
  [MEASURE.PPM]: 10,
};
export const ASSEMBLY_SCALE_VIEW: Record<string, number> = {
  [MEASURE.EQP_NBU]: 1,
  [MEASURE.MMS]: 0,
  [MEASURE.TTT]: 1,
  [MEASURE.CPM]: 1,
  [MEASURE.PPM]: 1,
};

/**
 * ELTR 숫자포맷은 AS-IS 가 키를 `EQP_QTY` 로 넣는데(cs:1756·1764) 실제 measure 는 `EQP_SPED` 라
 * 매칭 0건 = 사실상 미적용이다(03 C-06). 현행 동작 재현이라 ELTR 자릿수 맵을 두지 않는다.
 * `EQP_SPED` 로 고칠지는 사용자 결정 — 04 리포트 백로그.
 */

// ====================================================================================
// 3단 헤더 (design 03 §2.4 / hook #93)
// ====================================================================================
export const HEADER_DEPTH = 3;
export const HEADER_ROW_HEIGHT = 16; // 3단 x 16 = 총높이 48px

// ====================================================================================
// 저장 직렬화 (design 03 §4.3 — AS-IS SetQueryInfoSave cs:2295~2325)
// ====================================================================================
export const SAVE_ROW_DELIMITER = '^';
export const SAVE_PERIOD_DELIMITER = ';';

// ====================================================================================
// i18n — SCM_ADM_MSG_M 문구 역조회 실측 2026-09-23 (ora.py, hook #114)
// ====================================================================================
//   AS-IS 번호를 그대로 쓰지 않는다. 특히:
//   - AS-IS MSG00097(권한 Division 없음) -> TO-BE 는 **MSG00667**. TO-BE MSG00097 은
//     "Please select Division." 로 전혀 다른 메시지다(메모리 msg00097-tobe-select-division-not-permission).
//   - AS-IS MSG00004(저장 {0}건) -> TO-BE 는 **MSG00672** "{0} data saved.".
//     TO-BE MSG00004 는 "No changes to save." 라 번호를 그대로 쓰면 뜻이 뒤집힌다.
//   - AS-IS MSG00426(동일 라인 다중 설비유형) -> TO-BE 에 **등가 0건**(실측). 서버 메시지를 그대로
//     표면화하고 문구가 비면 MSG00006 으로 떨어진다 — 04 리포트 확인필요(채번 대기).
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (AS-IS MSG00097, 01 L-04)
  READ_ONLY: 'MSG00109', // "Read-only mode." (AS-IS MSG00109 동일 의미, 01 L-11)
  NO_PERMISSION: 'MSG00096', // "No permission." (AS-IS MSG00096 동일 의미, 01 L-12)
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (AS-IS MSG00004)
  SAVE_FAIL: 'MSG00006', // "Failed to save." (AS-IS MSG00006 동일 의미)
  NO_CHANGES: 'MSG00133', // "No modifications have been made." (AS-IS MSG00133 동일 의미)
} as const;

/** 저장 실패 응답 중 "동일 라인에 다른 설비유형" 을 뜻하는 DB 오류번호(03 §3.2 #3, C-08). */
export const DB_ERR_DIFFERENT_EQUIPMENT_TYPE = '50426';

// ====================================================================================
// 컬럼 개인화 (ColumnLayoutModal) — 03 §3.3
// ====================================================================================
//   AS-IS btnColumn -> SCM002_CAPAColumnPopup("SCP0105", _division_type_name, true) (cs:3166~3175).
//   sheetName 을 같이 넘겨야 ASSEMBLY/ELTR 설정이 섞이지 않는다.
export const TITLESET_COLUMN_TYPE = 'C';
