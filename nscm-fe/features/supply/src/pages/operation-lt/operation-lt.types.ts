import type { MENU_ID, SHEETS } from './operation-lt.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. TO-BE PKG_SCP0037 미배포 상태라 Base index fallback 으로
//   해석된다(자매 SCP0020 tact-time 동일 방식). 편집판정/파생에 쓰는 값 컬럼은 GET SP 반환에 포함됨(design 03 §4-2).
export type OperationLTRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리:
//   division(다중) / ltOperation(다중) / plantSite(다중) / material(itemId 텍스트) / siteItemValid(단일+ALL).
export interface SearchCondition {
  divisionIds: string[];
  ltOperationIds: string[];
  plantSiteIds: string[];
  itemId: string;
  validYn: string; // 'ALL' | 'Y' | 'N' — 기본 ALL (ALL -> SP NULL)
}

// 조회영역 Plant Site 콤보 원본 행 (PlantByDivisionOperNonOsp1_SCP_ALL ∪ PlantByDivisionOperOsp21_SCP_ALL).
//   design 02 §2-3 / 03 §3-2 — OSP_YN/OPERATION_GROUP/DIVISION_ID 로 cascade·셀콤보 좁힘.
export interface PlantSiteSource {
  CODE: string;
  NAME: string;
  OSP_YN: string;
  OPERATION_GROUP: string;
  DIVISION_ID: string;
}
