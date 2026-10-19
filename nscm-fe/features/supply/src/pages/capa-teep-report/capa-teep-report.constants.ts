export const MENU_ID = 'SCP0107' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Report/SCP0107_CAPA_TEEP_Report (CAPA TEEP Report, 메뉴 Title "TEEP Report"):
//   설계 근거: .atlas/gscm-design/SCP0107/design/00_checklist.md ~ 03_grid-columns.md
//   확정 결정: .atlas/gscm-design/SCP0107/convert-flow/goal.md 6-1 "사용자 확정" 표(D-1/D-2/D-5/D-11)
//
//   **조회 전용 리포트** 다 — 편집·저장 경로가 코드·메타·SP 어디에도 없다
//   (01 L-12/L-14/L-21 · 03 §4.4 · `INPUT_TP_CD='S'` 50/50). 자매 SCP0105/0106 의 편집·저장 배선을
//   복사하면 전부 오답이다(goal ④-2 S-1). 그래서 이 화면에는 다음이 존재하지 않는다:
//     `useProcMutation`/`useSaveWithValidation`/`EditTracker`/`CRUD_TYPE` · `isEditMode` state ·
//     `*.editLock.ts`/`*.recalc.ts`/`*.save.ts` · Edit 버튼 · 셀 콤보 · 시트 탭 UI.
//   - GET  SP : SCP.SCP0107_GET_CAPA_TEEP_ASSEMBLY / SCP.SCP0107_GET_CAPA_TEEP_ELTR (IN 13 / OUT 커서 1)
//   - SAVE SP : 없음(`SetQueryInfoSave*` 0건, 03 §4.4)
//   - TITLE SP: PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE (SCP0104/0105/0106/0107/0108 공용)
//   - SP 미배포(goal ②): `PKG_SCP0107`·`PKG_SCP0104` ALL_OBJECTS 0건(2026-09-25 ora.py 재확인)
//     -> 조회·동적 헤더 런타임 미완(convert-sp 후속)

/**
 * 런타임 시트 2종(동시 1개만 표시) + 헤더 메타용 1종.
 * `AddSheet` 등록 순서는 ASSEMBLY=0 / ELTR=1 이지만 `TabStripPolicy=Never` 라 탭이 아니다(03 G-01).
 */
// enum 이 아니라 const 객체다 — `procedures.d.ts` 의 `SheetName<'SCP0107'>`(문자열 리터럴 유니온)에
//   그대로 대입해야 `useTabProcQuery` 제네릭이 통과한다(string enum 멤버 타입은 리터럴에 대입되지 않는다).
export const SHEETS = {
  ASSEMBLY: 'ASSEMBLY',
  ELTR: 'ELTR',
  SPREAD_TITLE: 'spreadTitle', // 동적 기간 헤더 전용(그리드 아님) — 03 §2.1 / §4.5
} as const;

/** 데이터 그리드가 되는 시트 — SPREAD_TITLE 은 헤더 메타 전용이라 제외한다. */
export type GridSheet = typeof SHEETS.ASSEMBLY | typeof SHEETS.ELTR;

/**
 * OUT 커서 ↔ 응답 key. GET SP 는 **결과셋 1개**다(`AfterFindData` 가 `lst[0].Tables[0]` 만 쓴다, 03 §1.6).
 * `PKG_SCP0107` 미배포라 실제 OUT 파라미터 이름을 실측할 수 없다 — 소비부는
 * `utils/capaTeepReport.cursors.ts` 의 fallback chain 으로 읽는다(03 §4.5, hook #80).
 * 자매 SCP0105/0106 처럼 상수 하나만 믿고 `?? []` 로 넘기면 커서 이름이 다를 때 화면이 조용히 0건이 된다.
 */
export const RESPONSE_SET = {
  DATA: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
} as const;

/** admin UI Category Setup(`SCM_MST_SHEET_COLUMNS`/`SCM_MST_SHEET_MEASURE`) SHEET_NAME — 시트 키와 동일. */
export const ADMIN_SHEET_NAME: Record<GridSheet, string> = {
  [SHEETS.ASSEMBLY]: 'ASSEMBLY',
  [SHEETS.ELTR]: 'ELTR',
};

