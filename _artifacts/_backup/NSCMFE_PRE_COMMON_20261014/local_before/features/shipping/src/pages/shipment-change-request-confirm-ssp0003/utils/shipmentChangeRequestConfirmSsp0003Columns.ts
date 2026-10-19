import type { RawFlexGridColumnConfig } from '@foundation/models';

// admin(SCM_MST_SHEET_COLUMNS) 등록본 -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   SSP0003 는 컬럼메타가 DB 에 실측 배포돼 있다(design 03 §0: "Shipment Change Request Confirm" 22 /
//   "Shipment Change Request Confirm Detail" 54, 총 76행). admin 메타가 authoritative — constants
//   하드코딩 컬럼 fallback 을 두지 않는다(76행 수기 전사 = anti-simplification 위반, hook #130. DB 가 SSOT).
//   미등록/fetch 실패 시 빈 배열(그리드 공백).
//
//   메인(siMain): 단일 헤더(ONE_DEPTH) — 클래스 라벨 제거(스트레이 라벨 다단화 방지).
//   서브(siSub): 2단 헤더(Confirmed/Change 또는 Plan/Confirm, SMALL_CLASS_LABEL_NAME) — hook #93 48px.
//     _sChangeType='P' 분기(그룹라벨 오버라이드 + ERP_SO_NO hide)는 SubGrid 컴포넌트에서 재현(design 03 §2).
export const buildColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  twoTierHeader: boolean
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  if (twoTierHeader) return adminCols;
  // 단일 헤더 — 클래스 라벨 제거(스트레이 라벨로 인한 다단화 방지).
  return adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
};
