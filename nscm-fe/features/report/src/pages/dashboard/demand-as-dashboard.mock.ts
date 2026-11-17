// DMD0001 Demand AS Dashboard — 목업 더미 데이터.
//   실제 SP/BE 연동 전 단계. 모든 값은 시안(기준월 2025-05) 기준 하드코딩이다.
//   검색조건/제품 드롭다운 변경 시 아래 제품 키(PRODUCTS)로 시리즈를 스왑해 "재조회"를 재현한다.

export const PRODUCTS = ['P30B', 'N2.2A', 'P39', 'F2'] as const;
export type ProductKey = (typeof PRODUCTS)[number];

// ----- 검색조건 바 -----
export const BIZ_TYPE_OPTIONS = ['전체', 'Module', 'Pack', 'Cell'] as const;
export const OEM_OPTIONS = ['전체', 'Volvo', 'GM', 'Ford', 'HKMC'] as const;
export const BASE_MONTH = '2025-05';
export const LAST_UPDATED = '2025-05-12 08:30';

// ----- KPI 요약 (6카드) -----
export type KpiAccent = 'blue' | 'green' | 'red' | 'orange' | 'teal' | 'indigo';
export type KpiDeltaDir = 'up' | 'down' | 'none';

export interface KpiCard {
  key: string;
  label: string;
  value: string;
  unit: string;
  icon: 'product' | 'savings' | 'warning' | 'excess' | 'calendar' | 'accuracy';
  accent: KpiAccent;
  deltaLabel: string; // '전월대비'
  deltaValue: string; // '+2.1억원 (▲7.9%)' / '—'
  deltaDir: KpiDeltaDir;
}

export const KPI_CARDS: KpiCard[] = [
  {
    key: 'managed',
    label: '관리 대상 품목',
    value: '4',
    unit: 'EA',
    icon: 'product',
    accent: 'blue',
    deltaLabel: '전월대비',
    deltaValue: '—',
    deltaDir: 'none',
  },
  {
    key: 'asValue',
    label: 'AS 재고 가치',
    value: '28.6',
    unit: '억원',
    icon: 'savings',
    accent: 'green',
    deltaLabel: '전월대비',
    deltaValue: '+2.1억원 (▲ 7.9%)',
    deltaDir: 'up',
  },
  {
    key: 'shortage',
    label: '예상 부족 품목',
    value: '2',
    unit: 'EA',
    icon: 'warning',
    accent: 'red',
    deltaLabel: '전월대비',
    deltaValue: '+1 EA (▲ 50%)',
    deltaDir: 'up',
  },
  {
    key: 'excess',
    label: 'Excess 품목',
    value: '1',
    unit: 'EA',
    icon: 'excess',
    accent: 'orange',
    deltaLabel: '전월대비',
    deltaValue: '—',
    deltaDir: 'none',
  },
  {
    key: 'cover',
    label: '평균 Inventory Cover',
    value: '14.2',
    unit: '개월',
    icon: 'calendar',
    accent: 'teal',
    deltaLabel: '전월대비',
    deltaValue: '+1.8개월',
    deltaDir: 'up',
  },
  {
    key: 'mape',
    label: 'Forecast Accuracy (MAPE)',
    value: '82',
    unit: '%',
    icon: 'accuracy',
    accent: 'indigo',
    deltaLabel: '전월대비',
    deltaValue: '+4%p',
    deltaDir: 'up',
  },
];

// ----- 제품별 현황 (FlexGrid) -----
export type StatusDot = 'green' | 'orange' | 'red';
export type ActionTone = 'keep' | 'review' | 'produce';

export interface ProductStatusRow {
  product: string;
  oem: string;
  bizType: string;
  stock: string; // 현재 재고 (EA)
  cover: string; // Inventory Cover (개월)
  shortageMonth: string; // 예상 부족월
  action: string; // 권고 Action
  actionTone: ActionTone;
  status: StatusDot;
}

export const PRODUCT_STATUS_ROWS: ProductStatusRow[] = [
  { product: 'P30B', oem: 'Volvo', bizType: 'Module', stock: '1,200', cover: '18.0', shortageMonth: '–', action: '유지', actionTone: 'keep', status: 'green' },
  { product: 'N2.2A', oem: 'GM', bizType: 'Pack', stock: '500', cover: '4.0', shortageMonth: '2026-03', action: '생산 필요', actionTone: 'produce', status: 'red' },
  { product: 'P39', oem: 'Ford', bizType: 'Module', stock: '2,100', cover: '26.0', shortageMonth: '–', action: '감산 검토', actionTone: 'review', status: 'orange' },
  { product: 'F2', oem: 'HKMC', bizType: 'Cell', stock: '300', cover: '3.0', shortageMonth: '2026-01', action: '생산 필요', actionTone: 'produce', status: 'red' },
];

// ----- 리스크 Heat Map -----
export type RiskLevel = 'low' | 'medium' | 'high';
export interface RiskRow {
  product: string;
  m3: RiskLevel;
  m6: RiskLevel;
  m12: RiskLevel;
}
export const RISK_ROWS: RiskRow[] = [
  { product: 'P30B', m3: 'low', m6: 'low', m12: 'medium' },
  { product: 'N2.2A', m3: 'medium', m6: 'high', m12: 'high' },
  { product: 'P39', m3: 'low', m6: 'low', m12: 'low' },
  { product: 'F2', m3: 'high', m6: 'medium', m12: 'high' },
];

// ----- 수요 예측 추이 (실적 vs 예측) : 제품별 -----
export interface DemandPoint {
  x: string;
  actual: number | null;
  forecast: number | null;
}