// ====================================================================================
// DivisionType (조회조건 Operation group) — AS-IS ScpCapa.DivisionType(ScpCapa.cs:20~25)
// ====================================================================================
//   AS-IS 는 SelectedIndex(0/1/2) 정수를 쓰지만 TO-BE 는 의미를 잃지 않게 문자열 상수로 둔다.
export const DIVISION_TYPE = {
  ELTR: 'ELTR', // SelectedIndex 0
  CELL: 'CELL', // SelectedIndex 1
  MODULE_PACK: 'MODULE_PACK', // SelectedIndex 2
} as const;
export type DivisionType = (typeof DIVISION_TYPE)[keyof typeof DIVISION_TYPE];

/**
 * 초기 선택값 = **Electrode**.
 *
 * AS-IS Designer 는 `SelectedIndex`/`EditValue` 를 설정하지 않아 `-1`(미선택)로 시작하고, 그 상태는
 * 시트/GET 축은 `ELTR` 인데 헤더 SP 인자는 `ASSEMBLY` 라는 **AS-IS 자체 불일치**다(01 L-19 / 03 §6-3).
 * 게다가 `GetShopGroupId(-1)='P'` 라 EE 마스터에 `SHOP_GROUP_ID IN ('P')` 가 걸려 Division 을 하나라도
 * 고르면 Plant 이하 후보가 0건이 되는 잠재 결함이 있다(02 §4.3).
 * **사용자 확정(2026-09-25, goal ⑥-1 D-1 = "Electrode 명시 선택")** 으로 `ELTR` 을 기본값으로 둔다.
 * 재판단 금지. 자매 SCP0105/0106/0108 은 `CELL` 이라 복사 금지다.
 */
export const DEFAULT_DIVISION_TYPE: DivisionType = DIVISION_TYPE.ELTR;

/** AS-IS ScpCapa.GetShopGroupId(capa:111~135) — 마스터 슬라이스의 SHOP_GROUP_ID 필터축. */
export const SHOP_GROUP_ID: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: 'E',
  [DIVISION_TYPE.CELL]: 'A',
  [DIVISION_TYPE.MODULE_PACK]: 'P',
};

/**
 * AS-IS `GetDivisionTypeName`(capa:86~105) — Cell·Module/Pack 이 같은 ASSEMBLY 축이다.
 * 시트축(`_sheet_name`) · GET SP 변형 · 헤더 SP 의 `p_sheet_name` 이 **이 파생값 하나**에서 나온다.
 * AS-IS 는 헤더 호출만 `SelectedIndex == 0 ? ELTR : ASSEMBLY` 라는 다른 식을 쓰지만(cs:1208)
 * TO-BE 는 단일 출처로 통일한다(03 §4.1 `p_sheet_name` 계약).
 */
export const SHEET_NAME_BY_DIVISION_TYPE: Record<DivisionType, GridSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.ASSEMBLY,
};

// ====================================================================================
// 진행상태(PROG_STAT) — lookup SCP/CAPA_PROG_STAT 실측 4코드
// ====================================================================================
//   표시문구는 lookup 이 원천이라 하드코딩하지 않는다. 여기 상수는 "판정에 쓰는 코드" 뿐이다.
export const PROGRESS_STATUS = {
  PRE: '-',
  CURRENT: '0',
  FIRST_CUTOFF: '1',
  SECOND_CUTOFF: '2',
} as const;

/**
 * 조회 가능 진행상태 — **2차 컷오프 확정 버전만** 조회된다(`ProgressStatusType._2ND_CUTOFF='2'`).
 * Plan Month 후보 자체가 이 상태로 좁혀지고(02 §2.2 `PROG_STAT IN ('2')`, cs:941 주석
 * "2nd Cutoff 인 버전목록만 조회"), Search 시 한 번 더 게이트한다(02 §4.4 / cs:1340~1345).
 */
export const REQUIRED_PROG_STAT: string = PROGRESS_STATUS.SECOND_CUTOFF;

/**
 * `MSG01410`("Cannot be retrieved because the progress status is before {0}") 의 `{0}` 치환값.
 * **AS-IS 인자 리터럴 원문**이다 — `SCP0107_CAPA_TEEP_Report.cs:1342`
 * `GMessageBox("MSG00423", new object[] { "'2`nd Cut-off'" })` (홑따옴표 포함·`Cut-off` 하이픈).
 * iter-1 은 이 원문을 확인하지 못해 lookup `CAPA_PROG_STAT` `SEGMENT1='2'` 표시문구(`2`nd Cut off`)를
 * 대신 썼는데, iter-1 감사가 AS-IS 소스를 직접 read 해 원문을 실측 확정했다(R-04) — AS-IS 파리티로
 * 되돌린다. lookup 표시문구는 콤보 표시용이고 이 메시지 인자는 화면 하드코딩 리터럴이라 별개 축이다.
 * i18next 기본 보간자는 `{{ }}` 라 DB 문구의 `{0}` 은 `.replace('{0}', ...)` 로 치환한다.
 */
