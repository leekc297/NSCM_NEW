export const MENU_ID = 'SCP0013' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Analysis.UIL SCP0013_ProductionPlanLine — 단일 메인 그리드(spdMain siMain) + Load 팝업.
//   설계 근거: .atlas/gscm-design/SCP0013/design/00_checklist.md ~ 03_grid-columns.md (v2, DB 실측).
//   - 메인 GET  : PKG_SCP0013.P_SCP0013_GET_PROD_PLAN_LINEBY (22 IN + O_RC1~O_RC4)
//   - 편집판정  : P_SCP0013_GET_PLAN_EDIT_INFO(11 IN) / 저장가능 P_SCP0013_GET_PLAN_SAVE_YN(3 IN)
//   - Line 재조회: P_SCP0013_GET_LINE_LIST(5 IN, cellTypeGr 선택 시)
//   - Load 팝업 : P_SCP0013_LINE_LOAD_POPUP
//   - 저장       : P_SCP0013_SAVE_LINE_ROW / _DS (PROD_PLAN_AMEND 편집셀)
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M(SCP0013)=9행 등록됨(ora.py 2026-09-27)
//         main/SEARCH·main/SAVE·load/SEARCH·editInfo/SEARCH·lineList/SEARCH·newCheck/SEARCH·
//         newPopup/SEARCH·savePopup/SAVE·saveYn/SEARCH. SAVE=P_SCP0013_SAVE_LINE_ROW_JSON.
//         SP 배포 완료(PKG_SCP0013 VALID). design 03 §6 / 01 §2.5.
export enum SHEETS {
  MAIN = 'main', // spdMain siMain — 메인 pivot 그리드 (Line 시트, 27 고정 + D_/W_/M_ 동적)
  LOAD = 'load', // Load 팝업 그리드 (읽기전용 선택 로드)
  // 액션 SP 전용 시트 — SCM_ADM_MNU_BTN_MPG_M SHT_NM 정합(ora.py 2026-10-03, SCM_ADM_PROC_M 실측 param 바인딩).
  EDIT_INFO = 'editInfo', // P_SCP0013_GET_PLAN_EDIT_INFO(11 IN)→O_RC1 CP_KEY/IS_EDITABLE/NEW_EDIT_MODE/EDIT_START_DATE (행별 편집판정, M4c)
  SAVE_YN = 'saveYn', // P_SCP0013_GET_PLAN_SAVE_YN(divisionId·planStartYyyymmdd·planType)→O_RC1 EDIT_YN
  LINE_LIST = 'lineList', // P_SCP0013_GET_LINE_LIST(5 IN: div/opGroup/plantSite/cellTypeGr/planStart)→O_RC1 CODE/NAME
  EXTRA_SPEC = 'extraSpec', // P_SCP0013_GET_EXTRA_SPEC(1 IN: div='40')→O_RC1 OPERATION_GROUP/CODE/NAME (OPERATION_GROUP 클라필터)
  // New 삽입팝업 계열(M1) — PROC_M 실측 named param(ora.py 2026-09-27).
  NEW_POPUP = 'newPopup', // P_SCP0013_GET_NEW_POPUP_INFO(code·param1..5)→O_RC1 Item 후보(CODE/NAME/PLANT_SITE_ID/…)
  NEW_CHECK = 'newCheck', // P_SCP0013_GET_LINE_NEW_CHECK(9 IN)→O_RC1 중복확인
  SAVE_POPUP = 'savePopup', // P_SCP0013_SAVE_LINE_POPUP(10 IN, sesUserId BE 주입)→O_RC1 저장
  // Fix/Unfix 저장(AS-IS SaveData_FixInfo) — 공용 SP PKG_SCP0024.P_SCP0024_SAVE_PLAN_FIX_DS 재사용
  //   (SCM_ADM_MNU_BTN_MPG_M: SCP0013/fix/SAVE → API_ID 'P_SCP0024_SAVE', ora.py 2026-10-08 등록).
  //   메인 저장(main/SAVE)은 pivot+FIX 를 거부하므로 fix 는 이 전용 액션으로 라우팅한다(일 단위 payload).
  FIX = 'fix',
}

