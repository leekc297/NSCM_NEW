import { AllowMerging, CellRange, CellType, MergeManager } from '@mescius/wijmo.grid';
import type { FlexGrid, GridPanel } from '@mescius/wijmo.grid';

import { CRUD_TYPE } from '@foundation/constants';

// 좌측 상단 No 영역을 컬럼 헤더 높이만큼 병합
const getTopLeftMergedRange = (panel: GridPanel, col: number): CellRange | null => {
  const lastRow = panel.rows.length - 1;
  return lastRow > 0 ? new CellRange(0, col, lastRow, col) : null;
};

// 신규 입력행(CRUD_TYPE='I') 판정 — 값이 같아도 인접 행과 병합하지 않기 위한 공통 가드.
//   병합되면 owner(상단 행)가 편집을 대표해 기존 행이 함께 바뀌는 문제로 이어진다.
//   mkt-fcst/sales-plan 등 HierarchicalMergeManager 계열이 공통으로 사용한다.
export const isInsertRow = (item: Record<string, unknown> | null | undefined): boolean =>
  item?.CRUD_TYPE === CRUD_TYPE.INSERT;

/** 병합 대상에서 제외할 빈 셀 값 (null/undefined/공백문자열). */
const isEmptyCellValue = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

class TopLeftMergeManager extends MergeManager {
  constructor(private readonly delegate: MergeManager) {
    super();
  }

  getMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number,
    clip: boolean = true
  ): CellRange | null {
    if (panel.cellType === CellType.TopLeft) return getTopLeftMergedRange(panel, currentCol);
    return this.delegate.getMergedRange(panel, currentRow, currentCol, clip);
  }
}

export const ensureTopLeftMergeManager = (grid: FlexGrid): void => {
  if (grid.mergeManager instanceof TopLeftMergeManager) return;
  grid.mergeManager = new TopLeftMergeManager(grid.mergeManager);
};

export class CustomMergeManager<T extends WijmoRowItem = WijmoRowItem> extends MergeManager {
  private readonly _mergeKeyCache = new Map<string, string>();

  // collectionChanged 를 이미 구독한 collectionView — 같은 뷰에 중복 등록하지 않기 위한 표식.
  private _boundCollectionView: unknown = null;

  private bindCollectionChanged(): void {
    const collectionView = this.grid.collectionView;
    if (!collectionView || collectionView === this._boundCollectionView) return;

    this._boundCollectionView = collectionView;
    collectionView.collectionChanged.addHandler(() => {
      this._mergeKeyCache.clear();
    });
  }

  private invalidateRow(row: number): void {
    for (const key of this._mergeKeyCache.keys()) {
      if (key.startsWith(row + ':')) this._mergeKeyCache.delete(key);
    }
  }

  private bindInvalidateEvents(): void {
    // 편집이 시작될 때는 아무것도 하지 않는다.
    //   금지: 편집 중인 행을 병합에서 빼지 말 것. wijmo 는 이미 선택된 셀을 다시 클릭해도
    //   (= 더블클릭의 두 번째 클릭) 편집을 시작하므로, 편집 여부로 병합을 바꾸면 사용자에게는
    //   "포커스만 옮겼는데 병합이 풀린다"로 보인다. 게다가 편집 불가 셀은 beginningEdit 가
    //   취소되고 cellEditEnded 가 오지 않아 그 행이 갈라진 채 남는다(드릴다운 더블클릭).
    //   금지: 편집 중 invalidate 하지 말 것. invalidate 는 10ms 뒤 refresh 를 예약하고
    //   FlexGrid.refresh 는 finishEditing 을 부르므로 열려 있던 콤보 드롭다운이 닫힌다.
    //   편집 셀을 단독으로 보여줄 필요도 없다 — wijmo 의 편집 범위(_rng)는 beginningEdit 보다
    //   먼저 계산된 병합 블록 전체라, 갈라 보여줘도 저장은 블록 전체에 된다.
    this.grid.cellEditEnded.addHandler((s, e) => {
      this.invalidateRow(e.row);
      this.grid.invalidate();
    });

    // 머지키 캐시는 행 인덱스로 키를 잡으므로 행 구성이 바뀌면 통째로 버려야 한다.
    //   같은 인덱스에 다른 행이 오면 이전 값이 그대로 쓰여 병합이 풀린 채로 남는다(필터 사고).
    //   loadedRows = 그리드가 행을 다시 바인딩할 때. 조회/필터/정렬(Reset)이 여기로 온다.
    this.grid.loadedRows.addHandler(() => {
      this._mergeKeyCache.clear();
    });

    // 행 추가/삭제는 그리드가 행을 다시 바인딩하지 않아(_cvCollectionChanged 의 Add/Remove 분기)
    //   loadedRows 가 오지 않는다. 그 경로는 collectionView 를 직접 구독해야 하는데,
    //   재조회로 itemsSource 가 바뀌면 collectionView 자체가 교체돼 구독이 죽으므로
    //   itemsSourceChanged 마다 새 collectionView 에 다시 건다.
    this.bindCollectionChanged();
    this.grid.itemsSourceChanged.addHandler(() => {
      this._mergeKeyCache.clear();
      this.bindCollectionChanged();
    });

    this.grid.sortedColumn.addHandler(() => {
      this._mergeKeyCache.clear();
    });
  }

