// 조회조건 5필드 — AS-IS usrConditionPanel1 2행 3열(01 §1.1).
//   주의: dayWeekCode / inputValue 는 조회 파라미터가 아니다(btnInput 전용). setFilters payload 에
//   넣으면 요일만 바꿔도 filters 참조가 갈려 무의미한 재조회가 난다(02 §1 / §5.2).
export interface SearchCondition {
  // cboCompany — 단일, ALL 옵션 없음(AS-IS 에 ALL 행이 없다).
  companyId: string;
  // clbDivision — 단일 + ALL 옵션(ItemSelectionMode=One 실측이라 multiple 금지).
  divisionId: string;
  // drpPeriod — 표시는 YYYY-MM-DD, payload 는 YYYYMMDD. store 는 payload 형식으로 보관한다.
  fromYyyymmdd: string;
  toYyyymmdd: string;
  // cboDayWeek — WEEK_WORK_TIME lookup 값(EveryDay/SelectDay/Mon~Sun).
  dayWeekCode: string;
  // cboInputValue — Y/N. 초기값은 빈값이며 요일 변경 시 항상 리셋된다(AS-IS .cs:669).
  inputValue: string;
}

// GET o_rc1 1행 = (division x company) 조합 1건. 동적 D_YYYYMMDD 키가 조회기간만큼 붙는다.
//   행 수는 division 4 x company 7 수준(현재 19 조합)이라 성능 축은 행이 아니라 열(기본 363)이다.
export interface ShipmentWorkingDayRow {
  DIVISION_ID: string;
  COMPANY_ID: string;
  // 동적 D_YYYYMMDD('Y' | 'N' | null) + 공용 DataGrid 가 붙이는 CRUD_TYPE 등
  [key: string]: string | number | null;
}

// 3SPAN 헤더 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) 응답 1행.
//   D_/W_/M_ 3블록이 SORT_ORDER_NO 순으로 섞여 내려오고, 컬럼이 되는 것은 D_ 뿐이다(03 §1-b).
export interface CalendarColumnRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  DAY_CODE: string | null;
  SORT_ORDER_NO: string;
}

// 3SPAN 응답에서 추린 동적 일자 컬럼 1건(월/주차/일 + 요일코드).
export interface DayColumn {
  binding: string;
  // leaf 헤더 라벨(일)
  dayLabel: string;
  // 2단 소그룹 라벨(주차)
  weekLabel: string;
  // 1단 대그룹 라벨(월)
  monthLabel: string;
  // MON~SUN. 주말 헤더 색 판정 원천(dayjs 재계산 금지).
  dayCode: string;
}

// SAVE '^' 평면 payload 1건 = 변경 셀 1개(행 단위가 아니다 — 03 §3-c).
export interface SaveEntry {
  activeFlag: string;
  divisionId: string;
  companyId: string;
  yyyymmdd: string;
  workdayYn: string;
}
