import { CellType, MergeManager } from '@mescius/wijmo.grid';
import type { CellRange, FlexGrid, GridPanel } from '@mescius/wijmo.grid';

import { CustomMergeManager } from '@foundation/utils';

import { isPivotBinding } from './globalPsiReportColumns';

// SCP0100 그리드 병합 — 기간칼럼(M_/W_/B_) 헤더만 Wijmo 기본(컬럼그룹 범위) 병합으로 그린다.
//   공용 CustomMergeManager 는 헤더를 '같은 글자면 세로 병합'(mergeManager.ts _getColumnHeaderMergedRange)하는데,
//   MONTHLY 3SPAN 은 LARGE·SMALL 라벨이 같은 월('2026-09'/'2026-09')이라 1·2행이 한 칸으로 합쳐져
//   AS-IS 3행(SetSheetHeaderColumn(_SI,3) .cs:705 · ColumnHeaderSpan 0행 LARGE / 1행 SMALL / 2행 'Qty' .cs:787·794)이
//   2행으로 보였다(2026-10-21 E2E smoke header: 행 2 = 72+24px). AS-IS 의 헤더 스팬은 명시 범위라 글자가 같아도 합쳐지지 않는다.
//   고정 차원 컬럼 헤더·데이터 셀은 공용 CustomMergeManager 그대로 위임(공용 변경 없음, DataGrid mergeManager prop 직접 전달 — D4).
//   ⚠ 클래스에 인스턴스 필드를 두지 않는다 — FlexGrid 는 prop 으로 받은 mergeManager 의 속성을 copy() 로 옮기며
//   모르는 속성이면 'Unknown property' 단언으로 그리드 생성이 실패한다(2026-10-21 smoke 화면 오류 'inner', check.js H06).
//   위임 대상은 모듈 WeakMap<FlexGrid, …> 에 그리드별로 보관한다.
const delegates = new WeakMap<FlexGrid, CustomMergeManager>();
const delegateOf = (grid: FlexGrid): CustomMergeManager => {
  let d = delegates.get(grid);
  if (!d) {
    d = new CustomMergeManager(grid);
    delegates.set(grid, d);
  }
  return d;
};

export class GlobalPsiReportMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, row: number, col: number, clip = true): CellRange | null {
    if (
      panel.cellType === CellType.ColumnHeader &&
      row >= 0 &&
      col >= 0 &&
      col < panel.columns.length &&
      isPivotBinding(panel.columns[col]?.binding ?? '')
    ) {
      // Wijmo 기본 = 컬럼그룹이 있으면 그 그룹의 범위(_rng) — LARGE/SMALL/leaf 가 각자 자기 행에만 그려진다.
      return super.getMergedRange(panel, row, col, clip);
    }
    return delegateOf(panel.grid).getMergedRange(panel, row, col);
  }
}
