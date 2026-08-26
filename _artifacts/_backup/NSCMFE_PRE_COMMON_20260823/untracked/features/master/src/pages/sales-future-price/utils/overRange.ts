// AS-IS DMF0020_SalesFuturePrice.cs L1475~1488 [PJ20200138] "범위를 초과하는 YYYYMMDD"
//
//   string sColList = siMain.GetValue(iRow, ...ColList);        // "W_20260803,W_20260810,..."
//   foreach (col in sColList.Split(','))
//       siMain.SetBGColor2(iRow, iResultCol, iRow, iResultCol, Color.Pink);
//
// COL_LIST 는 SP(DMF0020_GET_SCM_MST_FUTURE_PRICE)가 P_OVER_RANGE='Y'(조회조건 Search over range)
// 일 때만 채운다. 판정은 LOC measure 기준으로 인접 주차 판가와 비교해
// |차이| > 기준가 x LIMIT_VAL(룩업 SALES_PRICE_RANGE_RATE 의 division 별 배율) 인 주차,
// 그리고 매출계획(DM_PLN_SALES_PLAN)이 있는 주차다.
//
// 주의: SP 의 LISTAGG GROUP BY 에 MEASURE 가 없다. 같은 품목(div/project/site/plant/item/
//   currency/domExp/fcstType/incoterms)의 4개 measure 행이 동일한 COL_LIST 를 받으므로
//   행마다 그대로 칠하면 AS-IS 처럼 4행이 통째로 분홍이 된다. FE 에서 별도 전파 로직 불필요.

// SP 가 "대상 없음"을 내려주는 표기 (standalone SP L835/L853 의 '-' 상수 분기).
const EMPTY_MARK = '-';

const parse = (raw: string): Set<string> => {
  const trimmed = raw.trim();
  if (trimmed === '' || trimmed === EMPTY_MARK) return new Set();
  return new Set(
    trimmed
      .split(',')
      .map(s => s.trim())
      .filter(s => s !== '' && s !== EMPTY_MARK)
  );
};

// formatItem 은 셀 하나당 한 번씩 호출된다. 행을 키로 파싱 결과를 캐시해 재파싱을 막는다.
//   (COL_LIST 문자열이 바뀌면 다시 파싱 - 재조회로 같은 행 객체가 갱신되는 경우 대비.)
const cache = new WeakMap<object, { raw: string; cols: Set<string> }>();

const EMPTY: Set<string> = new Set();

/** 행의 COL_LIST 를 파싱한 "범위 초과" 동적 컬럼 binding 집합. */
export const overRangeColsOf = (row: object | undefined | null): Set<string> => {
  if (!row) return EMPTY;
  const raw = (row as { COL_LIST?: unknown }).COL_LIST;
  if (typeof raw !== 'string') return EMPTY;

  const hit = cache.get(row);
  if (hit && hit.raw === raw) return hit.cols;

  const cols = parse(raw);
  cache.set(row, { raw, cols });
  return cols;
};

/** 해당 셀(행 x 동적 컬럼 binding)이 "범위 초과" 대상인지. */
export const isOverRangeCell = (row: object | undefined | null, binding: string): boolean =>
  overRangeColsOf(row).has(binding);
