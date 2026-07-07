// SYS0013 Parameters Grid — AS-IS SCM0005_DynamicQueryList.cs siWhere + SaveData L882-917 정합.
// 컬럼: admin staticColumns(parameters sheet) + VALUE(런타임 입력, 메타 외) append.
//   OPERATION_ID 드롭다운 = 메타 cellCtrlObjTpCd='FPComboBox'/cellCboDataTp='sysOperationOptions'(corp 27 보정) + comboDataMap.
// CRUD: Insert/Delete = 상단 공통버튼(부모 DynamicQuery 라우팅) / Modify = cellEditEnded → store.parametersPendingChanges.
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, type MutableRefObject, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../dynamic-query.constants';
import type { ParameterMetaRow } from '../dynamic-query.types';
import { OPERATION_OPTIONS } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ParameterMetaRow> | null>;
  data: ParameterMetaRow[];
}

interface ParameterEditableRow extends ParameterMetaRow {
  VALUE: string;
}

export const DynamicQueryParametersGrid = ({ gridRef, data }: Props) => {
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const parameterValues = useDynamicQueryStore(s => s.parameterValues);
  const parameterValuesSourceId = useDynamicQueryStore(s => s.parameterValuesSourceId);
  const initParameterValues = useDynamicQueryStore(s => s.initParameterValues);
  const setParameterValue = useDynamicQueryStore(s => s.setParameterValue);
  const parametersPendingChanges = useDynamicQueryStore(s => s.parametersPendingChanges);
  const parametersInsertedRows = useDynamicQueryStore(s => s.parametersInsertedRows);
  const trackParametersModify = useDynamicQueryStore(s => s.trackParametersModify);
  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.PARAMETERS]);

  // 선택된 query 변경 시 parameterValues 초기화.
  useEffect(() => {
    if (!selectedQueryId || parameterValuesSourceId === selectedQueryId) return;
    const defaults: Record<string, string> = {};
    for (const row of data) {
      defaults[row.PARAMETER_ID] = '';
    }
    initParameterValues(defaults, selectedQueryId);
  }, [selectedQueryId, data, parameterValuesSourceId, initParameterValues]);

  // admin 메타(UI Category Setup) + VALUE(런타임 입력, 메타 외) append.
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

  const mergedData = useMemo<ParameterEditableRow[]>(() => {
    const deletedKeys = new Set(
      Object.entries(parametersPendingChanges)
        .filter(([, c]) => c.crudType === 'D')
        .map(([k]) => k)
    );
    const base = data.filter(r => !deletedKeys.has(String(r.PARAMETER_ID)));
    const all = [...base, ...(parametersInsertedRows as unknown as ParameterMetaRow[])];
    return all.map(row => ({
      ...row,
      VALUE: parameterValues[row.PARAMETER_ID] ?? '',
    }));
  }, [data, parameterValues, parametersInsertedRows, parametersPendingChanges]);

  const handleCellEditEnded = (
    g: FlexGrid<ParameterEditableRow>,
    e: { row: number; col: number }
  ) => {
    const row = g.rows[e.row]?.dataItem as ParameterEditableRow | undefined;
    if (!row) return;
    const binding = g.columns[e.col]?.binding;
    if (binding === 'VALUE') {
      setParameterValue(row.PARAMETER_ID, String(row.VALUE ?? ''));
      return;
    }
    if (!row.PARAMETER_ID) return;
    trackParametersModify(String(row.PARAMETER_ID), row as unknown as Record<string, unknown>);
  };

  return (
    <DataGrid<ParameterEditableRow>
      gridRef={gridRef as unknown as MutableRefObject<FlexGrid<ParameterEditableRow> | undefined>}
      itemsSource={mergedData}
      staticColumns={columns}
      cellEditEnded={handleCellEditEnded}
      comboDataMap={{ sysOperationOptions: OPERATION_OPTIONS.map(v => ({ value: v, label: v })) }}
    />
  );
};
