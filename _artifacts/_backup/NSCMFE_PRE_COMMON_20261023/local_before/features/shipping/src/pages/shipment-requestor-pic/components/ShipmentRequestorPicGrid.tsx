import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  DIVISION_CASCADE_CLEAR,
  DIVISION_COLUMN,
  MAIN_COLUMNS,
  MENU_ID,
  SITE_DESCRIPTION_COLUMN,
  TO_SITE_COLUMN,
} from '../shipment-requestor-pic.constants';
import type { MainRow } from '../shipment-requestor-pic.types';
import { buildColumns } from '../utils/shipmentRequestorPicColumns';
import {
  isCellEditable,
  isDivisionRequired,
  isInlineEditable,
  isInsertRow,
  isItemPopupColumn,
  isUserPopupColumn,
} from '../utils/shipmentRequestorPicEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  editMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  // 신규행 ITEM_ID 더블클릭 -> 페이지가 Item 팝업 오픈(6칸 채움 대상 행 기억). design 03 §3 R12.
  onItemCellDblClick: (row: Record<string, unknown>) => void;
  // User/Part/Team 더블클릭 -> 페이지가 UserInfoPopup 오픈(row/binding 기억). design 03 §3 R16~R18.
  onUserCellDblClick: (row: Record<string, unknown>, binding: string) => void;
  // 신규행 Division 미선택 상태 셀 편집/팝업 시도 시 안내(R10, MSG00097). 페이지가 alert.
  onDivisionRequired: () => void;
  onFocus: () => void;
}

// 편집가능 셀 배경(#95 grid-cell-backcolor-standard, design 03 §5.1). 잠금셀은 기본색.
//   Wijmo 셀 DOM 직접 스타일(inline React style 아님) — BodGrid/gridNegativeText 와 동일 패턴.
const EDITABLE_CELL_BG = '#FFFDE7';

export const ShipmentRequestorPicGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  editMode,
  adminColumns,
  onItemCellDblClick,
  onUserCellDblClick,
  onDivisionRequired,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 자동 콤보 셀(DIVISION_ID=MyDivision, SITE_DESCRIPTION=PlantCell @divisionId, VALID_YN=YesOrNo)의 @토큰 해소.
  //   Form 선택 division 을 기본 파라미터로 — 행별 cascade(PlantCell PARAM10='D')는 admin 메타가 처리.
  //   getCombo funnel 이 인용 처리(pre-quote idempotent, nscm-patterns §3.3).
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // 최신 editMode 를 stale 없이 참조(핸들러는 mount 후 등록, deps 최소화).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;

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

    // 편집 게이트(R3/R4) — 조회직후 기존행 = EDIT_SET, 신규행('I') = INSERT_SET. 팝업 셀은 인라인 편집 취소.
    //   화면 로직이 최종 판정(e.cancel 명시) — 공용 DataGrid defaultEditHandler(INPUT_TP_CD)를 화면이 재지정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // R10 — 신규행 Division 미선택 상태에서 종속 셀 편집 시도 시 차단 + 안내(MSG00097).
      if (isDivisionRequired(binding, row)) {
        e.cancel = true;
        onDivisionRequired();
        return;
      }
      e.cancel = !isInlineEditable(binding, row, editModeRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 셀 파생/cascade(R13/R14) — 콤보 편집 확정(ComboSelChange) 시:
    //   R13: SITE_DESCRIPTION(=SCM_SITE_ID 코드) 선택 -> TO_SITE 파생(cs:679~682).
    //   R14: 신규행 DIVISION_ID 변경 -> TO_SITE/SITE/ITEM 등 7칸 초기화(cs:683~695).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: unknown) => {
        const prev = row[key];
        if (prev === value) return;
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      if (binding === SITE_DESCRIPTION_COLUMN) {
        // SITE_DESCRIPTION 셀 value = SCM_SITE_ID(코드) → TO_SITE 동기(R13).
        setCell(TO_SITE_COLUMN, row[SITE_DESCRIPTION_COLUMN]);
      } else if (binding === DIVISION_COLUMN && isInsertRow(row)) {
        // 신규행 Division 변경 → 종속 7칸 초기화(R14).
        for (const key of DIVISION_CASCADE_CLEAR) setCell(key, '');
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // 이미지셀(User/Part/Team) + 신규행 ITEM_ID 더블클릭 -> 팝업(design 03 §3 R12/R16~R18).
    //   ITEM_ID 는 신규행에서만 열고, User 계열은 편집가능행에서 연다(편집 판정은 isCellEditable).
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      if (!row) return;
      // R10 — 신규행 Division 미선택 상태에서 팝업 셀(ITEM/User..) 더블클릭 시 차단 + 안내(MSG00097).
      if (isDivisionRequired(binding, row)) {
        onDivisionRequired();
        return;
      }
      if (isItemPopupColumn(binding)) {
        if (!isCellEditable(binding, row, editModeRef.current)) return; // 신규행만
        onItemCellDblClick(row);
        return;
      }
      if (isUserPopupColumn(binding)) {
        if (!isCellEditable(binding, row, editModeRef.current)) return;
        onUserCellDblClick(row, binding);
      }
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 셀 병합(R20) — AS-IS SmartColMerge(cs:160,297,534). 공용 CustomMergeManager 가 좌측 누적 키로
    //   선행 식별컬럼(Division/Plant Site/Item)만 계층 병합, 신규행(CRUD_TYPE='I')은 병합 제외.
    for (let i = 0; i < g.columns.length; i += 1) g.columns[i].allowMerging = true;
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
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
