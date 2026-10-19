import type { MENU_ID, SHEETS } from './distribution-route.constants';

// AS-IS GSCM.SCP.Master.UIL SCP0005_DistributionRoute — 단일 그리드 마스터 편집 화면.
//   설계 근거: .atlas/gscm-design/SCP0005/design/00_checklist.md ~ 03_grid-columns.md.

// 조회조건 (design 02 §1) — 실 콤보 2(TransMode/Valid) + 텍스트+팝업 4(From/To Country·City).
export interface SearchCondition {
  fromCountry: string;
  fromCity: string;
  toCountry: string;
  toCity: string;
  transportMode: string; // clbTransMode(단일 SelectionMode.One) — 'ALL' sentinel
  validYn: string; // cboValidYN — 'ALL' | 'Y' | 'N'
}

// 메인 그리드 행 (design 03 §1 — 39 칼럼 + 서버 보조/원본 필드). 세부 타입은 procedures.d.ts SCP0005.route.
export type DistributionRouteRow = ResponseData<MENU_ID, SHEETS.ROUTE>;
