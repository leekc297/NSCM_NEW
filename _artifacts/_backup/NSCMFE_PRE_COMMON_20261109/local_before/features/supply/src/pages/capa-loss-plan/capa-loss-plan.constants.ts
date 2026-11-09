export const MENU_ID = 'SCP0106' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0106_CAPA_Loss_Plan (CAPA Loss Plan, 메뉴 Title "Loss Plan"):
//   설계 근거: .atlas/gscm-design/SCP0106/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   확정 결정: .atlas/gscm-design/SCP0106/convert-flow/decisions.md (goal.md 보다 우선)
//   한 스프레드(spdMain) 안에 8시트가 있고 `{_sheet_status}_{_division_type_name}` 로 결정된다(03 §0).
//   - GET  SP : PKG_SCP0106.P_SCP0106_GET_CAPA_LOSS_PLAN_{8시트} (8변형, 동적 QueryId)
//   - SAVE SP : PKG_SCP0106.P_SCP0106_SAVE_CAPA_LOSS_PLAN_{MODEL|LINE}_{ASSEMBLY|ELTR} (4변형)
//   - TITLE SP: PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE (SCP0104/0105/0106/0107/0108 공용 TVF)
//   - 행 추가 : 없음. AS-IS InsertButton() 본문이 빈 구현이다(03 R-26). 버튼은 노출한다(decisions §A BLK-4)
//   - SP 미배포(goal.md ②): PKG_SCP0106 all_objects 0건 -> 조회/저장 런타임 미완(convert-sp 후속)
//
//   자매 SCP0105(capa-speed-plan)와 골격은 같지만 **규칙이 11군데 다르다**(02 §0). 복사 사고 방지를 위해
//   차이 지점마다 주석에 "SCP0105 와 다름" 을 남겼다.

// ====================================================================================
// 시트 (design 03 §0 — `_sheet_name = "{_sheet_status}_{_division_type_name}"`)
// ====================================================================================
//   TS enum 멤버명은 숫자로 시작할 수 없어 키만 FIRST_/SECOND_ 로 쓴다.
//   **값은 DB `SHEET_NAME` 과 대소문자까지 정확 일치해야 한다**(03 V-01) — 키를 값으로 쓰지 말 것.
export enum SHEETS {
  CURRENT_ASSEMBLY = 'CURRENT_ASSEMBLY',
  CUTOFF_MODEL_ASSEMBLY = 'CUTOFF_MODEL_ASSEMBLY',
  FIRST_CUTOFF_LINE_ASSEMBLY = '1ST_CUTOFF_LINE_ASSEMBLY',
  SECOND_CUTOFF_LINE_ASSEMBLY = '2ND_CUTOFF_LINE_ASSEMBLY',
  CURRENT_ELTR = 'CURRENT_ELTR',
  CUTOFF_MODEL_ELTR = 'CUTOFF_MODEL_ELTR',
  FIRST_CUTOFF_LINE_ELTR = '1ST_CUTOFF_LINE_ELTR',
  SECOND_CUTOFF_LINE_ELTR = '2ND_CUTOFF_LINE_ELTR',
  SPREAD_TITLE = 'spreadTitle', // 동적 기간 헤더 전용(그리드 아님) — 03 §2.1
}

/** 데이터 그리드가 되는 시트 8종 — SPREAD_TITLE 은 헤더 메타 전용이라 제외한다. */
export type GridSheet = Exclude<SHEETS, SHEETS.SPREAD_TITLE>;

