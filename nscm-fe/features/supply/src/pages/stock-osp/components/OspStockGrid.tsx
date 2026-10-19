import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MENU_ID } from '../stock-osp.constants';
import type { OspStockRow } from '../stock-osp.types';

interface Props {
  rows: OspStockRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
}

// SCP0041 Osp Stock 시트 — 14컬럼 전부 조회 전용(design 03 §1-A, INPUT_TP_CD='S').
//   저장 배선 없음(AS-IS 도 Osp 는 조회+Excel Upload 만). 셀 편집가부는 공용 DataGrid 가 메타로 재현.
export const OspStockGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
}: Props) => {
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      comboParams={comboParams}
    />
  );
};
