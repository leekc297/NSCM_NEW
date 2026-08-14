import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

export const MENU_ID = 'SCP0013' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS SCP0013_ProductionPlanLine.cs (SCP > Production Plan > Production Plan Line):
//   - 메인 그리드 : 'Line' 시트 — measure 별 행 + 기간 wide-pivot (D_/W_/M_/B_ 접두 동적 컬럼, 3단 헤더)
//   - 분석서      : Doc/_analysis/domain_SCP/screens/SCP0013_ProductionPlanLine/ (validation 35 / MSG 16 / SP 16)
//   - Phase 0 실측: _artifacts/_apply_corporate/A5_scp0013_phase0_sp_blocked_handoff.md
//   ⚠️ Phase A(Shell+메타) — SP 전원 INVALID(기계변환 초안) → 조회는 T19 변환 적용 후 활성 (mock 금지).
export enum SHEETS {
  // 그리드/타이틀 시트명 = AS-IS SpdSheet.shtMain 'Line' (룰 #91 sheet-name-asis-preserve).
  //   ⚠️ AS-IS 원본이 이중 표기: 그리드/SHEET_COLUMNS='Line', 조회 p_sheet_name/SHEET_MEASURE='LINE'
  //   (.cs L123~127 vs L1058/L2024 실측) — 개명 없이 각 용도 그대로 보존한다.
  MAIN = 'Line',
}

// 조회 SP p_sheet_name / SHEET_MEASURE 조회용 시트명 (AS-IS 하드코딩 "LINE" 1:1).
export const SHEET_PARAM_NAME = 'LINE' as const;

// const object — NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// Bucket — AS-IS BucketType 구조체(.cs L186~191) 풀워드 1:1 (CMBO 'BucketType' CODE 와 동일).
//   ⚠️ DMF0003(mkt-fcst)의 D/W/M enum 과 다름 — SCP0013 조회 p_bucket 은 풀워드 전달.
export enum BUCKET_TYPE {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  MONTHLY = 'MONTHLY',
}

// W26/W52 기간 프리셋 (AS-IS PeriodType 구조체 .cs L193~199 — W78/W82 는 W{동적} 버튼용,
//   2026-07-13 사용자 결정으로 W{동적} 버튼 제외 → W26/W52 만 사용).
export const PERIOD_PRESET_WEEKS = {
  W26: 26,
  W52: 52,
} as const;

// Measure 6종 — 사내 SCM_MST_SHEET_MEASURE(PROGRAM_ID='SCP0013', SHEET_NAME='LINE') 실측 2026-07-13.
//   PROD_PLAN_AMEND 만 편집 대상 (AS-IS EditButton L684 — Phase B).
export const MEASURE = {
  PROD_PLAN_ENGINE: 'PROD_PLAN_ENGINE',
  PROD_PLAN_AMEND: 'PROD_PLAN_AMEND',
  PROD_PLAN_ENGINE_CELL_QTY: 'PROD_PLAN_ENGINE_CELL_QTY',
  PROD_PLAN_ENGINE_STD_JR: 'PROD_PLAN_ENGINE_STD_JR',
  LINE_TOTAL_LOAD_ENGINE: 'LINE_TOTAL_LOAD_ENGINE',
  LINE_TOTAL_LOAD_AMEND: 'LINE_TOTAL_LOAD_AMEND',
} as const;

// MeasureSelectModal fallback (BE 메타 미적재 degrade 용 — 코드만).
//   공용 모달(features/master measureSelectModal)은 fallback 미내장 → ProductionPlanLine 호출부 공급.
export const MEASURE_FALLBACK: string[] = Object.values(MEASURE);

