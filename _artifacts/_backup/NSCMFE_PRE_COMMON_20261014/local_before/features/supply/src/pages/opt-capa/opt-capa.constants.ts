export const MENU_ID = 'SCP0126' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0126_CAPA/SCP0126_CAPA.cs (3,865줄) — OPT CAPA.
//   설계: .atlas/gscm-design/SCP0126/design/00_checklist.md ~ 03_grid-columns.md
//   계획: .atlas/gscm-design/SCP0126/convert-flow/{goal,plan}.md · 매핑: __asis-mapping__.md
//
//   화면 축 3개(design 01 §0):
//     A. 활성 시트(8탭) — 조회/저장 SP · 컬럼셋 · 편집잠금 · 전용버튼 노출 · Plant/Operation 후보
//     B. Division      — 탭 집합(add/remove) · Batch Save 노출 · 컬럼 표시 · 행/열 잠금 · 셀콤보 후보
//     C. 편집모드      — 시트별 독립 boolean (탭을 바꿔도 다른 시트 편집상태가 남는다)
//
//   SP: PKG_SCP0126 (GET 10 / SAVE 9 / EXCEL_UPLOAD 1 = 21본) — PACKAGE + BODY 둘 다 VALID.
//     `SCM_ADM_MNU_BTN_MPG_M` 20행(SHT_NM 11종 × SEARCH/SAVE) 배선 완료 → convert-sp 후속 불요.

/**
 * BE 라우팅 키(`SCM_ADM_MNU_BTN_MPG_M.SHT_NM`, ora.py 실측 11종 camelCase).
 *
 * 컬럼 메타 시트명({@link ADMIN_SHEET_NAME})과 **값이 다르다** — 한쪽을 다른 쪽에 쓰면 조회가
 * 0건이 되거나 131행 컬럼 메타가 안 붙어 그리드가 빈 채로 뜬다(design 03 §0.1, 자매 SCP0114 선례).
 * `'main'` 단일시트 표준이 적용되지 않는 화면이다(convert-core §2.4 / hook #73).
 */
export enum SHEETS {
  /** 조회조건 마스터 6커서 — 그리드 아님(IN 0개). */
  INIT = 'init',
  NO_WORK = 'noWork',
  DAILY_CAPA = 'dailyCapa',
  SOP_EOP = 'sopEop',
  RAMP_UP = 'rampUp',
  RAMP_UP_ITVL = 'rampUpItvl',
  PREP_RT = 'prepRt',
  UTIL_RT = 'utilRt',
  YLD_ELEC = 'yldElec',
  /** No Work 일괄저장 팝업(SAVE 전용) — AS-IS `SCP0126_NoWork_BatchPopup`. */
  NO_WORK_BATCH = 'noWorkBatch',
  /**
   * Week 입력 모드 — AS-IS 워킹트리 `.cs` 에 소비자 0건(design 03 §6-L1 / goal.md B-5).
   * TO-BE 에 GET/SAVE 가 배포·배선돼 있으나 UI 사양을 소스로 확인할 수 없어 **이번 전환 범위 밖**이다.
   * 라우팅 키만 유니온에 남겨 `procedures.d.ts` 와 정합을 맞춘다(사양 확정 시 탭 추가).
   */
  NO_WORK_WEEK = 'noWorkWeek',
}

/** 그리드 8탭 — `SCM_MST_SHEET_COLUMNS` 에 컬럼 메타가 있는 시트(131행 / 8 sheetNm). */
export type GridSheet =
  | SHEETS.NO_WORK
  | SHEETS.DAILY_CAPA
  | SHEETS.SOP_EOP
  | SHEETS.RAMP_UP
  | SHEETS.RAMP_UP_ITVL
  | SHEETS.PREP_RT
  | SHEETS.UTIL_RT
  | SHEETS.YLD_ELEC;

/**
 * 탭 순서 = AS-IS `CreateSpread` 의 `AddSheet` 순서(cs:565-599).
 * 주의: Division 변경 시 복원 목록 `_spdSheets`(cs:269-277)는 idx 5·6 이 뒤바뀐 별개 배열이지만,
 *   제외목록 단일 원천으로 파생하면 순서는 이 배열 하나로 통일된다(design 01 R13·R14).
 */
