import { describe, expect, it } from 'vitest';

import type { EditTracker } from '@foundation/utils';

import {
  buildGeneralPayload,
  insertTargetMonths,
  unfoldSaveCells,
} from './integrationPsiSave';

type Row = Record<string, unknown>;

const FIXED = new Set(['ITEM_ID', 'MEASURE', 'PLANT_ID', 'SEQ_FLAG', 'BOH_QTY', 'LINE_ID']);

// EditTracker 스텁 — unfoldSaveCells 는 getOriginalValues() 만 쓴다.
const trackerOf = (pairs: [Row, Record<string, unknown>][]): EditTracker =>
  ({ getOriginalValues: () => new Map(pairs) }) as unknown as EditTracker;

const insertRow = (over: Row = {}): Row => ({
  CRUD_TYPE: 'I',
  OPERATION_GROUP: 'Electrode',
  MEASURE: 'PROD_PLAN',
  SEQ_FLAG: '550',
  ITEM_ID: 'ITEM1',
  LINE_ID: 'LINE1',
  BOH_QTY: 0,
  '202609': 10,
  '202610': 20,
  ...over,
});

describe('insertTargetMonths — 신규 삽입 월 범위', () => {
  it('plan start 월 ~ HORIZON_END 월 전체를 돌려준다', () => {
    expect(insertTargetMonths('20260817', '20280312')).toHaveLength(20);
    expect(insertTargetMonths('20260901', '20261031')).toEqual(['202609', '202610']);
  });

  it('HORIZON 부재/역순이면 AS-IS else 분기 = 시작월 + 11월(cs:277)', () => {
    expect(insertTargetMonths('20260901', '')).toHaveLength(12);
    expect(insertTargetMonths('20260901', '20250101')).toHaveLength(12);
  });

  it('plan start 가 비었으면 빈 배열(저장 대상 없음)', () => {
    expect(insertTargetMonths('', '20280312')).toEqual([]);
  });
});

describe('unfoldSaveCells — action 산출', () => {
  it('신규행은 Plan 전체 개월수를 action=I 로 펼친다 — BOH 셀은 넣지 않는다', () => {
    const cells = unfoldSaveCells({
      source: [insertRow()],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20261031',
    }).cells;
    expect(cells.map(c => c.yyyymm)).toEqual(['202609', '202610']);
    expect(cells.every(c => c.action === 'I')).toBe(true);
    // 신규는 절대값
    expect(cells.map(c => c.modiQty)).toEqual(['10', '20']);
    // 회귀: 'BOH' 리터럴을 보내면 SP INSERT 가 YYYYMM='BOH' 쓰레기 행을 만든다(2026-10-13 실사고).
    expect(cells.some(c => c.yyyymm === 'BOH')).toBe(false);
  });

  it('삽입 월은 조회기간이 아니라 Plan HORIZON 까지다(AS-IS cs:1510~1511)', () => {
    const cells = unfoldSaveCells({
      source: [insertRow()],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260817',
      horizonEndYyyymmdd: '20280312', // 실측 HORIZON_END (WEEKLY)
    }).cells;
    // 202608 ~ 202803 = 20개월. 화면 조회기간(6개월)으로 좁히면 불완전 등록이 된다.
    expect(cells).toHaveLength(20);
    expect(cells[0].yyyymm).toBe('202608');
    expect(cells[cells.length - 1].yyyymm).toBe('202803');
  });

  it('BOH 수정셀의 yyyymm 은 plan start 월이다(AS-IS cs:1577) — 리터럴 BOH 금지', () => {
    const row: Row = {
      CRUD_TYPE: 'M',
      OPERATION_GROUP: 'Cell',
      MEASURE: 'INV',
      SEQ_FLAG: '360',
      ITEM_ID: 'ITEM9',
      BOH_QTY: 120,
    };
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { BOH_QTY: 100 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260817',
      horizonEndYyyymmdd: '20280312',
    }).cells;
    expect(cells).toHaveLength(1);
    expect(cells[0].yyyymm).toBe('202608');
    expect(cells[0].modiQty).toBe('20');
  });

  it('수정행은 변경된 수량셀만 action=M + 가감값으로 펼친다', () => {
    const row: Row = {
      CRUD_TYPE: 'M',
      OPERATION_GROUP: 'Cell',
      MEASURE: 'SHIP_PLAN_SEMI',
      SEQ_FLAG: '420',
      ITEM_ID: 'ITEM2',
      '202609': 70,
      '202610': 5,
    };
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { '202609': 50, '202610': 5 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20261031',
    }).cells;
    // 202610 은 preQty==qty 라 제외
    expect(cells).toHaveLength(1);
    expect(cells[0].action).toBe('M');
    expect(cells[0].yyyymm).toBe('202609');
    expect(cells[0].modiQty).toBe('20');
  });

  it('operationGroup 은 표시명을 보낸다 — 코드(P/A/E) 금지(SP L786 CASE)', () => {
    // 코드를 보내면 SP 의 CASE 가 ELSE 로 떨어져 Pack/Cell 이 전부 'E'(Electrode)로 저장된다.
    for (const [name, seq] of [
      ['Pack', '150'],
      ['Cell', '350'],
      ['Electrode', '550'],
    ] as const) {
      const cells = unfoldSaveCells({
        source: [insertRow({ OPERATION_GROUP: name, SEQ_FLAG: seq })],
        tracker: undefined,
        fixedBindings: FIXED,
        planStartYyyymmdd: '20260901',
        horizonEndYyyymmdd: '20260930',
      }).cells;
      expect(cells[0].operationGroup).toBe(name);
      expect(['P', 'A', 'E']).not.toContain(cells[0].operationGroup);
    }
  });

  it('신규행 LINE_ID 가 sentinel("-")이면 hasEmptyLineInsert', () => {
    const r = unfoldSaveCells({
      source: [insertRow({ LINE_ID: '-' })],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20260930',
    });
    expect(r.hasEmptyLineInsert).toBe(true);
  });

  it('OPERATION_GROUP 역변환 실패 행은 제외하고 플래그를 세운다', () => {
    const r = unfoldSaveCells({
      source: [insertRow({ OPERATION_GROUP: '없는그룹' })],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20260930',
    });
    expect(r.opGroupLookupMissing).toBe(true);
    expect(r.cells).toEqual([]);
  });
});

