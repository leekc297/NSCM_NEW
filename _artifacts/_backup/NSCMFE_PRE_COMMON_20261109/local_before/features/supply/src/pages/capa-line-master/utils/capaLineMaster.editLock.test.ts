import { describe, expect, it } from 'vitest';

import type { DrillContext } from '../capa-line-master.types';

import {
  buildInsertRow,
  canDrillDown,
  hasParentContext,
  isCellEditable,
  isDummyRow,
  isInsertRow,
  nextSortOrder,
} from './capaLineMaster.editLock';

// design 03_grid-columns §5-3 의 편집 파리티 (a)~(e) 를 그대로 검증 축으로 삼는다.
//   (a) 조회 직후 전열 읽기전용 / (b) DUMMY_YN='N' 행 편집 불가 / (c) DUMMY_YN='Y' 편집모드 행은
//   자기레벨 NAME(+L5 VALID_YN) 만 / (d) ID 는 신규행에서만 / (e) DIVISION_ID·DUMMY_YN·SHOP_GROUP_ID 항상 잠금.
//   AS-IS 근거는 editLock.ts 머리말의 cs 라인 주석 참조(LockRange 상수 이식 금지 — hook #130).

const dummyRow = (patch: Record<string, unknown> = {}) => ({
  DIVISION_ID: '81',
  DUMMY_YN: 'Y',
  ...patch,
});

const fpRow = (patch: Record<string, unknown> = {}) => ({
  DIVISION_ID: '81',
  DUMMY_YN: 'N',
  ...patch,
});

describe('isCellEditable — (e) 항상 잠금 컬럼', () => {
  it('DIVISION_ID / DUMMY_YN / SORT_ORDER 는 편집모드·dummy 행에서도 잠금', () => {
    for (const binding of ['DIVISION_ID', 'DUMMY_YN', 'SORT_ORDER']) {
      expect(isCellEditable(1, binding, dummyRow(), 1)).toBe(false);
    }
  });

  it('SHOP_GROUP_ID 는 L5 편집모드에서도 잠금 (cs:650/658)', () => {
    expect(isCellEditable(5, 'SHOP_GROUP_ID', dummyRow(), 5)).toBe(false);
    expect(isCellEditable(5, 'SHOP_GROUP_ID', dummyRow({ CRUD_TYPE: 'I' }), 5)).toBe(false);
  });

  it('row/binding 이 없으면 편집 불가', () => {
    expect(isCellEditable(1, 'SITE_NAME', undefined, 1)).toBe(false);
    expect(isCellEditable(1, '', dummyRow(), 1)).toBe(false);
  });
});

describe('isCellEditable — (a) 조회 직후 전열 읽기전용', () => {
  it('편집모드가 아니면(null) dummy 행이어도 전열 잠금', () => {
    expect(isCellEditable(1, 'SITE_NAME', dummyRow(), null)).toBe(false);
    expect(isCellEditable(5, 'VALID_YN', dummyRow(), null)).toBe(false);
  });

  it('다른 레벨이 편집중이면 이 레벨은 전열 잠금 (동시 1개, cs:490~502)', () => {
    expect(isCellEditable(2, 'COMPANY_NAME', dummyRow(), 3)).toBe(false);
  });
});

describe('isCellEditable — (b) DUMMY_YN=N 행은 편집모드여도 전열 잠금', () => {
  it('FP 인터페이스 유입 행은 자기 NAME 도 잠금 (업무규칙 4)', () => {
    expect(isCellEditable(1, 'SITE_NAME', fpRow(), 1)).toBe(false);
    expect(isCellEditable(4, 'FACTORY_NAME', fpRow(), 4)).toBe(false);
    expect(isCellEditable(5, 'VALID_YN', fpRow(), 5)).toBe(false);
  });
});

