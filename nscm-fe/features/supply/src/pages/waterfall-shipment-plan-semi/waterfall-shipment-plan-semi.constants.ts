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
  // 동적 시간축(캘린더 3단 헤더, NotISO) — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN
  //   (Daily/Weekly/Monthly 버킷. 최상단=월, W_는 월 경계서 분할).
  SPREAD_TITLE = 'spreadTitle',
  // Only Weekly(WEEKLY_ISO) 전용 ISO 캘린더 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO
  //   (연속 ISO 주차 + 최상단=날짜범위 MMDD_LABEL_NAME, AS-IS SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO 이식).
  //   AS-IS 와 동일하게 Only Weekly 일 때만 이 시트를 호출한다(SCP0018...cs:992). 매핑 등록 =
  //   .atlas/gscm-design/SCP0018/design/06_register_spread_title_iso.sql.
  SPREAD_TITLE_ISO = 'spreadTitleIso',
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
  // 필수값 미입력 — AS-IS FindData_Main → DataUtil.checkRequired 의 MSG00002("{0} 값은 필수 입력입니다",
  //   arg=필드 라벨)를 TO-BE 재채번 MSG00429("{0} 값은 필수 입력 항목입니다.")로 매핑(EtcSalesReports 선례).
  //   AS-IS MSG00002 는 TO-BE 에서 '저장 성공' 으로 재채번되어 그대로 쓰면 오문구가 난다(ora.py 실측).
  REQUIRED_FIELD: 'MSG00429',
  // Period 범위 검증 — AS-IS DateUtil.Check_PeriodDate(dCalendar)(cs:645) 파리티. AS-IS MSG 번호를
  //   TO-BE 문구로 역조회(rule 6, ora.py SCM_ADM_MSG_M 실측):
  //   시작일 > 종료일 — AS-IS MSG00108 → TO-BE MSG01135 "The start date can not be later than the end date."
  PERIOD_START_AFTER_END: 'MSG01135',
  //   최대 조회기간 초과(to >= from + 1년 + 7일) — AS-IS MSG00172 → TO-BE MSG01187
  //   "Maximum Period is From Date + {0}." ({0}=371=AS-IS 하드코딩 364+7).
  MAX_PERIOD: 'MSG01187',
} as const;

export const LBL = {
  SEARCH: 'LBL00112',
  DIVISION: 'LBL00001',
  OPERATION_GROUP: 'LBL00027',
  // Model/Nickname — SCP0018.md 조회조건 정리(v0.5) 변경=O: 명칭 Model -> Model/Nickname + 팝업
  //   ItemByDivisionModal -> MaterialByDivisionModal(COM0013). LBL00618 = Model/Nickname(DB 실측).
  MODEL_NICKNAME: 'LBL00618',
  ELECTRODE: 'LBL00038',
  BUCKET: 'LBL00710',
  VERSION: 'LBL00606', // Version (full term, 참조용).
  // Ver. 약어 — 화면 라벨·필수 미입력 메시지 {0} 공용. LBL01275=KO/EN/CN 모두 'Ver.'(DB 등록 2026-11-12,
  //   SCM_ADM_MSG_M MSG_TP_CD='LBL'). 과거 LBL01231 참조는 오매핑(실제 "요청일"/"Date of Request")이라 교정.
  VER: 'LBL01275',
  // 확인 필요(02_search-combo.md §7#3) — LBL00013 vs 공용 PeriodField LBL00505 중복.
  //   전용 라벨(LBL00013)을 채택 — 공용 PeriodField 재사용 여부는 __asis-mapping__.md 에 기록.
  PERIOD: 'LBL00013',
  SUM: 'LBL00687',
  MEASURE: 'LBL00310',
} as const;