// 월 라벨 '24-05 ~ '25-11 (실적) + 꼬리 예측 구간.
const DEMAND_X = [
  '\'24-05', '\'24-07', '\'24-09', '\'24-11', '\'25-01', '\'25-03',
  '\'25-05', '\'25-07', '\'25-09', '\'25-11',
];

const demandSeries = (base: number, swing: number): DemandPoint[] =>
  DEMAND_X.map((x, i) => {
    const actual = i <= 6 ? base + Math.round(Math.sin(i) * swing) + (i % 3) * 40 : null;
    const forecast = i >= 6 ? base + Math.round(Math.cos(i) * swing) - 60 : null;
    return { x, actual, forecast };
  });

export const DEMAND_FORECAST: Record<ProductKey, DemandPoint[]> = {
  P30B: demandSeries(1300, 180),
  'N2.2A': demandSeries(620, 90),
  P39: demandSeries(1850, 150),
  F2: demandSeries(360, 70),
};

// ----- 재고 전망 (Inventory Projection) : 제품별 -----
export interface InventoryPoint {
  x: string;
  onHand: number | null;
  demand: number; // 예상 수요
  inbound: number; // 예상 입고
  safety: number; // 안전재고 (수평선)
}
const INV_X = [
  '\'25-05', '\'25-07', '\'25-09', '\'25-11', '\'26-01', '\'26-03', '\'26-05', '\'26-07',
];
const inventorySeries = (start: number, safety: number): InventoryPoint[] =>
  INV_X.map((x, i) => ({
    x,
    onHand: i <= 5 ? Math.max(0, start - i * Math.round(start / 7)) : null,
    demand: Math.max(0, start - i * Math.round(start / 6)),
    inbound: Math.round(safety * 1.1) + (i >= 5 ? (i - 4) * 60 : 0),
    safety,
  }));

export const INVENTORY_PROJECTION: Record<ProductKey, InventoryPoint[]> = {
  P30B: inventorySeries(1500, 400),
  'N2.2A': inventorySeries(1600, 350),
  P39: inventorySeries(2200, 500),
  F2: inventorySeries(900, 250),
};
// 재고 전망 '예상 부족 시작' 주석 (제품별 x 위치/라벨).
export const SHORTAGE_MARK: Record<ProductKey, { x: string; label: string } | null> = {
  P30B: null,
  'N2.2A': { x: '\'26-03', label: '예상 부족 시작\n2026-03' },
  P39: null,
  F2: { x: '\'26-01', label: '예상 부족 시작\n2026-01' },
};

// ----- Cover Month 추이 (멀티라인) -----
export interface CoverPoint {
  x: string;
  P30B: number;
  'N2.2A': number;
  P39: number;
  F2: number;
}
const COVER_X = [
  '\'25-05', '\'25-07', '\'25-09', '\'25-11', '\'26-01', '\'26-03', '\'26-05',
];
export const COVER_TREND: CoverPoint[] = COVER_X.map((x, i) => ({
  x,
  P30B: 24 - i * 0.6,
  'N2.2A': 16 - i * 1.6,
  P39: 27 - i * 0.4,
  F2: 7 - i * 0.5,
}));

// Cover Month 색상 (멀티라인 범례) — 시안과 동일 색 배정.
export const PRODUCT_COLORS: Record<ProductKey, string> = {
  P30B: '#2e7d32',
  'N2.2A': '#d32f2f',
  P39: '#1565c0',
  F2: '#7b1fa2',
};

// ----- Excess / 과재고 현황 -----
export interface ExcessRow {
  product: string;
  stock: string; // 현재 재고 (EA)
  demand12m: string; // 예상 수요 (12M)
  excessEa: string; // Excess (EA)
  excessAmount: string; // Excess 금액 (억원)
}
export const EXCESS_ROWS: ExcessRow[] = [
  { product: 'P39', stock: '2,100', demand12m: '800', excessEa: '1,300', excessAmount: '10.4' },
  { product: 'P30B', stock: '1,200', demand12m: '1,100', excessEa: '100', excessAmount: '0.8' },
  { product: 'N2.2A', stock: '500', demand12m: '1,200', excessEa: '–', excessAmount: '–' },
  { product: 'F2', stock: '300', demand12m: '1,000', excessEa: '–', excessAmount: '–' },
  { product: '합계', stock: '–', demand12m: '–', excessEa: '1,400', excessAmount: '11.2' },
];
export const EXCESS_RISK_AMOUNT = '11.2'; // 예상 폐기 위험 금액 (12M) 억원

// ----- 예측 정확도 (MAPE) -----
export interface MapeBar {
  product: string;
  value: number; // % (오차율)
}
export const MAPE_BARS: MapeBar[] = [
  { product: 'P30B', value: 18 },
  { product: 'N2.2A', value: 24 },
  { product: 'P39', value: 15 },
  { product: 'F2', value: 32 },
];
export const MAPE_AVG = '82'; // 전체 평균 정확도 %

// ----- Forecast Logic & Info -----
export const FORECAST_LOGIC: string[] = [
  '최근 24개월 판매 이력 기반 예측',
  '계절성(Seasonality) 반영',
  'Warranty / 리콜 제외',
  'Service Campaign / 리콜 반영',
  '월 Forecast (24개월)',
  '매주 자동 업데이트 (필요시)',
];
export const FORECAST_INFO: { label: string; value: string }[] = [
  { label: '모델', value: 'ETS + Seasonality' },
  { label: '예측 단위', value: '월 (Monthly)' },
  { label: '예측 기간', value: '24개월' },
  { label: '최근 모델 학습', value: '2025-05-05' },
  { label: '다음 업데이트', value: '2025-05-19 (예정)' },
];

export const FOOTER_NOTE =
  '※ 본 데이터는 참고용이며 실제 의사결정은 담당자 확인 후 진행 바랍니다.';
