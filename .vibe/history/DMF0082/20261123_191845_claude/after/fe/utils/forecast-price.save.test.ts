import { describe, expect, it } from 'vitest';

import type { EditTracker } from '@foundation/utils';

import { buildSavePayload, buildSaveRows, duplicateKeyOf } from './forecast-price.save';

// DMF0082_SAVE_MAIN_DATA payload 구성 — 17 IN '^' bulk.
//   AS_FROM_SITE 슬롯 분리(2026-08-03)와 M+4 동결 필터가 회귀 지점이다.

const M4_DAY = 'D_20260610'; // 202606 — cutoff 이하 = 동결
const OPEN_DAY = 'D_20261110'; // 202611 — 개방
const DAYS = [M4_DAY, OPEN_DAY];
const CUTOFF = '202609';

const row = (overrides: Record<string, unknown> = {}): WijmoRowItem =>
  ({
    DIVISION_ID: '81',
    PROJECT_CODE: 'P1',
    END_CUSTOMER: 'IM',
    SCM_SITE_ID: 'CUST-SITE',
    ITEM_ID: 'APCCA2791A',
    DOM_EXP: 'E',
    FCST_TYPE: 'WS(Chargeable)',
    INCOTERMS: 'FCA',
    MEASURE: 'MKT_FCST',
    PLANT_SITE_ID: 'WA00-P',
    AS_FROM_SITE: 'WA00-81-AS',
    CELL_PROD_SITE_ID: 'Common',
    CURRENCY: '',
    [M4_DAY]: 10,
    [OPEN_DAY]: 20,
    ...overrides,
  }) as unknown as WijmoRowItem;

/** 변경분 없는 tracker (Insert/Delete 경로만 볼 때). */
const emptyTracker = { getOriginalValues: () => new Map() } as unknown as EditTracker;

describe('buildSaveRows — AS_FROM_SITE 슬롯', () => {
  it('행의 AS_FROM_SITE 를 저장 row 에 싣는다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS);
    expect(rows.length).toBeGreaterThan(0);
    expect(rows[0].asFromSite).toBe('WA00-81-AS');
  });

  it('값이 없으면 공란 — NULL 이 아닌 빈 문자열로 나간다 (MERGE 비교값 유지)', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I', AS_FROM_SITE: undefined })], emptyTracker, DAYS);
    expect(rows[0].asFromSite).toBe('');
  });

  // p_as_from_site / p_plant_site_id 는 각각 제 슬롯으로 간다 (2026-08-03 이전엔 하나에 실었다).
  it('plantSite 와 asFromSite 가 서로 다른 키로 payload 에 실린다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, [OPEN_DAY]);
    const payload = buildSavePayload(rows, 'tester');
    expect(payload.plantSite).toBe('WA00-P');
    expect(payload.asFromSite).toBe('WA00-81-AS');
    expect(Object.keys(payload)).toHaveLength(17);
  });

  it('값 안에 캐럿(행 구분자)을 넣지 않는다 — 넣으면 행 경계가 깨진다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS);
    expect(buildSavePayload(rows, 'tester').asFromSite).not.toContain('^^');
  });
});

