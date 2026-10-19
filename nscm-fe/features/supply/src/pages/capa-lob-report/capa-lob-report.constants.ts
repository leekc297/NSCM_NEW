export const MENU_ID = 'SCP0108' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Report/SCP0108_CAPA_LOB_Report (CAPA LOB Report, 메뉴 Title "LOB Report"):
//   설계 근거: .atlas/gscm-design/SCP0108/design/00_checklist.md ~ 03_grid-columns.md
//   전건 조회전용 Report 다 — 편집·저장·measure·셀콤보가 코드·메타·SP 어디에도 없다
//   (01 L-32/L-33/L-34 · 03 §4.3 · INPUT_TP_CD='S' 44/44). 자매 SCP0104/0105/0106 의
//   편집·저장·measure 배선을 복사하면 전부 오답이다(goal.md §3-3 "베끼면 안 되는 것").
//   - GET  SP : SCP.SCP0108_GET_CAPA_LOB_CURRENT (Status=Current) / SCP.SCP0108_GET_CAPA_LOB (Cut-off·Pre)
//               둘 다 IN 15개 동일 + OUT 커서 2개(데이터 + Bottleneck 플래그, 03 R-11)
//   - SAVE SP : 없음. QueryDics 는 DIC_GET_CAPA_LOB 하나뿐(cs:129)
//   - TITLE SP: PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE (SCP0104/0105/0106/0107/0108 공용)
//   - SP 미배포(goal.md §2): PKG_SCP0108 · PKG_SCP0104 both ALL_OBJECTS 0건 -> 런타임 미완(convert-sp 후속)

/**
 * 런타임 시트 2종 + 헤더 메타용 1종.
 *
 * `SCM_MST_SHEET_COLUMNS` 에는 세 번째 sheetNm `MAIN`(15행, `VALID_YN='N'`)이 있지만 그리드
 * 컬럼이 아니다 — 헤더 SP 의 lookup 매칭 키일 뿐이라 이 유니온에 넣지 않는다(03 §0.3).
 */
// enum 이 아니라 const 객체다 — `procedures.d.ts` 의 `SheetName<'SCP0108'>`(문자열 리터럴 유니온)에
//   그대로 대입해야 `useTabProcQuery` 제네릭이 통과한다(string enum 멤버 타입은 리터럴에 대입되지 않는다).
export const SHEETS = {
  CURRENT: 'CURRENT', // _progress_status === '0' (cs:376-389)
  CUTOFF: 'CUTOFF', // _progress_status ∈ {'-','1','2'}
  SPREAD_TITLE: 'spreadTitle', // 동적 기간 헤더 전용(그리드 아님) — 03 §2.1
} as const;

/** 데이터 그리드가 되는 시트 — SPREAD_TITLE 은 헤더 메타 전용이라 제외한다. */
export type GridSheet = typeof SHEETS.CURRENT | typeof SHEETS.CUTOFF;

/**
 * OUT 커서 ↔ 응답 key. GET SP 는 커서 2개를 반환한다(03 R-11 / hook #80).
 * `PKG_SCP0108` 미배포라 실제 OUT 파라미터 이름을 실측할 수 없다 — 소비부는
 * `utils/capaLobReport.cursors.ts` 의 fallback chain 으로 읽는다(하나만 믿지 않는다).
 */
