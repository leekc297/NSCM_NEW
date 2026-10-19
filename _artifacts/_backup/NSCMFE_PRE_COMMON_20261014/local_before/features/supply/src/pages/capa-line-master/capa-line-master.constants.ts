export const MENU_ID = 'SCP0114' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0114_CAPA_LineMaster (5 그리드 spdLevel1~5 계층 마스터):
//   설계 근거: .atlas/gscm-design/SCP0114/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   Site(L1) -> Company(L2) -> Plant(L3) -> Building/Factory(L4) -> Line(L5) 5단계 CAPA 라인 마스터.
//   - GET  SP : PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MASTER  (p_menu_level 1~5 로 레벨별 조회)
//   - SAVE SP : PKG_SCP0114.P_SCP0114_SAVE_CAPA_LINE_MASTER (활성 레벨 1시트만, ^-delim 병렬배열 I/M)
//   - 드릴다운 : L1~L4 셀 더블클릭 -> 하위 레벨 재조회(L5 는 최하위라 재조회 없음, cs:1816~1833)
//   - 편집모드 : 5그리드 중 동시 1개만(EditModesCheck cs:490~502). Edit 재진입은 'I'/'M' 행 있으면 차단(cs:482)
//   - 삭제     : 신규행('I')만 로컬 제거, 기존행 삭제 불가(cs:373~384, hook #138)
//   - SP 미배포(goal.md 2): PKG_SCP0114 all_objects 0건 -> 런타임 실행체인 미완(convert-sp 후속)
export enum SHEETS {
  LEVEL1 = 'Level1', // spdLevel1 Site   (AS-IS SpdSheet.shtLevel1, cs:103)
  LEVEL2 = 'Level2', // spdLevel2 Company
  LEVEL3 = 'Level3', // spdLevel3 Plant
  LEVEL4 = 'Level4', // spdLevel4 Building(Factory)
  LEVEL5 = 'Level5', // spdLevel5 Line
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  LEVEL1: 'o_rc1',
  LEVEL2: 'o_rc1',
  LEVEL3: 'o_rc1',
  LEVEL4: 'o_rc1',
  LEVEL5: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   SHEETS value 와 동일 문자열이지만 의미가 달라 분리 보관한다(대소문자까지 DB SHT_NM 과 일치, hook #54).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.LEVEL1]: 'Level1',
  [SHEETS.LEVEL2]: 'Level2',
  [SHEETS.LEVEL3]: 'Level3',
  [SHEETS.LEVEL4]: 'Level4',
  [SHEETS.LEVEL5]: 'Level5',
};

// 계층 레벨 1~5 — GET SP p_menu_level / SAVE SP p_spreadSeq 값과 동일.
export type LevelNo = 1 | 2 | 3 | 4 | 5;
export const LEVELS: readonly LevelNo[] = [1, 2, 3, 4, 5];

export const SHEET_BY_LEVEL: Record<LevelNo, SHEETS> = {
  1: SHEETS.LEVEL1,
  2: SHEETS.LEVEL2,
  3: SHEETS.LEVEL3,
  4: SHEETS.LEVEL4,
  5: SHEETS.LEVEL5,
};

// 그리드 헤더(SubTitle) 표기용 레벨 명칭 — AS-IS 패널 구성(design 01 §1 트리).
export const LEVEL_TITLE: Record<LevelNo, string> = {
  1: 'Level1 Site',
  2: 'Level2 Company',
  3: 'Level3 Plant',
  4: 'Level4 Building',
  5: 'Level5 Line',
};

// ====================================================================================
// 조회조건 (design 02)
// ====================================================================================
// Product Group 라디오 -> _shopgroupId (AS-IS cs:1853~1864, SelectedIndex 0/1/2).
//   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 CustomDropdown 으로 매핑한다(의미 동일, 04 §확인필요).
export const PRODUCT_GROUP = {
  ELECTRODE: 'E',
  CELL: 'A',
  MODULE_PACK: 'P',
} as const;
export type ProductGroup = (typeof PRODUCT_GROUP)[keyof typeof PRODUCT_GROUP];

// Form_Load 기본값 = Electrode (AS-IS cs:179 `_shopgroupId = "E"`).
export const DEFAULT_PRODUCT_GROUP: ProductGroup = PRODUCT_GROUP.ELECTRODE;

// 조회조건/셀 콤보 SQL_ID — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y' (2026-09-23 ora.py).
//   Division: AS-IS BLUtils.GetDivisionWithoutEE -> Data_SCP.Common(Type.Division) = 권한필터 변형.
//     base 'Division'(권한필터 없음·NAME 미반환) 재사용 금지 — convert-core §2.6 의미 패리티(design 02 §2.1).
//   YesOrNo: Level5 VALID_YN 셀 콤보(CODE/NAME = 'Y'/'N', design 03 §1.6).
export const COMBO = {
  DIVISION: 'Division_SCP',
  VALID: 'YesOrNo',
} as const;

// Division 후처리 필터 — AS-IS BLUtils.cs:109 `DBUtils.Filter(res, "ATTRIBUTE3 <> 'EE'")`.
//   이관된 CMBO SQL(Division_SCP) WHERE 에는 없으므로 FE 클라 필터로 재현한다.
//   공유 SQL_ID WHERE 수정은 타 화면 회귀 위험이라 금지(Hard Boundary, convert-core §2.2/§2.6).
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

// ====================================================================================
// 편집 잠금 / 신규행 (design 03 §3.2·§3.3 — AS-IS LockRange 규칙의 TO-BE 재현 축, hook #130)
// ====================================================================================
// 레벨별 "자기 ID" 컬럼 — 기존행은 항상 잠금, 신규행('I')에서만 편집(cs:530/559/588/617/648).
export const LEVEL_ID_COLUMN: Record<LevelNo, string> = {
  1: 'SITE_ID',
  2: 'COMPANY_ID',
  3: 'PLANT_ID',
  4: 'FACTORY_ID',
  5: 'LINE_ID',
};

// 레벨별 "자기 NAME" 컬럼 — DUMMY_YN='Y' + 해당 레벨 편집모드 on 에서만 편집(cs:531/560/589/618/649).
export const LEVEL_NAME_COLUMN: Record<LevelNo, string> = {
  1: 'SITE_NAME',
  2: 'COMPANY_NAME',
  3: 'PLANT_NAME',
  4: 'FACTORY_NAME',
  5: 'LINE_NAME',
};

// 레벨별 신규행이 상위에서 상속받는 부모 키 (design 03 §3.3 R13~R17, cs:1217~1257).
//   L1 은 division 만. 상위 컨텍스트는 드릴다운으로 채워진다(_siteId/_companyId/...).
export const LEVEL_PARENT_KEYS: Record<LevelNo, readonly string[]> = {
  1: [],
  2: ['SITE_ID', 'SITE_NAME'],
  3: ['SITE_ID', 'SITE_NAME', 'COMPANY_ID', 'COMPANY_NAME'],
  4: ['SITE_ID', 'SITE_NAME', 'COMPANY_ID', 'COMPANY_NAME', 'PLANT_ID', 'PLANT_NAME'],
  5: [
    'SITE_ID',
    'SITE_NAME',
    'COMPANY_ID',
    'COMPANY_NAME',
    'PLANT_ID',
    'PLANT_NAME',
    'FACTORY_ID',
    'FACTORY_NAME',
  ],
};

// 항상 잠금 — 편집모드/신규행과 무관 (design 03 §3.2 편집요약 (e), cs:519/524/650~651/1267~1288).
//   DIVISION_ID(조회조건 파생) / DUMMY_YN(신규는 항상 'Y' 고정) / SHOP_GROUP_ID(라디오 파생) / SORT_ORDER(SP 채번).
export const ALWAYS_LOCKED_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'DUMMY_YN',
  'SHOP_GROUP_ID',
  'SORT_ORDER',
];

