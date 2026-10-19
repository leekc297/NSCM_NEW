import { describe, expect, it } from 'vitest';

import type { EditTracker } from '@foundation/utils';

import { buildFixRows, buildSavePayload, buildSaveRows } from './shipment-plan-fg.save';

// 래퍼 SP(F_SCP0009_JSON_TO_COLLECTION)의 JSON_TABLE 경로 `$.xxx` 와 같아야 한다(PKG_SCP0009 본문 5782~5808행).
const WRAPPER_JSON_KEYS = [
  'a', 'activeFlag', 'divisionId', 'planStartYyyymmdd', 'planType', 'seq', 'bizType', 'projectCode', 'itemId',
  'toSite', 'incoterms', 'fromSite', 'bodId', 'measure', 'yyyymmdd', 'qty', 'originFromDivisionId',
  'originToDivisionId', 'electrodeType', 'fixReason', 'bucketType', 'transMode', 'createdBy', 'lastUpdatedBy',
  'timeZone', 'debugMode',
];

describe('buildSavePayload', () => {
  it('행 배열을 data 키로 감싸고 행의 키 26개가 래퍼 SP 의 JSON 경로와 일치한다', () => {
    const row = { MEASURE: 'SHIP_PLAN_AMEND', DIVISION_ID: '40', ITEM_ID: 'I1', D_20260209: 5 };
    const rows = buildFixRows([{ row, binding: 'D_20260209' }], {
      userId: 'U',
      timeZone: '',
      fixReason: 'why',
      activeFlag: 'I',
      planStartYyyymmdd: '20260209',
      planType: 'PR',
      seq: '2',
      bucketType: 'WEEKLY',
    });

    const payload = buildSavePayload(rows);

    expect(Object.keys(payload)).toEqual(['data']);
    expect(payload.data).toHaveLength(1);
    expect(Object.keys(payload.data[0]).sort()).toEqual([...WRAPPER_JSON_KEYS].sort());
  });
});

describe('buildSaveRows', () => {
  // 조회 SP 응답 키는 전부 대문자다(06_column_name_upper.sql) — 정보컬럼 값이 빈 문자열로 새지 않아야 한다.
  it('대문자 응답 키에서 식별 필드를 모두 채운다', () => {
    const row = {
      DIVISION_ID: '40', BIZ_TYPE: 'P', PROJECT_CODE: 'PJ', ITEM_ID: 'I1', TO_SITE: 'T1', INCOTERMS: 'FOB',
      FROM_SITE: 'F1', BOD_ID: 'B1', MEASURE: 'SHIP_PLAN_AMEND', ORIGIN_FROM_DIVISION_ID: 'EE1',
      ORIGIN_TO_DIVISION_ID: 'EE2', ELECTRODE_TYPE: 'A', PLAN_START_YYYYMMDD: '20260209', PLAN_TYPE: 'PR',
      SEQ: '2', TRANSPORT_MODE: 'SEA', D_20260209: 5,
    };
    const tracker = { getOriginalValues: () => new Map([[row, { D_20260209: 3 }]]) } as unknown as EditTracker;

    const [r] = buildSaveRows(tracker, 'U', '');

    expect(r).toMatchObject({
      activeFlag: 'M', divisionId: '40', bizType: 'P', projectCode: 'PJ', itemId: 'I1', toSite: 'T1',
      incoterms: 'FOB', fromSite: 'F1', bodId: 'B1', measure: 'SHIP_PLAN_AMEND', originFromDivisionId: 'EE1',
      originToDivisionId: 'EE2', electrodeType: 'A', planStartYyyymmdd: '20260209', planType: 'PR', seq: '2',
      transMode: 'SEA', yyyymmdd: '20260209', qty: '5', bucketType: 'DAILY', createdBy: 'U',
    });
    const emptyKeys = Object.entries(r).filter(([k, v]) => v === '' && !['a', 'fixReason', 'timeZone'].includes(k));
    expect(emptyKeys).toEqual([]);
  });
});
