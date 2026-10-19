// ⭐ DMF0003 — Grid 셀 콤보 단일 출처 (etc-sales-reports.gridCombos / business-plan.gridCombos 동형).
//   "어떤 컬럼이 어떤 콤보를 쓰는가 + 그 콤보에 무슨 파라미터를 싣는가" 를 전부 이 파일에 모은다.
//   MktFcstGrid.tsx 는 여기서 만든 filter/dataMap 을 소비만 한다 (콤보 정의를 컴포넌트에 두지 말 것).
//
// ============================================================================
// 컬럼 → 콤보 → 이벤트
// ============================================================================
// [컬럼]  조회 표시 콤보  →  신규행(INSERT) 편집 콤보  [전송 파라미터]  + 클라 필터
//
//  TEAM_ID          메타 cellCboDataTp('DeptId')            → TeambyDivisionAuth            [@sesUserId]
//  END_CUSTOMER     ┐
//  END_CUSTOMER40   ├ 공용 DataGrid columnMapping 메타 구동으로 이관 (META_DRIVEN_COMBO_COLUMNS).
//  SCM_SITE_ID      │ 편집 후보(PARAM9) · 좁힘(PARAM2) · 행 재조회(PARAM10='D') 전부 컬럼 메타가 갖는다.
//  SCM_SITE_ID40    ┘ 이 파일과 MktFcstGrid 는 이 4개 컬럼의 콤보를 일절 건드리지 않는다 — 상세는
//                     아래 META_DRIVEN_COMBO_COLUMNS 주석.
//  INCOTERMS        메타('INCOTERMS')                       → AS_INCOTERMS [@division,@salesSite = 그 행 값]
//                     ※ 행 Sales site 가 채워진 뒤에만 (ready)
//  MEASURE          메타('Measure')                         → MktFcstEditMeasure
//                     [@divisionId·@scmSiteId·@projectCode = 그 행 값, @sesUserId]
//                     → 편집 후보 화면단 강제 없음(메타 그대로 — 2026-09-15 UI 하드코딩 제거)
//  FCST_TYPE        메타('FCST_TYPE_DM' = ETC 제외)     → 편집 스왑 없음(메타 그대로)
//  AS_FROM_SITE     메타('AS_FROM_SITE')                    → AS_FROM_SITE [@divisionId = 그 행 Div]
//                     ※ 편집 허용 판정은 MktFcstGrid.isAsFromSiteEditable (4축)
//  그 외 콤보 컬럼   메타 cellCboDataTp 그대로               → 조회 콤보 그대로 편집
//
// [이벤트] — 위 스왑을 실제로 돌리는 지점 (MktFcstGrid.tsx)
//  1. 화면 조회      buildGridComboFilter(1) + buildEditComboFilter(2) + buildWsSupportComboFilters(3)
//                    를 useTabComboQueries 로 화면당 1회 조회 → dataMap 생성.
//  2. warm-up effect division 이 정해지면 ROW_PARAM_EDIT_COMBO(2-B)를 {DIVISION_ID: division} 로 선조회
//                    (신규행 첫 클릭에 후보가 비지 않게).
//  3. beginningEdit  INSERT 행일 때만 col.dataMap 을 편집 후보로 스왑. 동기 핸들러라 await 불가 —
//                    2-B 는 캐시 hit 면 스왑, miss 면 조회만 걸고 이번 진입은 조회 dataMap 을 쓴다.
//                    후보는 매 진입마다 그 행의 현재 값으로 다시 계산한다(= 셀 클릭 시 재반영).
//  4. cellEditEnded  col.dataMap 원복 + GRID_CASCADE_CLEAR 로 하위 셀 clear +
//                    바뀐 컬럼이 refreshOn 에 걸린 2-B 콤보 선조회(파라미터가 바뀌면 새 캐시 키 = 재조회).
//  5. formatItem     편집 중인 셀이 아니면 조회 dataMap 의 이름으로 다시 그린다 —
//                    col.dataMap 스왑은 컬럼 통째라 신규행 편집 중 조회 행 표시가 흔들리는 것을 막는다.
//
// ⭐ 파라미터 quoting 규약 (전 빌더 공통 — 위반하면 조용히 0행 또는 ORA-01722):
//   BE makeComboQuery 는 @token 을 payload 값으로 "따옴표 없이" raw 치환한다
//   (세션 sesUserId/sesLangCd 만 따옴표 포함 주입). 그래서 문자열 비교 조건에 쓰이는 값은
//   FE 가 `'값'` 으로 감싸 보내야 한다 — 반드시 quoteParam() 을 거칠 것.
//   · divisionId 를 raw 로 보내면 `SEGMENT1 = 81`(숫자 비교) → ORA-01722.
//   · 파라미터를 아예 안 보내면 `@divisionId → ''` → 0행.
//   · SQL 에 없는 토큰은 BE 가 무시(존재 토큰만 치환) → 잉여 파라미터는 무해(회귀 0).
import { DataMap } from '@mescius/wijmo.grid';

