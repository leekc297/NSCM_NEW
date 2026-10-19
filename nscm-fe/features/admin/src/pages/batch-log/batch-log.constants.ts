import type { RawFlexGridColumnConfig } from '@foundation/models';

// 메뉴 SCM0016 (Admin > System > Batch Log). 조회 전용(read-only) 화면.
export const MENU_ID = 'SCM0016' as const;
export type MENU_ID = typeof MENU_ID;

// BE proc 라우팅 키(SHT_NM) = 응답 커서 키(PKG_SCM0016 OUT COL_NM). 셋 다 동일 명칭.
//   batchLog(Main) 은 Find 로, stepInfo/batchLogHist 는 Main 더블클릭(master->detail)으로 조회.
export enum SHEETS {
  BATCH_LOG = 'batchLog',
  STEP_INFO = 'stepInfo',
  BATCH_LOG_HIST = 'batchLogHist',
}

// SubTitle 툴바 동작 대상 그리드 식별용(포커스 추적).
export enum SHEET_INDEX {
  BATCH_LOG,
  STEP_INFO,
  BATCH_LOG_HIST,
}

// Run Status 조회조건 기본값 — AS-IS clbRunStatus NameList/ValueList="ALL" (Designer L140/L150).
//   PKG_SCM0016 는 NULL/빈값/'ALL' 포함이면 전체로 처리한다.
export const RUN_STATUS_ALL = 'ALL' as const;

// Run Status 옵션 원천 — SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE (AS-IS Data.Common LookupCommon).
export const RUN_STATUS_LOOKUP_TYPE = 'JOB_RUN_STATUS' as const;

// 그리드 컬럼(FE 정의) — SCM0016 은 SCM_MST_SHEET_COLUMNS 미등재(design 07-3, 실측 0건)라
//   AS-IS InitSpread(SCM0016_BatchLog.cs L176~230) 하드코딩 컬럼셋을 그대로 이식한다.
//   colLblNm(헤더)은 AS-IS 하드코딩 영문 라벨이 정본. i18n LBL 코드 등록은 deferred(design 04 gap 참조).
//
// 필수: 표시 컬럼은 display:true 를 명시한다. 공용 DataGrid 는 columnGroups 를
//   layoutAppliedColumns.filter(c => c.display) 로 빌드하므로 display 가 없으면(undefined=falsy)
//   컬럼이 통째로 탈락해 헤더가 0개로 렌더된다. 숨김 헬퍼는 visible:false + display:false.
//   (규약: tactTimeColumns / mkt-fcst 스토어의 visible+display 쌍과 동일.)

// spdMain (Batch Log) — 13 바인딩(hidden 4). 고정 경계 컬럼 1개(STEP_NAME)에만 fixed → Step Name 까지 Freeze.
//   DataGrid frozenColumns = findLastIndex(_fixed)+1 이므로 경계 컬럼에만 fixed:true 를 둔다.
export const BATCH_LOG_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'JOB_ID', colLblNm: 'JOB_ID', horzAlgnCd: 'L', colWth: 40, visible: false, display: false },
  { colNm: 'JOB_NAME', colLblNm: 'JobName', horzAlgnCd: 'L', colWth: 300, visible: true, display: true },
  { colNm: 'JOB_DESCRIPTION', colLblNm: 'Job Description', horzAlgnCd: 'L', colWth: 200, visible: true, display: true },
  { colNm: 'STEP_ID', colLblNm: 'STEP_ID', horzAlgnCd: 'L', colWth: 160, visible: false, display: false },
  { colNm: 'STEP_NAME', colLblNm: 'Step Name', horzAlgnCd: 'L', colWth: 120, visible: true, display: true, fixed: true },
  { colNm: 'SCHEDULE_UID', colLblNm: 'SCHEDULE_UID', horzAlgnCd: 'L', colWth: 160, visible: false, display: false },
  { colNm: 'SCHEDULE_NAME', colLblNm: 'Schedule Name', horzAlgnCd: 'L', colWth: 170, visible: true, display: true },
  { colNm: 'RUN_DATE', colLblNm: 'Last Run Date', horzAlgnCd: 'C', colWth: 150, visible: true, display: true },
  { colNm: 'RUN_STATUS', colLblNm: 'RUN_STATUS', horzAlgnCd: 'L', colWth: 80, visible: false, display: false },
  { colNm: 'RUN_STATUS_NAME', colLblNm: 'Last Run Status', horzAlgnCd: 'L', colWth: 80, visible: true, display: true },
  { colNm: 'RUN_DURATION', colLblNm: 'Last Run Duration', horzAlgnCd: 'C', colWth: 80, visible: true, display: true },
  { colNm: 'RUN_STATUS_MESSAGE', colLblNm: 'Last Run Status Message', horzAlgnCd: 'L', colWth: 250, visible: true, display: true },
  { colNm: 'NEXT_RUN_DATE', colLblNm: 'Next Run Date', horzAlgnCd: 'C', colWth: 150, visible: true, display: true },
];

