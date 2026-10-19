import type { FlexGrid } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BATCH_LOG_COLUMNS, SHEET_INDEX } from '../batch-log.constants';
import type { MENU_ID, SHEETS } from '../batch-log.constants';

interface BatchLogGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.BATCH_LOG>[];
  // admin(SCM_MST_SHEET_COLUMNS) 등록 컬럼. 있으면 우선, 없으면 BATCH_LOG_COLUMNS fallback.
  adminColumns?: RawFlexGridColumnConfig[];
  setActiveGrid: (activeGrid: SHEET_INDEX) => void;
  onSelectJob: (jobId: string) => void;
}

export const BatchLogGrid = ({
  gridRef,
  gridFilterRef,
  data,
  adminColumns,
  setActiveGrid,
  onSelectJob,
}: BatchLogGridProps) => {
  const handleFocus = () => {
    setActiveGrid(SHEET_INDEX.BATCH_LOG);
  };

  // AS-IS spdMain_CellDoubleClick(cs L254~271): 더블클릭 행의 hidden JOB_ID 추출 →
  //   Step/Hist 재조회(master->detail). JOB_ID = Oracle JOB_NAME(PKG 매핑).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem?.JOB_ID) return;

    // JOB_ID(=JOB_NAME) 는 런타임 항상 문자열이나, 그리드 셀 값 타입은 제네릭 유니온이라
    // (환경별 procedures.d.ts 생성 차이) String 으로 명시 변환한다.
    onSelectJob(String(dataItem.JOB_ID));
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.BATCH_LOG>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={adminColumns && adminColumns.length > 0 ? adminColumns : BATCH_LOG_COLUMNS}
      isReadOnly
      gotFocus={handleFocus}
      dblClick={handleDblClick}
    />
  );
};