import { MENU_ID } from '../mkt-fcst.constants';

import { toCellStr } from './mkt-fcst.prContext';

/** useTabComboQueries filters 원소 — 파라미터 없으면 comboId 문자열, 있으면 객체. */
export type ComboFilter = string | { comboId: string; [key: string]: string };

/** BE raw 치환 대응 — 콤보 파라미터 값은 예외 없이 이걸 통과시킨다. */
const quoteParam = (v: string): string => `'${v}'`;

/**
 * 콤보 응답(ComboResponse[] | undefined) → 필터/dataMap 헬퍼 입력 형태.
 * 콤보 SQL 마다 CODE/NAME 외 부가 컬럼(DIVISION_ID, END_CUSTOMER …)이 달라 unknown 맵으로 다룬다.
 */
export const asComboRows = (rows: readonly unknown[] | undefined): Record<string, unknown>[] =>
  (rows ?? []) as Record<string, unknown>[];

// ============================================================================
// 1. 조회 표시 콤보 — 컬럼 dataMap (CODE→NAME 매핑)
// ============================================================================
//   comboId 는 하드코딩하지 않는다 — admin UI Category Setup 의 CELL_COMBO_DATA_TYPE
//   (컬럼 메타 cellCboDataTp → _comboKey)이 유일한 출처다 (hook column-lookup 표준).
//   @mnuId 는 전 콤보에 일괄로 싣는다 — 'Measure' 처럼 `PROGRAM_ID = @mnuId` 를 쓰는 SQL 이
//   미주입 시 '' 로 치환돼 0건이 되면 CODE→NAME 매핑이 사라진다(@mnuId 없는 콤보는 BE 가 무시).
//   ⚠️ Sales site 컬럼만 @divisionId 를 추가로 싣는다: SiteByEndCustomer SQL 이
//     `LEFT JOIN … ON (@divisionId = '40' AND …)` 로 division 40 에서만 품목 조인을 켠다.
//     대상은 comboId 가 아니라 binding 으로 고른다 (조회 콤보 comboId 하드코딩 금지 규약 유지).
//   주의: Sales site 2개 컬럼은 META_DRIVEN_COMBO_COLUMNS 로 넘어가 이 빌더를 더 타지 않는다.
//     그 @divisionId 는 이제 공용 DataGrid 의 comboParams 가 싣는다(MktFcstGrid). 여기 집합은
//     되돌릴 때를 위한 기록으로 남긴다 — 이관 컬럼이 줄어들면 다시 유효해진다.
const DISPLAY_DIVISION_PARAM = new Set(['SCM_SITE_ID', 'SCM_SITE_ID40']);

export const buildGridComboFilter = (
  binding: string,
  comboId: string,
  division: string
): ComboFilter => ({
  comboId,
  mnuId: quoteParam(MENU_ID),
  ...(DISPLAY_DIVISION_PARAM.has(binding) ? { divisionId: quoteParam(division) } : {}),
});

// ============================================================================
// 2. 편집 전용 콤보 — 화면 1회 조회, 편집 진입 시 dataMap 스왑 / cellEditEnded 원복
// ============================================================================
//   AS-IS DMF0003_MktFcst.cs: 편집 시엔 유효분만 후보로 주고, 조회 표시는 전체 매핑을 쓴다.
//   여기 파라미터는 "화면 단위" 값(검색 division / 세션 사용자)뿐이다.
//   행마다 달라지는 값이 필요한 컬럼(INCOTERMS·MEASURE)은 아래 2-B 소관.
export interface EditComboConfig {
  comboId: string;
  /** true → @divisionId 를 quoteParam 으로 실어 보낸다. */
  divisionParam?: boolean;
  /** true → @sesUserId 를 quoteParam 으로 실어 보낸다 (로그인 사용자 권한으로 갈리는 콤보). */
  sesUserIdParam?: boolean;
  /**
   * 화면/행과 무관하게 항상 같은 값을 싣는 토큰 (키 = SQL 토큰명 그대로, 값은 raw).
   * quoteParam 은 빌더가 건다 — 여기에 따옴표를 직접 넣지 말 것.
   */
  fixedParams?: Readonly<Record<string, string>>;
  /** true → W/S Planner 사용자에게만 스왑 (그 외는 조회 dataMap 그대로). */
  wsOnly?: boolean;
  /**
   * 지정 시 → 그 행의 해당 컬럼에 값이 있을 때만 스왑한다.
   * 공란이면 조회 콤보 dataMap 을 그대로 쓴다(= 일반 cascade 경로로 흘러간다).
   * 예: SCM_SITE_ID 는 End Customer 를 고르기 전엔 SiteByEndCustomer, 고른 뒤엔 …Auth.
   */
  whenRowFilled?: string;
}

