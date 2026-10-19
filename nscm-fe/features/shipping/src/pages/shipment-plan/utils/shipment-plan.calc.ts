// CalcPlanQty (AS-IS .cs L6800~7054) — Main PSI 편집 시 실시간 재계산 5산식 (design 03 §3-A 1:1).
//   순수 함수 — 그리드/스토어 비의존(단위 테스트 대상, 03 §5-4).
//   전제(서버 wide pivot 실측): 행 = (Division·Site·Item·Measure·ToSite…) 조합, D_yyyymmdd 컬럼에 수량.
//   주의: TOT_SHIP_REQ/TOT_SHIP_AVAL/TOT_INTN_MOVEMENT/TOT_PROD_PLAN 4종은 AS-IS dead code —
//   계산하지 않는다(03 §1.1a — 임의 합계 채움 금지).

export interface CalcRow {
  DIVISION_ID?: unknown;
  FROM_SITE?: unknown;
  ITEM_ID?: unknown;
  PRODUCT_LEVEL1?: unknown;
  MEASURE?: unknown;
  BOH_TYPE?: unknown;
  BOH_QTY?: unknown;
  LOT_YN?: unknown;
  [key: string]: unknown;
}

const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 아이템 그룹 키 — "같은 Division/Site/Item" (AS-IS L6800 그룹 순회 기준)
export const itemGroupKeyOf = (row: CalcRow): string =>
  `${str(row.DIVISION_ID)}\x1F${str(row.FROM_SITE)}\x1F${str(row.ITEM_ID)}`;

const measureRowsOf = (group: CalcRow[], measure: string): CalcRow[] =>
  group.filter(r => str(r.MEASURE) === measure);

// 그룹의 일자별 SHIP_PLAN(= Σ SHIP_PLAN_DETAIL) 합
const sumDetail = (group: CalcRow[], day: string): number =>
  measureRowsOf(group, 'SHIP_PLAN_DETAIL').reduce((acc, r) => acc + num(r[day]), 0);

/**
 * 한 아이템 그룹 재계산 — 편집된 일자(fromIdx)부터 이후 일자로 정방향 전파(이전 날짜 재계산 없음).
 *   dayCols: D_yyyymmdd binding 오름차순 정렬 목록.
 *   반환: 변경된 (row, day) 목록 — 호출부(EditTracker 마킹/그리드 반영)가 소비.
 */
export const recalcItemGroup = (
  group: CalcRow[],
  dayCols: readonly string[],
  fromIdx: number
): { row: CalcRow; day: string; value: number }[] => {
  const changes: { row: CalcRow; day: string; value: number }[] = [];
  const put = (row: CalcRow | undefined, day: string, value: number) => {
    if (!row) return;
    if (num(row[day]) !== value) {
      row[day] = value;
      changes.push({ row, day, value });
    }
  };

  const shipPlanRow = measureRowsOf(group, 'SHIP_PLAN')[0];
  const shipAvalRow = measureRowsOf(group, 'SHIP_AVAL')[0];
  const gapRow = measureRowsOf(group, 'SHIP_AVAL_GAP')[0];
  const containerRow = measureRowsOf(group, 'CONTAINER')[0];
  const whRow = measureRowsOf(group, 'WH_STOCK')[0];
  const balanceRow = measureRowsOf(group, 'BALANCE')[0];
  const prodRow = measureRowsOf(group, 'PROD_PLAN')[0];
  const intnRow = measureRowsOf(group, 'INTN_MOVEMENT')[0];

  // 최초일 WH_STOCK 시드 = BOH_TYPE=='BOH' 행의 BOH_QTY (03 §3-A-1)
  const bohRow = group.find(r => str(r.BOH_TYPE) === 'BOH');
  const dBoh = num(bohRow?.BOH_QTY);

  // Lot Size — LOT_YN 컬럼의 숫자 재해석(AS-IS L6997 이중 의미, 03 §6-7). 'N'이면 CONTAINER=0.
  const lotYn = str(containerRow?.LOT_YN ?? group[0]?.LOT_YN);
  const lotSize = num(lotYn);

  const start = Math.max(fromIdx, 0);
  for (let i = start; i < dayCols.length; i += 1) {
    const day = dayCols[i];
    const prevDay = i > 0 ? dayCols[i - 1] : undefined;

    // 1) SHIP_PLAN = Σ SHIP_PLAN_DETAIL (당일)
    const shipPlan = sumDetail(group, day);
    put(shipPlanRow, day, shipPlan);

    // 2) SHIP_AVAL_GAP = 전일GAP + (SHIP_AVAL - SHIP_PLAN)
    if (gapRow) {
      const prevGap = prevDay ? num(gapRow[prevDay]) : 0;
      put(gapRow, day, prevGap + (num(shipAvalRow?.[day]) - shipPlan));
    }

    // 3) CONTAINER = LOT_YN=='N' ? 0 : CEIL(SHIP_PLAN_DETAIL 합 / LotSize)
    if (containerRow) {
      const container = lotYn === 'N' || lotSize <= 0 ? 0 : Math.ceil(shipPlan / lotSize);
      put(containerRow, day, container);
    }

    // 4) WH_STOCK = 전일WH + 전일PROD - 전일INTN - 전일SHIP_PLAN (최초일 = BOH 시드)
    if (whRow) {
      const wh = !prevDay
        ? dBoh
        : num(whRow[prevDay]) +
          num(prodRow?.[prevDay]) -
          num(intnRow?.[prevDay]) -
          num(shipPlanRow?.[prevDay] ?? sumDetail(group, prevDay));
      put(whRow, day, wh);

      // 5) BALANCE = WH_STOCK(전일 기준 산식값) - 당일 SHIP_PLAN
      put(balanceRow, day, wh - shipPlan);
    }
  }
  return changes;
};

