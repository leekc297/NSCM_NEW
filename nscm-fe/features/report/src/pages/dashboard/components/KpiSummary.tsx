import type { SvgIconComponent } from '@mui/icons-material';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import Inventory2Icon from '@mui/icons-material/Inventory2';
import LayersIcon from '@mui/icons-material/Layers';
import SavingsIcon from '@mui/icons-material/Savings';
import TrackChangesIcon from '@mui/icons-material/TrackChanges';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';

import { clsx } from '@shared/clsx';

import type { KpiAccent, KpiCard } from '../demand-as-dashboard.mock';
import { KPI_CARDS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

const ICON_MAP: Record<KpiCard['icon'], SvgIconComponent> = {
  product: Inventory2Icon,
  savings: SavingsIcon,
  warning: WarningAmberIcon,
  excess: LayersIcon,
  calendar: CalendarMonthIcon,
  accuracy: TrackChangesIcon,
};

const ACCENT_CLASS: Record<KpiAccent, string> = {
  blue: styles.accentBlue,
  green: styles.accentGreen,
  red: styles.accentRed,
  orange: styles.accentOrange,
  teal: styles.accentTeal,
  indigo: styles.accentIndigo,
};

// 상단 라벨·증감 텍스트는 같은 카드 아이콘(accent) 색과 동일하게 맞춘다(배경 없이 색상만).
const ACCENT_TEXT_CLASS: Record<KpiAccent, string> = {
  blue: styles.accentTextBlue,
  green: styles.accentTextGreen,
  red: styles.accentTextRed,
  orange: styles.accentTextOrange,
  teal: styles.accentTextTeal,
  indigo: styles.accentTextIndigo,
};

export const KpiSummary = () => {
  return (
    <div className={clsx(styles.panel)}>
      <div className={styles.panelHead}>
        <span className={styles.panelTitle}>KPI 요약</span>
      </div>
      <div className={styles.kpiRow}>
        {KPI_CARDS.map(card => {
          const Icon = ICON_MAP[card.icon];
          return (
            <div key={card.key} className={styles.kpiCard}>
              <span className={clsx(styles.kpiLabel, ACCENT_TEXT_CLASS[card.accent])}>
                {card.label}
              </span>
              <div className={styles.kpiMain}>
                <span className={clsx(styles.kpiIcon, ACCENT_CLASS[card.accent])}>
                  <Icon sx={{ fontSize: 28 }} />
                </span>
                <span className={styles.kpiValue}>
                  <b>{card.value}</b>
                  <span>{card.unit}</span>
                </span>
              </div>
              <div className={styles.kpiDelta}>
                <span className={styles.kpiDeltaLabel}>{card.deltaLabel}</span>
                <em className={ACCENT_TEXT_CLASS[card.accent]}>{card.deltaValue}</em>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};
