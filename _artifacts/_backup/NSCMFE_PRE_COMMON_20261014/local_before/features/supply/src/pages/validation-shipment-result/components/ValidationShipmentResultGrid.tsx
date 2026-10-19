import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { useValidationShipmentResultStore } from '../useValidationShipmentResultStore';
import type { ValidationShipmentResultRow } from '../validation-shipment-result.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ValidationShipmentResultRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ValidationShipmentResultRow[];
}

// 읽기전용 조회 그리드(design 03) — 컬럼셋/2단헤더(SMALL_CLASS)/정렬/폭/셀유형 전부 SCM_MST_SHEET_COLUMNS
//   메타 구동(staticColumns, 하드코딩 22 리터럴 사문 금지). 전 컬럼 Lock(#29 + INPUT_TP_CD 'S') = editable
//   false — EditTracker/편집셀 미배선. 셀 병합/Freeze/셀콤보/PIVOT 없음(design 03 §2.1·§3).
export const ValidationShipmentResultGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const staticColumns = useValidationShipmentResultStore(state => state.staticColumns);

  return (
    <DataGrid<ValidationShipmentResultRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