export const DUMMY_YN_COLUMN = 'DUMMY_YN';
export const VALID_YN_COLUMN = 'VALID_YN';
export const SORT_ORDER_COLUMN = 'SORT_ORDER';

// DUMMY_YN='Y' = 수기 dummy 행(Name 편집 가능) / 'N' = FP 인터페이스 유입 데이터(전열 잠금).
//   AS-IS 주석 cs:510 "dummy = 'N' (FP에서 가져온 데이터) 이면 EDIT 못하도록".
export const DUMMY_EDITABLE_FLAG = 'Y';

// 신규행 기본값 (design 03 §3.3 R12, cs:1260~1261). SORT_ORDER 는 기존 Max+1 로 런타임 계산.
export const INSERT_DEFAULT_VALID_YN = 'Y';
export const INSERT_DEFAULT_DUMMY_YN = 'Y';

// 좌측 고정(Freeze) 앵커 — AS-IS Freeze(0, GetColumnIndex(X)) 의 X (design 03 §3.1 R2, cs:249/268/288/310/336).
//   L2~L5 의 앵커는 그 시트에서 visible=false 라 화면상 고정열은 보이지 않는다(AS-IS 동일).
export const FREEZE_ANCHOR_COLUMN: Record<LevelNo, string> = {
  1: 'DIVISION_ID',
  2: 'SITE_NAME',
  3: 'COMPANY_NAME',
  4: 'PLANT_NAME',
  5: 'FACTORY_NAME',
};

// ====================================================================================
// 저장 (design 03 §4.3 — AS-IS SaveData cs:809~898)
// ====================================================================================
// 레벨별 미해당 컬럼 채움값 (cs:832~892).
export const SAVE_NOT_APPLICABLE = '-';