export const GRID_EDIT_COMBO: Record<string, EditComboConfig> = {
  // TEAM_ID — SQL 이 @sesUserId 로 UNIT_AUTH/ADMIN/PM_TEAM_MAPPING 을 판정한다(@divisionId 토큰 없음).
  //   화면 division 은 이미 조회조건으로 갈려 있어 클라 cascade 규칙은 두지 않는다.
  //   주의: END_CUSTOMER / END_CUSTOMER40 / SCM_SITE_ID 의 편집 후보는 컬럼 메타 PARAM9 로 이관했다
  //   (META_DRIVEN_COMBO_COLUMNS). 여기에 다시 넣으면 공용 DataGrid 와 이중 구동이 된다.
  TEAM_ID: { comboId: 'TeambyDivisionAuth', sesUserIdParam: true },
  // FCST_TYPE 은 편집 콤보 스왑을 두지 않는다 — 조회/편집 모두 컬럼 메타(cellCboDataTp =
  //   'FCST_TYPE_DM')가 준 목록 그대로 쓴다(2026-09-11 요구: "메타대로만"). 신규행 편집을
  //   'FCST_TYPE'(@sesUserId 권한 판정) 으로 바꿔치기하던 항목을 제거했다.
};

/**
 * 편집 콤보 1건 → filter.
 * · divisionParam=true → @divisionId (검색 division. 행 Div 가 필요한 콤보는 2-B).
 * · sesUserIdParam=true → @sesUserId. BE(LookupServiceImpl.retrieveCombo)도 세션에서 채워주지만
 *   화면에서 명시적으로 싣는다 — 어느 쪽이 먼저 치환돼도 따옴표 포함이라 문자열 비교가 성립한다.
 * · fixedParams → 고정 토큰. 값은 quoteParam 을 거친다.
 * · @mnuId 는 조회 콤보와 동일하게 일괄 주입.
 */
export const buildEditComboFilter = (
  cfg: EditComboConfig,
  division: string,
  sesUserId: string
): ComboFilter => ({
  comboId: cfg.comboId,
  mnuId: quoteParam(MENU_ID),
  ...(cfg.divisionParam ? { divisionId: quoteParam(division) } : {}),
  ...(cfg.sesUserIdParam ? { sesUserId: quoteParam(sesUserId) } : {}),
  ...Object.fromEntries(
    Object.entries(cfg.fixedParams ?? {}).map(([k, v]): [string, string] => [k, quoteParam(v)])
  ),
});

/**
 * 편집 콤보 스왑 게이트 — 막히면 조회 dataMap 을 그대로 쓴다.
 * · wsOnly        : 비W/S 사용자는 스왑하지 않는다.
 * · whenRowFilled : 지정 컬럼이 그 행에서 공란이면 스왑하지 않는다(선행 값 선택 전 단계).
 */
export const shouldSwapEditCombo = (
  cfg: EditComboConfig,
  wsPlanner: boolean,
  row?: Record<string, unknown>
): boolean => {
  if (cfg.wsOnly && !wsPlanner) return false;
  if (cfg.whenRowFilled && !toCellStr(row?.[cfg.whenRowFilled]).trim()) return false;
  return true;
};

// ============================================================================
// 2-B. 행 단위 파라미터 편집 콤보 — 화면 1회 조회(useTabComboQueries) 구조 밖
// ============================================================================
//   여기 등록된 컬럼은 "그 행의 값" 이 콤보 파라미터에 실린다.
//   ⚠️ 왜 GRID_EDIT_COMBO 가 아니라 별도인가: useTabComboQueries 는 화면당 1회 조회라
//     행마다 다른 파라미터를 실을 수 없다 → apiClient.getCombo 를 직접 호출하고
//     "파라미터 조합" 을 키로 캐시한다 (DMF0082 ForecastPriceGrid SalesBucket 룩업과 동일 패턴).
//   ⚠️ beginningEdit 은 동기라 그 자리에서 await 할 수 없다 = 선조회가 유일한 방법.
//     캐시가 비어 있으면 그 한 번만 조회 콤보 dataMap 이 뜨고 요청만 걸린다(다음 진입부터 반영).
export type ComboParamMap = { comboId: string; [key: string]: string };

export interface RowParamComboConfig {
  comboId: string;
  /**
   * 그 행에서 이 컬럼들이 바뀌면 후보를 다시 만든다 (cellEditEnded 선조회 트리거).
   * · 파라미터가 실제로 바뀌는 컬럼(Div) → 새 캐시 키 = 재조회.
   * · 파라미터엔 안 실리지만 클라 필터에 쓰이는 컬럼(Sales site/Project) → 재조회는 캐시 hit 로
   *   끝나고, 후보 재계산은 편집 진입(beginningEdit)에서 매번 행 값으로 다시 돈다.
   */
  refreshOn: readonly string[];
  /**
   * 행 + 검색 division + 세션 사용자 → getCombo 파라미터. 캐시 키도 이 결과에서 파생한다.
   * sesUserId 가 필요 없는 콤보는 인자를 안 받으면 된다(적게 선언한 함수는 그대로 대입 가능).
   */
  buildParam: (row: Record<string, unknown>, division: string, sesUserId: string) => ComboParamMap;
  /** false → 조회/스왑 안 함 (조회 콤보 dataMap 유지). 미지정이면 항상 대상. */
  ready?: (row: Record<string, unknown>) => boolean;
}

