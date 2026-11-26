import { useTranslation } from 'react-i18next';

import { clsx } from '@shared/clsx';
import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import type { DashboardBaseFilters } from '../demand-as-dashboard.filters';
import { LBL } from '../demand-as-dashboard.labels';
import type { RiskLevel } from '../demand-as-dashboard.types';
import styles from '../DemandAsDashboard.module.scss';

import { mapRiskHeatmap } from './riskHeatMap.map';

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

interface RiskHeatMapProps {
  tabId: string;
  filters: DashboardBaseFilters;
}

export const RiskHeatMap = ({ tabId, filters }: RiskHeatMapProps) => {
  const { t } = useTranslation();
  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.RISK_HEATMAP>({
    menuId: MENU_ID,
    sheetName: SHEETS.RISK_HEATMAP,
    tabId,
    filters,
    enabled: !!filters,
  });

  const rows = mapRiskHeatmap(data?.o_rc1 ?? []);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>
          {t(...LBL.riskTitle)}
          <small>({t(...LBL.riskSubtitle)})</small>
        </span>
        <div className={styles.heatLegend}>
          <span>
            <i className={styles.dotGreen} />
            {t(...LBL.riskLow)}
          </span>
          <span>
            <i className={styles.dotOrange} />
            {t(...LBL.riskMedium)}
          </span>
          <span>
            <i className={styles.dotRed} />
            {t(...LBL.riskHigh)}
          </span>
        </div>
      </div>
      <div className={styles.panelBody}>
        <table className={styles.heatTable}>
          <thead>
            <tr>
              <th>{t(...LBL.product)}</th>
              <th>{t(...LBL.m3)}</th>
              <th>{t(...LBL.m6)}</th>
              <th>{t(...LBL.m12)}</th>
            </tr>
          </thead>
          <tbody>
            {rows.map(row => (
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
