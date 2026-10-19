import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { DetailRow } from '../master-validation.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<DetailRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: DetailRow[];
  staticColumns: RawFlexGridColumnConfig[];
  gotFocus?: () => void;
}

// detail(결과) 그리드(siProjectRoute) — 활성 검증유형 sheetNm 별 정적 컬럼셋(admin fetch) + SP 결과.
//   전 컬럼 read-only(design 03 §3 R21).
export const MasterValidationDetailGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  gotFocus,
}: Props) => (
  <DataGrid<DetailRow>
    gridRef={gridRef}
    gridFilterRef={gridFilterRef}
    isReadOnly
    itemsSource={data}
    staticColumns={staticColumns}
    gotFocus={gotFocus}
  />
);
