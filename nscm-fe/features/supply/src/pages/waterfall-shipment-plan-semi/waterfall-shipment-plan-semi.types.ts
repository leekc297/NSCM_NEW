/**
 * SCP0018 조회조건 상태 (`02_search-combo.md §1/§5` 8종 인벤토리 그대로).
 * Bucket/Sum 은 SP 로 전달되지 않는 순수 클라 그리드 트리거(§2.4/§3) — SearchParams 에는 포함하되
 * setFilters() 조립에서 제외한다.
 */
export interface SearchParams {
  divisionId: string; // Division (단일, cascade 루트)
  operationGroup: string; // Operation Group (단일 — §2.3 트리거별 SQL_ID 분기)
  itemId: string; // Model(Item ID) — 텍스트 입력 or 팝업 선택
  electrodeTypes: string[]; // Electrode Type (다중, division=EE 조건부 활성)
  bucket: string; // Bucket — SP 미전달, 그리드 pivot 트리거
  versionNos: string[]; // Version (다중 체크)
  startYyyymmdd: string; // Period From
  endYyyymmdd: string; // Period To
  isSumChecked: boolean; // Sum — SP 미전달, 그리드 M_/W_ 컬럼 visible 토글
}

/** 메인 조회 응답 행(동적 pivot D_/W_/M_/B_ 포함 — 정적 24열은 03_grid-columns.md §1). */
export interface WaterfallRow {
  MEASURE: string;
  MEASURE_LABEL: string;
  [key: string]: string | number;
}

/** 캘린더 SP 응답 행(3단 헤더 원천 — `03_grid-columns.md §2.2`). */
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  MMDD_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  DAY_CODE?: string;
  [key: string]: string | number | undefined;
}
