import { describe, expect, it } from 'vitest';

import { BUCKET_TYPE, BUCKET2_TYPE, GUBUN } from '../demand-plan-waterfall.constants';

import {
  baseVisibleOf,
  buildDynColMetas,
  buildDynamicColumns,
  buildStaticColumns,
  splitTitleRows,
  type WaterfallTitleRow,
} from './waterfall.columns';

const titleRow = (
  name: string,
  sort: number,
  extra: Partial<WaterfallTitleRow> = {}
): WaterfallTitleRow => ({
  COLUMN_NAME: name,
  COLUMN_LABEL_NAME: name,
  SORT_ORDER_NO: sort,
  VISIBLE_FLAG: 'Y',
  ...extra,
});

// AS-IS TITLE SP 순서: 고정컬럼 → 기간(월합계 → 주합계 → 일자) interleave
const MKT_TITLE: WaterfallTitleRow[] = [
  titleRow('DIVISION_ID', 1),
  titleRow('ITEM_ID', 2),
  titleRow('B_HIDDEN', 3),
  titleRow('DROPPED', 4, { VISIBLE_FLAG: 'N' }),
  titleRow('VERSION_NO', 5, { VISIBLE_FLAG: 'N' }),
  titleRow('MEASURE', 6, { VISIBLE_FLAG: 'N' }),
  titleRow('M_202609', 11, { LARGE_CLASS_LABEL_NAME: '2026.09', SMALL_CLASS_LABEL_NAME: 'SUM' }),
  titleRow('W_20260936', 12, { LARGE_CLASS_LABEL_NAME: '2026.09', SMALL_CLASS_LABEL_NAME: 'W36' }),
  titleRow('D_20260901', 13, {
    LARGE_CLASS_LABEL_NAME: '2026.09',
    SMALL_CLASS_LABEL_NAME: 'W36',
    COLUMN_LABEL_NAME: '01',
    DAY_CODE: 'TUE',
  }),
  titleRow('D_20260905', 14, {
    LARGE_CLASS_LABEL_NAME: '2026.09',
    SMALL_CLASS_LABEL_NAME: 'W36',
    COLUMN_LABEL_NAME: '05',
    DAY_CODE: 'SAT',
  }),
];

describe('splitTitleRows', () => {
  it('B_ 접두·VISIBLE_FLAG=N 제외, VERSION_NO/MEASURE 는 강제 유지', () => {
    const { staticRows, periodRows } = splitTitleRows(MKT_TITLE);
    expect(staticRows.map(r => r.COLUMN_NAME)).toEqual([
      'DIVISION_ID',
      'ITEM_ID',
      'VERSION_NO',
      'MEASURE',
    ]);
    expect(periodRows).toHaveLength(4);
  });

  it('SORT_ORDER_NO 순으로 정렬한다', () => {
    const { staticRows } = splitTitleRows([titleRow('B', 9), titleRow('A', 1)]);
    expect(staticRows.map(r => r.COLUMN_NAME)).toEqual(['A', 'B']);
  });
});

describe('buildStaticColumns', () => {
  const { staticRows } = splitTitleRows(MKT_TITLE);

  it('MEASURE 를 말미로 핀하고 거기에만 fixed 를 준다 (AS-IS freeze 기준)', () => {
    const cols = buildStaticColumns({ staticRows, settings: null, metaColumns: [] });
    expect(cols.map(c => c.colNm)).toEqual(['DIVISION_ID', 'ITEM_ID', 'VERSION_NO', 'MEASURE']);
    expect(cols.filter(c => c.fixed).map(c => c.colNm)).toEqual(['MEASURE']);
  });

  it('COLUMN SET 이 표시/순서/폭/색을 반영하고, 끈 컬럼은 빠진다', () => {
    const cols = buildStaticColumns({
      staticRows,
      settings: [
        {
          COLUMN_NAME: 'ITEM_ID',
          COLUMN_LABEL_NAME: 'Item',
          USER_FLAG: 'Y',
          SORT_ORDER_NO: 1,
          COL_WIDTH: 150,
          CELL_COLOR: '#eeeeee',
          TEXT_COLOR: '#333333',
          isKey: false,
        },
        {
          COLUMN_NAME: 'DIVISION_ID',
          COLUMN_LABEL_NAME: 'Division',
          USER_FLAG: 'N',
          SORT_ORDER_NO: 2,
          COL_WIDTH: 100,
          CELL_COLOR: '',
          TEXT_COLOR: '',
          isKey: false,
        },
      ],
      metaColumns: [],
    });
    expect(cols.map(c => c.colNm)).toEqual(['ITEM_ID', 'VERSION_NO', 'MEASURE']);
    expect(cols[0].colWth).toBe(150);
    expect(cols[0].cellColor).toBe('#eeeeee');
    expect(cols.filter(c => c.fixed).map(c => c.colNm)).toEqual(['MEASURE']);
  });

  it('TITLE SP 에 없어도 UI CATEGORY 메타에 있으면 켤 수 있다 (ALLCOLS)', () => {
    const cols = buildStaticColumns({
      staticRows,
      settings: [
        {
          COLUMN_NAME: 'NICK_NAME',
          COLUMN_LABEL_NAME: 'Nick',
          USER_FLAG: 'Y',
          SORT_ORDER_NO: 1,
          COL_WIDTH: 0,
          CELL_COLOR: '',
          TEXT_COLOR: '',
          isKey: false,
        },
      ],
      metaColumns: [{ colNm: 'NICK_NAME', colLblNm: 'Nick Name' }],
    });
    expect(cols.map(c => c.colNm)).toEqual(['NICK_NAME', 'VERSION_NO', 'MEASURE']);
    expect(cols[0].colLblNm).toBe('Nick Name');
  });
});

