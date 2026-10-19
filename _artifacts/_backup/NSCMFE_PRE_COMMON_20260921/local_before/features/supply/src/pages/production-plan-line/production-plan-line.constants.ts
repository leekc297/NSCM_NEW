export const MENU_ID = 'SCP0013' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0013_ProductionPlanLine — 단일 메인 그리드(spdMain siMain) + Load 팝업.
//   설계 근거: .atlas/gscm-design/SCP0013/design/00_checklist.md ~ 03_grid-columns.md (v2, DB 실측).
//   - 메인 GET  : PKG_SCP0013.P_SCP0013_GET_PROD_PLAN_LINEBY (22 IN + O_RC1~O_RC4)
//   - 편집판정  : P_SCP0013_GET_PLAN_EDIT_INFO(11 IN) / 저장가능 P_SCP0013_GET_PLAN_SAVE_YN(3 IN)
//   - Line 재조회: P_SCP0013_GET_LINE_LIST(5 IN, cellTypeGr 선택 시)
//   - Load 팝업 : P_SCP0013_LINE_LOAD_POPUP
//   - 저장       : P_SCP0013_SAVE_LINE_ROW / _DS (PROD_PLAN_AMEND 편집셀)
//   주의: SCM_ADM_MNU_BTN_MPG_M(SCP0013)=0행 → 버튼-API 배선 미등록(조회/저장 실행체인 미배선).
//         admin(SYS0004 등) 등록 후 실동작(convert-core §2.3 — AI 임의 INSERT 금지). design 03 §6.
export enum SHEETS {
  MAIN = 'main', // spdMain siMain — 메인 pivot 그리드 (Line 시트, 27 고정 + D_/W_/M_ 동적)
  LOAD = 'load', // Load 팝업 그리드 (읽기전용 선택 로드)
}

// NSCM 단일 cursor 표준 'o_rc1' (RC2 fix / RC3·RC4 ratio 는 파생 보정 — design 03 §4.2).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  LOAD: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   실측: PROGRAM_ID='SCP0013' SHEET_NAME='Line' 27행 등록됨(ora.py 2026-09-16) → admin fetch authoritative.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Line',
};

// Bucket — cboBucketType(BucketType 콤보, DAILY/WEEKLY/MONTHLY). 기본 WEEKLY (design 01 A1 / 02 §4.3).
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// 편집 대상 measure — PROD_PLAN_AMEND 행만 편집 가능 (design 03 §1 #12 Measure / cs:684).
export const EDITABLE_MEASURE = 'PROD_PLAN_AMEND';
// LINE_TOTAL% measure 접두 — pivot 집계 시 SUM/CNT 평균 (design 03 §1 Measure #6/#7 / lineby.sql:1919).
export const LINE_TOTAL_MEASURE_PREFIX = 'LINE_TOTAL';

// division 특수 코드 (design 01 §2 B1/B3/B5, 02 §2.3).
export const DIVISION_CELL_TYPE = '40'; // div=40 → CellTypeGr/ExtraSpec enable + 관련 컬럼 표시
export const DIVISION_EE_PREFIX = 'EE'; // div 앞2자 EE → OperationGroup 코드셋 EE 전용 + EE 컬럼 표시
// Operation Group 코드 (design 01 C1/C2, 03 §4.4 lookup OPERATION_GROUP).
export const OP_GROUP_CELL = 'A'; // Cell
export const OP_GROUP_PACK = 'P'; // Pack
export const OP_GROUP_ELECTRODE = 'E'; // Electrode
// Electrode ALL 고정 대상 opGroup (Cell/Pack 선택 시 ALL+disable — design 01 C1).
export const ELECTRODE_LOCK_OP_GROUPS = [OP_GROUP_CELL, OP_GROUP_PACK] as const;
// Plan Type 확정/임시 — Fix/Unfix/New 불가 (design 01 D1 / 02 §4.4).
export const PLAN_TYPE_EXCLUDE_FIX = ['FN', 'TE'] as const;
// W-last 프리셋 숨김 기준 주차 (design 01 A3 — GetLastRange(division)==52 면 btnWLast 숨김).
export const W_LAST_HIDE_PERIOD = '52';