// PRODUCT_LEVEL1 그룹 누적 대상 (5종만 — 나머지 4 TOT 는 dead code 재현으로 미계산)
const TOT_SOURCE: Record<string, string> = {
  TOT_SHIP_PLAN: 'SHIP_PLAN',
  TOT_SHIP_AVAL_GAP: 'SHIP_AVAL_GAP',
  TOT_CONTAINER: 'CONTAINER',
  TOT_WH_STOCK: 'WH_STOCK',
  TOT_BALANCE: 'BALANCE',
};

/** PRODUCT_LEVEL1 그룹 단위 TOT_* 5종 누적 (03 §3-A-4). fromIdx 이후 일자만. */
export const recalcTotals = (
  rows: CalcRow[],
  dayCols: readonly string[],
  fromIdx: number
): { row: CalcRow; day: string; value: number }[] => {
  const changes: { row: CalcRow; day: string; value: number }[] = [];
  const byLevel = new Map<string, CalcRow[]>();
  rows.forEach(r => {
    const key = `${str(r.DIVISION_ID)}\x1F${str(r.FROM_SITE)}\x1F${str(r.PRODUCT_LEVEL1)}`;
    if (!byLevel.has(key)) byLevel.set(key, []);
    byLevel.get(key)?.push(r);
  });

  byLevel.forEach(group => {
    Object.entries(TOT_SOURCE).forEach(([totMeasure, srcMeasure]) => {
      const totRow = group.find(r => str(r.MEASURE) === totMeasure);
      if (!totRow) return;
      const srcRows = group.filter(r => str(r.MEASURE) === srcMeasure);
      for (let i = Math.max(fromIdx, 0); i < dayCols.length; i += 1) {
        const day = dayCols[i];
        const total = srcRows.reduce((acc, r) => acc + num(r[day]), 0);
        if (num(totRow[day]) !== total) {
          totRow[day] = total;
          changes.push({ row: totRow, day, value: total });
        }
      }
    });
  });
  return changes;
};

/**
 * 편집 이벤트 1건 처리 — 편집 행의 아이템 그룹 재계산 + TOT 누적.
 *   editedDay 가 dayCols 에 없으면(W_/M_ Sum 컬럼 등) 재계산하지 않는다(항상 잠금 — 03 §2.3).
 */
export const calcPlanQty = (
  rows: CalcRow[],
  dayCols: readonly string[],
  editedRow: CalcRow,
  editedDay: string
): { row: CalcRow; day: string; value: number }[] => {
  const fromIdx = dayCols.indexOf(editedDay);
  if (fromIdx < 0) return [];
  const groupKey = itemGroupKeyOf(editedRow);
  const group = rows.filter(r => itemGroupKeyOf(r) === groupKey);
  const changes = recalcItemGroup(group, dayCols, fromIdx);
  return changes.concat(recalcTotals(rows, dayCols, fromIdx));
};

// ====================================================================================
// Simulation (AS-IS Simulation() L7463~7886 — iter-2 에서 라인 정독으로 03 §6-9 해소)
// ====================================================================================

/** calendar 커서 기반 D_/W_/M_ 소속 그룹 — SUM 캐스케이드의 주/월 멤버십. */
export interface CalendarGroups {
  dayCols: string[];
  // W_ 컬럼과 그 주에 속한 D_ 컬럼들 — (yyyymm + SMALL_CLASS_LABEL_NAME) 일치로 귀속
  weeks: { binding: string; days: string[] }[];
  // M_ 컬럼과 그 월에 속한 W_ 컬럼들 — yyyymm 일치로 귀속
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

// SUM 캐스케이드 집계 방식 (AS-IS L7674~7886 라인 정독 실측):
//   - WH_STOCK/BALANCE = 마지막 값(시점성 재고 — 주 SUM=그 주 마지막 일자값, 월 SUM=마지막 주값)
//   - SHIP_REQ/SHIP_PLAN/INTN_MOVEMENT/CONTAINER/PROD_PLAN = 누적합(유량 — 주=Σ일, 월=Σ주)
const SIM_LAST_MEASURES = new Set(['WH_STOCK', 'BALANCE']);
const SIM_SUM_MEASURES = new Set([
  'SHIP_REQ',
  'SHIP_PLAN',
  'INTN_MOVEMENT',
  'CONTAINER',
  'PROD_PLAN',
]);

/**
 * Simulation 재계산 (AS-IS L7490~7605 1단계 + L7610~7887 2단계).
 *   1단계: 편집된(dirty) 아이템 그룹의 SHIP_PLAN 행 기준 — 일자별로
 *     WH_STOCK = 전일WH + 전일PROD - 전일PLAN - 전일MOVE (첫 일자는 미재계산, 전일 PLAN 이 빈 셀이면 0 —
 *       AS-IS L7557 IsNullOrEmpty 가드 그대로),
 *     BALANCE = 당일WH - 당일PLAN,
 *     CONTAINER = containerQty>0 ? (PLAN==0 ? 0 : CEIL(PLAN/containerQty)) : 0.
 *   2단계: 전 행 대상 주/월 SUM 캐스케이드(위 집계 방식 표).
 *   AS-IS 의 대상 판정(SHIP_PLAN 행 MEASURE 셀 ForeColor==Red)은 TO-BE 에서 "dirty(CRUD_TYPE='M')
 *   행이 있는 아이템 그룹"으로 재현한다(Red 마킹 = EditByChange 편집 흔적 — __asis-mapping__ 참조).
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

  // 2단계 — 전 행 SUM 캐스케이드 (AS-IS 2단계는 Red 여부 무관 전 행 순회)
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
