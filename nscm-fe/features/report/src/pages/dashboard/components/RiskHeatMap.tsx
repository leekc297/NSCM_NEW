import { clsx } from '@shared/clsx';

import type { RiskLevel } from '../demand-as-dashboard.mock';
import { RISK_ROWS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

const CELL_CLASS: Record<RiskLevel, string> = {
  low: styles.riskLow,
  medium: styles.riskMedium,
  high: styles.riskHigh,
};
const DOT_CLASS: Record<RiskLevel, string> = {
  low: styles.dotGreen,
  medium: styles.dotOrange,
  high: styles.dotRed,
};

const RiskCell = ({ level }: { level: RiskLevel }) => (
  <td className={clsx(styles.riskCell, CELL_CLASS[level])}>
    <span className={clsx(styles.riskDot, DOT_CLASS[level])} />
  </td>
);

export const RiskHeatMap = () => {
  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          리스크 Heat Map<small>(부족 위험도)</small>
        </span>
        <div className={styles.heatLegend}>
          <span>
            <i className={styles.dotGreen} />
            Low
          </span>
          <span>
            <i className={styles.dotOrange} />
            Medium
          </span>
          <span>
            <i className={styles.dotRed} />
            High
          </span>
        </div>
      </div>
      <div className={styles.panelBody}>
        <table className={styles.heatTable}>
          <thead>
            <tr>
              <th>제품</th>
              <th>3개월</th>
              <th>6개월</th>
              <th>12개월</th>
            </tr>
          </thead>
          <tbody>
            {RISK_ROWS.map(row => (
              <tr key={row.product}>
                <td>{row.product}</td>
                <RiskCell level={row.m3} />
                <RiskCell level={row.m6} />
                <RiskCell level={row.m12} />
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
