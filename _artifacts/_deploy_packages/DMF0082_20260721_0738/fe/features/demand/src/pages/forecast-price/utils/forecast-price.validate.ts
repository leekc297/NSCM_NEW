import { toNumber } from '../components/ForecastPriceGridUtils';

/**
 * 저장 전 검증 — AS-IS fnValidation + SaveData 검증(.cs L2052~2075) 1:1.
 * 반환 = 통과 시 null / 실패 시 MSG 상수 키 (호출측이 setAlert).
 */
export type SaveValidationError =
  | 'CURRENCY_REQUIRED' // Currency 값은 필수 입력 (PRICE 행 — MSG00429 {0}=Currency)
  | 'QTY_PRICE_REQUIRED' // 추가 행에 수량/가격 미입력 (MSG00670)
  | 'DUP_NEW_ROW'; // 신규 행 중복 조합 (MSG00260)

const PRICE_MEASURES = new Set(['LOC', 'KRW', 'USD']);

export const validateSaveRows = (
  gridRows: WijmoRowItem[],
  editableDayColumns: string[]
): SaveValidationError | null => {
  const insertRows = gridRows.filter(r => r['CRUD_TYPE'] === 'I');

  // V1 — PRICE 행(LOC 계열) Insert 는 CURRENCY 필수 (AS-IS bInputCheck2).
  for (const row of insertRows) {
    const measure = String(row['MEASURE'] ?? '');
    if (PRICE_MEASURES.has(measure) && !String(row['CURRENCY'] ?? '').trim()) {
      return 'CURRENCY_REQUIRED';
    }
  }

  // V2 — Insert 행은 하루 이상 수량/가격 입력 (AS-IS MSG00449).
  for (const row of insertRows) {
    const hasValue = editableDayColumns.some(d => toNumber(row[d]) !== 0);
    if (!hasValue) return 'QTY_PRICE_REQUIRED';
  }

  // V3 — 신규 행 중복 조합 (AS-IS MSG00260: Division/Project/Item/Measure 등 키 중복).
  //   projectKey: 81=PROJECT_CODE / 40=END_CUSTOMER (save keyOf 규약 정렬 — PROJECT_CODE 만 다른 81 행 오탐 방지)
  //   PLANT_SITE_ID: 81 키 차원 (40 은 동일값/공란 — 키 세분화 방향이라 40 무회귀)
  const seen = new Set<string>();
  for (const row of insertRows) {
    const key = [
      row['DIVISION_ID'],
      String(row['PROJECT_CODE'] ?? '') || String(row['END_CUSTOMER'] ?? ''),
      row['END_CUSTOMER'],
      row['SCM_SITE_ID'],
      row['ITEM_ID'],
      row['DOM_EXP'],
      row['FCST_TYPE'],
      row['INCOTERMS'],
      row['MEASURE'],
      row['CELL_PROD_SITE_ID'],
      row['PLANT_SITE_ID'],
    ]
      .map(v => String(v ?? ''))
      .join('|');
    if (seen.has(key)) return 'DUP_NEW_ROW';
    seen.add(key);
  }

  return null;
};
