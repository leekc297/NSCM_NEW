import { ChartType, FlexChart, Position } from '@mescius/wijmo.chart';
import { useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import type { DashboardBaseFilters } from '../demand-as-dashboard.filters';
import { LBL } from '../demand-as-dashboard.labels';
import { PRODUCT_COLORS } from '../demand-as-dashboard.types';
import styles from '../DemandAsDashboard.module.scss';
import { attachAutoSize } from '../wijmo-autosize';
import { drawYUnitTop } from '../wijmo-axis-unit';
import { styleLineLegend } from '../wijmo-legend';
import { applyCompactTooltip } from '../wijmo-tooltip';

import { mapCoverTrend } from './coverMonthChart.map';

interface Props {
  tabId: string;
  filters: DashboardBaseFilters & { nickName: string };
}

// 모델코드 색 — 알려진 코드는 PRODUCT_COLORS, 미지 코드는 아래 팔레트를 순환한다.
const COLOR_BY_NAME = PRODUCT_COLORS as Record<string, string>;
const FALLBACK_PALETTE = ['#1565c0', '#d32f2f', '#2e7d32', '#7b1fa2', '#ef6c00', '#00838f'];

export const CoverMonthChart = ({ tabId, filters }: Props) => {
  const hostRef = useRef<HTMLDivElement>(null);
  const { t } = useTranslation();

  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.COVER_TREND>({
    menuId: MENU_ID,
    sheetName: SHEETS.COVER_TREND,
    tabId,
    filters,
    enabled: !!filters,
  });

  const vm = useMemo(() => mapCoverTrend(data?.o_rc1 ?? []), [data]);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    const chart = new FlexChart(hostRef.current, {
      itemsSource: vm.points,
      bindingX: 'x',
      // 수요예측 추이처럼: LineSymbols(선 + 작은 동그라미 심볼 6px).
      chartType: ChartType.LineSymbols,
      series: vm.series.map(s => ({ name: s.name, binding: s.key, symbolSize: 6 })),
      palette: vm.series.map((s, i) => COLOR_BY_NAME[s.name] ?? FALLBACK_PALETTE[i % FALLBACK_PALETTE.length]),
      legend: { position: Position.Top },
      // 가로선(Y 주눈금 그리드) 숨김 + Y축 선·라벨 표시(수요예측 추이와 동일).
      axisY: { min: 0, max: 40, majorUnit: 10, majorGrid: false, axisLine: true },
    });
    // 단위(개월)를 세로 title 대신 Y축 최상단 라벨 위에 가로로(EA 차트들과 동일).
    drawYUnitTop(chart, '(개월)');
    applyCompactTooltip(chart);
    styleLineLegend(chart);
    return attachAutoSize(chart, hostRef.current);
  }, [vm]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>{t(...LBL.coverTitle)}</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.chartHost} ref={hostRef} />
      </div>
    </div>
  );
};
