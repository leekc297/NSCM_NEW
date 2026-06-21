import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { ColumnMetaRow, ResultRow } from '../dynamic-query.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResultRow> | null>;
  data: ResultRow[];
  // SCM_ADM_DQ_COLUMNS 메타 (선택된 query 의 컬럼 정의) — 결과 0 row 일 때 컬럼 헤더 fallback.
  columnsMeta: ColumnMetaRow[];
}

export const DynamicQueryResultGrid = ({ gridRef, data, columnsMeta }: Props) => {
  // 컬럼 우선순위:
  //   1. 결과 row 가 있으면 첫 row 의 key (실 실행 컬럼) — 실 SQL 변형 반영
  //   2. 결과 0 row 면 admin 메타 (columnsMeta) 의 COLUMN_NAME — 빈 결과여도 헤더 표시
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    if (data && data.length > 0) {
      const first = data[0] as Record<string, unknown>;
      return Object.keys(first).map(
        (key): RawFlexGridColumnConfig => ({
          colNm: key,
          colLblNm: key,
          colWth: 120,
          fixed: false,
          visible: true,
          display: true,
        })
      );
    }
    // fallback: admin 등록 컬럼 메타 기반
    if (columnsMeta && columnsMeta.length > 0) {
      return columnsMeta
        .filter(c => c.VALID_YN !== 'N')
        .map(
          (c): RawFlexGridColumnConfig => ({
            colNm: c.COLUMN_NAME,
            colLblNm: c.COLUMN_NAME,
            colWth: 120,
            fixed: false,
            visible: true,
            display: true,
          })
        );
    }
    return [];
  }, [data, columnsMeta]);

  return (
    <DataGrid<ResultRow>
      gridRef={gridRef as MutableRefObject<FlexGrid<ResultRow> | undefined>}
      itemsSource={data}
      staticColumns={staticColumns}
    />
  );
};
