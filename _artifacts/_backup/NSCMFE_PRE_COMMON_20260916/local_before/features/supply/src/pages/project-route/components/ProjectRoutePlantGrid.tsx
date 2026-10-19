import { type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { PLANT_EDITABLE_COLUMNS } from '../project-route.constants';
import type { BomKey, PlantRow, SiteKey } from '../project-route.types';
import { deriveOrgDates } from '../utils/projectRoute.plantDerive';

interface Props {
  gridRef: MutableRefObject<FlexGrid<PlantRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PlantRow> | undefined>;
  data: PlantRow[];
  staticColumns: RawFlexGridColumnConfig[];
  siteKey: SiteKey | null;
  bomKey: BomKey | null;
  // CELL_TYPE 'CA*' 는 편집불가(design/03 R-EDIT). BOM 더블클릭으로 넘어온 cellType 로 판정.
  readOnly: boolean;
}

// Plant Assign(siPlant) — 편집 CRUD. PLANT_SITE_ID·VALID_YN·PRIORITY·FROM·TO 5개만 편집가능,
//   키/감사/파생 열은 잠금(design/03 §1.3, R-EDIT/R-INS-LOCK). FROM/TO 변경 → ORG/MERGE 파생(R-ORG).
export const ProjectRoutePlantGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  siteKey,
  bomKey,
  readOnly,
}: Props) => {
  // 셀 콤보(design/03 §4.5): PLANT_SITE_ID=PlantByDivisionOperationItem_SCP(division/operation/item),
  //   VALID_YN=YesOrNo. 파라미터는 홑따옴표 규약(nscm-patterns §3.3, comboParams 로 @토큰 치환).
  const comboParams = useMemo(
    () => ({
      divisionId: `'${siteKey?.divisionId ?? ''}'`,
      operationId: `'${bomKey?.operationId ?? ''}'`,
      itemId: `'${bomKey?.itemId ?? ''}'`,
    }),
    [siteKey, bomKey]
  );

  // 편집 가능 컬럼 화이트리스트 강제(R-EDIT/R-INS-LOCK). admin 메타가 관대해도 5개 외 편집 차단.
  //   CELL_TYPE 'CA*'(readOnly) 면 전 컬럼 편집 차단.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const beginningEditHandler = (
      s: FlexGrid<PlantRow>,
      e: { cancel: boolean; col: number }
    ) => {
      if (readOnly) {
        e.cancel = true;
        return;
      }
      const binding = s.columns[e.col]?.binding ?? '';
      const editable: readonly string[] = PLANT_EDITABLE_COLUMNS;
      if (!editable.includes(binding)) e.cancel = true;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);
    return () => {
      try {
        grid.beginningEdit.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, readOnly]);

  // FROM/TO 변경 → ORG_FROM/ORG_TO/MERGE_DATE 파생(R-ORG). EditTracker 뒤 실행 위해 prop 경유.
  const handleCellEdit = (grid: FlexGrid<PlantRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    if (binding !== 'FROM_YYYYMMDD' && binding !== 'TO_YYYYMMDD') return;

    const record = dataItem as Record<string, unknown>;
    const derived = deriveOrgDates(record.FROM_YYYYMMDD, record.TO_YYYYMMDD);
    (Object.keys(derived) as (keyof typeof derived)[]).forEach(col => {
      editTrackerRef.current?.storeChange(dataItem, col, record[col] as string, derived[col]);
      record[col] = derived[col];
    });
    GridUtils.refreshRow(grid, e.row);
  };

  return (
    <DataGrid<PlantRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      comboParams={comboParams}
      cellEditEnded={handleCellEdit}
    />
  );
};