export const GRID_SHEETS: readonly GridSheet[] = [
  SHEETS.NO_WORK,
  SHEETS.DAILY_CAPA,
  SHEETS.SOP_EOP,
  SHEETS.RAMP_UP,
  SHEETS.RAMP_UP_ITVL,
  SHEETS.PREP_RT,
  SHEETS.UTIL_RT,
  SHEETS.YLD_ELEC,
];

/** 초기 활성 시트 — AS-IS `_sActiveSheetName = "No Work"`(cs:249) + `ChangeSheet()`(cs:615). */
export const DEFAULT_SHEET: GridSheet = SHEETS.NO_WORK;

/**
 * admin 컬럼 메타 시트명(`SCM_MST_SHEET_COLUMNS.SHEET_NAME`) — AS-IS 표시명 그대로.
 * 공백·슬래시·괄호 포함. `fetchStaticColumns` / `DataGrid sheetName` / 엑셀 메타가 이 값을 쓴다.
 */
export const ADMIN_SHEET_NAME: Record<GridSheet, string> = {
  [SHEETS.NO_WORK]: 'No Work',
  [SHEETS.DAILY_CAPA]: 'Daily Capa',
  [SHEETS.SOP_EOP]: 'SOP/EOP',
  [SHEETS.RAMP_UP]: 'Ramp-up(From/To)',
  [SHEETS.RAMP_UP_ITVL]: 'Ramp-up(Interval)',
  [SHEETS.PREP_RT]: 'Preparation Rate',
  [SHEETS.UTIL_RT]: 'Utilization Rate',
  [SHEETS.YLD_ELEC]: 'Yield(Elec.)',
};

/**
 * 탭 라벨 — 8 시트명에 대응하는 `LBL` 이 `SCM_ADM_MSG_M`·locale 번들 양쪽에 **0건**이다
 * (design 01 §5 V-7 실측). 임의 INSERT 금지(convert-core §2.3)이므로 AS-IS 시트명 문자열을
 * 영문 fallback 으로 그대로 쓴다. 자매 선례 `capa-line-assign` SOP 탭 라벨.
 */
export const SHEET_LABEL: Record<GridSheet, string> = ADMIN_SHEET_NAME;

/** NSCM 단일 cursor 표준. `init` 만 `o_rc1`~`o_rc6` 다(소문자 — `SCM_ADM_PROC_M.COL_NM` 실측). */
export const RESPONSE_SET = 'o_rc1' as const;

/** 다중선택 sentinel. 서버로는 나가지 않는다 — `setFilters` 가 공백 또는 전 CODE CSV 로 펼친다. */
export const ALL = 'ALL';

// ====================================================================================
// 조회조건 콤보 SQL_ID — `SCM_ADM_CMBO_SQL_M` 실측 확정(design 02 §2.1·§2.2)
// ====================================================================================
// 주의(convert-core §2.6): `Division_SCP` 만 정본이다. `MyDivision`/`Division_SCP_NoEE`/
//   `AllDivision_SCP` 는 EE 계열 제외 또는 권한필터 소실이라 이 화면에서 **재사용 금지** —
//   `EE_UC` 가 사라지면 이 화면의 핵심 분기(R-05·R-06·R-07·R04)가 통째로 죽는다(SCP0006 실사고).
export const COMBO = {
  DIVISION: 'Division_SCP',
  /** Owner(`@sesUserId`) 필터 **추가 금지** — AS-IS 가 `p_user_id=''` 고정이다(hook #128). */
  PLAN_GROUP: 'PlanGroup_SCP_ALL',
} as const;

