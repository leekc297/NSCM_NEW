import type { RawFlexGridColumnConfig } from '@foundation/models';

// admin(SCM_MST_SHEET_COLUMNS) 등록본 -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   SSP0201 은 컬럼메타가 DB 에 실측 배포돼 있다(design 03 §0: "Shipment Change Request" 65 /
//   "Change Request" 58, 총 123행). 따라서 admin 메타가 authoritative — constants 하드코딩 컬럼
//   fallback 을 두지 않는다(123행 수기 전사 = anti-simplification 위반 위험. DB 가 SSOT).
//   미등록/fetch 실패 시 빈 배열(그리드 공백) — 05_register.sql 로 셀콤보 B 6종 PARAM 보강.
//
//   메인: 단일 헤더(ONE_DEPTH) — 클래스 라벨 제거(model-pic/outsourcing-capacity 동일 이슈 회피).
//   서브: 2단 헤더(Confirmed/Change, SMALL_CLASS_LABEL_NAME) 유지 — hook #93 48px 다단헤더.
export const buildColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  twoTierHeader: boolean
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  if (twoTierHeader) return adminCols;
  // 단일 헤더 — 클래스 라벨 제거(스트레이 라벨로 인한 다단화 방지).
  return adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
};