// New 팝업 newPopup 호출 CODE (PKG body 실측: P_CODE='ItemProdPlanLinePopup' 분기만 유효).
export const NEW_POPUP_CODE = 'ItemProdPlanLinePopup' as const;

// NSCM 단일 cursor 표준 'o_rc1' (RC2 fix / RC3·RC4 ratio 는 파생 보정 — design 03 §4.2).
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  LOAD: 'o_rc1',
  EDIT_INFO: 'o_rc1',
  SAVE_YN: 'o_rc1',
  LINE_LIST: 'o_rc1',
  EXTRA_SPEC: 'o_rc1',
  NEW_POPUP: 'o_rc1',
  NEW_CHECK: 'o_rc1',
  SAVE_POPUP: 'o_rc1',
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
// LINE_TOTAL% measure 행 표시 소수 자리 — AS-IS SetDecimal(cs:3742). 나머지 QTY measure 는 정수(n0).
//   Wijmo 컬럼 format 은 컬럼단위라 행별 스케일 불가 → 그리드 formatItem 에서 이 행만 소수 2자리 렌더.
export const LINE_TOTAL_DECIMALS = 2;

// Measure 행 표시 순서 fallback — SCM_MST_SHEET_MEASURE(SHEET_NAME='LINE') SORT_ORDER_NO 정본(design 03 §1
//   Measure 표, 활성 6). % measure(LINE_TOTAL_*)가 맨 아래 — 각 Plant site 행그룹 안에서 %는 하단(사용자 지시
//   2026-10-13). 런타임은 staticMeasures(동적 fetch, 동일 원천·동일 SORT)가 있으면 그 순서를 쓰고, 비었을 때만
//   이 상수를 쓴다(고정컬럼 FIXED_COLUMNS fallback 과 동형 — 동적이 우선, 하드코딩 아님).
export const MEASURE_ROW_ORDER = [
  'PROD_PLAN_ENGINE',
  'PROD_PLAN_AMEND',
  'PROD_PLAN_ENGINE_CELL_QTY',
  'PROD_PLAN_ENGINE_STD_JR',
  'LINE_TOTAL_LOAD_ENGINE',
  'LINE_TOTAL_LOAD_AMEND',
] as const;