export const REQUIRED_PROG_STAT_LABEL = '\'2`nd Cut-off\'';

/** Plan Type 파생값 — `BIZ_PLAN_USE_YN='Y'` 면 BP, 아니면 RP(기본). AS-IS ScpCapaBL:654~691. */
export const PLAN_TYPE = { BIZ: 'BP', ROLLING: 'RP' } as const;

// ====================================================================================
// 조회조건 콤보 SQL_ID (design 02 §2.7 — ora.py 실측 2026-09-25, 5종 전건 USE_YN='Y')
// ====================================================================================
//   SCP 접미어 규약(convert-core §2.6): `Data_SCP.Common` -> `X_SCP` / `CommonAll` -> `X_SCP_ALL`.
//   이름이 비슷한 범용 콤보(`Division`/`DivisionByUser`/`MyDivision`) 재사용 금지 — 후보 집합이
//   조용히 달라진다(SCP0006 실사고, 메모리 `scp-combo-sqlid-suffix-convention`).
//   **미사용 3종은 호출하지 않는다**(02 §2.5 D1~D3): `CapaProgressStatus_SCP_ALL`(이 화면에 Status
//   콤보가 없다) · `YearFromThisYear_SCP_ALL`(대응 컨트롤 `cboFromYYYY` 가 Designer 에 부재) ·
//   `YesOrNo`(Y/N 콤보 부재). 자매 화면 훅을 복사해 5건을 부르면 AS-IS 에 없는 왕복이 생긴다.
export const SEARCH_COMBO = {
  DIVISION: 'Division_SCP', // 권한필터 O. clbDivision — 다중선택(02 §2.1)
  CAPA_VERSION: 'CapaVersion_SCP_ALL', // 결과셋 1건에서 4파생(Plan Month/Version/PlanType/게이트, 02 §2.2)
  LINE_MASTER_ASSEMBLY: 'CapaLineMaster_SCP_ALL', // Cell·Module/Pack 마스터(02 §2.3)
  LINE_MASTER_ELTR: 'CapaLineMasterEE_SCP_ALL', // Electrode 마스터(02 §2.3)
  OPERATION_ELECTRODE_TYPE: 'OperationElectrodeType_SCP_ALL', // Line Type 의 ELTR 경로 원천(02 §2.4)
} as const;

/** AS-IS BLUtils.GetDivisionWithoutEE(blu:107~116) — 이관 CMBO WHERE 에 없어 FE 재현(02 §2.1 ②). */
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

/**
 * Formation 더미 Operation.
 * **이 화면은 ELTR 과 CELL 양쪽에서 제외한다** — `GetFilterOperation` 이 ELTR 분기에서 걸고
 * 화면이 CELL 분기에서 한 번 더 붙인다(02 §2.6 Operation 행, cs:1083~1093). 결과적으로
 * **Module/Pack 만 Formation 이 후보에 남는다**.
 * 주의: 자매 SCP0106/SCP0108 은 **ELTR 만** 제외한다 — 그 코드를 복사하면 Cell 후보가 넓어진다.
 */
export const FORMATION_OPERATION_ID = 'AFFFF';

/** AS-IS `GetElectrodeOperationFilter`(BL:634~652) 의 ELTR 분기 실효 조건(02 §2.4). */
export const ELTR_DEFAULT_OPERATION_ID = 'E2000';

/** AS-IS `GetSortedCode`(BL:81~136) — `DMY_` 접두 항목을 목록 맨 뒤로 후치(02 §2.6 유틸 표). */
export const DUMMY_CODE_PREFIX = 'DMY_';

/**
 * 마스터 슬라이스의 `CODE <> '-'` 제외값.
 * AS-IS 는 Site/Plant/Building/Line **4축에만** 이 조건을 건다 — `GetFilterOperation`·
 * `GetFilterElectrodeType` 에는 없다(02 §2.6). 전 축에 걸면 Line Type 후보가 0건이 된다.
 */
export const EMPTY_CODE = '-';

/**
 * 다중선택의 "무선택 = 전체" sentinel. 공용 `CustomDropdown multiple allOption` 이
 * 전체선택/전체해제에서 이 값을 돌려주며 AS-IS `UsrCheckedList.ControlValues` 의 `"ALL"` 과 같은 자리다
 * (02 §3.4). 6개 체크리스트 컨트롤 전건 `ALL_VIEW=true` · `ValueList="ALL"`(02 §1.1 Designer 실측).
 */
