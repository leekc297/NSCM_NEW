import type { ComboParam, ComboResponse } from '@foundation/models';

export const MENU_ID = 'DMF0006' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_MODEL_MAPPING = 'customerModelMapping',
}

export enum RESPONSE_SET {
  DATA = 'o_rc1',
}

/**
 * Model Type(ITEM_CLASS_NAME) 별 Convert Qty 편집제어 대상 컬럼 바인딩.
 * AS-IS DM0006_CustomerModelMapping.cs 의 CONVERT_QTY_PACK/MODULE/CELL 과 1:1.
 */
export const CONVERT_QTY_BINDINGS = {
  PACK: 'CONVERT_QTY_PACK',
  MODULE: 'CONVERT_QTY_MODULE',
  CELL: 'CONVERT_QTY_CELL',
} as const;

/** Model Type 필드 바인딩 (AS-IS ITEM_CLASS_NAME). */
export const MODEL_TYPE_BINDING = 'ITEM_CLASS_NAME';

/** PJT Code 필드 바인딩. */
export const PROJECT_CODE_BINDING = 'PROJECT_CODE';

/**
 * Project 개념이 없는 Division (Mobility) — 조회조건 Project 입력/팝업 비활성 대상.
 * MKT FCST(DMF0043) ProjectField 의 `disabled={sc.divisionId === DIVISION.MOBILITY}` 와 동일 규칙.
 */
export const DIVISION_NO_PROJECT = '40';

/** Division 필드 바인딩. */
export const DIVISION_BINDING = 'DIVISION_ID';

/** Team 필드 바인딩. 신규행 후보 콤보 배선은 customer-model-mapping.gridCombos.ts 참조. */
export const TEAM_BINDING = 'DEPT_ID';

/**
 * 컬럼 메타 Param1(SCM_MST_SHEET_COLUMNS.ATTRIBUTE1) 의 허용 Division 목록 판정.
 *
 * 관리자 UI Category Setup 에서 해당 컬럼 Param1 에 콤마 목록을 넣으면 그 Division 에서만
 * 편집/팝업이 열린다 (예: PROJECT_CODE 에 '81,81_UC,81_HM,81_ST,81_HD,81_HG,82' → 40 은 잠김).
 * 값이 비어 있으면 제한 없음 — 메타 미등록 화면/컬럼은 종전대로 동작한다.
 *
 * 판정은 콤마 토큰 정확 일치다(substring 금지, 룰 #92 — sales-monitoring _divisionAllow 와 동일 규약).
 * 그래서 81 하위 코드(81_HM 등)를 허용하려면 그 코드까지 목록에 적어야 한다.
 */
export const isDivisionAllowed = (allowList?: string, divisionId?: string): boolean => {
  const allow = allowList?.trim();
  if (!allow) return true;
  if (!divisionId) return true;
  return allow
    .split(',')
    .map(token => token.trim())
    .includes(divisionId);
};

export interface ConvertQtyEditable {
  pack: boolean;
  module: boolean;
  cell: boolean;
}

/**
 * Model Type(ITEM_CLASS_NAME) 값에 따라 Convert Qty(Pack/Module/Cell) 편집 가능 여부를 반환.
 *
 * AS-IS DM0006_CustomerModelMapping.cs L289~307(EditButton) / L1075~1089(CellDoubleClick) 재현:
 *   대소문자 무시 substring 매칭, 판정 순서 MODULE → CELL → PACK → 그 외.
 *   - MODULE 포함 : Pack ✅ / Module ✅ / Cell 🔒
 *   - CELL   포함 : Pack ✅ / Module ✅ / Cell ✅
 *   - PACK   포함 : Pack ✅ / Module 🔒 / Cell 🔒
 *   - 그 외       : Pack ✅ / Module ✅ / Cell ✅
 */
export const getConvertQtyEditable = (itemClassName?: string): ConvertQtyEditable => {
  const type = (itemClassName ?? '').toUpperCase();

  if (type.indexOf('MODULE') >= 0) {
    return { pack: true, module: true, cell: false };
  }
  if (type.indexOf('CELL') >= 0) {
    return { pack: true, module: true, cell: true };
  }
  if (type.indexOf('PACK') >= 0) {
    return { pack: true, module: false, cell: false };
  }
  return { pack: true, module: true, cell: true };
};

