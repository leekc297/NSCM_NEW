import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { ConstraintOfShipmentQtyRow } from '../constraint-of-shipment-qty.types';
import {
  isMappedSiteDivision,
  siteDivisionsOf,
} from '../utils/constraint-of-shipment-qty.cascadeCombo';
import {
  applyItemSelect,
  applyValTpCdDerivation,
  isCellEditable,
  isItemPopupCell,
  isNewRow,
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

const SITE_COLUMNS = ['FROM_STE_ID', 'TO_STE_ID'] as const;

// 수량 6칸 — 원장 NUMBER(18,0)(ora.py 실측). 18자리 초과 입력은 JS 숫자 안전정수(약 15자리)를
//   넘겨 값이 조용히 변형된다(테스트 표-15: 20자리 입력 → 12,345,678,901,234,567,168 로 깨짐).
//   그래서 타이핑·붙여넣기 단계에서 18자리로 막는다(저장 정수검사 MSG00460 는 소수만 걸러 자리수는 못 막음).
const QTY_COLUMNS = [
  'SIPM_MIN_QYT',
  'SIPM_MAX_QTY',
  'SAT_SIPM_MIN_QTY',
  'SAT_SIPM_MAX_QTY',
  'SUN_SIPM_MIN_QTY',
  'SUN_SIPM_MAX_QTY',
] as const;
const QTY_MAX_DIGITS = 18;
const isQtyColumn = (binding: string): boolean =>
  (QTY_COLUMNS as readonly string[]).includes(binding);
const digitCount = (v: string): number => (v.match(/\d/g) ?? []).length;

// From/To Site 칸 후보를 행 Div 그대로가 아니라 사이트 사업부(EE → 81·40·82 등)로 거른다(AS-IS dtFromSite·dtToSite,
//   갭분석 C-19). 공용 그리드가 칸 설정 ATTRIBUTE2(DIVISION_ID 일치)로 만든 DataMap 에 바뀌는 Div 만 얹는다.
//   공용 그리드는 콤보 응답·레이아웃이 바뀌면 DataMap 을 새로 만들므로 그때마다 다시 얹는다(wrapped 로 한 번만).
const applySiteCandidates = (grid: FlexGrid, wrapped: WeakSet<object>): void => {
  for (const binding of SITE_COLUMNS) {
    const dataMap = grid.getColumn(binding)?.dataMap;
    if (!dataMap || wrapped.has(dataMap)) continue;
    wrapped.add(dataMap);
    const baseDisplayValues = dataMap.getDisplayValues.bind(dataMap);
    dataMap.getDisplayValues = (rowItem?: unknown) => {
      const division = s((rowItem as Record<string, unknown> | undefined)?.DIVISION_ID);
      if (!isMappedSiteDivision(division)) return baseDisplayValues(rowItem);
      const divisions = siteDivisionsOf(division);
      const comboRows = (dataMap.collectionView?.sourceCollection ?? []) as Record<
        string,
        unknown
      >[];
      const names = comboRows
        .filter(row => divisions.includes(s(row.DIVISION_ID)))
        .map(row => s(row.NAME));
      return [...new Set(names)];
    };
  }
};

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
  const wrappedSiteMapsRef = useRef(new WeakSet<object>());

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const updatedViewHandler = (sender: FlexGrid) =>
      applySiteCandidates(sender, wrappedSiteMapsRef.current);
    applySiteCandidates(g, wrappedSiteMapsRef.current);
    g.updatedView.addHandler(updatedViewHandler);

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

    // VAL_TP_CD "A"/"B" 자동 태깅 — AS-IS EditChange/KeyDown(Delete) 양쪽 중복 구현을 cellEditEnded 단일 경로로 통합.
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

    // 수량 칸 18자리 상한(표-15) — 붙여넣기는 값이 그리드에 들어가기 전(pastingCell, 취소 가능)에 자리수를
    //   보고 막는다. 이미 들어간 뒤(pastedCell)에는 JS 숫자로 변형된 값이라 되돌릴 근거가 없다.
    const pastingCellHandler = (
      sender: FlexGrid,
      e: { col: number; data: unknown; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (isQtyColumn(binding) && digitCount(s(e.data)) > QTY_MAX_DIGITS) e.cancel = true;
    };
    g.pastingCell.addHandler(pastingCellHandler as never);

    // 수량 칸 타이핑 상한(표-15) — 편집기 입력이 18자리에 닿으면 추가 숫자 키를 무시한다
    //   (project-route-electrode Priority 자리수 가드와 같은 방식). 첫 키는 편집기 생성 전이라 통과한다.
    const keydownHandler = (ev: KeyboardEvent) => {
      if (ev.ctrlKey || ev.metaKey || ev.altKey || ev.key.length !== 1) return;
      const col = g.activeEditor ? g.editRange?.col : g.selection?.col;
      const binding = col == null ? '' : (g.columns[col]?.binding ?? '');
      if (!isQtyColumn(binding) || !/^\d$/.test(ev.key)) return;
      const input = g.activeEditor as HTMLInputElement | null;
      if (!input) return;
      const start = input.selectionStart ?? input.value.length;
      const end = input.selectionEnd ?? start;
      const rest = input.value.slice(0, start) + input.value.slice(end);
      if (digitCount(rest) >= QTY_MAX_DIGITS) {
        ev.preventDefault();
        ev.stopPropagation();
      }
    };
    g.hostElement.addEventListener('keydown', keydownHandler, true);

    // ITEM_ID 셀 더블클릭 -> MaterialByDivisionModal(design 03 §1 #4, gridSignals#13).
    //   편집취소는 beginningEdit 이 이미 처리(isCellEditable('ITEM_ID')=false, convert-core §5-16).
    //   편집 권한이 없으면 신규 행 외에는 열지 않는다(AS-IS .cs:1003).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupCell(binding)) return;
      const row = g.rows[ht.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || (!isEditMode && !isNewRow(row))) return;
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.updatedView?.removeHandler(updatedViewHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.pastingCell?.removeHandler(pastingCellHandler as never);
        g.hostElement?.removeEventListener('keydown', keydownHandler, true);
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
          applyItemSelect(row, items, editTrackerRef.current);
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