// Measure 개인화(TitleSet) 영속 저장 키 — AS-IS SCM0002_TitleSetForm_Popup 'M'. measure 엔드포인트
//   (PR_GET_SHEET_MEASURE_LIST)가 SCM_MST_TITLESET_USER(PROGRAM_ID='SCP0013', SHEET_NAME='Line', 'M')를
//   읽어 DISPLAY_FLAG(저장선택)를 돌려준다 → 모달 체크상태·그리드 표시 measure 가 복원된다.
//   SHEET_NAME 은 measure 메타·개인화플래그(SHEET_PRSL_YN)·컬럼 메타와 대소문자까지 'Line' 로 일치해야 한다
//   (불일치 시 V_PRSL_YN 미매칭으로 개인화 OFF — 2026-11-11 대소문자 통일).
export const MEASURE_SHEET_NAME = 'Line';
export const TITLESET_MEASURE_TYPE = 'M';

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
// Plan Type 계획 진행순서 — TE → PR → MA → SE → FN (테스터 신고 2026-11-05 순서 정정).
//   TE 가 최초 단계, FN 이 최종 단계다. 그리드 편집잠금 판정 전용: 선택한 plan type 보다 "다음 단계"
//   (이 배열에서 더 뒤) 가 조회조건 콤보에 있으면 수정 불가(예: PR 은 MA/SE/FN 존재 시 잠금). FN 은 그
//   자체로 수정 불가. 배열 인덱스가 곧 단계 순번(앞설수록 이른 단계). (종전 ['FN','SE','MA','PR','TE']
//   역순이라 TE 가 PR 존재 시가 아니라 그 반대로 잠겨 동작이 뒤집혀 있었다 — 배열만 바로잡아 해소.)
export const PLAN_TYPE_STAGE_ORDER = ['TE', 'PR', 'MA', 'SE', 'FN'] as const;
// 그 자체로 수정 불가한 plan type(첫 계획 단계) — 사용자 지시 2026-11-04.
export const PLAN_TYPE_READONLY = 'FN';
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
  // cboDivision — 권한 division. AS-IS BLUtils.GetDivision(권한 MyDivision)의 TO-BE 등가는 'Division_SCP'
  //   (WHERE DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_ID=@sesUserId)).
  //   범용 'Division'(SCM_MST_DIVISION 전체)은 권한필터가 없어 목록이 넓게 나온다(ora.py 본문 실측, design 02 §7
  //   확인5·§2.2 #1 / 자매 tact-time.constants.ts 선례). 이름 재사용 금지(convert-core §2.6).
  DIVISION: 'Division_SCP',
  OP_GROUP: 'OperationGroup_SCP', // 비EE (SEGMENT1 IN ('P','A'))
  OP_GROUP_EE: 'OperationGroupEE_SCP', // EE (SEGMENT1 IN ('A','E')) — 접미 EE = 별개 콤보(코드셋 상이)
  CELL_TYPE_GR: 'CellTypeGr_SCP', // div=40 only (LOOKUP CELL_TYPE_GROUP_CODE R/C/P)
  PLANT_SITE: 'PlantByDivisionOperation1_SCP_ALL', // 비EE — 반환 DIVISION_ID/OPERATION_GROUP → 클라 필터
  PLANT_SITE_EE: 'PlantSiteProdPlan1_SCP_ALL', // EE — 반환 DIVISION_ID/OPERATION_GROUP(EE_PRODUCTION_PLAN). AS-IS RefreshPlantSite cs:1821 dtPlantSiteEEAll
  LINE: 'LineByOperationAddOSP1_SCP_ALL', // 비EE — 반환 DIVISION_ID/SITE_ID/OPERATION_GROUP → 클라 필터, '-' sentinel
  LINE_EE: 'LineProdPlanLine1_SCP_ALL', // EE — 반환 DIVISION_ID/OPERATION_GROUP/SITE_ID. AS-IS RefreshLine cs:1878 dtLineEEAll
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 반환 DIVISION_ID → 클라 필터, CODE=plan_start_yyyymmdd
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE → 클라 필터
  PLAN_SEQ: 'PlanSeq1_SCP_ALL', // 반환 DIVISION_ID/PLANDATE/PLANTYPE → 클라 필터
  BUCKET: 'BucketType', // DAILY/WEEKLY/MONTHLY
} as const;
// cboElectrode — lookup ELECTRODE_TYPE (ANODE/CATHODE/ONESIDE — design 02 §2.2 실측).
export const ELECTRODE_LOOKUP = 'ELECTRODE_TYPE';
// clbExtraSpec — AS-IS SCP0013_GET_EXTRA_SPEC(div=40) 를 TO-BE SP PKG_SCP0013.P_SCP0013_GET_EXTRA_SPEC 로
//   직접 배선(등록 콤보 ItemExtraSpec_SCP 는 의미 불일치로 재사용 금지, design 02 §7). SHEETS.EXTRA_SPEC proc 조회
//   (SCM_ADM_MNU_BTN_MPG_M SCP0013/extraSpec/SEARCH 등록, deploy SCP0013_extraSpec_combo_register_20261002.sql).
//   반환 OPERATION_GROUP 컬럼으로 선택 OperationGroup 클라 필터(AS-IS RefreshExtraSpec DBUtils.Filter cs:488).

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114, ora.py 2026-09-18 실측). AS-IS 번호를 그대로
//   두면 TO-BE 에서 같은 번호가 전혀 다른 문구로 등록돼 있어 오표시된다(예: 구 MSG00016 = TO-BE "requested
//   page could not be found" 인데 Unfix confirm 에 쓰여 잘못된 문구가 떴다). 각 코드는 의도한 의미의 TO-BE
//   MSG_NM 으로 재매핑했다(자매 SCP0020 tact-time 검증 매핑과 정합 — REQUIRED_FIELD=MSG00429/SAVE=MSG00002 등).
//   주의: TO-BE 메시지의 {0} 자리표시자는 i18next 가 자동 치환하지 않으므로(.NET 형식) 호출부에서 .replace 로 넣는다.
//   '번들 미포함' 표기 = SCM_ADM_MSG_M 에는 있으나 public/locales/*.json 배포본에 아직 없어 영문 defaultValue 로
//   표시됨(추후 번들 갱신 시 자동 반영, 엉뚱한 문구 회피).
export const MSG = {
  REQUIRED_FIELD: 'MSG00429', // {0} value is required. (구 MSG00002=TO-BE "Saved successfully." 오표시 — 자매 검증코드)
  NO_PERMISSION: 'MSG00096', // No permission. (TO-BE 동일 — 유지)
  NOT_EDIT_MODE: 'MSG00135', // This function is locked in edit mode. (구 MSG00010=TO-BE "search criteria saved" 오표시)
  SAVE_YN_NO: 'MSG01196', // 저장 불가(서버 SAVE_YN=N) (AS-IS MSG00182 는 TO-BE 미등록 → 같은 문구 MSG01196, KO/EN/CN). 서버 SAVE_YN(M5) 축
  CONFIRM_RESEARCH: 'MSG01273', // Do you want to re-search? (구 MSG00265=Excel 재로드 오표시). 번들 미포함→영문 fallback
  QTY_NEGATIVE: 'MSG00225', // Quantity must be 0 or greater. (구 MSG00084 미등록)
  QTY_OVERFLOW: 'MSG01318', // AS-IS 입력상한 "{0} 미만의 값만 입력 가능합니다."({0}=100,000,000). AS-IS 코드 MSG00317 은
  //   TO-BE 미등록이나, 동일 문구가 MSG01318(KO/EN/CN, USE_YN='Y' 실측 2026-11-16)로 이미 등록돼 있어 이를 사용한다.
  NEW_ROW_RED_CELL: 'MSG00013', // Please enter the required fields. (구 MSG00026=TO-BE "환율 적용 실패" 오표시)
  SELECT_CELL: 'MSG01262', // No date selected. Select Fix/Unfix date. (SCP0013 전용, 구 MSG00134 미등록). 번들 미포함
  CONFIRM_UNFIX: 'MSG00683', // 삭제 하시겠습니까? / Do you want to delete it? — AS-IS Unfix 확인(MSG00016='삭제하시겠습니까?')과 동일 문구. TO-BE MSG00016 은 'page not found' 오표시라, 동일 문구 MSG00683(KO/EN/CN USE_YN=Y 실측 2026-10-07)으로 재사용
  SELECT_TARGET: 'MSG00014', // No row selected. (구 MSG00007="This data cannot be modified" 부정확)
  LINE_ASSIGN_ITEM: 'MSG01293', // Line Assign 체크 시 Material 필수 (AS-IS MSG00290 는 TO-BE 미등록 → 같은 문구 MSG01293, KO/EN/CN)
  SAVE_SUCCESS: 'MSG00004', // No changes to save. (변경없음 토스트로 사용 — 의미 일치, 유지)
  SAVE_FAIL: 'MSG00003', // Failed to save. (TO-BE 동일 — 유지)
  // New 팝업 checkValidN0(AS-IS SCM0002_ProductionPlanInsertPopup cs:1402) — AS-IS 코드는 TO-BE 재번호됨.
  //   역조회 확정(ora.py 실측 2026-11-18, USE_YN='Y'): MSG00244→MSG01254 / MSG00254→MSG01264 / MSG00260→MSG01414.
  ITEM_TYPE_PH: 'MSG01254', // Item Type must be Product (P) or Semi-Product (H). (AS-IS MSG00244)
  //   주의: AS-IS 는 !(P||H) 분기가 빈값도 먼저 잡아 MSG00254(미확장)는 死코드 — AS-IS 동작(빈값=P/H 메시지) 그대로 따른다.
  DUP_NEW_INPUT: 'MSG01414', // There is duplicated data among new input data.\r\n{0} (AS-IS MSG00260, {0}=중복 site/line/item)
  PLAN_PERIOD_RANGE: 'MSG00108', // Invalid period (start > end). (구 MSG00252 미등록 — 자매 START_END_ORDER 정합)
  // SCP구간(계획구간) 초과 조회 차단 — AS-IS SCP0013 CheckPlanPeriodRange(cs:1989)/MSG00402.
  //   문구 "SCP구간 내 Plan 조회가 가능합니다\n(~계획수립주차 + {0}주 = {1})"({0}=주수, {1}=계획구간끝)는
  //   TO-BE SCM_ADM_MSG_M 에 KO/EN/CN 그대로 등록돼 있다(MSG_NM, ora.py 2026-11-18 실측 — AS-IS 동일).
  //   {0}=PLAN_WEEKS, {1}=HORIZON_END_DATE 를 호출부(.replace)에서 치환한다.
  PLAN_PERIOD_LIMIT: 'MSG00402',
  // INSERT_GUIDE(MSG00662 '조회 후 수정모드로 가능') 제거: AS-IS Set_FixButtonEnabled 는 조건 미충족 시
  //   btnNew 를 비활성(Enabled=false)으로 막을 뿐 안내 메시지가 없다 — New 에 disabled:!canFix 적용으로 대체.
} as const;

