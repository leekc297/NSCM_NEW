export const MENU_ID = 'SCP0024' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0024_ProductionPlanFix (생산계획 확정, Production Plan Fix)
//   설계 근거: .atlas/gscm-design/SCP0024/design/00_checklist.md ~ 03_grid-columns.md (v2, DB 실측).
//   화면 유형: measure-행 pivot(Prod Plan / Fix Reason) + 동적 기간컬럼(D_/W_/M_) + fix/unfix 액션.
//   - 메인 GET : PKG_SCP0024.P_SCP0024_GET_PROD_PLAN_FIX (9 IN + O_RC1 단일커서)
//   - 저장 A   : P_SCP0024_SAVE_PLAN_FIX_DS (JSON CLOB, 표준) — P_DATA/P_USER_ID
//   - 저장 B   : P_SCP0024_SAVE_PROD_PLAN_FIX (^ unpivot, 레거시)
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M(SCP0024)=main/SEARCH·main/SAVE 등록(05_register.sql, ora.py).
//     SP 배포 완료(PKG_SCP0024 VALID). 편집셀 = D_(일자) × Prod Plan measure 행 QTY 만(design 03 §3-보강).
export enum SHEETS {
  MAIN = 'main', // spdMain siMain — measure-행 pivot 그리드 (GET SP 단일커서 O_RC1)
}

// NSCM 단일 cursor 표준 'o_rc1' (GET SP O_RC1 — design 03 §0/§2.3).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 컬럼 메타는 'Model' 시트로 등록됨.
//   실측: PROGRAM_ID='SCP0024' SHEET_NAME='Model' 12행(ora.py 2026-09-24) → admin fetch authoritative.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Model',
};

// Measure 메타 SHEET_NAME — pivot measure 축. 실측: SHEET_NAME='PRODUCTION_PLAN_FIX' 2행(Prod Plan/Fix Reason).
export const MEASURE_SHEET_NAME = 'PRODUCTION_PLAN_FIX';

// Bucket — cboBucketType(BucketType 콤보, DAILY/WEEKLY/MONTHLY 실측 — design 02 §2.2).
//   기본 DAILY: 편집 band 가 D_(일자) × Prod Plan 셀이라(design 03 §3-보강) 진입 시 D_ 노출·편집 가능하도록.
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// 편집/파생 대상 measure 행 (design 03 §1.B / §2.2).
//   Prod Plan = D_/W_/M_ 수량(QTY, D_ 편집 대상 · W_/M_ SUM 롤업 읽기전용).
//   Fix Reason = D_ 셀에만 확정사유 텍스트(W_/M_ NULL), 읽기전용(SAVE SP 는 QTY 만 저장).
export const MEASURE_PROD_PLAN = 'Prod Plan';
export const MEASURE_FIX_REASON = 'Fix Reason';

// division EE 여부 — 앞2자 'EE'. AS-IS 원식 확정(gap-resolve iter-2, GSCM 소스 리포 반입):
//   SCP0024_ProductionPlanFix.cs:473/779/789/805/833 전건 `_division.Substring(0, 2).Equals("EE")` — 정확 재현(근사 아님).
export const DIVISION_EE_PREFIX = 'EE';
// EE division 에서만 표시되는 컬럼 (gridSignals #3~#6 — 두 컬럼 함께 on/off, design 03 §2.5/R-C).
export const EE_ONLY_COLUMNS = ['ORIGIN_DIVISION_ID', 'ELECTRODE_TYPE'] as const;

// Fix/Unfix 실행 타입 (design 01 R3 — SaveData(Fix) / SaveData_FixInfo_U(Unfix)).
//   ACTIVE_FLAG(_DS JSON) 로 서버 I/M/D 결정, FIX_MODE 로 확정/해제 구분(버튼-API 배선 확정 대기, design 03 §6 #7).
export type FixMode = 'F' | 'U';

// 기간 프리셋 (design 01 §2 / 02 §C10~C12 btnW26/W52/WLast — GetDayRange offset=주×7-1).
export const PRESET_W26 = 26;
export const PRESET_W52 = 52;

// btnWLast 라벨 주차 = AS-IS GetLastRange(division)(GetDayRange periodType 'Last', design 02 §7-4).
//   자매 SCP0022(production-plan-line) 선례와 동일 구조: GetLastRange SP(SCM0001_GET_SCP_DAILY_PLAN_PERIOD)가
//   반환하는 주차를 wLastPeriod 로 받아 라벨/구간에 반영하고, '52'면 btnWLast 를 숨긴다. SP 미배선(convert-sp 후속)이라
//   현재 wLastPeriod='' 로 넘겨 W26 로 fallback(react-gap-audit B1 — 자매도 동일 'SP 미배선 근사').
export const W_LAST_HIDE_PERIOD = '52';

