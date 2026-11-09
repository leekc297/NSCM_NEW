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
  // WH Name 선택 시 숨김 필수 SCM_SITE_ID/STAGE 를 채우는 조회원 — key `DIVISION_ID|OPMZ_PLAN_GR_ID|WH_NM`.
  warehouseSiteStage: Map<string, { site: string; stage: string }>;
  onFocus: () => void;
}

/**
 * Warehouse Item Mapping 시트(design 03 §1.2, 16컬럼) — DataGrid.
 *
 * 조회(A2): 이 시트는 전용 GET SP(`PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_ITEM_MAPPING`, 9 IN +
 * O_RC1 16컬럼)가 배포돼 있다(gap-resolve iter-2 ALL_ARGUMENTS 실측). 페이지가 `useTabProcQuery`
 * (SHEETS.ITEM_MAPPING)로 조회한 행을 `rows` prop 으로 받아 렌더하며, Insert 신규행도 같은
 * CollectionView 에서 관리된다. 저장(A3)은 페이지 handleSave 가 activeSheet===1 에서
 * `P_SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING` 으로 전송한다.
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
  warehouseSiteStage,
  onFocus,
}: Props) => {
  const dblClickRowRef = useRef<WijmoRowItem | undefined>(undefined);
  const [itemModalOpen, setItemModalOpen] = useState(false);
  // 핸들러가 항상 최신 조회원을 보도록 ref 로 들고 있는다(effect dep 은 adminColumns 로 고정).
  const warehouseSiteStageRef = useRef(warehouseSiteStage);
  warehouseSiteStageRef.current = warehouseSiteStage;

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

    // WH Name 변경 → 숨김 필수 SCM_SITE_ID/STAGE 자동파생(AS-IS SpdMain_ComboSelChange .cs:1298-1314).
    //   창고(DIVISION_ID+OPMZ_PLAN_GR_ID+WH_NM)를 'Warehose' 콤보로 조회해 Site/Stage 를 채운다 —
    //   두 컬럼은 NOT NULL+필수인데 VISIBLE_FLAG=N(숨김)이라 안 채우면 저장 시 ORA-01400.
    //   매치 없으면(그 조합의 창고 미존재) 비워 둔다 — 공통 필수검증이 저장 전에 막는다.
    const whDeriveHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'WH_NM') return;
      const row = GridUtils.getRow(sender, e.row) as WijmoRowItem | undefined;
      if (!row) return;
      const key = `${String(row.DIVISION_ID ?? '')}|${String(row.OPMZ_PLAN_GR_ID ?? '')}|${String(row.WH_NM ?? '')}`;
      const hit = warehouseSiteStageRef.current.get(key);
      if (!hit) return;
      editTrackerRef.current?.storeChange(row as never, 'SCM_SITE_ID' as never, row.SCM_SITE_ID as never, hit.site as never);
      editTrackerRef.current?.storeChange(row as never, 'STAGE' as never, row.STAGE as never, hit.stage as never);
      row.SCM_SITE_ID = hit.site;
      row.STAGE = hit.stage;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(whDeriveHandler as never);
    g.pastedCell.addHandler(whDeriveHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(storLocDeriveHandler as never);
        g.pastedCell?.removeHandler(storLocDeriveHandler as never);
        g.cellEditEnded?.removeHandler(whDeriveHandler as never);
        g.pastedCell?.removeHandler(whDeriveHandler as never);
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
