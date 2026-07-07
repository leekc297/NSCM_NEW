// DMF0020 편집가능 Division 판정 (메타/LOOKUP 구동 — 하드코딩 division 리터럴 제거).
//   원천 = CMBO 'SalesFuturePriceEditableDivision'(lookup DM_EDITABLE_DIVISION_ALLOW, SEGMENT1='DMF0020').
//   현행 업무규칙: 82(Power Tool)만 편집 가능. 40/81/81_UC/81_HM/81_ST/81_HD/81_HG = 편집제약.
//   정확일치 멤버십 — 미등재 division(81 계열 전부)은 자동 제약. (DMF0003 mkt-fcst.division.isEditableDivision 동등,
//   master 피처는 demand cross-import 금지로 로컬 사본.)
export const isEditableDivision = (
  divisionId: string,
  editableSet: ReadonlySet<string>
): boolean => editableSet.has((divisionId ?? '').trim());
