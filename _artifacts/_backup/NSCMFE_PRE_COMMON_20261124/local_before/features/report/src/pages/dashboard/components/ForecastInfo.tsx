import { FORECAST_INFO, FORECAST_LOGIC } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

export const ForecastInfo = () => {
  return (
    <div className={styles.panel}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>Forecast Logic &amp; Info</span>
      </div>
      <div className={styles.panelBody}>
        <div className={styles.logicWrap}>
          <ul className={styles.logicList}>
            {FORECAST_LOGIC.map(item => (
              <li key={item}>{item}</li>
            ))}
          </ul>
          <div className={styles.infoTable}>
            {FORECAST_INFO.map(info => (
              <div key={info.label} className={styles.infoRow}>
                <div className={styles.infoKey}>{info.label}</div>
                <div className={styles.infoVal}>{info.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