// 결과셋 커서 키 상수는 두지 않는다. 이 화면은 **상태별로 결과셋 개수가 2~4개 가변**이고
//   (00 §5 영역3, hook #80 — CURRENT/PRE 3 · CUTOFF_MODEL 2 · LINE 3~4), 커서 **이름**은
//   `PKG_SCP0106` 배포 후 `all_arguments` 실측으로 `convert-sp` 가 확정한다(현재 미배포).
//   그래서 `CapaLossPlan.tsx` 가 이름이 아니라 **응답 객체의 배열 값을 순서로** 집는다.
//   배포 전에 `o_rc1..o_rc4` 를 상수로 박아두면 확정 시 어긋난 이름이 코드에 남는다.

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE) SHEET_NAME.
//   AS-IS `_sheet_name` 이 그대로 p_sheet_name 으로 가고 DB SHEET_NAME 과 대소문자까지 같다(03 §0).
export const ADMIN_SHEET_NAME: Record<GridSheet, string> = {
  [SHEETS.CURRENT_ASSEMBLY]: 'CURRENT_ASSEMBLY',
  [SHEETS.CUTOFF_MODEL_ASSEMBLY]: 'CUTOFF_MODEL_ASSEMBLY',
  [SHEETS.FIRST_CUTOFF_LINE_ASSEMBLY]: '1ST_CUTOFF_LINE_ASSEMBLY',
  [SHEETS.SECOND_CUTOFF_LINE_ASSEMBLY]: '2ND_CUTOFF_LINE_ASSEMBLY',
  [SHEETS.CURRENT_ELTR]: 'CURRENT_ELTR',
  [SHEETS.CUTOFF_MODEL_ELTR]: 'CUTOFF_MODEL_ELTR',
  [SHEETS.FIRST_CUTOFF_LINE_ELTR]: '1ST_CUTOFF_LINE_ELTR',
  [SHEETS.SECOND_CUTOFF_LINE_ELTR]: '2ND_CUTOFF_LINE_ELTR',
};

/**
 * `_sheet_status` 4값 — GET SP 변형 선택자이자 동적 헤더 SP 의 `p_sheet_name` 이다.
 * 주의: 헤더 SP 는 이 **4값**을 쓰고 컬럼설정 팝업은 `_sheet_name` **8값**을 쓴다.
 * 축이 다른 것을 그대로 재현한다(03 §3.3, V-12).
 */
export const SHEET_STATUS = {
  CURRENT: 'CURRENT',
  CUTOFF_MODEL: 'CUTOFF_MODEL',
  FIRST_CUTOFF_LINE: '1ST_CUTOFF_LINE',
  SECOND_CUTOFF_LINE: '2ND_CUTOFF_LINE',
} as const;
export type SheetStatus = (typeof SHEET_STATUS)[keyof typeof SHEET_STATUS];

/** `_division_type_name` 2값 — 시트명 접미사(03 §0 `GetDivisionTypeName`). */
export const DIVISION_TYPE_NAME = { ASSEMBLY: 'ASSEMBLY', ELTR: 'ELTR' } as const;
export type DivisionTypeName = (typeof DIVISION_TYPE_NAME)[keyof typeof DIVISION_TYPE_NAME];

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
 * AS-IS Designer 는 `SelectedIndex` 를 세팅하지 않아 `-1`(무선택)로 시작하고, 그 상태는
 * `GetDivisionTypeName(-1)='ELTR'` 인데 `GetShopGroupId(-1)='P'` 라는 비정합이다(01 L-32).
 * **AS-IS 실행화면 캡처 실측**(`human-doc/asis-screenshot.png` — 라디오가 `⦿ Cell`)으로
 * `Cell` 을 확정했다(decisions.md §B-1). 재판단 금지.
 */
export const DEFAULT_DIVISION_TYPE: DivisionType = DIVISION_TYPE.CELL;

/** AS-IS ScpCapa.GetShopGroupId(CAPA:111~135) — 마스터 슬라이스의 SHOP_GROUP_ID 필터축. */
export const SHOP_GROUP_ID: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: 'E',
  [DIVISION_TYPE.CELL]: 'A',
  [DIVISION_TYPE.MODULE_PACK]: 'P',
};

/** AS-IS `GetDivisionTypeName`(CAPA:89~109) — Cell·Module/Pack 이 같은 ASSEMBLY 축이다. */
export const DIVISION_TYPE_NAME_BY_TYPE: Record<DivisionType, DivisionTypeName> = {
  [DIVISION_TYPE.ELTR]: DIVISION_TYPE_NAME.ELTR,
  [DIVISION_TYPE.CELL]: DIVISION_TYPE_NAME.ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: DIVISION_TYPE_NAME.ASSEMBLY,
};

// ====================================================================================
// SheetType (MODEL/LINE) — SCP0106 고유 조회조건. SCP0105 에는 없다(02 §0 #1)
// ====================================================================================
//   AS-IS 는 `cboSheetType.Items.Add("MODEL"/"LINE")` **코드 하드코딩**이고 TO-BE lookup/CMBO 에
//   대응 0건이다(02 §2.4). 값 자체(`MODEL`/`LINE`)는 `_sheet_status` 계산 키라 **변경 금지**.
//   hook #87 §L(콤보 하드코딩 금지)와 충돌하지만 lookup 신규 등록은 사용자 결정 대기라
//   화면 상수로 둔다 — 04 리포트 "확인필요"(02 §7 #2).
export const SHEET_TYPE = { MODEL: 'MODEL', LINE: 'LINE' } as const;
export type SheetType = (typeof SHEET_TYPE)[keyof typeof SHEET_TYPE];

