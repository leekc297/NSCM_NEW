import { CellType, type GridPanel } from '@mescius/wijmo.grid';
import { describe, expect, it } from 'vitest';

import { HierarchicalMergeManager } from './business-plan.merge';

// bucket=Monthly + Sum 체크 상태의 실제 컬럼 구성 (2026 Q3 = 08·09 / Q4 = 10).
const DYN = ['Y_2026', 'Q_2026_3', 'M_202608', 'M_202609', 'Q_2026_4', 'M_202610'];
const STATIC = ['MEASURE'];

// 3단 헤더 패널 흉내 — getMergedRange 가 쓰는 cellType/columns/rows 만 노출한다.
const headerPanel = (bindings: string[], headerRowCount = 3): GridPanel =>
  ({
    cellType: CellType.ColumnHeader,
    columns: bindings.map(binding => ({ binding })),
    rows: { length: headerRowCount },
  }) as unknown as GridPanel;

const range = (mm: HierarchicalMergeManager, panel: GridPanel, r: number, c: number) => {
  const rng = mm.getMergedRange(panel, r, c);
  return rng ? [rng.row, rng.col, rng.row2, rng.col2] : null;
};

describe('HierarchicalMergeManager — 동적 3단 헤더', () => {
  const panel = headerPanel([...STATIC, ...DYN]);
  const mm = new HierarchicalMergeManager(STATIC);
  const col = (binding: string) => [...STATIC, ...DYN].indexOf(binding);

  it('정적 컬럼은 헤더 전 단을 세로로 관통한다', () => {
    expect(range(mm, panel, 0, col('MEASURE'))).toEqual([0, 0, 2, 0]);
  });

  it('1단은 같은 연도의 동적 컬럼 전체를 가로로 묶는다', () => {
    expect(range(mm, panel, 0, col('Y_2026'))).toEqual([0, 1, 0, 6]);
  });

  it('연 SUM(Y_) 은 2·3단을 세로로 병합해 한 칸이 된다', () => {
    expect(range(mm, panel, 1, col('Y_2026'))).toEqual([1, 1, 2, 1]);
    expect(range(mm, panel, 2, col('Y_2026'))).toEqual([1, 1, 2, 1]);
  });

  it('2단은 분기 SUM + 그 분기의 월들을 가로로 묶는다', () => {
    expect(range(mm, panel, 1, col('Q_2026_3'))).toEqual([1, 2, 1, 4]);
    expect(range(mm, panel, 1, col('Q_2026_4'))).toEqual([1, 5, 1, 6]);
  });

  // 회귀 방지: 공용 CustomMergeManager 는 내용이 같은 인접 헤더 셀을 가로로 붙여
  //   Y_ 의 leaf 'SUM' 과 Q_ 의 leaf 'SUM' 을 한 칸으로 만든다. 3단은 병합 대상이 아니다.
  it('3단(leaf) 은 병합하지 않는다 — 연 SUM 과 분기 SUM 이 붙지 않아야 한다', () => {
    expect(range(mm, panel, 2, col('Q_2026_3'))).toBeNull();
    expect(range(mm, panel, 2, col('Q_2026_4'))).toBeNull();
    expect(range(mm, panel, 2, col('M_202608'))).toBeNull();
  });

  it('헤더가 2단뿐이면 Y_ 세로 병합을 건너뛴다', () => {
    const flat = headerPanel([...STATIC, ...DYN], 2);
    expect(range(mm, flat, 1, col('Y_2026'))).toBeNull();
  });
});
