export const MENU_ID = 'SCP0025' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0025_ShipmentPlanFix (출하계획 확정, Shipment Plan Fix)
//   설계 근거: .atlas/gscm-design/SCP0025/design/00_checklist.md ~ 03_grid-columns.md (v2, DB·SP 실측).
//   화면 유형: read-only 조회 pivot(Ship Plan / Fix Reason measure 행) + 동적 기간컬럼(D_/W_/M_) + 셀선택→Unfix.
//   - 메인 GET : PKG_SCP0025.P_SCP0025_GET_SHIP_PLAN_FIX (10 IN + O_RC1/O_RC2/O_RESULT_CURSOR)
//   - 저장     : PKG_SCP0025.P_SCP0025_SAVE_FIX_DATASET (P_DATA JSON CLOB, P_USER_ID)
//   자매 SCP0024(production-plan-fix)와 핵심 차이: SCP0025 는 20컬럼 전건 INPUT_TP_CD='S'(전 컬럼 잠금)라
//     편집 그리드가 아니다. Unfix 는 셀 편집이 아니라 셀 선택 → 역산 키에 ACTIVE_FLAG='D' → SAVE SP 전송.
//     SAVE SP 는 실측상 Unfix 전용(확정 테이블 write 는 ACTIVE_FLAG='D' DELETE 뿐, Fix-insert 경로 없음 —
//     PKG_SCP0025 body L749 DELETE/L686 history INSERT, 그 외 확정 테이블 write 없음). 따라서 SAVE 버튼·btnUnfix
//     둘 다 Unfix 동작으로 배선(design 03 §0 — "TO-BE SAVE 버튼 + ACTIVE_FLAG='D' 로 재현").
//   버튼-API 배선(DB 실측 2026-09-24): SCM_ADM_MNU_BTN_MPG_M(SCP0025) main/SEARCH→P_SCP0025_GET,
//     main/SAVE→P_SCP0025_SAVE 등록·USE_YN='Y'. 권한(USER_GR_*)·컬럼메타(20)·콤보/lookup 전건 등록 확인(05_register.sql).
export enum SHEETS {
  MAIN = 'main', // spdMain siMain — read-only pivot 그리드 (GET SP O_RC1)
}

// NSCM 단일 cursor 표준 'o_rc1' (GET SP O_RC1 — design 03 §0/§2.3). O_RC2(Fix Reason 상세)는 별도 병합.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — 컬럼 메타는 'Shipment Plan Fix' 시트로 등록됨.
//   실측: PROGRAM_ID='SCP0025' SHEET_NAME='Shipment Plan Fix' 20행(ora.py 2026-09-24) → admin fetch authoritative.
//   주의(design 03 §0): 컬럼 메타 fetch 키는 ('SCP0025','Shipment Plan Fix'), 데이터 호출 sheetName 은 'main'(SHEETS.MAIN)로 축이 다르다.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Plan Fix',
};

// Measure 메타 — SCM_MST_SHEET_MEASURE PROGRAM_ID='SCP0025' 0행(실측). 동적 measure 없음 → fetch 스킵.
//   measure 는 PIVOT measure 레지스트리가 아니라 일반 데이터 컬럼(행종류 라벨 Ship Plan/Fix Reason).

// Bucket — cboBucketType(BucketType 콤보, DAILY/WEEKLY/MONTHLY 실측 — design 02 §2.2).
//   변경 = 그리드 기간컬럼 visible 재계산만(재조회 없음 — GET SP 가 전 버킷 상주, design 03 §2.2).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// measure 행종류 라벨 (design 03 §2.3). Ship Plan = 수량(number), Fix Reason = 확정사유 텍스트(O_RC2 매핑).
export const MEASURE_SHIP_PLAN = 'Ship Plan';
export const MEASURE_FIX_REASON = 'Fix Reason';

// EE division 그룹 — FN_GET_DIVISION_DIV('EE') 실측 목록(design 03 §2.7). division ∈ 이 목록이면
//   ELECTRODE_TYPE/ORIGIN_TO_DIVISION_ID/ORIGIN_FROM_DIVISION_ID 3컬럼 노출, 아니면 숨김(gridSignals #2~#7, R-D).
export const EE_DIVISION_GROUP = ['EE', 'EE_HD', 'EE_HG', 'EE_HM', 'EE_ST', 'EE_UC'] as const;
// EE division 에서만 표시되는 컬럼 (design 03 §2.7 R-D — 세 컬럼 함께 on/off).
export const EE_ONLY_COLUMNS = ['ELECTRODE_TYPE', 'ORIGIN_TO_DIVISION_ID', 'ORIGIN_FROM_DIVISION_ID'] as const;