// ====================================================================================
// AS-IS 업무 리터럴 — 메타 축이 없는 코드 분기이므로 리터럴 보존이 정답이다
// ====================================================================================
/**
 * `RefreshPlantIdByDivision` cs:358 / `RefreshPlantIdByCombo` cs:403 / `RefreshLine` cs:443 /
 * `RefreshLineByCombo` cs:481 — **`EE_UC` 일 때만** 후보 필터 축을 `ORG_DIVISION_ID` 로 바꿔
 * 같은 company 의 비-EE division(`81_UC`) 마스터까지 끌어온다(PJ20257329, 2025-11-05).
 *
 * 다른 EE 계열로 일반화하면 AS-IS 와 후보 집합이 달라진다 — ora.py 실측(2026-09-25) 결과
 * `EE` 의 `ORG_DIVISION_ID` 는 40/81/82 **3건으로 갈라져** 축을 바꾸면 후보가 폭증한다.
 * hook #113 이 금지하는 것은 "컬럼 표시 메타를 코드 화이트리스트로 대체" 하는 것이고, 이 값은
 * 대응 메타가 존재하지 않는 AS-IS 필터 분기라 대상이 아니다(goal.md §5-3 근거주석 조건 충족).
 */
export const ORG_DIVISION_FALLBACK_DIVISION = 'EE_UC';

/**
 * `SetVisibleSheetColumns` cs:731·739 는 `division.IndexOf("EE_UC")>=0` / `IndexOf("EE")>=0`
 * **부분문자열** 비교이고, 잠금·기본값 분기(cs:887·901·994·1017·1030·3811)는 `!= "EE_UC"`
 * **완전일치** 비교다. 두 비교가 다르므로 같은 상수로 뭉치지 않는다.
 *
 * `EE_DIVISION_TOKEN` 은 저장 분기(cs:1569 `division_id == "EE"`) 전용이다 — 이쪽은 **행의**
 * `DIVISION_ID` 와 **완전일치** 비교이며 조회조건 division 과 무관하다({@link optCapa.save}
 * `isElectrodeCapaRow`). 컬럼 표시 토글(부분문자열)은 코드가 아니라 메타
 * `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 콤마 토큰이 담당한다(hook #113 / 05_register.sql [블록 4]).
 */
export const EE_UC_DIVISION_TOKEN = 'EE_UC';
export const EE_DIVISION_TOKEN = 'EE';

/** `RefreshPlantIdByDivision` cs:369 / `RefreshPlantIdByCombo` cs:416 / `RefreshOperationByDivision` cs:526. */
export const OSP_EXCLUDE_DIVISION = '82';
/** `O_RC1`/`O_RC3` 의 OSP UNION 분기는 `SEQ=2` — 정규 후보만 남기는 값(2025-09-03). */
export const PLANT_SEQ_NORMAL = '1';
/** OSP 제외가 걸리는 활성 시트 2종(cs:372·419·529). */
export const OSP_EXCLUDE_SHEETS: readonly GridSheet[] = [SHEETS.DAILY_CAPA, SHEETS.NO_WORK];

/** Daily Capa 행 잠금 분기축 — `operation_id == "E2000"`(cs:857). */
export const COATING_OPERATION_ID = 'E2000';
/** 비EE_UC 신규행 `LINE_TYPE` 기본값(cs:996·1019). */
export const LINE_TYPE_DEFAULT = '-';
/** 신규행 `VALID_YN` 기본값(cs:999·1022·1039·1049). */
export const VALID_YN_DEFAULT = 'Y';

/**
 * Daily Capa **저장 시** 강제주입 기본값 — AS-IS `Save_DailyCapa` 리터럴 그대로
 * (cs:1599 `capa = "0.0"` / cs:1662-1664 `m_min="0"; lane="0"; wide_yn="Y"`).
 *
 * 신규행 기본값(`Insert_Row`)과 다른 축이다 — 사용자가 셀에 무슨 값을 넣었든 저장 직전에
 * **덮어쓴다**. 전극(`EE` 계열) 분기에서는 `CAPA` 가 업무상 무의미하고 그 반대쪽에서는
 * `M_MIN`/`LANE`/`WIDE_YN` 이 무의미하기 때문이며, SAVE SP 는 받은 값을 그대로 INSERT/UPDATE
 * 하므로(PKG_SCP0126 BODY:2989-3053) 화면이 주입하지 않으면 AS-IS 와 다른 마스터가 적재된다.
 */