  constructor(private readonly grid: FlexGrid<T>) {
    super();
    this.bindInvalidateEvents();
  }

  // 빈 값 셀의 병합 허용 여부 — 기본 금지(_getCellMergedRange 빈 셀 가드 참조).
  //   AS-IS 파리티로 "값이 없어도 같은 키 조합 안에서는 한 칸"이어야 하는 attribute 컬럼
  //   (예: DMF0082 SENDER_NAME)은 서브클래스가 컬럼 단위로 허용한다.
  //   Insert 행(CRUD_TYPE='I')은 이 허용과 무관하게 병합에서 계속 제외된다.
  protected allowEmptyCellMerge(_panel: GridPanel, _row: number, _col: number): boolean {
    return false;
  }

  // Insert 행(CRUD_TYPE='I')을 병합에서 제외하는 기본 가드 — allowEmptyCellMerge 와 동일한 확장점.
  //   기본값 false 라 기존 화면은 전부 지금처럼 Insert 행이 계속 갈라져 보인다(회귀 0).
  //   화면이 특정 컬럼만 예외로 허용하고 싶으면(예: 항상 같은 값인 Category 컬럼) 서브클래스에서
  //   재정의한다 — ColumnInsertMergeManager 참고.
  protected allowInsertRowMerge(_panel: GridPanel, _row: number, _col: number): boolean {
    return false;
  }

  private _getMergeKey(panel: GridPanel, row: number, col: number): string {
    if (row < 0) return '';

    const cacheKey = `${row}:${col}`;
    const cached = this._mergeKeyCache.get(cacheKey);
    if (cached !== undefined) return cached;

    let key: string;
    if (col === 0) key = String(panel.getCellData(row, 0, false));
    else {
      const prev = this._getMergeKey(panel, row, col - 1);
      key = prev + '|' + panel.getCellData(row, col, false);
    }

    this._mergeKeyCache.set(cacheKey, key);
    return key;
  }

  private _isSameHorizontalRange(
    panel: GridPanel,
    row: number,
    col: number,
    left: number,
    right: number
  ): boolean {
    const val = panel.getCellData(row, col, false) as WijmoPrimitive;
    let l = col,
      r = col;

    while (l > 0 && panel.getCellData(row, l - 1, false) === val) l--;
    while (r < panel.columns.length - 1 && panel.getCellData(row, r + 1, false) === val) r++;

    return l === left && r === right;
  }

  private _getColumnHeaderMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    const rng = new CellRange(currentRow, currentCol);
    const cellValue = panel.getCellData(currentRow, currentCol, false) as WijmoPrimitive;

    if (cellValue === null || cellValue === undefined || cellValue === '') return null;
    if (
      ![AllowMerging.All, AllowMerging.AllHeaders, AllowMerging.ColumnHeaders].includes(
        panel.grid.allowMerging
      )
    )
      return null;

    while (rng.col > 0 && panel.getCellData(currentRow, rng.col - 1, false) === cellValue)
      rng.col--;

    while (
      rng.col2 < panel.columns.length - 1 &&
      panel.getCellData(currentRow, rng.col2 + 1, false) === cellValue
    )
      rng.col2++;

    while (rng.row > 0) {
      const topValue = panel.getCellData(rng.row - 1, currentCol, false) as WijmoPrimitive;

      if (topValue !== cellValue) break;
      if (!this._isSameHorizontalRange(panel, rng.row - 1, currentCol, rng.col, rng.col2)) break;

      rng.row--;
    }

    while (rng.row2 < panel.rows.length - 1) {
      const bottomValue = panel.getCellData(rng.row2 + 1, currentCol, false) as WijmoPrimitive;

      if (bottomValue !== cellValue) break;
      if (!this._isSameHorizontalRange(panel, rng.row2 + 1, currentCol, rng.col, rng.col2)) break;

      rng.row2++;
    }

