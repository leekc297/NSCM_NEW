import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { SHEETS } from '../capa-line-assign.constants';
import { ADMIN_SHEET_NAME, MENU_ID } from '../capa-line-assign.constants';
import type { GridRow } from '../capa-line-assign.types';
import type { ColumnLayoutOverride } from '../useCapaLineAssignStore';
import { isSopCellEditable } from '../utils/capaLineAssign.editLock';
import {
  applyEditModeVisibility,
  applyLayoutToColumns,
  collapseStaticLargeTier,
  hideInvisibleColumns,
} from '../utils/capaLineAssignColumns';

interface Props {
  sheet: SHEETS.SOP_ASSEMBLY | SHEETS.SOP_ELTR;
  data: GridRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns: RawFlexGridColumnConfig[];
  userColumnLayout?: ColumnLayoutOverride[];
  editMode: boolean;
}

const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

/**
 * SOP 탭 그리드 (AS-IS `spdSOP` / 시트 `SOP_ASSEMBLY` | `SOP_ELTR`).
 *
 * Assign 과 달리 **헤더 1단 · 동적 기간컬럼 없음**(`RefreshSheetHeaderSOP` 가 1단만 구성, cs:2187).
 * 편집 가능 셀도 `VALID_YN`·`SOP_DT` 둘뿐이다(G22~G24 / E-7).
 */
export const CapaLineSopGrid = ({
  sheet,
  data,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  userColumnLayout,
  editMode,
}: Props) => {
  // SOP 분기는 8컬럼 토글만 있고 `ATTRIBUTE3='N'` 폭 복원 블록이 없다(cs:4374-4388) → isAssign=false.
  // 정적 컬럼 1단은 AS-IS 가 숨겨 2단이다(collapseStaticLargeTier) — Assign 그리드와 동일(Site/Plant/
  //   Building/Line/Operation 메타가 LARGE<>SMALL 이라 축소 없으면 상위 그룹 헤더가 뜬다, DB 실측).
  // hideInvisibleColumns: 비노출(SOP_YM·SOP_DDN)이 보이는 SOP_DT 와 같은 'SOP' 그룹에 묶여 헤더가
  //   "SOP / SOP" 로 쪼개지던 것 교정 — AS-IS 의 헤더-전 비노출 컬럼 제거를 재현(helper 주석 참조).
  const columns = useMemo(
    () =>
      applyEditModeVisibility(
        hideInvisibleColumns(
          applyLayoutToColumns(collapseStaticLargeTier(adminColumns), userColumnLayout)
        ),
        editMode,
        false
      ),
    [adminColumns, userColumnLayout, editMode]
  );

  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const rowOf = (index: number): GridRow | undefined =>
      grid.rows[index]?.dataItem as GridRow | undefined;

    const editableAt = (col: number, row: number): boolean => {
      // `_inputEditType`(= admin INPUT_TP_CD) 은 공용 게이트와 같은 출처(GridUtils.getColumn)에서 읽는다 —
      //   grid.columns[col] 은 leaf 매핑 전 Wijmo 컬럼이라 이 메타 필드가 없다(Assign 그리드와 동일).
      const column = GridUtils.getColumn(grid, col);
      return isSopCellEditable({
        binding: column?.binding ?? grid.columns[col]?.binding ?? '',
        row: rowOf(row),
        editMode: editModeRef.current,
        inputEditType: column?._inputEditType,
      });
    };

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      toggleClass(e.cell, 'wj-cell-editable', editableAt(e.col, e.row));
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      // 공용 `defaultEditHandler` 가 먼저 등록되므로 양방향 지정한다(Assign 그리드와 동일).
      e.cancel = !editableAt(e.col, e.row);
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editableAt(e.col, e.row)) e.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      excelFileName='CapaLineSop'
      // 병합 규약은 Assign 그리드와 동일 — 근거는 `CapaLineAssignGrid` 의 같은 prop 주석 참조.
      allowMerging={editMode ? AllowMerging.ColumnHeaders : AllowMerging.All}
    />
  );
};
