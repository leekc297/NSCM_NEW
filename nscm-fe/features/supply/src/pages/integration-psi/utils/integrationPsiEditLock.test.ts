import { describe, expect, it } from 'vitest';

import {
  type AuthContext,
  type EditLockContext,
  hasEditAuth,
  INSERT_ROW_ONLY_EDITABLE,
  isBohCellEditable,
  isEssGreenCell,
  isInsertRowCellEditable,
  isPivotCellValueEmpty,
} from './integrationPsiEditLock';

const GENERAL: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: false };
const PLANNER: AuthContext = { isAdmin: false, isPiAdmin: false, isPlanner: true };
const PI_ADMIN: AuthContext = { isAdmin: false, isPiAdmin: true, isPlanner: false };
const ADMIN: AuthContext = { isAdmin: true, isPiAdmin: false, isPlanner: false };

const ctxOf = (auth: AuthContext, division = '81'): EditLockContext => ({
  division,
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

// BOH_QTY 편집 — AS-IS EditButton 권한 2-분기 + division별 해제 조건.
//   권한: ADMIN=전 행 / SCM PI Admin·SCP Planner=조건부 / 일반=불가 (cs:573 / cs:564-565).
//   해제 조건(AND 아님): ESS(82)=measure==INV(L17, cs:789) / 비ESS·소형=measureFlag==6(L8/L12, cs:650/692).
describe('isBohCellEditable — 권한 2-분기 + division별 해제 조건', () => {
  const invMf6 = { MEASURE: 'INV', SEQ_FLAG: '160' }; // INV & measureFlag=6
  const invMf0 = { MEASURE: 'INV', SEQ_FLAG: '100' }; // INV & measureFlag≠6 (ESS 핵심 케이스)
  const prodMf6 = { MEASURE: 'PROD_PLAN', SEQ_FLAG: '160' }; // 비INV & measureFlag=6
  const prodRow = { MEASURE: 'PROD_PLAN', SEQ_FLAG: '150' }; // 비INV & measureFlag≠6

  it('ADMIN(System Administrator)은 division·measure 무관 전 행 BOH 편집(cs:573 분기)', () => {
    expect(isBohCellEditable(invMf0, ctxOf(ADMIN, '82'))).toBe(true);
    expect(isBohCellEditable(prodRow, ctxOf(ADMIN, '81'))).toBe(true);
  });

  // ESS(82): measure==INV 이면 seqFlag(measureFlag) 무관하게 편집 — AS-IS cs:789 (L17).
  it('ESS: SCM PI Admin 은 INV 행 전부 편집(measureFlag≠6 포함)', () => {
    expect(isBohCellEditable(invMf6, ctxOf(PI_ADMIN, '82'))).toBe(true);
    expect(isBohCellEditable(invMf0, ctxOf(PI_ADMIN, '82'))).toBe(true); // 버그 수정 핵심
    expect(isBohCellEditable(prodMf6, ctxOf(PI_ADMIN, '82'))).toBe(false); // 비INV 는 제외
  });

  it('ESS: SCP Planner 도 INV 행 전부 편집', () => {
    expect(isBohCellEditable(invMf0, ctxOf(PLANNER, '82'))).toBe(true);
  });

  // 비ESS·소형: measureFlag==6 이면 measure 무관하게 편집 — AS-IS cs:650/692 (L8/L12).
  it('비ESS(81): measureFlag==6 행 편집(measure 무관), measureFlag≠6 은 제외', () => {
    expect(isBohCellEditable(invMf6, ctxOf(PI_ADMIN, '81'))).toBe(true);
    expect(isBohCellEditable(prodMf6, ctxOf(PI_ADMIN, '81'))).toBe(true); // mf6 이면 비INV 도 해제
    expect(isBohCellEditable(invMf0, ctxOf(PI_ADMIN, '81'))).toBe(false); // mf≠6 은 제외
  });

  it('소형(40): 비ESS 와 동일 — measureFlag==6 기준', () => {
    expect(isBohCellEditable(invMf6, ctxOf(PLANNER, '40'))).toBe(true);
    expect(isBohCellEditable(invMf0, ctxOf(PLANNER, '40'))).toBe(false);
  });

  it('일반 유저는 권한이 없어 어느 division 에서도 BOH 편집 불가', () => {
    expect(isBohCellEditable(invMf6, ctxOf(GENERAL, '82'))).toBe(false);
    expect(isBohCellEditable(invMf6, ctxOf(GENERAL, '81'))).toBe(false);
  });
});

// 조건부 배경색 C1/C2 — AS-IS SetBGColor2 연두(140,240,60) (SCP0111_IntegrationPSI.cs cs:757/782).
//   C1: ESS PROD_PLAN & seqFlag[0]=2. C2: ESS IN_HOUSE_MOVING & seqFlag[0]=3 & TO_PRODUCT 유효 &
//   VALUE_TYPE≠'-' & PROD_PLAN 페어 존재(prodPlanItemIds).
describe('isEssGreenCell — ESS C1/C2 연두 판정', () => {
  const PROD_PAIR = new Set(['ITEM_A']); // ITEM_A 의 PROD_PLAN 행이 존재

  it('C1: ESS PROD_PLAN & seqFlag[0]=2 는 연두', () => {
    expect(isEssGreenCell({ MEASURE: 'PROD_PLAN', SEQ_FLAG: '25' }, '82', PROD_PAIR)).toBe(true);
  });

  it('C1: seqFlag[0]≠2 인 PROD_PLAN 은 연두 아님', () => {
    expect(isEssGreenCell({ MEASURE: 'PROD_PLAN', SEQ_FLAG: '15' }, '82', PROD_PAIR)).toBe(false);
  });

  it('C2: IN_HOUSE_MOVING & seqFlag[0]=3 & TO_PRODUCT 페어 존재 & VALUE_TYPE≠"-" 는 연두', () => {
    expect(
      isEssGreenCell(
        { MEASURE: 'IN_HOUSE_MOVING', SEQ_FLAG: '35', TO_PRODUCT: 'ITEM_A', VALUE_TYPE: 'PRD' },
        '82',
        PROD_PAIR
      )
    ).toBe(true);
  });

  it('C2: PROD_PLAN 페어가 없으면 연두 아님', () => {
    expect(
      isEssGreenCell(
        { MEASURE: 'IN_HOUSE_MOVING', SEQ_FLAG: '35', TO_PRODUCT: 'ITEM_X', VALUE_TYPE: 'PRD' },
        '82',
        PROD_PAIR
      )
    ).toBe(false);
  });

  it('C2: VALUE_TYPE="-" 이면 연두 아님(cs:765)', () => {
    expect(
      isEssGreenCell(
        { MEASURE: 'IN_HOUSE_MOVING', SEQ_FLAG: '35', TO_PRODUCT: 'ITEM_A', VALUE_TYPE: '-' },
        '82',
        PROD_PAIR
      )
    ).toBe(false);
  });

  it('C2: TO_PRODUCT 가 "-"/공백이면 연두 아님(cs:765)', () => {
    expect(
      isEssGreenCell(
        { MEASURE: 'IN_HOUSE_MOVING', SEQ_FLAG: '35', TO_PRODUCT: '-', VALUE_TYPE: 'PRD' },
        '82',
        PROD_PAIR
      )
    ).toBe(false);
  });

  it('ESS(82)가 아니면 연두 아님', () => {
    expect(isEssGreenCell({ MEASURE: 'PROD_PLAN', SEQ_FLAG: '25' }, '81', PROD_PAIR)).toBe(false);
  });
});

// 관리컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 가시성 = ADMIN 전용 (AS-IS SetVisibleSheetColumns cs:594).
//   SCM PI Admin/SCP Planner 는 BOH 편집권한이 있어도 관리컬럼은 못 본다.
describe('hasEditAuth — 관리컬럼 가시성은 ADMIN 전용', () => {
  it('ADMIN 만 관리컬럼을 노출한다', () => {
    expect(hasEditAuth(ADMIN)).toBe(true);
    expect(hasEditAuth(PI_ADMIN)).toBe(false);
    expect(hasEditAuth(PLANNER)).toBe(false);
    expect(hasEditAuth(GENERAL)).toBe(false);
  });
});
