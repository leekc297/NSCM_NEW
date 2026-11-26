import type { RiskLevel, RiskRow } from '../demand-as-dashboard.types';

// 리스크 Heat Map — P_DMD0001_GET_RISK_HEATMAP 의 o_rc1(NICK_NAME·M3·M6·M12)을 RiskRow[]로.
//   구간은 SP 가 3/6/12 개월로 내려준다. 등급값은 low|medium|high.

export type RiskHeatmapRow = Record<string, string | number | null | undefined>;

const LEVELS: readonly RiskLevel[] = ['low', 'medium', 'high'];

const toLevel = (v: string | number | null | undefined): RiskLevel =>
  LEVELS.includes(v as RiskLevel) ? (v as RiskLevel) : 'low';

export const mapRiskHeatmap = (rows: RiskHeatmapRow[]): RiskRow[] =>
  rows.map(r => ({
    product: r.NICK_NAME == null ? '' : String(r.NICK_NAME),
    m3: toLevel(r.M3),
    m6: toLevel(r.M6),
    m12: toLevel(r.M12),
  }));
