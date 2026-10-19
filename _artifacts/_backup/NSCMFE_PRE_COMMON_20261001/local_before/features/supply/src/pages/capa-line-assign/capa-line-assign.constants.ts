export const MENU_ID = 'SCP0104' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0104_CAPA_Line_Assign (6,107줄) — CAPA Line Assign.
//   설계 근거: .atlas/gscm-design/SCP0104/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   전환 계획: .atlas/gscm-design/SCP0104/convert-flow/{goal,plan}.md. 상세 매핑: __asis-mapping__.md.
//
//   화면 축 3개(design 01 §0):
//     A. Division Type(Electrode/Cell/Module-Pack) = 모드 스위치. 시트·콤보·라벨·노출을 전부 가른다.
//     B. 탭(Line Assign / SOP) — AS-IS `tbcAll` 에 이벤트가 0건이라 탭 전환은 아무것도 트리거하지 않는다.
//     C. 편집모드 — 시트별 독립 플래그.
//
//   SP: PKG_SCP0104 (GET 6 / SAVE 4 / SPREAD_TITLE 1 / CHECK 3 = 14본) — **미배포**(goal.md ②).
//     조회·저장은 convert-sp 배포 후에야 런타임에서 동작한다.

/**
 * BE 라우팅 키(`SCM_ADM_MNU_BTN_MPG_M.SHT_NM`) — 컬럼 메타 시트명과 분리돼 있다.
 *
 * design 03 §5.1 C-2 는 7키(= `SCM_MST_SHEET_COLUMNS` 7 sheet)로 적었으나, Line 팝업은 컬럼 메타가
 * `LINE` 한 벌인 반면 SP 는 `..._GET_CAPA_LINE_ASSEMBLY` / `..._GET_CAPA_LINE_ELTR` 둘이라 한 키로
 * 두 SP 를 라우팅할 수 없다. 그래서 라우팅만 `LINE_ASSEMBLY`/`LINE_ELTR` 로 나누고 컬럼 메타는
 * {@link ADMIN_SHEET_NAME} 이 둘 다 `LINE` 으로 되돌린다. `SPREAD_TITLE` 도 그리드가 아니라
 * 동적 헤더 SP 라우팅 전용이다(DMF0044 `spreadTitle` 선례).
 */
export enum SHEETS {
  ASSEMBLY = 'ASSEMBLY', // spdAssign / Cell·Module-Pack
  ELTR = 'ELTR', // spdAssign / Electrode
  SOP_ASSEMBLY = 'SOP_ASSEMBLY', // spdSOP / Cell·Module-Pack
  SOP_ELTR = 'SOP_ELTR', // spdSOP / Electrode
  LINE_ASSEMBLY = 'LINE_ASSEMBLY', // P03 Line 팝업 / Cell·Module-Pack
  LINE_ELTR = 'LINE_ELTR', // P03 Line 팝업 / Electrode
  SOP_MODEL_ASSEMBLY = 'SOP_MODEL_ASSEMBLY', // P02 SOP Model 팝업 / Cell·Module-Pack
  SOP_MODEL_ELTR = 'SOP_MODEL_ELTR', // P02 SOP Model 팝업 / Electrode
  SPREAD_TITLE = 'spreadTitle', // 동적 기간컬럼 타이틀(그리드 아님)
}

/** NSCM 단일 cursor 표준 — 전 시트 `o_rc1`. */
export const RESPONSE_SET = 'o_rc1' as const;

/**
 * admin UI Category Setup(`SCM_MST_SHEET_COLUMNS.SHEET_NAME`) 시트명 — DB 실측 7종(design 03 §0.2).
 * 라우팅 키(SHEETS)와 값이 다른 곳이 Line 팝업 2키다(둘 다 `LINE` 메타를 공유).
 */
