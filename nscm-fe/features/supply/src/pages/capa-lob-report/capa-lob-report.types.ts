import type { DivisionType } from './capa-lob-report.constants';

/**
 * 조회조건 14필드 중 값을 갖는 12건 + 파생 2건 (design 02 §1 / §5.4).
 *
 * 다중선택 6축은 공용 `CustomDropdown multiple` 규약대로 **콤마 결합 문자열**이고 전체선택/
 * 전체해제는 `ALL` sentinel 이다(02 §3.4). 설계 §5.4 초안은 배열(`siteIds: []`)로 적었으나
 * 공용 컴포넌트 계약이 문자열이라 문자열로 보관하고 전송 시 `''`(무필터)로 바꾼다 — 서버로 나가는
 * 값은 설계 계약과 동일하다(무선택 -> `''`).
 */
export interface CapaLobSearchParams {
  divisionType: DivisionType; // rgrpDivisionType — shopGroup·가시성·6축 필터축 (cs:975)
  divisionId: string; // cboDivision (단일, ALL 없음)
  verId: string; // cboVersion = Plan Month (단일)
  verSeq: string; // cboVersionSeq = Version (단일, 값=표시 둘 다 VER_SEQ)
  progressStatus: string; // cboProgressStatus = Status (파생·disabled — 시트 스위치 축)
  siteId: string; // clbSite (다중)
  plantId: string; // clbPlant (다중)
  factoryId: string; // clbFactory = Building (다중)
  lineId: string; // clbLine (다중)
  operationId: string; // clbOperation (다중, ELTR 에서 숨김)
  electrodeType: string; // clbElectrodeType = Line Type (다중, CELL 에서만 표시)
  nickName: string; // txtItem — 팝업 다중선택 결과 `,` join
  bottleneckFlag: string; // cboBottleneck ('ALL' 기본, 전송 시 '')
}

/** 콤보/마스터 1행 — CODE/NAME 외 cascade 용 부가 컬럼이 콤보마다 달라 unknown 맵으로 다룬다. */
export type ComboRow = Record<string, unknown>;

/** SearchArea 콤보 옵션 — 공용 `CustomDropdown` 계약. */
export interface ComboOption {
  label: string;
  value: string;
}

/**
 * 동적 기간 헤더 1행 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 반환(03 §2.1/§4.4).
 * SCP0108 은 lookup `SCP_CAPA_RPT_CODE`(SEGMENT1='SCP0108', SEGMENT2='MAIN') 1행이 있어
 * `LARGE_CLASS_LABEL_NAME` 이 `Operation Plan` 으로 채워진다 — 자매 SCP0105(NULL)와 다르다.
 */
export interface SpreadTitleRow {
  COLUMN_NAME: string; // 'M_01202511' | 'Y_2028'
  COLUMN_LABEL_NAME?: string | null; // '2025-11' | '2028'   <- 3단
  SMALL_CLASS_LABEL_NAME?: string | null; // '2025'          <- 2단
  LARGE_CLASS_LABEL_NAME?: string | null; // 'Operation Plan' <- 1단
  DAY_CODE?: string | null; // SCP0108 경로에서는 항상 ''
  SORT_ORDER_NO?: string | null; // '012025110101' 12자리 고정폭(문자열 정렬이 표시 순서)
}

/**
 * SCP0108 그리드 행 — CURRENT/CUTOFF 공통 상위집합 (03 §4.4).
 *
 * `DV`·`DIVISION_NAME`·`COMPANY_NAME` 은 컬럼 메타에 없지만 **행 객체에는 보유한다**(03 §1.7) —
 * 합계행 판정·Bottleneck 키 조인에 필요하다. 메타 부재를 이유로 응답에서 버리면 §4.2 의
 * 합계행 규칙을 구현할 수 없다. 컬럼으로는 만들지 않는다(staticColumns 가 유일한 컬럼 출처).
 */
export interface CapaLobRow {
  DV: string; // '1'=NickName 합계행 / '2'=상세행. CURRENT 메타엔 없지만 응답엔 있다
  VER_ID?: string; // CUTOFF 만 반환(CURRENT 는 메타에만 있어 빈칸, 03 §1.7)
  VER_SEQ?: string | number; // 동상
  DIVISION_ID: string;
  COMPANY_ID: string;
  SITE_ID: string;
  PLANT_ID: string;
  LINE_ID: string;
  NICK_NAME: string;
  OPERATION_ID: string;
  OPERATION_NAME?: string | null; // CUTOFF 는 ISNULL 없음 -> null 가능
  ELTR_LN_TP_CD: string; // 코드 원문 표시(lookup 미바인딩 — 03 §1.6 / C-06)
  DIVISION_NAME?: string; // 메타 미등재 — 표시하지 않는다
  SITE_NAME?: string;
  COMPANY_NAME?: string; // CURRENT 만 반환
  PLANT_NAME?: string;
  LINE_NAME?: string;
  // M_01yyyymm / Y_yyyy — SP 가 동적 조립하는 기간 컬럼(number | null).
  [periodKey: string]: unknown;
}

/**
 * 2번째 커서 1행 — 동일 키 9축 + 기간별 `'Y'`/null.
 * 행 인덱스가 아니라 **키로 병합**한다(03 R-11 / V-23).
 */
export type CapaLobBottleneckRow = Record<string, unknown>;

/** 조회 payload — SP IN 15 중 FE 가 싣는 13건(`p_user_id`/`debug_mode` 제외, 02 §1.1). */
export interface CapaLobFilters {
  version: string;
  versionSeq: number;
  divisionId: string;
  siteId: string;
  plantId: string;
  factoryId: string;
  lineId: string;
  operationId: string;
  nickName: string;
  electrodeType: string;
  bottleneckFlag: string;
  programId: string;
  sheetName: string;
}

/** 헤더 SP payload — 캐시 키에 3요소가 전부 실려야 화면/버전 간 오염이 없다(hook #115). */
export interface SpreadTitleFilters {
  fromYyyymm: string;
  programId: string;
  sheetName: string;
}

/**
 * 시트별 조회 payload 보관용 — 키가 있으면 조회 대상, 없으면 비활성(명시 Search 게이트).
 * 키 이름은 `SHEETS` 값과 1:1 이다(`CURRENT`/`CUTOFF`/`spreadTitle`). `MAIN` 은 그리드 시트가
 * 아니라 여기에도 없다(03 §0.3 / V-05).
 */
export interface CapaLobFiltersBySheet {
  CURRENT?: CapaLobFilters;
  CUTOFF?: CapaLobFilters;
  spreadTitle?: SpreadTitleFilters;
}
