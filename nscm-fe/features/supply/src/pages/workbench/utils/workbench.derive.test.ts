import { describe, expect, it } from 'vitest';

import { COL, TABS } from '../workbench.constants';
import type { WorkbenchInitData } from '../workbench.types';

import { deriveOnCellChange, type DeriveSources } from './workbench.derive';
import { buildCellComboRows } from './workbench.gridCombos';

// design 03_grid-columns.md §5.4 P-1~P-6(파생 D1·D2·D4)를 고정한다.
//   특히 iter-1 GAP-3 회귀 방지: 셀 콤보 후보와 파생 역변환이 **같은 값 축**을 써야 한다.
//   AS-IS 는 셀 텍스트를 표시명(NAME)으로 두고 NAME→CODE 로 되돌린다(cs:2247·2264·2306·2315·2369).

/** lookup 실측 형태 — CODE(SEGMENT1) ≠ NAME(SEGMENT2). 이 어긋남이 GAP-3 의 원인이었다. */
const STOCK_TYPE_LOOKUP = [
  { CODE: 'WH', NAME: 'Warehouse' },
  { CODE: 'IT', NAME: 'In Transit' },
];

const FCST_TYPE_LOOKUP = [
  { CODE: 'F', NAME: 'Forecast' },
  { CODE: 'O', NAME: 'Order' },
];

const sources: DeriveSources = {
  fcstTypeRows: FCST_TYPE_LOOKUP,
  stockTypeRows: STOCK_TYPE_LOOKUP,
  lineAll: [
    { CODE: 'L01', NAME: 'Line 01', DIVISION_ID: '81', PLANT_ID: 'P1', OPERATION_ID: 'OP1' },
  ],
  plantSiteAll: [{ CODE: 'PS1', NAME: 'Plant Site 1', DIVISION_ID: '81', PLANT_ID: 'P1' }],
};

const EMPTY_INIT: WorkbenchInitData = {
  versionAll: [],
  salesSiteAll: [],
  plantSiteAll: [],
  scmSiteAll: [],
  itemAll: [],
  projectAll: [],
  projectCode40All: [],
  locationAll: [],
  lineAll: [],
};

describe('D1/D2 — *_TYPE_NAME 표시명 → 숨김 코드 역변환', () => {
  it('표시명이 들어오면 코드를 채운다', () => {
    expect(
      deriveOnCellChange(
        TABS.MKT_FCST,
        COL.FCST_TYPE_NAME,
        { [COL.FCST_TYPE_NAME]: 'Forecast' },
        sources
      )
    ).toEqual({ [COL.FCST_TYPE]: 'F' });

    for (const tab of [TABS.STOCK, TABS.STOCK_ELEC, TABS.STOCK_2ND_OCV]) {
      expect(
        deriveOnCellChange(tab, COL.STOCK_TYPE_NAME, { [COL.STOCK_TYPE_NAME]: 'Warehouse' }, sources)
      ).toEqual({ [COL.STOCK_TYPE]: 'WH' });
    }
  });

  it('코드가 들어오면 못 찾는다 — 셀 커밋값이 코드면 파생이 죽는다는 GAP-3 의 증거', () => {
    expect(
      deriveOnCellChange(TABS.STOCK, COL.STOCK_TYPE_NAME, { [COL.STOCK_TYPE_NAME]: 'WH' }, sources)
    ).toEqual({ [COL.STOCK_TYPE]: '' });
  });
});

describe('GAP-3 회귀 — 콤보 후보의 셀 커밋값(CODE)이 파생 입력과 같은 축이어야 한다', () => {
  // 공용 DataGrid 의 dataMap 은 `new DataMap(rows,'CODE','NAME')` 이라 셀에 후보의 **CODE** 를 커밋한다.
  //   따라서 후보의 CODE 를 그대로 파생에 넣어도 코드가 나와야 한다(= CODE 가 표시명이어야 한다).
  const built = buildCellComboRows(EMPTY_INIT, '81', {
    fcstType: FCST_TYPE_LOOKUP,
    stockType: STOCK_TYPE_LOOKUP,
    incoterms: [],
  });

  it('*_TYPE_NAME 후보는 CODE = NAME = 표시명으로 재구성된다', () => {
    for (const row of built.stock[COL.STOCK_TYPE_NAME]) expect(row.CODE).toBe(row.NAME);
    for (const row of built.mktFcst[COL.FCST_TYPE_NAME]) expect(row.CODE).toBe(row.NAME);
  });

  it('후보에서 고른 값을 그대로 파생에 넣으면 숨김 코드가 채워진다', () => {
    const picked = built.stock[COL.STOCK_TYPE_NAME][0].CODE;
    expect(
      deriveOnCellChange(
        TABS.STOCK,
        COL.STOCK_TYPE_NAME,
        { [COL.STOCK_TYPE_NAME]: picked },
        sources
      )
    ).toEqual({ [COL.STOCK_TYPE]: 'WH' });

    const pickedFcst = built.mktFcst[COL.FCST_TYPE_NAME][0].CODE;
    expect(
      deriveOnCellChange(
        TABS.MKT_FCST,
        COL.FCST_TYPE_NAME,
        { [COL.FCST_TYPE_NAME]: pickedFcst },
        sources
      )
    ).toEqual({ [COL.FCST_TYPE]: 'F' });
  });
});

