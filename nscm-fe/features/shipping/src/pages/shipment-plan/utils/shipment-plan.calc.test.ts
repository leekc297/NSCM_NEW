import { describe, expect, it } from 'vitest';

import {
  buildCalendarGroups,
  calcPlanQty,
  recalcItemGroup,
  simulate,
  type CalcRow,
} from './shipment-plan.calc';

// design 03 §3-A 산식 단위검증 (구현검증 기준 §5-4 — 전일 carry-forward + 최초일 BOH 시드 포함)
const DAYS = ['D_20260901', 'D_20260902', 'D_20260903'];

const row = (measure: string, days: Record<string, number>, extra?: Partial<CalcRow>): CalcRow => ({
  DIVISION_ID: '81',
  FROM_SITE: 'P1',
  ITEM_ID: 'ITEM1',
  PRODUCT_LEVEL1: 'PL1',
  MEASURE: measure,
  ...days,
  ...extra,
});

const buildGroup = () => {
  const detail = row('SHIP_PLAN_DETAIL', { D_20260901: 10, D_20260902: 20, D_20260903: 0 }, {
    TO_SITE: 'S1',
    LOT_YN: '5',
  });
  const shipPlan = row('SHIP_PLAN', { D_20260901: 0, D_20260902: 0, D_20260903: 0 });
  const shipAval = row('SHIP_AVAL', { D_20260901: 15, D_20260902: 15, D_20260903: 15 });
  const gap = row('SHIP_AVAL_GAP', { D_20260901: 0, D_20260902: 0, D_20260903: 0 });
  const container = row('CONTAINER', { D_20260901: 0, D_20260902: 0, D_20260903: 0 }, { LOT_YN: '5' });
  const prod = row('PROD_PLAN', { D_20260901: 30, D_20260902: 40, D_20260903: 0 });
  const intn = row('INTN_MOVEMENT', { D_20260901: 5, D_20260902: 0, D_20260903: 0 });
  const wh = row('WH_STOCK', { D_20260901: 0, D_20260902: 0, D_20260903: 0 });
  const balance = row('BALANCE', { D_20260901: 0, D_20260902: 0, D_20260903: 0 });
  const boh = row('SHIP_REQ', { D_20260901: 0 }, { BOH_TYPE: 'BOH', BOH_QTY: 100 });
  return { detail, shipPlan, shipAval, gap, container, prod, intn, wh, balance, boh };
};

describe('recalcItemGroup (CalcPlanQty 5산식)', () => {
  it('SHIP_PLAN = Σ SHIP_PLAN_DETAIL, CONTAINER = CEIL(합/LotSize)', () => {
    const g = buildGroup();
    const group = Object.values(g);
    recalcItemGroup(group, DAYS, 0);
    expect(g.shipPlan.D_20260901).toBe(10);
    expect(g.shipPlan.D_20260902).toBe(20);
    expect(g.container.D_20260901).toBe(2); // CEIL(10/5)
    expect(g.container.D_20260902).toBe(4); // CEIL(20/5)
  });

  it('LOT_YN=N 이면 CONTAINER=0', () => {
    const g = buildGroup();
    g.container.LOT_YN = 'N';
    g.detail.LOT_YN = 'N';
    recalcItemGroup(Object.values(g), DAYS, 0);
    expect(g.container.D_20260901).toBe(0);
  });

  it('WH_STOCK 최초일 = BOH 시드, 이후 = 전일WH+전일PROD-전일INTN-전일SHIP_PLAN', () => {
    const g = buildGroup();
    recalcItemGroup(Object.values(g), DAYS, 0);
    expect(g.wh.D_20260901).toBe(100); // BOH 시드
    expect(g.wh.D_20260902).toBe(100 + 30 - 5 - 10); // = 115
    expect(g.wh.D_20260903).toBe(115 + 40 - 0 - 20); // = 135
  });

  it('BALANCE = WH_STOCK - 당일 SHIP_PLAN', () => {
    const g = buildGroup();
    recalcItemGroup(Object.values(g), DAYS, 0);
    expect(g.balance.D_20260901).toBe(100 - 10);
    expect(g.balance.D_20260902).toBe(115 - 20);
  });

  it('SHIP_AVAL_GAP = 전일GAP + (SHIP_AVAL - SHIP_PLAN) 누적', () => {
    const g = buildGroup();
    recalcItemGroup(Object.values(g), DAYS, 0);
    expect(g.gap.D_20260901).toBe(15 - 10); // 5
    expect(g.gap.D_20260902).toBe(5 + (15 - 20)); // 0
    expect(g.gap.D_20260903).toBe(0 + (15 - 0)); // 15
  });

  it('편집 일자 이전 날짜는 재계산하지 않는다(정방향 전파)', () => {
    const g = buildGroup();
    g.shipPlan.D_20260901 = 999; // 이전 날짜에 의도적으로 잘못된 값
    recalcItemGroup(Object.values(g), DAYS, 1); // 2일차부터 전파
    expect(g.shipPlan.D_20260901).toBe(999); // 그대로
    expect(g.shipPlan.D_20260902).toBe(20);
  });
});

