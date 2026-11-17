import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { ColumnMeta } from '../delegate.constants';
import { buildColumns } from '../utils/delegateColumns';

interface Props {
  rows: WijmoRowItem[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  columnMeta: ColumnMeta[];
  adminColumns?: RawFlexGridColumnConfig[];
  // Delegate 시트만 CHK 선택(useCheckbox=Selector). Delegated List 는 view-only(false). design 03 §1-B.
  useCheckbox: boolean;
}

// AS-IS spdMain 시트(Delegate / Delegated List) — DIVISION_ID~끝열 LockColumn(전칼럼 읽기전용).
//   AS-IS 는 SmartColMerge() 를 호출하나(cs:200,208) 실제 셀 병합은 일어나지 않는다: 이 화면은
//   어떤 컬럼에도 MergePolicy.Restricted 를 걸지 않고(SetColumnMerge 미호출) COLMERGE 숨김컬럼도
//   없어 SmartColMergeOld() 가 병합 기준 컬럼을 못 찾고 즉시 return(SpreadInfo.cs:13225-13240).
//   데이터 바인딩 후 재병합 호출도 주석처리됨(cs:322). 따라서 TO-BE 도 셀 병합을 켜지 않는다
//   (allowMerging 미지정 = DataGrid 기본값 ColumnHeaders: 헤더만 병합, 셀 데이터 병합 없음).
//   선택은 공용 DataGrid useCheckbox(Selector, rowHeader 체크박스 + 헤더 전체선택 = AS-IS
//   SpdMain_CellClick 헤더 토글 전행선택 등가, design 03 §3).
export const DelegateGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  columnMeta,
  adminColumns,
  useCheckbox,
}: Props) => {
  const columns = useMemo(() => buildColumns(columnMeta, adminColumns), [columnMeta, adminColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={rows}
      staticColumns={columns}
      useCheckbox={useCheckbox}
    />
  );
};