export const DAILY_CAPA_SAVE_DEFAULT = {
  CAPA: '0.0',
  M_MIN: '0',
  LANE: '0',
  WIDE_YN: 'Y',
} as const;

/** `SOP/EOP` 의 `TYPE` 셀 콤보 후보 — AS-IS 클라 리터럴 2행(cs:233-245). */
export const SOP_EOP_TYPE_CANDIDATES: readonly string[] = ['SOP', 'EOP'];
/** `No Work` 의 `FIX` 셀 콤보 후보 — AS-IS 클라 리터럴 2행(공백/`Y`, cs:253-265). */
export const FIX_CANDIDATES: readonly string[] = ['', 'Y'];

/** `DAY_OF_WEEK` 파생 — `ToString("ddd", InvariantCulture).ToUpper()`(cs:3630). locale 의존 금지. */
export const DAY_OF_WEEK_LABELS: readonly string[] = [
  'SUN',
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
];

/** Period 기본 구간 — 당월 ~ +12개월(cs:226-227). */
export const PERIOD_MONTHS_AHEAD = 12;
/** 소수 자릿수 상한 — 11자리 이상 금지 = 10자리까지 허용(design 03 §4.4 V-12·V-56). */
export const MAX_DECIMAL_SCALE = 10;

// ====================================================================================
// 그리드 컬럼 (design 03 §1 — 8 sheetNm / 131행)
// ====================================================================================
export const COLUMN = {
  DIVISION_ID: 'DIVISION_ID',
  OPMZ_PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  PLANT_ID: 'PLANT_ID',
  LINE_ID: 'LINE_ID',
  LINE_NAME: 'LINE_NAME',
  OPERATION_ID: 'OPERATION_ID',
  LINE_TYPE: 'LINE_TYPE',
  NICK_NAME: 'NICK_NAME',
  ITEM_ID: 'ITEM_ID',
  NO_WORK_DATE: 'NO_WORK_DATE',
  DAY_OF_WEEK: 'DAY_OF_WEEK',
  WEEK_NAME: 'WEEK_NAME',
  OFF_TIME: 'OFF_TIME',
  NO_WORK_TYPE: 'NO_WORK_TYPE',
  TYPE: 'TYPE',
  DATE: 'DATE',
  START_DATE: 'START_DATE',
  END_DATE: 'END_DATE',
  FROM_DATE: 'FROM_DATE',
  TO_DATE: 'TO_DATE',
  YYYYMM: 'YYYYMM',
  CAPA: 'CAPA',
  M_MIN: 'M_MIN',
  LANE: 'LANE',
  WIDE_YN: 'WIDE_YN',
  PRDN_OPER_RT: 'PRDN_OPER_RT',
  EFCY: 'EFCY',
  ITVL1: 'ITVL1',
  ITVL2: 'ITVL2',
  ITVL3: 'ITVL3',
  ITVL4: 'ITVL4',
  EFCY1: 'EFCY1',
  EFCY2: 'EFCY2',
  EFCY3: 'EFCY3',
  EFCY4: 'EFCY4',
  PREP_RT: 'PREP_RT',
  UTIL_RT: 'UTIL_RT',
  ELEC_POST: 'ELEC_POST',
  ASSY: 'ASSY',
  DESC: 'DESC',
  VALID_YN: 'VALID_YN',
  FIX: 'FIX',
  SEQ: 'SEQ',
  PRE_KEY_VALUES: 'PRE_KEY_VALUES',
} as const;

/**
 * `PRE_KEY_VALUES` 파이프 결합 순서 — **GET SP 본문 실측**(`ALL_SOURCE` PACKAGE BODY
 * 628·801·1199·1404·1605·1784·1964·2184). SAVE SP 의 `pre*` 파라미터 순서와 1:1 이라
 * 파싱 결과를 그대로 `pre*` 에 싣는다(design 03 §4.3).
 *
 * 주의: 날짜/월 키는 **표시 포맷이 아니라 원본**이다(`NO_WORK_DATE` 8자리 / `YYYYMM` 6자리).
 *   현재 키와 대조할 때는 `-` 를 떼고 비교해야 한다(R-22 키변경 검사).
 */
