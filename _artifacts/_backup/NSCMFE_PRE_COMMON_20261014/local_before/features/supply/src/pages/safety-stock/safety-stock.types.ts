import type { MENU_ID, SHEETS } from './safety-stock.constants';

// SCP0128 SafetyStock — 단일 그리드(spdMain). PKG_SCP0128 미배포로 procedures.d.ts SSOT 에
//   아직 등록 없음 — Base index-signature 로 loose(WijmoRowItem) 해석된다(SCP0002 LineMaster 동일
//   선례, memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 결함 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

/**
 * 조회조건 (design/02_search-combo.md §1 인벤토리 8개 논리조건 전건: Division/Plan Group/Site/
 * Type/Stage/Period/Item Id+팝업/Valid).
 *
 * scmSiteId/valueType/stage — goal.md v2 ④-1/④-3 로 데이터소스(SCP0128_GET_SEARCH_INFO)는
 * 확정됐으나 `PKG_SCP0128` 미배포로 실데이터 배선은 불가하다. 필드 UI 골격은 노출하되(SafetyStockForm
 * 비활성 드롭다운) 값은 항상 'ALL'/''/''(필터 없음)로 고정 전송한다 — SP 배포 후 실배선 시 이
 * 주석과 SafetyStockForm 의 TODO 를 함께 갱신할 것.
 */
export interface SearchParamProps {
  divisionId: string;
  planGroupId: string; // 다중선택 — 콤마결합 문자열
  scmSiteId: string; // 확인 필요(SQL_ID 미확정) — 항상 'ALL' 고정 전송(clbSite 필드 미노출)
  itemId: string;
  stage: string; // 확인 필요(공급원 미상) — 필드 미노출, 항상 빈 값 전송
  validYn: string;
  valueType: string; // 확인 필요(공급원 미상) — 필드 미노출, 항상 빈 값 전송
  periodFrom: string;
  periodTo: string;
}
