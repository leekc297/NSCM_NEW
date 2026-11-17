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
  /** 하단 미저장 변경을 버리고 진행해도 되는지. 변경이 없으면 바로 true 다. */
  confirmDiscardDetail: () => Promise<boolean>;
}

/** 상단 Lookup Type 그리드. 행 클릭이 하단의 컬럼 사전과 조회 키를 동시에 만든다. */
export const ConstraintMgmtMasterGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  canEdit,
  confirmDiscardDetail,
}: ConstraintMgmtMasterGridProps) => {
  const staticColumns = useConstraintMgmtStore(state => state.staticColumns.lookupMaster);
  const setActiveGrid = useConstraintMgmtStore(state => state.setActiveGrid);
  const setSubFilters = useConstraintMgmtStore(state => state.setSubFilters);
  const applyDynamicSubColumns = useConstraintMgmtStore(state => state.applyDynamicSubColumns);
  const mainLookupType = useConstraintMgmtStore(state => state.mainLookupType);
  const mainLookupTypeRef = useRef(mainLookupType);
  mainLookupTypeRef.current = mainLookupType;

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
   * 마스터 클릭 -> Sub 컬럼 재구성 + Sub 조회(drill-down).
   *
   * AS-IS 는 spdMain.CellDoubleClick 이지만 TO-BE 는 단일 클릭으로 조회한다(2026-11-04).
   * 더블클릭도 클릭 두 번이라 그대로 조회된다.
   *
   * AS-IS 가드 3개 중 첫 번째(`siMain.IsLock==true` 일 때만 = Main 이 조회모드일 때만)는
   * 이식하지 않는다 — 편집이 기본값인 TO-BE 에서는 그 가드가 Sub 조회를 영구 차단한다
   * (decisions.md §2). 나머지 2개(행 존재 / LOOKUP_TYPE 비어있지 않음)는 유지한다.
   *
   * 하단에 미저장 변경이 있으면 확인창을 띄우고, 취소하면 하단을 그대로 둔다.
   */
  const handleSelectLookupType = async (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    // 편집 칸에서도 하단 조회되도록 제외(2026-10-15, c55755cf 원복). 원복 시 아래 주석 해제.
    // if (canEditRef.current && GridUtils.isEditableCell(grid, hitTest.row, hitTest.col)) return;

    const dataItem = GridUtils.getRow(grid, hitTest.row);
    if (!dataItem) return;

    const lookupType = String(dataItem.LOOKUP_TYPE ?? '');
    if (!lookupType) return;
    // 이미 하단에 띄운 LOOKUP_TYPE 이면 재조회 생략(2026-10-15).
    if (lookupType === mainLookupTypeRef.current) return;
    if (!(await confirmDiscardDetail())) return;

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
      click={mouseEvent => void handleSelectLookupType(mouseEvent)}
    />
  );
};