describe('baseVisibleOf (hook #103 rank 규칙 = AS-IS SetSpreadColumn)', () => {
  const mkt = GUBUN.MKT_FCST;
  it('DAILY: D 표시 / W·M 은 Sum 체크', () => {
    expect(baseVisibleOf(mkt, BUCKET_TYPE.DAILY, false, 'D')).toBe(true);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.DAILY, false, 'W')).toBe(false);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.DAILY, true, 'W')).toBe(true);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.DAILY, true, 'M')).toBe(true);
  });
  it('WEEKLY: W 표시 / D 숨김 / M 은 Sum 체크', () => {
    expect(baseVisibleOf(mkt, BUCKET_TYPE.WEEKLY, true, 'D')).toBe(false);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.WEEKLY, false, 'W')).toBe(true);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.WEEKLY, true, 'M')).toBe(true);
  });
  it('ONLY_WEEKLY: W 만 (Sum 체크여도 M 미표시)', () => {
    expect(baseVisibleOf(mkt, BUCKET_TYPE.ONLY_WEEKLY, true, 'W')).toBe(true);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.ONLY_WEEKLY, true, 'M')).toBe(false);
  });
  it('MONTHLY: M 만', () => {
    expect(baseVisibleOf(mkt, BUCKET_TYPE.MONTHLY, true, 'M')).toBe(true);
    expect(baseVisibleOf(mkt, BUCKET_TYPE.MONTHLY, true, 'W')).toBe(false);
  });
  it('BIZ: Y>Q>M 체계 (QUARTERLY 에서 Y 는 Sum 체크)', () => {
    const biz = GUBUN.BIZ_PLAN;
    expect(baseVisibleOf(biz, BUCKET2_TYPE.QUARTERLY, false, 'Q')).toBe(true);
    expect(baseVisibleOf(biz, BUCKET2_TYPE.QUARTERLY, false, 'Y')).toBe(false);
    expect(baseVisibleOf(biz, BUCKET2_TYPE.QUARTERLY, true, 'Y')).toBe(true);
    expect(baseVisibleOf(biz, BUCKET2_TYPE.QUARTERLY, true, 'M')).toBe(false);
    expect(baseVisibleOf(biz, BUCKET2_TYPE.YEARLY, true, 'Y')).toBe(true);
  });
});

describe('buildDynamicColumns (3단 헤더)', () => {
  const { periodRows } = splitTitleRows(MKT_TITLE);
  const metas = buildDynColMetas(periodRows, GUBUN.MKT_FCST);

  it('월 > 주차/SUM > SUM·일자 3단으로 묶고, 합계 leaf 는 SUM 이다', () => {
    const groups = buildDynamicColumns({
      metas,
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      isSumChecked: false,
      scale: 0,
    });
    expect(groups).toHaveLength(1);
    expect(groups[0].header).toBe('2026.09');
    const subs = groups[0].columns ?? [];
    expect(subs.map(s => s.header)).toEqual(['SUM', 'W36']);
    expect((subs[0].columns ?? []).map(c => c.header)).toEqual(['SUM']);
    // 주 합계(SUM) 가 같은 주차 그룹의 일자보다 앞
    expect((subs[1].columns ?? []).map(c => c.header)).toEqual(['SUM', '01', '05']);
  });

  it('초기 visible 을 config 에 직접 반영한다 (DAILY, Sum 해제)', () => {
    const groups = buildDynamicColumns({
      metas,
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.DAILY,
      isSumChecked: false,
      scale: 0,
    });
    const leaves = (groups[0].columns ?? []).flatMap(s => s.columns ?? []);
    const visibleOf = (binding: string) => leaves.find(c => c.binding === binding)?.visible;
    expect(visibleOf('D_20260901')).toBe(true);
    expect(visibleOf('W_20260936')).toBe(false);
    expect(visibleOf('M_202609')).toBe(false);
  });

  it('scale 에 따라 숫자 포맷을 만든다', () => {
    const groups = buildDynamicColumns({
      metas,
      gubun: GUBUN.MKT_FCST,
      bucket: BUCKET_TYPE.MONTHLY,
      isSumChecked: false,
      scale: 3,
    });
    const leaf = (groups[0].columns ?? [])[0].columns?.[0];
    expect(leaf?.format).toBe('#,##0.000');
  });
});