export const PRE_KEY_COLUMNS: Record<GridSheet, readonly string[]> = {
  [SHEETS.NO_WORK]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.LINE_TYPE,
    COLUMN.NO_WORK_DATE,
  ],
  [SHEETS.DAILY_CAPA]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.ITEM_ID,
    COLUMN.YYYYMM,
  ],
  [SHEETS.SOP_EOP]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.LINE_TYPE,
    COLUMN.ITEM_ID,
    COLUMN.TYPE,
    COLUMN.DATE,
  ],
  [SHEETS.RAMP_UP]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.LINE_TYPE,
    COLUMN.ITEM_ID,
    COLUMN.START_DATE,
    COLUMN.END_DATE,
  ],
  [SHEETS.RAMP_UP_ITVL]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.LINE_TYPE,
    COLUMN.ITEM_ID,
    COLUMN.START_DATE,
  ],
  [SHEETS.PREP_RT]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.FROM_DATE,
    COLUMN.TO_DATE,
  ],
  [SHEETS.UTIL_RT]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.LINE_ID,
    COLUMN.OPERATION_ID,
    COLUMN.FROM_DATE,
    COLUMN.TO_DATE,
  ],
  [SHEETS.YLD_ELEC]: [
    COLUMN.DIVISION_ID,
    COLUMN.PLANT_ID,
    COLUMN.ITEM_ID,
    COLUMN.YYYYMM,
  ],
};

/** `PRE_KEY_VALUES` 구분자. */
export const PRE_KEY_DELIMITER = '|';

/**
 * 기간 중첩 검사 축(R-23) — 동일 키 집합 안에서 기간이 4방향 중 하나로 겹치면 차단.
 * 대상은 시작·종료가 **쌍으로** 있는 3시트뿐이다(cs:2136-2173 · 2694-2730 · 2950-2986).
 * `Ramp-up(Interval)` 은 `START_DATE` 단일이라 중첩 개념이 없다.
 */
export const PERIOD_RANGE_COLUMNS: Partial<
  Record<GridSheet, { readonly start: string; readonly end: string }>
> = {
  [SHEETS.RAMP_UP]: { start: COLUMN.START_DATE, end: COLUMN.END_DATE },
  [SHEETS.PREP_RT]: { start: COLUMN.FROM_DATE, end: COLUMN.TO_DATE },
  [SHEETS.UTIL_RT]: { start: COLUMN.FROM_DATE, end: COLUMN.TO_DATE },
};

/** 표시 포맷이 `YYYY-MM-DD` 인 일자 컬럼 — 저장 시 `-` 제거 8자리로 환원(design 03 §4.2). */
export const DATE_DISPLAY_COLUMNS: readonly string[] = [
  COLUMN.NO_WORK_DATE,
  COLUMN.DATE,
  COLUMN.START_DATE,
  COLUMN.END_DATE,
  COLUMN.FROM_DATE,
  COLUMN.TO_DATE,
];

/** 표시 포맷이 `YYYY-MM` 인 월 컬럼(Yield 만 — Daily Capa 는 원본 그대로다, design 03 §4.2). */
export const MONTH_DISPLAY_COLUMNS: readonly string[] = [COLUMN.YYYYMM];

