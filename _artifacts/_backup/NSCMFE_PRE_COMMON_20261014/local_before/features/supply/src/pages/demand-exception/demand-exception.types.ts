import type { MENU_ID, SHEETS } from './demand-exception.constants';

// SCP0129 DemandException — 단일 그리드(spdMain). PKG_SCP0129 미배포로 procedures.d.ts 에 명시
//   entry 를 등록했으나(SP 미배포 상태의 best-evidence 파라미터명, SCP0127 선례) 실 컬럼 alias 는
//   SP 배포 후 재확정 필요(design 03 §6 확인 필요).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

/**
 * 조회조건(design/02_search-combo.md §1 인벤토리 7논리조건: Division/Site/PlanGroup/ItemId/Stage/
 * Period(From+To)/ValidYn).
 *
 * scmSiteId/planGroupId/stage/validYn — design/02_search-combo.md §2-2~2-5 전부 데이터소스
 * 미확정(AS-IS `.cs` 원본·AS-IS MSSQL 둘 다 확보 실패). 필드 UI 골격은 노출하되(SafetyStockForm
 * 선례와 동일 — 비활성 드롭다운) 값은 'ALL'/'' 고정 전송한다. 데이터소스 확정 후 실배선(TODO).
 */
export interface SearchParamProps {
  divisionId: string;
  planGroupId: string; // 확인 필요(comboId 미확정) — 항상 'ALL' 고정 전송(clbPlanGroup 필드 비활성 노출)
  scmSiteId: string; // 확인 필요(comboId 미확정) — 항상 'ALL' 고정 전송(clbSite 필드 비활성 노출)
  itemId: string;
  stage: string; // 확인 필요(comboId 미확정) — 항상 빈 값 전송(cboStage 필드 비활성 노출)
  validYn: string; // 확인 필요(comboId 미확정) — 항상 빈 값 전송(cboValid 필드 비활성 노출)
  periodFrom: string;
  periodTo: string;
}
