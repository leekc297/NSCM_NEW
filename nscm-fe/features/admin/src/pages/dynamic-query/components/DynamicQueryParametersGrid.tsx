// SYS0013 Parameters(Condition) Grid — AS-IS View 탭 siWhere(Condition 시트) 정합.
// 컬럼 = admin staticColumns(parameters) + VALUE(런타임 입력, 메타 외) append.
//   OPERATION_ID 콤보 = 메타 cellCboDataTp='sysOperationOptions' → CMBO_SQL_M 등록분 자동 해석.
// CRUD = 표준: EditTracker('M' 자동) + GridAction (부모 라우팅). VALUE 편집은 CRUD 아님 —
//   store.parameterValues 로만 반영 (Execute 토큰 치환용) + CRUD_TYPE 오염 시 원복.
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ParameterMetaRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ParameterMetaRow> | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ParameterMetaRow> | undefined>;
  data: ParameterMetaRow[];
}

interface ParameterEditableRow extends ParameterMetaRow {
  VALUE: string;
}

export const DynamicQueryParametersGrid = ({ gridRef, editTrackerRef, data }: Props) => {
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const parameterValues = useDynamicQueryStore(s => s.parameterValues);
  const parameterValuesSourceId = useDynamicQueryStore(s => s.parameterValuesSourceId);
  const initParameterValues = useDynamicQueryStore(s => s.initParameterValues);
  const setParameterValue = useDynamicQueryStore(s => s.setParameterValue);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.PARAMETERS]);

  // 선택된 query 변경 시 parameterValues 초기화 (DEFAULT_VALUE 반영 — admin 등록 초기값).
  useEffect(() => {
    if (!selectedQueryId || parameterValuesSourceId === selectedQueryId) return;
    const defaults: Record<string, string> = {};
    for (const row of data) {
      defaults[row.PARAMETER_ID] = String(row.DEFAULT_VALUE ?? '');
    }
    initParameterValues(defaults, selectedQueryId);
  }, [selectedQueryId, data, parameterValuesSourceId, initParameterValues]);

  // admin 메타 + VALUE(런타임 입력 — 메타 외, 근거 주석) append.
  const columns = useMemo<RawFlexGridColumnConfig[]>(
    () => [
      ...(staticColumns ?? []),
      {
        colNm: 'VALUE',
        colLblNm: 'Value',
        colWth: 240,
        fixed: false,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      },
    ],
    [staticColumns]
  );

  // 행에 VALUE(입력값) 병합 — data(캐시 행) 원본은 CRUD 추적용으로 직접 사용하고,
  // VALUE 는 표시 시점에만 주입 (rows 자체는 동일 참조 유지 — EditTracker/CRUD 마킹 보존).
  const mergedData = useMemo<ParameterEditableRow[]>(() => {
    return data.map(row => {
      const editable = row as ParameterEditableRow;
      editable.VALUE = parameterValues[row.PARAMETER_ID] ?? '';
      return editable;
    });
  }, [data, parameterValues]);

  const handleCellEditEnded = (
    g: FlexGrid<ParameterEditableRow>,
    e: { row: number; col: number }
  ) => {
    const row = g.rows[e.row]?.dataItem as ParameterEditableRow | undefined;
    if (!row) return;
    const binding = g.columns[e.col]?.binding;
    if (binding === 'VALUE') {
      setParameterValue(row.PARAMETER_ID, String(row.VALUE ?? ''));
      // VALUE 는 실행 입력값 — 저장 대상 아님. EditTracker 의 'M' 오염 원복.
      if (row.CRUD_TYPE === CRUD_TYPE.MODIFY) {
        editTrackerRef.current?.storeChange(row, 'VALUE', row.VALUE, row.VALUE);
      }
    }
  };

  return (
    <DataGrid<ParameterEditableRow>
      gridRef={gridRef as unknown as MutableRefObject<FlexGrid<ParameterEditableRow> | undefined>}
      editTrackerRef={
        editTrackerRef as unknown as MutableRefObject<EditTracker<ParameterEditableRow> | undefined>
      }
      itemsSource={mergedData}
      staticColumns={columns}
      cellEditEnded={handleCellEditEnded}
    />
  );
};
