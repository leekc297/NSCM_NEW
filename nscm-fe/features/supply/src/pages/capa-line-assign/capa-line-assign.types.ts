import type { DivisionType, MENU_ID, SHEETS } from './capa-line-assign.constants';

// design 03 §4.2 의 GET SP 반환 alias 를 procedures.d.ts 가 SSOT 로 보유한다(hook #73).
//   여기서는 로컬 interface 를 새로 만들지 않고 ResponseData 로 파생만 한다 — `any`/`as unknown as` 금지.

/** Assign 탭 행(Cell·Module-Pack). 동적 기간컬럼(`M_01YYYYMM`/`Y_YYYY`)은 인덱스 시그니처로 들어온다. */
export type CapaLineAssignRow = ResponseData<MENU_ID, SHEETS.ASSEMBLY, 'o_rc1'>;

/** Assign 탭 행(Electrode) — `EQUIPMENT_ID`/`EQUIPMENT_NAME`/`LANE_QTY` 3컬럼이 더 있다. */
export type CapaLineEltrRow = ResponseData<MENU_ID, SHEETS.ELTR, 'o_rc1'>;

/** SOP 탭 행. `VER_ID`/`VER_SEQ` 는 메타에만 있고 SP 미반환 → 항상 빈 값(design 03 §1.3). */
export type CapaLineSopRow = ResponseData<MENU_ID, SHEETS.SOP_ASSEMBLY, 'o_rc1'>;

/** P03 Line 팝업 행. */
export type CapaLinePopupRow = ResponseData<MENU_ID, SHEETS.LINE_ASSEMBLY, 'o_rc1'>;

/** P02 SOP Model 팝업 행. */
export type CapaLineSopModelRow = ResponseData<MENU_ID, SHEETS.SOP_MODEL_ASSEMBLY, 'o_rc1'>;

/** 동적 기간컬럼 타이틀 행(`P_SCP0104_GET_SPREAD_TITLE`). */
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'o_rc1'>;

/**
 * 조회조건 12필드(design 02 §1 S01~S14 / §5.2).
 *
 * 다중선택 5축은 `['ALL']` sentinel 로 시작한다(AS-IS `UsrCheckedList.ALL_VIEW=true` 기본 선택 ALL).
 * `'ALL'` 은 서버로 나가지 않는다 — `setFilters()` 가 현재 후보 전체 CODE CSV 로 펼친다(§4.3).
 */
export interface CapaLineAssignSearchParams {
  divisionId: string; // S01 p_division_id
  verId: string; // S02 Plan Month  p_version
  verSeq: string; // S03 Version     p_version_seq
  divisionType: DivisionType; // S05 화면 모드 스위치(직접 전달 없음 — p_sheet_name 파생)
  siteIds: string[]; // S06 p_site_id
  plantIds: string[]; // S07 p_plant_id
  factoryIds: string[]; // S08 Building p_factory_id
  lineIds: string[]; // S09 p_line_id
  operationIds: string[]; // S10 p_operation_id
  electrodeTypes: string[]; // S11 Line Type p_electrode_type
  itemId: string; // S12 Basic Nickname / Model  p_item_id
  validYn: string; // S14 p_valid_flag ('ALL' → '')
}

/** 콤보/마스터 응답 행 — SQL_ID 마다 부가컬럼이 달라 unknown 맵으로 다룬다. */
export type ComboRow = Record<string, unknown>;

/** 조회조건 드롭다운 옵션. */
export interface ComboOption {
  label: string;
  value: string;
}

/** 그리드 행 공통 형태(편집잠금/셀동기 유틸 입력). */
export type GridRow = Record<string, unknown>;
