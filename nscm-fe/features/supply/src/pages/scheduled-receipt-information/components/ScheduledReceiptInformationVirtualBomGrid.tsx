import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useRef, useState } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MENU_ID } from '../scheduled-receipt-information.constants';
import type { VirtualBomRow } from '../scheduled-receipt-information.types';
import { isSheetCellEditable } from '../utils/scheduledReceiptInformationEditLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<VirtualBomRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<VirtualBomRow> | undefined>;
  data: VirtualBomRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  planGroupOptions: ComboResponse[];
  isEditMode: boolean;
  onFocus: () => void;
}

const PLAN_GROUP_BINDING = 'OPMZ_PLAN_GR_ID';

/**
 * Virtual Bom 시트 그리드 — design/03_grid-columns.md §1.2/§3 white-list 재현.
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/02_search-combo.md §4.6 확정
 * 재사용, gridSignals#21 SetText 재현) — buttonGuards#4/#5(헤더 더블클릭 제외 / 잠금 또는
 * 비편집모드&&비신규행 시 팝업 차단) 재현.
 *
 * 편집잠금은 `isSheetCellEditable`(scheduledReceiptInformationEditLock.ts) 단일 진실원 — 신규행은
 * 항상 편집 가능(잠금 컬럼 제외), 기존행은 isEditMode(EditButton 토글) 일 때만.
 *
 * 셀 콤보 OPMZ_PLAN_GR_ID(`PlanGroup` SQL_ID) — admin 메타 fetch(staticColumns)로 자동 배선,
 * 화면이 col.dataMap 을 직접 붙이지 않는다(convert-core §2.3/§2.6, dev-manual 04장).
 */
export const ScheduledReceiptInformationVirtualBomGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  planGroupOptions,
  isEditMode,
  onFocus,
}: Props) => {
  const dblClickRowRef = useRef<VirtualBomRow | undefined>(undefined);
  const [itemModalOpen, setItemModalOpen] = useState(false);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!isSheetCellEditable(binding, row, isEditMode)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // INPUT_TP_CD 전건 'S'라 공통 DataGrid wrapper(GridUtils.isEditableCell)는 이 화면 전 셀을
    // 항상 편집불가로 판정해 'wj-cell-editable' 을 붙이지 않는다 — isSheetCellEditable 기준으로
    // 재판정해 시각적 단서를 맞춘다(react-gap-audit iter-2 SCP0130-06, MainGrid와 동일 패턴).
    const formatItemHandler = (sender: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      if (!binding) return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      toggleClass(e.cell, 'wj-cell-editable', isSheetCellEditable(binding, row, isEditMode));
    };
    g.formatItem.addHandler(formatItemHandler);

    // SpdMain_ClipboardPasted(OPMZ_PLAN_GR_ID NAME→CODE 변환, `00_checklist.md` §2 #9/§3 #21,
    // convert-flow/goal.md SCP0130-10) — MainGrid 와 동일 패턴(AS-IS `.cs` 원문 미확보, 화면에 이미
    // 로드된 PlanGroup 콤보 옵션으로 붙여넣은 NAME 을 CODE 로 치환). EditTracker 의 pastedCell
    // 핸들러(원본 기록) 뒤에 등록돼야 하므로 등록 순서를 그대로 유지한다.
    const pastedPlanGroupHandler = (sender: FlexGridType, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== PLAN_GROUP_BINDING) return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) return;
      const pastedValue = row[PLAN_GROUP_BINDING] as string | undefined;
      if (!pastedValue) return;
      const rowDivisionId = (row.DIVISION_ID as string | undefined) ?? divisionId;
      const matched = planGroupOptions.find(
        option => option.NAME === pastedValue && (!rowDivisionId || option.DIVISION_ID === rowDivisionId)
      );
      if (!matched || matched.CODE === pastedValue) return;
      editTrackerRef.current?.storeChange(
        row as VirtualBomRow,
        PLAN_GROUP_BINDING,
        pastedValue,
        matched.CODE
      );
      row[PLAN_GROUP_BINDING] = matched.CODE;
      sender.invalidate();
    };
    g.pastedCell.addHandler(pastedPlanGroupHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastedCell?.removeHandler(pastedPlanGroupHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, isEditMode, planGroupOptions, divisionId]);

  // buttonGuards#4 — 헤더 더블클릭 제외. buttonGuards#5 — 잠금 시트 또는(신규아님&&비편집모드) 차단.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    if (row.CRUD_TYPE !== 'I' && !isEditMode) return;
    dblClickRowRef.current = row;
    setItemModalOpen(true);
  };

  return (
    <>
      <DataGrid<VirtualBomRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
        gotFocus={() => onFocus()}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        preSearchParams={{ divisionId, scpModuleType: MENU_ID }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            // gridSignals#21 SetText(e.Row, ITEM_ID, sItemId) 재현.
            editTrackerRef.current?.storeChange(row, 'ITEM_ID', row.ITEM_ID, items);
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          setItemModalOpen(false);
        }}
      />
    </>
  );
};
