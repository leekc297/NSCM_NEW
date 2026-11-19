import { ChartType, FlexChart, Position } from '@mescius/wijmo.chart';
import { useEffect, useRef } from 'react';

import { COVER_TREND, PRODUCT_COLORS, PRODUCTS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';
import { attachAutoSize } from '../wijmo-autosize';
import { applyCompactTooltip } from '../wijmo-tooltip';

interface Props {
  refreshKey: string;
}

export const CoverMonthChart = ({ refreshKey }: Props) => {
  const hostRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    void refreshKey;
    const chart = new FlexChart(hostRef.current, {
      itemsSource: COVER_TREND,
      bindingX: 'x',
      // 수요예측 추이처럼: LineSymbols(선 + 작은 동그라미 심볼 6px).
      chartType: ChartType.LineSymbols,
      series: PRODUCTS.map(p => ({ name: p, binding: p, symbolSize: 6 })),
      palette: PRODUCTS.map(p => PRODUCT_COLORS[p]),
      legend: { position: Position.Top },
      // 가로선(Y 주눈금 그리드) 숨김 + Y축 선·라벨 표시(수요예측 추이와 동일).
      axisY: { min: 0, max: 40, majorUnit: 10, title: '(개월)', majorGrid: false, axisLine: true },
    });
    applyCompactTooltip(chart);
    return attachAutoSize(chart, hostRef.current);
  }, [refreshKey]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>Cover Month 추이</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.chartHost} ref={hostRef} />
      </div>
    </div>
  );
};
