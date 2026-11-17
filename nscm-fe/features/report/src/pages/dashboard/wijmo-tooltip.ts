import type { FlexChart } from '@mescius/wijmo.chart';

// 대시보드 차트 공통 툴팁 — wijmo 기본 툴팁은 글자가 크고 투박해, 작고 단정한
//   1~2줄 포맷으로 대체한다({x}=기준월, {seriesName}=계열, {y}=값).
export const applyCompactTooltip = (chart: FlexChart): void => {
  chart.tooltip.content =
    '<div style="font-size:11px;line-height:1.35;white-space:nowrap">' +
    '{x} · {seriesName}<br><b>{y}</b></div>';
};