export const ALL_SENTINEL = 'ALL';

/**
 * 후보 목록이 0건일 때 서버로 보내는 값 — 결과셋이 비도록 강제한다(AS-IS
 * `CString.GetCheckedListValueNone` 의 0건 분기, 02 §3.4).
 * **이 sentinel 을 빠뜨리면 그 축이 무필터가 되어 조건 없이 전건을 조회한다**(goal S-6).
 */
export const NONE_SENTINEL = 'NONE';

// ====================================================================================
// 그리드 컬럼 키 (design 03 §1 — DB 메타 50행의 COLUMN_NAME)
// ====================================================================================
//   컬럼 "목록"은 admin 메타가 원천이다. 여기 상수는 **코드가 의미를 읽는 컬럼**만 이름으로 고정한다
//   (행 배경색 적용 시작점 · 행 단위 소수 자릿수 판정 · 그 판정의 조건 컬럼).
//   AS-IS `SetVisibleSheetColumns` 의 숨김 컬럼명 배열 13종은 **이식하지 않는다**(hook #130 / 03 G-15)
//   — 숨김 신호는 메타(`colWth === 0 || visible === false`)에서만 읽는다.
export const COLUMN = {
  MEASURE: 'MEASURE',
  MEASURE_NAME: 'MEASURE_NAME',
  BIZ_QTY: 'BIZ_QTY',
  PRE_QTY: 'PRE_QTY',
  PFRSLT_QTY: 'PFRSLT_QTY',
  BASE_QTY: 'BASE_QTY',
} as const;

/** 동적 기간 컬럼 접두 — 월 `M_01yyyymm` / 연 `Y_yyyy` (03 §2.2). */
export const PERIOD_PREFIX = { MONTH: 'M_', YEAR: 'Y_' } as const;

/**
 * 동적 기간 컬럼 폭 — AS-IS `RefreshSpreadDateColumn(..., columnWidth: 80, ...)`(su:684~689, 03 §2.3).
 * **SCP0104 는 40 이라 그대로 베끼면 안 된다**(V-14).
 */
export const PERIOD_COLUMN_WIDTH = 80;

// `*_ASSIGN_PRIORITY` 상수를 두지 않는다 — TVF 가 `SCP0105`/`SCP0106` 에만 그 컬럼을 만들고 SCP0107 은
//   **0건 생성**이라 AS-IS 의 제외 필터(cs:1215)가 항상 무동작이다(03 §2.7 / V-13). 자매 화면에서
//   복사하면 있지도 않은 컬럼을 방어하는 죽은 코드가 된다.

// ====================================================================================
// 숫자 포맷 (design 03 §3.2 G-13 / V-19·V-20)
// ====================================================================================
//   `DATA_SCALE_NUMBER` 가 50행 전건 NULL 이라 **메타로 풀 수 없다**(03 §1 공통). AS-IS 는 행마다
//   `MEASURE` 값을 읽어 자릿수를 정하므로(su:1021~1097) 컬럼 단위 `format` 으로는 표현 불가 —
//   `formatItem` 에서 그린다. 컬럼 기본값은 AS-IS `SetReNumerCellType(..., decimalPlace:1)`(su:699).
export const SCALE_DEFAULT = 1;
export const SCALE_ZERO = 0;

/** 소수 0자리 measure 5종 — AS-IS `SetSheetNumericColumnFormat` 의 `dic` 키(cs:1484~1492). */
export const ZERO_SCALE_MEASURES: readonly string[] = [
  'SCP_PROD_PLAN',
  'PROD_CAPA_M',
  'PROD_CAPA_D',
  'SCP_PROD_PLAN_DDN',
  'THRY_CAPA_D',
];

/**
 * 행 단위 자릿수가 적용되는 정적 컬럼 — AS-IS `_sheetNumericColumns`(cs:1217~1222) 의 정적 구간이다.
 * 나머지 대상은 **기간 컬럼 전량**이며 그쪽은 `isPeriodColumn()` 으로 판정한다.
 */
export const NUMERIC_STATIC_COLUMNS: readonly string[] = [
  COLUMN.BIZ_QTY,
  COLUMN.PRE_QTY,
  COLUMN.PFRSLT_QTY,
  COLUMN.BASE_QTY,
];