describe('buildGeneralPayload — P_ACTIVE_FLAG 계약', () => {
  // 회귀 방지: SP 는 P_ACTIVE_FLAG 토큰을 'I'/'M' 으로 분기한다
  //   (PKG_SCP0111 BODY L751 `IF V_ACTIVE_FLAG = 'I'` / L3359 `= 'M'`).
  //   'Y' 같은 값을 보내면 신규 INSERT 분기가 안 돌아 아무 행도 안 들어간다(2026-10-13 실사고).
  it('activeFlag 는 셀별 action 을 ^ 로 이어 보낸다 — Y 고정 금지', () => {
    const cells = unfoldSaveCells({
      source: [insertRow()],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20261031',
    }).cells;
    const payload = buildGeneralPayload(cells, '20260901', 'tester');
    expect(payload?.activeFlag).toBe('I^I'); // 202609, 202610 (BOH 셀 없음)
    expect(payload?.activeFlag).not.toContain('Y');
  });

  it('수정/신규가 섞이면 순서대로 M/I 토큰이 실린다', () => {
    const mod: Row = {
      CRUD_TYPE: 'M',
      OPERATION_GROUP: 'Electrode',
      MEASURE: 'PROD_PLAN',
      SEQ_FLAG: '550',
      ITEM_ID: 'ITEM3',
      '202609': 9,
    };
    const cells = unfoldSaveCells({
      source: [mod, insertRow()],
      tracker: trackerOf([[mod, { '202609': 4 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20260930',
    }).cells;
    const payload = buildGeneralPayload(cells, '20260901', 'tester');
    expect(payload?.activeFlag).toBe('M^I'); // 수정 1셀 + 신규 1개월
    // 토큰 수는 모든 키에서 같아야 한다(SP 가 같은 인덱스로 F_TOKEN 한다).
    const counts = ['activeFlag', 'itemId', 'yyyymm', 'modiQty'].map(
      k => (payload?.[k] ?? '').split('^').length
    );
    expect(new Set(counts).size).toBe(1);
  });

  it('변경셀이 없으면 null — 호출부가 MSG00004 로 끝낸다', () => {
    expect(buildGeneralPayload([], '20260901', 'tester')).toBeNull();
  });
});
