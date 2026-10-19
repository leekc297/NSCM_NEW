import { describe, expect, it } from 'vitest';

import {
  formatYieldValue,
  groupRowRange,
  isFirstRowOfGroup,
  isGroupRow,
  isPlantCellEditable,
  isYieldCellEditable,
  plantProgress,
} from './plan-yield.editLock';

describe('편집 게이트 — INPUT_TP_CD 메타 × 행 축', () => {
  it('요청법인 그리드: 편집형(O/IO/M/IM)만, 체크박스 컬럼은 편집기 차단', () => {
    expect(isPlantCellEditable('O', 'FPComboBox')).toBe(true);
    expect(isPlantCellEditable('S', 'FPComboBox')).toBe(false);
    expect(isPlantCellEditable('O', 'FPCheckBox')).toBe(false);
    expect(isPlantCellEditable(undefined, 'S')).toBe(false);
  });

  it('수율 그리드: 그룹 헤더행(IS_GROUP=Y)은 편집형 컬럼이라도 잠금', () => {
    const cond = { IS_GROUP: 'N', LEVEL_4: '300㎛ 미만' };
    const group = { IS_GROUP: 'Y', LEVEL_3: 'Half Cell 두께' };
    expect(isGroupRow(group)).toBe(true);
    expect(isGroupRow(cond)).toBe(false);
    expect(isYieldCellEditable('O', 'S', cond)).toBe(true);
    expect(isYieldCellEditable('O', 'S', group)).toBe(false);
    expect(isYieldCellEditable('O', 'FPCheckBox', cond)).toBe(false);
    expect(isYieldCellEditable('O', 'S', undefined)).toBe(false);
  });
});

describe('formatYieldValue — 목업 표기 (95.0% / 20,000)', () => {
  it('[%] 단위 = 소수 저장값 × 100 소수 1자리', () => {
    expect(formatYieldValue(0.95, '[%]')).toBe('95.0%');
    expect(formatYieldValue('1', '[%]')).toBe('100.0%');
    expect(formatYieldValue(0.65, '[%]')).toBe('65.0%');
  });

  it('그 외 단위 = 천단위 콤마', () => {
    expect(formatYieldValue(20000, '[타]')).toBe('20,000');
    expect(formatYieldValue('1800', '[타]')).toBe('1,800');
  });

  it('빈 값·비수치는 원문 유지', () => {
    expect(formatYieldValue('', '[%]')).toBe('');
    expect(formatYieldValue(null, '[%]')).toBe('');
    expect(formatYieldValue('abc', '[타]')).toBe('abc');
  });
});

describe('plantProgress / isFirstRowOfGroup — 구분 단위 확인 (목업 67% = 4 구분 중 ... 반올림)', () => {
  // 구분 축 = OPERATION_GROUP_NAME (양극/음극은 OPERATION_GROUP 'E' 를 공유하므로 코드로 묶으면 1구분이 됨)
  const rows = [
    { OPERATION_GROUP: 'E', OPERATION_GROUP_NAME: '양극', CONFIRM_FLAG: 'CHECKED' },
    { OPERATION_GROUP: 'E', OPERATION_GROUP_NAME: '양극', CONFIRM_FLAG: 'CHECKED' },
    { OPERATION_GROUP: 'E', OPERATION_GROUP_NAME: '음극', CONFIRM_FLAG: 'CHECKED' },
    { OPERATION_GROUP: 'A', OPERATION_GROUP_NAME: '조립', CONFIRM_FLAG: 'UNCHECKED' },
    { OPERATION_GROUP: 'A', OPERATION_GROUP_NAME: '조립', CONFIRM_FLAG: 'UNCHECKED' },
  ];

  it('구분 전 행 CHECKED 만 확인 완료로 센다', () => {
    expect(plantProgress(rows)).toEqual({ confirmed: 2, total: 3, percent: 67 });
    expect(plantProgress([])).toEqual({ confirmed: 0, total: 0, percent: 0 });
  });

  it('구분이 섞여 있으면(한 행만 UNCHECKED) 그 구분은 미확인', () => {
    const mixed = [
      ...rows,
      { OPERATION_GROUP: 'E', OPERATION_GROUP_NAME: '양극', CONFIRM_FLAG: 'UNCHECKED' },
    ];
    expect(plantProgress(mixed).confirmed).toBe(1);
  });

  it('구분 첫 행만 체크박스를 그린다', () => {
    expect(rows.map((_, i) => isFirstRowOfGroup(rows, i))).toEqual([
      true,
      false,
      true,
      true,
      false,
    ]);
    expect(isFirstRowOfGroup(rows, 99)).toBe(false);
  });

  it('구분 병합 범위 — 구분의 연속 행 [첫, 끝]. 값이 같은 인접 구분(양극/음극 CHECKED)도 넘지 않는다', () => {
    expect(rows.map((_, i) => groupRowRange(rows, i))).toEqual([
      [0, 1],
      [0, 1],
      [2, 2],
      [3, 4],
      [3, 4],
    ]);
    expect(groupRowRange(rows, 99)).toEqual([99, 99]);
  });
});
