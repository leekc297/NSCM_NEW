import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';

/**
 * 편집권한(canEdit) 게이트 — 공용 DataGrid 처리 뒤에 붙는 마지막 override.
 *
 * 컬럼 단위 잠금(감사 4열 · Sub LOOKUP_TYPE · Sub SEGMENT10 · Sub SEGMENT*_KEY)은 전부
 * INPUT_TP_CD='S' 메타로 표현돼 있어 공용 DataGrid 가 이미 막는다. 여기서 더하는 조건부 축은
 * canEdit 하나뿐이다 — AS-IS 의 시트 단위 편집모드 토글은 사용자 지시로 미이식이고
 * (decisions.md §2), 대신 화면 오픈 시 1회 판정한 버튼권한으로 전체를 잠근다.
 *
 * 색은 hook #95 3색 규약으로 환산한다: 편집가능 = wj-cell-editable(Yellow) /
 * 잠금 = 클래스 없음(White). AS-IS 회색(LockColor)을 wj-cell-non-editable 로
 * 전면 이식하면 조회 그리드가 통째로 회색이 되므로 항상 false 로 명시해 끈다.
 *
 * canEdit 은 ref 로 받는다 — 값이 바뀔 때마다 핸들러를 재등록하면 등록 순서가 공용 핸들러보다
 * 앞뒤로 흔들려 override 가 깨진다.
 */
export const applyCanEditGuard = <T extends WijmoRowItem>(
  grid: FlexGrid<T>,
  canEditRef: MutableRefObject<boolean>
): (() => void) => {
  const formatItemHandler = (sender: FlexGrid<T>, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    const editable = canEditRef.current && GridUtils.isEditableCell(sender, e.row, e.col);
    toggleClass(e.cell, 'wj-cell-editable', editable);
    toggleClass(e.cell, 'wj-cell-non-editable', false);
  };

  const beginningEditHandler = (_sender: FlexGrid<T>, e: CellRangeEventArgs) => {
    if (!canEditRef.current) e.cancel = true;
  };

  /**
   * 붙여넣기도 같은 판정으로 막는다.
   *
   * 공용 DataGrid 의 setEditableColumns 는 pastingCell 을 GridUtils.isEditableCell
   * (= column._inputEditType 만)로 판정하므로, canEdit 이 false 여도 'M'/'O' 컬럼은 그대로
   * 통과한다 — 클릭 편집은 막히는데 Ctrl+V 만 먹는 상태가 된다
   * (메모리 datagrid-paste-editability-pastingcell-gap).
   * 편집가능 셀을 되살리지는 않는다: 여기서 더하는 축은 canEdit 차단 하나뿐이고, 컬럼 단위
   * 잠금(INPUT_TP_CD='S')은 공용 판정 그대로 유지해야 한다.
   */
  const pastingCellHandler = (_sender: FlexGrid<T>, e: CellRangeEventArgs) => {
    if (!canEditRef.current) e.cancel = true;
  };

  grid.formatItem.addHandler(formatItemHandler);
  grid.beginningEdit.addHandler(beginningEditHandler);
  grid.pastingCell.addHandler(pastingCellHandler);
  grid.invalidate();

  return () => {
    try {
      grid.formatItem?.removeHandler(formatItemHandler);
      grid.beginningEdit?.removeHandler(beginningEditHandler);
      grid.pastingCell?.removeHandler(pastingCellHandler);
    } catch {
      /* unmount race */
    }
  };
};
