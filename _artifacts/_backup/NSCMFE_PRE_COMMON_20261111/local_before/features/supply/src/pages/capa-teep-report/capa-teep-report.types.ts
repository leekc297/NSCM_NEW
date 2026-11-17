import type { DivisionType, GridSheet } from './capa-teep-report.constants';

/**
 * 조회조건 9필드(design 02 §1 C1~C11 중 값을 갖는 9건).
 *
 * 다중선택 6축(Division/Site/Plant/Building/Line/Line Type + Operation = 7축 중 Division 포함)은 공용
 * `CustomDropdown multiple` 계약대로 **콤마 결합 문자열**이고 전체선택/전체해제는 `ALL` sentinel 이다.
 * **Division 도 다중선택**인 것이 자매 SCP0105/0106/0108(단일)과 다르다 — `clbDivision` 은 체크리스트
 * 컨트롤이고 `ALL_VIEW=true`/`ValueList="ALL"` 이다(02 §1.1 Designer 실측). 단일로 만들면 AS-IS 에서
 * 여러 사업부를 동시에 조회하던 경로가 사라진다.
 *
 * `planType`(C4)은 파생 표시값이라 여기 없다 — store 가 따로 보유한다(02 §2.2).
 */
export interface CapaTeepSearchParams {
  divisionType: DivisionType; // rgrpDivisionType = Operation group — 시트/마스터 소스를 가르는 축
  divisionId: string; // clbDivision (다중 + ALL)
  verId: string; // cboVersion = Plan Month (단일)
  verSeq: string; // cboVersionSeq = Version (단일, 값=표시 둘 다 VER_SEQ)
  siteId: string; // clbSite (다중)
  plantId: string; // clbPlant (다중)
  factoryId: string; // clbFactory = Building (다중)
  lineId: string; // clbLine (다중)
  operationId: string; // clbOperation (다중, Electrode 에서 숨김 — 값은 나간다)
  electrodeType: string; // clbElectrodeType = Line Type (다중, Cell 에서만 표시)
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
 * 반환 6컬럼 중 실사용은 4건이고 `DAY_CODE`(TVF 가 항상 `''`)·`SORT_ORDER_NO`(정렬 전용)는 표시에
 *쓰지 않는다. `MMDD_LABEL_NAME` 은 TVF 반환에 아예 없다(03 §2.1 미사용 2 / §7.2).
 * SCP0107 은 lookup `SCP_CAPA_RPT_CODE`(SEGMENT1='SCP0107', SEGMENT2 ∈ {ASSEMBLY, ELTR}) 2행이 있어
 * `LARGE_CLASS_LABEL_NAME` 이 `Operation Plan` 으로 채워진다 — **빈 값이면 결함**이다(V-16).
 */
export interface SpreadTitleRow {
  COLUMN_NAME: string; // 'M_01202602' | 'Y_2029'
  COLUMN_LABEL_NAME?: string | null; // '2026-02' | '2029'   <- 3단 원문(월은 2자리로 잘라 쓴다, V-18)
  SMALL_CLASS_LABEL_NAME?: string | null; // '2026'          <- 2단
  LARGE_CLASS_LABEL_NAME?: string | null; // 'Operation Plan' <- 1단
  DAY_CODE?: string | null; // SCP0107 경로에서는 항상 ''
  SORT_ORDER_NO?: string | null; // 12자리 고정폭(문자열 정렬이 표시 순서, 03 §2.2)
}

/**
 * SCP0107 그리드 행 — ASSEMBLY/ELTR 공통 상위집합(03 §1.6 / §4.3).
 *
 * 행 = Measure(피벗 세로축), 열 = 고정 키 + 전월 실적 3 + Base + 기간이다.
 * `SORT_ORDER_NO_GR`·`MEASURE`·`MEASURE_GROUP` 등은 그리드 컬럼이 폭 0 / 미생성이라 화면에 뜨지 않지만
 * **행 객체에는 반드시 실려 있어야 한다** — `MEASURE` 는 행 배경색과 소수 자릿수 판정의 조건 컬럼이다
 * (03 §3.2 G-13 주의). 메타 부재를 이유로 응답에서 버리면 두 규칙이 통째로 무동작이 된다.
 * `ELTR_LN_TP_CD` 는 ASSEMBLY 만 반환한다(ELTR SP 는 미반환 — §1.6).
 */
export interface CapaTeepRow {
  VER_ID?: string;
  VER_SEQ?: string | number;
  DIVISION_ID?: string;
  DIVISION_NAME?: string; // SP 반환이나 컬럼 메타 미등록 — 표시하지 않는다(§1.6)
  COMPANY_ID?: string;
  SITE_ID?: string;
  SITE_NAME?: string;
  PLANT_ID?: string;
  PLANT_NAME?: string;
  FACTORY_ID?: string;
  FACTORY_NAME?: string;
  LINE_ID?: string;
  LINE_NAME?: string;
  OPERATION_ID?: string;
  OPERATION_NAME?: string | null;
  ELTR_LN_TP_CD?: string; // ASSEMBLY 만. 코드 원문(`S`/`W`/`-`) 표시 — lookup 미바인딩(§1.4)
  MEASURE_GROUP?: string;
  MEASURE_GROUP_NAME?: string;
  MEASURE?: string; // 배경색·소수자릿수 판정 조건 컬럼(숨김이지만 데이터 필수)
  MEASURE_NAME?: string; // 배경색 적용 시작 열
  SORT_ORDER_NO_GR?: string | number; // 행 블록 구분(2=전체 Total / 3=Division Total / 0=상세)
  SORT_ORDER_NO?: string | number;
  BIZ_QTY?: number | string | null;
  PRE_QTY?: number | string | null;
  PFRSLT_QTY?: number | string | null;
  BASE_QTY?: number | string | null;
  // M_01yyyymm / Y_yyyy — SP 가 동적 조립하는 기간 컬럼(number | null).
  [periodKey: string]: unknown;
}

/**
 * 조회 payload — SP IN 13 중 FE 가 싣는 12건(`p_user_id` 는 BE `@LoginUser` 자동 주입, 02 §5.5).
 *
 * **키는 camelCase 다** — `SCM_ADM_PROC_M.COL_NM` 이 이 키와 정확히 일치해야 바인딩된다(불일치는
 * 에러 없이 NULL 바인딩, 메모리 `generic-callproc-param-key-must-match-proc-m-colnm`). SCP 도메인
 * 실등록이 camelCase 다(`PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT` = `divisionId`/`programId`/
 * `bucket`). 자매 `capa-loss-plan`/`capa-speed-plan` 은 snake(`p_from_yyyymm`)로 보내고 있어
 * `PKG_SCP0104` 배포 시 한쪽은 NULL 바인딩된다 — `convert-sp` 인계 사항이며 자매 화면 수정은
 * Hard Boundary 밖이다(자매 SCP0108 iter-1 G-07 과 동일 관측).
 */
export interface CapaTeepFilters {
  version: string; // 1 P_VERSION      Plan Month(VER_ID, yyyyMM)
  versionSeq: number; // 2 P_VERSION_SEQ  VER_SEQ (AS-IS byte 캐스팅, 실패 시 0)
  divisionId: string; // 3 P_DIVISION_ID  ALL -> '' (SP 가 전체로 해석)
  siteId: string; // 4 P_SITE_ID      이하 6축 CSV, ALL -> 후보 전건 CSV / 후보 0건 -> 'NONE'
  plantId: string; // 5 P_PLANT_ID
  factoryId: string; // 6 P_FACTORY_ID   라벨은 Building (hook #112 rename)
  lineId: string; // 7 P_LINE_ID
  operationId: string; // 8 P_OPERATION_ID
  electrodeType: string; // 9 P_ELECTRODE_TYPE
  programId: string; // 10 P_PROGRAM_ID  'SCP0107'
  sheetName: string; // 11 P_SHEET_NAME  'ASSEMBLY' | 'ELTR'
  // 12 P_USER_ID  = BE @LoginUser 자동 주입
  debugMode: string; // 13 DEBUG_MODE    리터럴 'F'
}

/** 헤더 SP payload — 캐시 키에 3요소가 전부 실려야 화면/버전 간 오염이 없다(hook #115 / V-18d). */
export interface SpreadTitleFilters {
  fromYyyymm: string;
  programId: string;
  sheetName: string;
}

/**
 * 시트별 조회 payload 보관용 — 키가 있으면 조회 대상, 없으면 비활성(명시 Search 게이트).
 * 키 이름은 `SHEETS` 값과 1:1 이다(`ASSEMBLY`/`ELTR`/`spreadTitle`).
 */
export type CapaTeepFiltersBySheet = Partial<Record<GridSheet, CapaTeepFilters>> & {
  spreadTitle?: SpreadTitleFilters;
};