/** 행에서 Sales site 를 읽는다 — 검색 division 40 은 SCM_SITE_ID40, 그 외(81·82)는 SCM_SITE_ID. */
export const SALES_SITE_BINDINGS: readonly string[] = ['SCM_SITE_ID', 'SCM_SITE_ID40'];

export const rowSalesSite = (row?: Record<string, unknown>): string => {
  for (const b of SALES_SITE_BINDINGS) {
    const v = toCellStr(row?.[b]).trim();
    if (v) return v;
  }
  return '';
};

/**
 * 행에서 Project 를 읽는다 — 81·82 는 PROJECT_CODE, 40 은 CUSTOMER_40.
 * 근거는 division.ts divisionKeyColumns(SAVE payload·중복검증이 쓰는 division 별 실 컬럼명) 와 동일.
 * 40 에서도 조회 응답 alias 차이로 PROJECT_CODE 가 올 수 있어 둘 다 훑는다(readIdentity fallback 과 같은 이유).
 */
const PROJECT_CODE_BINDINGS: readonly string[] = ['PROJECT_CODE', 'CUSTOMER_40'];

const rowProjectCode = (row?: Record<string, unknown>): string => {
  for (const b of PROJECT_CODE_BINDINGS) {
    const v = toCellStr(row?.[b]).trim();
    if (v) return v;
  }
  return '';
};

/**
 * 행의 Division — 신규행은 검색 division 으로 채워지지만(MktFcst.handleInsert) Div 컬럼이
 * 편집 가능(IM)이라 사용자가 바꿀 수 있다. 공란이면 검색 division 으로 되돌린다.
 */
const rowDivision = (row: Record<string, unknown> | undefined, division: string): string =>
  toCellStr(row?.DIVISION_ID).trim() || division;