// 기본 조회기간 시드용 프리셋 (AS-IS CreateSpread 기본 GetDayRange(W52) — offset=주×7-1).
export const PRESET_W52 = 52;

// 조회조건 콤보 ID — DB 실측 등록 확인(SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py 2026-09-24, design 02 §2).
//   접미어(EE 유무)가 별개 콤보 — 이름 유사 재사용 금지(convert-core §2.6). MyDivision(EE 제외)은 오답(§2.2).
export const COMBO = {
  DIVISION: 'Division_SCP', // S1 — EE 사업부 포함·권한필터(design 02 §2.1). MyDivision(EE 제외) 재사용 금지
  OP_GROUP: 'OperationGroup_SCP', // S4 비EE (SEGMENT1 IN ('P','A') — Pack/Cell)
  OP_GROUP_EE: 'OperationGroupEE_SCP', // S5 EE (SEGMENT1 IN ('A','E') — Cell/Electrode)
  BUCKET: 'BucketType', // C4 — DAILY/WEEKLY/MONTHLY
  PLAN_EXEC_YN: 'PlanExecYn_SCP', // R3 게이트 — @divisionId 로 PLAN_STATUS 조회(design 01 R3, comboCall §4b #5)
} as const;

// clbElecType — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2.3 실측).
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';

// Operation Group 코드 (design 02 §2 lookup OPERATION_GROUP): P=Pack / A=Cell / E=Electrode.
export const OP_GROUP_CELL = 'A';
export const OP_GROUP_PACK = 'P';
export const OP_GROUP_ELECTRODE = 'E';

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114). AS-IS 번호를 그대로 두면 TO-BE 에서 같은 번호가
//   전혀 다른 문구로 등록돼 오표시된다. 공용 메시지는 자매 SCP0024 가 DB 실측(SCM_ADM_MSG_M)한 TO-BE 코드를 재사용.
//   AS-IS: MSG00096(권한)/MSG00304(계획미실행)/MSG00134(셀선택)/MSG00016(confirm)/MSG00003(실패)/MSG00004(성공)/MSG00108(기간)/MSG00109(편집가드).
export const MSG = {
  NO_PERMISSION: 'MSG00096', // No permission. (R2 — TO-BE 동일, 자매 SCP0024 검증)
  // Weekly Plan 수행중 — unfix 불가 (R3 게이트, PLAN_STATUS='0'). AS-IS MSG00304("Weekly Plan 수행중입니다. Plan
  //   수행완료 후 시도해주세요." cs:768) → TO-BE 미등록(SCM_ADM_MSG_M MSG00304 0행, ora.py 실측). 동일 문구가 이미
  //   MSG01307("Weekly Plan Processing now. Please try after finishing the plan." EN/KO/CN 3행 등록)로 실재 →
  //   AS-IS 번호 재사용 금지(Hook #114)에 따라 등록된 TO-BE 코드로 역매핑. 신규 문구 생성 아님(convert-core §2.3).
  PLAN_NOT_EXEC: 'MSG01307',
  SELECT_CELL: 'MSG00014', // No row/cell selected. (AS-IS MSG00134 selCells<1 — 자매 SCP0024 SELECT_CELL 정합)
  CONFIRM_UNFIX: 'MSG01438', // Do you want to release? (AS-IS MSG00016 confirm — 자매 SCP0024 CONFIRM_UNFIX 정합)
  SAVE_SUCCESS: 'MSG00004', // No changes to unfix. (변경/대상없음 토스트 — 자매 정합)
  PERIOD_RANGE: 'MSG00108', // Invalid period (start > end). (자매 PERIOD_RANGE 정합)
  SEARCH_FIRST: 'MSG00662', // Action available after search. (R1 조회선행 — 자매 SEARCH_FIRST 정합)
} as const;