// spdStep (Step Info) — 11 바인딩(hidden 5). Retry Attempts/Interval 우측정렬.
export const STEP_INFO_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'JOB_ID', colLblNm: 'JOB_ID', horzAlgnCd: 'L', colWth: 40, visible: false, display: false },
  { colNm: 'JOB_NAME', colLblNm: 'JOB_NAME', horzAlgnCd: 'L', colWth: 300, visible: false, display: false },
  { colNm: 'STEP_UID', colLblNm: 'STEP_UID', horzAlgnCd: 'L', colWth: 200, visible: false, display: false },
  { colNm: 'STEP_ID', colLblNm: 'STEP_ID', horzAlgnCd: 'L', colWth: 160, visible: false, display: false },
  { colNm: 'STEP_NAME', colLblNm: 'Step Name', horzAlgnCd: 'L', colWth: 120, visible: true, display: true },
  { colNm: 'STEP_TYPE', colLblNm: 'Step Type', horzAlgnCd: 'L', colWth: 160, visible: false, display: false },
  { colNm: 'EXEC_COMMAND', colLblNm: 'Command', horzAlgnCd: 'L', colWth: 170, visible: true, display: true },
  { colNm: 'ON_SUCCESS_ACTION', colLblNm: 'OnSuccessAction', horzAlgnCd: 'C', colWth: 200, visible: true, display: true },
  { colNm: 'RETRY_ATTEMPTS', colLblNm: 'Retry Attempts', horzAlgnCd: 'R', colWth: 100, visible: true, display: true },
  { colNm: 'RETRY_INTERVAL', colLblNm: 'Retry Interval(Minutes)', horzAlgnCd: 'R', colWth: 100, visible: true, display: true },
  { colNm: 'ON_FAILURE_ACTION', colLblNm: 'OnFailureAction', horzAlgnCd: 'C', colWth: 200, visible: true, display: true },
];

// spdHist (Batch Run Log) — 6 바인딩(hidden 2). 최근 100건(PKG 제한).
export const BATCH_LOG_HIST_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'JOB_ID', colLblNm: 'JOB_ID', horzAlgnCd: 'L', colWth: 40, visible: false, display: false },
  { colNm: 'RUN_DATE', colLblNm: 'RUN_DATE', horzAlgnCd: 'L', colWth: 150, visible: true, display: true },
  { colNm: 'RUN_STATUS', colLblNm: 'RUN_STATUS', horzAlgnCd: 'L', colWth: 200, visible: false, display: false },
  { colNm: 'RUN_STATUS_NAME', colLblNm: 'Run Status', horzAlgnCd: 'L', colWth: 80, visible: true, display: true },
  { colNm: 'RUN_DURATION', colLblNm: 'Run Duration', horzAlgnCd: 'C', colWth: 80, visible: true, display: true },
  { colNm: 'RUN_STATUS_MESSAGE', colLblNm: 'Run Status Message', horzAlgnCd: 'L', colWth: 250, visible: true, display: true },
];
