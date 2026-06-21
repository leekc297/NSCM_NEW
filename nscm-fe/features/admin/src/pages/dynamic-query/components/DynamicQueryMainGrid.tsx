// SYS0013 Main grid — AS-IS SCM0005_DynamicQueryList.cs L208-228 정합.
// CRUD: Insert/Edit/Delete 추적 → store.mainPendingChanges → SAVE 시 P_SYS0013_SAVE_QUERY_LIST.
// 메모리 룰 #70 P7: beginningEdit handler 등록 — 의도 binding 만 e.cancel=false override (Edit 활성).
import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { QueryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<QueryRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: QueryRow[];
}

// 편집 허용 binding (AS-IS EditButton L301-316 — ROLE/CREATED_BY~ADMIN_ONLY_YN 잠금).
const EDITABLE_BINDINGS = new Set([
  'DQ_NAME',
  'DESCRIPTION',
  'DQ_TEXT',
  'VALID_YN',
  'ADMIN_ONLY_YN',
  'DIVISION_ID',
]);

export const DynamicQueryMainGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.MAIN]);
  const trackMainModify = useDynamicQueryStore(s => s.trackMainModify);

  const handleSelectionChanged = (g: FlexGrid<QueryRow>) => {
    const row = g.selectedItems[0] as QueryRow | undefined;
    const dqId = row?.DQ_ID;
    if (dqId !== undefined && dqId !== null && dqId !== '') {
      setSelectedQueryId(String(dqId));
    }
  };

  const handleCellEditEnded = (g: FlexGrid<QueryRow>, e: { row: number; col: number }) => {
    const row = g.rows[e.row]?.dataItem as QueryRow | undefined;
    if (!row) return;
    const id = row.DQ_ID;
    if (id === undefined || id === null || id === '') return;
    trackMainModify(String(id), row as unknown as Record<string, unknown>);
  };

  // beginningEdit handler 등록 — admin 메타 INPUT_TP_CD 무관하게 의도 binding 편집 허용.
  // (메모리 #70 P7 — wrapper 의 isEditableCell 이 INPUT_TP_CD='S' 시 cancel=true → override 의무)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const onBeginningEdit = (
      sender: FlexGrid<QueryRow>,
      e: { cancel: boolean; col: number; row: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (EDITABLE_BINDINGS.has(binding)) {
        e.cancel = false;
      }
    };
    grid.beginningEdit.addHandler(onBeginningEdit);
    return () => {
      grid.beginningEdit.removeHandler(onBeginningEdit);
    };
  }, [gridRef]);

  return (
    <DataGrid<QueryRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<QueryRow> | undefined>}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      selectionMode={SelectionMode.Row}
      selectionChanged={handleSelectionChanged}
      cellEditEnded={handleCellEditEnded}
    />
  );
};
