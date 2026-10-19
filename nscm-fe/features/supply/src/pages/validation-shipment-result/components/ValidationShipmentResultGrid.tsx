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

// 2단 헤더(SMALL_CLASS 그룹)에서 leaf(아래쪽) 헤더 row 높이(px). 기본 높이로는 컬럼명이 세로로
//   잘려 가독성이 떨어져 이 row 만 키운다(상단 그룹 row 는 기본 유지). 공용 headerRowHeight prop 은
//   모든 헤더 row 를 같은 높이로 강제하므로 쓰지 않고, 아래 initialized 에서 leaf row 만 지정한다.
const LEAF_HEADER_ROW_HEIGHT = 44;

// 읽기전용 조회 그리드(design 03) — 컬럼셋/2단헤더(SMALL_CLASS)/정렬/폭/셀유형 전부 SCM_MST_SHEET_COLUMNS
//   메타 구동(staticColumns, 하드코딩 22 리터럴 사문 금지). 전 컬럼 Lock(#29 + INPUT_TP_CD 'S') = editable
//   false — EditTracker/편집셀 미배선. 셀 병합/Freeze/셀콤보/PIVOT 없음(design 03 §2.1·§3).
//   isReadOnly: CRUD 없는 조회전용이므로 row header 의 상태(I/M/D) 컬럼을 생성하지 않는다
//   (DataGrid.tsx:1553 — isReadOnly 일 때 상태 컬럼 push 를 건너뜀). 편집가능 스타일도 억제된다.
export const ValidationShipmentResultGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const staticColumns = useValidationShipmentResultStore(state => state.staticColumns);

  // leaf(아래쪽) 헤더 row 만 높이를 키운다. columnGroups 재대입 때마다 헤더 row 높이가 리셋되므로
  //   updatedLayout(매 layout refresh 후)에 재적용한다. guard: 이미 목표 높이면 skip(무한 루프 방지).
  const handleInitialized = (grid: FlexGrid<ValidationShipmentResultRow>) => {
    grid.updatedLayout.addHandler(() => {
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length < 2) return; // 단단 헤더면 무영향
      const leafRow = headerRows[headerRows.length - 1];
      if (Math.round(leafRow.height ?? 0) === LEAF_HEADER_ROW_HEIGHT) return;
      leafRow.height = LEAF_HEADER_ROW_HEIGHT;
    });
  };

  return (
    <DataGrid<ValidationShipmentResultRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      initialized={handleInitialized}
      isReadOnly
    />
  );
};
