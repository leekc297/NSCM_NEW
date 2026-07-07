import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// 동적 PIVOT 컬럼 키 파서 — M_yyyymm / W_yyyymm+ISO_WEEK / D_yyyymmdd (DMF0048_GET_SPREAD_TITLE 실측)
export interface DynKey {
  kind: 'M' | 'W' | 'D' | null;
  ym: string;
  sub: string;
  leaf: string;
}

export const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

export const dynKindOf = (binding: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(binding)
    ? 'M'
    : /^W_\d+$/.test(binding)
      ? 'W'
      : /^D_\d{8}$/.test(binding)
        ? 'D'
        : null;

export const getDynKey = (binding: string): DynKey => {
  if (/^M_\d{6}$/.test(binding)) {
    const d = binding.slice(2);
    return { kind: 'M', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, sub: 'SUM', leaf: '' };
  }
  if (/^W_\d{8}$/.test(binding)) {
    // W_yyyymmdd (8자리 = 주 시작일) — 데이터 row 키 fallback 경로.
    const d = binding.slice(2);
    return {
      kind: 'W',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      sub: `W${isoWeek(d)}`,
      leaf: `${d.slice(4, 6)}${d.slice(6, 8)}`,
    };
  }
  if (/^W_\d{7,9}$/.test(binding)) {
    // W_yyyymm + ISO_WEEK (SP 실측 형식 — 예 W_20260727 = 2026-07 · W27)
    const d = binding.slice(2);
    const week = d.slice(6);
    return { kind: 'W', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, sub: `W${week}`, leaf: '' };
  }
  if (/^D_\d{8}$/.test(binding)) {
    const d = binding.slice(2);
    return {
      kind: 'D',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      sub: `W${isoWeek(d)}`,
      leaf: `${d.slice(4, 6)}${d.slice(6, 8)}`,
    };
  }
  return { kind: null, ym: '', sub: '', leaf: '' };
};

// ⭐ 계층 머지 (DMF0003/DMF0020 HierarchicalMergeManager 표준 복제 — AS-IS SmartColMerge 1:1)
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content)
//   ② ColumnHeader: 정적 column verticalSpan + 동적 column 1단(년월)/2단(주차) 가로 머지
export class HierarchicalMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
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

    // ===== ② ColumnHeader — 정적 verticalSpan + 동적 1단(년월)/2단(주차) 가로 머지 =====
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (!/^[MWD]_/.test(binding)) return null;
      // M_ 컬럼 — 2·3단 모두 'SUM' 라벨 (월당 1열) → 세로 머지 단일 SUM 셀
      if (r >= 1 && /^M_\d{6}$/.test(binding)) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
      const cols = panel.columns;
      const bind = (i: number): string => cols[i]?.binding ?? '';
      const ymOf = (b: string): string => (/^[MWD]_/.test(b) ? b.slice(2, 8) : '\0');
      const subOf = (b: string): string => {
        if (/^M_\d{6}$/.test(b)) return b.slice(2, 8) + ':SUM';
        if (/^W_\d{7,9}$/.test(b)) return b.slice(2, 8) + ':W' + b.slice(8);
        if (/^D_\d{8}$/.test(b)) return b.slice(2, 8) + ':W' + isoWeek(b.slice(2));
        return '\0';
      };
      if (r === 0) {
        const ym = ymOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && ymOf(bind(c1 - 1)) === ym) c1--;
        while (c2 < cols.length - 1 && ymOf(bind(c2 + 1)) === ym) c2++;
        return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
      }
      if (r === 1) {
        const sub = subOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && subOf(bind(c1 - 1)) === sub) c1--;
        while (c2 < cols.length - 1 && subOf(bind(c2 + 1)) === sub) c2++;
        return c1 === c2 ? null : new CellRange(1, c1, 1, c2);
      }
    }
    return null;
  }
}
