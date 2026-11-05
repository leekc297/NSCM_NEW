import { type CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { isPivotBinding } from './globalPsiReportColumns';

// pivot 3단 헤더(월>주>Qty)의 leaf(Qty) 행 가로병합만 차단하는 매니저.
//   AS-IS(FarPoint ColumnHeaderSpan)는 월마다 'Qty' 를 개별 셀로 둔다 — leaf 라벨을 가로로 합치지 않는다.
//   공용 CustomMergeManager(allowMerging=All)는 값기반 병합이라 동일한 'Qty' 라벨을 가로로 뭉쳐(사용자
//   신고 2026-10-14 "Qty 헤더 통합") 보인다. 자매 SCP0031 GlobalPsiMergeManager 의 "leaf 행 no-merge"만 추려
//   공용 매니저를 감싼다 — 월/주 그룹 스팬(상위 행)과 선행 차원 컬럼 세로병합(데이터셀·고정컬럼 헤더)은
//   그대로 delegate 로 위임한다(주 포맷 가정 없이 안전).
export class ReportHeaderMergeManager extends MergeManager {
  constructor(private readonly delegate: MergeManager) {
    super();
  }

  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const binding = panel.columns[c]?.binding ?? '';
    // pivot(M_/W_) leaf 헤더 = 최하단 헤더 행. 이 행만 병합 금지(월별 개별 Qty). 고정 차원 컬럼 헤더는
    //   비-pivot binding 이라 delegate(세로 rowspan 유지), 월/주 그룹 헤더는 상위 행이라 delegate(스팬 유지).
    if (
      panel.cellType === CellType.ColumnHeader &&
      isPivotBinding(binding) &&
      r === panel.rows.length - 1
    ) {
      return null;
    }
    return this.delegate.getMergedRange(panel, r, c, clip);
  }
}