describe('calcPlanQty (TOT 누적 포함)', () => {
  it('TOT_SHIP_PLAN 은 PRODUCT_LEVEL1 그룹 누적, dead 4종(TOT_SHIP_REQ 등)은 계산하지 않는다', () => {
    const g = buildGroup();
    const totShipPlan = row('TOT_SHIP_PLAN', { D_20260901: 0, D_20260902: 0, D_20260903: 0 });
    const totShipReq = row('TOT_SHIP_REQ', { D_20260901: 7, D_20260902: 7, D_20260903: 7 });
    const rows = [...Object.values(g), totShipPlan, totShipReq];
    calcPlanQty(rows, DAYS, g.detail, 'D_20260901');
    expect(totShipPlan.D_20260901).toBe(10);
    // dead code 재현 — TOT_SHIP_REQ 는 손대지 않는다 (03 §1.1a)
    expect(totShipReq.D_20260901).toBe(7);
  });

  it('편집 컬럼이 D_ 가 아니면(W_/M_) 재계산하지 않는다', () => {
    const g = buildGroup();
    const rows = Object.values(g);
    const changes = calcPlanQty(rows, DAYS, g.detail, 'W_20260936');
    expect(changes).toHaveLength(0);
  });
});

// AS-IS Simulation() L7463~7886 (iter-2 라인 정독으로 03 §6-9 해소) 단위검증
describe('simulate (Simulation 재계산 + SUM 캐스케이드)', () => {
  const CALENDAR = [
    { COLUMN_NAME: 'D_20260901', SMALL_CLASS_LABEL_NAME: 'W36', SORT_ORDER_NO: '1' },
    { COLUMN_NAME: 'D_20260902', SMALL_CLASS_LABEL_NAME: 'W36', SORT_ORDER_NO: '2' },
    { COLUMN_NAME: 'D_20260903', SMALL_CLASS_LABEL_NAME: 'W36', SORT_ORDER_NO: '3' },
    { COLUMN_NAME: 'W_202609W36', SMALL_CLASS_LABEL_NAME: 'W36', SORT_ORDER_NO: '4' },
    { COLUMN_NAME: 'M_202609', SMALL_CLASS_LABEL_NAME: '', SORT_ORDER_NO: '5' },
  ];

  it('buildCalendarGroups — 주(yyyymm+주차라벨)·월(yyyymm) 멤버십 귀속', () => {
    const groups = buildCalendarGroups(CALENDAR);
    expect(groups.dayCols).toEqual(['D_20260901', 'D_20260902', 'D_20260903']);
    expect(groups.weeks).toEqual([
      { binding: 'W_202609W36', days: ['D_20260901', 'D_20260902', 'D_20260903'] },
    ]);
    expect(groups.months).toEqual([{ binding: 'M_202609', weeks: ['W_202609W36'] }]);
  });

  it('dirty 그룹의 WH(전일산식)/BALANCE(WH-PLAN)/CONTAINER(CEIL) 재계산 + realFlag=false 는 qty 0', () => {
    const g = buildGroup();
    // simulate 는 SHIP_PLAN 행 값을 원본으로 쓴다 — 사전 재계산으로 채워둠(AS-IS Red 이후 상태)
    recalcItemGroup(Object.values(g), DAYS, 0);
    const rows = Object.values(g);
    const groups = buildCalendarGroups(CALENDAR);
    const dirty = new Set(['81\x1FP1\x1FITEM1']);
    simulate(rows, groups, () => 5, dirty);
    // WH[2일] = WH[1일]+PROD[1일]-PLAN[1일]-MOVE[1일] = 100+30-10-5
    expect(g.wh.D_20260902).toBe(115);
    expect(g.balance.D_20260902).toBe(115 - 20);
    expect(g.container.D_20260902).toBe(4); // CEIL(20/5)
    // qty 0(realFlag=false 경로) 이면 CONTAINER 전 일자 0
    simulate(rows, groups, () => 0, dirty);
    expect(g.container.D_20260902).toBe(0);
  });

  it('SUM 캐스케이드 — 유량(SHIP_PLAN)은 주=Σ일, 재고(WH_STOCK/BALANCE)는 주=마지막 일자값', () => {
    const g = buildGroup();
    recalcItemGroup(Object.values(g), DAYS, 0);
    const rows = Object.values(g);
    const groups = buildCalendarGroups(CALENDAR);
    simulate(rows, groups, () => 5, new Set(['81\x1FP1\x1FITEM1']));
    expect(g.shipPlan.W_202609W36).toBe(10 + 20 + 0); // 누적합
    expect(g.wh.W_202609W36).toBe(g.wh.D_20260903); // 마지막값
    expect(g.shipPlan.M_202609).toBe(30); // 월 = Σ주
    expect(g.wh.M_202609).toBe(g.wh.W_202609W36); // 월 = 마지막 주값
  });

  it('dirty 그룹이 아니면 1단계 재계산은 건너뛴다(2단계 SUM 은 전 행 수행 — AS-IS 동일)', () => {
    const g = buildGroup();
    recalcItemGroup(Object.values(g), DAYS, 0);
    const whBefore = g.wh.D_20260902;
    g.prod.D_20260901 = 999; // 1단계가 돌면 WH 가 바뀔 입력
    simulate(Object.values(g), buildCalendarGroups(CALENDAR), () => 5, new Set());
    expect(g.wh.D_20260902).toBe(whBefore); // 1단계 미수행
    expect(g.shipPlan.W_202609W36).toBe(30); // 2단계는 수행
  });
});
