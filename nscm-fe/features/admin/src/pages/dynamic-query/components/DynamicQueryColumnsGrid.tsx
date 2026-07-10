// SYS0013 Columns Grid — AS-IS View 탭 siGRoup(Column 시트) 정합.
// CRUD = 표준: EditTracker('M' 자동) + GridAction.addRow/removeRow (부모 활성그리드 라우팅).
// AGGREGATE 콤보 = admin 메타 CELL_COMBO_DATA_TYPE='sysAggregateOptions' → CMBO_SQL_M 등록분
//   (DataGrid wrapper 가 cellCboDataTp 로 자동 해석 — 화면 코드 주입 불필요).
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ColumnMetaRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ColumnMetaRow> | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ColumnMetaRow> | undefined>;
  data: ColumnMetaRow[];
}

export const DynamicQueryColumnsGrid = ({ gridRef, editTrackerRef, data }: Props) => {
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.COLUMNS]);

  return (
    <DataGrid<ColumnMetaRow>
      gridRef={gridRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