/**
 * 조회조건 콤보 원천 7종. 등록명은 AS-IS DMF0006_CustomerModelMapping.cs 호출부와 1:1 이다.
 *
 * DMF0006 은 속도개선(PJT202350699) 대상에서 빠진 화면이라 SetChangeControl / GetDMInnerTable 이
 * 한 줄도 없다. 조회조건 콤보와 그리드 셀 콤보 모두 예외 없이 재조회 방식이다.
 *
 * 조인 평면 콤보 1건으로 묶는 CascadeFields 는 이 화면에 쓰지 않는다 - End Customer 와 Sales Site
 * 는 원천이 둘로 갈리고 어느 쪽을 쓸지가 "무엇이 바뀌었는가"로 정해지기 때문이다(아래 트리거).
 * 패턴 정본은 DMF0004 utils/sales-site.salesSiteCombo.ts 다.
 *
 * 금지: AS-IS 의 Data.UserXxx 메서드 이름을 콤보 ID 로 쓰지 말 것. 그건 C# 래퍼 이름이고 실제
 * 등록명은 안에서 부르는 문자열이다 (Data.cs L1076~1108) -
 *   Data.UserTeamByDivision(...)            -> CallBizCommonData("TeambyDivision", divisionID, ...)
 *   Data.UserEndCustomerByDivisionDept(...) -> CallBizCommonData("EndCustomerByDivisionDept", divisionID, deptID, ...)
 *   Data.UserSiteByEndCustomer(...)         -> CallBizCommonData("SiteByEndCustomer", divisionId, endCustomer, ...)
 * User 접두 콤보도 DB 에 따로 등록돼 있지만 다른 SQL 이다 - UserTeamByDivision 에는 division
 * 토큰이 아예 없고 @sesUserId 의 권한 division 전체를 훑어, 81 에서 목록이 크게 벌어진다
 * (2026-08-27 실측). 이 화면이 쓸 것은 AS-IS 가 부르는 접두 없는 쪽이다.
 *
 * 필수: 파라미터는 이름 토큰으로 보낸다 (2026-08-27 SQL 실물 확인).
 *
 *   TeambyDivision            @divisionId
 *   EndCustomerByDivision40   @divisionId  @deptId
 *   EndCustomerByDivisionDept @divisionId  @deptId
 *   SiteByEndCustomer         @divisionId  @endCustomer     (+ @userGrId 는 아래 주석 참조)
 *   ScmSitebyEndCustomer40    없음 - division 을 SQL 에 '40' 으로 하드코딩한다
 *   MyDivision / YesOrNo      없음
 *
 * 주의: 등록 SQL 의 토큰은 바뀐다. 한때 TeambyDivision 이 @PARAM1 이었다가 이름 토큰으로
 * 원복됐다(2026-08-27 당일 두 번). 목록이 이상하면 코드보다 등록 SQL 을 먼저 본다.
 *
 *   SELECT SQL_ID, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = '<콤보ID>';
 *
 * 이름이 어긋나면 makeComboQuery 가 없는 키를 '' 로 채우고 넘어간다. 게다가 Oracle 은 '' 를 NULL
 * 로 보므로 SQL 들의 `@divisionId IS NULL OR ...` 게이트가 통과되어, 조건이 안 걸린 전체 목록이
 * 조용히 돌아온다. 오류가 안 나므로 화면만 보고는 모른다 - 이 화면의 "Team 이 안 좁혀진다" /
 * "82 End Customer 가 전체로 나온다" 사고가 모두 이것이었다.
 *
 * group / user 자리는 BE 가 @sesUserId 로 주입하므로 FE 는 싣지 않는다(SQL 로 확인).
 */
export const SEARCH_COMBO = {
  division: 'MyDivision',
  team: 'TeambyDivision',
  endCustomer40: 'EndCustomerByDivision40',
  endCustomer: 'EndCustomerByDivisionDept',
  salesSite40: 'ScmSitebyEndCustomer40',
  salesSite: 'SiteByEndCustomer',
  active: 'YesOrNo',
} as const;