// 기간 프리셋 (design 01 H5 / 02 §2.1 btnW26/W52/WLast — GetDayRange 주차×7-1 offset).
export const PRESET_W26 = 26;
export const PRESET_W52 = 52;

// 조회조건 콤보 ID — DB 실측 등록 확인 (SCM_ADM_CMBO_SQL_M USE_YN='Y', ora.py 2026-09-16, design 02 §2.3/§2.4).
//   AS-IS 는 CommonAll(전체 로드) + C# 후처리 DBUtils.Filter — TO-BE _SCP_ALL 콤보는 서버쿼리만 이관됐고
//   AS-IS 소스 필터(DIVISION_ID/OPERATION_GROUP/SITE_ID/PLANDATE/PLANTYPE)는 화면에서 클라 재현한다
//   (convert-core §2.6 콤보 의미 패리티 — 반환 컬럼으로 클라 필터, Form 에서 재현).
export const COMBO = {
  // cboDivision — 권한 division. 주의: AS-IS 는 MyDivision 권한목록(BLUtils.GetDivision), TO-BE 범용
  //   'Division' 은 SCM_MST_DIVISION 전체라 권한 미반영 가능(design 02 §7 확인 필요). 등록 확인됨.
  DIVISION: 'Division',
  OP_GROUP: 'OperationGroup_SCP', // 비EE (SEGMENT1 IN ('P','A'))
  OP_GROUP_EE: 'OperationGroupEE_SCP', // EE (SEGMENT1 IN ('A','E')) — 접미 EE = 별개 콤보(코드셋 상이)
  CELL_TYPE_GR: 'CellTypeGr_SCP', // div=40 only (LOOKUP CELL_TYPE_GROUP_CODE R/C/P)
  PLANT_SITE: 'PlantByDivisionOperation1_SCP_ALL', // 반환 DIVISION_ID/OPERATION_GROUP → 클라 필터
  LINE: 'LineByOperationAddOSP1_SCP_ALL', // 반환 DIVISION_ID/SITE_ID/OPERATION_GROUP → 클라 필터, '-' sentinel
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 반환 DIVISION_ID → 클라 필터, CODE=plan_start_yyyymmdd
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE → 클라 필터
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE/PLANTYPE → 클라 필터
  BUCKET: 'BucketType', // DAILY/WEEKLY/MONTHLY
} as const;
// cboElectrode — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2.2 실측).
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';
// clbExtraSpec — AS-IS SCP0013_GET_EXTRA_SPEC(div=40) 등가 TO-BE 콤보 미탐(design 02 §7 확인 필요).
//   전용 콤보 미등록 → 옵션 미공급(div=40 에서만 노출되므로 실사용 영향 제한). admin 등록 후 배선.
export const EXTRA_SPEC_COMBO = '' as const;

// AS-IS Validation MSG ID (design 00 §4-D 31건). AS-IS 번호 유지 + 영문 defaultValue fallback.
//   확인 필요(Hook #114): TO-BE SCM_ADM_MSG_M 역매핑 미실행(design 02/03 §확인5) — 등가 코드 확정 후
//   이 상수 교정. 영문 fallback 이라 미등록이어도 문구는 표시됨(엉뚱한 한글 매핑 회피).
export const MSG = {
  REQUIRED_FIELD: 'MSG00002', // {0} 필수 입력
  NO_PERMISSION: 'MSG00096', // 사용권한 없음
  NOT_EDIT_MODE: 'MSG00010', // 시트 잠금(수정모드 아님)
  SAVE_YN_NO: 'MSG00182', // 저장 불가(서버 SAVE_YN=N)
  CONFIRM_RESEARCH: 'MSG00265', // 재조회 확인
  QTY_NEGATIVE: 'MSG00084', // 수량 < 0
  QTY_OVERFLOW: 'MSG00317', // 수량 > 99999999
  NEW_ROW_RED_CELL: 'MSG00026', // 신규행 붉은셀 저장 차단
  SELECT_CELL: 'MSG00134', // 대상 셀 선택 필수
  SELECT_TARGET: 'MSG00007', // 그리드 선택/대상
  LINE_ASSIGN_ITEM: 'MSG00290', // Line Assign 체크 시 Material 필수
  SAVE_SUCCESS: 'MSG00004', // 저장 성공/변경 없음
  SAVE_FAIL: 'MSG00003', // 저장 실패
  PLAN_PERIOD_RANGE: 'MSG00252', // 조회 기간 범위
  INSERT_GUIDE: 'MSG00161', // 조회/선택 후 추가 가능
} as const;