export const ADMIN_SHEET_NAME: Record<Exclude<SHEETS, SHEETS.SPREAD_TITLE>, string> = {
  [SHEETS.ASSEMBLY]: 'ASSEMBLY',
  [SHEETS.ELTR]: 'ELTR',
  [SHEETS.SOP_ASSEMBLY]: 'SOP_ASSEMBLY',
  [SHEETS.SOP_ELTR]: 'SOP_ELTR',
  [SHEETS.LINE_ASSEMBLY]: 'LINE',
  [SHEETS.LINE_ELTR]: 'LINE',
  [SHEETS.SOP_MODEL_ASSEMBLY]: 'SOP_MODEL_ASSEMBLY',
  [SHEETS.SOP_MODEL_ELTR]: 'SOP_MODEL_ELTR',
};

/** 컬럼 메타를 가진 그리드 시트 — `fetchStaticColumns` 대상(design 03 §4.1 I1). */
export const GRID_SHEETS: readonly Exclude<SHEETS, SHEETS.SPREAD_TITLE>[] = [
  SHEETS.ASSEMBLY,
  SHEETS.ELTR,
  SHEETS.SOP_ASSEMBLY,
  SHEETS.SOP_ELTR,
  SHEETS.LINE_ASSEMBLY,
  SHEETS.LINE_ELTR,
  SHEETS.SOP_MODEL_ASSEMBLY,
  SHEETS.SOP_MODEL_ELTR,
];

// ====================================================================================
// 축 A — Division Type (design 01 §0 / 02 §0-2)
// ====================================================================================
// AS-IS `rgrpDivisionType.SelectedIndex` (ScpCapa.cs:20-25). Designer 에 SelectedIndex 미지정이라
//   AS-IS 초기값은 -1 이고 헬퍼 else 분기가 서로 다른 값을 낸다(비일관) — 사용자 확정(U-6)으로
//   TO-BE 는 Electrode(0) 를 명시 기본값으로 둔다(자매 SCP0114 선례).
export const DIVISION_TYPE = {
  ELTR: 0,
  CELL: 1,
  MODULE_PACK: 2,
} as const;
export type DivisionType = (typeof DIVISION_TYPE)[keyof typeof DIVISION_TYPE];

export const DEFAULT_DIVISION_TYPE: DivisionType = DIVISION_TYPE.ELTR;

/** `ScpCapa.GetShopGroupId` (ScpCapa.cs:111-135) — 조회조건·콤보 필터의 shop_group. */
export const SHOP_GROUP_BY_DIVISION_TYPE: Record<DivisionType, 'E' | 'A' | 'P'> = {
  [DIVISION_TYPE.ELTR]: 'E',
  [DIVISION_TYPE.CELL]: 'A',
  [DIVISION_TYPE.MODULE_PACK]: 'P',
};

export type AssignSheet = SHEETS.ASSEMBLY | SHEETS.ELTR;
export type SopSheet = SHEETS.SOP_ASSEMBLY | SHEETS.SOP_ELTR;
export type LineSheet = SHEETS.LINE_ASSEMBLY | SHEETS.LINE_ELTR;
export type SopModelSheet = SHEETS.SOP_MODEL_ASSEMBLY | SHEETS.SOP_MODEL_ELTR;

/** Assign 그리드 시트 — `_sheet_idx` 파생(cs:2044-2057). */
export const ASSIGN_SHEET_BY_DIVISION_TYPE: Record<DivisionType, AssignSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.ASSEMBLY,
};

/** SOP 그리드 시트 — `'SOP_' + _sheet_name`. */
export const SOP_SHEET_BY_DIVISION_TYPE: Record<DivisionType, SopSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.SOP_ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.SOP_ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.SOP_ASSEMBLY,
};

/** P03 Line 팝업 시트. */
export const LINE_SHEET_BY_DIVISION_TYPE: Record<DivisionType, LineSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.LINE_ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.LINE_ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.LINE_ASSEMBLY,
};

