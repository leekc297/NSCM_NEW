/**
 * DMF0020 SalesFuturePrice — wide-format → long-format 변환 (클라이언트 unpivot)
 *
 * 사용자 결정 (2026-05-28): PivotGrid Tab2 의 데이터 소스로 메인 SP `P_DMF0020_GET_SCM_MST_FUTURE_PRICE`
 * 의 wide-format 결과를 그대로 사용 + FE 측에서 long-format 으로 unpivot 후 PivotEngine 에 입력.
 * 사유: 메인 SP 1,891 라인 재작성 회피 (anti-simplification 룰 부합).
 *
 * 룰 27 §C — PivotGrid React 패턴 의 입력 데이터 형식.
 */
import { GROUP_KEY_COLUMNS } from '../sales-future-price.constants';
import type { SalesFuturePriceDynamicColumn, SalesFuturePricePivotRow, SalesFuturePriceRow } from '../sales-future-price.types';

const PERIOD_KEY_PREFIX = ['W_', 'M_'] as const;

/** binding (`W_20260511`) 으로부터 YYYY-MM 추출. M_202605 도 호환. */
const extractYearMonth = (binding: string): string => {
  // W_20260511 → 2026-05
  if (binding.startsWith('W_')) {
    const yyyymmdd = binding.slice(2);
    return `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}`;
  }
  // M_202605 → 2026-05
  if (binding.startsWith('M_')) {
    const yyyymm = binding.slice(2);
    return `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}`;
  }
  return '';
};

/** binding 으로부터 표시 라벨 (`2026-05-11`) 추출 */
const extractPeriodLabel = (binding: string): string => {
  if (binding.startsWith('W_')) {
    const yyyymmdd = binding.slice(2);
    return `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}-${yyyymmdd.slice(6, 8)}`;
  }
  if (binding.startsWith('M_')) {
    const yyyymm = binding.slice(2);
    return `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}`;
  }
  return binding;
};

/**
 * Wide rows + 동적 컬럼 정의 → Long-format rows (PivotEngine 입력용).
 *
 * 입력 예 (wide):
 *   { DIVISION_ID:'81', ITEM_ID:'X', CURRENCY:'USD', MEASURE:'Q', W_20260511: 100, W_20260518: 120 }
 * 출력 예 (long):
 *   { DIVISION_ID:'81', ITEM_ID:'X', CURRENCY:'USD', MEASURE:'Q',
 *     PERIOD:'W_20260511', PERIOD_LABEL:'2026-05-11', YEAR_MONTH:'2026-05', PRICE:100 }
 *   { DIVISION_ID:'81', ITEM_ID:'X', CURRENCY:'USD', MEASURE:'Q',
 *     PERIOD:'W_20260518', PERIOD_LABEL:'2026-05-18', YEAR_MONTH:'2026-05', PRICE:120 }
 *
 * NULL/0 가격은 PivotGrid 분석에서 무의미하므로 제외 (성능 + 가독성).
 */
export const wideToLong = (
  rows: SalesFuturePriceRow[],
  dynamicColumns: SalesFuturePriceDynamicColumn[]
): SalesFuturePricePivotRow[] => {
  if (!rows.length || !dynamicColumns.length) return [];

  const visiblePeriodBindings = dynamicColumns.filter(c => c.visible).map(c => c.binding);
  if (visiblePeriodBindings.length === 0) return [];

  const result: SalesFuturePricePivotRow[] = [];

  rows.forEach(row => {
    visiblePeriodBindings.forEach(binding => {
      const raw = row[binding as `W_${string}`];
      const price = typeof raw === 'number' ? raw : parseFloat(raw as string);
      if (!price || isNaN(price)) return; // NULL / 0 제외

      result.push({
        DIVISION_ID: row.DIVISION_ID ?? '',
        TEAM_INCHARGE: row.TEAM_INCHARGE ?? '',
        END_CUSTOMER: row.END_CUSTOMER ?? '',
        SCM_SITE_ID: row.SCM_SITE_ID ?? '',
        ITEM_ID: row.ITEM_ID ?? '',
        INCOTERMS: row.INCOTERMS ?? '',
        FCST_TYPE: row.FCST_TYPE ?? '',
        DOM_EXP: row.DOM_EXP ?? '',
        CURRENCY: row.CURRENCY ?? '',
        MEASURE: row.MEASURE ?? '',
        PERIOD: binding,
        PERIOD_LABEL: extractPeriodLabel(binding),
        YEAR_MONTH: extractYearMonth(binding),
        PRICE: price,
      });
    });
  });

  return result;
};

/** binding 이 시간축 동적 컬럼인지 검사 (`W_` 또는 `M_` prefix). */
export const isPeriodBinding = (binding: string | undefined): boolean => {
  if (!binding) return false;
  return PERIOD_KEY_PREFIX.some(p => binding.startsWith(p));
};

/** group key 컬럼만 추출 — 그룹 동시 선택 (AS-IS Raw_CellClick) */
export const buildGroupKey = (row: SalesFuturePriceRow): string => {
  return GROUP_KEY_COLUMNS.map(c => String(row[c] ?? '')).join('|');
};
