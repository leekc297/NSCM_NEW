export const MENU_ID = 'SCP0018' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * SCP0018 Waterfall Shipment Plan Semi — 읽기 전용 조회 화면 (신규 생성).
 * AS-IS: GSCM.SCP.Forms.UIL\Analysis\SCP0018_WaterfallShipmentPlanSemi.cs — 조회 전용
 * (Delete/Save 순수 NO-OP, Edit NO-OP+MSG00109). 정본 분석:
 * `.atlas/gscm-design/SCP0018/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`.
 */
export enum SHEETS {
  // 메인 조회 — PKG_SCP0018.P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL (미배포, convert-sp 후속)
  MAIN = 'main',
  // 동적 시간축(캘린더 3단 헤더) — PKG_SCP0009.P_SCP0009_GET_SHEET_CALENDAR_3SPAN[_ISO] (미배포)
  SPREAD_TITLE = 'spreadTitle',
}

/** admin UI Category Setup SHEET_NAME — SCM_MST_SHEET_COLUMNS 실측 등록명(24행) 그대로. */
export const ADMIN_SHEET_NAME = 'Waterfall Shipment Plan' as const;

/** Bucket (AS-IS cboBucketType — BucketISO_SCP 콤보 CODE 4종). 기본값 Daily(AS-IS DefineProperty). */
export const BUCKET_TYPE = {
  DAILY: 'DAILY',
  WEEKLY: 'WEEKLY',
  MONTHLY: 'MONTHLY',
  WEEKLY_ISO: 'WEEKLY_ISO',
} as const;

/** 동적 pivot 컬럼 접두 판정 — D_/W_.../M_/B_ (03_grid-columns.md §2.5). */
export const kindOf = (binding: string): 'D' | 'W' | 'M' | 'B' | null => {
  if (binding.startsWith('D_')) return 'D';
  if (binding.startsWith('M_')) return 'M';
  // B_ 숨김 헬퍼 컬럼 — IndexOf('B_') > 0 조건(03_grid-columns.md §2.4 확인 필요 §6#4).
  //   접두사(index 0) 판정과 구분해 우선 확인한다.
  if (binding.includes('B_') && !binding.startsWith('B_')) return 'B';
  if (binding.startsWith('W_')) return 'W';
  return null;
};

/**
 * AS-IS MSG 매핑 — `02_search-combo.md §4.5` DB 실측(`ora.py`, SCM_ADM_MSG_M) 그대로.
 * 임의 신규 채번 없음(전건 기존 LBL/MSG 매칭).
 */
export const MSG = {
  DIVISION_NO_AUTH: 'MSG00097', // 권한을 가진 Division이 없습니다. (01_layout.md §2 트리거C)
  EDIT_READONLY: 'MSG00109', // Read-only mode. (Edit 버튼 NO-OP 안내, §4d)
  REQUIRED_INPUT: 'MSG00013', // 필수값을 입력하세요. (FindData_Main 이중 필수값 체크, §6#7)
} as const;

export const LBL = {
  DIVISION: 'LBL00641',
  OPERATION_GROUP: 'LBL00027',
  MODEL: 'LBL00669',
  ELECTRODE: 'LBL00038',
  BUCKET: 'LBL00710',
  VERSION: 'LBL00606',
  // 확인 필요(02_search-combo.md §7#3) — LBL00013 vs 공용 PeriodField LBL00505 중복.
  //   전용 라벨(LBL00013)을 채택 — 공용 PeriodField 재사용 여부는 __asis-mapping__.md 에 기록.
  PERIOD: 'LBL00013',
  SUM: 'LBL00687',
} as const;