    return rng.isSingleCell ? null : rng;
  }

  private _getCellMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number
  ): CellRange | null {
    if (!panel.columns[currentCol]?.allowMerging) return null;
    if (![AllowMerging.All, AllowMerging.Cells].includes(panel.grid.allowMerging)) return null;
    // 값이 빈 셀은 병합하지 않는다 — 빈칸끼리 한 덩어리가 되면 실제 데이터 그룹처럼 보인다.
    //   컬럼 헤더 병합도 같은 규칙이다(_getColumnHeaderMergedRange).
    //   단, 화면이 allowEmptyCellMerge 로 허용한 컬럼은 예외 — 머지키가 좌측 전 컬럼 누적이라
    //   허용해도 같은 키 조합 블록(예: measure 분할 행) 안에서만 병합된다.
    if (
      isEmptyCellValue(panel.getCellData(currentRow, currentCol, false)) &&
      !this.allowEmptyCellMerge(panel, currentRow, currentCol)
    )
      return null;

    const rng = new CellRange(currentRow, currentCol);
    const item = panel.grid.collectionView.items[currentRow] as WijmoRowItem;
    const rowCrudStat = item?.CRUD_TYPE;
    if (rowCrudStat === CRUD_TYPE.INSERT && !this.allowInsertRowMerge(panel, currentRow, currentCol))
      return null;

    let minRow = panel.viewRange.row;
    const maxRow = panel.viewRange.row2;
    const staticHeight = panel.grid.rows.defaultSize;
    const checkCount = minRow * staticHeight + panel.grid.scrollPosition.y + staticHeight;
    const currentKey = this._getMergeKey(panel, currentRow, currentCol);

    if (1 < checkCount && checkCount <= 15 && ((minRow === 0 && checkCount <= 12) || minRow > 0))
      minRow = minRow + 1;

    while (rng.row > minRow) {
      const r = rng.row - 1;
      if (rng.row <= 0 || this._getMergeKey(panel, r, currentCol) !== currentKey) break;

      const nextCrudType = (panel.grid.collectionView.items[r] as WijmoRowItem)?.CRUD_TYPE;
      if (nextCrudType === CRUD_TYPE.INSERT && !this.allowInsertRowMerge(panel, r, currentCol)) break;
      rng.row--;
    }

    while (rng.row2 < maxRow) {
      const r = rng.row2 + 1;
      if (this._getMergeKey(panel, r, currentCol) !== currentKey) break;
      const nextCrudType = (panel.grid.collectionView.items[r] as WijmoRowItem)?.CRUD_TYPE;
      if (nextCrudType === CRUD_TYPE.INSERT && !this.allowInsertRowMerge(panel, r, currentCol)) break;
      rng.row2++;
    }

    if (rng.isSingleCell) return null;
    else return rng;
  }

  // TODO: 그 외의 영역에서 merge 필요할 경우 추가 구현 필요 - 강민재
  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    const cellType = panel.cellType;
    const mergeType = panel.grid.allowMerging;

    if (cellType === CellType.TopLeft) return getTopLeftMergedRange(panel, currentCol);
    if (mergeType === AllowMerging.None) return null;

    // 유효 범위 밖 좌표 가드 — 스톡 MergeManager 와 동일하게 병합 없음(null)으로 답한다.
    //   wijmo 는 신규행 편집/레이아웃 도중 currentRow=-1 같은 범위 밖 좌표로도 이 메서드를 부른다.
    //   가드가 없으면 아래 경로가 panel.getCellData(-1, ...) 를 호출하고, wijmo 가 "Positive number
    //   expected" 를 던져 셀 렌더가 통째로 중단된다 → 그 셀의 콤보 드롭다운이 열리지 않는다
    //   (2026-09-03 DMF0006 신규행 콤보 드롭다운 열림 실패).
    if (
      currentRow < 0 ||
      currentCol < 0 ||
      currentRow >= panel.rows.length ||
      currentCol >= panel.columns.length
    )
      return null;

    if (cellType === CellType.ColumnHeader)
      return this._getColumnHeaderMergedRange(panel, currentRow, currentCol);
    else if (cellType === CellType.Cell)
      return this._getCellMergedRange(panel, currentRow, currentCol);
    else return null;
  }
}

/**
 * 지정한 컬럼(binding)만은 Insert 행(CRUD_TYPE='I')도 계속 병합한다.
 *
 * SYS0017/SCM0007 메시지 설정 탭처럼 Category 가 항상 같은 조회 컨텍스트로 고정되는 화면에서는
 * F8 로 새 행을 추가해도 Category 컬럼이 기존 행들과 같은 값이라 계속 하나로 붙어 보여야 한다.
 * 공용 CustomMergeManager 는 Insert 행을 모든 컬럼에서 무조건 제외하므로(편집 시 병합된 다른 행이
 * 함께 바뀌는 사고를 막기 위한 기본 가드), 그 화면들만 컬럼 단위로 예외를 두기 위해 별도 클래스로
 * 분리한다 — 기본 가드 자체를 바꾸면 다른 모든 그리드가 영향을 받는다.
 */
export class ColumnInsertMergeManager<T extends WijmoRowItem = WijmoRowItem> extends CustomMergeManager<T> {
  constructor(
    grid: FlexGrid<T>,
    private readonly insertMergeBindings: ReadonlySet<string>
  ) {
    super(grid);
  }

  protected override allowInsertRowMerge(panel: GridPanel, _row: number, col: number): boolean {
    const binding = panel.columns[col]?.binding;
    return !!binding && this.insertMergeBindings.has(binding);
  }
}
