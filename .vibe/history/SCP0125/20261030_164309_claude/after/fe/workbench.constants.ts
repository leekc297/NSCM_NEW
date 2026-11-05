// SCP0125 Workbench — 화면 상수 정본.
//   5탭 / 7 데이터시트(+init) / 102 컬럼 / 저장경로 4개. 시트별 분기는 전부 이 파일의 테이블로
//   외부화한다(hook #47/#51 — 페이지 본체 400라인 제한).
//
// 근거 문서: design/01_layout.md · 02_search-combo.md · 03_grid-columns.md · convert-flow/goal.md §7
// 근거 소스: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0125_Workbench/SCP0125_Workbench.cs (2404라인)

export const MENU_ID = 'SCP0125' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * BE 프로시저 라우팅 키 — `SCM_ADM_API_M.API_ID` 접미(`SCP0125_{shtNm}_{SEARCH|SAVE}`) 실측 8종.
 * admin 컬럼메타의 `SHEET_NAME`(`MKT FCST`/`STOCK`/…)과는 **별개 축**이다(ADMIN_SHEET_NAME 참조).
 * 근거: goal.md §4.4 C1 (API_M 15행 실측 정정 — 03_grid-columns.md §7.1 의 admin 표기 유니온 미채택)
 */
export enum SHEETS {
  INIT = 'init',
  MKT_FCST = 'mktFcst',
  STOCK = 'stock',
  STOCK_UC = 'stockUc',
  STOCK_ELEC = 'stockElec',
  STOCK_ELEC_UC = 'stockElecUc',
  ELEC_DEMAND = 'elecDemand',
  STOCK_2ND_OCV = 'stock2ndOcv',
}

/** 데이터 시트(그리드 조회·저장 대상) — `init` 은 조회조건 공급 전용이라 제외한다. */
export type DataSheet = Exclude<SHEETS, SHEETS.INIT>;

/** GET 커서 키 — `SCM_ADM_PROC_M.COL_NM` 실측 소문자 `o_rc1`(hook #80). init 만 o_rc1~o_rc9. */
export const RESPONSE_SET = 'o_rc1' as const;

/** 탭 인덱스 = AS-IS `AddSheet` 순서(cs:88~95). */
export enum TABS {
  MKT_FCST = 0,
  STOCK = 1,
  STOCK_ELEC = 2,
  ELEC_DEMAND = 3,
  STOCK_2ND_OCV = 4,
}

export const TAB_ORDER: readonly TABS[] = [
  TABS.MKT_FCST,
  TABS.STOCK,
  TABS.STOCK_ELEC,
  TABS.ELEC_DEMAND,
  TABS.STOCK_2ND_OCV,
];

/**
 * admin `SCM_MST_SHEET_COLUMNS.SHEET_NAME` — 컬럼메타 조회 sheetNm **전용** 키.
 * TO-BE 표기가 정본이다(03_grid-columns.md §5-D: AS-IS `Stock` ↔ TO-BE `STOCK` 대소문자 상이).
 * 탭 캡션으로 재사용하지 않는다 — 표시 라벨은 아래 `TAB_LABEL`(AS-IS 시트명과 문자열 일치).
 */
export const ADMIN_SHEET_NAME: Record<TABS, string> = {
  [TABS.MKT_FCST]: 'MKT FCST',
  [TABS.STOCK]: 'STOCK',
  [TABS.STOCK_ELEC]: 'Stock(Elec. Plant)',
  [TABS.ELEC_DEMAND]: 'Elec. Demand',
  [TABS.STOCK_2ND_OCV]: 'Stock(2nd OCV)',
};

/**
 * 탭 표시 라벨 — AS-IS 런타임 시트명(cs:88~95 AddSheet, 화면설계 01_layout.md §1.2)과 문자열 동일.
 * 컬럼메타 키 `ADMIN_SHEET_NAME`(DB `SHEET_NAME`, `STOCK` 대문자)과 분리한다 — 그 값을 캡션으로 쓰면
 *   AS-IS(`Stock`)와 대소문자가 어긋나기 때문(사용자 지적 2026-09-30, 첨부 AS-IS 탭 이미지).
 * 다국어: `MKT FCST`만 `SCM_ADM_MSG_M`(`MNU00182`, KO/EN/CN 동일)에 등록돼 있어 i18n(`code`)으로 뽑고,
 *   나머지 4개는 라벨 미등록이라 AS-IS 영문 리터럴로 고정한다 — 번역 미도입은 사용자 결정(2026-09-30).
 */