// i18n 라벨 — AS-IS Designer 라벨 문구로 표기(defaultValue). LBL##### TO-BE 코드는 확인 필요(Hook #114).
export const LABEL = {
  DIVISION: 'Division',
  OPERATION_GROUP: 'Operation Group',
  CELL_TYPE_GR: 'Cell Type Gr',
  ELECTRODE: 'Electrode',
  EXTRA_SPEC: 'Extra Spec',
  PLANT_SITE: 'Plant Site',
  LINE: 'Line',
  MODEL: 'Model',
  MATERIAL: 'Material',
  NICK_NAME: 'Nick Name',
  PLAN_DATE: 'Plan-date',
  PLAN_TYPE: 'Plan-type',
  SEQ: 'Seq',
  PERIOD: 'Period',
  BUCKET: 'Bucket',
  ALL: 'ALL',
  LINE_ASSIGN: 'Line Assign',
  SUM: 'Sum',
  FIX: 'Fix',
  UNFIX: 'Unfix',
  NEW: 'New',
  LOAD: 'Load',
  MEASURE: 'Measure',
  SEARCH: 'Search',
} as const;

// 수량 범위 (design 03 §3 파생 white-list — MSG00084 <0 / MSG00317 >99999999).
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;

// ===== 고정 컬럼 27건 (DB 실측 fallback, design 03 §1 / ora.py 2026-09-16) =====
//   admin(SCM_MST_SHEET_COLUMNS SHEET_NAME='Line') 등록본이 있으면 그걸 authoritative 로 쓰고,
//   없으면(미등록) 이 constants 를 fallback 으로 쓴다(tact-time buildColumns 패턴). 전건 INPUT_TP_CD='S'
//   (표시전용) — 편집은 동적 D_/W_ pivot 셀에만 발생. VISIBLE 은 기본값이며 div 별 조건 가시성은
//   productionPlanLineColumns.isFixedColumnVisible 가 런타임 override(design 03 §1 VISIBLE 열).
export interface FixedColumnMeta {
  key: string;
  header: string;
  sort: number;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean; // 기본 가시성(admin VISIBLE_FLAG). 조건 가시성은 isFixedColumnVisible.
  fixed?: boolean; // 좌측 고정(FIXED_FLAG=Y — MEASURE/MEASURE_NAME).
}