/** P02 SOP Model 팝업 시트. */
export const SOP_MODEL_SHEET_BY_DIVISION_TYPE: Record<DivisionType, SopModelSheet> = {
  [DIVISION_TYPE.ELTR]: SHEETS.SOP_MODEL_ELTR,
  [DIVISION_TYPE.CELL]: SHEETS.SOP_MODEL_ASSEMBLY,
  [DIVISION_TYPE.MODULE_PACK]: SHEETS.SOP_MODEL_ASSEMBLY,
};

/** `p_sheet_name` 파라미터 값 — AS-IS `_sheet_name`(cs:249-263)은 시트 enum 문자열 그대로다. */
export const SHEET_PARAM_NAME: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: 'ELTR',
  [DIVISION_TYPE.CELL]: 'ASSEMBLY',
  [DIVISION_TYPE.MODULE_PACK]: 'ASSEMBLY',
};

// ====================================================================================
// 탭 (design 01 §2.2)
// ====================================================================================
export const TAB = {
  ASSIGN: 0,
  SOP: 1,
} as const;
export type TabIndex = (typeof TAB)[keyof typeof TAB];

// ====================================================================================
// 콤보 SQL_ID — TO-BE `SCM_ADM_CMBO_SQL_M` 실측 확정(design 02 §2.1 D01~D10, USE_YN='Y')
// ====================================================================================
// 주의(convert-core §2.6): 접미 `EE` 는 별개 콤보다. 마스터는 테이블 자체가 다르고
//   (`SCP_MST_CAPA_LINE` ↔ `SCP_MST_CAPA_ELTR_LINE`), Operation 은 `SHOP_GROUP_ID IN ('P','A')` ↔
//   `IN ('E')` 다. 이름이 비슷한 자매 콤보(`CapaLineMaster_SCP_ALL` 등) 재사용 금지.
export const COMBO = {
  DIVISION: 'Division_SCP',
  CAPA_VERSION: 'CapaVersion_SCP_ALL',
  MASTER: 'DummyCapaLineMaster_SCP_ALL',
  MASTER_EE: 'DummyCapaLineMasterEE_SCP_ALL',
  OPERATION: 'CapaOperationByLine_SCP_ALL',
  OPERATION_EE: 'CapaOperationByLineEE_SCP_ALL',
  ELECTRODE_TYPE: 'OperationElectrodeType_SCP_ALL',
  VALID: 'YesOrNo',
  // 주의(design 03 §6-2 FAIL): 이 콤보는 `CODE`/`NAME` 별칭이 **없다**
  //   (반환 = DIVISION_ID, OPERATION_GROUP, OPERATION_ID, ITEM_ID, ITEM_NAME, NICK_NAME).
  //   셀 콤보에 그대로 물리면 목록이 조용히 빈다 — FE 가 `NICK_NAME`/`ITEM_ID` 를 code 로 매핑한다.
  NICKNAME: 'CapaNickname_SCP_ALL',
  /** `SCP_MST_CAPA_DUMMY_CODE` — `DUMMY_YN` 자동 마킹의 판정 원천(F14, cs:3281-3288). */
  DUMMY_CODE: 'CapaDummyCode_SCP_ALL',
} as const;

/** `divisionType` 에 따라 SQL_ID 자체를 전환한다(재조회형 — queryKey 가 바뀐다, design 02 §5.4). */
export const MASTER_COMBO_BY_DIVISION_TYPE: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: COMBO.MASTER_EE,
  [DIVISION_TYPE.CELL]: COMBO.MASTER,
  [DIVISION_TYPE.MODULE_PACK]: COMBO.MASTER,
};

export const OPERATION_COMBO_BY_DIVISION_TYPE: Record<DivisionType, string> = {
  [DIVISION_TYPE.ELTR]: COMBO.OPERATION_EE,
  [DIVISION_TYPE.CELL]: COMBO.OPERATION,
  [DIVISION_TYPE.MODULE_PACK]: COMBO.OPERATION,
};

