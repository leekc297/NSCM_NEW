import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import type { Gubun } from '../demand-plan-waterfall.constants';

import { dynKindOf, largeKeyOf, rankOf, weekNoOf } from './waterfall.periods';

/**
 * Waterfall 계층 병합 — **DMF0003 `HierarchicalMergeManager` 표준 이식**
 * (`features/demand/src/pages/mkt-fcst/utils/mkt-fcst.merge.ts:163~256`, 사용자 지시 2026-09-04
 *  "DMF0082·DMF0003 에 이미 적용된 내용 참조"). BIZ(연>분기>월) 3계층까지 일반화했다.
 *
 * ① TopLeft(No. 코너)  : 헤더 높이만큼 세로 병합
 * ② Data Cell          : 좌측 고정 컬럼의 **좌측 누적 계층** 세로 병합 (AS-IS `SmartColMerge` 1:1,
 *                        viewport 범위 한정 — 스크롤 시 `scrollPositionChanged` 로 재계산)
 * ③ ColumnHeader       : 정적 컬럼 = 세로 스팬(0..last)
 *                        최상위 합계 컬럼(MKT·SALES `M_` / BIZ `Y_`) = **2·3단 세로 병합**(단일 SUM 셀)
 *                        1단 = 대분류 키(월/연) 가로 병합 · 2단 = 중분류 키(주차/분기) 가로 병합
 *
 * ⚠ 라벨이 아니라 **binding 을 파싱해 키**를 만든다 — 2·3단 라벨이 모두 'SUM' 이라 값으로 묶으면
 *   월 경계를 넘어 가로로 합쳐진다(2026-09-04 실측: 3단 SUM 이 6개월 540px 한 덩어리).
 */
/** 셀 값 → 비교용 문자열 (객체는 빈 문자열 — 기본 stringify 방지) */
const cellText = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

export class WaterfallMergeManager extends MergeManager {
  private readonly gubun: Gubun;
  private readonly fixedBindings: string[];

  constructor(gubun: Gubun, fixedBindings: string[]) {
    super();
    this.gubun = gubun;
    this.fixedBindings = fixedBindings;
  }

  /** 2단(중분류) 키 — 대분류 + 주차/분기. 최상위 합계는 대분류+':SUM'(그룹당 1열) */
  private subKeyOf(binding: string): string {
    const kind = dynKindOf(binding);
    const rank = rankOf(this.gubun, kind);
    if (rank === null) return '\0';
    const large = largeKeyOf(this.gubun, binding);
    if (rank === 0) return `${large}:SUM`;
    if (kind === 'W') return `${large}:W${weekNoOf(binding)}`;
    if (kind === 'Q') return `${large}:${binding.slice(7)}`;
    // 최하위(일/월) — 소속 중분류에 합류해야 2단이 가로로 묶인다
    if (kind === 'D') return `${large}:D`;
    if (kind === 'M') return `${large}:M`;
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
      const rank = rankOf(this.gubun, kind);
      if (rank === null) return null;

      // 최상위 합계 컬럼(월/연) — 2·3단 라벨이 모두 'SUM' → 세로 단일 셀 (AS-IS 화면 1:1)
      if (r >= 1 && rank === 0) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }

      // 가로 병합은 **1단(대분류)·2단(중분류)에만** — 3단 leaf(일자/월)는 컬럼당 1칸이다.
      //   (DMF0003 규약: r===0 / r===1 만 처리하고 그 외는 null)
      if (r > 1) return null;
      const bind = (i: number): string => panel.columns[i]?.binding ?? '';
      const keyOf = r === 0 ? (b: string) => (dynKindOf(b) ? largeKeyOf(this.gubun, b) : '\0')
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
