import { Point } from '@mescius/wijmo';
import { ChartType, FlexChart, Position, type RenderEventArgs } from '@mescius/wijmo.chart';
import { useEffect, useRef } from 'react';

import type { ProductKey } from '../demand-as-dashboard.mock';
import { DEMAND_FORECAST, PRODUCTS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';
import { attachAutoSize } from '../wijmo-autosize';
import { applyCompactTooltip } from '../wijmo-tooltip';

interface Props {
  product: ProductKey;
  onProductChange: (p: ProductKey) => void;
  refreshKey: string;
}

// 실적/예측 색 — palette·경계 구분선이 공유.
const ACTUAL_COLOR = '#1565c0';
const FORECAST_COLOR = '#90a4ae';

export const DemandForecastChart = ({ product, onProductChange, refreshKey }: Props) => {
  const hostRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    // refreshKey: 검색조건(기준월/BizType/OEM) 변경 시 차트 재생성(="재조회") 트리거.
    void refreshKey;
    const chart = new FlexChart(hostRef.current, {
      itemsSource: DEMAND_FORECAST[product],
      bindingX: 'x',
      // wijmo 기본 series 모양(선 + 동그라미 심볼). 심볼은 기본 10px 라 커서 6px 로 줄임.
      chartType: ChartType.LineSymbols,
      series: [
        { name: '실적 (Actual)', binding: 'actual', symbolSize: 6 },
        { name: '예측 (Forecast)', binding: 'forecast', symbolSize: 6, style: { strokeDasharray: '6 4' } },
      ],
      palette: [ACTUAL_COLOR, FORECAST_COLOR],
      legend: { position: Position.Top },
      axisX: { labelAngle: 0 },
      // 가로선(Y 주눈금 그리드)은 숨기고 Y축 선·눈금·라벨(0·500·…·2000, EA)은 표시.
      axisY: { min: 0, max: 2000, majorUnit: 500, title: 'EA', majorGrid: false, axisLine: true },
    });
    applyCompactTooltip(chart);

    // 실적→예측 경계(forecast 가 처음 생기는 지점)에 세로 구분선 + 'Forecast' 라벨.
    //   카테고리 축이라 축좌표 변환(convert)이 필요해 rendered 이벤트에서 직접 그린다.
    const boundary = DEMAND_FORECAST[product].findIndex(d => d.forecast !== null);
    chart.rendered.addHandler((_s, e: RenderEventArgs) => {
      if (boundary < 0) return;
      const x = chart.axisX.convert(boundary);
      const yTop = chart.axisY.convert(Number(chart.axisY.actualMax));
      const yBottom = chart.axisY.convert(Number(chart.axisY.actualMin));
      if (!Number.isFinite(x) || !Number.isFinite(yTop) || !Number.isFinite(yBottom)) return;
      e.engine.drawLine(x, yTop, x, yBottom, undefined, {
        stroke: FORECAST_COLOR,
        strokeWidth: '1',
        strokeDasharray: '4 3',
      });
      e.engine.drawString('Forecast', new Point(x + 5, yTop + 13), undefined, {
        fill: '#3f51b5',
        fontSize: '11px',
        fontWeight: '700',
      });
    });

    return attachAutoSize(chart, hostRef.current);
  }, [product, refreshKey]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          수요 예측 추이<small>(실적 vs 예측)</small>
        </span>
        <div className={styles.chartTool}>
          <label>제품</label>
          <select value={product} onChange={e => onProductChange(e.target.value as ProductKey)}>
            {PRODUCTS.map(p => (
              <option key={p} value={p}>
                {p}
              </option>
            ))}
          </select>
        </div>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.chartHost} ref={hostRef} />
      </div>
    </div>
  );
};