// AS-IS 클라 후처리 필터 — 이관된 CMBO SQL WHERE 에는 없다(convert-core §2.6 "핵심 원칙").
//   빠지면 후보 집합이 AS-IS 보다 넓어져 조회 범위가 달라진다.
/** `BLUtils.GetDivisionWithoutEE` → `DBUtils.Filter(res, "ATTRIBUTE3 <> 'EE'")` (BLUtils.cs:107-117). */
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';
/** 전 축 공통 — 더미 플레이스홀더 코드 제외(`CODE <> '-'`, design 02 §3.3). */
export const EMPTY_CODE = '-';
/** `DMY_` 접두 Dummy 코드는 정렬 맨 뒤(ScpCapaBL `GetSortedCode`, cs:81-136). */
export const DUMMY_CODE_PREFIX = 'DMY_';
/** Electrode 모드 Operation 후보에서 Formation 제외(`GetCodeFilterExceptFormation`, ScpCapaBL.cs:138-141). */
export const ELTR_EXCLUDED_OPERATION = 'AFFFF';
/** Electrode 모드 Line Type 선필터 — `GetElectrodeOperationFilter`(ScpCapaBL.cs:634-652). */
export const ELTR_LINE_TYPE_OPERATION = 'E2000';

/** 다중선택 sentinel. 서버로는 절대 나가지 않는다(§4.3 — 현재 후보 전체 CODE CSV 로 펼친다). */
export const ALL = 'ALL';

// ====================================================================================
// 컷오프 편집 게이트 (design 01 R-19~R-21)
// ====================================================================================
// `PROG_STAT` 은 `CapaVersion_SCP_ALL` 콤보 응답의 부가컬럼이다(실측 확정) — 별도 조회 불필요.
//   '-'(Pre)→'0' 승격은 표시용이라 재현하지 않고, 차단목록 방식으로만 등가 구현한다.
export const CUTOFF_PROG_STATS: readonly string[] = ['1', '2'];

// ====================================================================================
// 동적 기간컬럼 (design 03 §2)
// ====================================================================================
/** 동적 컬럼은 이 컬럼 **바로 뒤**에 삽입된다(`datePreColumnName`, cs:2178). */
export const DATE_PRE_COLUMN = 'DUMMY_YN';
/** 월 컬럼 접두 — `'M_01' + YYYYMM`(10자). */
export const MONTH_COLUMN_PREFIX = 'M_01';
/** 연 컬럼 접두 — `'Y_' + YYYY`(6자). */
export const YEAR_COLUMN_PREFIX = 'Y_';
/** 신규행의 동적 기간셀 기본값 — 전건 `"1"`(cs:5306-5309·5376-5380). */
export const NEW_ROW_DATE_CELL_VALUE = '1';
/** 3단 헤더 총높이 48px 고정(hook #93) → 단당 16px. */
export const ASSIGN_HEADER_ROW_HEIGHT = 16;
/**
 * 저장 차단 alert 의 `{0}` 자리에 넣는 축 이름 — 특정 컬럼 1개가 아니라 동적 기간컬럼 **축 전체**가
 * 비어 있다는 뜻이다(design 03 §4.3-d `YYYYMM` 공백). 컬럼명이 실행마다 달라 고정 라벨을 쓴다.
 */
export const DATE_COLUMN_AXIS_LABEL = 'YYYYMM';