export const RESPONSE_SET = {
  DATA: 'o_rc1',
  BOTTLENECK: 'o_rc2',
  SPREAD_TITLE: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

/** admin UI Category Setup(`SCM_MST_SHEET_COLUMNS`) SHEET_NAME — 시트 키와 같은 값이다(03 §0.3). */
export const ADMIN_SHEET_NAME: Record<GridSheet, string> = {
  [SHEETS.CURRENT]: 'CURRENT',
  [SHEETS.CUTOFF]: 'CUTOFF',
};

/**
 * 헤더 SP 의 `p_sheet_name` — **`'MAIN'` 리터럴 고정**(03 §2.1/§2.2, cs:1183).
 * `sheetName`(CURRENT/CUTOFF)을 넘기면 lookup `SCP_CAPA_RPT_CODE` 매칭이 0행이 되어
 * 1단 라벨(`Operation Plan`)이 전건 NULL 이 되고 1단 헤더가 사라진다(실측 확인).
 * 자매 SCP0106 이 `_sheet_status` 를 넘기는 것과 정반대이므로 복사 금지.
 */
export const HEADER_LOOKUP_SHEET_NAME = 'MAIN';

// ====================================================================================
// DivisionType (조회조건 라디오) — AS-IS ScpCapa.DivisionType(ScpCapa.cs:20~25)
// ====================================================================================
export const DIVISION_TYPE = {
  ELTR: 'ELTR', // SelectedIndex 0
  CELL: 'CELL', // SelectedIndex 1
  MODULE_PACK: 'MODULE_PACK', // SelectedIndex 2
} as const;
export type DivisionType = (typeof DIVISION_TYPE)[keyof typeof DIVISION_TYPE];

/**
 * 초기 선택값 = Cell. AS-IS Form_Load 마지막 줄이 `rgrpDivisionType.SelectedIndex =
 * DivisionType.CELL` 을 **명시 대입**한다(cs:975).
 * 주의: 자매 SCP0105 는 미설정(-1)이라 결론이 다르다 — 복사 금지(01 L-11).
 */
export const DEFAULT_DIVISION_TYPE: DivisionType = DIVISION_TYPE.CELL;

/** AS-IS ScpCapa.GetShopGroupId(CAPA:111~135) — 마스터 슬라이스의 SHOP_GROUP_ID 필터축. */
export const SHOP_GROUP_ID: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: 'E',
  [DIVISION_TYPE.CELL]: 'A',
  [DIVISION_TYPE.MODULE_PACK]: 'P',
};

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
 * 시트 스위치 — `_sheet_name`(cs:376-389)와 동일 규칙.
 * Status 는 사용자가 못 고르고(이중 `Enabled=false`, 01 L-10) 상위 콤보 cascade 로만 바뀐다.
 */
export const sheetOf = (progressStatus: string): GridSheet =>
  progressStatus === PROGRESS_STATUS.CURRENT ? SHEETS.CURRENT : SHEETS.CUTOFF;

/** Plan Type 파생값 — `BIZ_PLAN_USE_YN='Y'` 면 BP, 아니면 RP(기본). AS-IS ScpCapaBL:654~691. */
export const PLAN_TYPE = { BIZ: 'BP', ROLLING: 'RP' } as const;

// ====================================================================================
// 조회조건 콤보 SQL_ID (design 02 §2 / §5.1 — ora.py 실측 2026-09-23, 전건 USE_YN='Y')
// ====================================================================================
//   SCP 접미어 규약(convert-core §2.6): Data_SCP.Common -> `X_SCP` / CommonAll -> `X_SCP_ALL` /
//   Data.Common(base) -> 접미어 없음.
//   이름이 비슷한 범용 콤보(`Division`/`DivisionByUser`/`MyDivision`/`CapaLineMasterEE_SCP_ALL`/
//   `DummyCapaLineMaster_SCP_ALL`/`YearFromThisYear_SCP_ALL`) 재사용 금지 — 후보 집합이 조용히 달라진다.
export const SEARCH_COMBO = {
  DIVISION: 'Division_SCP', // 권한필터 O. cboDivision (02 §2.1)
  CAPA_VERSION: 'CapaVersion_SCP_ALL', // 결과셋 1건에서 4파생 (02 §2.2)
  PROGRESS_STATUS: 'CapaProgressStatus_SCP_ALL', // lookup SCP/CAPA_PROG_STAT (02 §2.3)
  LINE_MASTER: 'CapaLineMaster_SCP_ALL', // 6축 단일 원천. EE 축은 호출하지 않는다 (02 §2.4/§0 #1)
  BOTTLENECK: 'YesOrNo', // 공통 proc 유래 -> 접미어 없음. 'ALL' 은 FE 가 붙인다 (02 §2.6)
} as const;