/** AS-IS `cboSheetType.SelectedIndex = 0`(02 §2.4). */
export const DEFAULT_SHEET_TYPE: SheetType = SHEET_TYPE.MODEL;

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

// Edit 차단 진행상태를 배열 상수로 두지 않는다 — 이 화면은 `'-'`/`'2'` 무조건 차단 + `'1'` 은
//   화면 Status 와 SheetType 까지 봐야 하는 **조건부** 차단이라 단순 포함검사로 표현되지 않는다.
//   판정은 `utils/capaLossPlan.sheetKey.ts#judgeEditGate` 하나가 전담한다(01 L-12~L-15).
//   **SCP0105 와 다름**: SCP0105 는 `-`/`1`/`2` 전부 무조건 차단이라 배열 상수로 충분했다.

/** Plan Type 파생값 — `BIZ_PLAN_USE_YN='Y'` 면 BP, 아니면 RP(기본). AS-IS ScpCapaBL:654~691. */
export const PLAN_TYPE = { BIZ: 'BP', ROLLING: 'RP' } as const;

// ====================================================================================
// 조회조건 콤보 SQL_ID (design 02 §2 — ora.py 실측, goal.md ② 표에서 전건 등록 확인)
// ====================================================================================
//   SCP 접미어 규약(convert-core §2.6): Data_SCP.Common -> `X_SCP` / CommonAll -> `X_SCP_ALL`.
//   이름이 비슷한 범용 콤보(`Division`/`DivisionByUser`/`MyDivision`/`AllDivision_SCP`) 재사용 금지 —
//   후보 집합이 조용히 달라진다(convert-core §2.6 의미 패리티, SCP0006 실사고).
export const COMBO = {
  DIVISION: 'Division_SCP', // 권한필터 O. cboDivision (02 §2.1)
  CAPA_VERSION: 'CapaVersion_SCP_ALL', // 결과셋 1건에서 4파생 (02 §2.2)
  PROGRESS_STATUS: 'CapaProgressStatus_SCP_ALL', // lookup SCP/CAPA_PROG_STAT (02 §2.3)
  LINE_MASTER_ASSEMBLY: 'CapaLineMaster_SCP_ALL', // Cell/Module·Pack 마스터 (02 §2.5)
  LINE_MASTER_ELTR: 'CapaLineMasterEE_SCP_ALL', // Electrode 마스터 (02 §2.5)
  LOOKUP_COMMON: 'LookupCommon', // Operation 화이트리스트 (02 §2.6)
} as const;

/**
 * Operation 화이트리스트 lookup — `CELL && 컷오프 && LINE` 일 때만 호출(02 §2.6).
 * **SCP0105 에는 없는 SCP0106 고유 규칙**(02 §0 #5). 미구현 시 1차 컷오프 후 Line별
 * 비조업 조회에서 A3000 공정이 소실된다(2025-03-25 PJ20249548R 개선분).
 */
export const OPERATION_WHITELIST_LOOKUP_TYPE = 'CPS_LOSS_CELL_LINE_OPERATION';

/** `_division === '40'`(소형)이면 lookup `CODE='40'` 행들, 아니면 `CODE='DEFAULT'` 행(02 §2.6). */
export const SMALL_DIVISION_ID = '40';
export const OPERATION_WHITELIST_DEFAULT_CODE = 'DEFAULT';

/** AS-IS BLUtils.GetDivisionWithoutEE(BLUtils.cs:107~116) — 이관 CMBO WHERE 에 없어 FE 재현(02 §2.1). */
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

/**
 * Formation 더미 Operation.
 * **SCP0105 와 정반대다**(02 §0 #4): SCP0105 는 `dtOperationAll` 생성 시 전역 제외하지만
 * SCP0106 은 **제외하지 않는다** — CELL/MODULE_PACK 축에서 보여야 하고, ELTR 축에서만
 * `GetFilterOperation` 이 제외한다. SCP0105 코드를 그대로 베끼면 조회 후보가 조용히 좁아진다.
 */
