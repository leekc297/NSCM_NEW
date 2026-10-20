// SCP0096 Shipment Working Day(OSP) 타입 — SCP0019 working-time.types.ts 미러.
//   정적 6컬럼(SHEET_COLUMNS) + 동적 D_/W_/M_ pivot 열(런타임 alias, index signature 로 수용).

// 조회조건 store 상태 — 02_search-combo.md 5조건. SCP0019 SearchParamProps 미러.
//   GET IN 파라미터(division/plantSite/기간)와 Form-local btnInput 드라이버(dayWeek/inputValue)를 함께 보관.
export interface SearchParamProps {
  // Division(단일 필수) — GET P_DIVISION_ID. cascade 상위(PlantSite 재조회 키).
  divisionId: string;
  // PlantSite(다중, cascade 하위) — GET P_PLANT_SITE_ID. 빈 배열은 orAll('ALL') sentinel.
  plantSiteIds: string[];
  // cboDayWeek(WEEK_WORK_TIME) — btnInput 일괄입력 분기 키. GET 파라미터 아님(Form-local).
  //   기본 SelectDay(선택셀 기입). 02 §2 #4.
  dayWeekCode: string;
  // 조회기간 시작 — GET P_FROM_YYYYMMDD (yyyymmdd 8자리)
  startYyyymmdd: string;
  // 조회기간 종료 — GET P_TO_YYYYMMDD (yyyymmdd 8자리)
  endYyyymmdd: string;
  // cboInputValue(YesOrNo) — btnInput 일괄입력 값. GET 파라미터 아님(Form-local). 02 §2 #5.
  inputValue: string;
}

// 그리드 행 — 정적 6컬럼 + 동적 D_yyyymmdd / W_ / M_ 열은 런타임 alias 라 index signature 로 받는다.
//   (SCP0019 WorkingTimeRow 동형: 값은 string|number|null 혼재 — D_ 은 'Y'/'N', W_/M_ 은 SUM 숫자.)
export interface ShipmentWorkingDayOspRow {
  DIVISION_ID: string;
  PLANT_SITE_ID: string;
  PLANT_SITE_NAME: string;
  // 편집 대상(FPNumber scale2) — WORKING_TIME_DEFAULT. is_save_defalut='Y' 저장분기.
  WORKING_TIME_DEFAULT: number | null;
  LAST_INPUT_DATE: string | null;
  // 'SHIPMENT WORKING DAY' 고정(GET 상수) — MEASURE_CONST
  MEASURE: string;
  // 동적 D_yyyymmdd(Y/N) / W_/M_(SUM) / B_(hidden 태그) 열
  [key: string]: string | number | null;
}

// admin `/column` 정적 컬럼 메타 원소(SCP0019 동형). 그리드가 이 목록으로 정적 6컬럼을 구성.
export interface StaticColumnMeta {
  colNm: string;
  colDesc?: string;
  displayYn?: string;
  visibleYn?: string;
  inputTpCd?: string;
  colWidth?: number;
  colOrder?: number;
  [key: string]: unknown;
}

// GET O_RC1 의 ResultSetMetaData 사이드카(o_rc1_columns) 원소 — 동적열 파생 원천.
export interface DynColumnMeta {
  name: string;
  type: string;
}

// dynamic-columns 파생 결과 — D_ 일자열 1개(3단 머지헤더 group 원천).
export interface DynDayColumn {
  // 실제 binding(예: D_20260101)
  binding: string;
  // 8자리 일자
  yyyymmdd: string;
  // 일(day-of-month) 헤더 라벨
  dayLabel: string;
  // 0=일 ~ 6=토 (요일색·btnInput 요일별 분기)
  weekday: number;
  // 대(월 yyyymm) 그룹 키 — 3단 머지헤더 상단
  monthKey: string;
  // 소(주차) 그룹 키 — 3단 머지헤더 중단
  weekKey: string;
}

// 동적 SUM 열(W_/M_) 파생 결과 — chkSum 토글 대상.
export interface DynSumColumn {
  binding: string;
  // 'W' 주 SUM / 'M' 월 SUM
  kind: 'W' | 'M';
  header: string;
}

// SAVE payload 1건 — SAVE_KEYS 순서로 '^' 직렬화된다(M-only). 03 §4 7 CLOB + userIdList.
export interface SaveEntry {
  divisionId: string;
  plantSiteId: string;
  // D_ 일자셀 저장분기(is_save_defalut='N')일 때만 채움
  yyyymmdd: string;
  measure: string;
  // D_ 셀 Y/N
  shipmentYn: string;
  // WORKING_TIME_DEFAULT 저장분기(is_save_defalut='Y')일 때만 채움
  workingTimeDefault: string;
  // 'Y'=WORKING_TIME_DEFAULT / 'N'=D_ 일자셀
  isSaveDefault: string;
  // BE 세션 자동 — 배열 붕괴 방지 List 접미
  userIdList: string;
}
