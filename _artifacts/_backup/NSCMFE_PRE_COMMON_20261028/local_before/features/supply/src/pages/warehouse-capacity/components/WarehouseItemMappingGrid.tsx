import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { deriveStorLocCode, isCellEditable, isStorLocNameVisible } from '../utils/warehouseCapacityEditLock';

interface Props {
  rows: WijmoRowItem[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  divisionId: string;
  onFocus: () => void;
}

/**
 * Warehouse Item Mapping 시트(design 03 §1.2, 16컬럼) — DataGrid.
 *
 * 확인 필요(design 03 §6-9, §4.2): 이 시트는 전용 GET SP 가 없다(`SCP.SCP0133_GET_WAREHOUSE_CAPACITY`
 * 는 Warehouse Capacity 시트 전용). `Query(ds)` 가 멀티 결과셋을 두 시트에 분배하는지, 이 시트가
 * 순수 입력전용(조회 없음)인지 GSCM 원본 미확보로 확정하지 못했다 — 추측으로 조회 계약을 만들지
 * 않는다(anti-simplification §1, §2.3). 따라서 이 컴포넌트는 `useTabProcQuery` 를 배선하지 않고
 * 페이지가 로컬로 관리하는 행 배열(`rows`, Insert 로만 채워짐)만 렌더한다. SP 계약이 확정되면
 * (convert-sp 후속) 조회 배선을 추가한다.
 *
 * 컬럼은 admin `SCM_MST_SHEET_COLUMNS`(SHEET_NAME='Warehouse Item Mapping', 16행 실측)를 그대로
 * 쓴다. 편집잠금은 WhCapa 시트와 동일 `isCellEditable`(ALWAYS_LOCKED_COLUMNS 공유) — 단
 * ITEM_ID 는 POPUP_ONLY_COLUMNS 로 항상 편집 차단, 더블클릭만 허용(design 03 §1.2 gridSignals#19).
 *
 * STOR_LOC_NAME 은 division 에 '81_UC' 가 포함될 때만 표시(AS-IS `.cs:512-532`, project-route
 * `ProjectRouteMainGrid.tsx` R-DYN 과 동일 패턴 — admin 메타 속성 덮어쓰기가 아니라 컬럼 목록에서
 * 제외). 이 컬럼에 "East"/"West" 를 입력·붙여넣기하면 STOR_LOC 이 `@E`/`@W` 로 파생된다
 * (AS-IS `.cs:1317-1336`/`1388-1406`).
 */
export const WarehouseItemMappingGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  divisionId,
  onFocus,
}: Props) => {
  const dblClickRowRef = useRef<WijmoRowItem | undefined>(undefined);
  const [itemModalOpen, setItemModalOpen] = useState(false);

  const columns = useMemo(() => {
    const cols = adminColumns ?? [];
    if (isStorLocNameVisible(divisionId)) return cols;
    return cols.filter(c => c.colNm !== 'STOR_LOC_NAME');
  }, [adminColumns, divisionId]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const item = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!item) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // STOR_LOC_NAME(East/West) → STOR_LOC(@E/@W) 파생(AS-IS ComboSelChange/ClipboardPasted).
    const storLocDeriveHandler = (
      sender: FlexGridType,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'STOR_LOC_NAME') return;
      const row = GridUtils.getRow(sender, e.row) as WijmoRowItem | undefined;
      if (!row) return;
      const code = deriveStorLocCode(row.STOR_LOC_NAME);
      editTrackerRef.current?.storeChange(
        row as never,
        'STOR_LOC' as never,
        row.STOR_LOC as never,
        code as never
      );
      row.STOR_LOC = code;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(storLocDeriveHandler as never);
    g.pastedCell.addHandler(storLocDeriveHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(storLocDeriveHandler as never);
        g.pastedCell?.removeHandler(storLocDeriveHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns]);

  // ITEM_ID 셀 더블클릭 → MaterialByDivisionModal(design 03 §1.2, gridSignals#19 SetText 재현).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    dblClickRowRef.current = row;
    setItemModalOpen(true);
  };

  return (
    <>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows}
        staticColumns={columns}
        allowMerging={AllowMerging.None}
        gotFocus={onFocus}
        dblClick={handleDblClick}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        preSearchParams={{ divisionId, scpModuleType: 'SCP0133' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            editTrackerRef.current?.storeChange(
              row as never,
              'ITEM_ID' as never,
              row.ITEM_ID as never,
              items as never
            );
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          setItemModalOpen(false);
        }}
      />
    </>
  );
};