export const FORMATION_OPERATION_ID = 'AFFFF';

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

/**
 * 후보 목록이 0건일 때 서버로 보내는 값 — 결과셋이 비도록 강제한다.
 * 주의: AS-IS `CString.GetCheckedListValueNone` **본문이 이 저장소 스냅샷에 없다**(02 §7 #7).
 * `"NONE"` 은 자매 SCP0105 가 채택한 값을 승계한 것이며 AS-IS 원문 확인은 미완이다
 * — 04 리포트 "확인필요(사용자 축)".
 */
export const NONE_SENTINEL = 'NONE';

// ====================================================================================
// 그리드 컬럼 키 (design 03 §1 — DB 메타 226행의 COLUMN_NAME)
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
  LINE_IDX: 'LINE_IDX',
  OPERATION_ID: 'OPERATION_ID',
  ELTR_LN_TP_CD: 'ELTR_LN_TP_CD',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  BASIC_NICK_NAME: 'BASIC_NICK_NAME',
  MEASURE_GROUP: 'MEASURE_GROUP',
  MEASURE: 'MEASURE',
  MEASURE_NAME: 'MEASURE_NAME',
  SITE_NAME: 'SITE_NAME',
  SPEED_PPM: 'SPEED_PPM',
  PFRSLT_QTY: 'PFRSLT_QTY',
  BASE_QTY: 'BASE_QTY',
  DAY_CNT: 'DAY_CNT',
  // `BASE_QTY` 편집 시에만 쓰는 짝 입력 — AS-IS 는 일수/PPM 을 이 두 컬럼으로 **갈아끼운다**
  //   (`AssemblyUtils.cs:184-190` DAY_CNT_BASE · `:211-216` SPEED_BASE_PPM · `EltrUtils.cs:441-459`).
  //   메타상 폭 0 숨김 컬럼이지만 행 데이터로는 내려온다.
  DAY_CNT_BASE: 'DAY_CNT_BASE',
  SPEED_BASE_PPM: 'SPEED_BASE_PPM',
  SCP_PRDN_PLAN_REF_ST_YM: 'SCP_PRDN_PLAN_REF_ST_YM',
  SCP_PRDN_PLAN_REF_END_YM: 'SCP_PRDN_PLAN_REF_END_YM',
} as const;

/** 동적 기간 컬럼 접두 — 월 `M_01yyyymm` / 연 `Y_yyyy` (03 §2.2). */
export const PERIOD_PREFIX = { MONTH: 'M_01', YEAR: 'Y_' } as const;

// `M_00`(개선율) 계열은 **TVF 가 0건 생성하는 전면 사문 블록**이라 이식하지 않는다(03 §2.2, C-09).
//   `chkShowRate` 가 토글하는 대상이 이것뿐이라 체크박스도 실효 무동작이다(R-02, V-19).
//   빠뜨린 게 아니라 의도적 미이식이다 — `__asis-mapping__.md §4` 에 근거를 남겼다.

/**
 * 기간 컬럼의 짝 컬럼 접미 — 이 값이 0/공백이면 그 기간 셀은 잠긴다(03 R-27).
 * 화면에는 안 보이지만 행 데이터에는 반드시 실려 있어야 한다. 빼면 편집 판정이 통째로 무너진다.
 * 컬럼으로는 만들지 않는다 — 만들면 우클릭 Filter/Sort/Hide 와 컬럼설정 모달에 노출된다(03 V-15).
 */
export const ASSIGN_PRIORITY_SUFFIX = '_ASSIGN_PRIORITY';

