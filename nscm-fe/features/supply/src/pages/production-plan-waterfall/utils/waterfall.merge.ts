import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { dynKindOf, largeKeyOf, rankOf, weekKeyOf } from './waterfall.periods';

/**
 * Waterfall 계층 병합 — demand-plan-waterfall `WaterfallMergeManager` 단일시트 이식(SCP0017 D/W/M).
 *
 * ① TopLeft(No. 코너)  : 헤더 높이만큼 세로 병합
 * ② Data Cell          : 좌측 고정 컬럼의 좌측 누적 계층 세로 병합 (AS-IS SmartColMerge 1:1,
 *                        viewport 범위 한정 — 스크롤 시 scrollPositionChanged 로 재계산)
 * ③ ColumnHeader       : 정적 컬럼 = 세로 스팬 / 최상위 합계(월 M_) = 2·3단 세로 병합 /
 *                        1단 = 월 키 가로 병합 · 2단 = 주차 키 가로 병합
 *
 * 주의: 라벨이 아니라 binding 을 파싱해 키를 만든다 — 2·3단 라벨이 모두 'SUM' 이라 값으로 묶으면
 *   월 경계를 넘어 가로로 합쳐진다(demand-plan-waterfall 실측).
 */
const cellText = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

export class WaterfallMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  /** 2단(중분류) 키 — 월 + 주차. 최상위 합계(월)는 월+':SUM'(그룹당 1열) */
  private subKeyOf(binding: string): string {
    const kind = dynKindOf(binding);
    const rank = rankOf(kind);
    if (rank === null) return '\0';
    const large = largeKeyOf(binding);
    if (rank === 0) return `${large}:SUM`;
    // 2단(주) 키 — W_ 롤업과 그 주의 D_ 일자들이 같은 주차 키를 공유해야 'Wxx' 헤더가 한 칸으로 가로 병합된다.
    //   주차는 binding 에서 파생 가능하다(weekKeyOf: W_ 는 인코딩 ISO주차, D_ 는 날짜에서 ISO주차 계산 — 같은 주면 일치).
    //   종전엔 D_ 를 월 단위 상수 키(`large:D`)로 둬 W_ 롤업(`large:Wxx`)과 키가 달라 'W01' 이 두 칸으로 쪼개졌다.
    if (kind === 'W' || kind === 'D') return `${large}:W${weekKeyOf(binding)}`;
    return '\0';
  }

  getMergedRange(
    panel: GridPanel,
    r: number,
    c: number,
    _clip: boolean = true
  ): CellRange | null {
    if (panel.cellType === CellType.TopLeft) {
      const lastRow = panel.rows.length - 1;
      return lastRow > 0 ? new CellRange(0, c, lastRow, c) : null;
    }

    const col = panel.columns[c];
    if (!col) return null;
    const binding = col.binding ?? '';

    // ① 데이터 셀 — 좌측 고정 컬럼 계층 세로 병합 (viewport 한정)
    if (panel.cellType === CellType.Cell && this.fixedBindings.includes(binding)) {
      const rowItem = (i: number): Record<string, unknown> | undefined =>
        (panel.rows[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      if (!rowItem(r)) return null;
      const idx = this.fixedBindings.indexOf(binding);
      const leftBindings = this.fixedBindings.slice(0, idx + 1);
      const sameRow = (a: number, b: number): boolean => {
        const ra = rowItem(a);
        const rb = rowItem(b);
        if (!ra || !rb) return false;
        return leftBindings.every(k => cellText(ra[k]) === cellText(rb[k]));
      };
      const minRow = panel.viewRange.row;
      const maxRow = panel.viewRange.row2;
      let r1 = r;
      let r2 = r;
      while (r1 > minRow && sameRow(r1 - 1, r)) r1 -= 1;
      while (r2 < maxRow && sameRow(r2 + 1, r)) r2 += 1;
      return r1 === r2 ? null : new CellRange(r1, c, r2, c);
    }

    // ② 컬럼 헤더
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      const kind = dynKindOf(binding);
      const rank = rankOf(kind);
      if (rank === null) return null;

      // 최상위 합계 컬럼(월) — 2·3단 라벨이 모두 'SUM' → 세로 단일 셀
      if (r >= 1 && rank === 0) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }

      // 가로 병합은 1단(월)·2단(주차)에만 — 3단 leaf(일자)는 컬럼당 1칸.
      if (r > 1) return null;
      const bind = (i: number): string => panel.columns[i]?.binding ?? '';
      const keyOf =
        r === 0
          ? (b: string) => (dynKindOf(b) ? largeKeyOf(b) : '\0')
          : (b: string) => this.subKeyOf(b);
      const key = keyOf(binding);
      if (key === '\0') return null;
      let c1 = c;
      let c2 = c;
      while (c1 > 0 && keyOf(bind(c1 - 1)) === key) c1 -= 1;
      while (c2 < panel.columns.length - 1 && keyOf(bind(c2 + 1)) === key) c2 += 1;
      return c1 === c2 ? null : new CellRange(r, c1, r, c2);
    }

    return null;
  }
}
