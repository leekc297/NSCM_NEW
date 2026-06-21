// SYS0013 Columns Grid — AS-IS SCM0005_DynamicQueryList.cs SaveData L845-879 정합.
// 컬럼: COLUMN_NAME (편집)/VALUE_YN/VALUE_TYPE/VALID_YN/SEQNO (admin staticColumns).
// CRUD: 자체 Add/Delete 버튼 + cellEditEnded → store.columnsPendingChanges.
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ColumnMetaRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ColumnMetaRow> | null>;
  data: ColumnMetaRow[];
}

const EDITABLE_BINDINGS = new Set([
  'COLUMN_NAME',
  'VALUE_YN',
  'VALUE_TYPE',
  'VALID_YN',
  'SEQNO',
]);

export const DynamicQueryColumnsGrid = ({ gridRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.COLUMNS]);
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const columnsPendingChanges = useDynamicQueryStore(s => s.columnsPendingChanges);
  const columnsInsertedRows = useDynamicQueryStore(s => s.columnsInsertedRows);
  const trackColumnsInsert = useDynamicQueryStore(s => s.trackColumnsInsert);
  const trackColumnsModify = useDynamicQueryStore(s => s.trackColumnsModify);
  const trackColumnsDelete = useDynamicQueryStore(s => s.trackColumnsDelete);

  const enrichedData = useMemo<ColumnMetaRow[]>(() => {
    const deletedKeys = new Set(
      Object.entries(columnsPendingChanges)
        .filter(([, c]) => c.crudType === 'D')
        .map(([k]) => k)
    );
    const visible = data.filter(r => !deletedKeys.has(String(r.COLUMN_NAME)));
    return [...visible, ...(columnsInsertedRows as unknown as ColumnMetaRow[])];
  }, [data, columnsInsertedRows, columnsPendingChanges]);

  const handleCellEditEnded = (g: FlexGrid<ColumnMetaRow>, e: { row: number; col: number }) => {
    const row = g.rows[e.row]?.dataItem as ColumnMetaRow | undefined;
    if (!row || !row.COLUMN_NAME) return;
    trackColumnsModify(String(row.COLUMN_NAME), row as unknown as Record<string, unknown>);
  };

  const handleAdd = () => {
    if (!selectedQueryId || selectedQueryId.startsWith('TEMP_')) return;
    trackColumnsInsert(Number(selectedQueryId), {
      VALUE_YN: 'Y',
      VALUE_TYPE: 'System.String',
      VALID_YN: 'Y',
      SEQNO: '0',
    });
  };

  const handleDelete = () => {
    const sel = gridRef.current?.selectedItems?.[0] as ColumnMetaRow | undefined;
    if (!sel?.COLUMN_NAME) return;
    trackColumnsDelete(String(sel.COLUMN_NAME));
  };

  // Edit 활성화 — beginningEdit handler (메모리 #70 P7).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const onBeginningEdit = (
      sender: FlexGrid<ColumnMetaRow>,
      e: { cancel: boolean; col: number; row: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (EDITABLE_BINDINGS.has(binding)) e.cancel = false;
    };
    grid.beginningEdit.addHandler(onBeginningEdit);
    return () => {
      grid.beginningEdit.removeHandler(onBeginningEdit);
    };
  }, [gridRef]);

  const disabled = !selectedQueryId || selectedQueryId.startsWith('TEMP_');

  return (
    <>
      <div style={{ padding: '4px 0', display: 'flex', gap: 8 }}>
        <button onClick={handleAdd} disabled={disabled}>
          + Add Column
        </button>
        <button onClick={handleDelete} disabled={disabled}>
          - Delete Column
        </button>
      </div>
      <DataGrid<ColumnMetaRow>
        gridRef={gridRef as MutableRefObject<FlexGrid<ColumnMetaRow> | undefined>}
        itemsSource={enrichedData}
        staticColumns={staticColumns}
        cellEditEnded={handleCellEditEnded}
      />
    </>
  );
};