/**
 * 음수 금지 숫자 컬럼 — AS-IS 실측 **3건뿐**이다(iter-3 감사 G3-6 정정, 2026-09-26):
 *   · `OFF_TIME` cs:1362-1369 (`int.Parse` + `< 0` → MSG00050)
 *   · `LANE`     cs:1603 · 1634-1638
 *   · `CAPA`     cs:1667-1674
 *
 * 공용 `CheckDouble`(cs:3312-3384)에는 음수 분기가 **0건**이고 `ITVL1~4` 는 `Save_Rampup_Itvl`
 * (cs:2380-2470)에서 검증 자체가 없다(`EFCY1~4` 만 `CheckDouble` 대상). iter-1~3 이 18컬럼으로
 * 넓혀 두었던 것은 AS-IS 초과 차단이라 되돌린다 — 초과 차단은 "AS-IS 가 통과시키는 저장"을
 * 막으므로 파리티 위반이다(convert-core §2.4).
 *
 * 주의: Daily Capa 의 `LANE`/`CAPA` 는 **`isElectrodeCapaRow` 분기 안에서만** 검사한다
 * (cs:1569 분기). 분기 밖에서 보면 `applyDailyCapaSaveRules` 가 어차피 덮어쓸 값까지 막는다 —
 * 그 분기 판정은 `useOptCapaValidation.findValueProblem` 이 한다.
 */
export const NON_NEGATIVE_COLUMNS: readonly string[] = [
  COLUMN.OFF_TIME,
  COLUMN.LANE,
  COLUMN.CAPA,
];

/**
 * 소수 11자리 이상 금지 컬럼(design 03 §4.4 V-12·V-56).
 * `M_MIN` 은 Daily Capa 컬럼이라 `NON_NEGATIVE_COLUMNS` 와 같은 전극 분기 제한을 받는다
 * (AS-IS 가 `CheckDouble(m_min)` 을 전극 분기 안에서만 부른다, cs:1573-1603).
 */
export const DECIMAL_SCALE_COLUMNS: readonly string[] = [
  COLUMN.M_MIN,
  COLUMN.ELEC_POST,
  COLUMN.ASSY,
];

/**
 * 셀 콤보 6종 — **FE 주입** 대상(`beginningEdit` 에서 `column.dataMap` 을 세운다).
 *
 * AS-IS 는 이 콤보들을 메타가 아니라 `SheetUtils.SetComboDataRow`(cs:3782-3828)로 **행 클릭
 * 시점에** 붙인다 — 후보가 조회조건 division·선택 Plant·활성 시트·그 행의 상위 셀에 동시에
 * 종속되므로(R-19·R-20·R-21) `SCM_ADM_CMBO_SQL_M` + `comboParams` 로는 등가가 되지 않는다
 * (design 03 §6 Q6 의 의문 지점). 그래서 자매 `capa-line-assign` 선례대로 FE 주입으로 재현한다.
 * → CMBO_SQL 신규 등록 0건 / `CELL_CONTROL_OBJECT_TYPE_CODE` 메타 무변경(04 리포트 D-2 결정).
 *
 * `VALID_YN`·`WIDE_YN` 은 메타(`FPComboBox` + `YesOrNo`)가 이미 정상 동작하므로 제외한다.
 */
export const CELL_COMBO_COLUMNS: readonly string[] = [
  COLUMN.PLANT_ID,
  COLUMN.LINE_ID,
  COLUMN.OPERATION_ID,
  COLUMN.LINE_TYPE,
  COLUMN.FIX,
  COLUMN.TYPE,
];

// ====================================================================================
// Excel Form / Upload (design 01 R05·R06)
// ====================================================================================
/**
 * `SCM_ADM_EXCEL_COLUMNS(PROGRAM_ID='SCP0126', SHEET_NAME='No Work').HEADER_CONTENT` 실측값.
 * BE `FileServiceImpl` 가 헤더를 **이름으로 조회**하므로 토큰 원형을 1바이트도 변형하지 않는다
 * (hook #135). AS-IS 는 HelpServer 의 고정 `NoWork_ExcelForm.xls` 를 내려줬는데(cs:3841-3844 →
 * BaseForm.cs:5300-5311) TO-BE 에는 그 호스팅이 없어 표준대로 클라에서 생성한다(§5 V-6).
 */
export const EXCEL_FORM_HEADER_TOKENS: readonly string[] = [
  'Div*',
  'Plant ID*',
  'Line ID*',
  'Operation ID*',
  'Line Type*',
  'Date(YYYYMMDD)*',
  'Off Time(Day)*',
  'Type',
  'Desc',
  'Valid',
  'Fix',
];

export const EXCEL_FORM_FILE_NAME = 'SCP0126_NoWork_ExcelForm';
export const EXCEL_FILE_NAME = 'OPT_CAPA';