export const ROW_PARAM_EDIT_COMBO: Record<string, RowParamComboConfig> = {
  // AS_INCOTERMS 는 (division, salesSite) 가 AS_SITE_PLANT 에 있으면 AS 목록, 없으면 일반
  //   INCOTERMS 목록을 주는 "스위치" 쿼리다. 반환은 CODE/NAME/DISPLAY_SEQ 뿐 — 사이트 구분 컬럼이
  //   없어 클라 cascade 로는 대체 불가하므로 반드시 파라미터로 보내야 한다.
  // ⚠️ 토큰명은 SQL 실측 그대로 `division` / `salesSite` (다른 콤보의 divisionId 아님).
  INCOTERMS: {
    comboId: 'AS_INCOTERMS',
    refreshOn: ['DIVISION_ID', ...SALES_SITE_BINDINGS],
    ready: row => !!rowSalesSite(row),
    buildParam: (row, division) => ({
      comboId: 'AS_INCOTERMS',
      mnuId: quoteParam(MENU_ID),
      division: quoteParam(rowDivision(row, division)),
      salesSite: quoteParam(rowSalesSite(row)),
    }),
  },
  // MktFcstEditMeasure = MKT_FCST_MEASURE lookup 중 VALID + TMM 제외.
  //   SQL 바인드 실측(2026-08-14): @divisionId / @measure / @scmSiteId / @projectCode / @sesUserId.
  //   division 뿐 아니라 사이트·프로젝트도 "그 행의 값" 이라 행 단위 콤보다.
  //   공란은 quoteParam('') = '' 로 나가고 SQL 은 그 경우 조건을 통과시킨다(= 전체 목록) —
  //   즉 값이 채워진 것만 실제로 후보를 좁힌다. 값이 있을 때만 키를 넣는 식으로 만들지 말 것:
  //   토큰을 빼면 BE 가 '' 로 치환해 결과는 같은데 캐시 키만 갈라져 같은 조합을 두 번 조회한다.
  // 주의: @measure(그 행의 현재 Measure)는 일부러 안 싣는다 — 이 콤보가 곧 Measure 후보 목록이라
  //   자기 값으로 좁히면 선택지가 자신 1건으로 붕괴한다. BE 가 '' 로 채워 전체 목록을 준다.
  // 주의: refreshOn 은 buildParam 이 읽는 컬럼과 반드시 같아야 한다 — 빠지면 그 컬럼을 바꿔도
  //   새 파라미터 조합이 선조회되지 않아 편집 진입 첫 번째가 옛 후보로 뜬다.
  MEASURE: {
    comboId: 'MktFcstEditMeasure',
    refreshOn: ['DIVISION_ID', ...SALES_SITE_BINDINGS, ...PROJECT_CODE_BINDINGS],
    buildParam: (row, division, sesUserId) => ({
      comboId: 'MktFcstEditMeasure',
      mnuId: quoteParam(MENU_ID),
      divisionId: quoteParam(rowDivision(row, division)),
      scmSiteId: quoteParam(rowSalesSite(row)),
      projectCode: quoteParam(rowProjectCode(row)),
      sesUserId: quoteParam(sesUserId),
    }),
  },
  // AS_FROM_SITE = SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='AS_SITE_PLANT') 의 AS(비축)향 사이트.
  //   SQL 이 CODE(SEGMENT2)/NAME(SEGMENT1) 만 반환하고 division 은 SEGMENT3 조건으로만 쓴다 —
  //   응답에 division 컬럼이 없어 클라 cascade 로는 못 좁힌다 = 반드시 파라미터로 보내야 한다.
  //   조건은 `NVL(TRIM(@divisionId),'-') = '-' OR SEGMENT3 = @divisionId` 이라 미전송 시 전체 목록이다.
  //   화면 division 이 아니라 그 행의 Div 를 싣는다 (Div 컬럼이 행 단위 편집 대상이라서).
  //   주의: 토큰명은 등록 SQL 실측 그대로 `divisionId` 다. param1 로 보내면 SQL 이 @divisionId 를
  //   '' 로 치환해 필터가 풀리고 전체(-82/-81/-40)가 반환된다(2026-09-03 신규행 전체노출 사고).
  AS_FROM_SITE: {
    comboId: 'AS_FROM_SITE',
    refreshOn: ['DIVISION_ID'],
    buildParam: (row, division) => ({
      comboId: 'AS_FROM_SITE',
      mnuId: quoteParam(MENU_ID),
      divisionId: quoteParam(rowDivision(row, division)),
    }),
  },
  // Sales Site(Div40 = SCM_SITE_ID40)는 컬럼 메타 PARAM10='D' 재조회형으로 이관했다
  //   (META_DRIVEN_COMBO_COLUMNS). 공용 DataGrid 의 useRowParamCombos 가 PARAM2
  //   `DIVISION_ID:divisionId,END_CUSTOMER40:endCustomer` 를 행 값으로 실어 SiteByEndCustomer 를
  //   행 조합마다 재조회한다 — 여기 있던 buildParam 과 같은 파라미터다(DMF0042 동형).
  //   AS-IS 근거는 그대로다: spdMain_ComboSelChange L3403·L3419 가 그 행의 Div40·Customer40 을 실어
  //   `Data.UserSiteByEndCustomer(...)` 를 다시 호출한다. SQL 의 40 분기는 END_CUSTOMER 가 아니라
  //   `SCM_MST_SITE_ITEM.PROJECT_CODE` 로 매칭하는데 응답에 PROJECT_CODE 가 없어 클라 필터로는
  //   대체 불가 = 반드시 파라미터로 보내야 한다.
  // ⭐ [2026-08-15] Plant Site(81 전용) — AS-IS `spdMain_CellClick` L6605~6616 [C20200525-000296]
  //   "Plant Site 에 Division, Project, Item 조건 추가" 는 셀에 들어가는 순간 그 행의
  //   Div·Project·Item 으로 `Data.Common(PlantSiteByItem, …)` 를 다시 걸어 후보를 만든다
  //   (Project/Item 셀 편집 직후 경로 L4157·L4166 도 같은 3값으로 재조회).
  //   TO-BE 는 beginningEdit 이 같은 자리라 여기서 행 파라미터로 재현한다.
  //   ⚠ 표시 dataMap 은 메타(`PlantByDivisionCompany`) 그대로 둔다 — 편집 후보(⊊ 표시 후보)를
  //     이유로 공유 메타를 바꾸면 이 콤보를 쓰는 다른 화면까지 좁아진다(편집/표시 이원화 규약).
  //   실측(2026-08-15): 무전달 107행 → div 만 27행 → div+project+item 5행.
  PLANT_SITE_ID: {
    comboId: 'PlantSiteByItem',
    refreshOn: ['DIVISION_ID', 'PROJECT_CODE', 'ITEM_ID'],
    buildParam: (row, division) => ({
      comboId: 'PlantSiteByItem',
      mnuId: quoteParam(MENU_ID),
      divisionId: quoteParam(rowDivision(row, division)),
      projectCode: quoteParam(toCellStr(row.PROJECT_CODE).trim()),
      itemId: quoteParam(toCellStr(row.ITEM_ID).trim()),
    }),
    // AS-IS 게이트: `sDivision.Substring(0,2) == "81"` (PLANT_SITE_ID 컬럼 자체가 81 계열 전용 메타)
    ready: row => toCellStr(row?.DIVISION_ID).trim().startsWith('81'),
  },
};

/** 행 단위 콤보 캐시 키 — 같은 파라미터 조합은 한 번만 조회한다. */
export const rowParamComboKey = (binding: string, param: ComboParamMap): string =>
  `${binding}|${JSON.stringify(param)}`;

