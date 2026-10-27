// DIVISION_NAME 세로 병합 전용 MergeManager — AS-IS SetColumnMerge(DIVISION_NAME, MergePolicy.Always)
//   (SCP0015_PlanManagement.cs L723, design 03 §3 R4) 재현.
//   공용 CustomMergeManager 는 머지키를 col0 부터 좌측 전 컬럼 누적으로 만드는데, 이 화면은
//   col0=MODELING_ID 가 행 유일키(hidden)라 동일 Division 인접 행도 키가 달라 병합이 발생하지
//   않는다(iter-1 gap-audit G2). 대상 컬럼 값 단독 키로 인접 동일값 행을 병합하는 화면 전용
//   매니저로 대체한다 — DataGrid mergeManager prop 으로 전달하면 공용 wrapper 가 CustomMergeManager
//   대입을 건너뛰고 TopLeft corner 병합만 ensureTopLeftMergeManager 데코레이터로 보강한다.
import { AllowMerging, CellRange, CellType, MergeManager } from '@mescius/wijmo.grid';
import type { GridPanel } from '@mescius/wijmo.grid';

import { isInsertRow } from '@foundation/utils';

const isEmptyCellValue = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

const rowItem = (panel: GridPanel, row: number): Record<string, unknown> | undefined =>
  panel.rows[row]?.dataItem as Record<string, unknown> | undefined;

export class DivisionNameMergeManager extends MergeManager {
  constructor(private readonly binding: string) {
    super();
  }

  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    if (panel.cellType !== CellType.Cell) return null;
    if (![AllowMerging.All, AllowMerging.Cells].includes(panel.grid.allowMerging)) return null;
    // 범위 밖 좌표 가드 — wijmo 는 편집/레이아웃 도중 row=-1 로도 호출한다(공용 매니저 동일 가드,
    //   2026-09-03 DMF0006 신규행 콤보 드롭다운 실패 선례)
    if (
      currentRow < 0 ||
      currentCol < 0 ||
      currentRow >= panel.rows.length ||
      currentCol >= panel.columns.length
    )
      return null;
    const column = panel.columns[currentCol];
    if (column?.binding !== this.binding || !column.allowMerging) return null;
    const value = panel.getCellData(currentRow, currentCol, false) as unknown;
    // 빈 값 셀은 병합하지 않는다 — 빈칸끼리 한 덩어리가 되면 실제 데이터 그룹처럼 보인다
    if (isEmptyCellValue(value)) return null;
    // 신규행(CRUD_TYPE='I') 제외 — 병합되면 owner 행 편집이 기존 행을 대표하는 사고(공용 가드 동일).
    //   이 화면은 Insert 자체가 NO-OP 이라 실도달 없으나 공용 패턴 파리티로 유지한다.
    if (isInsertRow(rowItem(panel, currentRow))) return null;
    const rng = new CellRange(currentRow, currentCol);
    while (
      rng.row > 0 &&
      panel.getCellData(rng.row - 1, currentCol, false) === value &&
      !isInsertRow(rowItem(panel, rng.row - 1))
    )
      rng.row--;
    while (
      rng.row2 < panel.rows.length - 1 &&
      panel.getCellData(rng.row2 + 1, currentCol, false) === value &&
      !isInsertRow(rowItem(panel, rng.row2 + 1))
    )
      rng.row2++;
    return rng.isSingleCell ? null : rng;
  }
}