export const FIXED_COLUMNS: FixedColumnMeta[] = [
  { key: 'KEY_IDX', header: 'KEY_IDX', sort: 1, width: 40, align: 'L', visible: false },
  { key: 'DIVISION_NAME', header: 'Div', sort: 2, width: 130, align: 'L', visible: false },
  { key: 'OPERATION_GROUP', header: 'Operation Group', sort: 3, width: 60, align: 'L', visible: false },
  { key: 'SCM_SITE_ID', header: 'Plant Site Id', sort: 4, width: 120, align: 'L', visible: false },
  { key: 'FROM_YYYYMMDD', header: 'FROM_YYYYMMDD', sort: 5, width: 40, align: 'L', visible: false },
  { key: 'TO_YYYYMMDD', header: 'TO_YYYYMMDD', sort: 6, width: 40, align: 'L', visible: false },
  { key: 'PLAN_START_YYYYMMDD', header: 'PLAN_START_YYYYMMDD', sort: 7, width: 40, align: 'L', visible: false },
  { key: 'PLAN_TYPE', header: 'PLAN_TYPE', sort: 8, width: 40, align: 'L', visible: false },
  { key: 'PLAN_SEQ', header: 'PLAN_SEQ', sort: 9, width: 40, align: 'L', visible: false },
  { key: 'CP_KEY', header: 'CP_KEY', sort: 10, width: 40, align: 'L', visible: false },
  { key: 'FIX_KEY', header: 'FIX_KEY', sort: 11, width: 40, align: 'L', visible: false },
  { key: 'MEASURE', header: 'Measure', sort: 12, width: 40, align: 'L', visible: true, fixed: true },
  { key: 'DIVISION_ID', header: 'Div', sort: 13, width: 60, align: 'C', visible: true },
  // EE division 만 표시 (design 03 §1 #14 cs:341/354)
  { key: 'ORIGIN_DIVISION_ID', header: 'Origin Div', sort: 14, width: 60, align: 'C', visible: true },
  { key: 'OPERATION_GROUP_NAME', header: 'Operation Group', sort: 15, width: 60, align: 'L', visible: true },
  { key: 'SCM_SITE_DESCRIPTION', header: 'Plant Site', sort: 16, width: 80, align: 'L', visible: true },
  { key: 'OPERATION_ID', header: 'Operation ID', sort: 17, width: 100, align: 'L', visible: true },
  { key: 'LINE_ID', header: 'Line', sort: 18, width: 85, align: 'L', visible: true },
  { key: 'ITEM_ID', header: 'Material', sort: 19, width: 130, align: 'L', visible: true },
  // OperationGroup=='A'(Cell) 만 표시 (design 01 §2 주의 SetColumnModelVisible cs:3903)
  { key: 'MODEL_ID', header: 'Model', sort: 19.5, width: 130, align: 'L', visible: true },
  { key: 'NICK_NAME', header: 'Nick Name', sort: 20, width: 100, align: 'L', visible: true },
  // EE + OpGr=E 만 표시 (design 03 §1 #22 cs:350/361)
  { key: 'CELL_ID', header: 'Cell Model', sort: 21, width: 120, align: 'L', visible: true },
  // div=40 만 표시 (design 03 §1 #23 cs:370)
  { key: 'EXTRA_SPEC', header: 'Extra Spec', sort: 22, width: 100, align: 'L', visible: true },
  // div=40 만 표시 (design 03 §1 #24 cs:346)
  { key: 'CELL_TYPE_GROUP_CODE', header: 'Cell Type Gr', sort: 31, width: 70, align: 'L', visible: true },
  // EE division 만 표시 (design 03 §1 #25 cs:355)
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', sort: 32, width: 60, align: 'C', visible: true },
  { key: 'MEASURE_NAME', header: 'Measure', sort: 33, width: 130, align: 'L', visible: true, fixed: true },
  // EE + OpGr=E 만 표시 (design 03 §1 #27 cs:360)
  { key: 'UNIT', header: 'Unit', sort: 90, width: 50, align: 'L', visible: true },
];

// pivot 컬럼 시작점 — MEASURE_NAME 다음부터 동적 기간 컬럼 (design 03 §2 cs:1212).
export const PIVOT_ANCHOR_COLUMN = 'MEASURE_NAME';

// div 조건 가시성 컬럼 그룹 (design 03 §1 VISIBLE 열 / cs:339~370).
export const EE_ONLY_COLUMNS = ['ORIGIN_DIVISION_ID', 'ELECTRODE_TYPE'] as const;
export const DIV40_ONLY_COLUMNS = ['EXTRA_SPEC', 'CELL_TYPE_GROUP_CODE'] as const;
export const EE_ELECTRODE_ONLY_COLUMNS = ['CELL_ID', 'UNIT'] as const; // EE + OpGr=E
export const CELL_OP_ONLY_COLUMNS = ['MODEL_ID'] as const; // OpGr=A(Cell) 만
