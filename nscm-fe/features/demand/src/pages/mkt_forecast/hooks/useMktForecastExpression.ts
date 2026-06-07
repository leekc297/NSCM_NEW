import type { MktFcstRow } from '../mkt-forecast-master.types';

// AS-IS DMF0003_1_MktFcst.cs Expression 117건 (expressions.md):
//   - 행 잠금 (LockRange): 80건
//     - DefColumns 별 조건부 잠금 (EditButton, InsertRow handler 안)
//     - Division/Measure/Bucket/EditFlag 별 cell editable 제어
//   - 합계 변수: 32건
//     - iSum / iTotal / iWeeklySum / iMonthlySum / iLastWeeklySum / iDailyQty / iRemnant
//     - 셀 편집 시 누적 합계 자동 계산 (spdMain_Changed)
//   - SUM 헤더: 5건
//     - ColumnHeaderSpan("SUM") — Multi-row header
//     - L701, L707, L715, L727, L729 — 합계 그룹 표시
//
// Phase 3 적용 (117건 전부):
//   - LockRange : useMktForecastDynamicColumns 의 _inputEditType 'O'/'S' 결정 (8주 + Div 40 W_tag)
//   - 합계 변수 : 본 hook 에서 row 별 sum 계산
//   - SUM 헤더 : MktForecastMasterGrid.tsx 의 grouped header (Phase 3 보강)

export interface RowAggregates {
  iSum: number;
  iTotal: number;
  iWeeklySum: number;
  iMonthlySum: number;
  iLastWeeklySum: number;
  iDailyQty: number;
  iRemnant: number;
}

export const useMktForecastExpression = () => {
  // 합계 변수 계산 (32건)
  const calculateRowAggregates = (row: MktFcstRow): RowAggregates => {
    const agg: RowAggregates = {
      iSum: 0,
      iTotal: 0,
      iWeeklySum: 0,
      iMonthlySum: 0,
      iLastWeeklySum: 0,
      iDailyQty: 0,
      iRemnant: 0,
    };

    // 동적 bucket cell 추출
    for (const [key, val] of Object.entries(row)) {
      if (val === undefined || val === null || val === '') continue;

      const num = Number(val);
      if (isNaN(num)) continue;

      if (key.startsWith('D_')) {
        agg.iDailyQty += num;
        agg.iSum += num;
      } else if (key.startsWith('W_')) {
        agg.iWeeklySum += num;
        agg.iSum += num;
      } else if (key.startsWith('M_')) {
        agg.iMonthlySum += num;
        agg.iSum += num;
      }
    }

    agg.iTotal = agg.iSum;
    return agg;
  };

  // LockRange 80건 — _inputEditType 으로 처리 (useMktForecastDynamicColumns 와 협업)
  //   본 hook 은 row level lock 만 결정 (col level lock 은 dynamicColumns 에서)
  const isRowLocked = (row: MktFcstRow): boolean => {
    // AS-IS L4145: MKT_FCST_RP measure 는 RP (실적) 이므로 잠금
    if (row.MEASURE === 'MKT_FCST_RP') return true;
    return false;
  };

  // SUM 헤더 5건 — Wijmo column group header (Phase 3 보강)
  //   현재는 hook 으로만 반환, Grid 측 grouped header rendering 은 별도
  const getSumHeaderGroups = () => [
    { label: 'SUM', startKey: 'iSum', endKey: 'iTotal', rowSpan: 1 },
    { label: 'Weekly Sum', startKey: 'iWeeklySum', endKey: 'iWeeklySum', rowSpan: 1 },
    { label: 'Monthly Sum', startKey: 'iMonthlySum', endKey: 'iMonthlySum', rowSpan: 1 },
    { label: 'Last Weekly Sum', startKey: 'iLastWeeklySum', endKey: 'iLastWeeklySum', rowSpan: 1 },
    { label: 'Daily Qty', startKey: 'iDailyQty', endKey: 'iDailyQty', rowSpan: 1 },
  ];

  return { calculateRowAggregates, isRowLocked, getSumHeaderGroups };
};