// i18n 라벨 코드 — SCM_ADM_MSG_M LBL 실측 역매핑(Hook #114, lbl-dict 대조). 값=LBL 코드, 호출부는
//   t(LBL.KEY, '_Fallback'). AS-IS Designer 문구와 DB EN 텍스트가 일치하는 코드만 등록한다.
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  OPERATION_GROUP: 'LBL00027', // Operation group
  CELL_TYPE_GR: 'LBL00042', // Cell Type Gr
  ELECTRODE: 'LBL00038', // Electrode
  EXTRA_SPEC: 'LBL00043', // Extra Spec
  PLANT_SITE: 'LBL00005', // Plant Site
  LINE: 'LBL00010', // Line
  MODEL: 'LBL00669', // Model
  MATERIAL: 'LBL00021', // Material
  NICK_NAME: 'LBL00767', // Nick Name
  MODEL_NICKNAME: 'LBL00618', // Model/Nickname (메1 MaterialByDivisionModal 픽커 통합 필드)
  PLAN_DATE: 'LBL00039', // Plan Date
  PLAN_VERSION: 'LBL01220', // Plan Date/Type/Seq
  PLAN_TYPE: 'LBL00040', // Plan Type
  SEQ: 'LBL00041', // Seq
  PERIOD: 'LBL00013', // Period (구 LBL00505 = DB 미등록 교정)
  BUCKET: 'LBL00710', // Bucket
  ALL: 'LBL00632', // All
  LINE_ASSIGN: 'LBL00769', // Line Assign
  SUM: 'LBL00687', // Sum
  FIX: 'LBL00771', // Fix
  UNFIX: 'LBL00772', // Unfix
  NEW: 'LBL01028', // New
  LOAD: 'LBL00773', // Load% (AS-IS Designer 'Load%' = DB SCM_ADM_MSG_M EN/KO/CN 'Load%' 일치, 실측 2026-10-07)
  MEASURE: 'LBL00310', // Measure
  REASON: 'LBL00625', // Reason
  OK: 'LBL00716', // OK (구 LBL00003 = DB 미등록 교정)
  CLOSE: 'LBL00627', // Close
} as const;

