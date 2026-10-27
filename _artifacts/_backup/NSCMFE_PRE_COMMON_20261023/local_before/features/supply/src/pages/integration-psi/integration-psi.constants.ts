export const MENU_ID = 'SCP0111' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Analysis/SCP0111_IntegrationPSI — 단일 메인 그리드(spdMain siMain) + 서버측 동적 PIVOT.
//   설계 근거: .atlas/gscm-design/SCP0111/design/00_checklist.md ~ 03_grid-columns.md (DB 실측 PASS).
//   - 메인 GET  : PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI (10 IN + O_RC[PIVOT] + O_RESULT_CURSOR[상태])
//   - 저장(일반): PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI (20 IN, modiQty 가감)
//   - 저장(ADMIN): PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN (21 IN, + p_boh_qty)
//   - ESS Line : PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE (신규행 LINE_ID 셀콤보 분기 A)
//   SP 배포 완료(PKG_SCP0111 PACKAGE + BODY VALID, ora.py 2026-09-23). 신규 화면(메뉴 미등록 → 05_register.sql).
export enum SHEETS {
  MAIN = 'main', // spdMain siMain — 메인 PIVOT 그리드 (고정 24열 + 동적 D_/W_/M_ 기간칼럼)
}

// NSCM 단일 cursor 표준. GET SP 는 O_RC(PIVOT 데이터) + O_RESULT_CURSOR(상태봉투) 반환 —
//   O_RC 를 그리드로 바인딩(design 03 §2-C / hook#80 cursor 이름 매핑). 표준 response key 'o_rc1'.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup 시트명 — SCM_MST_SHEET_COLUMNS distinct SHEET_NAME 1건 = 'Integration PSI'
//   (design 03 §0 실측 24행). admin 등록본이 authoritative(fetchStaticColumns). 미등록 시 빈 배열.
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Integration PSI',
};

// SCM_MST_SHEET_MEASURE 등록 시트명 — measure 7종 메타(design 03 §1-M). fetchStaticMeasures 로 동적 조회.
export const MEASURE_SHEET_NAME = 'Integration PSI';

// 편집 대상 measure 코드 (design 03 §1-M). MEASURE 컬럼 값 기준.
export const MEASURE = {
  MKT_FCST: 'MKT_FCST', // Market Forecast (division 81 제외)
  SHIP_PLAN_RTF: 'SHIP_PLAN_RTF',
  SHIP_PLAN_SEMI: 'SHIP_PLAN_SEMI', // 편집 가능 measure
  IN_HOUSE_MOVING: 'IN_HOUSE_MOVING', // ESS 파생검증(D1/D2) 대상
  SEMI_WH_IN: 'SEMI_WH_IN',
  PROD_PLAN: 'PROD_PLAN', // 신규행 Insert 대상 measure
  INV: 'INV', // Inventory (BOH 편집 대상)
} as const;

// division 특수 코드 (design 03 §3-Lock / §1-M).
export const DIVISION_ESS = '82'; // ESS — 파생검증(D1/D2) + 신규행 LINE_ID 분기 A + 조건색 C1/C2
export const DIVISION_SMALL = '40'; // 소형 — L10~L13 편집잠금 분기
export const DIVISION_NO_MKT_FCST = '81'; // MKT_FCST measure 제외 (design 03 §1-M cs:309-312)

// Operation Group lookup(OPERATION_GROUP) — 저장 시 NAME(표시명)→CODE 역변환 (design 03 §1-L).
//   GET SP 는 SEGMENT2(Pack/Cell/Electrode 표시명)로 반환. 저장 시 이 매핑으로 코드 복원.
export const OPERATION_GROUP_CODE = {
  Pack: 'P',
  Cell: 'A',
  Electrode: 'E',
} as const;
// 셀콤보 operation_group 매핑 (design 03 §2-D cs:1744-1755): Pack→P / Cell→A / 기타→E.
export const OP_GROUP_PACK = 'P';
export const OP_GROUP_CELL = 'A';
export const OP_GROUP_ELECTRODE = 'E';

