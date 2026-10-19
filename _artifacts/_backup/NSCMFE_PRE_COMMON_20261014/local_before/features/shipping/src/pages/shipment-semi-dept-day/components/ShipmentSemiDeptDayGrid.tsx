import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MAIN_COLUMNS, MENU_ID, MERGE_COLUMN } from '../shipment-semi-dept-day.constants';
import type { MainRow } from '../shipment-semi-dept-day.types';
import { buildColumns } from '../utils/shipmentSemiDeptDayColumns';
import {
  isCellEditable,
  isDivisionRequired,
  isInlineEditable,
  isInsertRow,
  isItemPopupColumn,
} from '../utils/shipmentSemiDeptDayEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  isEditMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  // 신규행 ITEM_ID 더블클릭 -> 페이지가 SCM0002 Item 팝업 오픈(ITEM_ID/NICK_NAME 채움 대상 행 기억). design 03 §3.4.
  onItemCellDblClick: (row: Record<string, unknown>) => void;
  // 신규행 DIVISION_ID 미선택 상태 ITEM_ID 팝업 시도 시 안내. 페이지가 alert(MSG00097="Please select Division.",
  //   AS-IS MSG00093 대응 — TO-BE 번호 재조회로 확정, hook #114). 권한게이트 문구와 같은 코드지만 문구는 "선택 안내".
  onDivisionRequired: () => void;
  onFocus: () => void;
}

// 편집가능 셀 배경(#95 grid-cell-backcolor-standard, design 03 §5-10). 잠금셀은 기본색.
//   Wijmo 셀 DOM 직접 스타일(inline React style 아님 — 공용 그리드 formatItem 패턴).
const EDITABLE_CELL_BG = '#FFFDE7';

// AS-IS spdMain "Shipment Semi Dept Day" (단일 그리드 11열). 조회직후 전잠금, Edit/Insert=지정칸(editLock).
//   셀 콤보(OPERATION_GROUP/DEPARTURE_DAY=LookupCommon, VALID_YN=YesOrNo)는 공용 DataGrid 가 admin 메타로 자동 배선.
//   신규행 DIVISION_ID 콤보(Division_SCP)는 buildColumns 가 주입(메타 미반영, design 03 §1.2).
//   화면은 (a) 모드×행상태 편집잠금(beginningEdit) (b) ITEM_ID 셀팝업(dblClick) (c) 세로 머지(DIVISION_ID)만 담당.
export const ShipmentSemiDeptDayGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  isEditMode,
  adminColumns,
  onItemCellDblClick,
  onDivisionRequired,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 셀 콤보 @토큰(@mnuId) 해소 — Division_SCP(권한, @mnuId+@sesUserId) / LookupCommon / YesOrNo.
  //   인용은 getCombo funnel(pre-quote idempotent, nscm-patterns §3.3).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 최신 isEditMode 를 stale 없이 참조(핸들러는 mount 후 등록, deps 최소화).
  const editModeRef = useRef(isEditMode);
  editModeRef.current = isEditMode;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집가능 셀 배경 강조(#95) — 셀 DOM 재사용 대비 항상 재설정(조건 미해당 시 해제).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cell.style.backgroundColor =
        row && isCellEditable(binding, row, editModeRef.current) ? EDITABLE_CELL_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집 게이트(design 03 §3.1) — 조회직후 전잠금(editMode=false) / Edit=기존행 DEPARTURE_DAY·VALID_YN /
    //   신규행('I')=DIVISION_ID/ITEM_ID/DEPARTURE_DAY/VALID_YN. ITEM_ID 는 팝업 전용이라 인라인 편집 취소.
    //   공용 DataGrid defaultEditHandler(INPUT_TP_CD='S')가 먼저 cancel, 화면이 나중 실행돼 최종 재지정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 신규행 DIVISION 미선택 상태에서 ITEM_ID 편집/팝업 시도 시 차단 + 안내(design 03 §3.4 cs:463 MSG00093).
      if (isDivisionRequired(binding, row)) {
        e.cancel = true;
        onDivisionRequired();
        return;
      }
      e.cancel = !isInlineEditable(binding, row, editModeRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // ITEM_ID 셀 더블클릭 -> SCM0002 Item 팝업(design 03 §3.4). 신규행 + 편집가능 + DIVISION_ID 있을 때만.
    //   직접 키입력은 beginningEdit 이 차단(팝업 전용, cs:440 KeyPress e.Handled).
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupColumn(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      if (!row || !isInsertRow(row)) return; // 신규행에서만(cs:456)
      if (!isCellEditable(binding, row, editModeRef.current)) return;
      if (isDivisionRequired(binding, row)) {
        onDivisionRequired();
        return;
      }
      onItemCellDblClick(row);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 세로 머지(design 03 §3.3) — DIVISION_ID 동일값 병합. AS-IS SmartColMerge(cs:162, TopChange cs:116 sticky 유지).
    //   공용 CustomMergeManager 가 좌측 누적 키로 병합 + 신규행(CRUD_TYPE='I') 제외. DIVISION_ID 외 컬럼은 미병합.
    const mergeCol = g.columns.getColumn(MERGE_COLUMN);
    if (mergeCol) mergeCol.allowMerging = true;
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
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
      isReadOnly={false}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