// ====================================================================================
// 그리드 컬럼 상수 (design 03 §1·§3.3)
// ====================================================================================
export const COLUMN = {
  VER_ID: 'VER_ID',
  VER_SEQ: 'VER_SEQ',
  DIVISION_ID: 'DIVISION_ID',
  SITE_ID: 'SITE_ID',
  SITE_NAME: 'SITE_NAME',
  COMPANY_ID: 'COMPANY_ID',
  COMPANY_NAME: 'COMPANY_NAME',
  PLANT_ID: 'PLANT_ID',
  PLANT_NAME: 'PLANT_NAME',
  FACTORY_ID: 'FACTORY_ID',
  FACTORY_NAME: 'FACTORY_NAME',
  LINE_ID: 'LINE_ID',
  LINE_NAME: 'LINE_NAME',
  OPERATION_ID: 'OPERATION_ID',
  OPERATION_NAME: 'OPERATION_NAME',
  ELTR_LN_TP_CD: 'ELTR_LN_TP_CD',
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
  LANE_QTY: 'LANE_QTY',
  VALID_YN: 'VALID_YN',
  DUMMY_YN: 'DUMMY_YN',
  SOP_DT: 'SOP_DT',
  CHK: 'CHK',
} as const;

/** Assign 고정블록의 오른쪽 경계 — 이 컬럼까지가 신규행 전용 편집 구간(`_fixed_column_name`, cs:229-247). */
export const ASSIGN_FIXED_BOUNDARY_COLUMN = COLUMN.DUMMY_YN;
/** SOP 고정컬럼 — AS-IS 는 Assign 시트 인덱스를 잘못 쓰지만(R-33) TO-BE 는 컬럼명으로 정확히 잠근다. */
export const SOP_FIXED_COLUMN = COLUMN.ELTR_LN_TP_CD;

/** ELTR 신규행에서만 잠기는 컬럼 — G43(2025-03-31 개정, cs:5419-5422). */
export const ELTR_INSERT_LOCKED_COLUMN = COLUMN.NICK_NAME;

/** 편집모드·기존행에서도 편집 가능한 Assign 컬럼(G19·G20). ELTR 의 `LANE_QTY` 는 그 시트에만 있다. */
export const ASSIGN_ALWAYS_EDITABLE_COLUMNS: readonly string[] = [COLUMN.VALID_YN, COLUMN.LANE_QTY];
/** SOP 는 이 둘만 편집 가능(G22~G24). */
export const SOP_EDITABLE_COLUMNS: readonly string[] = [COLUMN.VALID_YN, COLUMN.SOP_DT];

/**
 * 편집모드에서만 노출되는 컬럼 (AS-IS `SetVisibleSheetColumns` cs:4371-4493 / design 03 §3.6 X-F).
 *
 * `SheetUtils.SetVisibleSheetColumn(si, IsEditModes[...], [8컬럼])` — 조회모드는 명칭 축만 보여주고
 * 편집모드에 들어가야 코드(ID) 축이 나타난다. Assign·SOP 두 시트 공통이다(`isPageSOP` 분기 양쪽 호출).
 */
export const EDIT_MODE_ONLY_COLUMNS: readonly string[] = [
  COLUMN.SITE_ID,
  COLUMN.SITE_NAME,
  COLUMN.COMPANY_ID,
  COLUMN.COMPANY_NAME,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
  COLUMN.OPERATION_ID,
];

/**
 * 조회모드에서 폭 0 으로 접히는 컬럼 — **메타 `ATTRIBUTE3='N'` 인 행만** 해당한다(cs:4416-4447·4459-4490).
 * Assign 탭 전용(SOP 분기에는 이 블록이 없다). 편집모드 복원 폭은 AS-IS 리터럴(40/120/140/120/120)이
 * 아니라 **메타 `COLUMN_WIDTH` 원값**을 쓴다 — 실측상 두 값이 일치하며(ora.py 2026-09-23), 메타를
 * 코드 리터럴로 덮어쓰지 않기 위함이다(CLAUDE.md §2 체크4).
 */
export const EDIT_MODE_WIDTH_RESTORE_COLUMNS: readonly string[] = [
  COLUMN.DIVISION_ID,
  COLUMN.LINE_NAME,
  COLUMN.PLANT_NAME,
  COLUMN.FACTORY_NAME,
  COLUMN.OPERATION_NAME,
];

