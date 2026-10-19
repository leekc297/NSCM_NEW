import { describe, expect, it } from 'vitest';

import { DIVISION_CODE, TABS } from '../workbench.constants';

import { isCellEditable, isInsertRow, isRowDeletable } from './workbench.editLock';

// design 01_layout.md §4 의 편집 검증축(V10~V14) + 03_grid-columns.md §5.3(E-1~E-5)을 고정한다.
//   AS-IS 근거 cs 라인은 workbench.editLock.ts 머리말 주석 참조(LockRange 상수 이식 금지 — hook #130).
//
// 4번째 인자는 규범 convert-core §2.4 적용 후 `canEdit`(= `hasButton('EDIT')`) 이다 — AS-IS 의
//   Edit 모드 토글이 아니라 화면 오픈 시 1회 확정되는 권한축이다(iter-3, goal.md §8).

const existing = (patch: Record<string, unknown> = {}) => ({
  DIVISION_ID: '81',
  CHG_TYPE: '',
  ...patch,
});

const inserted = (patch: Record<string, unknown> = {}) => ({
  CRUD_TYPE: 'I',
  DIVISION_ID: '81',
  CHG_TYPE: 'New',
  ...patch,
});

describe('isInsertRow', () => {
  it('CRUD_TYPE=I 만 신규행 (자체 행상태 필드 신설 금지)', () => {
    expect(isInsertRow(inserted())).toBe(true);
    expect(isInsertRow(existing())).toBe(false);
    expect(isInsertRow(undefined)).toBe(false);
  });
});

describe('isCellEditable — EDIT 권한 없으면 전열 읽기전용(규범 §2.4 — AS-IS R07/V10 모드 잠금 대체)', () => {
  it('canEdit=false 면 CHG_QTY 조차 잠금', () => {
    for (const tab of [TABS.MKT_FCST, TABS.STOCK, TABS.ELEC_DEMAND]) {
      expect(isCellEditable(tab, 'CHG_QTY', existing(), false, '81')).toBe(false);
      expect(isCellEditable(tab, 'CHG_RSN', inserted(), false, '81')).toBe(false);
    }
  });
});

describe('isCellEditable — (E-1) 권한 있는 기존행은 5시트 전부 CHG_QTY·CHG_RSN 2개만', () => {
  const tabs = [
    TABS.MKT_FCST,
    TABS.STOCK,
    TABS.STOCK_ELEC,
    TABS.ELEC_DEMAND,
    TABS.STOCK_2ND_OCV,
  ];

  it('CHG_QTY / CHG_RSN 만 편집 가능', () => {
    for (const tab of tabs) {
      expect(isCellEditable(tab, 'CHG_QTY', existing(), true, '81')).toBe(true);
      expect(isCellEditable(tab, 'CHG_RSN', existing(), true, '81')).toBe(true);
    }
  });

  it('그 밖의 컬럼은 전부 잠금 (PRE_CHG_* 포함 — AS-IS 누락은 재현하지 않는다, §5 K4)', () => {
    for (const tab of tabs) {
      for (const binding of [
        'DIVISION_ID',
        'ITEM_ID',
        'QTY',
        'CHG_TYPE',
        'LAST_UPDATE_DATE',
        'PRE_CHG_QTY',
        'PRE_CHG_RSN',
      ]) {
        expect(isCellEditable(tab, binding, existing(), true, '81')).toBe(false);
      }
    }
  });
});

