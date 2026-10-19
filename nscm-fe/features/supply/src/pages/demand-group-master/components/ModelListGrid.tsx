import { AllowMerging, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

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
// GROUP_ID(편집 대상) 병합 제외 — 공용 DataGrid 는 allowMerging prop 이 켜지면 정적 컬럼 전체에
//   일괄 true 를 씌워 컬럼별 지정을 무시한다(DataGrid.tsx mappedStaticColumns). 병합 대상이 아닌
//   컬럼은 updatedLayout effect 로 도로 false 로 돌린다(grid-behavior-parity.md §1.3 표준 패턴,
//   gap-resolve iter-2 G26 — 병합 시 편집 콤보 셀 경계가 사라지는 것을 방지).
const MERGE_EXCLUDED_BINDING = 'GROUP_ID';

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
  //   Division 은 단일선택(GET_GROUP_MASTER 완전일치 제약)이라 searchParams.divisionId 를 그대로 쓴다.
  const [groupMasterRows] = useTabComboQueries({
    filters: [{ comboId: COMBO_ID.GROUP_MASTER, mnuId: MENU_ID }],
  });

  const groupIdComboRows = useMemo(
    () =>
      filterGroupMasterByContext(
        groupMasterRows,
        searchParams.divisionId,
        searchParams.operationGroup
      ),
    [groupMasterRows, searchParams.divisionId, searchParams.operationGroup]
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

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const resetExcludedMerge = () => {
      const col = g.getColumn(MERGE_EXCLUDED_BINDING);
      if (col && col.allowMerging !== false) col.allowMerging = false;
    };
    g.updatedLayout.addHandler(resetExcludedMerge);
    resetExcludedMerge();
    return () => g.updatedLayout.removeHandler(resetExcludedMerge);
  }, [gridRef, columns]);

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
