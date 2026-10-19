import type { DivisionType, GridSheet, SheetType } from './capa-loss-plan.constants';

/**
 * 조회조건 14필드 (design 02 §1.1). 다중선택 6축은 공용 `CustomDropdown multiple` 규약대로
 * 콤마 결합 문자열이고, 전체선택/전체해제는 `ALL` sentinel 이다(02 §3.4).
 * `planType` 은 파생 표시값이라 여기 없다(store 가 따로 보유).
 */
export interface SearchCondition {
  divisionType: DivisionType; // rgrpDivisionType — 시트/마스터 소스를 가르는 축
  divisionId: string; // cboDivision (단일)
  version: string; // cboVersion = Plan Month (단일)
  versionSeq: string; // cboVersionSeq = Version (단일)
  progressStatus: string; // cboProgressStatus = Status (단일)
  sheetType: SheetType; // cboSheetType = MODEL/LINE (단일) — SCP0106 고유, 라벨 없음
  siteId: string; // clbSite (다중)
  plantId: string; // clbPlant (다중)
  factoryId: string; // clbFactory = Building (다중)
  lineId: string; // clbLine (다중)
  operationId: string; // clbOperation (다중, ELTR 에서는 숨김 — 값은 나간다)
  electrodeType: string; // clbElectrodeType = Line Type (다중, Cell 에서만 표시)
  nickName: string; // txtItem — 팝업 선택 결과, 콤마 결합. SP 파라미터는 `p_nick_name`
  showRate: boolean; // chkShowRate — 토글 대상(M_00)이 0건이라 실효 무동작(03 R-02)
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
 * SCP0105 와 달리 SCP0106 은 `LARGE_CLASS_LABEL_NAME` 에 **`Operation Plan` 이 실제로 온다**
 * (lookup `SCP_CAPA_RPT_CODE`) — 빈 값이면 오류다(03 V-17).
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
 * GET 2번 커서 — measure 메타 결과셋(03 §1.11).
 * **편집 가능 measure 의 단일 원천**이다. 코드 상수 배열로 대체하지 않는다(hook #130, V-23).
 * lookup `SCP_CAPA_LOSS_MEASURE`(29행) 를 SP 가 시트 상태에 맞춰 돌려준다.
 */
export interface MeasureTargetRow {
  /**
   * measure 코드. 결과셋 컬럼명은 **`LOSS_CD`** 다(`SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1` 의 별칭) —
   * 그리드 행의 `MEASURE` 컬럼과 이름이 다르니 혼동하지 말 것.
   * AS-IS 도 `DBUtils.GetStringColumnValues(tbl, "LOSS_CD")` 로 읽는다(`cs:2743`).
   */
  LOSS_CD: string;
  /** 표시명 — KO/EN 2종. `MEASURE_NAME`(그리드 행) 과 다른 컬럼이다. */
  LOSS_NM_EN?: string | null;
  LOSS_NM_KO?: string | null;
  /** measure 그룹 코드·명. */
  LOSS_GR_CD?: string | null;
  LOSS_GR_NM_EN?: string | null;
  LOSS_GR_NM_KO?: string | null;
  /** CURRENT 시트에서 편집 가능한가. 실측 10종(`PF_RT` 제외). */
  CURRENT_TARGET_YN?: string | null;
  /** 1차 컷오프 x MODEL 에서 편집 가능한가. 실측 0종. */
  FIRST_MODEL_TARGET_YN?: string | null;
  /** 1차 컷오프 x LINE 에서 편집 가능한가. 실측 4종(`SCP_PROD_PLAN SD_RT TD_RT MC_RT`). */
  FIRST_LINE_TARGET_YN?: string | null;
  /** 2차 컷오프에서 편집 가능한가. 실측 0종. */
  SECOND_TARGET_YN?: string | null;
  /** 표시 순서(lookup `DISPLAY_SEQ`). */
  DISPLAY_SEQ?: number | string | null;
}

/**
 * GET 3번 커서 — 기간별 일수·속도(03 R-08 5·7단계 `THRY_CAPA_D = SPEED_PPM * 1440`,
 * `PROD_CAPA_M = PROD_CAPA_D * DAY_CNT`).
 *
 * 결과셋 입도는 **엔티티 11축 + `YYYYMM`** 이다 — AS-IS GET SP 의 "DAY_CNT - UI 계산용" 블록이
 * VER_ID·VER_SEQ·DIVISION_ID·COMPANY_ID·SITE_ID·PLANT_ID·FACTORY_ID·LINE_ID·NICK_NAME·
 * OPERATION_ID·ELTR_LN_TP_CD·YYYYMM 으로 GROUP BY 하고, AS-IS 소비부도 같은 12축으로 한 행을
 * 집는다(`AssemblyUtils.cs:146-160`). `YYYYMM` 단독 키로는 라인·모델이 겹친다.
 *
 * `SPEED_PPM` 이 여기 있는 것이 핵심이다 — 그리드의 정적 `SPEED_PPM` 컬럼은 GET SP 가
 * `AVG(SPEED_PPM)`(전기간 평균)으로 내려주는 표시용 값이라 월별 파생 계산의 입력이 될 수 없다.
 */
export interface DayCountRow {
  YYYYMM: string;
  DAY_CNT: number | string | null;
  SPEED_PPM?: number | string | null;
  VER_ID?: string | null;
  VER_SEQ?: string | number | null;
  DIVISION_ID?: string | null;
  COMPANY_ID?: string | null;
  SITE_ID?: string | null;
  PLANT_ID?: string | null;
  FACTORY_ID?: string | null;
  LINE_ID?: string | null;
  NICK_NAME?: string | null;
  OPERATION_ID?: string | null;
  ELTR_LN_TP_CD?: string | null;
}

/**
 * 8시트 공통 행 (design 03 §4.2/§4.4).
 * 시트마다 반환 컬럼이 달라(28/27/27/27/32/29/28/28) **미반환 컬럼은 전부 optional** 이다.
 * 기간 키(`M_01yyyymm` / `Y_yyyy` / `*_ASSIGN_PRIORITY`)는 인덱스 시그니처 `unknown` 으로 받고
 * 소비 지점에서 좁힌다 — `any` 금지(convert-core §2.1 #4).
 */
export interface Scp0106BaseRow {
  IDX?: string | number;
  VER_ID?: string;
  VER_SEQ?: string | number;
  DIVISION_ID?: string;
  COMPANY_ID?: string;
  SITE_ID?: string;
  PLANT_ID?: string;
  FACTORY_ID?: string;
  LINE_ID?: string;
  LINE_IDX?: string | number;
  OPERATION_ID?: string;
  ELTR_LN_TP_CD?: string;
  ITEM_ID?: string;
  NICK_NAME?: string;
  BASIC_NICK_NAME?: string;
  MEASURE_GROUP?: string;
  MEASURE?: string;
  MEASURE_NAME?: string;
  MEASURE_GROUP_NAME?: string;
  SORT_ORDER_NO?: string;
  SPEED_PPM?: number | string | null;
  PFRSLT_QTY?: number | string | null;
  BASE_QTY?: number | string | null;
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

/** CURRENT / CUTOFF_MODEL 계열(ASSEMBLY·ELTR)에서만 오는 컬럼. */
export interface Scp0106ModelRow extends Scp0106BaseRow {
  EQUIPMENT_ID?: string;
  EQUIPMENT_NAME?: string;
  ELTR_TP_NM_EN?: string;
  ITEM_CNT?: number | string | null;
}

/**
 * LINE 계열(1ST/2ND_CUTOFF_LINE)에서만 오는 컬럼.
 * 생산확정기간 2컬럼은 **전 행 동일값**이라 첫 행에서 1회만 읽는다(03 R-06).
 */
export interface Scp0106LineRow extends Scp0106BaseRow {
  SCP_PRDN_PLAN_REF_ST_YM?: string | null;
  SCP_PRDN_PLAN_REF_END_YM?: string | null;
}

export type Scp0106Row = Scp0106ModelRow & Scp0106LineRow;

/**
 * 시트별 조회 payload 보관용 키.
 * 값 타입이 문자열인 이유: 공용 `useTabProcQuery` 의 `filters` 는 `Record<string, JsonPrimitive>` 이고,
 * SP 파라미터는 전부 문자열로 나간다(다중선택도 `,` 결합 문자열). `String(value ?? '')` 가드를
 * payload 조립부에서 걸어 `'undefined'` 문자열 전파(ORA-01722)를 막는다.
 */
export type FiltersBySheet = Partial<Record<GridSheet | 'spreadTitle', Record<string, string>>>;
