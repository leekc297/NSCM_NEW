import { describe, expect, it } from 'vitest';

import type { Scp0105Row } from '../capa-speed-plan.types';

import { qtyRowOffsetOf, recalcPpmCell } from './capaSpeedPlan.recalc';

/**
 * design 03_grid-columns §5-4 V-27~V-31 (PPM 자동계산) 검증 축.
 *   AS-IS `RecalcSheet`(cs:2676~2879) / `GetQtyRowIndex`(cs:2594~2618).
 * 블록 배치는 AS-IS GET SP 실측 기준이다 — 한 블록 3행(수량 `EQP_NBU` -> 속도 1종 -> `PPM`),
 * 정렬은 `... , A.ELTR_LN_TP_CD, M.SORT_ORDER_NO`.
 */

const PERIOD = 'M_01202510';

const row = (msr: string, patch: Record<string, unknown> = {}): Scp0105Row =>
  ({
    VER_ID: '202509',
    VER_SEQ: '1',
    DIVISION_ID: '81',
    COMPANY_ID: 'C1',
    SITE_ID: 'S1',
    PLANT_ID: 'P1',
    FACTORY_ID: 'F1',
    LINE_ID: 'L1',
    OPERATION_ID: 'A5000',
    ELTR_LN_TP_CD: 'Anode',
    ITEM_ID: 'I1',
    NICK_NAME: 'N1',
    MSR_TP_CD: msr,
    [`${PERIOD}_ASSIGN_PRIORITY`]: '1',
    ...patch,
  }) as Scp0105Row;

/** 온전한 3행 블록 — 수량(qty) / 속도(speed) / PPM. */
const block = (
  speedMeasure: string,
  values: { qty: number; speed: number; ppm?: number },
  patch: Record<string, unknown> = {}
): Scp0105Row[] => [
  row('EQP_NBU', { [PERIOD]: values.qty, ELTR_QTY: 2, MMS_CF: 4, ...patch }),
  row(speedMeasure, { [PERIOD]: values.speed, ...patch }),
  row('PPM', { [PERIOD]: values.ppm ?? 0, ...patch }),
];

describe('qtyRowOffsetOf — 행 오프셋 (cs:2594~2618)', () => {
  it('EQP_NBU=0 / 속도 4종=-1 / PPM=-2', () => {
    expect(qtyRowOffsetOf('EQP_NBU')).toBe(0);
    for (const measure of ['MMS', 'PPM_AVG', 'TTT', 'CPM']) {
      expect(qtyRowOffsetOf(measure)).toBe(-1);
    }
    expect(qtyRowOffsetOf('PPM')).toBe(-2);
  });

  it('대상 measure 가 아니면 null (ELTR EQP_SPED 등)', () => {
    expect(qtyRowOffsetOf('EQP_SPED')).toBeNull();
    expect(qtyRowOffsetOf('')).toBeNull();
  });
});

describe('recalcPpmCell — 산식 4종 (V-27)', () => {
  it('MMS = (speed * 60) / mms_cf * qty', () => {
    const rows = block('MMS', { qty: 10, speed: 2 });
    expect(recalcPpmCell(rows, 1, PERIOD)).toEqual({
      ppmRowIndex: 2,
      value: ((2 * 60) / 4) * 10,
      previousValue: 0,
    });
  });

  it('CPM = speed / eltr_qty * qty', () => {
    const rows = block('CPM', { qty: 10, speed: 8 });
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe((8 / 2) * 10);
  });

  it('PPM_AVG = speed * qty', () => {
    const rows = block('PPM_AVG', { qty: 10, speed: 3 });
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe(30);
  });

  it('TTT = 60 / speed * qty', () => {
    const rows = block('TTT', { qty: 10, speed: 5 });
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe((60 / 5) * 10);
  });

  it('수량행·PPM행에서 편집해도 같은 블록의 같은 결과가 나온다(오프셋 0 / -2)', () => {
    const rows = block('PPM_AVG', { qty: 10, speed: 3 });
    expect(recalcPpmCell(rows, 0, PERIOD)?.value).toBe(30);
    expect(recalcPpmCell(rows, 2, PERIOD)?.value).toBe(30);
  });
});

