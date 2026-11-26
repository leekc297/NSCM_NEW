import type { KpiAccent, KpiCard, KpiDeltaDir } from '../demand-as-dashboard.types';

// KPI 요약 — P_DMD0001_GET_KPI 의 o_rc1(KPI_KEY·KPI_VALUE·UNIT·DELTA_VALUE·DELTA_DIR)을 변환한다.
//   값·단위·증감은 SP. 아이콘·accent(색)는 FE(KPI_KEY 조인, 표시 전용). 라벨 텍스트는 FE 하드코딩이
//   아니라 labelCode(i18n) 로 두고 컴포넌트가 t() 해석한다(사용자 결정 2026-11-23).

export type KpiRow = Record<string, string | number | null | undefined>;

interface KpiMeta {
  labelCode: string;
  labelFallback: string; // t() 2인자 fallback (_ 접두 = 미등록 식별)
  icon: KpiCard['icon'];
  accent: KpiAccent;
}

// 매퍼 산출 — 라벨 텍스트는 빠져 있다(labelCode 로 컴포넌트가 해석). 아이콘/accent 는 표시 메타.
export interface KpiMapped {
  key: string;
  labelCode: string;
  labelFallback: string;
  value: string;
  unit: string;
  icon: KpiCard['icon'];
  accent: KpiAccent;
  deltaValue: string;
  deltaDir: KpiDeltaDir;
}

// KPI_KEY → 표시 메타. 라벨 코드 등록 SQL: .atlas/gscm-design/DMD0001/design/05_register_msg.sql.
const KPI_META: Record<string, KpiMeta> = {
  managed: { labelCode: 'LBL01282', labelFallback: '_관리 대상 품목', icon: 'product', accent: 'blue' },
  asValue: { labelCode: 'LBL01283', labelFallback: '_AS 재고 가치', icon: 'savings', accent: 'green' },
  shortage: { labelCode: 'LBL01284', labelFallback: '_예상 부족 품목', icon: 'warning', accent: 'red' },
  excess: { labelCode: 'LBL01285', labelFallback: '_Excess 품목', icon: 'excess', accent: 'orange' },
  cover: { labelCode: 'LBL01286', labelFallback: '_평균 Inventory Cover', icon: 'calendar', accent: 'teal' },
  mape: { labelCode: 'LBL01287', labelFallback: '_Forecast Accuracy (MAPE)', icon: 'accuracy', accent: 'indigo' },
};

// 카드 공통 '전월대비' 증감 라벨 / 패널 타이틀 — 컴포넌트가 t() 해석한다.
export const DELTA_LABEL_CODE = 'LBL01288';
export const DELTA_LABEL_FALLBACK = '_전월대비';
export const KPI_PANEL_TITLE_CODE = 'LBL01289';
export const KPI_PANEL_TITLE_FALLBACK = '_KPI 요약';

const NO_DELTA = '—';

const str = (v: string | number | null | undefined): string => (v == null ? '' : String(v));

export const mapKpi = (rows: KpiRow[]): KpiMapped[] =>
  rows.reduce<KpiMapped[]>((cards, r) => {
    const key = str(r.KPI_KEY);
    const meta = KPI_META[key];
    if (!meta) return cards;
    const delta = str(r.DELTA_VALUE);
    cards.push({
      key,
      labelCode: meta.labelCode,
      labelFallback: meta.labelFallback,
      value: str(r.KPI_VALUE),
      unit: str(r.UNIT),
      icon: meta.icon,
      accent: meta.accent,
      deltaValue: delta === '' ? NO_DELTA : delta,
      deltaDir: (str(r.DELTA_DIR) || 'none') as KpiDeltaDir,
    });
    return cards;
  }, []);