// 수량 범위 (design 03 §3 파생 white-list — MSG00084 <0 / MSG00317 >99999999).
export const QTY_MIN = 0;
export const QTY_MAX = 99999999;
// 입력상한 메시지 MSG00317("{0} 미만의 값만 입력 가능합니다.")의 {0} — AS-IS 하드코딩 "100,000,000"(=QTY_MAX+1) 동일.
export const QTY_MAX_LABEL = '100,000,000';

// pivot 셀 색상 파리티 (design 03 §3.8) — AS-IS SetCellBackColor.
//   실적/과거 구간 회색(cs #34/#61), fix 확정 셀 녹색(cs #62~64), LINE_TOTAL<100 강조(cs #65).
//   주의: fix 녹색은 GET O_RC2(dtFix, FIX_KEY 8필드) 매칭이 있어야 셀 단위로 칠할 수 있다 — O_RC2 미소비
//         구간이라 이 회차는 회색(과거)·<100 강조만 재현. fix 녹색은 O_RC2 소비(M2 잔여) 후 배선.
export const CELL_COLOR = {
  PAST_GRAY: 'rgb(234,234,234)', // 실적/과거(편집불가) 구간 배경
  // fix 확정 셀 배경 — AS-IS 녹색(188,229,92, Set_FixCellColor cs:3629)에서 진회색으로 변경
  //   (테스트 이슈 "Prod Plan Amend Measure 색상" 1번, 사용자 지시 2026-11-25 — 의도적 AS-IS deviation).
  FIX_DARK_GRAY: '#a6a6a6',
  // 계획구간(Plan Date 이후) Prod Plan(Amend) 행 배경 — 흰색에서 연회색으로(같은 이슈 2번). 실적구간
  //   회색(PAST_GRAY 234)과 구분되도록 한 단계 밝게 둔다. 편집가능 셀은 EDIT_YELLOW 가 덮는다.
  AMEND_PLAN_GRAY: '#f2f2f2',
  // 편집가능 pivot 셀 표시색 — NSCM 공통 editable 색 토큰($wj-editable-cell=#fff8cd, _variables.scss)과 동일.
  //   AS-IS 는 편집밴드를 회색(234,234,234, Set_FPOperationColor cs:3574)으로 칠했으나 TO-BE 는 플랫폼
  //   공통 editable 노랑으로 통일한다. 고정/동적컬럼 전건 INPUT_TP_CD='S' 라 공용 formatEditableColumns
  //   (wj-cell-editable)이 안 걸리므로 그리드 formatItem 에서 직접 칠한다(design 03 §3.8 #61 TO-BE 치환).
  EDIT_YELLOW: '#fff8cd', // 편집가능(PROD_PLAN_AMEND 편집kind·미래·행편집가능) 셀 배경
  UNDER_100: '#d32f2f', // LINE_TOTAL(%) < 100 강조 텍스트
} as const;
// LINE_TOTAL(%) 강조 임계 (design 03 §3.8 #65 — 부하율 100% 미만 강조).
export const LINE_TOTAL_WARN_THRESHOLD = 100;

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
  // Model 은 opGroup 무관 항상 표시 — AS-IS SetColumnModelVisible(cs:3903)은 유일 호출부(cs:373)가 주석
  //   처리된 dead code 라 실제 미동작(opGroup A/P 토글 미적용). division 가시성은 서버
  //   SCM_MST_SHEET_COLUMNS.DIVISION_ID(40·81·82·EE 계열 등록, 실측 2026-10-07)가 담당.
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

// opGroup 조건 가시성 컬럼 그룹 (design 03 §1 VISIBLE 열 / cs:339~370).
//   division 기반(EE 계열 전용 / div=40 전용) 가시성은 SCM_MST_SHEET_COLUMNS.DIVISION_ID 로 데이터화
//   되어 서버(PR_GET_SHEET_COLUMN_LIST)가 담당한다 — 더는 FE 상수로 두지 않는다. 테이블에 축이 없는
//   opGroup 조건만 아래 상수로 남긴다(isFixedColumnVisible).
export const EE_ELECTRODE_ONLY_COLUMNS = ['CELL_ID', 'UNIT'] as const; // OpGr=E (EE 계열은 DIVISION_ID 서버 필터)
// MODEL_ID 는 여기서 제외 — AS-IS SetColumnModelVisible(opGroup A/P 토글)은 cs:373 주석 처리로 미호출되는
//   dead code 라 AS-IS 는 Model 을 opGroup 으로 숨기지 않는다. Model 가시성은 서버 DIVISION_ID 필터만으로 충분.
export const CELL_OP_ONLY_COLUMNS = [] as const; // 현재 opGroup 전용 고정컬럼 없음