// MSG — 사내 SCM_ADM_MSG_M 정합 (기존 재사용 + 신규 채번 MSG00673~674, MAX 실측 2026-07-13 = MSG00672).
//   AS-IS MSG 16종(00096/00265/00010/00007/00084/00317/00004/00003/00134/00016/00026/00252/00046/00182/00290)
//   은 편집/저장/팝업(Phase B/C) 소관 — 해당 Phase 에서 배선.
export const MSG = {
  /** Phase B/C 기능 버튼 안내 — '해당 기능은 후속 단계에서 적용 예정입니다.' */
  PHASE_PENDING: 'MSG00673',
  /** 조회 차단 안내 — '조회는 SP 변환 적용 후 활성화됩니다.' */
  SEARCH_BLOCKED: 'MSG00674',
} as const;

// 커스텀(화면 특화) 버튼 코드 — SCM_ADM_MNU_BTN_MPG_M 등록명 (Phase A 메타 스크립트와 1:1).
export const BTN = {
  MEASURE_SELECT: 'MEASURE_SELECT',
  NEW: 'NEW',
  FIX: 'FIX',
  UNFIX: 'UNFIX',
  LOAD_PERCENT: 'LOAD_PERCENT',
} as const;

// ⭐ 좌측 고정 컬럼 fallback — 사내 SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0013', SHEET_NAME='Line')
//   27행 중 visible 15 실측(2026-07-13) 1:1. 정본은 store fetchStaticColumns 동적 fetch —
//   BE 메타 미응답 시 화면 작동 보장용 (hook: staticColumns 하드코딩 금지 — fallback 한정 허용).
//   Division 별 노출 분기(AS-IS InitSpread L339~370)는 Grid 에서 코드 분기(메타 DIVISION_ID 공란).
export const MAIN_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 60, horzAlgnCd: 'C', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'ORIGIN_DIVISION_ID', colLblNm: 'Origin Div', colWth: 60, horzAlgnCd: 'C', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'OPERATION_GROUP_NAME', colLblNm: 'Operation Group', colWth: 60, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'SCM_SITE_DESCRIPTION', colLblNm: 'Plant Site', colWth: 80, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'OPERATION_ID', colLblNm: 'Operation ID', colWth: 100, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'LINE_ID', colLblNm: 'Line', colWth: 85, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'ITEM_ID', colLblNm: 'Material', colWth: 130, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'MODEL_ID', colLblNm: 'Model', colWth: 130, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'NICK_NAME', colLblNm: 'Nick Name', colWth: 100, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'CELL_ID', colLblNm: 'Cell Model', colWth: 120, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'EXTRA_SPEC', colLblNm: 'Extra Spec', colWth: 100, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'CELL_TYPE_GROUP_CODE', colLblNm: 'Cell Type Gr', colWth: 70, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'ELECTRODE_TYPE', colLblNm: 'Electrode Type', colWth: 60, horzAlgnCd: 'C', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'MEASURE_NAME', colLblNm: 'Measure', colWth: 130, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
  { colNm: 'UNIT', colLblNm: 'Unit', colWth: 50, horzAlgnCd: 'L', display: true, visible: true, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY },
];

// Division 별 컬럼 노출 분기 (AS-IS InitSpread L339~370 1:1 — 메타 DIVISION_ID 공란이라 코드 분기):
//   - 비 EE division: ORIGIN_DIVISION_ID / ELECTRODE_TYPE / UNIT / CELL_ID 숨김.
//     division '40' 일 때만 CELL_TYPE_GROUP_CODE + EXTRA_SPEC 표시.
//   - EE division: ORIGIN_DIVISION_ID / ELECTRODE_TYPE 표시. operationGroup 'E' 일 때만 UNIT/CELL_ID 표시.
export const EE_ONLY_COLUMNS = ['ORIGIN_DIVISION_ID', 'ELECTRODE_TYPE'] as const;
export const EE_ELECTRODE_GROUP_COLUMNS = ['UNIT', 'CELL_ID'] as const;
export const DIV40_ONLY_COLUMNS = ['CELL_TYPE_GROUP_CODE', 'EXTRA_SPEC'] as const;