// 기본 조회기간(월수) lookup — AS-IS Data.Common(LookupCommon,"INTEGRATION_PSI_DEFAULT_PERIOD").
//   응답 CODE(SEGMENT1 정규화)=개월수. To 초기 선택값 = 시작월+(CODE-1)월 (design 02 §3.2 / cs:256-260).
//   주의: 이 값은 To "선택값"만 정한다 — From/To 콤보 "목록 범위"는 HORIZON_END_DATE 로 별도 산정(cs:287).
export const DEFAULT_PERIOD_LOOKUP = 'INTEGRATION_PSI_DEFAULT_PERIOD' as const;
// lookup CODE 부재 시 fallback 개월수 — AS-IS else 분기 시작월+5월(=6개월치, cs:264).
export const DEFAULT_PERIOD_MONTHS = 6;
// From/To 콤보 목록 상한 fallback — SCPPlanPeriod 부재 시 시작월+11월(AS-IS cs:277).
//   미사용: Period 를 SCP 공통 PeriodRangePicker(자유 달력)로 바꿔 "선택 가능한 월 목록"이 없어졌다
//   (사용자 지시 2026-10-12). AS-IS 실측값으로 남겨 둔다 — 상한 제약을 되살릴 때 쓸 근거다.
export const PERIOD_LIST_FALLBACK_MONTHS = 12;

// LINE_ID 신규행 기본값 sentinel (design 03 §3-Value V2 / §2-D). 저장 시 "-" 이면 확인(MSG00453→MSG01434).
export const LINE_ID_EMPTY = '-';

// L7 모듈 반제품 편집 예외 lookup — AS-IS Data.Common(LookupCommon,"MULTI_CHILD_ITEM") (design 03 §1-L cs:622-643).
//   SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='MULTI_CHILD_ITEM') SEGMENT2(=Data.Common NAME)와 ITEM_ID 를 대조.
//   VALID 2행 실측(SEGMENT1=AMRSAEV20-A2/B2, SEGMENT2=AMDAU0630D/AMDAU0629D). useTabLookupQueries 로 조회.
export const MULTI_CHILD_ITEM_LOOKUP = 'MULTI_CHILD_ITEM';

// 조회조건 콤보 SQL_ID — SCM_ADM_CMBO_SQL_M 전건 존재 실측(design 02 §2). AS-IS CommonAll 전량 로드 +
//   C# 후처리 필터를 TO-BE 는 CMBO WHERE 또는 FE 후처리로 재현(convert-core §2.6 콤보 의미 패리티).
export const COMBO = {
  // cboDivision — 권한 division. AS-IS BLUtils.GetDivisionWithoutEE = 공통 Division + ATTRIBUTE3<>'EE' 필터.
  //   TO-BE 공통 Division 재사용 시 EE division 노출 → CMBO WHERE 또는 FE 후처리로 EE 제외 재현 필수.
  DIVISION: 'Division_SCP',
  PLAN_DATE: 'DATE_WEEKLY1_SCP_ALL', // 반환 PLANDATE/DIVISION_ID → 클라 필터(Division·SE/FN PlanType 교집합)
  PLAN_TYPE: 'PlanType1_SCP_ALL', // 반환 CODE/DIVISION_ID/PLANDATE → PlanDate 산출용(cascade 필터)
  // 아래 2건은 **현재 미호출**이다 — Period 가 SCP 공통 PeriodRangePicker(자유 달력)로 바뀌어 월 목록/목록상한을
  //   쓰지 않는다(사용자 지시 2026-10-12). 실측 SQL_ID·파라미터 계약은 복구 근거로 남긴다.
  CALENDAR_MONTH: 'CalendarMonth', // 파라미터 @param1/@param2 (basis_yyyymm >= / <=) → 월 목록 CODE=YYYYMM
  SCP_PLAN_PERIOD: 'SCPPlanPeriod_SCP', // 파라미터 @planName/@divisionId → HORIZON_END_DATE(기간 목록 상한)
} as const;
// EE division 제외 필터값 (design 02 §2 #1 — ATTRIBUTE3<>'EE'). FE 후처리 대상 코드값.
export const DIVISION_EE_EXCLUDE = 'EE';
// cboPlanDate 노출 대상 PlanType 코드 (design 02 §3.1 — SE/FN PlanType 의 PLANDATE 교집합만 노출).
export const PLAN_DATE_ALLOWED_PLAN_TYPES = ['SE', 'FN'] as const;

