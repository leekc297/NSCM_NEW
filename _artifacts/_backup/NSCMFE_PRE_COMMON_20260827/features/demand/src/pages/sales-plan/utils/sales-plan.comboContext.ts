import type { ComboParam } from '@foundation/models';

import type { SalesPlanRow } from '../sales-plan.types';

import { toCellStr } from './sales-plan.gridCombos';

export interface SalesPlanComboContext {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  itemId: string;
  // ⭐ Model(ITEM_ID) Insert 행 드롭박스(COM0008/itemByDivision) 필터용 — 2026-07-28 추가.
  scmSiteId: string;
  projectCode: string;
}

// END_CUSTOMER 는 row-dependent 서버 재조회 대상이 아니다 — business-plan/sales-future-price
//   TOBE 검증 baseline 과 동일하게 GRID_CASCADE_FILTERS(constants.ts) 의 클라 cascade
//   (DIVISION_ID + DEPT_ID, filterComboRowsByRow 관대 통과)로 처리한다. 사내 SITE.DEPT_ID 가
//   아직 미이관(전부 NULL)이라 Team 필터는 관대 통과로 배선되는 게 두 baseline 의 확정 설계
//   (__asis-mapping__ §cascade 근거) — 데이터 적재 시 자동 활성.
const ROW_DEPENDENT_BINDINGS = new Set(['SCM_SITE_ID', 'CELL_PROD_SITE_ID']);
// 필수: 콤보 파라미터는 bind 변수가 아니라 텍스트 치환이다 — LookupServiceImpl.retrieveCombo →
//   BaseService.makeComboQuery 가 등록 SQL(SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN)의 @key 를 전달 문자열로
//   그대로 갈아끼운다. 따옴표는 호출자가 붙여야 한다 (프레임워크도 sesUserId/sesLangCd 를
//   "'"+값+"'" 로 감싸 넣고, 미전달 키 기본값이 '' 라 SQL 쪽 placeholder 는 따옴표 없이 = @key 다).
//   미인용 시 숫자 코드인 divisionId 만 우연히 통과하고 itemId/endCustomer/'ALL' 같은 문자값은
//   = ALL 로 치환돼 식별자 오류 → 빈 콤보가 된다. 다른 화면(SalesPlanForm/BusinessPlanForm 등)
//   q() 헬퍼와 동일 규칙.
const quote = (value: string): string => `'${value.trim() !== '' ? value : 'ALL'}'`;

export const buildSalesPlanComboContext = (
  row: SalesPlanRow | undefined,
  defaultDivisionId: string
): SalesPlanComboContext => ({
  divisionId: toCellStr(row?.DIVISION_ID) || defaultDivisionId,
  deptId: toCellStr(row?.DEPT_ID),
  endCustomer: toCellStr(row?.END_CUSTOMER) || toCellStr(row?.END_CUSTOMER40),
  itemId: toCellStr(row?.ITEM_ID),
  scmSiteId: toCellStr(row?.SCM_SITE_ID),
  projectCode: toCellStr(row?.PROJECT_CODE),
});

export const salesPlanComboContextKey = (context: SalesPlanComboContext): string =>
  [
    context.divisionId,
    context.deptId,
    context.endCustomer,
    context.itemId,
    context.scmSiteId,
    context.projectCode,
  ].join('|');

export const isSalesPlanRowDependentCombo = (binding: string): boolean =>
  ROW_DEPENDENT_BINDINGS.has(binding);

export const buildSalesPlanComboFilter = (
  binding: string,
  metadataComboId: string,
  context: SalesPlanComboContext,
  rowExact: boolean
): ComboParam | string => {
  const divisionId = quote(context.divisionId);
  const deptId = quote(rowExact ? context.deptId : 'ALL');
  const endCustomer = quote(rowExact ? context.endCustomer : 'ALL');
  const itemId = quote(rowExact ? context.itemId : 'ALL');

  switch (binding) {
    case 'DEPT_ID':
      // 'DeptId' 는 미등록 comboId — @divisionId 를 무시하고 전 division 목록을 반환해
      //   Team 콤보가 Div 에 영향받지 않던 원인. 'TeambyDivision'(TeamField/검증됨,
      //   DIVISION_ID 컬럼 보유)으로 교체 — cascade(GRID_CASCADE_FILTERS.DEPT_ID) 필터와도 정합.
      return { comboId: 'TeambyDivision', divisionId };
    case 'SCM_SITE_ID':
      return { comboId: 'SiteByEndCustomer', divisionId, deptId, endCustomer };
    case 'CELL_PROD_SITE_ID':
      return { comboId: 'CELL_PROD_SITE_ID', divisionId, itemId };
    case 'FROM_SITE_ID':
    case 'PLANT_SITE_ID':
      return { comboId: 'FromSiteByDivision', divisionId };
    default:
      // [게이트 §7 2026-08-12] CMBO 'Measure' 는 @mnuId 비관대형(`= @mnuId`) — 미전달 시 '' 치환
      //   → 0행(조용한 빈 콤보, measure 계층 표시명 소실). 메뉴 컨텍스트를 명시 전달한다.
      if (metadataComboId === 'Measure') {
        return { comboId: 'Measure', mnuId: quote('DMF0021') };
      }
      return metadataComboId;
  }
};