// ====================================================================================
// Measure 행 배경색 (design 03 §3.3 — 19종 4색 / V-21~V-24 · goal D-8 "4색 유지")
// ====================================================================================
//   AS-IS 는 `MEASURE_NAME`(영문 표시값) **19문자열 하드코딩 비교**다(cs:1534~1564) — 다국어 전환 즉시
//   깨지므로 TO-BE 는 **`MEASURE`(코드) 기준**으로 재현한다. 대응표는 설계가 lookup 실측
//   (`SCP_CAPA_LOSS_MEASURE.SEGMENT1 ↔ ATTRIBUTE5`)으로 19건 전건 확정했다.
//   `MC_RT` 도 **칠해진다** — AS-IS 리터럴이 `Model` + U+00A0(NBSP) + `Change` 인데 lookup `ATTRIBUTE5`
//   도 같은 NBSP 를 갖고 있어 AS-IS 비교가 성립한다(03 §3.3 두 번째 불릿, 바이트 실측). 코드 기준 비교는
//   이 함정 자체를 원천 제거한다. 이 주석에도 NBSP 를 타이핑하지 않는다(`no-irregular-whitespace` 게이트).
export const MEASURE_COLOR = {
  /** (237,248,170) 연노랑 — AS-IS `Final Production Plan`. */
  YELLOW: 'YELLOW',
  /** (218,238,243) 연하늘 — AS-IS `Production Capa.(Daily)` / `Production Operating Rate`. */
  SKY: 'SKY',
  /** (255,239,213) 연주황 — AS-IS Loss 계열 15종. */
  ORANGE: 'ORANGE',
  /** (255,192,203) 분홍 — AS-IS `Capa. Balancing (LOB)`. ELTR 에는 행 자체가 없다(V-23). */
  PINK: 'PINK',
} as const;
export type MeasureColor = (typeof MEASURE_COLOR)[keyof typeof MEASURE_COLOR];

/**
 * measure 코드 -> 색 클래스. 색값 자체는 `components/CapaTeepReportGrid.module.scss` 가 갖는다
 * (inline style 금지 — convert-core §2.1 #5). 적용 범위는 `(행, MEASURE_NAME 열) ~ 행 끝` 이다.
 * AS-IS `else { continue; }`(cs:1565~1568) 라 미매칭 행은 칠하지 않는다 — 자매 SCP0106 의
 * `SetMeasureColorOneRow`(검정 칠) 데드 분기는 SCP0107 에 없으므로 이식하지 않는다.
 */
export const MEASURE_COLOR_BY_CODE: Readonly<Record<string, MeasureColor>> = {
  SCP_PROD_PLAN: MEASURE_COLOR.YELLOW,
  PROD_CAPA_D: MEASURE_COLOR.SKY,
  PROD_OP_RT: MEASURE_COLOR.SKY,
  PF_RT: MEASURE_COLOR.ORANGE,
  QL_RT: MEASURE_COLOR.ORANGE,
  SD_RT: MEASURE_COLOR.ORANGE,
  WT_RT: MEASURE_COLOR.ORANGE,
  TD_RT: MEASURE_COLOR.ORANGE,
  MC_RT: MEASURE_COLOR.ORANGE,
  ID_RT: MEASURE_COLOR.ORANGE,
  NM_RT: MEASURE_COLOR.ORANGE,
  BM_RT: MEASURE_COLOR.ORANGE,
  CM_RT: MEASURE_COLOR.ORANGE,
  PD_RT: MEASURE_COLOR.ORANGE,
  PM_RT: MEASURE_COLOR.ORANGE,
  UD_RT: MEASURE_COLOR.ORANGE,
  PP_RT: MEASURE_COLOR.ORANGE,
  MR_RT: MEASURE_COLOR.ORANGE,
  ADJ_ULD_RT: MEASURE_COLOR.PINK,
};

// ====================================================================================
// 3단 헤더 (design 03 §2.4 / hook #93)
// ====================================================================================
//   개별 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 헤더 row 마다 명시 height 를 박아 3단 전체가
//   1단 높이로 벌어진다(SCP0106 실사고 메모). 높이는 DataGrid `headerRowHeight` prop 단일 출처다.
export const HEADER_ROW_HEIGHT = 16; // 3단 x 16 = 총높이 48px (V-18c)