// 그리드 셀콤보(LINE_ID) SQL_ID — 신규행 'I' 전용, 분기 B(비ESS) 원천 (design 03 §2-D 실측).
//   분기 A(ESS div82·Pack)는 P_SCP0111_GET_ESS_PACK_LINE 결과를 COMPANY_ID 필터 — 단일 PARAM 표현 불가.
export const LINE_COMBO = {
  BY_PLANT: 'LineByOperationPlantId_SCP_ALL', // 반환 CODE/NAME/DIVISION_ID/SHOP_GROUP_ID/PLANT_ID/FACTORY_ID
} as const;

// Validation MSG ID — TO-BE SCM_ADM_MSG_M 역매핑(Hook #114). AS-IS 번호를 그대로 두면 TO-BE 에서 같은
//   번호가 다른 문구로 등록돼 오표시된다 → 의도한 의미의 TO-BE MSG_NM 으로 재매핑(자매화면 검증코드 정합).
//   주의: TO-BE 메시지의 {0} 자리표시자는 i18next 가 자동 치환하지 않으므로 호출부에서 .replace 로 넣는다.
export const MSG = {
  REQUIRED_FIELD: 'MSG00013', // 필수값 공백 (design 03 §4-저장 cs:1233-1239 필수 15건). EN="Please enter the required fields." (DB 실측 2026-09-23)
  PERIOD_RANGE: 'MSG00219', // 조회기간 from>to (design 03 §5). AS-IS MSG00344 는 TO-BE 부재 → 등가 MSG00219 EN="Invalid period (start > end)."
  DUPLICATE_ROW: 'MSG00260', // 신규행 중복 (design 03 §5). EN="Duplicate combination (Division/Project/Item/Date/Measure)."
  LINE_REQUIRED: 'MSG01434', // Line 없이("-") 저장 시 확인 (design 03 §5 / §3-Value). AS-IS MSG00453 부재 → 등가 MSG01434("Line 항목 미입력, 저장?")
  SAVE_SUCCESS: 'MSG00002', // 저장 성공 토스트. EN="Saved successfully." (직전 SAVE_RESULT=MSG00004 오지정 교정)
  NO_CHANGES: 'MSG00004', // 저장 대상 변경 없음. EN="No changes to save." (성공과 분리 — 직전 SAVE_RESULT 단일키 오용 교정)
  SAVE_FAIL: 'MSG00003', // 저장 실패. EN="Failed to save."
  NO_ROW_SELECTED: 'MSG00014', // 대상 행 미선택. EN="No row selected."
  // 저장된 행 삭제 시도 — 미저장 신규행만 삭제 가능(사용자 지시 2026-10-13). AS-IS DeleteButton 은 NO-OP 라
  //   대응 메시지가 없다 → SCM_ADM_MSG_M 역조회로 **기존 코드 재사용**(2026-10-13 ora.py 실측,
  //   KO/EN/CN 3언어 USE_YN='Y'). KO="신규 입력 (Insert) 한 행만 삭제할 수 있습니다."
  DELETE_ONLY_NEW: 'MSG00608', // EN="Only newly inserted rows can be deleted."
  OP_GROUP_LOOKUP_MISSING: 'MSG00013', // OPERATION_GROUP NAME→CODE lookup 부재 (design 03 §4). 필수입력 계열 → MSG00013
  // 파생검증 D1/D2 불일치 경고 (design 03 §3-Deriv). AS-IS 는 리터럴 "수량 불일치"(catalog MSG 코드 아님) —
  //   TO-BE MSG_M 등가 코드 미확정(확인필요). 실 MSG 코드를 재사용하면 hook#114 오표시 위험이 있어
  //   비카탈로그 key 로 두고 t() defaultValue 로만 표시(경고, 저장 미차단). 코드 확정 시 여기만 교체.
  DERIV_MISMATCH: 'SCP0111_DERIV_MISMATCH',
} as const;

