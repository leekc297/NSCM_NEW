import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { CONDITIONAL_BG, CONDITIONAL_BG_START_COL } from '../global-psi-elec.constants';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 배경색(AS-IS Set_FPOperationColor 순서) — 색 없는 행은 ''.
export const conditionalBgOf = (row: Record<string, unknown> | undefined): string => {
  if (!row) return '';
  const psi = s(row.PSI);
  const measure = s(row.MEASURE_NAME);
  if (psi === 'P' && measure === 'SUM') return CONDITIONAL_BG.P_SUM;
  if (psi === 'S' && measure === 'SUM') return CONDITIONAL_BG.S_SUM;
  if (psi === 'I' && measure === 'EOH') return CONDITIONAL_BG.I_EOH;
  if (measure === 'Package Plan') return CONDITIONAL_BG.PACKAGE_PLAN;
  return '';
};

// 색칠 영역(4번째 컬럼~) 세로병합에서 색 있는 행을 분리 — 색이 위아래 행으로 번지지 않게 한다.
//   나머지(헤더·앞 3컬럼·색 없는 행끼리 병합)는 delegate(공용 병합)에 맡긴다.
export class GlobalPsiElecMergeManager extends MergeManager {
  constructor(private readonly delegate: MergeManager) {
    super();
  }

  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const range = this.delegate.getMergedRange(panel, r, c, clip);
    if (!range || panel.cellType !== CellType.Cell || c < CONDITIONAL_BG_START_COL) return range;
    if (range.row === range.row2) return range;

    const bgAt = (i: number) =>
      conditionalBgOf(panel.rows[i]?.dataItem as Record<string, unknown> | undefined);
    if (bgAt(r) !== '') return null;

    let r1 = r;
    let r2 = r;
    while (r1 > range.row && bgAt(r1 - 1) === '') r1--;
    while (r2 < range.row2 && bgAt(r2 + 1) === '') r2++;
    return r1 === r2 ? null : new CellRange(r1, range.col, r2, range.col2);
  }
}
