import { Button } from '@lges/design-system';
import {
  CellType,
  type FlexGrid as TFlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { CustomDialog } from '@shared/components';
import { useDataGridStore } from '@shared/stores';

import { MoveType } from './components/column-grid.constants';
import { ColumnGrids } from './components/ColumnGrids';
import { ControlButtonGroup } from './components/ControlButtonGroup';

const defaultColumnProps = {
  allowSorting: false,
};

const candidateGridColumnGroups: FlexGridColumnConfig[] = [
  { ...defaultColumnProps, binding: 'binding', header: 'Large Class', isReadOnly: true },
  { ...defaultColumnProps, binding: 'binding', header: 'Small Class', isReadOnly: true },
  { ...defaultColumnProps, binding: 'binding', header: 'Column', isReadOnly: true },
];

const selectedGridColumnGroups: FlexGridColumnConfig[] = [
  { ...defaultColumnProps, binding: 'binding', header: 'Large Class', isReadOnly: true },
  { ...defaultColumnProps, binding: 'binding', header: 'Small Class', isReadOnly: true },
  { ...defaultColumnProps, binding: 'binding', header: 'Column', isReadOnly: true },
  { ...defaultColumnProps, binding: 'SORT', header: 'Sort', isReadOnly: false },
];

export const ColumnButton = () => {
  const { candidateColumns, staticColumns, fetchStaticColumns, saveStaticColumns } =
    useDataGridStore();

  const [open, setOpen] = useState<boolean>(false);
  const [candidateItems, setCandidateItems] = useState<FlexGridColumnConfig[]>([]);
  const [selectedItems, setSelectedItems] = useState<FlexGridColumnConfig[]>([]);

  const candidateGridRef = useRef<TFlexGrid | null>(null);
  const candidateGridFilterRef = useRef<FlexGridFilter | null>(null);
  const selectedGridRef = useRef<TFlexGrid | null>(null);
  const selectedGridFilterRef = useRef<FlexGridFilter | null>(null);

  const initGrid = (grid: TFlexGrid, type: MoveType) => {
    if (type === MoveType.FROM_CANDIDATE) {
      candidateGridRef.current = grid;
      candidateGridFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });
    } else if (type === MoveType.FROM_SELECTED) {
      selectedGridRef.current = grid;
      selectedGridFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });
    }

    const starOnRequiredRows = (sender: TFlexGrid, event: FormatItemEventArgs) => {
      const panel = event.panel;
      if (panel.cellType !== CellType.Cell) return;

      const dataItem: unknown = grid.rows[event.row].dataItem;
      const binding = grid.columns[event.col].binding;

      if (
        dataItem &&
        typeof dataItem === 'object' &&
        'isRequired' in dataItem &&
        dataItem.isRequired &&
        binding !== 'SORT'
      ) {
        event.cell.textContent = event.cell.textContent + '*';
      }

      if (binding === 'SORT') {
        event.cell.classList.add('wj-cell-editable');
      }
    };

    grid.formatItem.addHandler(starOnRequiredRows);
  };

  const onClose = () => {
    setOpen(false);
  };

  const handleOpen = () => {
    setOpen(true);
    setCandidateItems(candidateColumns);
    setSelectedItems(staticColumns);
  };

  const handleMove = (type: MoveType) => {
    const fromGrid =
      type === MoveType.FROM_CANDIDATE ? candidateGridRef.current : selectedGridRef.current;
    const toGrid =
      type === MoveType.FROM_SELECTED ? selectedGridRef.current : candidateGridRef.current;

    if (fromGrid === null || toGrid === null) return;

    const selection = fromGrid.selectedItems as FlexGridColumnConfig[];
    const targetIndex = toGrid.selection.row + 1;

    const selectionSet = new Set(selection);

    if (type === MoveType.FROM_CANDIDATE) {
      setCandidateItems(prev => prev.filter(item => !selectionSet.has(item)));
      setSelectedItems(prev => [
        ...prev.slice(0, targetIndex),
        ...selection,
        ...prev.slice(targetIndex),
      ]);
    } else if (type === MoveType.FROM_SELECTED) {
      setSelectedItems(prev =>
        prev.filter(item => !selectionSet.has(item) || (selectionSet.has(item) && item.isRequired))
      );
      setCandidateItems(prev => [
        ...prev.slice(0, targetIndex),
        ...selection.filter(item => !item.isRequired),
        ...prev.slice(targetIndex),
      ]);
    }
  };

  const handleDefault = () => {
    setCandidateItems(candidateColumns);
    setSelectedItems(staticColumns);
  };

  const handleOk = async () => {
    // TODO: Save 오류 handle 필요 - 강민재
    await saveStaticColumns(selectedItems);
    await fetchStaticColumns();
    onClose();
  };

  const handleCancel = () => {
    onClose();
  };

  useEffect(() => {
    // return ();
  }, []);

  return (
    <>
      <Button onClick={handleOpen} buttonLabel='Columns' />
      {open && (
        <CustomDialog
          open={open}
          handleClose={onClose}
          type='modaless'
          position='basic'
          size={1200}
          customContentArea={
            <>
              <ColumnGrids
                candidateItems={candidateItems}
                selectedItems={selectedItems}
                candidateGridColumnGroups={candidateGridColumnGroups}
                selectedGridColumnGroups={selectedGridColumnGroups}
                initGrid={initGrid}
                handleMove={handleMove}
              />
              <ControlButtonGroup
                handleDefault={handleDefault}
                handleOk={handleOk}
                handleCancel={handleCancel}
              />
            </>
          }
        />
      )}
    </>
  );
};
