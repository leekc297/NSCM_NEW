import type { GridPanel } from '@mescius/wijmo.grid';
import { type FlexGrid, CellRange, CellType } from '@mescius/wijmo.grid';

import { CustomMergeManager } from '@foundation/utils';

export interface HeaderKey {
  /** 대분류(월) 병합 키 — binding 의 yyyymm */
  ym: string;
  /** 소분류(주) 병합 키. 월 합계(M_)는 'SUM' */
  sub: string;
}

/**
 * 동적(기간) 컬럼 헤더 병합 — 대분류(월)·소분류(주) 가로 병합과 월 합계(M_)의 2단 이상 세로 병합.
 *   자매 화면 shipment-plan-fg 의 ShipmentPlanFgHeaderMergeManager 와 동일(공용 SP·동일 헤더 구조).
 *
 * 공용 CustomMergeManager 는 인접 헤더 셀의 값이 같으면 병합하는데, 숨겨진 W_ 합계 컬럼의 'SUM' 이 월 합계(M_)
 * 옆에 붙어 있어 가로 범위가 행마다 달라지고 세로 병합이 깨진다. 라벨이 아니라 binding 에서 만든 키로 판정해 막는다.
 * ColumnHeader 의 동적 컬럼만 재정의하고 나머지(TopLeft, 정적 컬럼 헤더, 데이터 셀)는 super 에 위임한다.
 */
export class ShipmentPlanSemiHeaderMergeManager extends CustomMergeManager {
  constructor(
    grid: FlexGrid<WijmoRowItem>,
    private readonly getKeys: () => Map<string, HeaderKey>
  ) {
    super(grid);
  }

  getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
    if (panel.cellType !== CellType.ColumnHeader) return super.getMergedRange(panel, r, c);
    const keys = this.getKeys();
    const bindingAt = (i: number): string => panel.columns[i]?.binding ?? '';
    const binding = bindingAt(c);
    if (!keys.has(binding)) return super.getMergedRange(panel, r, c);

    const leafRow = panel.rows.length - 1;
    // 월 합계(M_): 월 라벨 아래 전 행을 하나로 합친다(AS-IS Monthly 2단).
    if (binding.startsWith('M_') && r >= 1) {
      return leafRow <= 1 ? null : new CellRange(1, c, leafRow, c);
    }
    if (r === leafRow) return null;

    // 월 라벨(0행)은 월 합계(M_) 컬럼도 같은 월 그룹에 포함해 가로 병합하고, 주 라벨(1행)은 M_ 를 제외한다.
    const keyOf = (i: number): string => {
      const key = keys.get(bindingAt(i));
      if (!key) return '\0';
      if (r === 0) return key.ym;
      return bindingAt(i).startsWith('M_') ? '\0' : `${key.ym}|${key.sub}`;
    };
    const key = keyOf(c);
    let c1 = c;
    let c2 = c;
    while (c1 > 0 && keyOf(c1 - 1) === key) c1 -= 1;
    while (c2 < panel.columns.length - 1 && keyOf(c2 + 1) === key) c2 += 1;
    return c1 === c2 ? null : new CellRange(r, c1, r, c2);
  }
}
