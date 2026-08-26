import { describe, expect, it } from 'vitest';

import { isOverRangeCell, overRangeColsOf } from './overRange';

/**
 * AS-IS DMF0020_SalesFuturePrice.cs L1475~1488 [PJ20200138] "범위를 초과하는 YYYYMMDD"
 *
 * SP(DMF0020_GET_SCM_MST_FUTURE_PRICE)가 P_OVER_RANGE='Y' 일 때만 행마다 COL_LIST 를 채운다.
 * FE 는 그 목록에 든 동적 컬럼(W_yyyymmdd) 셀만 분홍으로 칠한다.
 *
 * COL_LIST 그룹키에 MEASURE 가 없어(SP LISTAGG GROUP BY) 같은 품목의 4개 measure 행이
 * 같은 값을 받는다 - 그래서 AS-IS 화면에서 4행이 통째로 분홍이 된다.
 */
describe('overRangeColsOf', () => {
  it('콤마 목록을 Set 으로 파싱한다', () => {
    const set = overRangeColsOf({ COL_LIST: 'W_20260803,W_20260810' });
    expect(set.has('W_20260803')).toBe(true);
    expect(set.has('W_20260810')).toBe(true);
    expect(set.size).toBe(2);
  });

  it('SP 가 "없음"으로 내려주는 표기를 걸러낸다', () => {
    // SP 는 대상이 없으면 '-' 를 상수로 내려주는 분기가 있다 (standalone SP L835/L853).
    expect(overRangeColsOf({ COL_LIST: '-' }).size).toBe(0);
    expect(overRangeColsOf({ COL_LIST: '' }).size).toBe(0);
    expect(overRangeColsOf({ COL_LIST: null }).size).toBe(0);
    expect(overRangeColsOf({}).size).toBe(0);
  });

  it('공백과 빈 토큰을 정리한다', () => {
    const set = overRangeColsOf({ COL_LIST: ' W_20260803 ,, W_20260810,' });
    expect([...set]).toEqual(['W_20260803', 'W_20260810']);
  });

  it('같은 행을 다시 물어보면 같은 Set 을 돌려준다 (formatItem 셀마다 재파싱 금지)', () => {
    const row = { COL_LIST: 'W_20260803' };
    expect(overRangeColsOf(row)).toBe(overRangeColsOf(row));
  });

  it('행의 COL_LIST 가 바뀌면 다시 파싱한다', () => {
    const row: { COL_LIST: string } = { COL_LIST: 'W_20260803' };
    expect(overRangeColsOf(row).has('W_20260803')).toBe(true);
    row.COL_LIST = 'W_20260810';
    expect(overRangeColsOf(row).has('W_20260810')).toBe(true);
    expect(overRangeColsOf(row).has('W_20260803')).toBe(false);
  });
});

describe('isOverRangeCell', () => {
  const row = { COL_LIST: 'W_20260803,W_20260810' };

  it('목록에 든 동적 컬럼만 대상이다', () => {
    expect(isOverRangeCell(row, 'W_20260803')).toBe(true);
    expect(isOverRangeCell(row, 'W_20260817')).toBe(false);
  });

  it('Monthly bucket 은 대상이 없다 (COL_LIST 는 W_ 만 담는다 - AS-IS 동일)', () => {
    expect(isOverRangeCell({ COL_LIST: 'W_20260803' }, 'M_20260801')).toBe(false);
  });

  it('행이 없거나(신규 INSERT 행) COL_LIST 가 비면 대상이 아니다', () => {
    expect(isOverRangeCell(undefined, 'W_20260803')).toBe(false);
    expect(isOverRangeCell({ CRUD_TYPE: 'I' }, 'W_20260803')).toBe(false);
  });
});
