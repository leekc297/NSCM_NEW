import {
  CellRange,
  CellType,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';

// ⭐ DMF0044 — business-plan.merge.ts 축약 (M_ 단일 축 — 2단 헤더: 1단=연 span / 2단=월 leaf).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan + 동적 1단(연) 가로 머지.
//   ⚠ 커스텀 mergeManager 설치 시 nested columnGroups 네이티브 span 무효 → 수동 머지 의무 (hook #108).
//   AS-IS CreateSheetHeaderColumnDtDiv 연도 span 대응.

// 1단 그룹 키 = 연도 4자리 (M_yyyymm)
const yearOf = (b: string): string => (/^M_\d{6}$/.test(b) ? b.slice(2, 6) : '\0');

export class EtcSalesReportsMergeManager extends MergeManager {
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

    // ===== ② ColumnHeader — 정적 verticalSpan + 동적 1단(연) 가로 머지 =====
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (!/^M_\d{6}$/.test(binding)) return null;
      if (r === 0) {
        const cols = panel.columns;
        const bind = (i: number): string => cols[i]?.binding ?? '';
        const y = yearOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && yearOf(bind(c1 - 1)) === y) c1--;
        while (c2 < cols.length - 1 && yearOf(bind(c2 + 1)) === y) c2++;
        return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
      }
    }
    return null;
  }
}