export const TAB_LABEL: Record<TABS, { code?: string; text: string }> = {
  [TABS.MKT_FCST]: { code: 'MNU00182', text: 'MKT FCST' },
  [TABS.STOCK]: { text: 'Stock' },
  [TABS.STOCK_ELEC]: { text: 'Stock(Elec. Plant)' },
  [TABS.ELEC_DEMAND]: { text: 'Elec. Demand' },
  [TABS.STOCK_2ND_OCV]: { text: 'Stock(2nd OCV)' },
};

/**
 * division 축 리터럴 — **한계 있음(hook #113 부분 미준수)**.
 *
 * AS-IS 는 `sDivision == "40"`(cs:447·734·934) / `== "81_UC"`(cs:459·1229) 로 코드 리터럴을
 * 직접 비교한다. TO-BE 에 이 두 축에 대응하는 메타가 **없다**(ora.py 실측 2026-09-26):
 *   · `OPMZ_DIVISION_GM` lookup = {`81_UC`, `EE_UC`} 2행 → UC 단독 축과 **불일치**(EE_UC 가 섞인다)
 *   · `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 102행 전건 NULL → division 별 컬럼메타 분기 불가
 *   · `40` 전용 lookup 0행
 * 신규 lookup 등록은 운영 메타 임의 생성(convert-core §2.3)이라 금지 → 두 코드를 **이 한 곳에만**
 * 두고 04_react-gap.md "확인 필요(사용자 축)"에 올린다. GM 축(Plan Date 위젯·CUTOFF)은 리터럴이
 * 아니라 lookup 조회로 판정한다(GM_LOOKUP_TYPE).
 */
export const DIVISION_CODE = {
  /** 소형전지 — MKT FCST `PROJECT_CODE`↔`PROJECT_CODE_40` 배타 + 신규행 필수집합 분기 */
  SMALL: '40',
  /** 원통형 UC — STOCK 계열 SP 분기 + `LINE_ID`/`BEFORE_DEGAS` 표시 */
  UC: '81_UC',
} as const;

/** GM 사업부 집합 원천 — FE 화이트리스트 금지(hook #113). `useTabLookupQueries` 로 조회. */
export const GM_LOOKUP_TYPE = 'OPMZ_DIVISION_GM';

/** 조회조건 콤보 SQL_ID — 의미 패리티 실측 확인분만(convert-core §2.6). */
export const COMBO = {
  /**
   * `Division_SCP` + `ATTRIBUTE3 <> 'EE'` 를 WHERE 에 흡수한 등록본.
   * 주의: `mnuId` 는 **공용 훅이 기본 주입**한다(호출부가 안 넘겨도 실린다). 종전 "미전달이 기본"
   * 표기는 사실오류였다 — 근거·영향 실측은 `components/WorkbenchForm.tsx` 의 Q1 주석 참조.
   */
  DIVISION: 'Division_SCP_NoEE',
  /** 주단위 Plan Date 전건(권한 무시). division 필터는 FE 클라 재현(F02). */
  PLAN_DATE_WEEKLY: 'OPMZ_DATE_WEEKLY_SCP_ALL',
} as const;

/** 조회조건 라벨 — `SCM_ADM_MSG_M` 실측(02_search-combo.md §4.5, 5건 전건 기등록). */
export const LBL = {
  DIVISION: 'LBL00001',
  PLAN_DATE: 'LBL00039',
  VERSION: 'LBL00060',
  // Nick Name(LBL00767)·Model(LBL00669) 2필드를 Project Route 와 동일한 단일 Model/Nickname 픽커로
  //   통합했다(사용자 지시 2026-09-30). 값은 itemId 로만 전송하고 nickName 은 '' — 아래 MODEL_NICKNAME.
  MODEL_NICKNAME: 'LBL00618',
  // Edit 토글 버튼 라벨(`LBL00414`)은 두지 않는다 — 규범 convert-core §2.4 로 모드 토글이 미이식이며
  //   `customButtons` 자체가 없어졌다(goal.md §8). 권한축 `EDIT` 버튼코드 메타는 DB 에 그대로 유지된다.
  SEARCH: 'LBL00112',
} as const;

