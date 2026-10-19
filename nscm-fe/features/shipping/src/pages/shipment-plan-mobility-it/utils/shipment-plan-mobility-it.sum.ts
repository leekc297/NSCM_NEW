import type { MainRow } from '../shipment-plan-mobility-it.types';

// 재고성 측정치 — 합계가 아니라 구간 마지막 일자 값을 쓴다(AS-IS Set_SumValues, SSP0015.cs L2930).
const CLOSING_MEASURES = new Set(['INCO_WIP', 'INSP_WIP', 'WH_STOCK', 'BALANCE']);

const isEmpty = (v: unknown): boolean => v === null || v === undefined || v === '';

const toNum = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

// 소수 합산 오차 제거
const round = (n: number): number => Math.round(n * 1e6) / 1e6;

// 일반 측정치 — W_/M_ 는 뒤따르는 D_ 구간의 합(PROD_DATE 는 최대값, LOT 은 0). AS-IS CalculateSum(L5127).
const fillTotal = (row: Record<string, unknown>, bindings: string[], measure: string): void => {
  const out = (n: number): number | string => (measure === 'PROD_DATE' && n === 0 ? '' : round(n));
  let curW = '';
  let curM = '';
  let week = 0;
  let month = 0;
  bindings.forEach(b => {
    if (b.startsWith('D_')) {
      if (isEmpty(row[b])) return;
      const n = toNum(row[b]);
      if (measure === 'PROD_DATE') {
        week = Math.max(week, n);
        month = Math.max(month, n);
      } else if (measure === 'LOT') {
        week = 0;
        month = 0;
      } else {
        week += n;
        month += n;
      }
    } else if (b.startsWith('W_')) {
      if (curW) row[curW] = out(week);
      curW = b;
      week = 0;
    } else if (b.startsWith('M_')) {
      if (curM) row[curM] = out(month);
      curM = b;
      month = 0;
    }
  });
  if (curW) row[curW] = out(week);
  if (curM) row[curM] = out(month);
};

// 재고성 측정치 — W_/M_ 는 해당 구간 마지막 D_ 값.
const fillClosing = (row: Record<string, unknown>, bindings: string[]): void => {
  let curW = '';
  let curM = '';
  let lastD = '';
  bindings.forEach(b => {
    if (b.startsWith('D_')) {
      lastD = b;
    } else if (b.startsWith('W_')) {
      if (curW && lastD) row[curW] = row[lastD];
      curW = b;
    } else if (b.startsWith('M_')) {
      if (curM && lastD) row[curM] = row[lastD];
      curM = b;
    }
  });
  if (lastD) {
    if (curW) row[curW] = row[lastD];
    if (curM) row[curM] = row[lastD];
  }
};

// Main 시트 주/월 합계 계산. bindings 는 SP 컬럼 순서(M_, W_, D_ 반복)여야 한다.
export const applyMainSums = (rows: MainRow[], bindings: string[]): MainRow[] => {
  if (!bindings.some(b => b.startsWith('W_') || b.startsWith('M_'))) return rows;
  return rows.map(src => {
    const row = { ...src } as Record<string, unknown>;
    const measure = typeof row.MEASURE === 'string' ? row.MEASURE.toUpperCase() : '';
    if (CLOSING_MEASURES.has(measure)) fillClosing(row, bindings);
    else fillTotal(row, bindings, measure);
    return row as MainRow;
  });
};