/**
 * 마지막으로 바뀐 조회조건.
 *
 * AS-IS 는 이벤트 기반이라 나중에 발생한 핸들러가 목록을 덮어쓴다. React 는 상태 기반이므로 그
 * "마지막"을 상태로 들고 같은 규칙을 재현한다 - DMF0004 SalesSiteTrigger 와 같은 장치다.
 *
 * 이게 필요한 이유는 AS-IS 의 40 분기가 Division 변경 경로에만 있기 때문이다.
 *
 *   InitControls L146~165        Team 조회
 *                                End Customer 40 분기 O / Sales Site 는 SiteByEndCustomer 고정
 *   cboDivision 변경 L840~870    Team 재조회 + End Customer 40 분기 O + Sales Site 40 분기 O
 *   clbTeam 변경   L1149~1161    End Customer / Sales Site 를 40 분기 없이 기본 원천으로 재조회
 *   clbEndCustomer 변경 L1126    Sales Site 를 40 분기 없이 기본 원천으로 재조회
 *
 * 즉 40 전용 원천은 "Division 을 방금 바꿨을 때"만 쓰인다. Team 이나 End Customer 를 건드리는
 * 순간 40 이어도 기본 원천으로 넘어가고, 그 상태가 다음 Division 변경까지 유지된다.
 */
export type SearchComboTrigger = 'division' | 'team' | 'endCustomer';

/**
 * End Customer / Sales Site 콤보 원천을 가르는 술어.
 *
 * 40 전용 콤보를 쓸 Division 은 Project 개념이 없는 Division 과 같은 코드라 DIVISION_NO_PROJECT 를
 * 재사용한다. 두 규칙이 우연히 같은 값을 쓰는 게 아니라 같은 Division(Mobility)을 가리킨다.
 */
export const isDivision40 = (divisionId?: string): boolean => divisionId === DIVISION_NO_PROJECT;

/** 40 전용 원천을 쓰는 조건 - Division 40 이면서 방금 바뀐 것이 Division 일 때. */
const uses40Source = (trigger: SearchComboTrigger, divisionId?: string) =>
  trigger === 'division' && isDivision40(divisionId);

/**
 * 미선택은 공란으로 넘긴다. AS-IS GetDMInnerTable 진입부가 'ALL' 을 '' 로 바꾸고, 값이 비면 그
 * 단계를 아예 건너뛴다. 공란 규약은 콤보 파라미터에 한한다 - 스토어 조회조건 필드는 종전대로
 * 'ALL' 을 담아야 드롭다운 전체 체크가 유지되고 proc 요청 규약도 맞는다.
 */
const blank = (value?: string) => (!value || value === 'ALL' ? '' : value);

interface SearchComboSource {
  divisionId: string;
  deptId: string;
  endCustomer: string;
}

/**
 * Team 콤보 1건. 원천이 하나라 트리거를 보지 않는다.
 *
 * AS-IS Data.UserTeamByDivision(group, user, sDivision) = CallBizCommonData('TeambyDivision',
 * divisionID, ...) - InitControls L146 / Division 변경 L840.
 *
 * 등록 SQL 은 @divisionId 이름 토큰을 쓴다. AS-IS 가 division 을 param1 자리로 넘긴다고 해서
 * PARAM1 으로 보내면 안 된다 - 그러면 치환 대상이 없어 조용히 전체 목록이 온다.
 */
export const buildTeamComboParam = ({
  divisionId,
}: Pick<SearchComboSource, 'divisionId'>): ComboParam => ({
  comboId: SEARCH_COMBO.team,
  divisionId,
});

/**
 * End Customer 콤보 1건. 원천만 갈리고 파라미터 구성은 양쪽이 같다.
 *
 *   Division 변경 + 40   Data.Common(EndCustomerByDivision40, false, sDivision, sTeam, ...)  L152/L850
 *   그 외                Data.UserEndCustomerByDivisionDept(group, user, sDivision, sTeam)   L157/L1154
 */