// ============================================================================
// 3. W/S 분기 보조 콤보 — 편집 후보 필터 / 조건부 편집 판정의 입력
// ============================================================================
//   [E20260402-001736] FcstTypeWs = W/S FcstType 4종(SALES_TYPE_CODE2),
//   AS_FROM_SITE = AS(비축)향 사이트 목록(NAME=사이트, @divisionId=division).
//   용도: MEASURE 편집 후보 필터(§5) / AS_FROM_SITE 조건부 편집.
//   MktFcst.tsx 도 같은 2종을 조회한다 — 파라미터 규약을 한 곳으로 묶으려 여기서 빌드한다.
//   주의: 토큰명은 등록 SQL 실측 그대로 `divisionId` 다(param1 아님 — 위 ROW_PARAM_EDIT_COMBO 주석 참조).
export const buildWsSupportComboFilters = (division: string): ComboFilter[] => [
  { comboId: 'FcstTypeWs', mnuId: quoteParam(MENU_ID) },
  { comboId: 'AS_FROM_SITE', mnuId: quoteParam(MENU_ID), divisionId: quoteParam(division) },
];

// ============================================================================
// 4. Grid 내 cascade (hook #59 §5-G — DMF0020 표준 이식)
// ============================================================================
//   콤보 편집 진입 시 같은 행의 상위 셀 값으로 후보를 "클라에서" 필터한다(쿼리 파라미터 아님).
//   filter 키 = 콤보 SQL 반환 컬럼 실측. 관대 통과(행 값·콤보 값 공란/'ALL' = 통과)라
//   키를 안 가진 콤보(Div40 변형 등)는 자동 전체 통과 — 값 유실 없음.
//   ⚠️ 규칙 추가 시 콤보 응답에 comboKey 컬럼이 실제로 있는지 먼저 확인할 것 — 없으면
//     관대 통과에 걸려 조용히 전부 통과한다.
export interface CascadeRule {
  rowKey: string;
  comboKey: string;
  /**
   * true → 콤보 값 공란을 통과시키지 않는다(완전 일치만).
   * 행 값이 공란/'ALL' 일 때 전체 통과하는 것은 동일 — "아직 안 고른 상태" 는 여전히 전체 목록.
   * 예: Sales site 콤보에는 END_CUSTOMER 가 공란인 사이트(EG01-82-AS 등)가 섞여 오는데,
   *     End Customer 를 고른 뒤에는 그 고객의 사이트만 보여야 한다.
   */
  strict?: boolean;
}

/**
 * 화면 코드가 드는 cascade 표. 현재 등록 컬럼 없음 — 4개 컬럼(END_CUSTOMER / END_CUSTOMER40 /
 * SCM_SITE_ID / SCM_SITE_ID40) 의 좁힘을 컬럼 메타 PARAM2 로 이관했기 때문이다
 * (META_DRIVEN_COMBO_COLUMNS). 비어 있어도 지우지 않는다 — 메타로 표현할 수 없는 cascade
 * (콤보 응답 컬럼명 ≠ 행 컬럼명 / 콤보 쪽 공란 관대 통과 / strict 구분)가 다시 필요해지면
 * 여기 한 줄로 되살린다. 소비처는 MktFcstGrid 의 beginningEdit·cellEditEnded 와 comboDebug.
 *
 * 메타 PARAM2 와 규칙이 다르다는 점에 주의 — filterComboRowsByRowItem(메타)은 "콤보 쪽 값이
 * 비면 통과" 가 없고 strict 구분도 없다. 이 표로 되돌릴 때 그 차이를 먼저 확인할 것.
 */
export const GRID_CASCADE_FILTERS: Record<string, CascadeRule[]> = {};

/**
 * 공용 DataGrid columnMapping 메타(PARAM2/9/10)가 콤보를 전담하는 컬럼 (2026-09-03 이관).
 *
 * 이 집합의 컬럼은 화면 커스텀 콤보 machinery 를 **한 곳도** 타지 않는다 — MktFcstGrid 의
 * comboColumns(조회 dataMap 생성) · formatItem 재포맷 · beginningEdit 스왑 · cellEditEnded 원복 ·
 * 붙여넣기 dataMap 재부착이 전부 이 집합을 제외한다. 부분 제외(설정 표에서만 빼기)로는
 * 화면과 공용 DataGrid 가 같은 col.dataMap 을 번갈아 쓰는 이중 구동이 남는다(2026-09-03 회귀 원인).
 *
 * 컬럼 메타 등록값 (SCM_MST_SHEET_COLUMNS, PROGRAM_ID='DMF0003'):
 *   END_CUSTOMER    PARAM9='EndCustomerByDivisionDeptAuth'
 *                   PARAM2='DIVISION_ID:DIVISION_ID,TEAM_ID:DEPT_ID'
 *   END_CUSTOMER40  PARAM9='EndCustomerByDivision40'  (편집 콤보가 CODE/NAME 만 반환 → PARAM2 없음)
 *   SCM_SITE_ID     PARAM9='SiteByEndCustomerAuth'
 *                   PARAM2='DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER'
 *   SCM_SITE_ID40   PARAM10='D' + PARAM2='DIVISION_ID:divisionId,END_CUSTOMER40:endCustomer'
 *
 * 하위 셀 clear(GRID_CASCADE_CLEAR)는 이관 대상이 아니다 — 모달 컬럼(Project/Model)까지 비워야
 * 해서 콤보 메타가 표현할 수 있는 범위를 넘는다. 그대로 화면 코드가 갖는다.
 */
