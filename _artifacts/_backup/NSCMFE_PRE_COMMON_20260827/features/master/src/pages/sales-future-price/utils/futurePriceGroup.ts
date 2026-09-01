// measure 그룹 식별 키 (SP GROUP BY = 아래 9키 + YYYYMMDD). PIVOT 결과는 행마다 키 컬럼 보유.
//   공용: 저장 payload 구성(siblingsOf) · 저장 후 스크롤 대상 탐색 · 그리드 기존행 실시간 형제 환율 재계산.
export const KEY_COLS = [
  'DIVISION_ID',
  'PROJECT_CODE',
  'SCM_SITE_ID',
  'PLANT_SITE_ID',
  'ITEM_ID',
  'CURRENCY',
  'DOM_EXP',
  'FCST_TYPE',
  'INCOTERMS',
] as const;

// no-base-to-string 회피: unknown 값을 안전하게 string 으로 (null/undefined → '').
export const toStr = (v: unknown): string => (v == null ? '' : String(v as string | number));

export const groupKeyOf = (r: Record<string, unknown>): string =>
  KEY_COLS.map(k => toStr(r[k])).join('|');
