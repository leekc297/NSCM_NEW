// OLAP 데이터 변환 유틸 — OlapPivotGrid 동반 (react-refresh 규칙상 컴포넌트 파일과 분리)

/**
 * wide(PIVOT 커서: 축 컬럼 + D_/W_/M_ 기간 컬럼들) → long(행당 기간 1값) 변환.
 * waterfall SP 커서를 OLAP PivotEngine 계약(long-format)으로 바꾸는 표준 유틸.
 * @param rows        wide 행
 * @param keyBindings 축으로 유지할 컬럼들 (DIVISION_ID/.../MEASURE)
 * @param periodTest  기간 컬럼 판정 (예: /^[DWM]_\d+$/)
 * @param periodField long 행에 추가될 기간 컬럼명 (기본 'PERIOD')
 * @param valueField  long 행에 추가될 값 컬럼명 (기본 'QTY')
 */
export const unpivotWideRows = (
  rows: Record<string, unknown>[],
  keyBindings: string[],
  periodTest: RegExp,
  periodField = 'PERIOD',
  valueField = 'QTY'
): Record<string, unknown>[] => {
  const out: Record<string, unknown>[] = [];
  for (const row of rows) {
    const base: Record<string, unknown> = {};
    for (const k of keyBindings) base[k] = row[k];
    for (const key of Object.keys(row)) {
      if (!periodTest.test(key)) continue;
      const v = row[key];
      if (v == null || v === '') continue;
      out.push({
        ...base,
        [periodField]: key,
        [valueField]: typeof v === 'number' ? v : Number(v) || 0,
      });
    }
  }
  return out;
};