// p_valid_yn 은 전 레벨 'Y' 하드코딩 (cs:841/854/867/880/893).
//   AS-IS 파리티 결정 (a) = 사용자 확정 2026-09-23 (goal.md 6 #1 / plan.md 머리말 1).
//   주의: Level5 VALID_YN 셀은 편집 가능하지만 저장 payload 에는 실값이 아니라 'Y' 가 실린다 — AS-IS quirk 재현.
export const SAVE_VALID_YN = 'Y';

// ====================================================================================
// 컬럼 메타 fallback (design 03 §1.1~§1.5 — AS-IS InitSpread AddTextColumn/AddComboColumn 리터럴 실측)
// ====================================================================================
// admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative. 없으면 이 fallback.
//   INPUT_TP_CD 는 AS-IS LockRange 규칙을 컬럼 축으로 옮긴 값이다(hook #130 — 상수 이식이 아니라 의미 재현):
//     IM = 자기 ID(신규행에서만 편집 + 필수) / M = 자기 NAME(편집 + 필수) / O = L5 VALID_YN / S = 그 외 전부.
//   행 축(DUMMY_YN·편집모드·신규행) 최종 판정은 utils/capaLineMaster.editLock 이 beginningEdit 에서 수행한다.
//   라벨의 `*` 는 AS-IS 헤더 그대로다(공용 useSaveWithValidation 의 필수 판정 원천 중 하나).
export interface ColumnMeta {
  key: string;
  header: string;
  width: number;
  align: 'L' | 'C' | 'R';
  visible?: boolean; // 미지정 = 표시. false = 데이터만 보유(하위 시트의 부모레벨 컬럼)
  inputTp: 'S' | 'O' | 'M' | 'IM';
  cell?: 'combo';
  comboId?: string;
}

// §1.1 Level1 (Site) — 데이터 5컬럼
const LEVEL1_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 60, align: 'L', inputTp: 'S' },
  { key: 'SITE_ID', header: 'Site*', width: 60, align: 'L', inputTp: 'IM' },
  { key: 'SITE_NAME', header: 'Site Name', width: 110, align: 'L', inputTp: 'M' },
  { key: 'DUMMY_YN', header: 'Dummy', width: 60, align: 'L', inputTp: 'S' },
  { key: 'SORT_ORDER', header: 'SortOrder', width: 10, align: 'L', visible: false, inputTp: 'S' },
];

// §1.2 Level2 (Company) — 데이터 7컬럼
const LEVEL2_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_ID', header: 'Site*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_NAME', header: 'Site Name', width: 110, align: 'L', visible: false, inputTp: 'S' },
  { key: 'COMPANY_ID', header: 'Company*', width: 100, align: 'L', inputTp: 'IM' },
  { key: 'COMPANY_NAME', header: 'Company Name', width: 150, align: 'L', inputTp: 'M' },
  { key: 'DUMMY_YN', header: 'Dummy', width: 60, align: 'L', inputTp: 'S' },
  { key: 'SORT_ORDER', header: 'SortOrder', width: 10, align: 'L', visible: false, inputTp: 'S' },
];

// §1.3 Level3 (Plant) — 데이터 9컬럼
const LEVEL3_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_ID', header: 'Site*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_NAME', header: 'Site Name', width: 110, align: 'L', visible: false, inputTp: 'S' },
  { key: 'COMPANY_ID', header: 'Company*', width: 100, align: 'L', visible: false, inputTp: 'S' },
  {
    key: 'COMPANY_NAME',
    header: 'Company Name',
    width: 120,
    align: 'L',
    visible: false,
    inputTp: 'S',
  },
  { key: 'PLANT_ID', header: 'Plant*', width: 60, align: 'L', inputTp: 'IM' },
  { key: 'PLANT_NAME', header: 'Plant Name', width: 120, align: 'L', inputTp: 'M' },
  { key: 'DUMMY_YN', header: 'Dummy', width: 60, align: 'L', inputTp: 'S' },
  { key: 'SORT_ORDER', header: 'SortOrder', width: 10, align: 'L', visible: false, inputTp: 'S' },
];

// §1.4 Level4 (Building/Factory) — 데이터 11컬럼
const LEVEL4_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_ID', header: 'Site*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_NAME', header: 'Site Name', width: 110, align: 'L', visible: false, inputTp: 'S' },
  { key: 'COMPANY_ID', header: 'Company*', width: 100, align: 'L', visible: false, inputTp: 'S' },
  {
    key: 'COMPANY_NAME',
    header: 'Company Name',
    width: 120,
    align: 'L',
    visible: false,
    inputTp: 'S',
  },
  { key: 'PLANT_ID', header: 'Plant*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'PLANT_NAME', header: 'Plant Name', width: 120, align: 'L', visible: false, inputTp: 'S' },
  { key: 'FACTORY_ID', header: 'Building*', width: 130, align: 'L', inputTp: 'IM' },
  { key: 'FACTORY_NAME', header: 'Building Name', width: 170, align: 'L', inputTp: 'M' },
  { key: 'DUMMY_YN', header: 'Dummy', width: 60, align: 'L', inputTp: 'S' },
  { key: 'SORT_ORDER', header: 'SortOrder', width: 10, align: 'L', visible: false, inputTp: 'S' },
];