// 조회조건 콤보 ID — DB 실측 등록 확인 (SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py 2026-09-24, design 02 §2).
//   AS-IS CommonAll(전량 로드) + C# 후처리 DBUtils.Filter(F1~F4) — TO-BE _SCP_ALL 콤보는 서버쿼리만 이관됐고
//   AS-IS 소스 필터(DIVISION_ID/OPERATION_GROUP/SITE_ID)는 화면에서 클라 재현한다(convert-core §2.6 콤보 의미 패리티).
//   접미어(ProdPlan1/ByDivisionOperation1/ProdPlanLine1/ByOperationAddOSP1, EE 유무)가 별개 콤보 — 이름 유사 재사용 금지.
export const COMBO = {
  DIVISION: 'Division_SCP', // S1 — EE 사업부 포함(design 02 §2.1, cf. MyDivision 은 EE 제외)
  OP_GROUP: 'OperationGroup_SCP', // S8 비EE (SEGMENT1 IN ('P','A') — Pack/Cell)
  OP_GROUP_EE: 'OperationGroupEE_SCP', // S7 EE (SEGMENT1 IN ('A','E') — Cell/Electrode)
  PLANT_SITE_EE: 'PlantSiteProdPlan1_SCP_ALL', // S2 EE pool — 반환 DIVISION_ID/OPERATION_GROUP → 클라 F1 필터
  PLANT_SITE: 'PlantByDivisionOperation1_SCP_ALL', // S3 비EE pool — 반환 DIVISION_ID/OPERATION_GROUP → 클라 F2 필터
  LINE_EE: 'LineProdPlanLine1_SCP_ALL', // S4 EE pool — bind 부재, 클라 F3 필터('-' sentinel)
  LINE: 'LineByOperationAddOSP1_SCP_ALL', // S5 비EE pool — bind 부재, 클라 F4 필터(SN+OSP+P5000 UNION)
  BUCKET: 'BucketType', // C6 — DAILY/WEEKLY/MONTHLY
} as const;

// cboElectrode — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2.3 실측).
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';

// Operation Group 코드 (design 02 §2.3 lookup OPERATION_GROUP): P=Pack / A=Cell / E=Electrode.
//   EE 분기(S7)=A,E · 비EE 분기(S8)=P,A → A(Cell)=공통, E=EE 전용, P=비EE 전용.
export const OP_GROUP_CELL = 'A';
export const OP_GROUP_PACK = 'P';
export const OP_GROUP_ELECTRODE = 'E';

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114). AS-IS 번호를 그대로 두면 TO-BE 에서 같은
//   번호가 전혀 다른 문구로 등록돼 있어 오표시된다(자매 SCP0013/SCP0020 검증 매핑과 정합).
//   AS-IS: MSG00003(실패)/00004(성공)/00006(성공후속)/00016(confirm)/00046(삭제)/00096(권한)/00109(편집가드)/00134(셀선택).
export const MSG = {
  NO_PERMISSION: 'MSG00096', // No permission. (TO-BE 동일 — 유지)
  SELECT_CELL: 'MSG00014', // No row/cell selected. (AS-IS MSG00134 selCells<1 — 자매 SELECT_TARGET 정합)
  // {0} value is required. — AS-IS 프레임워크 checkRequiredOfSearch(DataUtil.cs:427-553, 라벨 '*' 컨트롤 빈값/'ALL' 차단
  //   MSG00002) 재현. Designer 실측 라벨 Division*/Operation Group*/Period*(Designer.cs:723/734/898).
  //   구 MSG00002 는 TO-BE 에서 "Saved successfully." 오표시 — 자매 SCP0013/SCP0020 과 동일하게 MSG00429 재매핑(ora.py 2026-09-25).
  REQUIRED_FIELD: 'MSG00429',
  // No data to delete. — AS-IS Unfix 수집 0건 MSG00046("삭제할 데이터가 없습니다", cs:1535-1539).
  //   TO-BE 는 MSG00046 미등록(ora.py 2026-09-25 0행) → 동일 의미 MSG01078 실측 재매핑.
  NO_DELETE_DATA: 'MSG01078',
  CONFIRM_UNFIX: 'MSG01438', // Do you want to release? (AS-IS MSG00016 confirm — 자매 SCP0013 CONFIRM_UNFIX). 번들 미포함→fallback
  CONFIRM_FIX: 'MSG01034', // Do you want to confirm? (AS-IS MSG00016 은 TO-BE 에서 "page not found" 로 등록됨 — react-gap-audit I1. DB 실측(SCM_ADM_MSG_M) 재매핑, CONFIRM_UNFIX(MSG01438 release)와 대칭)
  SAVE_SUCCESS: 'MSG00004', // No changes to save. (변경없음 토스트 — 자매 정합)
  SAVE_FAIL: 'MSG00003', // Failed to save. (TO-BE 동일)
  PERIOD_RANGE: 'MSG00108', // Invalid period (start > end). (자매 START_END_ORDER 정합)
  QTY_NEGATIVE: 'MSG00225', // Quantity must be 0 or greater. (자매 정합)
  QTY_OVERFLOW: 'MSG00165', // You have exceeded the number of digits you can enter. (자매 정합). 번들 미포함
  SEARCH_FIRST: 'MSG00662', // Edit mode is available after search. (자매 INSERT_GUIDE 정합)
} as const;

