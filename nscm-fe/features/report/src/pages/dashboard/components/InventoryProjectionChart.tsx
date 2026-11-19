import { Point } from '@mescius/wijmo';
import { ChartType, FlexChart, Position, type RenderEventArgs } from '@mescius/wijmo.chart';
import { useEffect, useRef } from 'react';

import type { ProductKey } from '../demand-as-dashboard.mock';
import { INVENTORY_PROJECTION, PRODUCTS, SHORTAGE_MARK } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';
import { drawYUnitTop } from '../wijmo-axis-unit';
import { attachAutoSize } from '../wijmo-autosize';
import { styleLineLegend } from '../wijmo-legend';
import { applyCompactTooltip } from '../wijmo-tooltip';

interface Props {
  product: ProductKey;
  onProductChange: (p: ProductKey) => void;
  refreshKey: string;
}

// '예상 부족 시작' 세로 선·라벨 색(부족 경고 = 빨강).
const SHORTAGE_COLOR = '#d32f2f';

export const InventoryProjectionChart = ({ product, onProductChange, refreshKey }: Props) => {
  const hostRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!hostRef.current) return undefined;
    void refreshKey;
    const chart = new FlexChart(hostRef.current, {
      itemsSource: INVENTORY_PROJECTION[product],
      bindingX: 'x',
      // series 를 수요예측 추이처럼: LineSymbols(선 + 작은 동그라미 심볼 6px). 투영·안전선은 점선 유지.
      chartType: ChartType.LineSymbols,
      series: [
        { name: '재고 (On Hand)', binding: 'onHand', symbolSize: 6 },
        { name: '예상 수요', binding: 'demand', symbolSize: 6, style: { strokeDasharray: '6 4' } },
        { name: '예상 입고', binding: 'inbound', symbolSize: 6, style: { strokeDasharray: '6 4' } },
        // 안전재고는 기준선 성격이라 심볼 없이 점선만(ChartType.Line). 데이터 점을 찍지 않는다.
        { name: '안전재고', binding: 'safety', chartType: ChartType.Line, style: { strokeDasharray: '2 3' } },
      ],
      palette: ['#1565c0', '#ed6c02', '#2e7d32', '#9e9e9e'],
      legend: { position: Position.Top },
      // 가로선(Y 주눈금 그리드) 숨김 + Y축 선·라벨 표시(수요예측 추이와 동일).
      axisY: { min: 0, majorGrid: false, axisLine: true },
    });
    applyCompactTooltip(chart);
    styleLineLegend(chart);
    drawYUnitTop(chart, 'EA');

    // '예상 부족 시작'을 수요예측 추이의 Forecast 구분선처럼 해당 날짜에 세로 선 + 라벨로 표시.
    //   카테고리 축이라 축좌표 변환(convert) 필요 → rendered 이벤트에서 직접 그린다.
    const mark = SHORTAGE_MARK[product];
    const boundary = mark ? INVENTORY_PROJECTION[product].findIndex(p => p.x === mark.x) : -1;
    chart.rendered.addHandler((_s, e: RenderEventArgs) => {
      if (!mark || boundary < 0) return;
      const x = chart.axisX.convert(boundary);
      const yTop = chart.axisY.convert(Number(chart.axisY.actualMax));
      const yBottom = chart.axisY.convert(Number(chart.axisY.actualMin));
      if (!Number.isFinite(x) || !Number.isFinite(yTop) || !Number.isFinite(yBottom)) return;
      e.engine.drawLine(x, yTop, x, yBottom, undefined, {
        stroke: SHORTAGE_COLOR,
        strokeWidth: '1',
        strokeDasharray: '4 3',
      });
      // 라벨은 '아까'(코너 배지)처럼 연한 빨강 배경 + 테두리 박스 안에 그린다.
      //   부족 지점이 우측이라 박스는 선 왼쪽에 둬 잘림을 피한다.
      const lines = mark.label.split('\n');
      const fontPx = 10;
      const fontStyle = { fontSize: `${fontPx}px`, fontWeight: '700' };
      const padX = 6;
      const padY = 4;
      const lineH = 13;
      // 글자폭 추정(한글 ≈ fontSize, 그 외 ≈ 0.55배). measureString 은 rendered 이벤트에서
      //   불안정(undefined 반환 시 예외로 라벨이 통째로 안 그려짐)해 쓰지 않는다.
      const estWidth = (s: string): number =>
        [...s].reduce((w, ch) => w + (/[가-힣]/.test(ch) ? fontPx : fontPx * 0.55), 0);
      const textW = Math.max(...lines.map(estWidth));
      const boxW = textW + padX * 2;
      const boxH = lines.length * lineH + padY * 2;
      const boxLeft = x - 4 - boxW;
      const boxTop = yTop + 6;
      e.engine.drawRect(boxLeft, boxTop, boxW, boxH, undefined, {
        fill: '#fdf1f1',
        stroke: '#f3c9c9',
        strokeWidth: '1',
        rx: '4',
      });
      // 각 줄을 박스 중심 x 에 text-anchor:middle 로 그려 가로 중앙 정렬(글자폭 추정 불필요).
      const centerX = boxLeft + boxW / 2;
      // 세로 중앙 정렬: Wijmo drawString 의 y 는 글자 baseline 이다(dominant-baseline 미반영).
      //   글자 블록(첫 줄 상단 ~ 마지막 줄 baseline)을 박스 세로 중앙에 두도록 첫 baseline 을 잡는다.
      //   그래야 첫 줄이 박스 상단에 물려 잘리지 않는다.
      const ascent = fontPx * 0.8; // baseline 위 글자 높이 추정(한글/숫자)
      const blockH = (lines.length - 1) * lineH + ascent;
      // 세로 중앙값(topGap=0)에서 topGap 만큼 더 내려 위 여백을 키운다(아래 여백은 그만큼 줄어듦).
      const topGap = 3;
      const firstBaseline = boxTop + (boxH - blockH) / 2 + ascent + topGap;
      lines.forEach((line, li) => {
        e.engine.drawString(
          line,
          new Point(centerX, firstBaseline + li * lineH),
          undefined,
          { ...fontStyle, fill: SHORTAGE_COLOR, textAnchor: 'middle' },
        );
      });
    });

    return attachAutoSize(chart, hostRef.current);
  }, [product, refreshKey]);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          재고 전망<small>(Inventory Projection)</small>
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
