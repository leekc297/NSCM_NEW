import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
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
}

/** 하단 Lookup Values 그리드. 컬럼 라벨·표시는 선택한 마스터 행이 런타임에 결정한다. */
export const ConstraintMgmtDetailGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  canEdit,
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

  return (
    <DataGrid<DetailRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      sheetName={SHEETS.LOOKUP_DETAIL}
      gotFocus={handleGotFocus}
    />
  );
};
