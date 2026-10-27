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

// 3SPAN 타이틀 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 응답 o_rc1 1행 — 동적 기간 컬럼 원천.
//   AS-IS dsSpdTitle.Tables[0] 행(InitSpreadDateColumn .cs:183-192 가 읽는 DefColumns 5종 + 정렬키).
//   D_(일)/W_(주)/M_(월) 3블록이 SORT_ORDER_NO 순으로 섞여 내려온다(사내 실측 2026-10-20: M_202610, W_20261043, D_20261020 …).
export interface CalendarColumnRow {
  COLUMN_NAME: string;
  // D_ = 일(DD '01'), W_ = 주차('W43'), M_ = 월('2026-10')
  COLUMN_LABEL_NAME: string;
  // 2단 소그룹 라벨(주차 'W43')
  SMALL_CLASS_LABEL_NAME: string;
  // 1단 대그룹 라벨(월 '2026-10')
  LARGE_CLASS_LABEL_NAME: string;
  // MON~SUN(D_ 만, W_/M_ 은 NULL)
  DAY_CODE: string | null;
  SORT_ORDER_NO: string;
}

// dynamic-columns 파생 결과 — D_ 일자열 1개(3단 머지헤더 group 원천).
export interface DynDayColumn {
  // 실제 binding(예: D_20260101) = 3SPAN COLUMN_NAME
  binding: string;
  // 8자리 일자
  yyyymmdd: string;
  // 일 leaf 헤더 라벨 = COLUMN_LABEL_NAME
  dayLabel: string;
  // 2단 소그룹(주차) 라벨 = SMALL_CLASS_LABEL_NAME
  weekLabel: string;
  // 1단 대그룹(월) 라벨 = LARGE_CLASS_LABEL_NAME
  monthLabel: string;
  // MON~SUN = DAY_CODE (요일색·btnInput 요일별 분기 — AS-IS GetDayOfWeek 원천)
  dayCode: string;
}

// 동적 SUM 열(W_/M_) 파생 결과 — chkSum 토글 대상(AS-IS 는 컬럼을 만들되 chkSum.Checked=false 로 숨김 .cs:353-356).
export interface DynSumColumn {
  binding: string;
  // 'W' 주 SUM / 'M' 월 SUM
  kind: 'W' | 'M';
  // = COLUMN_LABEL_NAME
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
