import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useState, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS, RESPONSE_SET } from '../dynamic-query.constants';
import { useDynamicQueryStore, isIntegerValueType } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.RESULT>> | undefined>;
  data: ResponseData<MENU_ID, SHEETS.RESULT, RESPONSE_SET.OUTPUT>[];
}

export const DynamicQueryResultGrid = ({ gridRef, data }: Props) => {
  const resultGridColumns = useDynamicQueryStore(s => s.resultGridColumns);
  const dynamicQueryMeta = useDynamicQueryStore(s => s.dynamicQueryMeta);

  // 조회가 이루어지기 전의 보여주기 위한 디폴트 컬럼
  const defaultColums = [
    {
      colNm: 'COL1',
      colLblNm: 'COL1',
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    },
    {
      colNm: 'COL2',
      colLblNm: 'COL2',
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    },
    {
      colNm: 'COL3',
      colLblNm: 'COL3',
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    },
    {
      colNm: 'COL4',
      colLblNm: 'COL4',
      colWth: 120,
      fixed: false,
      visible: true,
      display: true,
    },
  ] as RawFlexGridColumnConfig[];

  const [columns, setColumns] = useState<RawFlexGridColumnConfig[]>(defaultColums);
  const [rowData, setRowData] = useState<
    ResponseData<MENU_ID, SHEETS.RESULT, RESPONSE_SET.OUTPUT>[]
  >([]);

  useEffect(() => {
    if (dynamicQueryMeta) {
      if (resultGridColumns.length > 0) {
        const cols = resultGridColumns.map(col => ({
          colNm: col.name,
          colLblNm: col.name,
          colWth: 120,
          fixed: false,
          visible: true,
          display: true,
          // Int 계열(System.Int16/32/64)은 텍스트처럼 표시 → 좌측 정렬 (AS-IS 는 숫자 우측정렬이나
          // 사용자 요구 2026-07-27: HISTORY_SEQ 등 식별자성 Int 는 콤마/우측정렬 없이 텍스트로).
          horzAlgnCd: isIntegerValueType(col.valueType) ? ('L' as const) : undefined,
        }));
        setColumns(cols);

        // Int 계열 컬럼 값은 String() 으로 변환하여 바인딩 → Wijmo 가 number 로 추론해
        // 콤마(41,391,359) + 우측정렬 렌더하는 것을 방지 (텍스트 셀로 표시).
        const intCols = resultGridColumns
          .filter(col => isIntegerValueType(col.valueType))
          .map(col => col.name);
        if (intCols.length > 0) {
          setRowData(
            data.map(row => {
              const next = { ...row };
              intCols.forEach(name => {
                if (next[name] !== null && next[name] !== undefined) {
                  next[name] = String(next[name]);
                }
              });

              return next;
            })
          );
        } else {
          setRowData(data);
        }
      } else {
        setColumns(defaultColums);
        setRowData([]);
      }
    } else {
      setColumns(defaultColums);
      setRowData([]);
    }
  }, [data, resultGridColumns, dynamicQueryMeta]);

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.RESULT>>
      gridRef={gridRef}
      itemsSource={rowData}
      staticColumns={columns}
      isReadOnly={true}
    />
  );
};
