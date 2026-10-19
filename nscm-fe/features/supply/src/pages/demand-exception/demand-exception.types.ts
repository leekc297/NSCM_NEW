import type { MENU_ID, SHEETS } from './demand-exception.constants';

// SCP0129 DemandException — 단일 그리드(spdMain). PKG_SCP0129 미배포로 procedures.d.ts 에 명시
//   entry 를 등록했으나(SP 미배포 상태의 best-evidence 파라미터명, SCP0127 선례) 실 컬럼 alias 는
//   SP 배포 후 재확정 필요(design 03 §6 확인 필요).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

/**
 * 조회조건(design/02_search-combo.md §1 인벤토리 7논리조건: Division/Site/PlanGroup/ItemId/Stage/
 * Period(From+To)/ValidYn) — 전건 데이터 배선 완료(AS-IS .cs + DB 실측 2026-10-13 확정).
 *
 * 데이터소스: Division=CMBO `Division_SCP` / ValidYn=CMBO `YesOrNo` / PlanGroup·Site·Stage=init 시트
 *   (PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO o_rc1/o_rc2/o_rc7). 상세 constants COMBO·INIT_SET 주석.
 */
export interface SearchParamProps {
  divisionId: string; // 단일(ALL 없음, 첫 항목 자동선택)
  planGroupId: string; // 다중(콤마결합) — init o_rc1, Division 단순일치 cascade
  scmSiteId: string; // 다중(콤마결합) — init o_rc2, Division EE 분기 cascade
  itemId: string;
  stage: string; // 단일 — init o_rc7(ATTRIBUTE3='Y'), Division 단순일치 cascade
  validYn: string; // 단일 — CMBO YesOrNo, allOption
  periodFrom: string;
  periodTo: string;
}
