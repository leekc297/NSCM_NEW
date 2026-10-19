import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MENU_ID } from '../shipment-change-request-confirm-ssp0003.constants';
import type { MainRow } from '../shipment-change-request-confirm-ssp0003.types';
import { buildColumns } from '../utils/shipmentChangeRequestConfirmSsp0003Columns';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
  // 마스터행 더블클릭 -> 디테일/위임자 로드 + 액션버튼 Visibility 판정(design 01 §2-A, 진입가드 §4d G2/G3 Rows>0).
  onRowDblClick: (row: Record<string, unknown>) => void;
}

// AS-IS spdMain "Shipment Change Request Confirm" (22열). 전열 LockColumn = 조회전용(편집 컬럼 0, design 03 §1.1 · §3.3 #38).
//   셀콤보 6종(CHANGE_TYPE/SHIPMENT_STATUS/CHANGE_REASON_CODE/REQUEST·APPROVAL·DELEGATEE_DEPT)은 표시전용 code->label(admin 메타).
export const ShipmentChangeRequestConfirmSsp0003MainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  adminColumns,
  onRowDblClick,
}: Props) => {
  const columns = useMemo(() => buildColumns(adminColumns, false), [adminColumns]);
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // 마스터행 더블클릭 -> 디테일 로드(진입가드: 데이터 셀 + 행 존재, G2/G3). AS-IS IsLock==true 는 조회전용 상시 성립.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    onRowDblClick(row);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // AS-IS 셀 병합 없음(InitSpread 병합 신호 0 · SmartColMerge 미호출, react-gap-audit iter-1 SSP0003-06) → 파리티상 병합 비활성.
      allowMerging={AllowMerging.None}
      dblClick={handleDblClick}
    />
  );
};