// ====================================================================================
// Batch Save 팝업 (AS-IS SCP0126_NoWork_BatchPopup.cs)
// ====================================================================================
/** 팝업 그리드 컬럼 — AS-IS `InitSpread` cs:159-162(컬럼 메타 미등록 시트라 코드가 정본이다). */
export const BATCH_GRID_COLUMNS: readonly { key: string; label: string; align: 'L' | 'R' | 'C'; width: number }[] =
  [
    { key: COLUMN.SEQ, label: 'Seq', align: 'R', width: 60 },
    { key: COLUMN.DAY_OF_WEEK, label: 'Day Of Week', align: 'C', width: 100 },
    { key: COLUMN.OFF_TIME, label: 'Off Time', align: 'R', width: 100 },
    { key: COLUMN.DESC, label: 'Desc', align: 'L', width: 200 },
  ];

/** 행 생성 순서 — AS-IS `_dayOfWeek[0..6]`(BatchPopup cs:122-129). 월요일 시작이다. */
export const BATCH_DAY_OF_WEEK: readonly string[] = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN',
];
export const BATCH_DEFAULT_WEEKS = '1';
export const BATCH_DEFAULT_OFF_TIME = '0';
/**
 * Batch SAVE 구분자 — **CLOB 축과 VARCHAR 축이 다르다**(배포 SP 본문 실측, `ALL_SOURCE` 2026-09-26).
 *
 * `P_SCP0126_SAVE_NO_WORK_BATCH` 는 파라미터 타입에 따라 쪼개는 문자가 갈린다:
 *   · CLOB 4종(`seq`/`offTime`/`type`/`desc`) -> `P_SPLIT(P_SEQ, '^', ...)` (BODY:3447-3450)
 *   · VARCHAR `lineId`                       -> `TABLE(STRING_SPLIT(P_LINE_ID, ','))` (BODY:3467)
 *
 * 하나로 합쳐 쓰면(iter-1~4 상태: 둘 다 `','`) 행 패턴 CLOB 이 `'1,2,3'` 한 덩어리로 들어가
 * `F_INT` 의 `REGEXP_LIKE(P_VALUE, '^[+-]?[0-9]+$')`(BODY:2300)에서 `INVALID_NUMBER` 가 나고
 * `EXCEPTION WHEN OTHERS` 로 잡혀 `CODE=-1` 이 된다 - Batch Save 100% 실패
 * (`05_runtime-parity.md` RP-3). 그래서 두 상수로 분리한다.
 */
export const BATCH_ROW_DELIMITER = '^';
/** 다중 Line 결합 구분자 — `lineId` 는 VARCHAR 이고 SP 가 `STRING_SPLIT(...,',')` 로 쪼갠다. */
export const BATCH_LINE_DELIMITER = ',';

