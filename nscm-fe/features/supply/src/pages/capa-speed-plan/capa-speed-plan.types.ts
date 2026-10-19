import type { DivisionType, GridSheet } from './capa-speed-plan.constants';

/**
 * 조회조건 13필드 (design 02 §1.1). 다중선택 6축은 공용 `CustomDropdown multiple` 규약대로
 * 콤마 결합 문자열이고, 전체선택/전체해제는 `ALL` sentinel 이다(02 §3.4).
 */
export interface SearchCondition {
  divisionType: DivisionType; // rgrpDivisionType — 시트/마스터 소스를 가르는 축
  divisionId: string; // cboDivision (단일)
  version: string; // cboVersion = Plan Month (단일)
  versionSeq: string; // cboVersionSeq = Version (단일)
  progressStatus: string; // cboProgressStatus = Status (단일)
  siteId: string; // clbSite (다중)
  plantId: string; // clbPlant (다중)
  factoryId: string; // clbFactory = Building (다중)
  lineId: string; // clbLine (다중)
  operationId: string; // clbOperation (다중, ELTR 에서는 숨김)
  electrodeType: string; // clbElectrodeType = Line Type (다중, Cell/MP 에서만 표시)
  itemId: string; // txtItem — 팝업 선택 결과, 콤마 결합
}

/** 콤보/마스터 1행 — CODE/NAME 외 cascade 용 부가 컬럼이 콤보마다 달라 unknown 맵으로 다룬다. */
export type ComboRow = Record<string, unknown>;

/** SearchArea 콤보 옵션 — 공용 `CustomDropdown` 계약. */
export interface ComboOption {
  label: string;
  value: string;
}

/**
 * 동적 기간 헤더 1행 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 반환(03 §2.1).
 * `LARGE_CLASS_LABEL_NAME` 은 SCP0105 에서 항상 NULL 이다(lookup SCP_CAPA_RPT_CODE 0건, 03 §2.2-5).
 */
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME?: string | null;
  SMALL_CLASS_LABEL_NAME?: string | null;
  LARGE_CLASS_LABEL_NAME?: string | null;
  DAY_CODE?: string | null;
  SORT_ORDER_NO?: string | null;
}

/**
 * 두 시트 공통 행 (design 03 §4.4).
 * `IDX`/`EDITABLE_YN`/`MEASURE_COLOR`/`MMS_CF` 는 1ST_CUTOFF SP 또는 ELTR SP 가 돌려주지 않아
 * optional 이다(03 §4.2 C-01/C-02). 기간 키는 `unknown` 인덱스 시그니처로 받고 소비 지점에서 좁힌다.
 */
export interface Scp0105BaseRow {
  IDX?: string;
  VER_ID: string;
  VER_SEQ: string;
  DIVISION_ID: string;
  COMPANY_ID: string;
  SITE_ID: string;
  PLANT_ID: string;
  FACTORY_ID: string;
  LINE_ID: string;
  OPERATION_ID: string;
  ELTR_LN_TP_CD: string;
  ITEM_ID: string;
  NICK_NAME: string;
  SPEED_UNIT_GROUP?: string;
  SPEED_UNIT_GROUP_SEQ?: string;
  MSR_TP_CD: string;
  MEASURE_NAME?: string;
  SORT_ORDER_NO?: string;
  PFRSLT_QTY?: number | null;
  BASE_QTY?: number | null;
  UI_UPD_YN?: string;
  NICK_NAME_DUMMY_YN?: string;
  DIVISION_NAME?: string;
  SITE_NAME?: string;
  PLANT_NAME?: string;
  FACTORY_NAME?: string;
  LINE_NAME?: string;
  OPERATION_NAME?: string;
  CRUD_TYPE?: string;
  // M_01yyyymm / Y_yyyy / *_ASSIGN_PRIORITY — SP 가 동적 조립하는 기간 컬럼.
  [periodKey: string]: unknown;
}

export interface Scp0105AssemblyRow extends Scp0105BaseRow {
  ELTR_QTY?: number | null;
  MMS_CF?: number | null;
  EDITABLE_YN?: string;
  BASE_EDITABLE_YN?: string;
  DUMMY_YN?: string;
  MEASURE_COLOR?: string;
}

export interface Scp0105EltrRow extends Scp0105BaseRow {
  EQUIPMENT_ID?: string;
  EQUIPMENT_NAME?: string;
  ELTR_TP_NM_EN?: string;
  // MMS_CF / MEASURE_COLOR 는 메타엔 있으나 ELTR SP 가 반환하지 않는다(03 C-02).
}

export type Scp0105Row = Scp0105AssemblyRow & Scp0105EltrRow;

/**
 * 시트별 조회 payload 보관용 키.
 * 값 타입이 문자열인 이유: 공용 `useTabProcQuery` 의 `filters` 는 `Record<string, JsonPrimitive>` 이고,
 * SP 파라미터는 전부 문자열로 나간다(다중선택도 `,` 결합 문자열). `String(value ?? '')` 가드를
 * payload 조립부에서 걸어 `'undefined'` 문자열 전파(ORA-01722)를 막는다.
 */
export type FiltersBySheet = Partial<Record<GridSheet | 'spreadTitle', Record<string, string>>>;
