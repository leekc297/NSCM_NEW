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
  // 컬럼 순서 = Columns 탭 정의 순서(SEQNO). 결과 row 의 원시 key 순서(SQL/JSON)와 무관하게
  //   정의된 순서로 정렬 + 정의에 없는 결과 컬럼은 뒤에 append (누락 방지).
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const toCol = (key: string): RawFlexGridColumnConfig => ({
      colNm: key,
      colLblNm: key,
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    });

    // SEQNO 오름차순 (Array.sort 안정 정렬 — 동일 SEQNO 는 SP 반환 순서=LAST_UPDATE_DATE 보존).
    const orderedMeta = (columnsMeta ?? [])
      .filter(c => c.VALID_YN !== 'N')
      .slice()
      .sort((a, b) => Number(a.SEQNO ?? 0) - Number(b.SEQNO ?? 0));

    if (data && data.length > 0) {
      const first = data[0] as Record<string, unknown>;
      const resultKeys = Object.keys(first);
      const upperToKey = new Map(resultKeys.map(k => [k.toUpperCase(), k]));
      const metaUpper = new Set(orderedMeta.map(c => String(c.COLUMN_NAME).toUpperCase()));

      // 1) 정의(SEQNO) 순서로, 결과에 존재하는 컬럼만 (대소문자 무시 매칭, 실제 key 보존)
      const ordered = orderedMeta
        .map(c => upperToKey.get(String(c.COLUMN_NAME).toUpperCase()))
        .filter((k): k is string => !!k)
        .map(toCol);
      // 2) 정의에 없는 결과 컬럼 (예: 사용자 SQL 변형) 은 뒤에 append
      const extras = resultKeys.filter(k => !metaUpper.has(k.toUpperCase())).map(toCol);
      return [...ordered, ...extras];
    }

    // 결과 0 row: 정의 메타 순서대로 헤더 표시
    if (orderedMeta.length > 0) {
      return orderedMeta.map(c => toCol(String(c.COLUMN_NAME)));
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
