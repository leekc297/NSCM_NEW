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

// 편집 전(조회 시점) 통화 기준 묶음 키. originals = EditTracker 가 그 행에 보관한 원본값.
//   기존 행 Currency 를 바꾸면 저장 전까지 현재 통화가 이웃 묶음과 같아질 수 있다(JPY 묶음을 USD 로 바꾸면
//   원래 USD 묶음과 groupKeyOf 가 같아진다). 그 상태에서 현재 값으로 형제를 찾으면 두 묶음이 섞여
//   KRW·USD 가 두 번씩 전송되고 저장 SP 가 통화 중복으로 거부한다. 원래 통화로 묶음을 가른다.
export const originalGroupKeyOf = (
  r: Record<string, unknown>,
  originals?: Record<string, unknown>
): string =>
  KEY_COLS.map(k =>
    toStr(k === 'CURRENCY' && originals && 'CURRENCY' in originals ? originals.CURRENCY : r[k])
  ).join('|');