/** 위 복원 대상을 가르는 메타 플래그 값 — `ATTRIBUTE3 = 'N'`("사용자 선택 고정컬럼 아님"). */
export const WIDTH_RESTORE_ATTRIBUTE3 = 'N';

/**
 * `SORT_ORDER_NO` 중복 시 적용할 2차 정렬키 (design 03 §1.3 마지막 note · §6-4 / GAP-06).
 *
 * `SCM_MST_SHEET_COLUMNS` 의 `SOP_ASSEMBLY` 는 `OPERATION_NAME` 과 `ELTR_LN_TP_CD` 가 **둘 다 150**
 * 이라 표시 순서가 비결정적이다(ora.py 실측 2026-09-23). `ELTR_LN_TP_CD` 가 `FIXED_FLAG='Y'` 라
 * 고정열 경계까지 흔들린다. 설계가 제시한 두 선택지("메타 값 정정" / "2차 정렬키 고정") 중 메타
 * UPDATE 는 사용자 승인 대상이므로 후자를 쓴다.
 *
 * 순서 값은 임의 배치가 아니라 **자매 시트 `SOP_ELTR` 실측**(OPERATION_NAME=150 / ELTR_LN_TP_CD=160)
 * 이다. 메타가 정정되면 이 맵은 같은 순서를 재확인할 뿐이라 무해하고, 그 시점에 삭제 대상이다.
 * 값(폭·노출 등)은 건드리지 않는다 — 순서만 결정적으로 만든다(CLAUDE.md §2 체크4).
 */
export const TIED_COLUMN_ORDER: Partial<Record<SHEETS, readonly string[]>> = {
  [SHEETS.SOP_ASSEMBLY]: [COLUMN.OPERATION_NAME, COLUMN.ELTR_LN_TP_CD],
};

// ====================================================================================
// Dummy 코드 채번 (design 03 §3.2 G14·G15 / K-11)
// ====================================================================================
/**
 * `SCP0104_CHECK_NAME_ON_DUMMY_CODE` 의 `p_code_tp` — AS-IS 실측(cs:3664·3681).
 * 나머지 축("S"/"C"/"P"/"F"/"L"/"O")은 AS-IS 에서 전부 주석 처리돼 호출되지 않는다.
 */
export const DUMMY_CODE_TYPE = {
  NICKNAME: 'N',
  ITEM: 'I',
} as const;
export type DummyCodeType = (typeof DUMMY_CODE_TYPE)[keyof typeof DUMMY_CODE_TYPE];

/** call-proc 경로의 버튼 코드 — `SCM_ADM_MNU_BTN_MPG_M(MNU_ID, SHT_NM, MNU_BTN_CD)` 등록명과 일치. */
export const DUMMY_CODE_BUTTON_CD = 'CHECK_NAME_ON_DUMMY_CODE';
/** `p_sheet_name` 은 라우팅 시트가 아니라 AS-IS 원문 그대로 `'MAIN'` 고정이다(cs:2975). */
export const DUMMY_CODE_SHEET_PARAM = 'MAIN';

// 셀 병합 대상 목록(`MERGE_COLUMNS` 11개)은 2026-09-23 iter-2 에서 **삭제**했다(GAP-07).
//   AS-IS 프레임워크 원천(`SpreadInfo.cs:11700`)이 컬럼 메타 기반 컬럼 전부에 `FPMerge.Restricted`
//   를 조건 없이 걸기 때문에 "고정블록 11개만" 은 추론이자 과소 병합이었다. 컬럼 단위 플래그를 세우던
//   `applyMergeFlags` 도 iter-3 에서 삭제했다(GAP-22 — 공용 DataGrid 가 일괄 재지정해 무효였다).
//   판정 근거와 TO-BE cascade 등가성은 `CapaLineAssignGrid` 의 `allowMerging` prop 주석에 있다.