describe('recalcPpmCell — 0 방어·비유한값 (V-28)', () => {
  it('eltr_qty=0 -> 1, mms_cf=0 -> 1 로 대체한다', () => {
    const rows = block('MMS', { qty: 10, speed: 2 });
    rows[0].MMS_CF = 0;
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe(2 * 60 * 10);
  });

  it('TTT 에서 speed=0 이면 0 (나눗셈 폭주 금지)', () => {
    const rows = block('TTT', { qty: 10, speed: 0 });
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe(0);
  });
});

describe('recalcPpmCell — 발동 대상 컬럼 (V-30)', () => {
  it('BASE_QTY 와 기간열만 계산한다', () => {
    const rows = block('PPM_AVG', { qty: 10, speed: 3 });
    rows[0].BASE_QTY = 10;
    rows[1].BASE_QTY = 3;
    rows[2].BASE_QTY = 0;
    expect(recalcPpmCell(rows, 1, 'BASE_QTY')?.value).toBe(30);
    expect(recalcPpmCell(rows, 1, 'PFRSLT_QTY')).toBeNull();
    expect(recalcPpmCell(rows, 1, 'LINE_ID')).toBeNull();
  });

  it('우선순위 컬럼(_ASSIGN_PRIORITY)은 편집 대상이 아니라 계산도 하지 않는다', () => {
    const rows = block('MMS', { qty: 10, speed: 2 });
    expect(recalcPpmCell(rows, 1, `${PERIOD}_ASSIGN_PRIORITY`)).toBeNull();
  });
});

describe('recalcPpmCell — 더미 제외 (V-31)', () => {
  it('NICK_NAME_DUMMY_YN=Y 이면서 MMS/CPM 이면 기입하지 않는다', () => {
    for (const measure of ['MMS', 'CPM']) {
      const rows = block(measure, { qty: 10, speed: 2 }, { NICK_NAME_DUMMY_YN: 'Y' });
      expect(recalcPpmCell(rows, 1, PERIOD)).toBeNull();
    }
  });

  it('더미여도 PPM_AVG/TTT 는 계산한다', () => {
    const rows = block('PPM_AVG', { qty: 10, speed: 3 }, { NICK_NAME_DUMMY_YN: 'Y' });
    expect(recalcPpmCell(rows, 1, PERIOD)?.value).toBe(30);
  });
});

describe('recalcPpmCell — 블록 경계·measure 정체성 가드 (V-29 잔여 결함 차단)', () => {
  it('이웃이 다른 블록이면 계산하지 않는다', () => {
    const rows = [...block('MMS', { qty: 10, speed: 2 })];
    rows[2] = row('PPM', { LINE_ID: 'L9', [PERIOD]: 0 });
    expect(recalcPpmCell(rows, 1, PERIOD)).toBeNull();
  });

  it('ELTR_LN_TP_CD 만 다른 인접 블록도 다른 블록으로 본다 (Anode/Cathode)', () => {
    // 앞 블록이 2행으로 결손되면 오프셋이 다음 블록 첫 행을 가리킨다.
    const rows: Scp0105Row[] = [
      row('EQP_NBU', { [PERIOD]: 10, ELTR_QTY: 2, MMS_CF: 4 }),
      row('MMS', { [PERIOD]: 2 }),
      row('EQP_NBU', { ELTR_LN_TP_CD: 'Cathode', [PERIOD]: 99 }),
    ];
    expect(recalcPpmCell(rows, 1, PERIOD)).toBeNull();
  });

  it('같은 블록이어도 이웃 measure 가 EQP_NBU/PPM 이 아니면 계산하지 않는다', () => {
    const rows: Scp0105Row[] = [
      row('MMS', { [PERIOD]: 2 }),
      row('PPM_AVG', { [PERIOD]: 3 }),
      row('TTT', { [PERIOD]: 0 }),
    ];
    expect(recalcPpmCell(rows, 1, PERIOD)).toBeNull();
  });

  it('블록 경계를 넘어가는 인덱스(음수·초과)는 계산하지 않는다', () => {
    const rows = block('MMS', { qty: 10, speed: 2 });
    expect(recalcPpmCell([rows[1]], 0, PERIOD)).toBeNull();
    expect(recalcPpmCell(rows, 99, PERIOD)).toBeNull();
  });
});