/** AS-IS BLUtils.GetDivisionWithoutEE(BU:107~117) — 이관 CMBO WHERE 에 없어 FE 재현(02 §2.1). */
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

/**
 * Formation 더미 Operation(lookup `CPS_FORMATION_OPERATION` 실측 1행 `AFFFF`).
 * 주의: **제외는 ELTR 축에서만** 이다(`GetCodeFilterExceptFormation`, BL:355~361 · 02 §3.3).
 * 자매 SCP0105 의 전역 제외를 복사하면 Cell/Module·Pack 후보가 AS-IS 보다 좁아진다(02 §0 #4).
 */
export const FORMATION_OPERATION_ID = 'AFFFF';

/** AS-IS GetElectrodeOperationFilter 의 ELTR 분기 대체값(ScpCapaBL.cs:634~652, 02 §3.3). */
export const ELTR_DEFAULT_OPERATION_ID = 'E2000';

/** AS-IS ScpCapaBL.GetSortedCode(BL:81~136) — `DMY_` 접두 항목을 목록 맨 뒤로 후치(02 §2.9 #25~31). */
export const DUMMY_CODE_PREFIX = 'DMY_';

/**
 * 마스터 슬라이스의 `CODE <> '-'` 제외값.
 * AS-IS 는 Site/Plant/Building/Line **4축에만** 이 조건을 건다 — `GetFilterOperation`(BL:327~)·
 * `GetFilterElectrodeType`(BL:370~)에는 없다(02 §3.3). 전 축에 걸면 Line Type 후보가 0건이 된다.
 */
export const EMPTY_CODE = '-';

/**
 * 다중선택의 "무선택 = 전체" sentinel. 공용 `CustomDropdown multiple allOption` 이
 * 전체선택/전체해제에서 이 값을 돌려준다(`handleMultipleChange`).
 * AS-IS `UsrCheckedList.ValueList` 가 `CheckedItems.Count==0` 일 때 돌려주는 `"ALL"` 과 같은 자리다(02 §3.4).
 */
export const ALL_SENTINEL = 'ALL';

/**
 * Bottleneck 콤보의 선두 옵션. TO-BE `YesOrNo` CMBO 에는 'ALL' 행이 없어 FE 가 붙인다(02 §2.6).
 * 전송 시 `''` 로 치환한다 — 'ALL' 문자열을 그대로 SP 로 보내면 AS-IS 와 다르다(cs:586~601).
 */
export const BOTTLENECK_ALL = 'ALL';

// ====================================================================================
// 그리드 컬럼 키 (design 03 §1 — DB 메타 44행의 COLUMN_NAME)
// ====================================================================================
//   컬럼 "목록"은 admin 메타가 원천이다. 여기 상수는 **코드가 의미를 읽는 컬럼**만 이름으로 고정한다
//   (고정영역 경계 · Bottleneck 키 조인). AS-IS `LockColumn` 컬럼명 배열을 복제하지 않는다(hook #130).
export const COLUMN = {
  DV: 'DV',
  DIVISION_ID: 'DIVISION_ID',
  SITE_ID: 'SITE_ID',
  COMPANY_ID: 'COMPANY_ID',
  PLANT_ID: 'PLANT_ID',
  LINE_ID: 'LINE_ID',
  NICK_NAME: 'NICK_NAME',
  OPERATION_ID: 'OPERATION_ID',
  ELTR_LN_TP_CD: 'ELTR_LN_TP_CD',
} as const;