describe('buildSaveRows — M+4 동결 필터', () => {
  it('Insert: 동결 구간 일자는 저장 rows 에서 빠진다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS, CUTOFF, 'M');
    expect(rows.map(r => r.yyyymmdd)).toEqual(['20261110']);
  });

  // Delete 는 값 유무와 무관하게 편집가능 일자 전량에 0 을 쓴다 — 필터가 없으면 동결 구간 실적이 지워진다.
  it('Delete: 동결 구간에 0 을 쓰지 않는다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'D' })], emptyTracker, DAYS, CUTOFF, 'M');
    expect(rows.map(r => r.yyyymmdd)).toEqual(['20261110']);
    expect(rows.every(r => r.activeFlag === 'D' && r.qty === '0')).toBe(true);
  });

  it('Modify: 동결 구간 변경분은 저장에서 제외한다', () => {
    const item = row({ CRUD_TYPE: 'M' });
    const tracker = {
      getOriginalValues: () => new Map([[item, { [M4_DAY]: 0, [OPEN_DAY]: 0 }]]),
    } as unknown as EditTracker;
    const rows = buildSaveRows([item], tracker, DAYS, CUTOFF, 'M');
    expect(rows.map(r => r.yyyymmdd)).toEqual(['20261110']);
  });

  // 현업 검수 40번 — M+4 동결은 Monthly 한정. Weekly/Daily 는 편집이 열리므로 저장도 열려야 한다.
  it('Daily 버킷은 동결 구간도 저장한다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS, CUTOFF, 'D');
    expect(rows.map(r => r.yyyymmdd)).toEqual(['20260610', '20261110']);
  });

  it('Weekly 버킷은 동결 구간도 저장한다', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS, CUTOFF, 'W');
    expect(rows.map(r => r.yyyymmdd)).toEqual(['20260610', '20261110']);
  });

  it('M+4 대상이 아닌 measure(LOC)는 동결 구간도 저장한다', () => {
    const rows = buildSaveRows(
      [row({ CRUD_TYPE: 'I', MEASURE: 'LOC' })],
      emptyTracker,
      DAYS,
      CUTOFF,
      'M'
    );
    expect(rows).toHaveLength(2);
  });

  it('cutoff 미수신이면 필터하지 않는다 (fail-open)', () => {
    const rows = buildSaveRows([row({ CRUD_TYPE: 'I' })], emptyTracker, DAYS, '', 'M');
    expect(rows).toHaveLength(2);
  });
});

describe('duplicateKeyOf', () => {
  it('81 계열은 PlantSite 를 키에 포함한다', () => {
    expect(duplicateKeyOf(row())).not.toBe(duplicateKeyOf(row({ PLANT_SITE_ID: 'WA01-P' })));
  });

  it('40 은 PlantSite 를 키에서 제외한다 (AS-IS L4913~4956)', () => {
    const r40 = { DIVISION_ID: '40' };
    expect(duplicateKeyOf(row(r40))).toBe(duplicateKeyOf(row({ ...r40, PLANT_SITE_ID: 'WA01-P' })));
  });

  it('AS_FROM_SITE 는 전 division 공통으로 키에 들어간다', () => {
    expect(duplicateKeyOf(row())).not.toBe(duplicateKeyOf(row({ AS_FROM_SITE: '' })));
  });

  // 통화는 식별자가 아니라 값 — 가격 통화는 MEASURE 로 갈린다 (Unit Price(KRW)/(USD)/(LOC)).
  it('CURRENCY 는 키에 넣지 않는다', () => {
    expect(duplicateKeyOf(row())).toBe(duplicateKeyOf(row({ CURRENCY: 'USD' })));
  });

  // NICK_NAME 은 시드 복사 대상이 아니라 신규행에서 늘 공란 — 키에 넣으면 검사가 구조적으로 빗나간다.
  it('NICK_NAME 은 키에 넣지 않는다 (2026-08-05 사고)', () => {
    expect(duplicateKeyOf(row())).toBe(duplicateKeyOf(row({ NICK_NAME: 'anything' })));
  });

  it('행에 DIVISION_ID 가 없으면 인자 divisionId 로 폴백한다', () => {
    expect(duplicateKeyOf(row({ DIVISION_ID: '' }), '81')).toBe(duplicateKeyOf(row()));
  });

  // 구분자가 없으면 ('AB','C') 와 ('A','BC') 가 같은 키로 이어붙어 오탐이 난다.
  it('키 조각 경계가 구분자로 분리된다', () => {
    expect(duplicateKeyOf(row({ ITEM_ID: 'AB', DOM_EXP: 'C' }))).not.toBe(
      duplicateKeyOf(row({ ITEM_ID: 'A', DOM_EXP: 'BC' }))
    );
  });
});
