// SCP0019 Working Time 타입 정의.
//   근거: 03_grid-columns.md(정적 14컬럼 + 동적 D_) / 02_search-combo.md(조회조건).
//   GET SP 커서 실측(all_source PKG_SCP0019 BODY, 2026-09-25 04_impl-gap-audit #1):
//   O_RC1 = 피벗 데이터 커서(정적 14 + 동적 SUM(CASE...) AS D_yyyymmdd), O_RESULT_CURSOR = 상태 커서
//   ('0'/'SUCCESS')뿐. 타이틀-메타 커서는 이 SP 에 없다 — 동적 컬럼은 데이터 커서 자신의 alias 이며,
//   BE 가 ResultSetMetaData 를 o_rc1_columns 로 함께 노출한다(DynamicQueryModal 선례). 요일 그룹핑은
//   커서가 주지 않으므로 D_yyyymmdd 에서 클라이언트 파생한다(SP "칸 펼치기" 주석과 동일 원리).

// 조회조건 — 02_search-combo.md §1 인벤토리. 멀티 콤보는 콤마 문자열(store setFilters 에서 orAll 처리).
export interface SearchParamProps {
  // cboDivision(단일 필수) — 권한기반. cascade 최상위. 변경 시 하위 초기화 + 그리드 비움.
  divisionId: string;
  // clbPlantSite(다중) — DIVISION_ID 하위 필터형. 콤마 join.
  plantSiteIds: string[];
  // clbBuilding(다중·정적 hidden) — FACTORY. 콤마 join. 숨김이나 파라미터 보존.
  buildingIds: string[];
  // clbOperation(다중) — OPERATION_GROUP. 콤마 join.
  operationIds: string[];
  // clbLine(다중) — 다중키 필터형 최하위. 콤마 join.
  lineIds: string[];
  // cboDayWeek(단일) — 값입력 대상 요일. 기본 SelectDay. cascade 없음(btnInput 대상 결정).
  dayWeekCode: string;
  // dCalendar 조회기간 — yyyymmdd 8자리.
  startYyyymmdd: string;
  endYyyymmdd: string;
  // txtInpuValue(MaxLength 4) — btnInput 이 선택 셀에 써넣을 값. 01_layout §1 #15.
  inputValue: string;
}

// 그리드 데이터 행 — GET SP O_RC1(피벗 데이터 커서). 정적 14컬럼(4 숨김) + 동적 D_yyyymmdd 값.
//   OSP_YN 이 편집 게이트('Y' 행만 편집, 01_layout §2-b #5). DMF0014 EDIT_FLAG 대응.
export interface WorkingTimeRow {
  // 식별 키(hidden 4 포함) — 03 §1 SEQ1~5,9
  PLANT_SITE_ID: string; //  SEQ1 hidden
  FACTORY_ID: string; //     SEQ2 hidden
  OPERATION_ID: string; //   SEQ3 hidden
  DIVISION_NAME: string; //  SEQ4 hidden
  DIVISION_ID: string; //    SEQ5
  PLANT_SITE_NAME: string; //SEQ6
  FACTORY_NAME: string; //   SEQ7 (Building)
  OPERATION_NAME: string; // SEQ8
  LINE_ID: string; //        SEQ9
  LINE_NAME: string; //      SEQ10
  // 편집 가능 셀 — WORKING_TIME_DEFAULT(FPNumber, 03 §1 SEQ11)
  WORKING_TIME_DEFAULT: string | number;
  LAST_INPUT_DATE: string; //SEQ12
  MEASURE: string; //        SEQ13 fixed
  // 편집 제어 키 — OSP_YN 대문자 'Y' 행만 편집 개방(01_layout §2-b #5). fixed(03 §1 SEQ14)
  OSP_YN: string;
  // 동적 D_yyyymmdd 기간 값 — GET SP O_RC1(데이터 커서)가 함께 반환. 인덱스 시그니처로 수용.
  [key: string]: string | number;
}

// BE ResultSetMetaData 사이드카 — GET SP 응답의 o_rc1_columns. 데이터 커서 컬럼의 이름/타입만 준다
//   (DynamicQueryModal BeColumnMeta 와 동일 형상). SP 에 타이틀 커서가 없어 이것이 동적 컬럼의 정본.
export interface DynColumnMeta {
  name: string; //  오라클 alias — 정적 컬럼명 또는 동적 D_yyyymmdd
  type: string; //  JDBC 타입명(미사용 — 컬럼 존재/이름 판별에만)
}

// 동적 기간 컬럼(FE 파생) — o_rc1_columns 의 D_yyyymmdd 이름에서 도출. 요일 그룹은 커서가 주지 않으므로
//   yyyymmdd 로 클라이언트 계산한다(SP "칸 펼치기": 일자마다 칸 1개, 요일은 캘린더 파생).
export interface DynDayColumn {
  binding: string; //   D_yyyymmdd (그리드 셀 binding)
  yyyymmdd: string; //  8자리 일자
  dayLabel: string; //  leaf 헤더 = 일(DD, 앞 0 제거)
  weekday: string; //   상단 그룹 span 키 = 요일 3글자(MON~SUN)
}

// SAVE 수집 엔트리 — 변경 셀(D_ 또는 WORKING_TIME_DEFAULT) net 변경. SAVE_KEYS 순서로 '^' join.
//   isSaveDefault='Y' 이면 WORKING_TIME_DEFAULT 저장(yyyymmdd/workingTime 미사용), 아니면 D_ 일자값.
export interface SaveEntry {
  activeFlag: string; //          셀 상태 (편집=M)
  divisionId: string;
  plantSiteId: string;
  factoryId: string;
  operationId: string;
  lineId: string;
  yyyymmdd: string; //            D_ 일자 (isSaveDefault!=='Y' 일 때)
  workingTime: string; //         D_ 셀 값
  isSaveDefault: string; //       'Y'=WORKING_TIME_DEFAULT 저장
  workingTimeDefault: string; //  기본 근무시간 값
}