/**
 * Bottleneck 2번째 커서를 행에 병합하는 **키 조인** 축(03 R-11 / V-23).
 * AS-IS 는 행 인덱스 대응(`_tblBottleneckFlag.Rows[r]`, cs:1373)인데 **CURRENT SP 는 두 커서 모두
 * `ORDER BY` 가 없다**(03 §4.2 A) — 인덱스 대응을 이식하면 색이 엉뚱한 행에 칠해질 수 있다.
 */
export const BOTTLENECK_JOIN_KEYS: readonly string[] = [
  COLUMN.DV,
  COLUMN.DIVISION_ID,
  COLUMN.SITE_ID,
  COLUMN.COMPANY_ID,
  COLUMN.PLANT_ID,
  COLUMN.LINE_ID,
  COLUMN.NICK_NAME,
  COLUMN.OPERATION_ID,
  COLUMN.ELTR_LN_TP_CD,
];

/** Bottleneck 판정값 — `SCP_RPT_CAPA_LOB.ATTRIBUTE1`("neck공정여부") 를 피벗한 값(03 R-09). */
export const BOTTLENECK_FLAG_YES = 'Y';

/** 동적 기간 컬럼 접두 — 월 `M_01yyyymm` / 연 `Y_yyyy` (03 §2.2). */
export const PERIOD_PREFIX = { MONTH: 'M_', YEAR: 'Y_' } as const;

/** 동적 기간 컬럼 폭 — AS-IS `RefreshSpreadDateColumn(..., 80, ...)`(cs:1222, 03 R-06). */
export const PERIOD_COLUMN_WIDTH = 80;

/**
 * 기간 셀 숫자 포맷 — AS-IS `SetRowFormat(..., "###,##0.0", ...)`(cs:1386, 03 R-08).
 * 소수 1자리 + 천단위 구분 + `OmitZero=false`(0 을 빈칸 처리하지 않는다).
 * 메타 `DATA_SCALE_NUMBER` 가 44행 전건 NULL 이라 **코드 상수가 유일 출처**다(03 C-05 — 메타 INSERT 금지).
 */
export const PERIOD_NUMBER_FORMAT = 'n1';

// ====================================================================================
// 3단 헤더 (design 03 §2.5 / hook #93)
// ====================================================================================
//   AS-IS 는 1단 35 + 2·3단 각 20 = 75px 이지만 **TO-BE 표준 총높이 48px** 를 따른다(03 §2.5).
//   개별 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 헤더 row 마다 명시 height 를 박아
//   3단 전체가 1단 높이로 벌어진다. 높이는 DataGrid `headerRowHeight` prop 단일 출처다.
export const HEADER_DEPTH = 3;
export const HEADER_ROW_HEIGHT = 16; // 3단 x 16 = 총높이 48px

// ====================================================================================
// i18n — SCM_ADM_MSG_M 문구 역조회 실측 (goal.md §4-4, hook #114)
// ====================================================================================
//   AS-IS 번호를 그대로 쓰지 않는다. 이 화면에서 특히 위험한 3건:
//   - AS-IS MSG00097(권한 Division 0건) -> TO-BE 는 **MSG00667**. TO-BE MSG00097 은
//     "Please select Division." 로 전혀 다르다(메모리 msg00097-tobe-select-division-not-permission).
//   - AS-IS MSG00423(진행상태 Pre 조회 차단) -> **TO-BE 에 0건**. 문구 일치본은 **MSG01410**.
//   - AS-IS MSG00007/00008/00009/00010 -> TO-BE 같은 번호가 전혀 다른 문구다.
//     문구 역조회 확정본 = MSG01043 / MSG01044 / MSG01045 / MSG01046 (01 L-32).
export const MSG = {
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (AS-IS MSG00097, 01 L-04)
  PRE_VERSION_BLOCKED: 'MSG01410', // "... before {0}" (AS-IS MSG00423, 01 L-22)
  CANNOT_INSERT: 'MSG01044', // "Can not add as it is not in modify mode." (AS-IS MSG00008, 01 L-27)
  CANNOT_DELETE: 'MSG01045', // "... delete ..." (AS-IS MSG00009, 01 L-32)
  NO_PERMISSION: 'MSG00096', // "No permission." (AS-IS MSG00096 동일 의미, 01 L-28)
  // 콤보 조회 실패 — "권한 0건(MSG00667)" 과 반드시 구분한다. 실패를 권한 없음으로 오판하면
  //   네트워크 오류에 조회영역이 잠긴다(iter-1 G-03). 문구 역조회 실측:
  //   MSG01390 = "An error occurred while initializing the search conditions."
  COMBO_LOAD_FAIL: 'MSG01390',
  // 컬럼 메타(`SCM_MST_SHEET_COLUMNS`) 조회 실패 — 그리드가 컬럼 0개로 렌더되는 원인 표시(iter-1 G-11).
  //   MSG01052 = "An error has occurred when inquiring."
  COLUMN_META_FAIL: 'MSG01052',
  // 컬럼 개인화(`SCM_MST_TITLESET_USER`) 저장 실패 — 자매 SCP0104 와 같은 코드다.
  //   MSG00003 = "Failed to save."
  SAVE_FAIL: 'MSG00003',
} as const;

