import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../constraint-mgmt.constants';
import type { DetailRow } from '../constraint-mgmt.types';
import { useConstraintMgmtStore } from '../useConstraintMgmtStore';
import { applyCanEditGuard } from '../utils/constraintMgmt.editGuard';

interface ConstraintMgmtDetailGridProps {
  gridRef: MutableRefObject<FlexGrid<DetailRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<DetailRow> | undefined>;
  data: DetailRow[];
  /**
   * 동적 3축이 적용된 파생 컬럼셋. 이 컴포넌트가 직접 만들지 않고 상위에서 받는다 —
   * 저장 필수검증(saveWithValidation)이 같은 컬럼셋을 써야 동적 `*` 가 실제로 걸린다.
   */
  staticColumns: RawFlexGridColumnConfig[];
  canEdit: boolean;
  /** LOOKUP_TYPE 컬럼 더블클릭 재조회(2026-11-09). 권한 게이트·미저장 변경 확인은 상위에서 처리한다. */
  onRefresh: () => void;
}

/** 하단 Lookup Values 그리드. 컬럼 라벨·표시는 선택한 마스터 행이 런타임에 결정한다. */
export const ConstraintMgmtDetailGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  canEdit,
  onRefresh,
}: ConstraintMgmtDetailGridProps) => {
  const setActiveGrid = useConstraintMgmtStore(state => state.setActiveGrid);

  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    return applyCanEditGuard(grid, canEditRef);
  }, [gridRef, staticColumns]);

  const handleGotFocus = () => {
    setActiveGrid('sub');
  };

  /**
   * 더블클릭 재조회(2026-11-09, LOOKUP_TYPE 컬럼 한정 2026-11-09 추가 지시) — Master 그리드와
   * 같은 가드다(ConstraintMgmtMasterGrid.handleDblClick 주석 참조). LOOKUP_TYPE 외 컬럼
   * 더블클릭은 재조회를 걸지 않아 "수정 중인 데이터가 있습니다" 확인창이 편집과 섞여 뜨지 않는다.
   */
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (GridUtils.getBinding(grid, hitTest.col) !== 'LOOKUP_TYPE') return;
    if (grid.activeEditor) grid.finishEditing(true);
    onRefresh();
  };

  return (
    <DataGrid<DetailRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      sheetName={SHEETS.LOOKUP_DETAIL}
      gotFocus={handleGotFocus}
      dblClick={handleDblClick}
    />
  );
};
