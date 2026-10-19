import type { ComboParam } from '@foundation/models';

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
  /** 필터. 파라미터 없이 전량을 한 번 받는다. DIVISION_ID 컬럼을 안 내려주므로 좁히지 않는다. */
  division: 'FilterMyDivision',
  /** 필터. 파라미터 없이 전량을 한 번 받고 division 좁히기는 화면이 한다. */
  team: 'FilterTeambyDivision',
  endCustomer40: 'EndCustomerByDivision40',
  endCustomer: 'EndCustomerByDivisionDept',
  salesSite40: 'ScmSitebyEndCustomer40',
  salesSite: 'SiteByEndCustomer',
  active: 'YesOrNo',
} as const;

/** 40 전용 원천을 쓰는 Division. Project 개념이 없는 Division 과 같은 값이라 상수를 재사용한다. */
export const isDivision40 = (divisionId?: string): boolean => divisionId === DIVISION_NO_PROJECT;

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
 * End Customer 콤보 1건. 원천만 갈리고 파라미터 구성은 양쪽이 같다.
 *
 *   Division 변경 + 40   Data.Common(EndCustomerByDivision40, false, sDivision, sTeam, ...)  L152/L850
 *   그 외                Data.UserEndCustomerByDivisionDept(group, user, sDivision, sTeam)   L157/L1154
 */
export const buildEndCustomerComboParam = ({
  divisionId,
  deptId,
}: Pick<SearchComboSource, 'divisionId' | 'deptId'>): ComboParam => ({
  comboId: isDivision40(divisionId) ? SEARCH_COMBO.endCustomer40 : SEARCH_COMBO.endCustomer,
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
/**
 * Sales Site 에 넘길 End Customer 값. AS-IS CString.GetCheckedListValue 재현이다.
 *
 * 미선택('ALL')은 그 시점 End Customer 목록의 전체 CODE 로 펼쳐진다. Team 을 바꾸면 End
 * Customer 가 팀으로 좁혀지고(clbTeam_SelectedIndexChanged :1154) 그 좁혀진 집합이 Sales Site
 * 를 좁히므로, 이 펼치기가 곧 Team 을 Sales Site 에 반영하는 경로다.
 *
 * 필수: 미선택을 공란으로 떨어뜨리면 안 된다. 그러면 Team 을 골라도 Sales Site 가 그대로다.
 * 목록이 비었을 때만 공란이 되며, 그때는 AS-IS 도 빈 테이블에서 공란을 돌려준다.
 */
export const resolveEndCustomerParam = (
  selected: string,
  options: readonly { value: string }[]
): string => {
  const codes = (selected ?? '')
    .split(',')
    .map(v => v.trim())
    .filter(v => v !== '' && v !== 'ALL');
  return codes.length > 0 ? codes.join(',') : options.map(option => option.value).join(',');
};

export const buildSalesSiteComboParam = ({
  divisionId,
  endCustomer,
}: Pick<SearchComboSource, 'divisionId' | 'endCustomer'>): ComboParam =>
  isDivision40(divisionId)
    ? // 40 은 Project 자리를 항상 비운다. AS-IS Data.ScmSitebyEndCustomer40(group, user,
      //   sDivision, "") 의 네 번째 인자가 그 자리다 - End Customer 를 골라도 채우지 않는다.
      { comboId: SEARCH_COMBO.salesSite40, divisionId, endCustomer: '' }
    : { comboId: SEARCH_COMBO.salesSite, divisionId, endCustomer: blank(endCustomer) };