// ====================================================================================
// i18n — 문구 역조회 실측(hook #114). AS-IS 번호를 그대로 쓰지 않는다.
// ====================================================================================
// `SCM_ADM_MSG_M`(LANG_CD EN) + 런타임 정본인 정적 번들 `public/locales/{EN,KO}.json` 양쪽에서
//   전건 존재 확인(2026-09-25). **신규 등록 0건.**
export const MSG = {
  /** AS-IS MSG00344(Period 선택이 잘못되었습니다) → KO 문구 완전 일치. `MSG00344` 는 TO-BE 미등록. */
  PERIOD_INVALID: 'MSG01340',
  /** AS-IS MSG00129 → TO-BE MSG00129 는 `{0}` 없는 플레이스홀더라 재사용 금지(design 01 R10). */
  SHEET_CHANGE_BLOCKED: 'MSG01149',
  /** TO-BE MSG00097 은 "Please select Division." 이라 권한 게이트에 쓰면 안 된다(design 01 R01). */
  NO_DIVISION_AUTH: 'MSG00667',
  /**
   * AS-IS MSG00002(필수 입력 {0}) → TO-BE MSG00002 는 "Saved successfully." 로 정반대 의미다.
   * 실측 문구 `{0} value is required.`(ora.py `SCM_ADM_MSG_M`) — 공용
   * `useSaveWithValidation` 이 쓰는 `CRUD_MSG.REQUIRED_FIELD.id` 와 **같은 값**이라
   * 화면 로컬 필수검증(D-3)과 공용 경로의 문구가 갈리지 않는다. `{0}` 에는 공용 경로와 같은
   * 형식(`[라벨]`)을 넣는다.
   */
  REQUIRED_FIELD: 'MSG00429',
  /** AS-IS MSG00004(저장결과) → TO-BE MSG00004 는 "No changes to save." 다. */
  SAVE_SUCCESS: 'MSG00672',
  SAVE_FAIL: 'MSG00003',
  NO_CHANGES: 'MSG00004',
  /** AS-IS MSG00260(신규 입력 데이터 중 중복) → 문구 1:1 등가. */
  DUPLICATE_NEW: 'MSG00428',
  /**
   * AS-IS MSG00443(중복된 항목이 있습니다) → "Duplicate Data found."
   * design 03 §5.4 는 `MSG00007`("This data cannot be modified.")를 **검토 후보**로 적었으나
   * 그 문구는 중복이 아니라 수정불가 안내라 의미가 어긋난다 — 문구 역조회 결과 이 값이 정합이다.
   */
  DUPLICATE_KEY_CHANGED: 'MSG01427',
  /** AS-IS MSG00046 → TO-BE 동일번호 미등록. 문구 등가. */
  INVALID_DATE: 'MSG01081',
  /** AS-IS MSG00050 → TO-BE 동일번호 미등록. 문구 등가. */
  INVALID_NUMBER: 'MSG01082',
  PERIOD_OVERLAP: 'MSG00105',
  PERIOD_REVERSED: 'MSG00108',
  /** AS-IS 하드코딩 한글(소수 11자리 초과) → 등가 문구 존재. */
  DIGIT_EXCEEDED: 'MSG00165',
  /** Batch 팝업 — 시작일이 월요일이 아님(BatchPopup cs:294). 번호·의미 모두 일치. */
  BATCH_START_NOT_MONDAY: 'MSG00330',
  /** Batch 팝업 — AS-IS MSG00061(`{0}` 정보 미선택, TO-BE 미등록) → 필수 문구로 대체. */
  BATCH_LINE_REQUIRED: 'MSG00429',
  UPLOAD_DONE: 'MSG00265',
  UPLOAD_FAIL: 'MSG01068',
  UPLOAD_FILE_REQUIRED: 'MSG01385',
} as const;

/** 조회조건·버튼 라벨 — design 02 §5 / 01 §1.2 실측(전건 존재, 신규 0건). */
export const LBL = {
  DIVISION: 'LBL00001',
  PLAN_GROUP: 'LBL00002',
  /** 공용 `PeriodField` 기본값 `LBL00505` 는 DB·번들 모두 0건 — 반드시 명시 전달한다(§5 M-2). */
  PERIOD: 'LBL00013',
  PLANT: 'LBL00030',
  LINE: 'LBL00010',
  NICK_NAME: 'LBL00767',
  MODEL: 'LBL00669',
  SEARCH: 'LBL00112',
  EDIT: 'LBL00414',
  EXCEL_UPLOAD: 'LBL00346',
  EXCEL_FORM: 'LBL00762',
  BATCH_SAVE: 'LBL01056',
  OK: 'LBL00716',
  CANCEL: 'LBL00107',
  EXCEL_FILE: 'LBL00759',
  UPLOAD_RESULT: 'LBL00754',
  UPLOAD_SUCCESS: 'LBL00755',
  UPLOAD_ERROR: 'LBL00756',
  UPLOAD_TOTAL: 'LBL00757',
} as const;

/** Batch Save 팝업 제목 — AS-IS Designer 제목이 `Batch Save` 버튼 라벨과 같다. */
export const FALLBACK_LABEL = {
  BATCH_TITLE: 'No Work Batch Save',
  WEEKS: 'Weeks',
} as const;
