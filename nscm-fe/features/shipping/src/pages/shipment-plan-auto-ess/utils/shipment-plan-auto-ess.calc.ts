// Simulation 재계산 (AS-IS Simulation() — design 03 §2.3 1:1). 순수 함수 — 그리드/스토어 비의존.
//   SSP0021 은 Main SHIP_PLAN measure 를 직접 편집(design 03 §1.2 편집 유일)하고, 재계산은 Simulation
//   버튼에서만 수행한다(셀 편집 즉시 재계산 없음 — SSP0060 의 CalcPlanQty per-cell 경로는 미해당).
//   전제(서버 wide pivot 실측): 행 = (Division·Site·Item·Measure) 조합, D_yyyymmdd 컬럼에 수량.

export interface CalcRow {
  DIVISION_ID?: unknown;
  FROM_SITE?: unknown;
  ITEM_ID?: unknown;
  MEASURE?: unknown;
  CRUD_TYPE?: unknown;
  [key: string]: unknown;
}

const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 아이템 그룹 키 — "같은 Division/Site/Item" (AS-IS Measure_SearchIdx 그룹 순회 기준, design 03 §2.3)
export const itemGroupKeyOf = (row: CalcRow): string =>
  `${str(row.DIVISION_ID)}\x1F${str(row.FROM_SITE)}\x1F${str(row.ITEM_ID)}`;

const measureRowsOf = (group: CalcRow[], measure: string): CalcRow[] =>
  group.filter(r => str(r.MEASURE) === measure);

/** calendar 커서 기반 D_/W_/M_ 소속 그룹 — SUM 캐스케이드의 주/월 멤버십. */
export interface CalendarGroups {
  dayCols: string[];
  weeks: { binding: string; days: string[] }[];
  months: { binding: string; weeks: string[] }[];
}

interface CalendarMetaRow {
  COLUMN_NAME?: unknown;
  SMALL_CLASS_LABEL_NAME?: unknown;
  SORT_ORDER_NO?: unknown;
}

export const buildCalendarGroups = (calendar: CalendarMetaRow[]): CalendarGroups => {
  const metas = calendar
    .map(r => ({
      binding: str(r.COLUMN_NAME),
      small: str(r.SMALL_CLASS_LABEL_NAME).trim(),
      sort: str(r.SORT_ORDER_NO),
    }))
    .filter(m => /^[DWM]_/.test(m.binding))
    .sort((a, b) => a.sort.localeCompare(b.sort) || a.binding.localeCompare(b.binding));

  const dayCols = metas
    .filter(m => m.binding.startsWith('D_'))
    .map(m => m.binding)
    .sort();
  const weeks = metas
    .filter(m => m.binding.startsWith('W_'))
    .map(w => ({
      binding: w.binding,
      days: metas
        .filter(
          d =>
            d.binding.startsWith('D_') &&
            d.binding.slice(2, 8) === w.binding.slice(2, 8) &&
            d.small === w.small
        )
        .map(d => d.binding)
        .sort(),
    }));
  const months = metas
    .filter(m => m.binding.startsWith('M_'))
    .map(mo => ({
      binding: mo.binding,
      weeks: weeks.filter(w => w.binding.slice(2, 8) === mo.binding.slice(2, 8)).map(w => w.binding),
    }));
  return { dayCols, weeks, months };
};

// SUM 캐스케이드 집계 방식 (design 03 §2.2 — Sum 컬럼):
//   - WH_STOCK/BALANCE = 마지막 값(시점성 재고)
//   - SHIP_REQ/SHIP_PLAN/SHIP_AVAL/INTN_MOVEMENT/CONTAINER/PROD_PLAN = 누적합(유량)
const SIM_LAST_MEASURES = new Set(['WH_STOCK', 'BALANCE']);
const SIM_SUM_MEASURES = new Set([
  'SHIP_REQ',
  'SHIP_PLAN',
  'SHIP_AVAL',
  'INTN_MOVEMENT',
  'CONTAINER',
  'PROD_PLAN',
]);

