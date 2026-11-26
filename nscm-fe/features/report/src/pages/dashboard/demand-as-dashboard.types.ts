// DMD0001 Demand AS Dashboard — 위젯 공유 타입·상수.
//   (실데이터 연동 완료. 각 위젯은 <widget>.map.ts 가 프로시저 o_rc1 을 아래 타입으로 변환한다.)
//   권고 Action·Excess 등 산출 규칙은 demand-as-dashboard.rules 로 분리돼 있다.

import type { ActionTone, StatusDot } from './demand-as-dashboard.rules';

// 권고 Action 톤·상태 신호등 타입은 규칙 모듈이 정본 — 소비 컴포넌트 호환 위해 재노출한다.
export type { ActionTone, StatusDot };

// 관리 대상 모델코드(차트 제품 드롭다운·색 매칭용 샘플 집합).
export const PRODUCTS = ['P30B', 'N2.2A', 'P39', 'F2'] as const;
export type ProductKey = (typeof PRODUCTS)[number];

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

// ----- 제품별 현황 (그리드) -----
export interface ProductStatusRow {
  product: string;
  oem: string;
  bizType: string;
  stock: string; // 현재 재고 (EA)
  cover: string; // Inventory Cover (개월)
  shortageMonth: string; // 예상 부족월
  action: string; // 권고 Action — actionCode 로 산출
  actionTone: ActionTone;
  status: StatusDot;
}

// ----- 리스크 Heat Map -----
export type RiskLevel = 'low' | 'medium' | 'high';
export interface RiskRow {
  product: string;
  m3: RiskLevel;
  m6: RiskLevel;
  m12: RiskLevel;
}

// ----- Excess / 과재고 현황 (그리드 행) -----
export interface ExcessRow {
  product: string;
  stock: string; // 현재 재고 (EA)
  demand12m: string; // 예상 수요 (12M)
  excessEa: string; // Excess (EA)
  excessAmount: string; // Excess 금액 (억원)
}

// Cover Month 색상(멀티라인) — 알려진 모델코드 색. 미지 코드는 차트가 팔레트로 순환한다.
export const PRODUCT_COLORS: Record<ProductKey, string> = {
  P30B: '#2e7d32',
  'N2.2A': '#d32f2f',
  P39: '#1565c0',
  F2: '#7b1fa2',
};