// §1.5 Level5 (Line) — 데이터 15컬럼 (VALID_YN 만 콤보 + align C)
const LEVEL5_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_ID', header: 'Site*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'SITE_NAME', header: 'Site Name', width: 110, align: 'L', visible: false, inputTp: 'S' },
  { key: 'COMPANY_ID', header: 'Company*', width: 100, align: 'L', visible: false, inputTp: 'S' },
  {
    key: 'COMPANY_NAME',
    header: 'Company Name',
    width: 120,
    align: 'L',
    visible: false,
    inputTp: 'S',
  },
  { key: 'PLANT_ID', header: 'Plant*', width: 60, align: 'L', visible: false, inputTp: 'S' },
  { key: 'PLANT_NAME', header: 'Plant Name', width: 120, align: 'L', visible: false, inputTp: 'S' },
  { key: 'FACTORY_ID', header: 'Building*', width: 100, align: 'L', visible: false, inputTp: 'S' },
  {
    key: 'FACTORY_NAME',
    header: 'Building Name',
    width: 150,
    align: 'L',
    visible: false,
    inputTp: 'S',
  },
  { key: 'LINE_ID', header: 'Line*', width: 150, align: 'L', inputTp: 'IM' },
  { key: 'LINE_NAME', header: 'Line Name', width: 180, align: 'L', inputTp: 'M' },
  { key: 'SHOP_GROUP_ID', header: 'Operation Group', width: 120, align: 'L', inputTp: 'S' },
  { key: 'DUMMY_YN', header: 'Dummy', width: 60, align: 'L', inputTp: 'S' },
  {
    key: 'VALID_YN',
    header: 'Valid Y/N*',
    width: 100,
    align: 'C',
    inputTp: 'O',
    cell: 'combo',
    comboId: COMBO.VALID,
  },
  { key: 'SORT_ORDER', header: 'SortOrder', width: 10, align: 'L', visible: false, inputTp: 'S' },
];

// 합계 5+7+9+11+15 = 47 = 00_checklist §3-B gridColumns n(47). design 03 §1 대사 일치.
export const LEVEL_COLUMNS: Record<LevelNo, ColumnMeta[]> = {
  1: LEVEL1_COLUMNS,
  2: LEVEL2_COLUMNS,
  3: LEVEL3_COLUMNS,
  4: LEVEL4_COLUMNS,
  5: LEVEL5_COLUMNS,
};

// 필수검증 alert 문구용 컬럼 라벨('*' 제외) — 화면 커스텀 검증(CheckDummyDuplication 등가)이 쓴다.
export const COLUMN_LABEL: Record<string, string> = {
  SITE_ID: 'Site',
  SITE_NAME: 'Site Name',
  COMPANY_ID: 'Company',
  COMPANY_NAME: 'Company Name',
  PLANT_ID: 'Plant',
  PLANT_NAME: 'Plant Name',
  FACTORY_ID: 'Building',
  FACTORY_NAME: 'Building Name',
  LINE_ID: 'Line',
  LINE_NAME: 'Line Name',
};

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 실측 2026-09-23 ora.py — Hook #114).
//   AS-IS 번호를 그대로 쓰지 않는다. AS-IS MSG00004 는 "{0}개 저장되었습니다"(저장성공)지만
//   TO-BE MSG00004 는 "No changes to save." 다 — 번호가 아니라 문구로 매핑한다.
//   자매 SCP0033/SSP0024 역매핑 재사용(동일 도메인 메시지 레지스트리 공유).
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (AS-IS MSG00004 저장건수 메시지 대응, cs:933)
  SAVE_FAIL: 'MSG00003', // "Failed to save." (SAVE 반환 첫 행 != 'S', cs:958~961)
  NO_DATA: 'MSG00004', // "No changes to save." (저장 대상 0건 = 무변경)
  DUP_KEY: 'MSG00060', // "Duplicate key exists." (SAVE SP THROW 99020 표면화, 07 §3 S3)
  REQUIRE_DIVISION: 'MSG00097', // "Please select Division." (조회 전 Division 미선택)
  EDIT_AFTER_SEARCH: 'MSG00662', // "Edit mode is available after search." (미조회/비편집 상태 Insert 안내)
} as const;
