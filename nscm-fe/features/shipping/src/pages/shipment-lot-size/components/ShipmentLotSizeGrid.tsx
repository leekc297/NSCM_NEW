import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { LOT_SIZE_COLUMNS, MERGE_COLUMNS } from '../shipment-lot-size.constants';
import type { ShipmentLotSizeRow } from '../shipment-lot-size.types';
import { buildColumns } from '../utils/shipmentLotSize.columns';
import { computeIncrementSync } from '../utils/shipmentLotSize.derive';
import { isLotSizeCellEditable } from '../utils/shipmentLotSize.editLock';

interface InvalidCell {
  row: Record<string, unknown>;
  column: string;
}

interface Props {
  rows: ShipmentLotSizeRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // 편집권한(hasButton('EDIT')) — 로드 시 1회 판정. false 면 그리드 읽기전용(편집셀 잠금+yellow 미표시).
  canEdit: boolean;
  // 저장검증(design 03 §4.3) 위반 셀 — formatItem 영속 하이라이트.
  invalidCells: InvalidCell[];
  onFocus: () => void;
}

// 저장검증 위반 셀 red (design 03 §3-14). 편집셀 yellow 는 공용 .wj-cell-editable 이 담당.
const INVALID_BG = '#ffd7d7';

const MERGE_SET = new Set<string>(MERGE_COLUMNS);

export const ShipmentLotSizeGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  canEdit,
  invalidCells,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(LOT_SIZE_COLUMNS, adminColumns), [adminColumns]);

  // 편집권한/위반셀을 ref 로 들고 핸들러가 최신값 참조(핸들러 재바인딩 없이). 변경 시 invalidate 로 재적용.
  const canEditRef = useRef(canEdit);
  const invalidRef = useRef<InvalidCell[]>(invalidCells);
  useEffect(() => {
    canEditRef.current = canEdit;
    invalidRef.current = invalidCells;
    gridRef.current?.invalidate();
  }, [canEdit, invalidCells, gridRef]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집잠금(design 03 §3, 상시편집): 편집 화이트리스트(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN)만 편집 허용,
    //   나머지(식별/표시/audit/OPERATION_GROUP_ID)는 항상 잠금. Edit 토글 없이 조회 직후 즉시 4컬럼 편집(G1).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!canEditRef.current || !isLotSizeCellEditable(binding)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // INCREMENT = LOT_SIZE auto-sync 파생 (design 03 §3-16, cs:735).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'LOT_SIZE') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const nextInc = computeIncrementSync(row);
      if (nextInc === null) return;
      const tracker = editTrackerRef.current;
      const prev = row.INCREMENT;
      tracker?.storeChange(row as never, 'INCREMENT', prev as never, nextInc as never);
      row.INCREMENT = nextInc;
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // formatItem: 저장검증 위반셀 red 하이라이트(영속). DOM 재사용 대비 매 렌더 재적용/해제.
    //   편집셀 yellow 는 공용 .wj-cell-editable(INPUT_TP_CD 메타 'M' 4컬럼 + isReadOnly 권한연동)이
    //   담당한다 — 커스텀 배경칠 제거(hook #95 grid-cell-backcolor-standard). 위반 red 는 인라인이라
    //   .wj-cell-editable 보다 우선 적용된다.
    const formatItemHandler = (sndr: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sndr.columns[e.col]?.binding ?? '';
      const dataItem = sndr.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const isInvalid =
        !!dataItem && invalidRef.current.some(c => c.row === dataItem && c.column === binding);
      e.cell.style.backgroundColor = isInvalid ? INVALID_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 세로 병합 (design 03 §3-9·15, hook #69) — Division/Operation/Site/Item 반복값. 좌측 누적 키 계층 병합.
    //   신규행('I')은 CustomMergeManager 기본 가드로 제외. 스크롤 시 유지(mergeManager 자동).
    const applyMerge = () => {
      g.allowMerging = AllowMerging.Cells;
      for (let i = 0; i < g.columns.length; i += 1) {
        g.columns[i].allowMerging = MERGE_SET.has(g.columns[i].binding ?? '');
      }
    };
    applyMerge();
    // 그리드 인스턴스당 1회 — 생성자가 grid 이벤트를 구독하므로 effect 재실행마다 재생성하지 않는다.
    if (!(g.mergeManager instanceof CustomMergeManager)) g.mergeManager = new CustomMergeManager(g);
    g.updatedLayout.addHandler(applyMerge);
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.updatedLayout?.removeHandler(applyMerge);
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
      // EDIT 권한 없으면 읽기전용 → 공용 .wj-cell-editable(편집 하이라이트)도 권한을 존중한다.
      //   권한 있으면 INPUT_TP_CD 메타('M' 4컬럼)로 편집셀이 자동 판정·강조된다.
      isReadOnly={!canEdit}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.Cells}
      gotFocus={onFocus}
    />
  );
};
