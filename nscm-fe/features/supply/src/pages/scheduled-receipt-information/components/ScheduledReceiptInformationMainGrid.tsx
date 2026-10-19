import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { ScheduledReceiptRow } from '../scheduled-receipt-information.types';
import { isSheetCellEditable } from '../utils/scheduledReceiptInformationEditLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<ScheduledReceiptRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<ScheduledReceiptRow> | undefined>;
  data: ScheduledReceiptRow[];
  staticColumns: RawFlexGridColumnConfig[];
  planGroupOptions: ComboResponse[];
  isEditMode: boolean;
  onFocus: () => void;
}

const PLAN_GROUP_BINDING = 'OPMZ_PLAN_GR_ID';

/**
 * Scheduled Reciept Information 시트 그리드 — design/03_grid-columns.md §1.1/§3 white-list 재현.
 * ITEM_ID(팝업 대상) 컬럼이 이 시트엔 없다(§1.1 확인, Virtual Bom 시트만 팝업 반영 대상) — 더블클릭
 * 팝업 배선 없음. 편집잠금은 Virtual Bom 시트와 동일 규칙(`isSheetCellEditable` 공유).
 */
export const ScheduledReceiptInformationMainGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  planGroupOptions,
  isEditMode,
  onFocus,
}: Props) => {
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

    // INPUT_TP_CD 전건 'S'(design/03_grid-columns.md §1)라 공통 DataGrid wrapper
    // (dataGridUtils.ts GridUtils.isEditableCell)는 이 화면 전 셀을 항상 편집불가로 판정해
    // 'wj-cell-editable' 을 붙이지 않는다 — 실제로는 isSheetCellEditable 이 편집을 허용하므로
    // 시각적 단서(노란 배경)가 없는 채로 편집만 되는 불일치가 생긴다(react-gap-audit iter-2
    // SCP0130-06). 공용 핸들러 이후에 실행되도록 여기서 추가 등록해 최종 판정을 덮어쓴다.
    const formatItemHandler = (sender: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      if (!binding) return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      toggleClass(e.cell, 'wj-cell-editable', isSheetCellEditable(binding, row, isEditMode));
    };
    g.formatItem.addHandler(formatItemHandler);

    // SpdMain_ClipboardPasted(OPMZ_PLAN_GR_ID NAME→CODE 변환, `00_checklist.md` §2 #9/§3 #21,
    // convert-flow/goal.md SCP0130-10) — AS-IS `.cs` 원문은 이 세션에서 미확보라 정확한 변환 소스는
    // 확인 필요로 `__asis-mapping__.md` 에 남기고, 화면에 이미 로드된 PlanGroup 콤보 옵션(NAME↔CODE)
    // 으로 붙여넣은 NAME 텍스트를 CODE 로 치환한다. EditTracker 의 pastedCell 핸들러(원본 기록) 뒤에
    // 등록돼야 하므로 이 핸들러 등록 순서를 그대로 유지한다(Wijmo Event 는 등록 순서대로 호출).
    const pastedPlanGroupHandler = (sender: FlexGridType, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== PLAN_GROUP_BINDING) return;
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) return;
      const pastedValue = row[PLAN_GROUP_BINDING] as string | undefined;
      if (!pastedValue) return;
      const divisionId = (row.DIVISION_ID as string | undefined) ?? '';
      const matched = planGroupOptions.find(
        option => option.NAME === pastedValue && (!divisionId || option.DIVISION_ID === divisionId)
      );
      if (!matched || matched.CODE === pastedValue) return;
      editTrackerRef.current?.storeChange(
        row as ScheduledReceiptRow,
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
  }, [staticColumns, isEditMode, planGroupOptions]);

  return (
    <DataGrid<ScheduledReceiptRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      gotFocus={() => onFocus()}
    />
  );
};