// i18n 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 역조회로 확정한 TO-BE 코드(hook#114).
//   호출부는 t(LBL.KEY, '_Fallback') 로만 표기. AS-IS Designer 문구는 fallback 으로만 남긴다.
export const LBL = {
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  PLAN_DATE: 'LBL00039', // AS-IS PlanDate "Plan-date*" — DB "Plan Date"
  PERIOD: 'LBL00013', // AS-IS layoutControlItem2 "Period" — From/To 를 묶는 단일 라벨
  QTY: 'LBL01150', // AS-IS chkQty.Text "Qty < 0"
  NICK_NAME: 'LBL00767', // AS-IS lblNickName "Nick Name" — 통합 후 미사용(MODEL_NICKNAME 참조)
  CELL_ITEM_ID: 'LBL00051', // AS-IS lblCellItem "Cell Model"
  ITEM_ID: 'LBL00669', // AS-IS lblItemId "Model" — 통합 후 미사용(MODEL_NICKNAME 참조)
  // Model + Nick Name 통합 입력 라벨 (사용자 지시 2026-10-12). AS-IS 는 txtNickName/txtItemId 2필드지만
  //   팝업이 Model·Nickname 양쪽으로 찾아주므로 입력칸을 하나로 합쳤다. LBL00618 은 DB 기등록
  //   (SCM_ADM_MSG_M KO/EN/CN 전부 'Model/Nickname') — 신규 등록 없음. 자매 SSP0021·SSP0060 과 동일 코드.
  MODEL_NICKNAME: 'LBL00618',
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
} as const;

// From/To 콤보 구분자 리터럴 — AS-IS layoutControlItem5 "   ~" (라벨 아님, spacer).
export const PERIOD_SEP = '~';

// 동적 PIVOT 기간칼럼 접두 (design 03 §2-A cs:384-397). 기본 노출 = 월(M_), 일/주(D_/W_)는 숨김 + drill-down.
export const PIVOT_PREFIX = {
  DAILY: 'D_',
  WEEKLY: 'W_',
  MONTHLY: 'M_',
} as const;

// pivot 컬럼 시작점 — 고정 base 20열(GET inner SELECT) 이후가 전부 YYYYMM pivot 컬럼 (design 03 §2-C).
export const PIVOT_ANCHOR_COLUMN = 'SEQ_FLAG';

// 저장 call-proc procedureAction 세그먼트 — apiClient.post `{MENU_ID}/{sheet}/{action}/call-proc`.
//   '^'delim bulk SAVE 는 useProcMutation(배열 unfold)을 우회해 apiClient.post 직접 호출
//   (feedback_save_sp_bulk_payload_apiclient_post 규약, sales-plan 정본). 일반=SAVE_INTEGRATION_PSI /
//   ADMIN=SAVE_PSI_ADMIN 은 서로 다른 SP → procedureAction 도 분리 필요.
//   확인필요: SCP0111 procedures.d.ts 미등재 + 05_register 미적용 상태라 action 세그먼트 실명은
//   등록 시점에 확정된다. 표준 BUTTON_TYPE 규약상 일반=SAVE / ADMIN 별도 액션(SAVEDETAIL)로 잡되,
//   05_register 의 SCM_ADM_PROC_M 매핑명과 반드시 일치시켜야 한다(불일치 시 -9997/미등록 오류).
export const SAVE_ACTION = {
  GENERAL: 'SAVE',
  ADMIN: 'SAVEDETAIL',
} as const;