// i18n 라벨 — DB 실측 LBL ID(design 02 §4.5) + defaultValue(AS-IS Designer 문구). 하드코딩 금지(Hook #87§L).
export const LABEL = {
  DIVISION: 'Division', // LBL00641
  OPERATION_GROUP: 'Operation group', // LBL00027
  PLANT_SITE: 'Plant Site', // LBL00005
  LINE: 'Line', // LBL00010
  ELECTRODE: 'Electrode', // LBL00038
  BUCKET: 'Bucket', // LBL00710
  PERIOD: 'Period', // LBL00013
  ITEM: 'Item', // LBL01142
  SUM: 'Sum', // chkSum — 재사용 LBL00687='Sum'(EN/KO/CN, ora.py 2026-09-24) defaultValue. Form 이 t('LBL00687') 로 조회
  MEASURE: 'Measure',
  SEARCH: 'Search',
  UNFIX: 'Unfix',
  FIX: 'Fix',
  ALL: 'ALL',
} as const;

// 수량 범위 (design 03 §3 파생 white-list — QTY 정수, 반올림).
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;

// pivot 셀 색상 파리티 (design 03 §2.1 R-A — 요일 헤더 색: 토=파랑/일=빨강).
export const WEEKEND_COLOR = {
  SATURDAY: '#1976d2', // 토 Blue (gridSignals #7 ForeColor)
  SUNDAY: '#d32f2f', // 일 Red
} as const;

// pivot 컬럼 시작점 — MEASURE 다음부터 동적 기간 컬럼(design 03 §1.C / §2.6, FIXED=MEASURE 까지 frozen).
export const PIVOT_ANCHOR_COLUMN = 'MEASURE';

// ===== 고정/정보·키 컬럼 12건 (DB 실측 fallback, design 03 §1.A / ora.py 2026-09-24) =====
//   admin(SCM_MST_SHEET_COLUMNS SHEET_NAME='Model') 등록본이 있으면 authoritative, 없으면 이 fallback.
//   전건 INPUT_TP_CD='S'(표시전용) — 편집은 동적 D_ pivot 셀(Prod Plan 행)에만 발생.
//   VISIBLE_FLAG=N: OPERATION_GROUP·SCM_SITE_ID(코드 원본, 이름 컬럼만 노출). ORIGIN_DIVISION_ID/ELECTRODE_TYPE 는 EE 조건부.
export interface FixedColumnMeta {
  key: string;
  header: string;
  sort: number;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  fixed?: boolean;
}

export const FIXED_COLUMNS: FixedColumnMeta[] = [
  { key: 'OPERATION_GROUP', header: 'Operation Group', sort: 1, width: 60, align: 'C', visible: false },
  { key: 'SCM_SITE_ID', header: 'Plant Site', sort: 2, width: 80, align: 'L', visible: false },
  { key: 'DIVISION_ID', header: 'Division', sort: 3, width: 60, align: 'C', visible: true },
  // EE division 만 표시 (design 03 §2.5 gridSignals #3~#6)
  { key: 'ORIGIN_DIVISION_ID', header: 'Origin Div', sort: 4, width: 60, align: 'C', visible: true },
  { key: 'OPERATION_GROUP_NAME', header: 'Operation Group', sort: 5, width: 60, align: 'L', visible: true },
  { key: 'SCM_SITE_DESCRIPTION', header: 'Plant Site', sort: 6, width: 80, align: 'L', visible: true },
  { key: 'ITEM_ID', header: 'Material', sort: 7, width: 130, align: 'L', visible: true },
  { key: 'NICK_NAME', header: 'Nick Name', sort: 8, width: 100, align: 'L', visible: true },
  // EE division 만 표시 (design 03 §2.5 gridSignals #3~#6)
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', sort: 9, width: 60, align: 'C', visible: true },
  { key: 'LINE_ID', header: 'Line', sort: 10, width: 80, align: 'L', visible: true },
  { key: 'OPERATION_ID', header: 'Operation ID', sort: 11, width: 80, align: 'L', visible: true },
  { key: 'MEASURE', header: 'Measure', sort: 12, width: 80, align: 'L', visible: true, fixed: true },
];