/**
 * 셀 cascade — 상위 코드가 바뀌면 지우는 하위 컬럼(design 03 §3.2.1 실측 매트릭스).
 * 주의: `OPERATION_*` 은 `ELTR_LN_TP_CD` 만 지운다(2025-03-31 개정, cs:3804-3811).
 *   `NICK_NAME`/`ITEM_ID` 변경은 아무것도 지우지 않는다(cs:3799-3803 주석 처리).
 */
export const CASCADE_CLEAR_COLUMNS: Record<string, readonly string[]> = {
  [COLUMN.SITE_ID]: [
    COLUMN.COMPANY_ID,
    COLUMN.COMPANY_NAME,
    COLUMN.PLANT_ID,
    COLUMN.PLANT_NAME,
    COLUMN.FACTORY_NAME,
    COLUMN.FACTORY_ID,
    COLUMN.LINE_ID,
    COLUMN.LINE_NAME,
    COLUMN.NICK_NAME,
    COLUMN.ITEM_ID,
    COLUMN.OPERATION_ID,
    COLUMN.OPERATION_NAME,
    COLUMN.ELTR_LN_TP_CD,
  ],
  [COLUMN.COMPANY_ID]: [
    COLUMN.PLANT_ID,
    COLUMN.PLANT_NAME,
    COLUMN.FACTORY_NAME,
    COLUMN.FACTORY_ID,
    COLUMN.LINE_ID,
    COLUMN.LINE_NAME,
    COLUMN.NICK_NAME,
    COLUMN.ITEM_ID,
    COLUMN.OPERATION_ID,
    COLUMN.OPERATION_NAME,
    COLUMN.ELTR_LN_TP_CD,
  ],
  [COLUMN.PLANT_ID]: [
    COLUMN.FACTORY_NAME,
    COLUMN.FACTORY_ID,
    COLUMN.LINE_ID,
    COLUMN.LINE_NAME,
    COLUMN.NICK_NAME,
    COLUMN.ITEM_ID,
    COLUMN.OPERATION_ID,
    COLUMN.OPERATION_NAME,
    COLUMN.ELTR_LN_TP_CD,
  ],
  [COLUMN.FACTORY_ID]: [
    COLUMN.LINE_ID,
    COLUMN.LINE_NAME,
    COLUMN.NICK_NAME,
    COLUMN.ITEM_ID,
    COLUMN.OPERATION_ID,
    COLUMN.OPERATION_NAME,
    COLUMN.ELTR_LN_TP_CD,
  ],
  [COLUMN.LINE_ID]: [
    COLUMN.NICK_NAME,
    COLUMN.ITEM_ID,
    COLUMN.OPERATION_ID,
    COLUMN.OPERATION_NAME,
    COLUMN.ELTR_LN_TP_CD,
  ],
  [COLUMN.OPERATION_ID]: [COLUMN.ELTR_LN_TP_CD],
};

/** `*_ID` ↔ `*_NAME` 짝 — 코드↔명칭 양방향 동기(G06·G08~G13·G16). */
export const ID_NAME_PAIRS: readonly { id: string; name: string; masterId: string; masterName: string }[] =
  [
    { id: COLUMN.SITE_ID, name: COLUMN.SITE_NAME, masterId: 'SITE_ID', masterName: 'SITE_NAME' },
    {
      id: COLUMN.COMPANY_ID,
      name: COLUMN.COMPANY_NAME,
      masterId: 'COMPANY_ID',
      masterName: 'COMPANY_NAME',
    },
    { id: COLUMN.PLANT_ID, name: COLUMN.PLANT_NAME, masterId: 'PLANT_ID', masterName: 'PLANT_NAME' },
    {
      id: COLUMN.FACTORY_ID,
      name: COLUMN.FACTORY_NAME,
      masterId: 'FACTORY_ID',
      masterName: 'FACTORY_NAME',
    },
    { id: COLUMN.LINE_ID, name: COLUMN.LINE_NAME, masterId: 'LINE_ID', masterName: 'LINE_NAME' },
  ];

