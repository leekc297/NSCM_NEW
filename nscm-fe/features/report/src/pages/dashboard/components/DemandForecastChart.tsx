import { Point } from '@mescius/wijmo';
import { ChartType, FlexChart, Position, type RenderEventArgs } from '@mescius/wijmo.chart';
import { useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import type { DashboardBaseFilters } from '../demand-as-dashboard.filters';
import { LBL } from '../demand-as-dashboard.labels';
import type { ProductKey } from '../demand-as-dashboard.types';
import { PRODUCTS } from '../demand-as-dashboard.types';
import styles from '../DemandAsDashboard.module.scss';
import { attachAutoSize } from '../wijmo-autosize';
import { drawYUnitTop } from '../wijmo-axis-unit';
import { styleLineLegend } from '../wijmo-legend';
import { applyCompactTooltip } from '../wijmo-tooltip';

import { mapDemandTrend } from './demandForecastChart.map';

interface Props {
  product: ProductKey;
  onProductChange: (p: ProductKey) => void;
  tabId: string;
  filters: DashboardBaseFilters & { nickName: string };
}

// 실적은 파랑 실선, 예측 2종(MKT·AI)은 점선으로 구분(주황·초록).
const ACTUAL_COLOR = '#1565c0';
const MKT_COLOR = '#ef6c00';
const AI_COLOR = '#2e7d32';
// 실적→예측 경계 세로 구분선은 데이터 선과 섞이지 않게 중립 회색으로 둔다.
const BOUNDARY_COLOR = '#90a4ae';

export const DemandForecastChart = ({ product, onProductChange, tabId, filters }: Props) => {
  const hostRef = useRef<HTMLDivElement>(null);
  const { t } = useTranslation();

  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.DEMAND_TREND>({
    menuId: MENU_ID,
    sheetName: SHEETS.DEMAND_TREND,
    tabId,
    filters,
    enabled: !!filters,
  });

  const points = useMemo(() => mapDemandTrend(data?.o_rc1 ?? []), [data]);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    const chart = new FlexChart(hostRef.current, {
      itemsSource: points,
      bindingX: 'x',
      chartType: ChartType.LineSymbols,
      series: [
        { name: t(...LBL.seriesActual), binding: 'actual', symbolSize: 6 },
        { name: t(...LBL.seriesMkt), binding: 'mktFcst', symbolSize: 6, style: { strokeDasharray: '6 4' } },
        { name: t(...LBL.seriesAi), binding: 'aiFcst', symbolSize: 6, style: { strokeDasharray: '2 3' } },
      ],
      palette: [ACTUAL_COLOR, MKT_COLOR, AI_COLOR],
      legend: { position: Position.Top },
      axisX: { labelAngle: 0 },
      // 가로선(Y 주눈금 그리드)은 숨기고 Y축 선·눈금·라벨(0·500·…·2000, EA)은 표시.
      axisY: { min: 0, max: 2000, majorUnit: 500, majorGrid: false, axisLine: true },
    });
    applyCompactTooltip(chart);
    styleLineLegend(chart);
    drawYUnitTop(chart, 'EA');

    // 실적→예측 경계(예측 시리즈가 처음 생기는 지점)에 세로 구분선 + 'Forecast' 라벨.
    const boundary = points.findIndex(d => d.mktFcst !== null || d.aiFcst !== null);
    chart.rendered.addHandler((_s, e: RenderEventArgs) => {
      if (boundary < 0) return;
      const x = chart.axisX.convert(boundary);
      const yTop = chart.axisY.convert(Number(chart.axisY.actualMax));
      const yBottom = chart.axisY.convert(Number(chart.axisY.actualMin));
      if (!Number.isFinite(x) || !Number.isFinite(yTop) || !Number.isFinite(yBottom)) return;
      e.engine.drawLine(x, yTop, x, yBottom, undefined, {
        stroke: BOUNDARY_COLOR,
        strokeWidth: '1',
        strokeDasharray: '4 3',
      });
      e.engine.drawString(t(...LBL.forecastBoundary), new Point(x + 5, yTop + 13), undefined, {
        fill: '#3f51b5',
        fontSize: '11px',
        fontWeight: '700',
      });
    });

    return attachAutoSize(chart, hostRef.current);
  }, [points, t]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          {t(...LBL.demandTitle)}
          <small>({t(...LBL.demandSubtitle)})</small>
        </span>
        <div className={styles.chartTool}>
          <label>{t(...LBL.product)}</label>
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
