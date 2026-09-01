import { Button } from '@lges/design-system';
import { ArrowChevronIcon } from '@lges/design-system/icon';
import type { FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import { FlexGrid } from '@mescius/wijmo.react.grid';

import type { FlexGridColumnConfig } from '@foundation/models';

import { MoveType } from './column-grid.constants';

interface ColumnGridsProps {
  candidateItems: FlexGridColumnConfig[];
  selectedItems: FlexGridColumnConfig[];
  candidateGridColumnGroups: FlexGridColumnConfig[];
  selectedGridColumnGroups: FlexGridColumnConfig[];
  initGrid: (grid: TFlexGrid, type: MoveType) => void;
  handleMove: (type: MoveType) => void;
}

export const ColumnGrids = ({
  candidateItems,
  selectedItems,
  candidateGridColumnGroups,
  selectedGridColumnGroups,
  initGrid,
  handleMove,
}: ColumnGridsProps) => {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'center',
        height: '300px',
      }}
    >
      <FlexGrid
        initialized={(grid: TFlexGrid) => initGrid(grid, MoveType.FROM_CANDIDATE)}
        itemsSource={candidateItems}
        columnGroups={candidateGridColumnGroups}
      />
      <div
        style={{
          gap: '10px',
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          margin: '0 10px',
        }}
      >
        <Button
          appearance='outlined'
          iconComponent={<ArrowChevronIcon direction='right' appearance='single' />}
          onClick={() => handleMove(MoveType.FROM_CANDIDATE)}
        />
        <Button
          appearance='outlined'
          iconComponent={<ArrowChevronIcon direction='left' appearance='single' />}
          onClick={() => handleMove(MoveType.FROM_SELECTED)}
        />
      </div>
      <FlexGrid
        initialized={(grid: TFlexGrid) => initGrid(grid, MoveType.FROM_SELECTED)}
        itemsSource={selectedItems}
        columnGroups={selectedGridColumnGroups}
      />
    </div>
  );
};
