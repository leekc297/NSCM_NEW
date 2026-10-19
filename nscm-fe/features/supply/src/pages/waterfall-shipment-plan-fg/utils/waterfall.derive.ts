import type { DynColMeta } from './waterfall.columns';

// measure 코드 'BALANCE' = 재고성 지표 — W_/M_ 는 합이 아니라 해당 기간 마지막(최신) D_ 값(design 03 §3 R8).
const BALANCE_MEASURE = 'BALANCE';

// 그리드 행 타입 — Grid 가 넘기는 DataGrid itemsSource(Record) 그대로.
type PivotRow = Record<string, string | number>;

interface PeriodMembership {
  // W_ binding → 소속 D_ binding[] (컬럼 정렬 순 = 날짜 오름차순)
  weekOf: Map<string, string[]>;
  // M_ binding → 소속 D_ binding[]
  monthOf: Map<string, string[]>;
}

const toNum = (v: string | number | undefined): number => {
  const n = Number(v ?? 0);
  return Number.isFinite(n) ? n : 0;
};

/**
 * 기간칼럼 소속 관계 — 컬럼 정렬 순서(SORT_ORDER_NO: 한 달 안에서 M_ → W_ → D_ 인터리브, design 03 §2.1)를
 *   좌→우로 훑어 각 D_ 를 직전에 등장한 W_/M_ 에 귀속시킨다. AS-IS Set_SumValues(cs:938)가 컬럼 인접
 *   누적으로 "이전 W_/M_ 칼럼에 기록"하던 것과 동일한 소속 규칙(주/월 헤더가 그 하위 일자 앞에 온다).
 *   ISO(WeeklyISO)처럼 D_ 가 없는 경우 그 W_ 는 소속 D_ 0 → 재합산 대상 아님(서버값 유지).
 */
export const buildPeriodMembership = (metas: DynColMeta[]): PeriodMembership => {
  const weekOf = new Map<string, string[]>();
  const monthOf = new Map<string, string[]>();
  let currentWeek: string | null = null;
  let currentMonth: string | null = null;

  metas.forEach(meta => {
    if (meta.kind === 'M') {
      currentMonth = meta.binding;
      if (!monthOf.has(currentMonth)) monthOf.set(currentMonth, []);
    } else if (meta.kind === 'W') {
      currentWeek = meta.binding;
      if (!weekOf.has(currentWeek)) weekOf.set(currentWeek, []);
    } else {
      // D_ — 직전 W_/M_ 에 귀속
      if (currentWeek) weekOf.get(currentWeek)?.push(meta.binding);
      if (currentMonth) monthOf.get(currentMonth)?.push(meta.binding);
    }
  });

  return { weekOf, monthOf };
};

/**
 * W_/M_ 파생 합산(design 03 §3 R6~R8, §2.2) — AS-IS 는 D_ 만 서버 취득 후 W_/M_ 를 FE 재합산한다.
 *   measure != BALANCE : W_/M_ = 소속 D_ 의 합
 *   measure == BALANCE : W_/M_ = 소속 D_ 중 마지막(최신) 값(합 아님 — 재고성 지표, R8)
 * 서버가 W_/M_ 를 plain SUM 으로 반환하더라도(design 03 §2.2 주의) FE 재합산으로 덮어써 BALANCE 행을
 *   교정한다(비-BALANCE 는 값이 동일해 무해). 소속 D_ 가 없으면(ISO 주 등) 서버값을 유지한다.
 */
export const derivePeriodSums = (rows: PivotRow[], metas: DynColMeta[]): PivotRow[] => {
  if (rows.length === 0 || metas.length === 0) return rows;
  const { weekOf, monthOf } = buildPeriodMembership(metas);
  if (weekOf.size === 0 && monthOf.size === 0) return rows;

  return rows.map(row => {
    const measure = String(row.MEASURE ?? row.measure ?? '');
    const isBalance = measure === BALANCE_MEASURE;
    const next: PivotRow = { ...row };

    const apply = (members: string[], periodBinding: string): void => {
      if (members.length === 0) return; // 소속 D_ 없음 → 서버값 유지
      if (isBalance) {
        next[periodBinding] = toNum(row[members[members.length - 1]]);
      } else {
        let sum = 0;
        members.forEach(dayBinding => {
          sum += toNum(row[dayBinding]);
        });
        next[periodBinding] = sum;
      }
    };

    weekOf.forEach(apply);
    monthOf.forEach(apply);
    return next;
  });
};
