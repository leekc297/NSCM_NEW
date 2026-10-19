import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { MENU_ID } from '../shipment-change-request.constants';
import type { SubRow } from '../shipment-change-request.types';
import { buildColumns } from '../utils/shipmentChangeRequestColumns';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
}

// AS-IS spdSub "Change Request" (58열, 전량 읽기전용 siSub.LockColumn :1824).
//   2단 헤더 Confirmed/Change(SMALL_CLASS_LABEL_NAME, hook #93 48px) — admin 메타 클래스라벨 유지.
export const ShipmentChangeRequestSubGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  adminColumns,
}: Props) => {
  const columns = useMemo(() => buildColumns(adminColumns, true), [adminColumns]);
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      // GAP-MERGE-SUB: AS-IS siSub.SmartColMerge()(cs:615/1833) 셀 병합 재현 —
      //   공용 DataGrid 가 allowMerging≠None 시 CustomMergeManager(좌측누적) 자동 배선(DataGrid.tsx:1339).
      //   읽기전용 비교 그리드라 신규행 없음, CHK 컬럼 부재(admin 메타).
      allowMerging={AllowMerging.Cells}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
    />
  );
};
