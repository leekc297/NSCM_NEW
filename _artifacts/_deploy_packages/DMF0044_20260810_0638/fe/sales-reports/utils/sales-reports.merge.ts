import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// ⭐ DMF0044 — business-plan.merge.ts 축약 (M_ 단일 축 — **1단 헤더**).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan (헤더 행 2개 이상일 때만 의미).
//   ⚠ 2026-08-10 — 연도 가로 머지 제거. AS-IS `DMF0044_Sales_Reports.cs:235~236` 가
//     `iColumnHeaderRowCount = 1` 을 넘기므로 헤더는 1단이고, 동적 컬럼은 `2025-01` 처럼
//     **월 라벨 하나**로 나온다(연도 상위 span 없음). 종전 2단 구성은 SP 라벨(LARGE=SMALL='2025-01')
//     때문에 '2025-01' 그룹 아래 '2025-01' 1개짜리가 12개 생기는 오구성이었다.

export class SalesReportsMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ===== #108 — No. 코너(TopLeft) 단일 머지 (정본 ExchangeRateModal) =====
    if (panel.cellType === CellType.TopLeft) {
      return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
    }

    const col = panel.columns[c];
    if (!col) return null;
    const binding = col.binding ?? '';

    // ===== ① Data Cell — 좌측 fixed cols 계층 머지 (viewport row 제한) =====
    if (panel.cellType === CellType.Cell && this.fixedBindings.includes(binding)) {
      const view = panel.rows;
      const rowItem = (i: number): Record<string, unknown> | undefined =>
        (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      const cur = rowItem(r);
      if (!cur) return null;
      const fixedIdx = this.fixedBindings.indexOf(binding);
      const leftBindings = this.fixedBindings.slice(0, fixedIdx + 1);
      const sameRow = (a: number, b: number): boolean => {
        const ra = rowItem(a);
        const rb = rowItem(b);
        if (!ra || !rb) return false;
        return leftBindings.every(
          k =>
            ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
        );
      };
      const minRow = panel.viewRange.row;
      const maxRow = panel.viewRange.row2;
      let r1 = r;
      let r2 = r;
      while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
      while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
      if (r1 === r2) return null;
      return new CellRange(r1, c, r2, c);
    }

    // ===== ② ColumnHeader — 정적 컬럼 verticalSpan =====
    //   ⚠ 2026-08-10 — **연도 가로 머지 제거**. 헤더가 1단이 되어(AS-IS iColumnHeaderRowCount=1)
    //     묶을 상위 행 자체가 없다. 헤더 행이 1개면 아래 verticalSpan 도 1행짜리라 실질 무동작이지만,
    //     정적 컬럼 규약(hook #108 계열)을 유지하기 위해 형태는 남긴다.
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding) && panel.rows.length > 1) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
    }
    return null;
  }
}