describe('isCellEditable — (c) dummy 행 편집모드는 자기레벨 NAME 만', () => {
  const levelNameColumn = {
    1: 'SITE_NAME',
    2: 'COMPANY_NAME',
    3: 'PLANT_NAME',
    4: 'FACTORY_NAME',
    5: 'LINE_NAME',
  } as const;

  it('레벨별 자기 NAME 만 열린다', () => {
    for (const [level, nameColumn] of Object.entries(levelNameColumn)) {
      const lv = Number(level) as 1 | 2 | 3 | 4 | 5;
      expect(isCellEditable(lv, nameColumn, dummyRow(), lv)).toBe(true);
    }
  });

  it('부모레벨 NAME 은 자기 레벨에서 열리지 않는다', () => {
    expect(isCellEditable(3, 'SITE_NAME', dummyRow(), 3)).toBe(false);
    expect(isCellEditable(3, 'COMPANY_NAME', dummyRow(), 3)).toBe(false);
  });

  it('L5 는 VALID_YN 도 함께 열린다 (cs:652)', () => {
    expect(isCellEditable(5, 'VALID_YN', dummyRow(), 5)).toBe(true);
    // 다른 레벨의 VALID_YN 은 컬럼 자체가 없고, 있더라도 열리지 않는다.
    expect(isCellEditable(1, 'VALID_YN', dummyRow(), 1)).toBe(false);
  });
});

describe('isCellEditable — (d) ID 컬럼은 신규행에서만', () => {
  it('기존 dummy 행의 자기 ID 는 편집모드여도 잠금 (cs:530/559/588/617/648)', () => {
    expect(isCellEditable(1, 'SITE_ID', dummyRow(), 1)).toBe(false);
    expect(isCellEditable(5, 'LINE_ID', dummyRow(), 5)).toBe(false);
  });

  it('신규행(CRUD_TYPE=I)은 자기 ID + 자기 NAME 이 열린다 (cs:1265~1290)', () => {
    const inserted = dummyRow({ CRUD_TYPE: 'I' });
    expect(isCellEditable(2, 'COMPANY_ID', inserted, 2)).toBe(true);
    expect(isCellEditable(2, 'COMPANY_NAME', inserted, 2)).toBe(true);
  });

  it('신규행의 부모키는 상속값이라 잠금', () => {
    const inserted = dummyRow({ CRUD_TYPE: 'I' });
    expect(isCellEditable(3, 'SITE_ID', inserted, 3)).toBe(false);
    expect(isCellEditable(3, 'COMPANY_NAME', inserted, 3)).toBe(false);
  });

  it('신규행은 DUMMY_YN 값과 무관하게 자기 ID/NAME 이 열린다', () => {
    // 신규행은 항상 DUMMY_YN='Y' 로 생성되지만, 판정이 (b) 보다 먼저라 'N' 이어도 동일하다.
    const inserted = fpRow({ CRUD_TYPE: 'I' });
    expect(isCellEditable(1, 'SITE_ID', inserted, 1)).toBe(true);
  });
});

describe('isInsertRow / isDummyRow', () => {
  it('CRUD_TYPE 이 I 인 행만 신규행', () => {
    expect(isInsertRow({ CRUD_TYPE: 'I' })).toBe(true);
    expect(isInsertRow({ CRUD_TYPE: 'M' })).toBe(false);
    expect(isInsertRow(undefined)).toBe(false);
  });

  it('DUMMY_YN 이 Y 인 행만 수기 dummy 행', () => {
    expect(isDummyRow({ DUMMY_YN: 'Y' })).toBe(true);
    expect(isDummyRow({ DUMMY_YN: 'N' })).toBe(false);
    expect(isDummyRow({})).toBe(false);
  });
});

describe('canDrillDown — design 01 §2 L6 / 00 §4d #8~#12', () => {
  it('L5 는 최하위라 드릴다운 없음 (cs:1816~1833)', () => {
    expect(canDrillDown(5, 10, null)).toBe(false);
  });

  it('행이 0건이면 무동작 (cs:1745/1764/1781/1799)', () => {
    expect(canDrillDown(1, 0, null)).toBe(false);
  });

  it('해당 레벨이 편집중이면 억제 (Action 컬럼 visible 판정 등가)', () => {
    expect(canDrillDown(2, 5, 2)).toBe(false);
    // 다른 레벨이 편집중인 것은 억제 사유가 아니다.
    expect(canDrillDown(2, 5, 4)).toBe(true);
  });

  it('L1~L4 + 행 존재 + 비편집이면 허용', () => {
    expect(canDrillDown(1, 1, null)).toBe(true);
    expect(canDrillDown(4, 3, null)).toBe(true);
  });
});