/**
 * Simulation 재계산 (design 03 §2.3):
 *   1단계: 편집(dirty, CRUD_TYPE='M') 아이템 그룹의 SHIP_PLAN 행 기준 일자별로
 *     WH_STOCK[j] = WH[j-1] + PROD_PLAN[j-1] - SHIP_PLAN[j-1] - INTN_MOVEMENT[j-1] (첫 일자 미재계산),
 *     BALANCE[j] = WH_STOCK[j] - SHIP_PLAN[j],
 *     CONTAINER[j] = containerQty>0 ? (SHIP_PLAN==0 ? 0 : CEIL(SHIP_PLAN/containerQty)) : 0.
 *   2단계: 전 행 대상 주/월 SUM 캐스케이드(위 집계 방식).
 *   Container 단위수량은 realFlag 일 때만 실값(containerQtyOf 가 판정) — AS-IS bRealFlag.
 */
export const simulate = (
  rows: CalcRow[],
  groups: CalendarGroups,
  containerQtyOf: (row: CalcRow) => number,
  dirtyGroupKeys: ReadonlySet<string>
): number => {
  let changed = 0;
  const { dayCols, weeks, months } = groups;

  // 1단계 — dirty 그룹만
  const byGroup = new Map<string, CalcRow[]>();
  rows.forEach(r => {
    const key = itemGroupKeyOf(r);
    if (!byGroup.has(key)) byGroup.set(key, []);
    byGroup.get(key)?.push(r);
  });
  byGroup.forEach((group, key) => {
    if (!dirtyGroupKeys.has(key)) return;
    const planRow = measureRowsOf(group, 'SHIP_PLAN')[0];
    if (!planRow) return;
    const whRow = measureRowsOf(group, 'WH_STOCK')[0];
    const prodRow = measureRowsOf(group, 'PROD_PLAN')[0];
    const moveRow = measureRowsOf(group, 'INTN_MOVEMENT')[0];
    const balanceRow = measureRowsOf(group, 'BALANCE')[0];
    const containerRow = measureRowsOf(group, 'CONTAINER')[0];
    const cQty = containerQtyOf(planRow);

    dayCols.forEach((day, j) => {
      const plan = num(planRow[day]);
      if (j > 0 && whRow && prodRow && moveRow) {
        const prev = dayCols[j - 1];
        const prevPlanRaw = planRow[prev];
        const wh =
          prevPlanRaw === null || prevPlanRaw === undefined || prevPlanRaw === ''
            ? 0
            : num(whRow[prev]) + num(prodRow[prev]) - num(planRow[prev]) - num(moveRow[prev]);
        if (num(whRow[day]) !== wh) {
          whRow[day] = wh;
          changed += 1;
        }
      }
      if (balanceRow) {
        const balance = num(whRow?.[day]) - plan;
        if (num(balanceRow[day]) !== balance) {
          balanceRow[day] = balance;
          changed += 1;
        }
      }
      if (containerRow) {
        const container = cQty > 0 ? (plan === 0 ? 0 : Math.ceil(plan / cQty)) : 0;
        if (num(containerRow[day]) !== container) {
          containerRow[day] = container;
          changed += 1;
        }
      }
    });
  });

  // 2단계 — 전 행 SUM 캐스케이드
  rows.forEach(row => {
    const measure = str(row.MEASURE);
    const isLast = SIM_LAST_MEASURES.has(measure);
    const isSum = SIM_SUM_MEASURES.has(measure);
    if (!isLast && !isSum) return;
    weeks.forEach(w => {
      if (w.days.length === 0) return;
      const value = isLast
        ? num(row[w.days[w.days.length - 1]])
        : w.days.reduce((acc, d) => acc + num(row[d]), 0);
      if (num(row[w.binding]) !== value) {
        row[w.binding] = value;
        changed += 1;
      }
    });
    months.forEach(mo => {
      if (mo.weeks.length === 0) return;
      const value = isLast
        ? num(row[mo.weeks[mo.weeks.length - 1]])
        : mo.weeks.reduce((acc, w) => acc + num(row[w]), 0);
      if (num(row[mo.binding]) !== value) {
        row[mo.binding] = value;
        changed += 1;
      }
    });
  });

  return changed;
};
