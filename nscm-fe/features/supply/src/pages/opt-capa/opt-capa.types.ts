/** 조회조건 — AS-IS 7항목(design 02 §1 S-1~S-7). 다중선택 2축은 `ALL` sentinel 배열이다. */
export interface OptCapaSearchParams {
  divisionId: string;
  planGrId: string;
  /** `YYYYMM` — `PeriodField mode='month'` 계약과 SP IN 계약이 같은 형식이다. */
  fromYyyymm: string;
  toYyyymm: string;
  plantIds: string[];
  lineIds: string[];
  nickName: string;
  itemId: string;
}

/**
 * 확정 조회조건 — Search 로 실제 발사된 값.
 * 신규행 `DIVISION_ID` 는 입력 중 `searchParams` 가 아니라 여기서 온다
 * (CommonCheckList Division §"Insert 시 확정 searchParams 기준 division").
 */
export interface OptCapaAppliedCondition {
  divisionId: string;
  plantIds: string[];
}

/** 그리드 1행 — 컬럼셋이 8시트로 갈리므로 index signature 로 둔다(컬럼 하드코딩 금지). */
export type GridRow = Record<string, unknown>;

/** 조회조건/셀 콤보 옵션. */
export interface ComboOption {
  label: string;
  value: string;
}

/** `init` `o_rc1` — Plant 마스터(design 02 §2.3). */
export interface PlantRow {
  CODE?: string;
  NAME?: string;
  DIVISION_ID?: string;
  ORG_DIVISION_ID?: string;
  /** `1`=정규 / `2`=OSP(외주). SP 가 숫자로 내려줄 수 있어 문자·숫자 양쪽을 받는다. */
  SEQ?: string | number;
  [key: string]: unknown;
}

/** `init` `o_rc2` — Line 마스터. `LINE_NAME`/`OPERATION_ID` 가 파생 2종의 원천이다(R-08·R-09). */
export interface LineRow extends PlantRow {
  OPERATION_ID?: string;
  PLANT_ID?: string;
  FACTORY_ID?: string;
  LINE_NAME?: string;
}

/** `init` `o_rc3` — Operation 후보(`CODE`=`NAME`). */
export type OperationRow = PlantRow;

/** `init` `o_rc4` — 탭 표시제외 목록(`OPMZ_OPT_CAPA_EXPT_DIV`). */
export interface ExcludedSheetRow {
  /** `SCM_MST_SHEET_COLUMNS.SHEET_NAME` 과 같은 표시명 축이다(A축). */
  SHEET_NAME?: string;
  DIVISION_ID?: string;
  [key: string]: unknown;
}

/** `init` `o_rc5` — Line Type 후보(`OPERATION_ID` 로 좁힌다). */
export interface LineTypeRow {
  CODE?: string;
  NAME?: string;
  OPERATION_ID?: string;
  [key: string]: unknown;
}

/** `init` `o_rc6` — No Work `TYPE` lookup 10건. AS-IS 워킹트리 `.cs` 에 소비자가 없다(§6-Q3). */
export interface NoWorkTypeRow {
  CODE?: string;
  NAME?: string;
  [key: string]: unknown;
}

/** Batch Save 팝업 1행 — 컬럼 메타가 없는 클라 생성 그리드다(BatchPopup cs:235-248). */
export interface BatchGridRow {
  SEQ: number;
  DAY_OF_WEEK: string;
  OFF_TIME: string;
  DESC: string;
  [key: string]: unknown;
}
