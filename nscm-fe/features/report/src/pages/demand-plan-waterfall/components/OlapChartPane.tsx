import type { PivotEngine } from '@mescius/wijmo.olap';
import { PivotChart } from '@mescius/wijmo.react.olap';

import { ResultArea } from '@shared/components';

import styles from './OlapChartPane.module.scss';

/**
 * OLAP 차트 팬 — Wijmo 표준 PivotChart (wijmo.olap). 그리드와 **같은 PivotEngine** 을 itemsSource 로 받아
 * 레일에서 바꾼 필드 배치·집계·Subtotal 이 그대로 차트에 반영된다 (사용자 요청 2026-08-27: Chart 공통 버튼).
 *   차트 종류 = wijmo PivotChartType (Column 0 / Bar 1 / Scatter 2 / Line 3 / Area 4 / Pie 5).
 */
export type OlapChartType = 0 | 1 | 2 | 3 | 4 | 5;
const CHART_TYPES: Array<{ value: OlapChartType; label: string }> = [
  { value: 0, label: 'Column' },
  { value: 1, label: 'Bar' },
  { value: 3, label: 'Line' },
  { value: 4, label: 'Area' },
  { value: 5, label: 'Pie' },
  { value: 2, label: 'Scatter' },
];

interface OlapChartPaneProps {
  engine: PivotEngine | null;
  chartType: OlapChartType;
  onChartTypeChange: (type: OlapChartType) => void;
  /** ResultArea 비율(형제 그리드와 합 10) */
  flex?: number;
}

export const OlapChartPane = ({ engine, chartType, onChartTypeChange, flex }: OlapChartPaneProps) => {
  const { t } = useTranslation();
  return (
    <ResultArea
      title={t('', 'Chart')}
      flex={flex}
      rightButtons={
        <select
          className={styles.typeSelect}
          value={chartType}
          onChange={e => onChartTypeChange(Number(e.target.value) as OlapChartType)}
          aria-label='Chart type'
        >
          {CHART_TYPES.map(o => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
      }
    >
      {engine ? (
        <div className={styles.chartHost}>
          <PivotChart
            itemsSource={engine}
            chartType={chartType}
            showTitle={false}
            // 시리즈/포인트 상한 — 대량 피벗에서 차트가 멈추지 않게 (wijmo 기본 100/100)
            maxSeries={20}
            maxPoints={100}
            className={styles.chart}
          />
        </div>
      ) : (
        <div className={styles.empty}>{t('', 'Run a search first — the chart uses the current pivot data.')}</div>
      )}
    </ResultArea>
  );
};
