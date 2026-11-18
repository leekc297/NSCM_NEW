import { describe, expect, it } from 'vitest';

import {
  type AuthContext,
  type EditLockContext,
  INSERT_ROW_ONLY_EDITABLE,
  isBohCellEditable,
  isInsertRowCellEditable,
  isPivotCellValueEmpty,
} from './integrationPsiEditLock';

const GENERAL: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: false };
const PLANNER: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: true };
const ADMIN: AuthContext = { isAdmin: true, isPiAdmin: false, isPlanner: false };

const ctxOf = (auth: AuthContext): EditLockContext => ({
  division: '81',
  auth,
  multiChildItems: new Set<string>(),
});

// AS-IS InsertRow 가 삽입 직후 거는 LockRange:
//   일반(cs:1054) PLAN_TYPE..VALUE_TYPE + (cs:1057) TO_SITE_DESCRIPTION..마지막컬럼(= YYYYMM 월 컬럼 포함)
//   → 메타 SORT_ORDER 상 두 범위 사이에 남는 칸은 LINE_ID(130) 하나뿐.
//   ADMIN(cs:976) 은 DIVISION_ID 만 잠금.
describe('isInsertRowCellEditable — 신규행 잠금', () => {
  it('일반 유저는 LINE_ID 만 편집 가능하다', () => {
    expect(isInsertRowCellEditable('LINE_ID', GENERAL)).toBe(true);
    expect(INSERT_ROW_ONLY_EDITABLE).toBe('LINE_ID');
  });

  it('일반 유저는 기간(월) 수량칸을 입력할 수 없다 — 사용자 확인 2026-10-13', () => {
    for (const ym of ['202608', '202609', '202702', '202708']) {
      expect(isInsertRowCellEditable(ym, GENERAL)).toBe(false);
    }
  });

  it('일반 유저는 BOH_QTY·식별열도 전부 잠긴다(cs:1054/1057 두 범위)', () => {
    const locked = [
      'PLAN_TYPE',
      'DIVISION_ID',
      'OPERATION_GROUP',
      'CELL_ITEM_ID',
      'ITEM_ID',
      'VALUE_TYPE',
      'TO_SITE_DESCRIPTION',
      'INCOTERMS',
      'BOH_QTY',
      'UOM',
      'SEQ_FLAG',
      'MEASURE',
      'PLANT_ID',
      'TO_SITE',
    ];
    for (const col of locked) {
      expect(isInsertRowCellEditable(col, GENERAL)).toBe(false);
    }
  });

  it('SCP Planner 도 ADMIN 이 아니므로 일반 규칙을 따른다', () => {
    expect(isInsertRowCellEditable('202609', PLANNER)).toBe(false);
    expect(isInsertRowCellEditable('LINE_ID', PLANNER)).toBe(true);
  });

  it('ADMIN 은 DIVISION_ID 만 잠기고 나머지는 전부 열린다(cs:976)', () => {
    expect(isInsertRowCellEditable('DIVISION_ID', ADMIN)).toBe(false);
    for (const col of ['202609', 'BOH_QTY', 'ITEM_ID', 'LINE_ID', 'MEASURE']) {
      expect(isInsertRowCellEditable(col, ADMIN)).toBe(true);
    }
  });
});

// AS-IS 셀단위 빈값 잠금 (design 03 §3-Lock L4/L9/L13/L18 — qty=='' → month 셀 잠금).
//   편집 가능 측정값 행이라도 그 달 값이 없으면 잠금 → 값 있는 셀만 편집. 0 은 값이 있는 것.
describe('isPivotCellValueEmpty — AS-IS 셀단위 빈값 잠금', () => {
  it('값이 없는(undefined/null/"") 셀은 빈값으로 본다', () => {
    expect(isPivotCellValueEmpty({}, '202610')).toBe(true);
    expect(isPivotCellValueEmpty({ '202610': undefined }, '202610')).toBe(true);
    expect(isPivotCellValueEmpty({ '202610': null }, '202610')).toBe(true);
    expect(isPivotCellValueEmpty({ '202610': '' }, '202610')).toBe(true);
  });

  it('0 은 값이 있는 것으로 보고 편집 허용한다(AS-IS qty=="" 비교, 0≠"")', () => {
    expect(isPivotCellValueEmpty({ '202610': 0 }, '202610')).toBe(false);
  });

  it('숫자/문자 값이 있으면 빈값이 아니다', () => {
    expect(isPivotCellValueEmpty({ '202610': 23 }, '202610')).toBe(false);
    expect(isPivotCellValueEmpty({ '202610': -8 }, '202610')).toBe(false);
    expect(isPivotCellValueEmpty({ '202610': '5' }, '202610')).toBe(false);
  });
});

// BOH_QTY 편집 — AS-IS EditButton 권한 2-분기 (SCP0111_IntegrationPSI.cs cs:573 / cs:650-652).
describe('isBohCellEditable — BOH 권한 2-분기', () => {
  const invRow = { MEASURE: 'INV', SEQ_FLAG: '160' }; // measureFlag=6
  const prodRow = { MEASURE: 'PROD_PLAN', SEQ_FLAG: '150' }; // non-INV

  it('ADMIN(System Administrator)은 전 행 BOH 편집 가능(cs:573 분기)', () => {
    expect(isBohCellEditable(invRow, ctxOf(ADMIN))).toBe(true);
    expect(isBohCellEditable(prodRow, ctxOf(ADMIN))).toBe(true); // 비-INV 행도 편집
  });

  it('SCP Planner 는 INV(measureFlag=6) 행만 편집(cs:650-652 isEdit)', () => {
    expect(isBohCellEditable(invRow, ctxOf(PLANNER))).toBe(true);
    expect(isBohCellEditable(prodRow, ctxOf(PLANNER))).toBe(false);
  });

  it('일반 유저는 BOH 편집 불가', () => {
    expect(isBohCellEditable(invRow, ctxOf(GENERAL))).toBe(false);
    expect(isBohCellEditable(prodRow, ctxOf(GENERAL))).toBe(false);
  });
});
