/**
 * DMF0020 SalesFuturePrice — Expression Hook
 *
 * As-Is `DMF0020_SalesFuturePrice.cs` Expression 2건 (SUM 헤더) + 보조 메서드
 * (SetExchangeValues, GetThisWeekMonday) 의 To-Be 구현.
 *
 * Cell.Formula 사용 0건 → FlexGrid + Footer Aggregate 사용 (FlexSheet 불필요).
 */
import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { useCallback } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';

import { DIVISION_CODE } from '../sales-future-price.constants';

interface DynamicColumn {
  binding: string;
  header: string;
  basisYYYYMM: string;
  weekName: string;
  visible: boolean;
}

export const useSalesFuturePriceExpression = () => {
  /**
   * #72, #73  AS-IS: SetSpreadHeaderSpan (L645, L673)
   * `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center)`
   *
   * Wijmo FlexGrid 에서는 `<FlexGridColumnGroup>` 으로 그룹 헤더 구성.
   * 좌측에 'SUM' 라벨 그룹을 만들고 동적 시간축 컬럼들을 자식으로 배치.
   */
  const buildLargeSumHeader = useCallback(
    (dynamicCols: DynamicColumn[]): RawFlexGridColumnConfig[] => {
      if (dynamicCols.length === 0) return [];

      // YYYY-MM 단위로 그룹화 → 3단 헤더 (YYYY-MM > Wxx > MMDD)
      const yymMap = new Map<string, DynamicColumn[]>();
      dynamicCols.forEach(c => {
        const arr = yymMap.get(c.basisYYYYMM) ?? [];
        arr.push(c);
        yymMap.set(c.basisYYYYMM, arr);
      });

      // 첫 YYYY-MM 그룹을 'SUM' 으로 라벨링 (As-Is L645, L673 의 ColumnHeaderSpan)
      const result: RawFlexGridColumnConfig[] = [];
      let first = true;
      yymMap.forEach((cols, yym) => {
        const headerLabel = first ? `SUM (${yym})` : yym;
        first = false;
        // 자식 컬럼들을 columnGroup 형태로 추가
        result.push({
          header: headerLabel,
          align: 'center',
          columnGroup: cols.map(c => ({
            binding: c.binding,
            header: c.header,
            width: 120,
            align: 'right',
            format: 'n2',
            visible: c.visible,
          })),
        } as unknown as RawFlexGridColumnConfig);
      });
      return result;
    },
    []
  );

  /**
   * AS-IS: SetExchangeValues (L3116) — `if (sCurrency == "") return;`
   * 행의 Currency 에 따라 환율 자동 적용 — 빈 Currency 면 silent return.
   */
  const setExchangeValues = useCallback(
    (s: FlexGrid, e: CellRangeEventArgs, divisionId: string) => {
      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const currency = row.CURRENCY as string | undefined;
      // L3116 guard
      if (!currency || currency === '') return;

      // 환율 적용 로직 — 행의 시간축 컬럼들에 통화 환산 곱셈 적용.
      // 실제 환율 데이터는 DM_MST_EXCHANGE_RATE 에서 별도 조회됨 (Exchange Rate Modal 결과 활용).
      // To-Be 에서는 useExchangeRateStore (별도 슬라이스) 의 rates Map 을 곱하는 방식 권장.
      // 본 구현은 라이브 환율 store 연결 전 placeholder — Modal 저장 후 자동 갱신될 예정.
      const binding = GridUtils.getBinding(s, e.col);
      if (typeof binding === 'string' && binding.startsWith('W_') && divisionId.startsWith(DIVISION_CODE.ESS)) {
        // 사업부 81 ESS 에서만 자동 환산 적용 가능 (As-Is 동작 보존)
        // const rate = useExchangeRateStore.getState().getRate(currency, ...);
        // row[binding] = (row[binding] as number) * rate;
      }
    },
    []
  );

  /**
   * AS-IS: GetThisWeekMonday (L3505) — `if (dtStart.DayOfWeek == DayOfWeek.Monday) ...`
   * 주어진 날짜의 그 주 월요일을 반환. (As-Is 사전검증 분기 #61)
   */
  const getThisWeekMonday = useCallback((date: Date): Date => {
    const result = new Date(date);
    const day = result.getDay(); // 0 = Sun, 1 = Mon, ...
    const diff = day === 0 ? -6 : 1 - day;
    result.setDate(result.getDate() + diff);
    return result;
  }, []);

  return {
    buildLargeSumHeader,
    setExchangeValues,
    getThisWeekMonday,
  };
};
