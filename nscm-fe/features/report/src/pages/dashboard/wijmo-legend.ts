import type { FlexChart } from '@mescius/wijmo.chart';

// 범례를 '선 형식'으로 보이게 한다(점 심볼이 두드러지는 기본형 대신).
//   1) 범례의 점 심볼(ellipse)을 숨겨 선 위주로 읽히게 한다(플롯의 데이터 점은 유지).
//   2) 점선 시리즈(strokeDasharray)는 범례 line 에도 점선을 입혀 '실선 vs 점선'을 구분한다.
//      플롯 dash('6 4' 등)는 폭 10px 범례 line 에선 거의 실선으로 보여, 확실히 읽히는 짧은
//      패턴으로 정규화한다(패턴 종류가 아니라 실선/점선 구분이 목적).
// rendered 마다 범례가 다시 그려지므로 매 렌더 재적용한다.
const LEGEND_DASH = '3 2';

export const styleLineLegend = (chart: FlexChart): void => {
  chart.rendered.addHandler(() => {
    const host = chart.hostElement;
    if (!host) return;
    host.querySelectorAll<SVGElement>('.wj-legend ellipse').forEach(el => {
      el.setAttribute('display', 'none');
    });
    const lines = host.querySelectorAll<SVGLineElement>('.wj-legend line');
    chart.series.forEach((s, i) => {
      const dashed = Boolean((s.style as { strokeDasharray?: string } | undefined)?.strokeDasharray);
      const line = lines[i];
      if (!line) return;
      // 범례 선은 기본 1px 라 같은 색이어도 플롯 선(2px)보다 얇아 톤다운돼 보인다. 두께를 플롯과
      //   맞춰 같은 채도로 읽히게 한다.
      line.setAttribute('stroke-width', '2');
      if (dashed) line.setAttribute('stroke-dasharray', LEGEND_DASH);
      else line.removeAttribute('stroke-dasharray');
    });
  });
};
