import { describe, expect, it } from 'vitest';

import {
  type AuthContext,
  INSERT_ROW_ONLY_EDITABLE,
  isInsertRowCellEditable,
} from './integrationPsiEditLock';

const GENERAL: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: false };
const PLANNER: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: true };
const ADMIN: AuthContext = { isAdmin: true, isPiAdmin: false, isPlanner: false };

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
