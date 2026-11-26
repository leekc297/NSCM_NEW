import { useTranslation } from 'react-i18next';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../demand-as-dashboard.constants';
import { LBL } from '../demand-as-dashboard.labels';
import styles from '../DemandAsDashboard.module.scss';

import { mapForecastInfo } from './forecastInfo.map';

interface ForecastInfoProps {
  tabId: string;
  filters: { yyyymmdd: string };
}

export const ForecastInfo = ({ tabId, filters }: ForecastInfoProps) => {
  const { t } = useTranslation();
  const { data } = useTabProcQuery<MENU_ID, typeof SHEETS.FORECAST_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.FORECAST_INFO,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { logic, info } = mapForecastInfo(data?.o_rc1 ?? []);

  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>{t(...LBL.forecastInfoTitle)}</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.logicWrap}>
          <ul className={styles.logicList}>
            {logic.map(item => (
              <li key={item}>{item}</li>
            ))}
          </ul>
          <div className={styles.infoTable}>
            {info.map(row => (
              <div key={row.label} className={styles.infoRow}>
                <div className={styles.infoKey}>{row.label}</div>
                <div className={styles.infoVal}>{row.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
