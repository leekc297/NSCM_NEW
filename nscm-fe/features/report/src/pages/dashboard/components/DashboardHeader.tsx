import InfoOutlined from '@mui/icons-material/InfoOutlined';

import { BIZ_TYPE_OPTIONS, LAST_UPDATED, OEM_OPTIONS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

interface DashboardHeaderProps {
  bizType: string;
  oem: string;
  baseMonth: string;
  onBizTypeChange: (value: string) => void;
  onOemChange: (value: string) => void;
  onBaseMonthChange: (value: string) => void;
}

const BASE_MONTH_OPTIONS = ['2025-05', '2025-04', '2025-03'];

export const DashboardHeader = ({
  bizType,
  oem,
  baseMonth,
  onBizTypeChange,
  onOemChange,
  onBaseMonthChange,
}: DashboardHeaderProps) => {
  return (
    <div className={styles.header}>
      <div className={styles.field}>
        <label>기준월</label>
        <select value={baseMonth} onChange={e => onBaseMonthChange(e.target.value)}>
          {BASE_MONTH_OPTIONS.map(m => (
            <option key={m} value={m}>
              {m}
            </option>
          ))}
        </select>
      </div>
      <div className={styles.field}>
        <label>Biz Type</label>
        <select value={bizType} onChange={e => onBizTypeChange(e.target.value)}>
          {BIZ_TYPE_OPTIONS.map(v => (
            <option key={v} value={v}>
              {v}
            </option>
          ))}
        </select>
      </div>
      <div className={styles.field}>
        <label>OEM</label>
        <select value={oem} onChange={e => onOemChange(e.target.value)}>
          {OEM_OPTIONS.map(v => (
            <option key={v} value={v}>
              {v}
            </option>
          ))}
        </select>
      </div>
      <div className={styles.updated}>
        <InfoOutlined sx={{ fontSize: 14 }} />
        <span>최근 업데이트</span>
        <strong>{LAST_UPDATED}</strong>
      </div>
    </div>
  );
};
