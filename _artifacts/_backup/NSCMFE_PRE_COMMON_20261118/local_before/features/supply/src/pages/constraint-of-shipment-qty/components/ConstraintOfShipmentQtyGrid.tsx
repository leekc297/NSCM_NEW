import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { ConstraintOfShipmentQtyRow } from '../constraint-of-shipment-qty.types';
import {
  applyItemSelect,
  applyValTpCdDerivation,
  isCellEditable,
  isItemPopupCell,
  s,
} from '../utils/constraint-of-shipment-qty.editLock';

interface Props {
  rows: ConstraintOfShipmentQtyRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  onFocus: () => void;
}

// design 03 §1.1: 그리드 셀콤보 SQL_ID 5종(PlanGroup/Stage/FromSite/ToSite/YesOrNo) 중 4종이 admin
//   메타 CELL_COMBO_DATA_TYPE 에는 실려 있으나 SCM_ADM_CMBO_SQL_M 미등록(05_register.sql 등록 시도,
//   확인 필요) — 등록 전까지 해당 4컬럼은 공용 DataGrid 자동콤보 경로가 빈 옵션으로 렌더한다.
export const ConstraintOfShipmentQtyGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  isEditMode,
  onFocus,
}: Props) => {
  const [openItem, setOpenItem] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 white-list(design 03 §1/§3) — 편집권한 없음(잠금)/권한 있음(편집)/신규행 부분편집
    //   3상태를 isCellEditable 이 판정(isEditMode 인자 = canEdit 권한). ITEM_ID 는 항상 인라인 편집 금지(팝업 전용).
    const beginningEditHandler = (
      sender: FlexGrid,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || !isCellEditable(binding, row, isEditMode)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // VAL_TP_CD "A"/"B" 자동 태깅(design 03 §3 #14~17) — EditChange/KeyDown 양쪽 중복 구현을
    //   cellEditEnded 단일 경로로 통합(plan.md §4 권고).
    const cellEditEndedHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      applyValTpCdDerivation(row, binding);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);

    // 붙여넣기 From>To 재검증(design 03 §4, gridSignals#14 계열 부분 구현) — 역전되면 To 를 비운다.
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'FROM_YYYYMMDD' && binding !== 'TO_YYYYMMDD') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const from = s(row.FROM_YYYYMMDD);
      const to = s(row.TO_YYYYMMDD);
      if (from && to && from > to) row.TO_YYYYMMDD = '';
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ITEM_ID 셀 더블클릭 -> MaterialByDivisionModal(design 03 §1 #4, gridSignals#13).
    //   편집취소는 beginningEdit 이 이미 처리(isCellEditable('ITEM_ID')=false, convert-core §5-16).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupCell(binding)) return;
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, isEditMode]);

  return (
    <>
      <DataGrid<ConstraintOfShipmentQtyRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={adminColumns ?? []}
        gotFocus={onFocus}
      />
      {/* 그리드 셀 Item 팝업 — MaterialByDivisionModal, 조회영역과 동일 팝업 재사용(design 03 §1 #4). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          const row = GridUtils.getRow(gridRef.current, clickedRow) as
            | Record<string, unknown>
            | undefined;
          if (!row) return;
          applyItemSelect(row, items);
          GridUtils.refreshRow(gridRef.current, clickedRow);
        }}
        preSearchParams={{
          divisionId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.DIVISION_ID
          ),
          itemId: '',
        }}
      />
    </>
  );
};
