import { describe, expect, it } from 'vitest';

import type { EditTracker } from '@foundation/utils';

import {
  buildAdminPayload,
  buildGeneralPayload,
  insertTargetMonths,
  unfoldSaveCells,
} from './integrationPsiSave';
import type { SaveCell } from './integrationPsiSave';

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

describe('unfoldSaveCells — ADMIN 수정은 절대값(일반은 가감값)', () => {
  // 회귀 방지(사용자 신고 2026-11-17): ADMIN SP 는 QTY/BOH_QTY 를 절대 대입하므로
  //   수정셀 modiQty 는 절대값이어야 한다. 종전엔 가감값을 보내 ① BOH 저장 시 INV 가 깨지고
  //   ② 특정월 INV 변경이 delta 만 반영돼 "안 됨"이었다. AS-IS cs:1283~1369.
  const invRow = (over: Row = {}): Row => ({
    CRUD_TYPE: 'M',
    OPERATION_GROUP: 'Cell',
    MEASURE: 'INV',
    SEQ_FLAG: '360',
    ITEM_ID: 'ITEM9',
    BOH_QTY: 120,
    '202608': 1000,
    '202609': 1100,
    '202610': 1200,
    ...over,
  });

  it('특정월 INV 변경 — 절대값(now)을 보낸다, delta 아님', () => {
    const row = invRow({ '202609': 1150 }); // 1100 -> 1150
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { '202609': 1100 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260801',
      horizonEndYyyymmdd: '20261031',
      isAdmin: true,
    }).cells;
    expect(cells).toHaveLength(1);
    expect(cells[0].yyyymm).toBe('202609');
    expect(cells[0].modiQty).toBe('1150'); // 절대값 — 종전 버그면 '50'(delta)
    expect(cells[0].bohQty).toBe('120'); // BOH 미변경 — 현재 BOH 유지
  });

  it('BOH 변경 — 기간 전체 월에 새 BOH + 각 월 절대 QTY 를 전개한다', () => {
    const row = invRow({ BOH_QTY: 130 }); // 120 -> 130
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { BOH_QTY: 120 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260801',
      horizonEndYyyymmdd: '20261031',
      isAdmin: true,
    }).cells;
    // 공백 아닌 월 3개 전체 — 종전 버그면 plan-start월 1건(modiQty=BOH delta=10)만 나왔다.
    expect(cells.map(c => c.yyyymm)).toEqual(['202608', '202609', '202610']);
    expect(cells.map(c => c.modiQty)).toEqual(['1000', '1100', '1200']); // 각 월 절대 QTY 유지
    expect(cells.every(c => c.bohQty === '130')).toBe(true); // 새 BOH 를 전월에 전파
  });

  it('BOH 변경 시 공백 월은 건너뛴다(AS-IS 공백 skip cs:1301)', () => {
    const row = invRow({ BOH_QTY: 130, '202609': '' }); // 202609 공백
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { BOH_QTY: 120 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260801',
      horizonEndYyyymmdd: '20261031',
      isAdmin: true,
    }).cells;
    expect(cells.map(c => c.yyyymm)).toEqual(['202608', '202610']);
  });

  it('일반 저장은 그대로 가감값(비ADMIN) — ADMIN 분기가 일반 경로를 건드리지 않는다', () => {
    const row = invRow({ '202609': 1150 });
    const cells = unfoldSaveCells({
      source: [row],
      tracker: trackerOf([[row, { '202609': 1100 }]]),
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260801',
      horizonEndYyyymmdd: '20261031',
      // isAdmin 생략 = false
    }).cells;
    expect(cells).toHaveLength(1);
    expect(cells[0].modiQty).toBe('50'); // 가감값 유지(일반 SP 는 누적)
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

describe('unfoldSaveCells — 15필수 공백검증 (AS-IS roslyn L1237)', () => {
  // 15필수 전부 채운 신규행. 공백검증은 trim()==='' 만 잡으므로 '-'(VALUE_TYPE 등)는 통과한다.
  const fullInsert = (over: Row = {}): Row => ({
    CRUD_TYPE: 'I',
    PLAN_TYPE: 'FN',
    DIVISION_ID: '40',
    OPERATION_GROUP: 'Pack',
    CELL_ITEM_ID: 'C1',
    ITEM_ID: 'ITEM1',
    COMPANY_ID: 'HQ00',
    PLANT_ID: 'HQ06',
    MEASURE: 'PROD_PLAN',
    LINE_ID: 'LINE1',
    VALUE_TYPE: '-',
    TO_PRODUCT: '-',
    TO_SITE: '-',
    INCOTERMS: '-',
    BOH_QTY: 0,
    SEQ_FLAG: '550',
    '202609': 0,
    ...over,
  });
  const missing = (row: Row): string | undefined =>
    unfoldSaveCells({
      source: [row],
      tracker: undefined,
      fixedBindings: FIXED,
      planStartYyyymmdd: '20260901',
      horizonEndYyyymmdd: '20260930',
    }).missingRequiredField;

  it('전 필수 입력 시 undefined (저장 통과)', () => {
    expect(missing(fullInsert())).toBeUndefined();
  });

  it('빈 필수 컬럼의 binding 을 돌려준다 (PLANT_ID)', () => {
    expect(missing(fullInsert({ PLANT_ID: '' }))).toBe('PLANT_ID');
  });

  it('공백(스페이스)만 있어도 미입력으로 본다', () => {
    expect(missing(fullInsert({ TO_SITE: '   ' }))).toBe('TO_SITE');
  });

  it('BOH_QTY=0 은 통과 — 공백만 필수대상이다', () => {
    expect(missing(fullInsert({ BOH_QTY: 0 }))).toBeUndefined();
  });

  it('LINE_ID 공백이면 Line 을 필수로 잡는다 (admin V1 신규행)', () => {
    expect(missing(fullInsert({ LINE_ID: '' }))).toBe('LINE_ID');
  });
});

describe('buildAdminPayload — operationGroup 코드 변환 (ADMIN SP 는 코드 계약)', () => {
  const saveCell = (over: Partial<Record<keyof SaveCell, string>> = {}) =>
    ({
      action: 'I',
      planType: 'FN',
      divisionId: '40',
      companyId: 'HQ00',
      plantId: 'HQ06',
      operationGroup: 'Pack',
      seqFlag: '550',
      cellitemId: 'C1',
      itemId: 'ITEM1',
      measure: 'PROD_PLAN',
      toSite: '-',
      lineId: 'LINE1',
      valuationType: '-',
      toProduct: '-',
      incoterms: '-',
      yyyymm: '202609',
      modiQty: '10',
      bohQty: '0',
      ...over,
    }) as SaveCell;

  it('ADMIN payload 는 operationGroup 을 코드(P/A/E)로 보낸다 — 표시명 금지(ORA-12899 회피)', () => {
    const p = buildAdminPayload(
      [saveCell({ operationGroup: 'Pack' }), saveCell({ operationGroup: 'Cell' }), saveCell({ operationGroup: 'Electrode' })],
      '20260907',
      'tester'
    );
    expect(p?.operationGroup).toBe('P^A^E');
  });

  it('일반 payload 는 operationGroup 을 표시명 그대로 보낸다 (일반 SP 가 내부 변환)', () => {
    const p = buildGeneralPayload([saveCell({ operationGroup: 'Pack' })], '20260907', 'tester');
    expect(p?.operationGroup).toBe('Pack');
  });
});
