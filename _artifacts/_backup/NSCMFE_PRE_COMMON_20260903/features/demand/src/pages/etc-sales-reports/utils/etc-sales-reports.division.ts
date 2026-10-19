// ⭐ DMF0049 — Division 분기 단일 진실원.
//   40(소형 — 편집 완화) / 81계열(자동차 — Substring(0,2)=='81' 판정, '===' 비교 금지) / 82(ESS).
import { DIVISION } from '../etc-sales-reports.constants';

export const isDiv40 = (divisionId: string): boolean => divisionId === DIVISION.MOBILITY;
export const isDiv81 = (divisionId: string): boolean => divisionId.startsWith(DIVISION.AUTOMOTIVE);
export const isDiv82 = (divisionId: string): boolean => divisionId === DIVISION.ESS;