export const META_DRIVEN_COMBO_COLUMNS: ReadonlySet<string> = new Set([
  'END_CUSTOMER',
  'END_CUSTOMER40',
  'SCM_SITE_ID',
  'SCM_SITE_ID40',
]);

/**
 * 상위 콤보 값 변경 시 하위 셀 clear 체인 (같은 INSERT_GROUP 형제 행 포함 — DMF0020 동일).
 * 신규행에서 상위 값을 바꾸면 그 값에 종속된 하위 값은 유효하지 않게 되므로 비운다.
 * 목록은 2026-08-14 사용자 확정 스펙 그대로다 — 전이(transitive) 전파를 하지 않는다.
 *   End Customer 변경 -> Sales Site / Project Code / Model
 *   Sales Site  변경 -> Project Code / Model / Fcst Type / AS From Site
 *   Project Code 변경 -> Model
 * 즉 End Customer 를 바꿔도 Fcst Type 은 남는다(Sales Site 의 하위이지만 스펙에 없다).
 * 다만 AS_FROM_SITE 만은 예외로, 값이 남으면 잠긴 셀에 못 지우는 값이 갇히므로
 * cellEditEnded 가 isAsFromSiteEditable 로 매번 재판정해 별도로 비운다(CE-04).
 * Div40 계열은 END_CUSTOMER40 자체가 Project Code 역할이라 Project 단계가 없다.
 */
export const GRID_CASCADE_CLEAR: Record<string, readonly string[]> = {
  END_CUSTOMER: ['SCM_SITE_ID', 'PROJECT_CODE', 'ITEM_ID'],
  SCM_SITE_ID: ['PROJECT_CODE', 'ITEM_ID', 'FCST_TYPE', 'AS_FROM_SITE'],
  PROJECT_CODE: ['ITEM_ID'],
  END_CUSTOMER40: ['SCM_SITE_ID40', 'ITEM_ID40'],
  SCM_SITE_ID40: ['ITEM_ID40', 'FCST_TYPE', 'AS_FROM_SITE'],
};

/**
 * 코드 컬럼과 한 몸인 표시용 컬럼 — 코드만 지우고 두면 그리드에 옛 명칭이 남는다.
 * Model/Project 는 콤보가 아니라 팝업이 채우는 값이라 dataMap 재변환으로 갱신되지 않는다.
 */
const CASCADE_COMPANION_COLS: Record<string, readonly string[]> = {
  ITEM_ID: ['ITEM_NAME', 'ITEM_TYPE', 'NICK_NAME'],
  ITEM_ID40: ['ITEM_NAME', 'ITEM_TYPE', 'NICK_NAME'],
  PROJECT_CODE: ['PROJECT_NAME', 'PROJECT_OWNER'],
};

/**
 * 행 1건에 cascade clear 적용 — 그리드 편집(cellEditEnded)과 팝업 선택 경로가 함께 쓴다.
 * 팝업(Project/Model)은 cellEditEnded 를 타지 않으므로 이 함수를 직접 불러야 한다.
 * 호출 측이 "값이 실제로 바뀌었는지" 를 먼저 판정한다 — 같은 값 재선택으로 하위가 날아가면 안 된다.
 * keepCols = 지우지 않을 컬럼. 붙여넣기처럼 상위와 하위 값이 한 번에 들어오는 경로에서
 * 방금 붙여넣은 하위 값을 도로 지우지 않도록 호출 측이 넘긴다.
 */
export const applyCascadeClear = (
  rec: Record<string, unknown>,
  binding: string,
  keepCols: readonly string[] = []
): void => {
  for (const k of GRID_CASCADE_CLEAR[binding] ?? []) {
    if (keepCols.includes(k)) continue;
    rec[k] = '';
    for (const c of CASCADE_COMPANION_COLS[k] ?? []) rec[c] = '';
  }
};

// AS_FROM_SITE_CLEAR_TRIGGERS(트리거 컬럼 목록)는 2026-08-14 제거했다 —
//   cellEditEnded 가 정적 편집마다 isAsFromSiteEditable 로 재판정하는 방식으로 바뀌었다.
//   목록 방식은 위 cascade clear 가 Sales Site 를 간접적으로 비우는 경로를 놓친다(CE-04).