// ====================================================================================
// Measure 코드 (lookup SCP_CAPA_LOSS_MEASURE 29행 / SCM_MST_SHEET_MEASURE 109행 — 03 §1.11)
// ====================================================================================
//   **편집 가능 measure 목록은 여기 두지 않는다** — GET measure 결과셋의 `*_TARGET_YN` 이 단일
//   원천이다(hook #130, 03 V-23). 아래는 코드가 산식·색·환산에서 이름으로 읽는 measure 뿐이다.
export const MEASURE = {
  // 산식 출력 7종 (R-09 ApplyToSheet)
  PROD_CAPA_M: 'PROD_CAPA_M',
  PROD_CAPA_D: 'PROD_CAPA_D',
  THRY_CAPA_D: 'THRY_CAPA_D',
  OP_RT: 'OP_RT',
  LD_RT: 'LD_RT',
  TEEP: 'TEEP',
  PROD_OP_RT: 'PROD_OP_RT',
  // 산식 입력
  AV_RT: 'AV_RT',
  PF_RT: 'PF_RT',
  QL_RT: 'QL_RT',
  ID_RT: 'ID_RT',
  NM_RT: 'NM_RT',
  BM_RT: 'BM_RT',
  CM_RT: 'CM_RT',
  PD_RT: 'PD_RT',
  PM_RT: 'PM_RT',
  UD_RT: 'UD_RT',
  PP_RT: 'PP_RT',
  MR_RT: 'MR_RT',
  // LINE 축
  SCP_PROD_PLAN: 'SCP_PROD_PLAN',
  SCP_PROD_PLAN_DDN: 'SCP_PROD_PLAN_DDN',
  SD_RT: 'SD_RT',
  WT_RT: 'WT_RT',
  TD_RT: 'TD_RT',
  MC_RT: 'MC_RT',
  ADJ_ULD_RT: 'ADJ_ULD_RT',
} as const;

/** `OP_RT = 100 - Σ` 의 감산 항 7종 (03 R-08 1단계). */
export const OP_RT_LOSS_MEASURES: readonly string[] = [
  MEASURE.BM_RT,
  MEASURE.CM_RT,
  MEASURE.PD_RT,
  MEASURE.PM_RT,
  MEASURE.UD_RT,
  MEASURE.PP_RT,
  MEASURE.MR_RT,
];

/** `LD_RT = 100 - Σ` 의 감산 항 2종 (03 R-08 2단계). */
export const LD_RT_LOSS_MEASURES: readonly string[] = [MEASURE.ID_RT, MEASURE.NM_RT];

// 값이 직접 반영되는 파생 measure 7종(03 R-09 `ApplyToSheet`) —
//   `PROD_CAPA_M PROD_CAPA_D THRY_CAPA_D OP_RT LD_RT TEEP PROD_OP_RT`.
//   목록을 상수로 두지 않는다: `utils/capaLossPlan.recalc.ts` 의 7단계가 각 measure 에 **직접**
//   값을 쓰므로 목록과 산식이 이중 관리되면 어긋난다(산식 쪽이 단일 원천).

/**
 * 값이 아니라 **dirty 마킹만** 되는 measure 18종 (03 R-09 `ApplyToSheetOnlyEditModeCurrent`).
 * "한 셀 고치면 그 열의 18 measure 행이 전부 `CRUD_TYPE='M'`" 이 저장 계약의 전제다(V-39).
 * 마킹은 공용 `EditTracker` 로만 한다 — 자체 상태필드 신설 금지(convert-core §2.4).
 */
export const DIRTY_ONLY_MEASURES: readonly string[] = [
  MEASURE.ID_RT,
  MEASURE.NM_RT,
  MEASURE.BM_RT,
  MEASURE.CM_RT,
  MEASURE.PD_RT,
  MEASURE.PM_RT,
  MEASURE.UD_RT,
  MEASURE.PP_RT,
  MEASURE.MR_RT,
  MEASURE.AV_RT,
  MEASURE.SD_RT,
  MEASURE.TD_RT,
  MEASURE.MC_RT,
  MEASURE.WT_RT,
  MEASURE.ADJ_ULD_RT,
  MEASURE.SCP_PROD_PLAN,
  MEASURE.SCP_PROD_PLAN_DDN,
  MEASURE.QL_RT,
];

// 1차 컷오프 x LINE 재계산 트리거 measure 4종(AS-IS `_recalcLineMeasures` =
//   `SCP_PROD_PLAN SD_RT TD_RT MC_RT`)을 상수로 두지 않는다 — 03 R-18 의 TO-BE 지시가
//   "상수 대신 lookup `FIRST_LINE_TARGET_YN` 소비" 이고, 그 집합이 곧 `editableMeasures` 다.
//   상수를 함께 두면 lookup 이 바뀔 때 두 기준이 갈린다(hook #130).

/** ELTR `THRY_CAPA_D` 배수 — `ELTR_LN_TP_CD === 'W'` 면 2, 그 외 1 (03 R-08 5단계, V-37). */
export const ELTR_DOUBLE_LINE_TYPE = 'W';

