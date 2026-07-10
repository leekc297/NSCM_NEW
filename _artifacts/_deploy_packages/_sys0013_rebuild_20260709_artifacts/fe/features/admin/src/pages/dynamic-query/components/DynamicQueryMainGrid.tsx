// SYS0013 Main grid — AS-IS SCM0005 spdMain (Register 목록) 정합.
// CRUD = 표준: DataGrid 내장 EditTracker(수정 'M' 자동 마킹) + GridAction.addRow/removeRow (부모 라우팅).
// 더블클릭 = Designer(View) 진입 (AS-IS spdMain_CellDoubleClick L969 — 미저장 신규(I) 행은 차단 L974).
import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS, SHEET_INDEX } from '../dynamic-query.constants';
import type { QueryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<QueryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<QueryRow> | undefined>;
  data: QueryRow[];
  // 행 더블클릭 → SQL Query 편집 모달 (AS-IS 팝업 정합 — 2026-07-09 복원). View 탭은 탭 클릭 진입.
  onEditRow?: (row: QueryRow) => void;
  // Designer 진입 후 숨겨진 grid 재선택이 selectedQueryId 를 덮어쓰지 않도록 가드.
  activePage?: SHEET_INDEX;
}

export const DynamicQueryMainGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  onEditRow,
  activePage,
}: Props) => {
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.MAIN]);

  // Register 탭일 때만 selectionChanged 가 selectedQueryId 갱신 — ref 동기화로
  // dblclick 직후 탭전환 spurious selectionChanged race 차단.
  const activePageRef = useRef(activePage);
  activePageRef.current = activePage;

  const handleSelectionChanged = (g: FlexGrid<QueryRow>) => {
    if (activePageRef.current !== SHEET_INDEX.REGISTER) return;
    const row = g.selectedItems[0] as QueryRow | undefined;
    // 신규(I) 행은 DQ_ID 미채번 — 선택만으로 child fetch 트리거하지 않음.
    if (row?.CRUD_TYPE === CRUD_TYPE.INSERT) {
      setSelectedQueryId('');
      return;
    }
    const dqId = row?.DQ_ID;
    if (dqId !== undefined && dqId !== null && dqId !== '') {
      setSelectedQueryId(String(dqId));
    }
  };

  // 더블클릭 → SQL Query 편집 모달 (AS-IS 편집모드 더블클릭=팝업 정합).
  // 저장된 행은 selectedQueryId 도 갱신 (모달 Role/자동채움 + View 탭 진입 준비).
  const handleDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || !onEditRow) return;
    const ht = grid.hitTest(e);
    if (!ht || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as QueryRow | undefined;
    if (!row) return;
    if (row.CRUD_TYPE !== CRUD_TYPE.INSERT && row.DQ_ID) {
      setSelectedQueryId(String(row.DQ_ID));
    }
    onEditRow(row);
  };

  return (
    <DataGrid<QueryRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
      dblClick={handleDblClick}
    />
  );
};
