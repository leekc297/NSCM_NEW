import type { CellRangeEventArgs, FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS } from '../shipment-request-pack.constants';
import type { RequestDetailRow, ResultDetailRow } from '../shipment-request-pack.types';
import { isRequestDetailCellEditable } from '../utils/shipment-request-pack.editLock';

interface Props<Row extends RequestDetailRow | ResultDetailRow> {
  sheet: SHEETS.REQUEST_DETAIL | SHEETS.RESULT_DETAIL;
  rows: Row[];
  gridRef: MutableRefObject<FlexGridType<Row> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<Row> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  onFocus: () => void;
}

/**
 * spdDetail — Request Detail(편집 대상) / Result Detail(항상 읽기전용) 공용 그리드(design 03 §1.3/§1.4).
 * Result Detail 은 Edit 버튼 클릭 자체가 MSG00109로 차단되므로(design 01 R8) 이 컴포넌트는 항상
 * `isReadOnly` 를 강제한다. Request Detail 은 신규행(CRUD_TYPE='I') 은 편집모드 전체 unlock,
 * 기존행은 `EDIT_FLAG=='Y'` 인 행만 [Qty..REMARK] 컬럼만 unlock 된다(R6/R8,
 * `shipment-request-pack.editLock.isRequestDetailCellEditable`).
 *
 * 미완(04_react-gap.md): 신규행(R10)의 Division+1~2/ShipToCode+2~3/NickName+1/Requestor~EditFlag/
 * FromSite+1/Remark+1~끝 오프셋 잠금은 실 컬럼 바인딩 매핑이 design 문서에 확정되지 않아(확인 필요)
 * 이번 회차는 임의 추정 없이 전체 unlock 으로 남긴다(회귀 방지 우선).
 */
export const ShipmentRequestPackDetailGrid = <Row extends RequestDetailRow | ResultDetailRow>({
  sheet,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  isEditMode,
  onFocus,
}: Props<Row>) => {
  const isResultDetail = sheet === SHEETS.RESULT_DETAIL;

  const handleBeginningEdit = (grid: FlexGridType<Row>, e: CellRangeEventArgs) => {
    const column = grid.columns[e.col];
    const dataItem = GridUtils.getRow(grid, e.row) as
      | (Row & { CRUD_TYPE?: string; EDIT_FLAG?: string })
      | undefined;
    if (!column?.binding || !dataItem) return;
    const editable = isRequestDetailCellEditable({
      columnBinding: column.binding,
      crudType: dataItem.CRUD_TYPE,
      editFlag: dataItem.EDIT_FLAG,
      isEditMode,
    });
    if (!editable) e.cancel = true;
  };

  return (
    <DataGrid<Row>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      isReadOnly={isResultDetail}
      beginningEdit={isResultDetail ? undefined : handleBeginningEdit}
      gotFocus={onFocus}
    />
  );
};