// i18n 라벨 코드 — DB 실측 LBL ID(SCM_ADM_MSG_M, design 02 §4.5). 표준 화면(bod-item·shipment-working-day)
//   정합: 코드를 상수로 정의하고 호출부에서 t(LBL.X, '_fallback') 로 조회한다.
export const LBL = {
  DIVISION: 'LBL00001',
  OPERATION_GROUP: 'LBL00027',
  ELECTRODE: 'LBL00038', // 정확 "Electrode Type" LBL 부재 — 근접 사용(design 02 §4.5)
  BUCKET: 'LBL00710',
  PERIOD: 'LBL00013',
  ITEM: 'LBL00618',
  SUM: 'LBL00687', // EN/KO/CN 실측(ora.py 2026-09-30)
  SEARCH: 'LBL00112',
  UNFIX: 'LBL00772', // EN/KO/CN 실측(ora.py 2026-09-24)
} as const;

// pivot 셀 색상 파리티 (design 03 §2.4 R-A — 요일 헤더 색: 토=파랑/일=빨강, gridSignals #29 ForeColor).
export const WEEKEND_COLOR = {
  SATURDAY: '#1976d2', // 토 Blue
  SUNDAY: '#d32f2f', // 일 Red
} as const;

// pivot 컬럼 시작점 — measure 다음부터 동적 기간 컬럼(design 03 §1 #14 / §2.6, FIXED=measure 까지 frozen).
export const PIVOT_ANCHOR_COLUMN = 'measure';

// ===== 정적/정보·키 컬럼 20건 (DB 실측 fallback, design 03 §1 / ora.py 2026-09-24) =====
//   admin(SCM_MST_SHEET_COLUMNS SHEET_NAME='Shipment Plan Fix') 등록본이 authoritative(20행 실측), 없으면 이 fallback.
//   전건 INPUT_TP_CD='S'(표시전용, 전 컬럼 잠금 — 편집 그리드 아님). VIS=Y 14 / 숨김 6.
//   EE 조건부(ELECTRODE_TYPE/ORIGIN_TO_DIVISION_ID/ORIGIN_FROM_DIVISION_ID)는 런타임 가시성 override(design 03 §2.7).
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
  { key: 'division_id', header: 'Division', sort: 1, width: 40, align: 'C', visible: true },
  { key: 'biz_type_name', header: 'Operation Group', sort: 2, width: 80, align: 'L', visible: true },
  { key: 'item_id', header: 'Model', sort: 3, width: 95, align: 'L', visible: true },
  { key: 'nick_name', header: 'Nick Name', sort: 4, width: 65, align: 'L', visible: true },
  // EE division 만 표시 (design 03 §2.7 R-D)
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', sort: 5, width: 60, align: 'L', visible: true },
  { key: 'ORIGIN_TO_DIVISION_ID', header: 'Origin To Div', sort: 6, width: 60, align: 'L', visible: true },
  { key: 'to_site_description', header: 'To Site', sort: 7, width: 65, align: 'L', visible: true },
  // EE division 만 표시 (design 03 §2.7 R-D)
  { key: 'ORIGIN_FROM_DIVISION_ID', header: 'Origin From Div', sort: 8, width: 60, align: 'L', visible: true },
  { key: 'from_site_description', header: 'From Site', sort: 9, width: 70, align: 'L', visible: true },
  { key: 'incoterms', header: 'Incoterms', sort: 10, width: 45, align: 'L', visible: true },
  { key: 'project_code', header: 'Project Code', sort: 11, width: 85, align: 'L', visible: true },
  { key: 'transport_mode', header: 'Trans Mode', sort: 12, width: 40, align: 'L', visible: true },
  { key: 'lt_total', header: 'L/T(Day)', sort: 13, width: 45, align: 'R', visible: true },
  { key: 'measure', header: 'Measure', sort: 14, width: 80, align: 'L', visible: true, fixed: true },
  // 숨김 키/표시명 소스 컬럼 (design 03 §1 #15~#20)
  { key: 'division_name', header: 'Division', sort: 15, width: 80, align: 'L', visible: false },
  { key: 'biz_type', header: 'BIZ_TYPE', sort: 16, width: 110, align: 'R', visible: false },
  { key: 'to_site', header: 'To Site', sort: 17, width: 110, align: 'L', visible: false },
  { key: 'from_site', header: 'FROM_SITE', sort: 18, width: 110, align: 'L', visible: false },
  { key: 'BOD_ID', header: 'BOD_ID', sort: 19, width: 50, align: 'C', visible: false },
  // to_yyyymmdd: O_RC1 미반환(design 03 §6 #1 불일치) — 레거시 hidden 키. 실렌더 대사 확인필요.
  { key: 'to_yyyymmdd', header: 'to_yyyymmdd', sort: 20, width: 140, align: 'C', visible: false },
];