/**
 * 메시지 — **AS-IS 번호를 그대로 쓰지 않는다**(hook #114). 전건 `SCM_ADM_MSG_M` 문구 역조회 실측
 * (ora.py 2026-09-26) + `public/locales/EN.json` 번들 존재 확인.
 *
 * | AS-IS | AS-IS 문구 | TO-BE | TO-BE 문구(EN) |
 * |---|---|---|---|
 * | MSG00097 | 권한을 가진 Division이 없습니다 | MSG00667 | No authority assigned. |
 * | MSG00129 | {0}를 수정 중이어서 시트를 변경할 수 없습니다 | MSG01149 | You are modifying {0} and can not change the sheet. |
 * | MSG00001 | 모든 항목은 필수입력입니다 | MSG01039 | All entries are mandatory. |  (AS-IS 문구와 1:1 일치하는 등록본 — 종전 MSG01027 "대상 항목 전체를 입력해야 합니다" 는 의미만 유사해 2026-10-01 교체, hook #114)
 * | MSG00260 | 신규 입력 데이터 중 중복된 데이터가 있습니다 | MSG00428 | There are duplicate entries among the newly entered data. |
 * | MSG00046 | 유효한 날짜 형식이 아닙니다. {0} | MSG01081 | This is not a valid date format. {0} |
 * | MSG00463 | Plan 시작일자보다 이른 Date를 확인하시기 바랍니다 | MSG01437 | Please check the Date earlier than the Plan start date. |
 * | MSG00457 | {0} 유효하지 않은 프로젝트 코드입니다 | MSG00457 | PROJECT_CODE:{0} Invalid project code! |
 * | MSG00458 | {0} 유효하지 않은 모델입니다 | MSG00458 | MODEL:{0} Invalid model! |
 * | MSG00310 | 필수 입력 칼럼 값을 입력해 주세요 | MSG00013 | Please enter the required fields. |
 * | MSG00050 | 유효한 숫자형식이 아닙니다. {0} | MSG01082 | This is not a valid numeric format. {0} |
 * | MSG00004 | 저장결과({0}건) | MSG00672 | {0} data saved. |
 */
export const MSG = {
  NO_AUTHORITY: 'MSG00667',
  SHEET_CHANGE_BLOCKED: 'MSG01149',
  REQUIRED_ALL: 'MSG01039',
  DUPLICATE_NEW_ROW: 'MSG00428',
  INVALID_DATE: 'MSG01081',
  DATE_BEFORE_PLAN_START: 'MSG01437',
  INVALID_PROJECT: 'MSG00457',
  INVALID_ITEM: 'MSG00458',
  REQUIRED_COLUMN: 'MSG00013',
  INVALID_NUMBER: 'MSG01082',
  SAVE_RESULT: 'MSG00672',
  NO_CHANGE: 'MSG00004',
  SAVE_FAIL: 'MSG00003',
} as const;

/** CHG_TYPE 파생값 — AS-IS cs:744(신규) / cs:1050·1351·1613·1872(최초수정). */
export const CHG_TYPE = { NEW: 'New', CHANGE: 'Change' } as const;

/** 코드 컬럼 미해당 시 AS-IS 가 채우는 센티널(cs:736·1242~1248). */
export const NOT_APPLICABLE = '-';

/** Elec. Demand 신규행 PLAN_TYPE 고정값(cs:792). */
export const ELEC_DEMAND_PLAN_TYPE = 'FN';

