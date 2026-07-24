// ⭐ DMF0044 — Division 분기 단일 진실원.
//   AS-IS FE 비교는 '40'(편집 완화) / '82'(Textbox 버튼 노출) 2종뿐 — 81 계열 분기 없음
//   (제약매트릭스 §1 L28 실측: "81계열('81%' LIKE 등) 비교는 이 화면 FE 소스에 없음").
import { DIVISION } from '../sales-reports.constants';

export const isDiv40 = (divisionId: string): boolean => divisionId === DIVISION.MOBILITY;
export const isDiv82 = (divisionId: string): boolean => divisionId === DIVISION.ESS;