// ====================================================================================
// i18n — SCM_ADM_MSG_M 문구 역조회 실측 (01 §2-F / hook #114 · ora.py 2026-09-25 재확인)
// ====================================================================================
//   **AS-IS 번호를 그대로 쓰지 않는다.** 이 화면은 AS-IS 6개 번호 중 5개가 TO-BE 에서 다른 뜻이다:
//   - MSG00423(진행상태 조회 차단) -> TO-BE 미등록. 문구 일치본 **MSG01410**
//   - MSG00097(권한 Division 0건)  -> TO-BE MSG00097 은 "Please select Division." 로 전혀 다름 -> **MSG00667**
//     (메모리 `msg00097-tobe-select-division-not-permission`)
//   - MSG00007 -> **MSG01043** / MSG00008 -> **MSG01044** / MSG00009 -> **MSG01045**
//   - MSG00096 만 의미가 같아 번호를 유지한다.
//   MSG00002(필수입력)·MSG00127(조회 확인)은 **이식 불요** — `*` 라벨 0건으로 사문 / 편집 경로 부재로
//   조건 미발생이다(01 §2-F).
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (AS-IS MSG00097, 01 L-04)
  PROG_STAT_BLOCKED: 'MSG01410', // "... before {0}" (AS-IS MSG00423, 02 §4.4)
  CANNOT_INSERT: 'MSG01044', // "Can not add as it is not in modify mode." (AS-IS MSG00008, 01 L-14)
  CANNOT_DELETE: 'MSG01045', // "Can not delete as it is not in modify mode." (AS-IS MSG00009, 01 L-12)
  // 콤보 조회 실패 — "권한 0건(MSG00667)" 과 반드시 구분한다. 실패를 권한 없음으로 오판하면
  //   네트워크 오류에 조회영역이 통째로 잠긴다(자매 SCP0108 iter-1 G-03).
  COMBO_LOAD_FAIL: 'MSG01390', // "An error occurred while initializing the search conditions."
  COLUMN_META_FAIL: 'MSG01052', // "An error has occurred when inquiring." (컬럼 메타 조회 실패)
  SAVE_FAIL: 'MSG00003', // "Failed to save." (컬럼 개인화 저장 실패)
} as const;

/**
 * "Module/Pack" 라디오 항목 라벨.
 * 설계 시점(01 §5-6)에는 미등록이었으나 **ora.py 실측 2026-09-25 로 `LBL01143` 3언어 등록 확인**했다
 * (자매 SCP0108 의 `05_register_msg.sql` 이 채번·등록). 영문 fallback 대신 이 코드를 쓴다 — goal D-4 의
 * "미등록 2건" 중 이 건은 해소됐고, 남은 건은 카탈로그 명칭 `Ver.`(아래 주석) 뿐이다.
 */
export const LBL_MODULE_PACK = 'LBL01143';

/**
 * Division 라벨 — TO-BE 조회조건 카탈로그 확정값 **`LBL00001`("Div.")** 이다(02 §4.5.1 / §5.1 #3).
 * AS-IS Designer 문자열 `Division` 에 대응하는 `LBL00641` 도 실재하지만, 카탈로그 rename 규칙상
 * 미채택으로 이미 판정됐다(설계 02 §4.5.1). 설계 두 문서가 갈릴 때 카탈로그가 정본이다
 * (hook #112 §4-1 — iter-1 감사 R-03 지적, iter-2 사용자 확정).
 */
export const LBL_DIVISION = 'LBL00001';

/**
 * Version 라벨 — **AS-IS Designer Text `Version` = `LBL00606`** 를 쓴다(01 §2-F 실측).
 * TO-BE 조회조건 카탈로그 표기는 `Ver.` 인데 `SCM_ADM_MSG_M` 에 그 문구가 0건이다(ora.py 재확인).
 * 엉뚱한 근사 코드(`LBL00031`="Version.")를 재사용하면 다국어 전량 불일치가 되므로(hook #114)
 * AS-IS 파리티 코드를 유지하고 `Ver.` 신규 채번은 별도 상신 항목으로 남긴다(goal D-4 / 02 §7 A-4).
 */
export const LBL_VERSION = 'LBL00606';

// ====================================================================================
// 컬럼 개인화 (ColumnLayoutModal) — 03 §0.2 / V-33·V-34
// ====================================================================================
//   AS-IS `btnColumn_Click` -> `SCM002_CAPAColumnPopup("SCP0107", _division_type_name, true)`(cs:1767).
//   3번째 인자 `isColumn=true` -> `_sTitleSetType = "C"`. **Measure 설정(`"M"`) 호출은 0건**이다.
//   `sheetName`(ASSEMBLY/ELTR)을 반드시 함께 넘긴다 — 빠지면 두 시트 개인화가 한 곳에 뭉친다.
export const TITLESET_COLUMN_TYPE = 'C';
