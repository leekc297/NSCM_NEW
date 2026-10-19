import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo, useRef } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  ACTIVE_GRID,
  COMBO_ID,
  MENU_ID,
  SHEETS,
  SUB_EDITABLE_COLUMNS,
} from '../demand-group-master.constants';
import type { ModelListRow } from '../demand-group-master.types';
import { useDemandGroupMasterStore } from '../useDemandGroupMasterStore';
import { buildGridColumns } from '../utils/demand-group-master.columns';
import { filterGroupMasterByContext } from '../utils/demand-group-master.combos';

// 세로 병합 대상 = 식별/표시 컬럼(값 반복 시 collapse — AS-IS spdSub SmartColMerge cs L1082).
//   편집 대상 GROUP_ID 는 제외한다.
const MERGE_COLUMNS = new Set(['DIVISION_ID', 'PROJECT_CODE', 'PROJECT_NAME', 'ITEM_ID']);

interface ModelListGridProps {
  gridRef: MutableRefObject<FlexGrid<ModelListRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ModelListRow[];
  onFocus: (grid: ACTIVE_GRID) => void;
}

export const ModelListGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onFocus,
}: ModelListGridProps) => {
  const editTrackerRef = useRef<EditTracker<ModelListRow> | undefined>();
  const staticColumns = useDemandGroupMasterStore(state => state.staticColumns);
  const searchParams = useDemandGroupMasterStore(state => state.searchParams);

  // GROUP_ID 셀 콤보 후보 — GroupMaster_SCP_ALL 에 AS-IS 클라 좁힘(division+opGroup) 재현.
  //   division 다중 체크의 첫 코드 + 현재 operationGroup 기준(AS-IS 는 조회 선택값으로 좁힘).
  const [groupMasterRows] = useTabComboQueries({
    filters: [{ comboId: COMBO_ID.GROUP_MASTER, mnuId: MENU_ID }],
  });

  const firstDivision = searchParams.divisionId.split(',')[0] ?? '';
  const groupIdComboRows = useMemo(
    () => filterGroupMasterByContext(groupMasterRows, firstDivision, searchParams.operationGroup),
    [groupMasterRows, firstDivision, searchParams.operationGroup]
  );

  const columns = useMemo(
    () =>
      buildGridColumns(staticColumns[SHEETS.MODEL_LIST], SUB_EDITABLE_COLUMNS, {
        GROUP_ID: groupIdComboRows,
      }).map(col =>
        MERGE_COLUMNS.has(col.colNm) ? { ...col, allowMerging: true } : col
      ),
    [staticColumns, groupIdComboRows]
  );

  return (
    <DataGrid<ModelListRow>
      key={columns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={columns}
      allowMerging={AllowMerging.Cells}
      alternatingRowStep={0}
      gotFocus={() => onFocus(ACTIVE_GRID.SUB)}
    />
  );
};
