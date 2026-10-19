// New Plan 팝업(AS-IS SCM0002_ShipmentPlanInsertPopup) 공용 상수 — FG(SCP0009)/SEMI(SCP0010) 양쪽이 쓴다.
//   이 팝업은 두 화면이 p_prgram_id 로만 분기하는 동일 AS-IS 컴포넌트라, 메시지/라벨 코드는 화면이 아니라
//   SCM0002 팝업 기준으로 고정한다(대응표: .atlas/gscm-design/SCM0002/design/00_checklist.md §4).
//   값은 SCM_ADM_MSG_M 실측(2026-10-07) — AS-IS ID 가 TO-BE 에 없거나 다른 문구라 대체한 ID.
import type { NewPlanProgramId } from './newPlan';

// UI 라벨 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 실측. 값 = LBL 코드.
export const LBL = {
  NO: 'LBL00674',
  OK: 'LBL00716',
  SAVE: 'LBL00111',
  CLOSE: 'LBL00627',
} as const;

// 팝업 메시지 코드 — SCM0002 기준 고정(§4 대응표).
export const MSG = {
  SYSTEM_ERROR: 'MSG01075', // System error. Capture the screen...(AS-IS MSG00042 는 TO-BE 미등록)
  NO_ROW_SELECTED: 'MSG01104', // No rows selected.(AS-IS MSG00071)
  SELECT_FIRST: 'MSG01126', // First, select {0}.(AS-IS MSG00098)
  REQUIRED_FIELD: 'MSG00013', // 필수값을 입력하세요
  DUPLICATE_NEW: 'MSG00428', // There are duplicate entries among the newly entered data.(AS-IS MSG00260)
  ALREADY_REGISTERED: 'MSG01271', // ... is already registered. 뒤에 {0}(AS-IS MSG00295)
  SAVE_DONE: 'MSG00606', // 저장되었습니다.(사용자 요청 2026-10-13: "N개의 데이터 저장" 대신 단순 문구. AS-IS MSG00004 는 TO-BE 에서 다른 문구)
  SAVE_NOT_ALLOWED: 'MSG01196', // This Plan can not be modified.(AS-IS MSG00182)
} as const;

// 팝업 제목 — AS-IS SCM0002_ShipmentPlanInsertPopup 창 Text="Shipment Plan Insert"(Designer.cs:272).
//   미등록 키라 항상 defaultValue 'Shipment Plan Insert' 로 표시된다.
export const NEW_TITLE_KEY = '_newPlan.title';

export const ELECTRODE_LOOKUP_TYPE = 'ELECTRODE_TYPE';

// New 팝업 그리드 컬럼 메타 시트명(SCM_MST_SHEET_COLUMNS.SHEET_NAME) — POST /admin/menu/{menuId}/column 의 sheetNm.
//   컬럼 구조(라벨/폭/정렬/순서/2단 헤더/콤보)를 데이터로 관리한다. 등록은 07_newpopup_sheet_columns.sql
//   (현재 SCP0010 만). 미등록 화면(FG 등)·조회 실패 시 컴포넌트의 하드코딩 컬럼을 fallback 으로 쓴다.
export const NEW_POPUP_SHEET = 'Shipment Plan Insert';

// Operation Group 표시 콤보(읽기전용 컨텍스트 컬럼의 코드→이름 매핑) — 화면별로 콤보가 다르다.
//   FG: 전용 SQL_ID(OperationGroup_SCP/OperationGroupEE_SCP). SEMI: base LookupCommon + lookupType(design 02 §2.2).
export const operationGroupComboArgs = (
  programId: NewPlanProgramId,
  ee: boolean
): { comboId: string; lookupType?: string } =>
  programId === 'FG'
    ? { comboId: ee ? 'OperationGroupEE_SCP' : 'OperationGroup_SCP' }
    : { comboId: 'LookupCommon', lookupType: ee ? 'OPERATION_GROUP_SEMI_EE' : 'OPERATION_GROUP_SEMI' };

// call-proc 응답 실패 판정 — HTTP 4xx+ 또는 응답 code 가 0 이 아니면 실패(화면 save 유틸과 동일 계약).
export const isSaveResultFailure = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code ?? 0) !== 0;