// ====================================================================================
// 저장 (design 03 §4.3)
// ====================================================================================
/** 행 사이 구분자. */
export const ROW_DELIMITER = '^';
/** 동적 기간컬럼 payload 의 행 내부 구분자. */
export const DATE_CELL_DELIMITER = ';';
/** ASSEMBLY 는 `p_item_id` 를 전건 `'-'` 로 보낸다(cs:4991). */
export const SAVE_ITEM_ID_ASSEMBLY = '-';
/** `p_prog_stat` 는 `'0'` 고정 — SP 본문 미참조(cs:5011). */
export const SAVE_PROG_STAT = '0';

// ====================================================================================
// i18n — `SCM_ADM_MSG_M` 문구 역조회 실측(hook #114, design 01 §5.1-A / 03 §4.4)
// ====================================================================================
// 주의: AS-IS 번호를 그대로 쓰지 않는다. 저장 성공은 AS-IS MSG00004 지만 TO-BE MSG00004 는
//   "No changes to save." 다 — 번호가 아니라 문구로 매핑한다.
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved."      (AS-IS MSG00004)
  SAVE_FAIL: 'MSG00003', // "Failed to save."         (AS-IS MSG00006, TO-BE 미등록)
  NO_CHANGES: 'MSG00004', // "No changes to save."    (AS-IS MSG00133)
  CUTOFF_READONLY: 'MSG00109', // "Read-only mode."   (AS-IS MSG00109 — 번호·의미 모두 일치)
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." — TO-BE MSG00097 은
  //   "Please select Division." 이라 재사용 금지(hook #114 재번호 함정, design 01 R-22)
} as const;

/** 조회조건·탭 라벨 — design 02 §4.5 실측 16건 + 01 §5.1-A. */
export const LBL = {
  DIVISION: 'LBL00641',
  PLAN_MONTH: 'LBL00053',
  VERSION: 'LBL00606',
  PLAN_TYPE: 'LBL00040',
  ELECTRODE: 'LBL00038',
  CELL: 'LBL01059',
  SITE: 'LBL00015',
  PLANT: 'LBL00030',
  BUILDING: 'LBL00008',
  LINE: 'LBL00010',
  OPERATION: 'LBL00009',
  LINE_TYPE: 'LBL00056',
  BASIC_NICKNAME: 'LBL00054',
  MODEL: 'LBL00669',
  VALID: 'LBL00639',
  ALL: 'LBL00632',
  TAB_LINE_ASSIGN: 'LBL00769',
  SEARCH: 'LBL00664',
  EDIT: 'LBL00414',
  COLUMN_SETTING: 'LBL00605',
} as const;

// 미등록 라벨 — `SCM_ADM_MSG_M` 실측 0행. 임의 INSERT 금지(convert-core §2.3)이므로
//   등록 전까지 영문 defaultValue 를 그대로 쓴다(design 02 §4.5 / 01 §5.1-A).
//   · `Module/Pack` : LBL00379(`Module`)는 등가가 아니라 재사용 금지.
//   · SOP 탭 라벨   : `MSG_TP_CD='LBL'` 전건 역조회 0건.
export const FALLBACK_LABEL = {
  MODULE_PACK: 'Module/Pack',
  TAB_SOP: 'SOP',
} as const;

/** Plan Type 파생 표시(design 02 §5.2 S04) — `BIZ_PLAN_USE_YN='Y' ? 'BP' : 'RP'`, 기본 `'RP'`. */
export const PLAN_TYPE = { BIZ: 'BP', ROLLING: 'RP' } as const;

/** 컬럼 개인화(titleSet) 3점 일치 키 — 조회·저장·복원이 전부 이 값을 쓴다(hook #115, §5-9). */
export const TITLESET_COLUMN_TYPE = 'C' as const;

/** SubTitle/Excel 파일명. */
export const EXCEL_FILE_NAME = 'CapaLineAssign';
