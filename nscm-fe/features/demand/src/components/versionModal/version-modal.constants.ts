// ⭐ DMF0044 / DMF0049 공용 Version 팝업 상수 (AS-IS DMF0044_United_VersionPopup 727행 1:1).
//   두 화면이 SP·MNU_BTN_MPG_M(unitedVersion) 배선을 각자 보유하므로 menuId 는 prop 주입이고,
//   컬럼 메타(SHEET_COLUMNS)는 AS-IS GetSpdTitle L278 이 p_program_id='DMF0044' 를 고정 전달하는
//   파리티를 그대로 승계한다 (DMF0049 호출 시에도 DMF0044/MDFVerpopup 등록분을 읽는다).

// SP 배선 sheet (SCM_ADM_MNU_BTN_MPG_M.SHT_NM — DMF0044·DMF0049 양 화면 동일 등록명)
export const VERSION_SHEET = 'unitedVersion' as const;

// 컬럼 메타 원천 — SCM_MST_SHEET_COLUMNS (PROGRAM_ID='DMF0044', SHEET_NAME='MDFVerpopup' 12행)
export const VERSION_META_PROGRAM_ID = 'DMF0044' as const;
export const VERSION_META_SHEET_NAME = 'MDFVerpopup' as const;

// Type 콤보 원천 lookup (AS-IS InitControls L130~137 — 부모 Report Type 으로 분기)
export const VERSION_TYPE_LOOKUP = {
  SP: 'MDF_TYPE_SP_POPUP', // REPORT_SP_W / SP_W / SP_M
  BP: 'MDF_TYPE_BP_POPUP', // REPORT_BP_M / BP_M
} as const;

// 부모 Report Type (조회조건 clbType 값 — SP 계열 판정 기준)
export const PARENT_REPORT_TYPE = {
  SP_W: 'REPORT_SP_W',
  BP_M: 'REPORT_BP_M',
} as const;

// ⭐ 팝업 Type 값 → 모드 (AS-IS ControlDisplay L505: SP_W/BP_M/SP_M = CREATE, 그 외(REPORT%) = COPY)
export const VERSION_MODE = {
  CREATE: 'CREATE',
  COPY: 'COPY',
} as const;
export type VersionMode = (typeof VERSION_MODE)[keyof typeof VERSION_MODE];

// CREATE 모드가 되는 Type 값 (AS-IS L505 정확 3종)
const CREATE_MODE_TYPES: readonly string[] = ['SP_W', 'BP_M', 'SP_M'];
export const modeOfType = (versionType: string): VersionMode =>
  CREATE_MODE_TYPES.includes(versionType) ? VERSION_MODE.CREATE : VERSION_MODE.COPY;

// ⭐ 이동계획(MV) 표시 Type (AS-IS L520 CREATE=SP_W·SP_M / L557 COPY=REPORT_SP_W)
const MV_VISIBLE_TYPES: readonly string[] = ['SP_W', 'SP_M', 'REPORT_SP_W'];
export const isMvVisibleType = (versionType: string): boolean =>
  MV_VISIBLE_TYPES.includes(versionType);

// ⭐ 버전 채택(더블클릭/OK) 허용 Type (AS-IS spdMain_CellDoubleClick L351 게이트)
const ADOPTABLE_TYPES: readonly string[] = ['REPORT_SP_W', 'REPORT_BP_M'];
export const isAdoptableType = (versionType: string): boolean =>
  ADOPTABLE_TYPES.includes(versionType);

// 버전 액션 코드 (AS-IS P_ACTION_TYPE — SAVE_SALES_PLAN_VERSION_COPY / MOBILE_REPORT_CREATE)
export const VERSION_ACTION = {
  DELETE: 'D', // btnVerDel  — SEND_YN N·C 만
  COPY: 'CP', // btnVerCopy — 실적 미포함 시 confirm
  CREATE: 'CR', // btnVerCre  — confirm 없음
  TRANSFER: 'T', // btnTransfer   — SEND_YN N 만
  CANCEL: 'C', // btnTranCancel — SEND_YN Y 만
} as const;

// MNU_BTN_CD (SCM_ADM_MNU_BTN_MPG_M 등록분 — 양 화면 동일)
export const VERSION_BTN_CD = {
  SEARCH: 'SEARCH', // PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP
  ACTION: 'ACTION', // PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY
  TRANSFER: 'TRANSFER', // PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE
} as const;

// ⭐ MSG — DMF0044 P1 신규 채번분(682~687)을 DMF0049 도 재사용 (양 화면 constants 동일 매핑 실측)
export const VERSION_MSG = {
  COPY_PLAN_ONLY: 'MSG00682', // AS-IS 00314 '실적은 포함하지 않고, 계획만 복사하시겠습니까?'
  DELETE_CONFIRM: 'MSG00683', // AS-IS 00016 삭제 확인
  CANCEL_CONFIRM: 'MSG00684', // AS-IS 00195 전송취소 확인
  SEND_ONLY_N: 'MSG00685', // AS-IS 00318
  CANCEL_ONLY_Y: 'MSG00686', // AS-IS 00319
  DELETE_ONLY_NC: 'MSG00687', // AS-IS 00320
  SAVED: 'MSG00002', // AS-IS 00004 저장 성공 재매핑
  SAVE_ERROR: 'MSG00618', // AS-IS 00006 실패 fallback
  // ⭐ 권한 없음 — AS-IS DMF0044_SalesReportExchangePopup.SaveButton L402 가 쓰는 그 MSG 그대로.
  //   locales 실값 확인(2026-08-10): KO '권한이 없습니다.' / EN 'No permission.'
  NO_AUTH: 'MSG00096',
} as const;
