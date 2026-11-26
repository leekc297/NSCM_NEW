// 예측 정확도(MAPE) — P_DMD0001_GET_MAPE 의 o_rc1(NICK_NAME·MAPE·OVERALL_ACCURACY)을
//   { bars: 제품별 오차율, avg: 전체 정확도 }로. 전체 정확도는 SP 가 내려주는 별개 값(막대 평균 아님).

export type MapeApiRow = Record<string, string | number | null | undefined>;

export interface MapeVm {
  bars: { product: string; value: number }[];
  avg: string;
}

const num = (v: string | number | null | undefined): number => {
  if (v == null || v === '') return 0;
  const n = Number(v);
  return Number.isNaN(n) ? 0 : n;
};

export const mapMape = (rows: MapeApiRow[]): MapeVm => ({
  bars: rows.map(r => ({
    product: r.NICK_NAME == null ? '' : String(r.NICK_NAME),
    value: num(r.MAPE),
  })),
  // 전체 정확도는 행마다 동일하게 실려 온다 — 첫 행에서 취한다. 행이 없으면 빈 문자열.
  avg: rows.length === 0 ? '' : String(num(rows[0].OVERALL_ACCURACY)),
});
