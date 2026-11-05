// SCP0096 Shipment Working Day(OSP) 타입 — SCP0019 working-time.types.ts 미러.
//   정적 6컬럼(SHEET_COLUMNS) + 동적 D_/W_/M_ pivot 열(런타임 alias, index signature 로 수용).

// 조회조건 store 상태 — GET IN 파라미터(division/plantSite/기간)만 보관한다.
//   Day of the week + Input Value(일괄입력 드라이버)는 조회조건이 아니라 입력 팝업
//   (ShipmentWorkingDayOspInputModal)의 로컬 state 로 이동했다(2026-10-15 사용자 지시 — 버튼영역 버튼 + 팝업).
export interface SearchParamProps {
  // Division(단일 필수) — GET P_DIVISION_ID. cascade 상위(PlantSite 재조회 키).
  divisionId: string;
  // PlantSite(다중, cascade 하위) — GET P_PLANT_SITE_ID. 빈 배열은 orAll('ALL') sentinel.
  plantSiteIds: string[];
  // 조회기간 시작 — GET P_FROM_YYYYMMDD (yyyymmdd 8자리)
  startYyyymmdd: string;
  // 조회기간 종료 — GET P_TO_YYYYMMDD (yyyymmdd 8자리)
  endYyyymmdd: string;
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

// 동적열 파생 원천 — 컬럼명({name})만 쓴다(type 은 호환 보존용 optional).
//   원천은 CALENDAR(3SPAN) SP O_RC1 의 COLUMN_NAME(D_/W_/M_). GET 데이터 커서(o_rc1)는
//   call-proc 경로에서 컬럼 메타 사이드카를 주지 않으므로 이 목록이 동적 컬럼의 단일 원천이다.
export interface DynColumnMeta {
  name: string;
  type?: string;
}

// CALENDAR(3SPAN) SP O_RC1 행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용, VALID) 반환.
//   조회기간(start/end)으로 D_/W_/M_ 컬럼명과 대/중/소 3단 라벨·요일코드를 돌려준다(03 §1-b/§4).
//   현 구현은 COLUMN_NAME 만 동적 컬럼 원천으로 쓴다(3단 라벨·요일색은 dynamic-columns 에서 yyyymmdd
//   파싱으로 재현 — 기존 로직 유지). 나머지 라벨 필드는 향후 실라벨 적용 여지로 보존.
export interface CalendarColumnRow {
  COLUMN_NAME?: string;
  COLUMN_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  DAY_CODE?: string;
  SORT_ORDER_NO?: number | string;
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
}
