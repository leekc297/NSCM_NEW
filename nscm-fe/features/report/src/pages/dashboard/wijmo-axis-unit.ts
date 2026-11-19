import { Point } from '@mescius/wijmo';
import type { FlexChart, RenderEventArgs } from '@mescius/wijmo.chart';

// axisY.title 은 축을 따라 세로로(회전) 렌더된다. 단위(EA)를 Y축 최상단 라벨(최댓값) '위'에 가로로
//   배치하기 위해, 제목 대신 rendered 마다 현재 최상단 라벨 좌표를 읽어 그 위에 직접 그린다.
//   라벨 좌표는 리사이즈·최댓값 변화로 바뀌므로 매 렌더 동적으로 읽는다(하드코딩 좌표 금지).
export const drawYUnitTop = (chart: FlexChart, unit: string): void => {
  chart.rendered.addHandler((_s, e: RenderEventArgs) => {
    const host = chart.hostElement;
    if (!host) return;
    const labels = host.querySelectorAll<SVGTextElement>('.wj-axis-y text.wj-label');
    // 최상단(최댓값) 라벨 = y 가 가장 작은 것.
    let top: SVGTextElement | undefined;
    labels.forEach(l => {
      if (!top || Number(l.getAttribute('y')) < Number(top.getAttribute('y'))) top = l;
    });
    if (!top) return;
    const x = Number(top.getAttribute('x'));
    const y = Number(top.getAttribute('y'));
    if (!Number.isFinite(x) || !Number.isFinite(y)) return;
    e.engine.drawString(unit, new Point(x, y - 14), undefined, { fill: '#666', fontSize: '11px' });
  });
};