export const buildEndCustomerComboParam = (
  trigger: SearchComboTrigger,
  { divisionId, deptId }: Pick<SearchComboSource, 'divisionId' | 'deptId'>
): ComboParam => ({
  comboId: uses40Source(trigger, divisionId) ? SEARCH_COMBO.endCustomer40 : SEARCH_COMBO.endCustomer,
  divisionId,
  deptId: blank(deptId),
});

/**
 * Sales Site 콤보 1건.
 *
 *   Division 변경 + 40   Data.ScmSitebyEndCustomer40(group, user, sDivision, "")          L856
 *   그 외                Data.UserSiteByEndCustomer(group, user, sDivision, sEndCustomer) L164/L868/L1128/L1159
 *
 * 두 원천의 파라미터 구성이 서로 다르다 (2026-08-27 SQL 실물 확인).
 *
 * ScmSitebyEndCustomer40 은 파라미터를 받지 않는다. SQL 이 DIVISION_ID = '40' / SITE_TYPE = 'SALES'
 * 를 하드코딩하고 권한만 @sesUserId 로 거른다 - 래퍼가 넷째 인자를 넘기지만 등록 SQL 에 그 토큰이
 * 없어 쓰이지 않는다. 그래서 40 에서는 화면 진입 1회 조회로 끝난다.
 *
 * SiteByEndCustomer 는 @divisionId / @endCustomer 이름 토큰을 쓰고, SQL 안에 40 분기를 자체적으로
 * 갖고 있다 - NVL(@divisionId,'~') = '40' 인 UNION 갈래에서는 @endCustomer 를 END_CUSTOMER 가
 * 아니라 B.PROJECT_CODE 와 대조한다. 40 사업부는 End Customer 자리에 Project Code 가 들어간다는
 * 규약이 SQL 에도 그대로 있다.
 *
 * 미확인: SQL 에 @userGrId 도 있다(JV Planner 전용 UNION ALL 갈래). BE 가 주입하는 것은
 * sesUserId / langCd 뿐이라(LookupServiceImpl) FE 가 안 보내면 '' 로 치환된다. 일반 사용자는
 * NVL('','~') <> 'JV Planner' 로 본 갈래가 그대로 도므로 영향이 없지만, JV Planner 그룹 사용자는
 * 추가 갈래가 빠진다. 그 그룹에서 목록이 모자라면 session.groupId 를 userGrId 로 실어야 한다.
 *
 * Sales Site 는 Team 을 반영하지 않는다 - AS-IS 호출부에 팀 자리가 없다. 다만 Team 을 바꾸면
 * endCustomer 가 'ALL' 로 풀리므로 결과적으로 목록은 다시 만들어진다.
 */
export const buildSalesSiteComboParam = (
  trigger: SearchComboTrigger,
  { divisionId, endCustomer }: Pick<SearchComboSource, 'divisionId' | 'endCustomer'>
): ComboParam =>
  uses40Source(trigger, divisionId)
    ? { comboId: SEARCH_COMBO.salesSite40 }
    : { comboId: SEARCH_COMBO.salesSite, divisionId, endCustomer: blank(endCustomer) };

/**
 * 콤보 응답을 드롭다운 옵션으로. CODE 중복은 접는다 - AS-IS 도 GroupBy 로 한 번 접는다.
 *
 * 종전에는 화면이 DIVISION_ID / DEPT_ID 로 응답을 한 번 더 걸렀다. End Customer 와 Sales Site 는
 * 이제 서버가 그 축소를 하므로 클라이언트 필터를 두지 않는다 - 두면 콤보 SQL 이 그 컬럼을 안
 * 내려줄 때 목록이 통째로 빈다.
 */
export const toComboOptions = (rows?: ComboResponse[]) => [
  ...new Map(
    (rows ?? [])
      .map(row => [String(row.CODE ?? ''), String(row.NAME ?? '')] as const)
      .filter(([code]) => code !== '')
      .map(([code, name]) => [code, { label: name || code, value: code }] as const)
  ).values(),
];