describe('nextSortOrder — cs:1206~1212', () => {
  it('행이 없으면 1', () => {
    expect(nextSortOrder([])).toBe(1);
  });

  it('기존 최대값 + 1', () => {
    expect(nextSortOrder([{ SORT_ORDER: 3 }, { SORT_ORDER: 7 }, { SORT_ORDER: 5 }])).toBe(8);
  });

  it('문자열 숫자도 반영하고 비숫자는 무시한다', () => {
    expect(nextSortOrder([{ SORT_ORDER: '4' }, { SORT_ORDER: 'x' }, {}])).toBe(5);
  });
});

describe('hasParentContext — 미조회 삽입 차단 (convert-core §2.4)', () => {
  it('L1 은 부모키가 없어 항상 통과 (division 만 필요)', () => {
    expect(hasParentContext(1, {})).toBe(true);
  });

  it('부모키가 하나라도 비면 차단', () => {
    expect(hasParentContext(2, {})).toBe(false);
    expect(hasParentContext(2, { SITE_ID: 'A003' })).toBe(false);
  });

  it('레벨별 부모키가 전부 차 있으면 통과', () => {
    const drill: DrillContext = { SITE_ID: 'A003', SITE_NAME: 'Michigan' };
    expect(hasParentContext(2, drill)).toBe(true);
    // L3 은 COMPANY_* 까지 필요하다.
    expect(hasParentContext(3, drill)).toBe(false);
  });
});

describe('buildInsertRow — design 03 §3.3 R11~R17', () => {
  const drill: DrillContext = {
    SITE_ID: 'A003',
    SITE_NAME: 'Michigan',
    COMPANY_ID: 'MI00',
    COMPANY_NAME: 'MI Company',
    PLANT_ID: 'MI02',
    PLANT_NAME: 'MI Plant',
    FACTORY_ID: 'ET',
    FACTORY_NAME: 'ET Building',
  };

  it('공통 기본값 — CRUD_TYPE/division/VALID_YN/DUMMY_YN/SORT_ORDER (cs:1259~1262)', () => {
    const row = buildInsertRow(1, '81', 'E', {}, [{ SORT_ORDER: 2 }]);
    expect(row.CRUD_TYPE).toBe('I');
    expect(row.DIVISION_ID).toBe('81');
    expect(row.VALID_YN).toBe('Y');
    expect(row.DUMMY_YN).toBe('Y');
    expect(row.SORT_ORDER).toBe(3);
  });

  it('자기 레벨 ID/NAME 은 빈 값으로 시작한다', () => {
    const row = buildInsertRow(1, '81', 'E', {}, []);
    expect(row.SITE_ID).toBe('');
    expect(row.SITE_NAME).toBe('');
  });

  it('L3 은 SITE_*/COMPANY_* 를 드릴다운 컨텍스트에서 상속한다 (R15)', () => {
    const row = buildInsertRow(3, '81', 'E', drill, []);
    expect(row.SITE_ID).toBe('A003');
    expect(row.COMPANY_NAME).toBe('MI Company');
    expect(row.PLANT_ID).toBe('');
    // L5 전용이라 L3 에는 실리지 않는다.
    expect(row.SHOP_GROUP_ID).toBeUndefined();
  });

  it('L5 만 SHOP_GROUP_ID 를 조회조건 Product Group 에서 상속한다 (R17, cs:1256)', () => {
    const row = buildInsertRow(5, '81', 'A', drill, []);
    expect(row.SHOP_GROUP_ID).toBe('A');
    expect(row.FACTORY_NAME).toBe('ET Building');
    expect(row.LINE_ID).toBe('');
  });

  it('부모키가 비어 있으면 빈 문자열로 채운다 — 임의 기본값 폴백 금지', () => {
    const row = buildInsertRow(2, '81', 'E', {}, []);
    expect(row.SITE_ID).toBe('');
    expect(row.SITE_NAME).toBe('');
  });
});