/**
 * 신규(I) 행의 키 컬럼 = 이 값이 바뀌면 행의 정체가 바뀐다 (CG-05, .cs L5319~5379).
 * 주의: 2026-08-27 요구로 이 목록을 쓰던 유일한 소비처(MktFcstGrid.applyStaticCascade 의 수량
 * 전량 클리어)가 제거돼 현재 참조하는 코드가 없다. 키 컬럼셋 자체의 기록 + 클리어를 되살릴 때의
 * 출처로 남긴다. 사유는 MktFcstGrid.tsx 의 A-08 [CG-05] 주석 참조.
 * 근거 컬럼셋은 utils/mkt-fcst.division.ts buildDuplicateKey(중복검증 키, AS-IS fnValidation
 * L4892~4956) 와 동일하다 — 저장 payload 가 이 키로 만들어지므로 키가 바뀐 행에 이전 키로 입력한
 * 수량을 그대로 남기면 다른 행의 수량을 저장하는 셈이 된다.
 * DIVISION_ID 는 제외 — 행 단위 편집 대상이 아니고(조회조건에서 주입) 바뀌면 그리드 자체가 초기화된다.
 * 40 계열은 그리드 바인딩(END_CUSTOMER40·SCM_SITE_ID40·ITEM_ID40) 과 저장 alias(*_40) 를 모두 담는다 —
 * 조회 응답 alias 차이로 어느 쪽이 올지 확정할 수 없다(division.ts readIdentity 의 fallback 과 같은 이유).
 */
export const ROW_KEY_BINDINGS: readonly string[] = [
  'PROJECT_CODE',
  'END_CUSTOMER',
  'END_CUSTOMER40',
  'CUSTOMER_40',
  ...SALES_SITE_BINDINGS,
  'SCM_SITE_ID_40',
  'ITEM_ID',
  'ITEM_ID40',
  'ITEM_ID_40',
  'DOM_EXP',
  'FCST_TYPE',
  'INCOTERMS',
  'MEASURE',
  'PLANT_SITE_ID',
  'AS_FROM_SITE',
];

/**
 * 행 컨텍스트 cascade 필터 (관대 통과: 행 값·콤보 키 공란/'ALL' = 통과) + 복합키 dedup.
 * strict 규칙은 콤보 값 공란 통과만 끈다 — 행 값이 공란/'ALL' 이면 여전히 전체 통과.
 */
export const filterComboRowsByRow = (
  src: Record<string, unknown>[],
  row: Record<string, unknown>,
  cascade: CascadeRule[]
): Record<string, unknown>[] => {
  const filtered = src.filter(cr =>
    cascade.every(({ rowKey, comboKey, strict }) => {
      const rv = toCellStr(row[rowKey]).trim();
      const cv = toCellStr(cr[comboKey]).trim();
      if (!rv || rv === 'ALL') return true;
      return strict ? rv === cv : !cv || rv === cv;
    })
  );
  // Map 복합 키 dedup (hook #59 §3) — 필터 후 division 컨텍스트 유지.
  return [
    ...new Map(
      filtered.map(cr => [`${toCellStr(cr.DIVISION_ID)}|${toCellStr(cr.CODE)}`, cr])
    ).values(),
  ];
};

// ============================================================================
// 5. MEASURE / FCST Type — 화면단 강제 없음 (메타대로만)
// ============================================================================
//   MEASURE 신규행 편집 후보는 화면단 강제(Sales site·W/S 권한에 따른 1종 고정 / AS_In_Req 제거)를
//     두지 않는다 — 조회/편집 모두 콤보(MktFcstEditMeasure)가 그 행의 division·사이트·프로젝트로
//     좁혀 준 목록 그대로 쓴다(2026-09-15 요구: "measure 컬럼 신규행은 메타대로 진행 — UI 하드코딩 제거").
//     이전의 filterMeasureEditRows(규칙표 2·3·4열: 사이트 축 1종 고정 + 비W/S AS_In_Req 제거)와
//     짝이던 값 강제(cellEditEnded)까지 함께 제거했다. FCST_TYPE 을 메타대로만 정리한 것과 같은 방향.
//
//   FCST Type 은 화면단 강제(편집 콤보 스왑 / Div82 WS·WSF 제외)를 두지 않는다 — 조회/편집 모두
//     컬럼 메타가 준 목록(FCST_TYPE_DM) 그대로 쓴다(2026-09-11 요구: "메타대로만").

// ============================================================================
// 6. dataMap / 재생성 시그니처 헬퍼
// ============================================================================
/**
 * 조회 표시 dataMap — 0건이면 null(dataMap 미부착).
 * 메타 주도 원칙: 응답이 비면 하드코딩 fallback 을 만들지 않는다.
 */
export const buildDataMap = (rows: Record<string, unknown>[]): DataMap | null =>
  rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;

/**
 * 편집 진입 스왑용 dataMap — 0건이어도 빈 DataMap 을 만든다.
 * (null 을 넣으면 콤보 컬럼이 자유 입력으로 열려 미등록 코드가 저장될 수 있다.)
 */
export const buildEditDataMap = (rows: Record<string, unknown>[]): DataMap =>
  new DataMap(rows, 'CODE', 'NAME');

/** dataMap 재생성 억제용 시그니처 — comboId(또는 binding) + row count 가 바뀔 때만 rebuild. */
export const buildComboSig = (
  keys: readonly (string | undefined)[],
  results: readonly (readonly unknown[] | undefined)[]
): string => keys.map((k, i) => `${k ?? ''}#${results[i]?.length ?? 'x'}`).join(',');
