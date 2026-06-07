import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';

import type { MktFcstRow } from '../mkt-forecast-master.types';
import { markRowAsUpdated } from '../utils/crudTypeMarker';

// AS-IS DMF0003_1_MktFcst.cs L3136 spdMain_Changed cascade 5 sub-pattern (룰 07 §2.10):
//   1. auto-derive    : 변경된 셀에 따라 종속 셀 자동 계산 (Phase 3 — 합계 변수 32건)
//   2. duplicate-check: Division/Project/Item/YYYYMMDD/Measure 중복 검증
//   3. cascade-clear  : Division 변경 시 종속 컬럼 reset
//   4. staging        : EditTracker.storeChange — Row 단위 modified tracking
//   5. combo cascade  : combo column dataMap 자동 갱신 (Phase 3 — Incoterms/FcstType 등)
//
// 메모리 feedback_cell_cascade_5_patterns + hook modal-callback-cascade-check
//
// Phase 2 적용: CRUD_TYPE marker (cell 편집 시 'U' 마킹) + grid.refreshRange

interface UseCellEditCascadeOptions {
  gridRef: React.RefObject<FlexGridType<MktFcstRow> | null>;
  onRowModified?: (row: MktFcstRow) => void;
}

export const useMktForecastCellEditCascade = ({
  gridRef,
  onRowModified,
}: UseCellEditCascadeOptions) => {
  // cellEditEnded handler — Wijmo FlexGrid event
  const handleCellEditEnded = (
    _sender: FlexGridType<MktFcstRow>,
    e: { row: number; col: number },
  ) => {
    const g = gridRef.current;
    if (!g) return;

    const row = g.rows[e.row]?.dataItem as MktFcstRow | undefined;
    if (!row) return;

    // (4) staging — CRUD_TYPE 'U' 마킹 (단 'I' 신규 row 는 'I' 유지)
    const updated = markRowAsUpdated(row);
    Object.assign(row, updated);

    // (3) cascade-clear — Division 변경 시 종속 컬럼 reset (Phase 3 보강)

    // (2) duplicate-check — Phase 3 spdMain_Changed 30건 검증

    // refreshRange — Wijmo grid 화면 갱신
    g.refresh(false);

    onRowModified?.(row);
  };

  return { handleCellEditEnded };
};
