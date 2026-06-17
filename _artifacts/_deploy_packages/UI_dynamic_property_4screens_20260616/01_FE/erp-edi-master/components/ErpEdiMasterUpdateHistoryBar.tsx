import styles from '../ErpEdiMaster.module.scss';

interface UpdateHistory {
  sDate: string;
  eDate: string;
  updatedBy: string;
}

interface Props {
  history: UpdateHistory;
}

// AS-IS L2924~2928: lblUpdateHistory.Text = SDATE \r\n EDATE \r\n UPDATED_BY
export const ErpEdiMasterUpdateHistoryBar = ({ history }: Props) => (
  <div className={styles.updateHistoryBar}>
    <div className={styles.historyItem}>
      <span className={styles.historyLabel}>Last Update Start:</span>
      <span className={styles.historyValue}>{history.sDate}</span>
    </div>
    <div className={styles.historyItem}>
      <span className={styles.historyLabel}>Last Update End:</span>
      <span className={styles.historyValue}>{history.eDate}</span>
    </div>
    <div className={styles.historyItem}>
      <span className={styles.historyLabel}>Updated By:</span>
      <span className={styles.historyValue}>{history.updatedBy}</span>
    </div>
  </div>
);
