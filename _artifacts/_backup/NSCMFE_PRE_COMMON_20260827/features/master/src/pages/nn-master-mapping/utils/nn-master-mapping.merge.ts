import { CellRange, CellType, MergeManager, type GridPanel } from '@mescius/wijmo.grid';

// AS-IS .cs L515 `siMain.SmartColMerge()` 동작 모사 (사용자 요구 2026-06-02):
// "자신의 column 이 같은 값이어도, 좌측의 모든 allowMerging column 도 같은 값일 때만 머지"
// Wijmo 기본 `AllowMerging.Cells` + 표준 `CustomMergeManager` 는 column-independent 머지 —
// 본 클래스는 column-dependent (좌측 의존성) 머지 구현.
// DataGrid wrapper 의 `mergeManager` prop 으로 전달 가능 (DataGrid.tsx:130 가드 활용).
export class HierarchicalMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, clip: boolean = true): CellRange | null {
    if (panel.cellType !== CellType.Cell) {
      return super.getMergedRange(panel, r, c, clip);
    }
    const col = panel.columns[c];
    if (!col || !col.allowMerging) return null;

    // 좌측 (포함) 의 allowMerging=true column 모음
    const mergeColIdx: number[] = [];
    for (let i = 0; i <= c; i++) {
      if (panel.columns[i]?.allowMerging) mergeColIdx.push(i);
    }
    if (mergeColIdx.length === 0) return null;

    const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
      mergeColIdx.every(ci => {
        const a: unknown = panel.getCellData(rowA, ci, false);
        const b: unknown = panel.getCellData(rowB, ci, false);
        return a === b;
      });

    let r1 = r;
    let r2 = r;
    while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
    const rowCnt = panel.rows.length;
    while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;

    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}
