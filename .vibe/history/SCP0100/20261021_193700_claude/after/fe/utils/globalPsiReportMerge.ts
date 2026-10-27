import { CellType, MergeManager } from '@mescius/wijmo.grid';
import type { CellRange, GridPanel } from '@mescius/wijmo.grid';

import { CustomMergeManager } from '@foundation/utils';

import { isPivotBinding } from './globalPsiReportColumns';

// SCP0100 그리드 병합 — 기간칼럼(M_/W_/B_) 헤더만 Wijmo 기본(컬럼그룹 범위) 병합으로 그린다.
//   공용 CustomMergeManager 는 헤더를 '같은 글자면 세로 병합'(mergeManager.ts _getColumnHeaderMergedRange)하는데,
//   MONTHLY 3SPAN 은 LARGE·SMALL 라벨이 같은 월('2026-09'/'2026-09')이라 1·2행이 한 칸으로 합쳐져
//   AS-IS 3행(SetSheetHeaderColumn(_SI,3) .cs:705 · ColumnHeaderSpan 0행 LARGE / 1행 SMALL / 2행 'Qty' .cs:787·794)이
//   2행으로 보였다(2026-10-21 E2E smoke header: 행 2 = 72+24px). AS-IS 의 헤더 스팬은 명시 범위라 글자가 같아도 합쳐지지 않는다.
//   고정 차원 컬럼 헤더·데이터 셀은 공용 CustomMergeManager 그대로 위임(공용 변경 없음, DataGrid mergeManager prop 직접 전달 — D4).
export class GlobalPsiReportMergeManager extends MergeManager {
  private inner: CustomMergeManager | null = null;

  getMergedRange(
    panel: GridPanel,
    currentRow: number,
    currentCol: number,
    clip: boolean = true
  ): CellRange | null {
    if (
      panel.cellType === CellType.ColumnHeader &&
      currentRow >= 0 &&
      currentCol >= 0 &&
      currentCol < panel.columns.length &&
      isPivotBinding(panel.columns[currentCol]?.binding ?? '')
    ) {
      // Wijmo 기본 = 컬럼그룹이 있으면 그 그룹의 범위(_rng) — LARGE/SMALL/leaf 가 각자 자기 행에만 그려진다.
      return super.getMergedRange(panel, currentRow, currentCol, clip);
    }
    this.inner ??= new CustomMergeManager(panel.grid);
    return this.inner.getMergedRange(panel, currentRow, currentCol);
  }
}
