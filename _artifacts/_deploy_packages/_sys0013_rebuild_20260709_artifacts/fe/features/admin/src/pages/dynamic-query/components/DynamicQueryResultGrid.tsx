// SYS0013 Result Grid — EXECUTE 결과 동적 컬럼 (AS-IS siResult DataSource 직접 바인딩 정합).
// 컬럼 순서 = Columns 정의(SEQNO) → 결과 실키 매칭(대소문자 무시) → 정의 외 컬럼 뒤 append.
// 동적 컬럼 visible:true 명시 — Excel export 숨김 사고 방지 (DMF0043 룰).
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { ColumnMetaRow, ResultRow } from '../dynamic-query.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResultRow> | undefined>;
  data: ResultRow[];
  // 선택 쿼리의 컬럼 정의 — 결과 0 row 일 때 컬럼 헤더 fallback.
  columnsMeta: ColumnMetaRow[];
}

export const DynamicQueryResultGrid = ({ gridRef, data, columnsMeta }: Props) => {
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const toCol = (key: string): RawFlexGridColumnConfig => ({
      colNm: key,
      colLblNm: key,
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    });

    // SEQNO 오름차순 (안정 정렬 — 동일 SEQNO 는 SP 반환 순서 보존).
    const orderedMeta = (columnsMeta ?? [])
      .filter(c => c.VALID_YN !== 'N')
      .slice()
      .sort((a, b) => Number(a.SEQNO ?? 0) - Number(b.SEQNO ?? 0));

    if (data && data.length > 0) {
      const first = data[0] as Record<string, unknown>;
      const resultKeys = Object.keys(first);
      const upperToKey = new Map(resultKeys.map(k => [k.toUpperCase(), k]));
      const metaUpper = new Set(orderedMeta.map(c => String(c.COLUMN_NAME).toUpperCase()));

      const ordered = orderedMeta
        .map(c => upperToKey.get(String(c.COLUMN_NAME).toUpperCase()))
        .filter((k): k is string => !!k)
        .map(toCol);
      const extras = resultKeys.filter(k => !metaUpper.has(k.toUpperCase())).map(toCol);
      return [...ordered, ...extras];
    }

    if (orderedMeta.length > 0) {
      return orderedMeta.map(c => toCol(String(c.COLUMN_NAME)));
    }
    return [];
  }, [data, columnsMeta]);

  return (
    <DataGrid<ResultRow>
      gridRef={gridRef}
      itemsSource={data}
      staticColumns={staticColumns}
      isReadOnly
    />
  );
};