/** `DAY_CNT` 조회 실패 시 기본값 (03 R-08, V-41). 연 컬럼도 이 값이 된다(C-15 AS-IS 결함). */
export const DEFAULT_DAY_CNT = 30;

/** 하루 분(minute) — `THRY_CAPA_D = SPEED_PPM * 1440` (03 R-08 5단계). */
export const MINUTES_PER_DAY = 1440;

// ====================================================================================
// Measure 행 배경색 (design 03 R-12 / V-57·V-58 · decisions.md §A BLK-11 · §B-5)
// ====================================================================================
//   AS-IS 는 `MEASURE_NAME` **영문 표시값 19문자열**을 하드코딩 비교한다 — 다국어에서 즉시 깨지므로
//   TO-BE 는 **`MEASURE`(코드) 기준**으로 재현한다(R-12 지시). 아래는 그 19문자열 ↔ 코드 대응이다.
//
//   decisions.md §B-5 충돌 규명 결과(이번 회차):
//     설계 C-11 은 "연주황은 3행(PF_RT/QL_RT/UD_RT)만 발현, 분홍·연하늘은 사문" 으로 판정했으나,
//     그 판정은 하드코딩 문자열을 **TO-BE 로 이관된 measure 라벨**과 대조해 나온 것이다.
//     AS-IS 실행화면 캡처(`human-doc/asis-screenshot.png`, CURRENT_ASSEMBLY)의 행 라벨은
//     `Idle (Equipment Standby)` · `Out of Raw Materials` · `BM` · `CM` · `PD` · `PM` ·
//     `Production Preparation` · `Material Replacement` 처럼 **AS-IS 하드코딩 문자열과 정확히 같고**,
//     그 11행이 실제로 연주황으로 칠해져 있다. 즉 문자열 미스매치는 TO-BE 라벨 이관 과정에서
//     생긴 것이고 **AS-IS 런타임에서는 R-12 가 정상 발현**한다 — "사문" 판정은 AS-IS 기준으로 기각.
//     따라서 캡처가 보여주는 11행을 그대로 코드 기준으로 옮긴다.
//   분홍 1행 — gap-resolve iter-1 에서 **AS-IS DB 실측으로 확정**(추정 매핑 아님).
//     iter-1/iter-2 는 "대응 코드를 찾지 못했다"로 남겼으나, 그 근거 두 개가 모두 오류였다:
//       (1) "lookup 29행에 해당 항목이 없다" -> 있다. 표시문자열이 `COLUMN_LABEL_NAME` 이 아니라
//           `ATTRIBUTE5` 에 들어 있어 라벨 컬럼만 훑은 검색이 빗나갔다. AS-IS 실측:
//           `SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='SCP_CAPA_LOSS_MEASURE', SEGMENT1='ADJ_ULD_RT')`
//           -> `ATTRIBUTE5 = 'Capa. Balancing (LOB)'` · `DISPLAY_SEQ = 43`.
//       (2) "캡처에서 MR_RT(57) 뒤에 온다" -> 아니다. 캡처상 분홍 행은
//           `Out of Raw Materials`(NM_RT,42) 와 `BM`(BM_RT,51) **사이**이며 이는 DISPLAY_SEQ 43 과 일치한다.
//     AS-IS `Set_MeasureColor` 의 분홍 분기 조건이 `measureVal == "Capa. Balancing (LOB)"` 이므로
//     코드 기준 대응은 `ADJ_ULD_RT` 로 확정된다.
export const MEASURE_COLOR = {
  /** (237,248,170) 연노랑 — AS-IS `Final Production Plan`. */
  YELLOW: 'YELLOW',
  /** (218,238,243) 연하늘 — AS-IS `Production Capa.(Daily)` / `Production Operating Rate`. */
  SKY: 'SKY',
  /** (255,239,213) 연주황 — AS-IS 나머지 매칭분. */
  ORANGE: 'ORANGE',
  /** (255,192,203) 분홍 — AS-IS `Capa. Balancing (LOB)`. */
  PINK: 'PINK',
} as const;
export type MeasureColor = (typeof MEASURE_COLOR)[keyof typeof MEASURE_COLOR];

/**
 * measure 코드 -> 색 클래스. 색값 자체는 `components/CapaLossPlanGrid.module.scss` 가 갖는다
 * (inline style 금지 — convert-core §2.1 #5).
 * 적용 범위는 `(행, MEASURE_NAME 열) ~ 행 끝` 이다(R-12).
 */
