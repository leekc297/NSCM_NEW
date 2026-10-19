import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../constraint-mgmt.constants';
import type { MasterRow } from '../constraint-mgmt.types';
import { useConstraintMgmtStore } from '../useConstraintMgmtStore';
import { applyCanEditGuard } from '../utils/constraintMgmt.editGuard';

interface ConstraintMgmtMasterGridProps {
  gridRef: MutableRefObject<FlexGrid<MasterRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MasterRow> | undefined>;
  data: MasterRow[];
  canEdit: boolean;
}

/** 상단 Lookup Type 그리드. 더블클릭이 하단의 컬럼 사전과 조회 키를 동시에 만든다. */
export const ConstraintMgmtMasterGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  canEdit,
}: ConstraintMgmtMasterGridProps) => {
  const staticColumns = useConstraintMgmtStore(state => state.staticColumns.lookupMaster);
  const setActiveGrid = useConstraintMgmtStore(state => state.setActiveGrid);
  const setSubFilters = useConstraintMgmtStore(state => state.setSubFilters);
  const applyDynamicSubColumns = useConstraintMgmtStore(state => state.applyDynamicSubColumns);

  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    return applyCanEditGuard(grid, canEditRef);
  }, [gridRef, staticColumns]);

  const handleGotFocus = () => {
    setActiveGrid('main');
  };

  /**
   * 마스터 더블클릭 -> Sub 컬럼 재구성 + Sub 조회(drill-down).
   *
   * AS-IS 가드 3개 중 첫 번째(`siMain.IsLock==true` 일 때만 = Main 이 조회모드일 때만)는
   * 이식하지 않는다 — 편집이 기본값인 TO-BE 에서는 그 가드가 Sub 조회를 영구 차단한다
   * (decisions.md §2). 나머지 2개(행 존재 / LOOKUP_TYPE 비어있지 않음)는 유지한다.
   *
   * 수정 가능한 컬럼을 더블클릭하면 편집 진입이 목적이므로 하단 조회(drill-down)를 걸지 않는다.
   * 잠금 컬럼(INPUT_TP_CD='S')이나 편집권한 없음(canEdit=false)일 때만 조회로 넘어간다.
   */
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (canEditRef.current && GridUtils.isEditableCell(grid, hitTest.row, hitTest.col)) return;

    const dataItem = GridUtils.getRow(grid, hitTest.row);
    if (!dataItem) return;

    const lookupType = String(dataItem.LOOKUP_TYPE ?? '');
    if (!lookupType) return;

    applyDynamicSubColumns(dataItem);
    setSubFilters(lookupType);
  };

  return (
    <DataGrid<MasterRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      sheetName={SHEETS.LOOKUP_MASTER}
      gotFocus={handleGotFocus}
      dblClick={handleDblClick}
    />
  );
};
