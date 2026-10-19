// FlexGrid 간 드래그 드랍 hook 작업 중
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGrid as TFlexGrid, Row } from '@mescius/wijmo.grid';
import { useRef } from 'react';

export interface FlexGridRowDnD {
  preventRowHeaderSelectionClear: (grid: TFlexGrid, mouseEvent: MouseEvent) => void;
  dragSourceHandler: (grid: TFlexGrid) => void;
  dropTargetHandler: (grid: TFlexGrid) => void;
}

export const useFlexGridRowDnD = (): FlexGridRowDnD => {
  const originalGrid = useRef<TFlexGrid | null>(null);
  const dragRows = useRef<Row[]>([]);
  const targetRowIndex = useRef<number | null>(null);

  const preventRowHeaderSelectionClear = (grid: TFlexGrid, mouseEvent: MouseEvent) => {
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType === CellType.RowHeader) mouseEvent.stopPropagation();
  };

  const dragSourceHandler = (grid: TFlexGrid) => {
    const _dragSourceHandler = (dragEvent: DragEvent) => {
      const ht = grid.hitTest(dragEvent);
      if (ht.cellType !== CellType.RowHeader) return;
      if (dragEvent.dataTransfer) dragEvent.dataTransfer.effectAllowed = 'copyMove';

      originalGrid.current = grid;
      dragRows.current = [];
      grid.rows.forEach(row => {
        if (row.isSelected) {
          dragRows.current.push(row);
        }
      });
    };

    grid.addEventListener(grid.hostElement, 'dragstart', _dragSourceHandler, true);
  };

  const dropTargetHandler = (grid: TFlexGrid) => {
    const _dragOverHandler = (dragEvent: DragEvent) => {
      if (!dragRows.current) return;

      const ht = grid.hitTest(dragEvent);
      if (ht.cellType === CellType.RowHeader || ht.cellType === CellType.Cell)
        targetRowIndex.current = ht.row;
      else targetRowIndex.current = null;

      if (dragEvent.dataTransfer) dragEvent.dataTransfer.dropEffect = 'copy';

      dragEvent.preventDefault();
    };

    const _dropTargetHandler = (dragEvent: DragEvent) => {
      if (!originalGrid.current) return;

      const ht = grid.hitTest(dragEvent);

      if (!dragRows.current) return;
      const cv: unknown[] = grid.collectionView.sourceCollection;
      const newSource = [...cv];
      dragRows.current.forEach((row, idx) => {
        const newItem: unknown = { ...row.dataItem };
        newSource.splice(ht.row + idx, 0, newItem);
      });

      grid.collectionView.sourceCollection = newSource;
      dragEvent.preventDefault();
    };

    grid.hostElement.addEventListener('dragover', _dragOverHandler);
    grid.hostElement.addEventListener('drop', _dropTargetHandler);
  };

  return {
    dragSourceHandler,
    dropTargetHandler,
    preventRowHeaderSelectionClear,
  };
};