export const MEASURE_COLOR_BY_CODE: Readonly<Record<string, MeasureColor>> = {
  // 연노랑 — 캡처 범위 밖(LINE 시트 measure). 설계 R-12 문자열 대응만으로 이식, 육안 미확인.
  [MEASURE.SCP_PROD_PLAN]: MEASURE_COLOR.YELLOW,
  // 연하늘 — 캡처 범위 밖(상단 스크롤 아웃). 설계 R-12 문자열 대응만으로 이식, 육안 미확인.
  [MEASURE.PROD_CAPA_D]: MEASURE_COLOR.SKY,
  [MEASURE.PROD_OP_RT]: MEASURE_COLOR.SKY,
  // 연주황 — 11행은 캡처로 직접 확인(CURRENT_ASSEMBLY).
  [MEASURE.PF_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.QL_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.ID_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.NM_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.BM_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.CM_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.PD_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.PM_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.UD_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.PP_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.MR_RT]: MEASURE_COLOR.ORANGE,
  // 연주황 — LINE 시트분(캡처는 CURRENT_ASSEMBLY 라 범위 밖).
  //   `MC_RT` 는 iter-1/iter-2 가 "AS-IS 라벨의 NBSP(U+00A0) 때문에 문자열 비교가 빗나가
  //   칠해지지 않았다"(C-11 / decisions §A BLK-11)며 제외했으나, gap-resolve iter-1 바이트 실측 결과
  //   **NBSP 가 양쪽에 다 있어 비교가 성립한다** — 즉 AS-IS 는 이 행을 칠한다.
  //     · AS-IS lookup: `SCP_CAPA_LOSS_MEASURE.MC_RT.ATTRIBUTE5` 6번째 문자 `UNICODE()` = 160
  //     · AS-IS 소스:   `SCP0106_CAPA_Loss_Plan.cs:2832` 리터럴이 `"Model\u00A0Change"`(UTF-8 C2 A0)
  //   제외 근거가 사라졌으므로 나머지 연주황 14종과 함께 포함한다(AS-IS 연주황 15종 = 14 + MC_RT).
  //   주의: SQL Server 기본 collation 은 NBSP 와 공백을 같게 보므로 `LEN`/`LIKE`/`=` 로는 판별되지 않는다
  //   — `UNICODE(SUBSTRING(...))` 또는 `COLLATE Latin1_General_BIN2` 로 확인해야 한다.
  [MEASURE.SD_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.WT_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.TD_RT]: MEASURE_COLOR.ORANGE,
  [MEASURE.MC_RT]: MEASURE_COLOR.ORANGE,
  // 분홍 — 캡처로 직접 확인(CURRENT_ASSEMBLY). 코드 대응은 AS-IS lookup 실측 확정(위 주석).
  [MEASURE.ADJ_ULD_RT]: MEASURE_COLOR.PINK,
};

// ====================================================================================
// 숫자 포맷 (design 03 R-07 / V-33)
// ====================================================================================
//   메타 `DATA_SCALE_NUMBER` 가 226행 전건 NULL 이라 메타로 풀 수 없다(C-05, 메타 정비 대상).
//   AS-IS 는 measure 26종에 대해 조회 1자리 / 편집 10자리를 건다. 자릿수가 measure 별로 다르지
//   않고 **모드로만 갈리므로** 상수 배열이 아니라 모드 상수 2개로 충분하다(컬럼명 배열 이식 아님).
export const SCALE_VIEW = 1;
export const SCALE_EDIT = 10;

/** 컬럼 폭 2모드 — `PFRSLT_QTY`/`BASE_QTY`/전 날짜컬럼 (03 R-04, V-32). */
export const COLUMN_WIDTH_VIEW = 80;
export const COLUMN_WIDTH_EDIT = 140;

// ====================================================================================
// 3단 헤더 (design 03 §2.4 / hook #93)
// ====================================================================================
// 헤더는 3단이다(1단 LARGE / 2단 SMALL / 3단 COLUMN_LABEL). depth 를 별도 상수로 두지 않는다 —
//   단 수는 `buildPeriodColumns` 의 중첩 구조가 곧 표현이고, 높이만 아래 prop 단일 출처로 준다.
export const HEADER_ROW_HEIGHT = 16; // 3단 x 16 = 총높이 48px (AS-IS 20x3=60 이식 금지)