/**
 * "Module/Pack" 라디오 라벨 — `design/05_register.sql` 1b 블록이 등록하는 신규 채번 LBL.
 * 번호는 추측이 아니라 실측 채번이다(`ora.py`: `MSG_TP_CD='LBL'` 최대값 `LBL01142` -> 다음 `LBL01143`,
 * `LBL01143` 미존재 확인 2026-09-25). 자매 SCP0105/SCP0106 도 같은 번호를 공유한다(goal.md BLK-5).
 * `t()` 경유가 의무이며(hook #87 §L) 번들에 아직 키가 없어도 `defaultValue` 가 영문 표기를 유지한다.
 */
export const LBL_MODULE_PACK = 'LBL01143';

/**
 * `MSG01410` 의 `{0}` 치환값.
 * AS-IS 인자는 `new object[]{ "'Current" }`(닫는 따옴표 누락 오타, cs:1273)인데 **오타를 이식하지 않고**
 * `'Current'` 로 복원한다(01 L-22 · 00_checklist.md §2-b 주의 1).
 * i18next 기본 보간자는 `{{ }}` 라 DB 문구의 `{0}` 은 `.replace('{0}', ...)` 로 치환한다.
 */
export const PRE_VERSION_LABEL = '\'Current\'';

// ====================================================================================
// 컬럼 개인화 (ColumnLayoutModal) — 03 R-15/R-17
// ====================================================================================
//   AS-IS btnColumn -> SCM002_CAPAColumnPopup("SCP0108", _sheet_name, true) (cs:1614~1623).
//   `sheetName` 을 같이 넘겨야 CURRENT/CUTOFF 설정이 섞이지 않는다.
export const TITLESET_COLUMN_TYPE = 'C';

/**
 * 개인화 조회 키의 `divisionId` — 저장/조회/팝업 **3점이 같은 값**이어야 한다(`titleSetApi` 주석:
 * 다르면 저장은 되는데 재진입 조회가 그 행을 못 찾아 개인화가 사라진다).
 * 이 화면은 `ColumnLayoutModal` 에 `divisionId` 를 넘기지 않아 공용 기본값이 쓰인다
 * (`ColumnLayoutModal.tsx:117` `divisionId ?? '40'` / `fetchGridLayout` 도 동일) — store 의 복원
 * 호출은 `fetchTitleSet` 를 직접 쓰므로 그 기본값을 여기에 명시해 맞춘다.
 * 컬럼 메타 44행의 `DIVISION_ID` 는 전건 NULL 이라 이 값이 컬럼 분기에 쓰이지는 않는다(03 §1.0).
 */
export const TITLESET_DIVISION_ID = '40';