/** 컬럼명 — 화면 로직이 실제로 참조하는 것만. 컬럼 목록 자체는 admin 메타 구동(하드코딩 금지). */
export const COL = {
  DIVISION_ID: 'DIVISION_ID',
  VERSION_NO: 'VERSION_NO',
  CUTOFF_YYYYMMDD: 'CUTOFF_YYYYMMDD',
  PLAN_START_YYYYMMDD: 'PLAN_START_YYYYMMDD',
  PLAN_TYPE: 'PLAN_TYPE',
  SEQ: 'SEQ',
  SRCE_DIVS_CD: 'SRCE_DIVS_CD',
  PROJECT_CODE: 'PROJECT_CODE',
  PROJECT_CODE_40: 'PROJECT_CODE_40',
  SCM_SITE_ID: 'SCM_SITE_ID',
  NICK_NAME: 'NICK_NAME',
  ITEM_ID: 'ITEM_ID',
  FCST_TYPE: 'FCST_TYPE',
  FCST_TYPE_NAME: 'FCST_TYPE_NAME',
  STOCK_TYPE: 'STOCK_TYPE',
  STOCK_TYPE_NAME: 'STOCK_TYPE_NAME',
  INCOTERMS: 'INCOTERMS',
  FROM_SITE_ID: 'FROM_SITE_ID',
  PLANT_SITE_ID: 'PLANT_SITE_ID',
  PLANT_ID: 'PLANT_ID',
  CELL_PROD_SITE_ID: 'CELL_PROD_SITE_ID',
  LOCATION_CODE: 'LOCATION_CODE',
  LINE_ID: 'LINE_ID',
  OPERATION_ID: 'OPERATION_ID',
  OPERATION_NAME: 'OPERATION_NAME',
  BEFORE_DEGAS: 'BEFORE_DEGAS',
  DUE_DATE: 'DUE_DATE',
  INV_DATE: 'INV_DATE',
  YYYYMMDD: 'YYYYMMDD',
  SECOND_OCV_TIME: 'SECOND_OCV_TIME',
  SECOND_OCV_DATE: 'SECOND_OCV_DATE',
  QTY: 'QTY',
  CHG_QTY: 'CHG_QTY',
  CHG_RSN: 'CHG_RSN',
  CHG_TYPE: 'CHG_TYPE',
  PRE_CHG_QTY: 'PRE_CHG_QTY',
  PRE_CHG_RSN: 'PRE_CHG_RSN',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  LAST_UPDATE_DATE: 'LAST_UPDATE_DATE',
} as const;

/**
 * 기존행 편집 가능 컬럼 — 5시트 공통 2개(01_layout.md §2.4 A, LockColumn 24건 합성 결과).
 * `PRE_CHG_*` 는 AS-IS 잠금범위 누락으로 편집 가능하나 SAVE SP 파라미터에 없어 저장되지 않는다
 * → 재현하지 않는다(§5 K4 "저위험 잔여").
 */
export const EDITABLE_ON_EXISTING_ROW: readonly string[] = [COL.CHG_QTY, COL.CHG_RSN];

/**
 * 신규행('I') 편집 가능 컬럼 — 시트별 white-list(01_layout.md §2.4 B, LockRange 실측 합성).
 * hook #130: AS-IS LockRange 컬럼 인덱스를 그대로 옮기지 않고 "무엇이 열리는가"를 컬럼명으로 인코딩.
 */