// ====================================================================================
// 저장 직렬화 (design 03 §3.5 — AS-IS SetQueryInfoSave)
// ====================================================================================
export const SAVE_ROW_DELIMITER = '^';
export const SAVE_PERIOD_DELIMITER = ';';

/**
 * 저장 시 `/100` 환산에서 **제외**되는 measure 9종 (03 §3.5, V-48).
 * 나머지 비율 measure 는 `값/100` 으로 저장한다. `PFRSLT_QTY`/`BASE_QTY` 에도 같은 규칙.
 * 주의: GET 쪽 `x100` 은 SP(6시트)/뷰(CURRENT 2시트)가 이미 하므로 **화면에서 재적용 금지**
 * — 재적용하면 100배 오류다(C-13).
 */
export const SAVE_NO_RATE_CONVERT_MEASURES: readonly string[] = [
  MEASURE.SCP_PROD_PLAN,
  MEASURE.PROD_CAPA_M,
  MEASURE.PROD_CAPA_D,
  MEASURE.SCP_PROD_PLAN_DDN,
  MEASURE.THRY_CAPA_D,
  MEASURE.SD_RT,
  MEASURE.WT_RT,
  MEASURE.TD_RT,
  MEASURE.MC_RT,
];

export const RATE_DIVISOR = 100;

// ====================================================================================
// i18n — SCM_ADM_MSG_M 문구 역조회 실측 (01 §2-F, hook #114)
// ====================================================================================
//   AS-IS 번호를 그대로 쓰지 않는다. 특히:
//   - AS-IS MSG00097(권한 Division 없음) -> TO-BE 는 **MSG00667**. TO-BE MSG00097 은
//     "Please select Division." 로 전혀 다르다(메모리 msg00097-tobe-select-division-not-permission).
//   - AS-IS MSG00004(저장 {0}건) -> TO-BE 는 **MSG00672** "{0} data saved.".
//     TO-BE MSG00004 는 "No changes to save." 라 번호를 그대로 쓰면 뜻이 뒤집힌다.
//   - AS-IS MSG00109 -> **MSG01454**("Read-only.") 문구 완전일치 채택(사용자 확정, decisions §A BLK-5).
//     자매 SCP0105 는 `MSG00109`("Read-only mode.")를 쓰고 있어 현재 두 화면이 갈린다 —
//     SCP0105 폴더는 Hard Boundary 밖이라 이번 회차에 고치지 않고 04 리포트에 후속 정합으로 올린다.
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (AS-IS MSG00097, 01 L-07)
  PRE_READ_ONLY: 'MSG01406', // "Only inquiries are allowed when the status is Pre." (AS-IS MSG00419, L-12)
  READ_ONLY: 'MSG01454', // "Read-only." (AS-IS MSG00109, L-13/L-15)
  NO_PERMISSION: 'MSG00096', // "No permission." (AS-IS MSG00096 동일 의미, L-22)
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (AS-IS MSG00004)
  SAVE_FAIL: 'MSG00006', // "Failed to save." (AS-IS MSG00006 동일 의미)
  NO_CHANGES: 'MSG00133', // "No modifications have been made." (AS-IS MSG00133 동일 의미)
} as const;

// ====================================================================================
// 컬럼 개인화 (ColumnLayoutModal) — 03 §3.3
// ====================================================================================
//   AS-IS btnColumn -> `new SCM002_CAPAColumnPopup("SCP0106", _sheet_name, true)`.
//   **`_sheet_name` 8값**을 넘긴다 — 헤더 SP 가 쓰는 `_sheet_status`(4값)와 축이 다르며
//   그 비대칭을 그대로 재현한다(03 §3.3, V-59).
export const TITLESET_COLUMN_TYPE = 'C';

/**
 * 코드 숨김 컬럼 판정 — 메타 `VISIBLE_FLAG` 가 정비돼 있지 않아(C-10) 폭 0 을 숨김으로 읽는다.
 * AS-IS `SetVisibleSheetColumn` 이 16컬럼을 코드 배열로 숨기지만, 그 배열을 이식하면 hook #130
 * (컬럼명 상수 배열 이식 금지) 위반이자 메타와 이중 관리가 된다 — 메타 무수정 경로가 안전하다(03 R-03).
 */
export const HIDDEN_COLUMN_WIDTH = 0;
