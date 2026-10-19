import { AllowMerging, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  LINE_MODE,
  PACKER_COLUMNS,
  PLANT_COLUMNS,
  SITE_COMBO_DIVISIONS,
  SITE_COMBO_ID,
} from '../line-master.constants';
import type { MainRow } from '../line-master.types';
import { buildColumns, resolveFrozenColumns } from '../utils/lineMasterColumns';
import { deriveOperationIdByRack, deriveSiteSelection } from '../utils/lineMasterDerive';
import { isPackerCellEditable, isPlantCellEditable } from '../utils/lineMasterEditLock';

interface Props {
  mode: LINE_MODE;
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toCellStr = (v: unknown): string => (v == null ? '' : str(v));

export const LineMasterMainGrid = ({
  mode,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const isPlant = mode === LINE_MODE.PLANT;
  const isPlantRef = useRef(isPlant);
  isPlantRef.current = isPlant;

  const columns = useMemo(
    () => buildColumns(isPlant ? PLANT_COLUMNS : PACKER_COLUMNS, adminColumns),
    [isPlant, adminColumns]
  );
  const frozenCols = useMemo(() => resolveFrozenColumns(columns), [columns]);
  const staticBindingSet = useMemo(() => new Set(columns.map(c => c.colNm)), [columns]);

  // 신규행 전용 셀콤보 SCM_SITE_ID (Packer) — PlantByDivisionOperOsp3_SCP.
  //   반환 CODE/NAME/OPERATION_ID. 파라미터는 raw, 인용은 getCombo funnel (grid-combo-division-param).
  const [siteComboRows] = useTabComboQueries({
    filters: [{ comboId: SITE_COMBO_ID, divisionId: SITE_COMBO_DIVISIONS }],
  });
  const siteRows = useMemo(
    () => (siteComboRows ?? []) as unknown as Record<string, unknown>[],
    [siteComboRows]
  );
  const siteRowsRef = useRef(siteRows);
  siteRowsRef.current = siteRows;

  // 신규행에만 후보를 돌려주는 DataMap (조회/기존행은 텍스트) — SalesPlanGrid insertOnlyDataMaps 동일.
  //   메타상 SCM_SITE_ID 는 FPTextBox(콤보 아님)라 공용 콤보 경로를 타지 않아 화면이 직접 맡는다.
  const insertOnlyDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const build = (source: Record<string, unknown>[]): DataMap | null => {
      if (source.length === 0) return null;
      const map = new DataMap(source, 'CODE', 'NAME');
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      map.getDisplayValues = (item?: unknown): string[] => {
        const all = [...new Set(allDisplayValues(item))];
        // 행 컨텍스트 없는 호출(필터 패널 등)은 전체 유지 — 비우면 필터가 죽는다.
        if (!item) return all;
        return toCellStr((item as Record<string, unknown>).CRUD_TYPE) === 'I' ? all : [];
      };
      return map;
    };
    return { SCM_SITE_ID: build(siteRows) };
  }, [siteRows]);

  // 편집 시작 셀의 (binding, oldVal) — cellEditEnded 에서 실제 값 변경 여부 판정용.
  const editingCellRef = useRef<{ binding: string; oldVal: unknown } | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // wijmo 는 columnGroups 재대입마다 Column 을 새로 만들어 dataMap 이 날아가므로 updatedLayout 에서 재부착.
    const attach = () => {
      Object.entries(insertOnlyDataMaps).forEach(([binding, map]) => {
        if (!map || !staticBindingSet.has(binding)) return;
        const col = g.getColumn(binding);
        if (col && col.dataMap !== map) col.dataMap = map;
      });
    };
    g.updatedLayout.addHandler(attach);
    attach();

    // Plant = 전 칼럼 잠금 / Packer = white-list (design 03 §2.1). 신규행 SCM_SITE_ID 콤보만 편집.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      const editable = isPlantRef.current
        ? isPlantCellEditable()
        : isPackerCellEditable(binding, row);
      if (!editable) {
        e.cancel = true;
        return;
      }
      editingCellRef.current = { binding, oldVal: (row as Record<string, unknown>)[binding] };
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 파생 (design 03 §3.1): SCM_SITE_ID 선택 -> SITE_DESCRIPTION/OPERATION_ID / RACK_YN -> OPERATION_ID 접미사.
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      // Packer 신규행만 파생 대상 (기존행 편집 파생 없음 — design 03 §3.1).
      if (isPlantRef.current || toCellStr(row.CRUD_TYPE) !== 'I') {
        editingCellRef.current = null;
        return;
      }
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: string) => {
        tracker?.storeChange(row as never, key, row[key] as never, value as never);
        row[key] = value;
      };
      const prev = editingCellRef.current;
      const newVal = row[binding];
      const changed = prev?.binding === binding && toCellStr(prev.oldVal) !== toCellStr(newVal);

      if (binding === 'SCM_SITE_ID' && changed) {
        const selected = siteRowsRef.current.find(r => toCellStr(r.CODE) === toCellStr(newVal));
        if (selected) {
          const d = deriveSiteSelection({
            CODE: toCellStr(selected.CODE),
            NAME: toCellStr(selected.NAME),
            OPERATION_ID: toCellStr(selected.OPERATION_ID),
          });
          setCell('SITE_DESCRIPTION', d.SITE_DESCRIPTION);
          // RACK_YN 이 이미 'Y' 면 접미사 반영, 아니면 순수 OPERATION_ID.
          setCell('OPERATION_ID', deriveOperationIdByRack(d.OPERATION_ID, toCellStr(row.RACK_YN)));
        }
      }
      if (binding === 'RACK_YN' && changed) {
        setCell('OPERATION_ID', deriveOperationIdByRack(toCellStr(row.OPERATION_ID), toCellStr(newVal)));
      }

      editingCellRef.current = null;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // Freeze 좌측 고정 — SITE_DESCRIPTION 까지 (design 03 §3.4 #24).
    if (frozenCols > 0) g.frozenColumns = frozenCols;
    g.invalidate(true);

    return () => {
      try {
        g.updatedLayout?.removeHandler(attach);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, insertOnlyDataMaps, staticBindingSet, frozenCols]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