export const EDITABLE_ON_INSERT_ROW: Record<TABS, readonly string[]> = {
  // cs:748~752 (G18~G22) — CELL_PROD_SITE_ID 는 division 조건부(R13/G16) 라 editLock 이 별도 판정
  [TABS.MKT_FCST]: [
    COL.CUTOFF_YYYYMMDD,
    COL.PROJECT_CODE,
    COL.PROJECT_CODE_40,
    COL.SCM_SITE_ID,
    COL.ITEM_ID,
    COL.FCST_TYPE_NAME,
    COL.INCOTERMS,
    COL.PLANT_SITE_ID,
    COL.CELL_PROD_SITE_ID,
    COL.DUE_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  // cs:780~784 (G24~G28) — LINE_ID·BEFORE_DEGAS 는 division=='81_UC' 조건부
  [TABS.STOCK]: [
    COL.SRCE_DIVS_CD,
    COL.CUTOFF_YYYYMMDD,
    COL.STOCK_TYPE_NAME,
    COL.PROJECT_CODE,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.FROM_SITE_ID,
    COL.SCM_SITE_ID,
    COL.LINE_ID,
    COL.BEFORE_DEGAS,
    COL.INV_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  // cs:756 조건 공유 — LINE_ID·BEFORE_DEGAS 없음 / LOCATION_CODE 추가
  [TABS.STOCK_ELEC]: [
    COL.SRCE_DIVS_CD,
    COL.CUTOFF_YYYYMMDD,
    COL.STOCK_TYPE_NAME,
    COL.PROJECT_CODE,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.FROM_SITE_ID,
    COL.SCM_SITE_ID,
    COL.LOCATION_CODE,
    COL.INV_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  // cs:797~800 (G30~G33)
  [TABS.ELEC_DEMAND]: [
    COL.PLANT_SITE_ID,
    COL.LINE_ID,
    COL.ITEM_ID,
    COL.YYYYMMDD,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  // cs:828~832 (G35~G39)
  [TABS.STOCK_2ND_OCV]: [
    COL.STOCK_TYPE_NAME,
    COL.ITEM_ID,
    COL.PLANT_ID,
    COL.OPERATION_ID,
    COL.SECOND_OCV_TIME,
    COL.SECOND_OCV_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
};

/**
 * 동적 컬럼 표시(V1~V5) — **"숨김" = COLUMN_WIDTH 0**(Visible=false 아님).
 * SVN BASE `SheetUtils.SetVisibleSheetColumn` 실측: `visible` 인자는 미사용, width 0 으로만 숨긴다
 * (02_search-combo.md §7 보너스 / 03_grid-columns.md §2.2). 숨김 컬럼도 행 데이터·저장 payload 에는
 * 반드시 남는다(§4.3).
 *
 * `shownWidth` 가 null 이면 admin 메타 폭을 그대로 쓴다(코드 override 금지 — hook #130 A-1).
 * STOCK 의 2컬럼은 메타 폭이 0 이라 메타에서 표시폭을 얻을 수 없어 AS-IS 값(cs:461·462)을 싣는다.
 */
export interface DynamicColumnRule {
  /** 이 컬럼이 보이는 division 조건. `undefined` = 무조건 표시. */
  visibleWhenDivision?: string;
  /** division 조건을 반전(해당 division 이 **아닐 때** 표시). */
  negate?: boolean;
  /** 표시 시 강제 폭. null = admin 메타 폭 사용. */
  shownWidth: number | null;
}

export const DYNAMIC_COLUMNS: Record<TABS, Readonly<Record<string, DynamicColumnRule>>> = {
  // V1/V2 cs:447~453 — PROJECT_CODE ↔ PROJECT_CODE_40 배타. 메타 폭 100 을 그대로 쓴다.
  [TABS.MKT_FCST]: {
    [COL.PROJECT_CODE]: {
      visibleWhenDivision: DIVISION_CODE.SMALL,
      negate: true,
      shownWidth: null,
    },
    [COL.PROJECT_CODE_40]: { visibleWhenDivision: DIVISION_CODE.SMALL, shownWidth: null },
  },
  // V3/V4 cs:461~468 — 메타 폭이 0 이라 AS-IS 표시폭을 싣는다(메타 정비 시 null 로 되돌릴 것).
  [TABS.STOCK]: {
    [COL.LINE_ID]: { visibleWhenDivision: DIVISION_CODE.UC, shownWidth: 100 },
    [COL.BEFORE_DEGAS]: { visibleWhenDivision: DIVISION_CODE.UC, shownWidth: 80 },
  },
  // V4 는 이 시트에 해당 컬럼이 없어 AS-IS 도 no-op(GetColumnIndex()==-1) — 규칙 0건.
  [TABS.STOCK_ELEC]: {},
  // V5 cs:473 — 무조건 표시. AS-IS 는 폭 100 으로 덮어쓰지만 메타(80)를 정본으로 둔다(§6 U6).
  [TABS.ELEC_DEMAND]: {},
  [TABS.STOCK_2ND_OCV]: {},
};

/**
 * 신규행 필수 컬럼(MSG00001 → MSG01027) — 03_grid-columns.md §4.3 표가 정본이다.
 * 라벨 `*` 와 어긋나는 컬럼이 여럿이라(§6 U3) 메타 라벨 기반 검증으로 대체할 수 없다.
 */
export const INSERT_REQUIRED_COLUMNS: Record<TABS, readonly string[]> = {
  // division ≠ '40' 기준 10개. division == '40' 은 아래 MKT_FCST_REQUIRED_SMALL 로 대체.
  [TABS.MKT_FCST]: [
    COL.PROJECT_CODE,
    COL.SCM_SITE_ID,
    COL.ITEM_ID,
    COL.FCST_TYPE_NAME,
    COL.INCOTERMS,
    COL.PLANT_SITE_ID,
    COL.CELL_PROD_SITE_ID,
    COL.DUE_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  // LOCATION_CODE 는 코드가 '-' 를 채우므로 검사 대상이 아니다.
  //   LINE_ID·BEFORE_DEGAS 는 division 조건부다 — `81_UC` 에서만 필수이며 그 2건은
  //   STOCK_UC_REQUIRED_COLUMNS 로 분리해 검증에서 덧붙인다(비UC 는 '-' 강제라 제외).
  [TABS.STOCK]: [
    COL.STOCK_TYPE_NAME,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.SCM_SITE_ID,
    COL.INV_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  [TABS.STOCK_ELEC]: [
    COL.STOCK_TYPE_NAME,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.SCM_SITE_ID,
    COL.LOCATION_CODE,
    COL.INV_DATE,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  [TABS.ELEC_DEMAND]: [
    COL.PLANT_SITE_ID,
    COL.LINE_ID,
    COL.OPERATION_ID,
    COL.ITEM_ID,
    COL.YYYYMMDD,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
  [TABS.STOCK_2ND_OCV]: [
    COL.STOCK_TYPE_NAME,
    COL.ITEM_ID,
    COL.PLANT_ID,
    COL.OPERATION_ID,
    COL.CHG_QTY,
    COL.CHG_RSN,
  ],
};

/** MKT FCST division == '40' 전용 필수 8개 — `PLANT_SITE_ID` 검사 제외(주석 명시 cs:934). */
export const MKT_FCST_REQUIRED_SMALL: readonly string[] = [
  COL.PROJECT_CODE_40,
  COL.SCM_SITE_ID,
  COL.ITEM_ID,
  COL.FCST_TYPE_NAME,
  COL.INCOTERMS,
  COL.DUE_DATE,
  COL.CHG_QTY,
  COL.CHG_RSN,
];

/**
 * 신규행 중복검사 키(MSG00260 → MSG00428) — F13·F17·F18·F20 실측.
 * STOCK 계열은 division·시트에 따라 키가 가변이므로 `dynamicKeys` 로 분리한다.
 */
export const DUPLICATE_KEYS: Record<TABS, readonly string[]> = {
  // F13 11키 (PROJECT_CODE 는 division 에 따라 PROJECT_CODE_40 로 치환 — buildDuplicateKey 처리)
  [TABS.MKT_FCST]: [
    COL.DIVISION_ID,
    COL.VERSION_NO,
    COL.CUTOFF_YYYYMMDD,
    COL.PROJECT_CODE,
    COL.SCM_SITE_ID,
    COL.ITEM_ID,
    COL.FCST_TYPE,
    COL.INCOTERMS,
    COL.PLANT_SITE_ID,
    COL.CELL_PROD_SITE_ID,
    COL.DUE_DATE,
  ],
  // F17 9키 + (81_UC 면 LINE_ID·BEFORE_DEGAS)
  [TABS.STOCK]: [
    COL.DIVISION_ID,
    COL.STOCK_TYPE,
    COL.CUTOFF_YYYYMMDD,
    COL.PROJECT_CODE,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.FROM_SITE_ID,
    COL.SCM_SITE_ID,
    COL.INV_DATE,
  ],
  // F17 9키 + LOCATION_CODE
  [TABS.STOCK_ELEC]: [
    COL.DIVISION_ID,
    COL.STOCK_TYPE,
    COL.CUTOFF_YYYYMMDD,
    COL.PROJECT_CODE,
    COL.ITEM_ID,
    COL.INCOTERMS,
    COL.FROM_SITE_ID,
    COL.SCM_SITE_ID,
    COL.INV_DATE,
    COL.LOCATION_CODE,
  ],
  // F18 8키 — SEQ 제외(신규행은 공백, cs:1548 주석)
  [TABS.ELEC_DEMAND]: [
    COL.DIVISION_ID,
    COL.PLAN_START_YYYYMMDD,
    COL.PLAN_TYPE,
    COL.PLANT_SITE_ID,
    COL.LINE_ID,
    COL.OPERATION_ID,
    COL.ITEM_ID,
    COL.YYYYMMDD,
  ],
  // F20 7키 + SECOND_OCV_DATE(공백이면 IS NULL 분기 — buildDuplicateKey 가 빈값을 그대로 키에 넣어 등가)
  [TABS.STOCK_2ND_OCV]: [
    COL.DIVISION_ID,
    COL.STOCK_TYPE,
    COL.CUTOFF_YYYYMMDD,
    COL.ITEM_ID,
    COL.PLANT_ID,
    COL.OPERATION_ID,
    COL.SECOND_OCV_TIME,
    COL.SECOND_OCV_DATE,
  ],
};

/** UC division 한정 추가 중복키(F17) — STOCK 시트만. */
export const STOCK_UC_DUPLICATE_KEYS: readonly string[] = [COL.LINE_ID, COL.BEFORE_DEGAS];

/**
 * UC division 한정 추가 **필수** 컬럼 — STOCK 시트만.
 *
 * 비UC 에서는 이 2컬럼이 폭 0 으로 숨겨지고 저장값도 `'-'` 강제라 검사 대상이 아니지만(cs:1242~1248),
 * `81_UC` 에서는 셀값을 그대로 보내므로(cs:1229~1234) 공백이면 `lineId=''`/`beforeDegas=''` 가 저장된다.
 * AS-IS 는 강제값을 먼저 대입한 뒤 그 변수로 공백을 검사해 차단한다(cs:1268~1273) — 같은 순서로
 * 재현한다. 메타 라벨도 `Line*`·`Before Degas*` 로 필수 표기돼 있다(실측).
 */
export const STOCK_UC_REQUIRED_COLUMNS: readonly string[] = [COL.LINE_ID, COL.BEFORE_DEGAS];

/** 날짜 컬럼 — 저장 시 `YYYYMMDD` 8자로 변환하고 형식검증(MSG01081) 대상. */
export const DATE_COLUMN: Partial<Record<TABS, string>> = {
  [TABS.MKT_FCST]: COL.DUE_DATE,
  [TABS.STOCK]: COL.INV_DATE,
  [TABS.STOCK_ELEC]: COL.INV_DATE,
  [TABS.ELEC_DEMAND]: COL.YYYYMMDD,
  [TABS.STOCK_2ND_OCV]: COL.SECOND_OCV_DATE,
};

/** `MSG01081` 의 `{0}` 에 들어가는 AS-IS 라벨(cs:990·1323·1577·1851). */
export const DATE_COLUMN_LABEL: Partial<Record<TABS, string>> = {
  [TABS.MKT_FCST]: 'Due Date',
  [TABS.STOCK]: 'Date',
  [TABS.STOCK_ELEC]: 'Date',
  [TABS.ELEC_DEMAND]: 'Date',
  [TABS.STOCK_2ND_OCV]: 'Date',
};

/** Plan 시작일 역전 검사(MSG00463 → MSG01437) 대상 — 2nd OCV 는 AS-IS 에 없다(cs:997·1330·1584). */
export const PLAN_START_REVERSE_CHECK: Record<TABS, boolean> = {
  [TABS.MKT_FCST]: true,
  [TABS.STOCK]: true,
  [TABS.STOCK_ELEC]: true,
  [TABS.ELEC_DEMAND]: true,
  [TABS.STOCK_2ND_OCV]: false,
};

/** Item 존재검증(MSG00458) 대상 — STOCK 계열·2nd OCV 는 AS-IS 에 없다(cs:1034·1593). */
export const ITEM_EXISTENCE_CHECK: Record<TABS, boolean> = {
  [TABS.MKT_FCST]: true,
  [TABS.STOCK]: false,
  [TABS.STOCK_ELEC]: false,
  [TABS.ELEC_DEMAND]: true,
  [TABS.STOCK_2ND_OCV]: false,
};

/**
 * 기존행 수정 필수값 누락 메시지(비-MKT FCST 전용) — AS-IS inline check(cs:1342)의 MSG00310 등가.
 * MKT FCST 는 AS-IS `checkRequiredOfSpread`(cs:1045) 로 빈 컬럼을 지목하는 per-field 메시지
 * (`CRUD_MSG.REQUIRED_FIELD`/MSG00429)를 쓰므로 이 맵을 타지 않는다 — `useWorkbenchValidation`
 * 의 'M' 분기에서 tab 으로 분기한다(2026-10-08 정정, 종전 lump REQUIRED_ALL 매핑 오류 해소).
 */
export const EXISTING_ROW_REQUIRED_MSG: Record<TABS, string> = {
  [TABS.MKT_FCST]: MSG.REQUIRED_COLUMN,
  [TABS.STOCK]: MSG.REQUIRED_COLUMN,
  [TABS.STOCK_ELEC]: MSG.REQUIRED_COLUMN,
  [TABS.ELEC_DEMAND]: MSG.REQUIRED_COLUMN,
  [TABS.STOCK_2ND_OCV]: MSG.REQUIRED_COLUMN,
};

/**
 * 탭 → GET/SAVE sheetName 라우팅. STOCK 계열만 division 으로 갈린다(goal.md §4.4 C2 — API_M 실측).
 * `divisionId` 를 filters 로만 넘기고 sheetName 을 고정하면 81_UC 의 2열이 통째로 빠진다.
 */
export const resolveSheet = (tab: TABS, isUcDivision: boolean): DataSheet => {
  switch (tab) {
    case TABS.MKT_FCST:
      return SHEETS.MKT_FCST;
    case TABS.STOCK:
      return isUcDivision ? SHEETS.STOCK_UC : SHEETS.STOCK;
    case TABS.STOCK_ELEC:
      return isUcDivision ? SHEETS.STOCK_ELEC_UC : SHEETS.STOCK_ELEC;
    case TABS.ELEC_DEMAND:
      return SHEETS.ELEC_DEMAND;
    case TABS.STOCK_2ND_OCV:
      return SHEETS.STOCK_2ND_OCV;
  }
};

// 저장경로는 SP 축으로 4개지만(STOCK·Stock(Elec. Plant) 가 `SAVE_STOCK_ADJ` 공유, 03 §4.3)
//   FE 가 호출에 쓰는 축은 `sheetName` 이다(`/{menuId}/{sheetName}/SAVE/call-proc`) — SAVE API 는
//   `stock`/`stockUc`/`stockElec`/`stockElecUc` 4건이 모두 등록돼 있고(API_M 실측) 그 4건이 같은 SP 를
//   가리킨다. 따라서 별도 `SAVE_PATH` 축을 두지 않고 조회와 동일하게 `resolveSheet()` 하나만 쓴다
//   ('stockAdj' 같은 값은 실존 sheetName 이 아니어서 호출 URL 로 쓰면 404 다 — iter-1 GAP-11 로 제거).

/**
 * Plan Date 위젯 이원화(R04 / §2.2) — GM 사업부 + 아래 3탭에서만 일단위 DatePicker 가 노출된다.
 * B2 결정(goal.md §7): 표시 위젯 · 조회 기준일 · 신규행 CUTOFF 기준일을 **항상 일치**시킨다
 * (AS-IS 4지점 불일치는 의도적으로 정정 — `runtime-parity-gate` 에 기록).
 */
export const isDailyPlanDateTab = (tab: TABS): boolean =>
  tab === TABS.STOCK || tab === TABS.STOCK_ELEC || tab === TABS.STOCK_2ND_OCV;

export type PlanDateMode = 'weekly' | 'daily';

export const resolvePlanDateMode = (tab: TABS, isGmDivision: boolean): PlanDateMode =>
  isGmDivision && isDailyPlanDateTab(tab) ? 'daily' : 'weekly';

/** MKT FCST Ver. 조회조건 노출 여부(R03) + `versionNo` 파라미터 전송 여부(W12). */
export const usesVersion = (tab: TABS): boolean => tab === TABS.MKT_FCST;
