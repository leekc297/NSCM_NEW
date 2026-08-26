import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// ⭐ DMF0044 — business-plan.merge.ts 축약 (M_ 단일 축 — **1단 헤더**).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan (헤더 행 2개 이상일 때만 의미).
//   ⚠ 2026-08-10 — 연도 가로 머지 제거. AS-IS `DMF0044_Sales_Reports.cs:235~236` 가
//     `iColumnHeaderRowCount = 1` 을 넘기므로 헤더는 1단이고, 동적 컬럼은 `2025-01` 처럼
//     **월 라벨 하나**로 나온다(연도 상위 span 없음). 종전 2단 구성은 SP 라벨(LARGE=SMALL='2025-01')
//     때문에 '2025-01' 그룹 아래 '2025-01' 1개짜리가 12개 생기는 오구성이었다.

/**
 * 두 행이 세로 병합 가능한가 — 순수 판정 (MergeManager 내부에서 사용. 단위테스트 대상).
 *
 * ⭐ 신규(Insert) 행은 **자기 2행 세트 안에서만** 병합한다 (2026-08-11).
 *   AS-IS 는 InsertRow 끝에서 `SetRowSpanFucTwo(siMain, ActiveRowIndex, ActiveRowIndex + 1, …)`
 *   로 **삽입한 2행만** span 한다(`.cs` L1031) — 이웃한 기존 등록 행과는 절대 묶이지 않는다.
 *   값 비교만 하면 신규행의 빈 값이 인접 기존행과 우연히 일치해 셀이 붙어버려,
 *   행 경계가 사라지고 편집·삭제 대상이 뭉개진다.
 */
export const canMergeRows = (
  ra: Record<string, unknown> | undefined,
  rb: Record<string, unknown> | undefined,
  leftBindings: string[]
): boolean => {
  if (!ra || !rb) return false;
  const ia = ra.CRUD_TYPE === 'I';
  const ib = rb.CRUD_TYPE === 'I';
  if (ia !== ib) return false; // 신규 ↔ 기존 경계 = 병합 금지
  // 신규끼리라도 다른 삽입 세트면 금지 (세트당 2행이 AS-IS span 단위)
  if (ia && ra.INSERT_GROUP_ID !== rb.INSERT_GROUP_ID) return false;
  return leftBindings.every(
    k => ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
  );
};

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
      const sameRow = (a: number, b: number): boolean =>
        canMergeRows(rowItem(a), rowItem(b), leftBindings);
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
