import { useEffect, useRef } from 'react';

import { MAPE_AVG, MAPE_BARS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

// MAPE 막대 최대 기준(%) — 막대 길이 환산용.
const MAPE_MAX = 40;

// 막대 하나 — 폭은 JSX inline style 금지(STR-05)라 ref 로 DOM 에 직접 설정(formatItem 과 동일 기법).
const MapeBar = ({ product, value }: { product: string; value: number }) => {
  const fillRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (fillRef.current) {
      fillRef.current.style.width = `${Math.min(100, (value / MAPE_MAX) * 100)}%`;
    }
  }, [value]);
  return (
    <div className={styles.mapeBarRow}>
      <span className={styles.mapeBarLabel}>{product}</span>
      <div className={styles.mapeBarTrack}>
        <div className={styles.mapeBarFill} ref={fillRef} />
      </div>
      <span className={styles.mapeBarPct}>{value}%</span>
    </div>
  );
};

// 예측 정확도(MAPE) — 제품별 가로 막대 + 전체 평균. wijmo FlexChart(Bar)가 컨테이너 높이 반영에
//   계속 실패해(26px 뭉개짐) HTML/CSS 막대로 구현한다. HTML 은 컨테이너 높이에 자동 반응.
export const MapeChart = () => {
  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          예측 정확도<small>(MAPE)</small>
        </span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.mapeWrap}>
          <div className={styles.mapeAvg}>
            <span className={styles.mapeAvgLabel}>전체 평균</span>
            <span className={styles.mapeAvgValue}>{MAPE_AVG}%</span>
          </div>
          <div className={styles.mapeBars}>
            {MAPE_BARS.map(b => (
              <MapeBar key={b.product} product={b.product} value={b.value} />
            ))}
          </div>
        </div>
      </div>
      <div className={styles.gridFoot}>
        <span>※ MAPE (Mean Absolute Percentage Error)</span>
      </div>
    </div>
  );
};
