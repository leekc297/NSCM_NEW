// DMF0045 — Division 40/81*/82 분기 단일 진실원 (AS-IS DMF0045_ShipmentRequest.cs).
//   근거(design 03 §4.3 저장검증 + sales-plan.division 선례):
//     · 81 계열 판정 : startsWith('81') 의무 — '===' 비교 금지 (메모리 규칙 grid-combo-division-param).
//       81/81_UC/81_HM/81_ST/81_HD/81_HG 등 접두 다종.
//     · 40 분기      : Project/PlantSite 비활성 (design 02 §3).
//     · 81 분기      : 조건부 TO_SITE(Plant) 필수 (design 03 §4.3 — startsWith('81')).
import { DIVISION } from '../dmf0045.constants';

export type DivisionKind = 'D40' | 'D81' | 'D82';

export const divisionKindOf = (divisionId: string): DivisionKind => {
  const d = (divisionId ?? '').trim();
  if (d.startsWith('81')) return 'D81';
  if (d === DIVISION.ESS) return 'D82';
  return 'D40';
};

export const isDiv40 = (divisionId: string): boolean => divisionKindOf(divisionId) === 'D40';
export const isDiv81 = (divisionId: string): boolean => divisionKindOf(divisionId) === 'D81';
