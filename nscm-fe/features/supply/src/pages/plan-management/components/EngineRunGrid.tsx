import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { EngineRow } from '../plan-management.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  rows: EngineRow[];
  staticColumns: RawFlexGridColumnConfig[];
}

const cell = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Detail Grid(하단) — 선택 Version 의 Engine 수립 진행 정보(읽기전용, 화면설계서 Detail Grid).
//   컬럼명 매핑: 사용자 선등록 SHEET_COLUMNS 의 STEP/PROGRESS ↔ SP O_RC 의 PROGRESS_CODE/PROGRESS_TEXT.
//   그리드 binding 은 COLUMN_NAME(STEP/PROGRESS)이라 행에 그 키 별칭을 심어 바인딩되게 한다.
export const EngineRunGrid = ({ gridRef, gridFilterRef, rows, staticColumns }: Props) => {
  const itemsSource = useMemo(
    () =>
      rows.map(r => ({
        ...r,
        STEP: cell(r.PROGRESS_CODE),
        PROGRESS: cell(r.PROGRESS_TEXT),
      })),
    [rows]
  );

  return (
    <DataGrid<EngineRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource as EngineRow[]}
      staticColumns={staticColumns}
      isReadOnly
    />
  );
};