describe('isCellEditable — (E-2) 신규행 white-list', () => {
  it('MKT FCST 신규행: white-list 안은 열리고 잠금 컬럼은 닫힌다', () => {
    for (const binding of ['CUTOFF_YYYYMMDD', 'SCM_SITE_ID', 'DUE_DATE', 'CHG_QTY']) {
      expect(isCellEditable(TABS.MKT_FCST, binding, inserted(), true, '81')).toBe(true);
    }
    for (const binding of ['DIVISION_ID', 'VERSION_NO', 'NICK_NAME', 'FCST_TYPE', 'QTY']) {
      expect(isCellEditable(TABS.MKT_FCST, binding, inserted(), true, '81')).toBe(false);
    }
  });

  it('Elec. Demand 신규행: OPERATION_ID 는 파생 전용이라 잠금(G31)', () => {
    expect(isCellEditable(TABS.ELEC_DEMAND, 'LINE_ID', inserted(), true, '81')).toBe(true);
    expect(isCellEditable(TABS.ELEC_DEMAND, 'PLANT_SITE_ID', inserted(), true, '81')).toBe(true);
    expect(isCellEditable(TABS.ELEC_DEMAND, 'OPERATION_ID', inserted(), true, '81')).toBe(false);
    expect(isCellEditable(TABS.ELEC_DEMAND, 'SEQ', inserted(), true, '81')).toBe(false);
  });

  it('Stock(2nd OCV) 신규행: OPERATION_ID 는 자유입력(열림), OPERATION_NAME 은 잠금(G37)', () => {
    expect(isCellEditable(TABS.STOCK_2ND_OCV, 'OPERATION_ID', inserted(), true, '81')).toBe(true);
    expect(isCellEditable(TABS.STOCK_2ND_OCV, 'OPERATION_NAME', inserted(), true, '81')).toBe(
      false
    );
  });

  it('Stock(Elec. Plant) 신규행: LOCATION_CODE 열림 / LINE_ID·BEFORE_DEGAS 는 컬럼 자체 없음', () => {
    expect(isCellEditable(TABS.STOCK_ELEC, 'LOCATION_CODE', inserted(), true, '81')).toBe(true);
    expect(isCellEditable(TABS.STOCK_ELEC, 'LINE_ID', inserted(), true, DIVISION_CODE.UC)).toBe(
      false
    );
    expect(isCellEditable(TABS.STOCK_ELEC, 'BEFORE_DEGAS', inserted(), true, DIVISION_CODE.UC)).toBe(
      false
    );
  });
});

describe('isCellEditable — (E-5) 조건부 잠금 2건', () => {
  it('MKT FCST CELL_PROD_SITE_ID: division=40 만 편집 (G16)', () => {
    expect(
      isCellEditable(TABS.MKT_FCST, 'CELL_PROD_SITE_ID', inserted(), true, DIVISION_CODE.SMALL)
    ).toBe(true);
    expect(isCellEditable(TABS.MKT_FCST, 'CELL_PROD_SITE_ID', inserted(), true, '81')).toBe(false);
  });

  it('STOCK LINE_ID / BEFORE_DEGAS: division=81_UC 만 편집 (V3/V4)', () => {
    for (const binding of ['LINE_ID', 'BEFORE_DEGAS']) {
      expect(isCellEditable(TABS.STOCK, binding, inserted(), true, DIVISION_CODE.UC)).toBe(true);
      expect(isCellEditable(TABS.STOCK, binding, inserted(), true, '81')).toBe(false);
    }
  });

  it('STOCK 의 나머지 신규행 컬럼은 division 과 무관하게 열린다', () => {
    for (const binding of ['STOCK_TYPE_NAME', 'SCM_SITE_ID', 'INV_DATE', 'INCOTERMS']) {
      expect(isCellEditable(TABS.STOCK, binding, inserted(), true, '81')).toBe(true);
    }
  });
});

describe('isRowDeletable — (V17/V18/D11) 원본행 삭제 금지', () => {
  it('CHG_TYPE 이 비면 삭제 불가', () => {
    expect(isRowDeletable(existing())).toBe(false);
    expect(isRowDeletable(existing({ CHG_TYPE: '   ' }))).toBe(false);
    expect(isRowDeletable(undefined)).toBe(false);
  });

  it('CHG_TYPE 이 \'New\' / \'Change\' 면 삭제 가능', () => {
    expect(isRowDeletable(inserted())).toBe(true);
    expect(isRowDeletable(existing({ CHG_TYPE: 'Change' }))).toBe(true);
  });
});
