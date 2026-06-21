// SYS0013 Parameters Grid — AS-IS SCM0005_DynamicQueryList.cs siWhere + SaveData L882-917 정합.
// 컬럼: PARAMETER_ID(편집)/PARAMETER_TYPE/OPERATION_ID(dropdown)/SEQNO/VALID_YN/VALUE(런타임 입력).
// CRUD: 자체 Add/Delete 버튼 + cellEditEnded → store.parametersPendingChanges.
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, type MutableRefObject, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

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
  const trackParametersInsert = useDynamicQueryStore(s => s.trackParametersInsert);
  const trackParametersModify = useDynamicQueryStore(s => s.trackParametersModify);
  const trackParametersDelete = useDynamicQueryStore(s => s.trackParametersDelete);

  // 선택된 query 변경 시 parameterValues 초기화.
  useEffect(() => {
    if (!selectedQueryId || parameterValuesSourceId === selectedQueryId) return;
    const defaults: Record<string, string> = {};
    for (const row of data) {
      defaults[row.PARAMETER_ID] = '';
    }
    initParameterValues(defaults, selectedQueryId);
  }, [selectedQueryId, data, parameterValuesSourceId, initParameterValues]);

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

  // inputTpCd 분기 (사용자 정책 — 2026-06-21):
  //   - 'IM' (MANDATORY_INSERT_ONLY) — INSERT row(CRUD_TYPE='I') 에서만 편집, 기존 row 잠금
  //     → PK 컬럼 (PARAMETER_ID, PARAMETER_TYPE)
  //   - 'O'  (OPTIONAL) — 항상 편집 가능
  //     → OPERATION_ID, SEQNO, VALID_YN, VALUE (런타임 변경 허용)
  //
  // RawFlexGridColumnConfig 의 raw 필드명 = inputTpCd (column-config.ts L14).
  // mapRawColumnsToWijmoColumns 가 inputTpCd → _inputEditType 매핑 후 wrapper 분기.
  // DataGrid wrapper(dataGridUtils.ts L138-143) 의 isEditableCell:
  //   cellCrudType === 'I' && cellInputEditType ∈ ('IM','IO')  → editable (INSERT 시만)
  //   cellInputEditType ∈ ('M','O')                            → editable (항상)
  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => [
      { colNm: 'PARAMETER_ID', colLblNm: 'Parameter ID', colWth: 200, fixed: true, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY },
      { colNm: 'PARAMETER_TYPE', colLblNm: 'Type', colWth: 100, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY },
      {
        colNm: 'OPERATION_ID',
        colLblNm: 'Operation',
        colWth: 100,
        fixed: false,
        visible: true,
        display: true,
        cellCboDataTp: 'sysOperationOptions',
        inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      },
      { colNm: 'SEQNO', colLblNm: 'Seq', colWth: 80, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
      { colNm: 'VALID_YN', colLblNm: 'Valid', colWth: 80, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
      { colNm: 'VALUE', colLblNm: 'Value', colWth: 240, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
    ],
    []
  );

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

  const handleAdd = () => {
    if (!selectedQueryId || selectedQueryId.startsWith('TEMP_')) return;
    trackParametersInsert(Number(selectedQueryId), {
      PARAMETER_TYPE: 'Parameter',
      OPERATION_ID: '-',
      VALID_YN: 'Y',
      REP_YN: 'N',
      SEQNO: '0',
    });
  };

  const handleDelete = () => {
    const sel = gridRef.current?.selectedItems?.[0] as ParameterMetaRow | undefined;
    if (!sel?.PARAMETER_ID) return;
    trackParametersDelete(String(sel.PARAMETER_ID));
  };

  const disabled = !selectedQueryId || selectedQueryId.startsWith('TEMP_');

  return (
    <>
      <div style={{ padding: '4px 0', display: 'flex', gap: 8 }}>
        <button onClick={handleAdd} disabled={disabled}>
          + Add Parameter
        </button>
        <button onClick={handleDelete} disabled={disabled}>
          - Delete Parameter
        </button>
      </div>
      <DataGrid<ParameterEditableRow>
        gridRef={gridRef as unknown as MutableRefObject<FlexGrid<ParameterEditableRow> | undefined>}
        itemsSource={mergedData}
        staticColumns={staticColumns}
        cellEditEnded={handleCellEditEnded}
        comboDataMap={{ sysOperationOptions: OPERATION_OPTIONS.map(v => ({ value: v, label: v })) }}
      />
    </>
  );
};
