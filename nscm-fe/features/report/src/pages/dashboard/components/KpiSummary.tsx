import type { SvgIconComponent } from '@mui/icons-material';
import CalendarMonthOutlinedIcon from '@mui/icons-material/CalendarMonthOutlined';
import Inventory2OutlinedIcon from '@mui/icons-material/Inventory2Outlined';
import PaymentsOutlinedIcon from '@mui/icons-material/PaymentsOutlined';
import TrackChangesIcon from '@mui/icons-material/TrackChanges';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';

import { clsx } from '@shared/clsx';

import type { KpiAccent, KpiCard } from '../demand-as-dashboard.mock';
import { KPI_CARDS } from '../demand-as-dashboard.mock';
import styles from '../DemandAsDashboard.module.scss';

// 시안(참고 디자인)의 라인 스타일 아이콘에 최대한 근접하게 MUI Outlined 변형으로 맞춘다.
//   관리 대상 품목/Excess 는 시안에서 같은 상자 아이콘(색만 다름)이라 둘 다 Inventory2Outlined 를 쓴다.
//   AS 재고 가치의 시안은 '동전 스택'이라 가장 가까운 Payments(겹친 지폐/카드)로 맞춘다(돼지저금통 Savings 아님).
const ICON_MAP: Record<KpiCard['icon'], SvgIconComponent> = {
  product: Inventory2OutlinedIcon,
  savings: PaymentsOutlinedIcon,
  warning: WarningAmberIcon,
  excess: Inventory2OutlinedIcon,
  calendar: CalendarMonthOutlinedIcon,
  accuracy: TrackChangesIcon,
};

// 카드 아이콘·상단 라벨·증감 텍스트 모두 같은 accent 색을 공유한다(배경 없이 색상만).
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
                <span className={clsx(styles.kpiIcon, ACCENT_TEXT_CLASS[card.accent])}>
                  <Icon sx={{ fontSize: 34 }} />
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
