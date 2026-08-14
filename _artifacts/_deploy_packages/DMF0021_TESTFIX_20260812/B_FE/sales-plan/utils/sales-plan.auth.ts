interface AuthGroupRow {
  CODE?: unknown;
}

// CMBO 'SalesPlanUserAuthGroup'(P6) 결과가 정본 — session.groupId 는 유령 필드라 참조 금지
//   (UI분석서 v2.1 시트9 C29 / 시트5 C15, 2026-07-15 ghost field 사고 대응).
//   SQL 이 이미 보유그룹×GET_ADMIN_GROUP_MEASURE 교집합 + ADMIN 우선 정렬을 해주므로 1행만 취하면 됨.
export const resolveSalesPlanAuthGroup = (comboRows: AuthGroupRow[] | undefined): string => {
  const first = (comboRows ?? [])[0];
  return typeof first?.CODE === 'string' ? first.CODE.trim() : '';
};
