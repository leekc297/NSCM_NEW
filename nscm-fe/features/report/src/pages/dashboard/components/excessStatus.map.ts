import { computeExcessEa } from '../demand-as-dashboard.rules';
import type { ExcessRow } from '../demand-as-dashboard.types';

// Excess / 과재고 — P_DMD0001_GET_EXCESS 의 o_rc1(NICK_NAME·STOCK·DEMAND_12M·EXCESS_AMOUNT)을
//   그리드 행 + 합계행 + 위험금액으로. Excess(EA)·합계·위험금액은 FE 산출(handoff §5).
//   EXCESS_AMOUNT 는 SP 가 억원 금액으로 직접 내려준다(단가 아님 — 업무확정 #4/#5 해소).

export type ExcessApiRow = Record<string, string | number | null | undefined>;

export interface ExcessVm {
  rows: ExcessRow[];
  riskAmount: string;
}

const num = (v: string | number | null | undefined): number | null => {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
};
const fmtEa = (n: number): string => n.toLocaleString('en-US');
const fmtAmount = (n: number): string => n.toFixed(1);

// totalLabel: 합계 행 라벨(컴포넌트가 i18n 으로 해석해 주입 — 매퍼는 순수 유지).
export const mapExcess = (apiRows: ExcessApiRow[], totalLabel: string): ExcessVm => {
  let totalExcessEa = 0;
  let totalAmount = 0;

  const rows: ExcessRow[] = apiRows.map(r => {
    const stock = num(r.STOCK) ?? 0;
    const demand12m = num(r.DEMAND_12M) ?? 0;
    const amount = num(r.EXCESS_AMOUNT);
    const ea = computeExcessEa(stock, demand12m);
    totalExcessEa += ea ?? 0;
    totalAmount += amount ?? 0;
    return {
      product: r.NICK_NAME == null ? '' : String(r.NICK_NAME),
      stock: fmtEa(stock),
      demand12m: fmtEa(demand12m),
      excessEa: ea == null ? '–' : fmtEa(ea),
      excessAmount: amount == null ? '–' : fmtAmount(amount),
    };
  });

  rows.push({
    product: totalLabel,
    stock: '–',
    demand12m: '–',
    excessEa: fmtEa(totalExcessEa),
    excessAmount: fmtAmount(totalAmount),
  });

  return { rows, riskAmount: fmtAmount(totalAmount) };
};
