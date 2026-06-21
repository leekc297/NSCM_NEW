import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { ApprovalRow } from '../auth-approval.types';
import { useAuthApprovalStore } from '../useAuthApprovalStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ApprovalRow> | null>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ApprovalRow[];
}

export const AuthApprovalGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const staticColumns = useAuthApprovalStore(s => s.staticColumns);

  return (
    <DataGrid<ApprovalRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ApprovalRow> | undefined>}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      useCheckbox
      isReadOnly
    />
  );
};
