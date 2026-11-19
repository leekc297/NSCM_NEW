// DMF0020 Sales Future Price — 환율 재계산 (AS-IS GetExchangeRate L2792~2833 1:1 port)
//
// AS-IS 동작 (anti-simplification — 누락 0):
//   LOC 메져 셀 편집 시 같은 measure 그룹의 KRW/USD/(RTF) 형제 행 값을 환율로 재계산해
//   함께 변경(red)·전송한다 (DMF0020_SalesFuturePrice.cs CellsUpdated L2649~2668).
//   SAVE SP DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 은 GROUP BY(key+CURRENCY) HAVING COUNT(*) < 3
//   검증(L237~276)으로 LOC/KRW/USD 3쌍이 함께 와야 통과 → LOC 단독 전송 시 "LOC값 확인 후 재저장" 거부.
//
// 환율 데이터 = SP PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (ExchangeRateModal 과 동일 소스)
//   행: { DIVISION_ID, YYYYMM, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE }

export interface ExchangeRateRow {
  DIVISION_ID?: string;
  YYYYMM?: string;
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
}

// (division, currency, unitCurrency, yyyymm) → EXCHANGE_PRICE 빠른 조회 맵
export type ExchangeRateMap = Map<string, number>;

const erKey = (div: string, currency: string, unitCurrency: string, yyyymm: string): string =>
  `${div.trim()}|${currency}|${unitCurrency}|${yyyymm}`;

export const buildExchangeRateMap = (rows: ExchangeRateRow[]): ExchangeRateMap => {
  const map: ExchangeRateMap = new Map();
  for (const r of rows) {
    const div = String(r.DIVISION_ID ?? '').trim();
    const cur = String(r.CURRENCY ?? '');
    const uc = String(r.UNIT_CURRENCY ?? '');
    const ym = String(r.YYYYMM ?? '');
    if (!div || !cur || !uc || !ym) continue;
    const price =
      typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
    if (!Number.isNaN(price)) map.set(erKey(div, cur, uc, ym), price);
  }
  return map;
};

// ⭐ 환율 재계산 "대상 measure" 판정 (AS-IS 실측 정합 2026-07-08 — 사용자 확인: LOC 입력 시 RTF 미변경):
//   RTF(RTF_SYS_RP)는 통화가 아니라 시스템 생성 measure(이동계획 판가 — GET SP 가 DM_PLN_SALES_PLAN 에서
//   생성, 저장 대상 아님. GET 적재 필터도 COLUMN_NAME <> 'RTF_SYS_RP' 로 제외) → LOC 편집 재계산/저장에서 제외.
//   판정은 하드코딩 대신 환율 데이터(CURRENCY/UNIT_CURRENCY 코드 집합) 기반 — KRW/USD 는 포함, RTF 는 자동 제외.
export const currencyCodesFromRateMap = (map: ExchangeRateMap | undefined | null): Set<string> => {
  const set = new Set<string>();
  if (!map) return set;
  for (const key of map.keys()) {
    const parts = key.split('|'); // div|CURRENCY|UNIT_CURRENCY|yyyymm
    if (parts[1]) set.add(parts[1]);
    if (parts[2]) set.add(parts[2]);
  }
  return set;
};

// 형제 measure 가 환율 재계산 대상인지 — base 통화와 동일하거나 환율 코드 집합에 존재.
//   집합이 비어있으면(환율 데이터 미로드) 기존 동작 보존(전체 대상) — 화면 작동 보장.
export const isExchangeTargetMeasure = (
  currencyCodes: Set<string>,
  measure: string,
  baseCurrency: string
): boolean => {
  if (currencyCodes.size === 0) return true; // fallback — 환율 미로드 시 기존 동작
  return measure === baseCurrency || currencyCodes.has(measure);
};

// AS-IS GetExchangeRate(sDIVISION_ID, sBaseER=Currency, sTargetER=Measure, sYYYYMM, sValue, sTargetVal)
//   1. base == target  → 원래 값 리턴
//   2. CURRENCY=target  AND UNIT_CURRENCY=base → EXCHANGE_PRICE * value
//   3. CURRENCY=base    AND UNIT_CURRENCY=target → round(1/EXCHANGE_PRICE,5) * value
//   4. KRW 경유: CURRENCY='KRW' & UNIT=base, CURRENCY='KRW' & UNIT='USD' → (value*krw)/usd
//   5. 환율 없음 → targetVal==null 이면 '' 아니면 '0' (AS-IS 그대로)
export const getExchangeRate = (
  map: ExchangeRateMap,
  divisionId: string,
  baseCurrency: string,
  targetMeasure: string,
  yyyymm: string,
  value: string,
  targetVal: string | null
): string => {
  if (baseCurrency === targetMeasure) return value;
  const v = Number(value);
  if (Number.isNaN(v)) return targetVal == null ? '' : '0';

  // 2.
  const p2 = map.get(erKey(divisionId, targetMeasure, baseCurrency, yyyymm));
  if (p2 !== undefined) return String(p2 * v);

  // 3.
  const p3 = map.get(erKey(divisionId, baseCurrency, targetMeasure, yyyymm));
  if (p3 !== undefined && p3 !== 0) {
    const inv = Math.round((1.0 / p3) * 1e5) / 1e5;
    return String(inv * v);
  }

  // 4.
  const krw = map.get(erKey(divisionId, 'KRW', baseCurrency, yyyymm));
  if (krw !== undefined) {
    const usd = map.get(erKey(divisionId, 'KRW', 'USD', yyyymm));
    if (usd !== undefined && usd !== 0) return String((v * krw) / usd);
  }

  // 5.
  return targetVal == null ? '' : '0';
};