describe('D4 — Elec. Demand LINE_ID/PLANT_SITE_ID → OPERATION_ID', () => {
  const row = {
    [COL.DIVISION_ID]: '81',
    [COL.PLANT_SITE_ID]: 'PS1',
    [COL.LINE_ID]: 'L01',
  };

  it('Line·Plant Site 양쪽 변경에서 같은 결과를 낸다', () => {
    for (const binding of [COL.LINE_ID, COL.PLANT_SITE_ID])
      expect(deriveOnCellChange(TABS.ELEC_DEMAND, binding, row, sources)).toEqual({
        [COL.OPERATION_ID]: 'OP1',
      });
  });

  it('어느 단계든 못 찾으면 빈 문자열(저장 시 필수검증이 잡는다)', () => {
    expect(
      deriveOnCellChange(
        TABS.ELEC_DEMAND,
        COL.LINE_ID,
        { ...row, [COL.LINE_ID]: 'NOPE' },
        sources
      )
    ).toEqual({ [COL.OPERATION_ID]: '' });
  });
});

describe('GAP-23 회귀 — 빈값을 붙여넣으면 파생을 수행하지 않는다', () => {
  // AS-IS ClipboardPasted 3분기 전건이 `Cells[iRow,iCol].Text != ""` 를 먼저 본다
  //   (cs:2243 D1 · cs:2261 D2 · cs:2278 D4). 가드가 없으면 숨김 코드 컬럼이 `''` 로 덮인다.
  it('D1 — FCST_TYPE_NAME 이 비면 FCST_TYPE 를 건드리지 않는다', () => {
    expect(
      deriveOnCellChange(TABS.MKT_FCST, COL.FCST_TYPE_NAME, { [COL.FCST_TYPE_NAME]: '' }, sources)
    ).toEqual({});
  });

  it('D2 — STOCK_TYPE_NAME 이 비면 STOCK_TYPE 를 건드리지 않는다', () => {
    for (const tab of [TABS.STOCK, TABS.STOCK_ELEC, TABS.STOCK_2ND_OCV])
      expect(
        deriveOnCellChange(tab, COL.STOCK_TYPE_NAME, { [COL.STOCK_TYPE_NAME]: '' }, sources)
      ).toEqual({});
  });

  it('D4 — 붙여넣은 셀이 비면 OPERATION_ID 를 건드리지 않는다', () => {
    expect(
      deriveOnCellChange(
        TABS.ELEC_DEMAND,
        COL.LINE_ID,
        { [COL.DIVISION_ID]: '81', [COL.PLANT_SITE_ID]: 'PS1', [COL.LINE_ID]: '' },
        sources
      )
    ).toEqual({});
  });

  it('값이 있으면 그대로 파생한다(가드가 정상 경로를 막지 않는다)', () => {
    expect(
      deriveOnCellChange(
        TABS.MKT_FCST,
        COL.FCST_TYPE_NAME,
        { [COL.FCST_TYPE_NAME]: 'Forecast' },
        sources
      )
    ).toEqual({ [COL.FCST_TYPE]: 'F' });
  });
});

describe('D3 — STOCK SCM_SITE_ID 는 셀 출력이 없다(후보만 좁혀진다)', () => {
  it('AS-IS 도 이미 입력된 Line 값을 지우지 않는다', () => {
    expect(
      deriveOnCellChange(TABS.STOCK, COL.SCM_SITE_ID, { [COL.SCM_SITE_ID]: 'S1' }, sources)
    ).toEqual({});
  });
});
