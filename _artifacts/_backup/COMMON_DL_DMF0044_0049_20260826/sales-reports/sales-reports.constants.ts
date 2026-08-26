export const MENU_ID = 'DMF0044' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0044_Sales_Reports.cs (Demand > Demand Plan > Sales Reports / MDF Reports — 신정본 base 1,483행,
//   Forms.UIL 판 확정 — Plan.UIL 변형(1,405행) 대비 ExcelButton [E20240906]/YearSet [E20250107] 2건 신규):
//   - 메인 그리드 : PIVOT wide format (정적 46컬럼 admin 메타 'MDF Reports' + 동적 M_yyyymm 12컬럼 + 연 span)
//     ⭐ 2행 Measure 블록 구조 (GetCellNumbersByRow multiful=2) — Insert/Delete 는 2행 세트 단위.
//   - 분석서      : Doc/화면분석서/DMF0044_SalesReports_{제약매트릭스_상세,주요이벤트_상세분석,상세동작_개발용}.md
//     + UI분석서 v2.1 (2026-07-20 전수 실측)
//   - 3축 분기    : Report Type(SP_W/BP_M) × Data Type(ALL=편집차단/1=Cutoff/2=ETC) × Division(40/82 — 81 분기 없음)
//   - 편집제어    : 조회 SP 행 EDIT_FLAG × Measure × Division × 시점 4변수 (제약매트릭스 §3)
//   - Version 필수: United 팝업 주입 — 미선택 조회 MSG00283 / 저장·팝업 진입 MSG00688(AS-IS 00281)
export enum SHEETS {
  MAIN = 'MDF Reports', // 메인 그리드 — SHEET_COLUMNS 46행 등록명 (룰 #91 — rename 금지)
  SPREAD_TITLE = 'spreadTitle', // 동적 월 헤더 (DMF0044_GET_SPREAD_TITLE — 선택연도 1/1~12/31)
  MEASURE = 'measure', // Measure 2행 블록 정의 (PKG.P_DMF0044_GET_MEASURE p_data_type)
  UNITED_VERSION = 'unitedVersion', // United 버전 팝업 (조회/액션 D·CP·CR/전송 T·C)
  EXCHANGE_RATE = 'exchangeRate', // 환율 팝업 (조회 2종 + 월 헤더 + 저장)
  TEXTBOX = 'textbox', // 82 전용 코멘트 팝업 (GET=OUT 4커서 / SAVE 16키 — 행별 반복, 정책③)
  TITLE_SET = 'titleSet', // Column/Measure Setting 영구 저장 (공유)
}

// Report Type (lookup MDF_TYPE — clbType). SP_W=주간 Sales Plan / BP_M=월간 Business Plan.
export const REPORT_TYPE = {
  SP_W: 'REPORT_SP_W',
  BP_M: 'REPORT_BP_M',
} as const;
export type ReportType = (typeof REPORT_TYPE)[keyof typeof REPORT_TYPE];

// Data Type (lookup MDF_TYPE2 — usrDataType). ALL=편집·저장 차단 / 1=Cutoff(저장 _C_CF) / 2=ETC(저장 _C, Insert 허용).
export const DATA_TYPE = {
  ALL: 'ALL',
  CUTOFF: '1',
  ETC: '2',
} as const;
export type DataType = (typeof DATA_TYPE)[keyof typeof DATA_TYPE];

// Division 분기 — AS-IS FE 비교는 '40'(편집 완화)/'82'(Textbox 버튼 노출) 2종뿐 (제약매트릭스 §1 L28. 81 없음).
export const DIVISION = {
  MOBILITY: '40',
  ESS: '82',
} as const;

// ⭐ AS-IS Validation MSG 매핑 — 사내 SCM_ADM_MSG_M 실측 대사 (2026-07-22 — P1 신규 채번 MSG00681~688).
//   룰(hook #114): AS-IS MSG_ID 그대로 사용 금지 — AS-IS TB_FX_MessageInfo 원문 실측 후 3분기.
export const MSG = {
  // 조회 전 버전 필수 — 'Version을 선택하고 조회하세요.' (AS-IS 00283 = 사내 기등록 재사용)
  REQUIRE_VERSION_FIND: 'MSG00283',
  // 저장/팝업 전 버전 — 'Version을 검색 후 조회하신 후에 입력이 가능합니다.' (AS-IS 00281 → 신규 00688)
  REQUIRE_VERSION_ACTION: 'MSG00688',
  // Data Type ALL 편집/저장 차단 (AS-IS 00321 → 신규 00681)
  ALL_BLOCK: 'MSG00681',
  // 필수값 — '{0} 값은 필수 입력 항목입니다.' (AS-IS 00002 용법 → 사내 MSG00429 재매핑, DMF0042 선례)
  REQUIRED_FIELD: 'MSG00429',
  // 저장 성공 — AS-IS 00004 '{0}개의 데이터가 저장되었습니다.' → 사내 MSG00002(저장 성공) 재매핑 (DMF0042 선례)
  SAVED: 'MSG00002',
  // 변경 없음 — 사내 MSG00004 '수정한 내용이 없습니다.'
  NO_CHANGES: 'MSG00004',
  // 저장 대상 0건 (DMF0042 신설 재사용)
  NO_SAVE_TARGET: 'MSG00676',
  // 저장 실패 fallback (AS-IS 00006 용법 → 사내 MSG00618 재매핑)
  SAVE_ERROR: 'MSG00618',
  // pending 변경 중 기능 차단 — Exchange 진입 (AS-IS 00142 'Edit Mode 에서는 수행할 수 없습니다'
  //   → DMF0042 신설 MSG00680 재사용. 사내 00142 는 '환율 잠금' 문구라 재사용 불가)
  PENDING_BLOCK: 'MSG00680',
  // 권한 없음 (사내 기등록 재사용)
  NO_PERMISSION: 'MSG00096',
  // United 팝업 — 계획만 복사 확인 (AS-IS 00314 → 신규 00682)
  COPY_PLAN_ONLY: 'MSG00682',
  // United 팝업 — 삭제 확인 (AS-IS 00016 → 신규 00683. 사내 00016 'page not found' 충돌)
  DELETE_CONFIRM: 'MSG00683',
  // United 팝업 — 전송취소 확인 (AS-IS 00195 → 신규 00684)
  CANCEL_CONFIRM: 'MSG00684',
  // United SEND_YN 게이트 3종 (AS-IS 00318/00319/00320 → 신규 00685/00686/00687)
  SEND_ONLY_N: 'MSG00685',
  CANCEL_ONLY_Y: 'MSG00686',
  DELETE_ONLY_NC: 'MSG00687',
} as const;

// United 팝업 버전 액션 코드 (AS-IS SAVE_SALES_PLAN_VERSION_COPY P_ACTION_TYPE / MOBILE_REPORT_CREATE)
export const VERSION_ACTION = {
  DELETE: 'D',
  COPY: 'CP',
  CREATE: 'CR',
  TRANSFER: 'T',
  CANCEL: 'C',
} as const;

// Grid 편집 전용 콤보 (조회 표시 dataMap 과 별개 — hook #59 §5-G). 메인 그리드 편집 콤보는
//   SHEET_COLUMNS 메타(FPComboBox + CELL_COMBO_DATA_TYPE) 기반이 1차 — 여기는 메타 미지정 컬럼만.
export const GRID_EDIT_COMBO: Record<string, { comboId: string }> = {};

// Insert 2행 Measure 블록 — AS-IS InsertRow L970~1035: GetMeasure(p_data_type) 결과 2행(CODE) 를
//   한 키셋에 세트 삽입, MEASURE 셀은 강제 세팅(사용자 선택 불가).
export const INSERT_ROW_DEFAULTS = {
  DEPARTMENT_ID: '',
  DEPT_ID: '',
  END_CUST_REPORT: '',
  CUST_REPORT: '',
  PRODUCT_GROUP: '',
  ITEM_ID: '',
  NICK_NAME: '',
  CURRENCY: '',
  COMPANY_ID: '',
} as const;
