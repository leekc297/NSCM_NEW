import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { toCellStr } from '../demand-manager.constants';

// ⭐ DMF0068 — 한 건이 Measure 2행으로 표현되므로 왼쪽 고정 컬럼(No / Project / 수주 기간)을
//   세트 단위로 세로 병합한다. 병합 판정은 "같은 그룹 키(KEYVALUE2)" 를 기준으로 한다
//   (프로젝트·기간 값이 같아도 그룹이 다르면 별개 건이므로 합치지 않는다).
//   ⚠ 커스텀 mergeManager 를 달면 nested columnGroups 의 네이티브 span 이 무효가 되므로
//     헤더 가로 병합도 여기서 직접 처리한다(hook #108).

/** 세로 병합 대상 — 세트 내 두 행이 같은 값을 갖는 좌측 고정 컬럼 */
const PAIR_MERGE_BINDINGS = ['PROJECT_NAME', 'ORDERSTART', 'ORDEREND'];

export class DemandManagerMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ===== No. 코너(TopLeft) 단일 병합 (hook #108 — 정본 ExchangeRateModal) =====
    if (panel.cellType === CellType.TopLeft) {
      return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
    }

    const col = panel.columns[c];
    if (!col) return null;
    const binding = col.binding ?? '';

    // ===== 컬럼 헤더 — 세로/가로 병합 직접 구현 =====
    //   커스텀 MergeManager 를 달면 그룹 컬럼의 네이티브 span 이 동작하지 않으므로
    //   ① 그룹이 없는 컬럼은 헤더 전 행을 세로로 합치고
    //   ② 같은 상위 헤더를 가진 이웃 컬럼은 1단에서 가로로 합친다 (hook #108).
    if (panel.cellType === CellType.ColumnHeader) {
      return this.headerRange(panel, r, c);
    }

    // ===== 행 헤더(No.) — 세트 단위 병합 =====
    if (panel.cellType === CellType.RowHeader) {
      return this.pairRange(panel, r, c);
    }

    // ===== 데이터 셀 — Project / 수주 기간만 세트 병합 =====
    if (panel.cellType === CellType.Cell && PAIR_MERGE_BINDINGS.includes(binding)) {
      return this.pairRange(panel, r, c);
    }

    return null;
  }

  /**
   * 컬럼 헤더 병합.
   *  - 1단(상위) 라벨이 없거나 2단 라벨과 같은 컬럼 → 헤더 전 행 세로 병합
   *  - 1단 라벨이 있는 컬럼 → 같은 라벨이 이어지는 구간을 1단에서 가로 병합
   */
  private headerRange(panel: GridPanel, r: number, c: number): CellRange | null {
    const rowCount = panel.rows.length;
    if (rowCount <= 1) return null;

    const groupOf = (i: number): string => {
      const col = panel.columns[i] as unknown as { _hdrGroup?: string } | undefined;
      if (!col) return '';
      // wijmo 는 그룹 헤더 텍스트를 상위 행 셀 값으로 들고 있다
      const top = panel.getCellData(0, i, false);
      const leaf = panel.getCellData(rowCount - 1, i, false);
      const topStr = top == null ? '' : String(top);
      const leafStr = leaf == null ? '' : String(leaf);
      return topStr === leafStr ? '' : topStr;
    };

    const group = groupOf(c);

    // 그룹이 없는 컬럼 — 헤더 전 행 세로 병합
    if (!group) {
      return new CellRange(0, c, rowCount - 1, c);
    }

    // 그룹이 있는 컬럼 — 1단만 가로 병합, 2단(leaf)은 그대로
    if (r > 0) return null;
    let c1 = c;
    let c2 = c;
    while (c1 > 0 && groupOf(c1 - 1) === group) c1--;
    while (c2 < panel.columns.length - 1 && groupOf(c2 + 1) === group) c2++;
    if (c1 === c2) return new CellRange(0, c, rowCount - 2, c);
    return new CellRange(0, c1, rowCount - 2, c2);
  }

  /** 같은 그룹 키를 가진 인접 행 범위 (viewport 안으로 제한 — sticky content 방지) */
  private pairRange(panel: GridPanel, r: number, c: number): CellRange | null {
    const view = panel.rows;
    const keyOf = (i: number): string | undefined => {
      const item = (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      if (!item) return undefined;
      const key = toCellStr(item.KEYVALUE2 ?? item.INSERT_GROUP_ID);
      return key === '' ? undefined : key;
    };
    const cur = keyOf(r);
    if (!cur) return null;
    const minRow = panel.viewRange.row;
    const maxRow = panel.viewRange.row2;
    let r1 = r;
    let r2 = r;
    while (r1 > minRow && keyOf(r1 - 1) === cur) r1--;
    while (r2 < maxRow && keyOf(r2 + 1) === cur) r2++;
    if (r1 === r2) return null;
    return new CellRange(r1, c, r2, c);
  }
}
