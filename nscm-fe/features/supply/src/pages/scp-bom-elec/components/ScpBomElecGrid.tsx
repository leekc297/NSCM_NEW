import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { EDITABLE_COLUMNS, MENU_ID, MERGE_COLUMNS, ROW_LOCK_BG } from '../scp-bom-elec.constants';
import type { ScpBomElecRow } from '../scp-bom-elec.types';
import { isRowLocked } from '../utils/scp-bom-elec.editLock';

interface Props {
  rows: ScpBomElecRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
}

const EDITABLE = EDITABLE_COLUMNS as readonly string[];

export const ScpBomElecGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
}: Props) => {
  // 셀 콤보 @토큰 치환 — SCP_YN·STOCK_SUM 은 YesOrNo(@maxNumber 토큰 없음)라 mnuId 만 전달.
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 세로 계층 병합 대상 컬럼 제한 — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를
  //   씌우므로, 병합 4컬럼(DIVISION_ID·PARENT_ITEM_ID·PARENT_ITEM_NAME·ELECTRODE_TYPE)만 남기고
  //   나머지(Child Item·편집 2컬럼 등)는 false 로 되돌린다(design 03 §3.4 — 서버 ORDER BY 정본, FE 재정렬 금지).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = MERGE_COLUMNS.has(col.binding);
      }
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, rows]);

  // 행 편집잠금 — SCP_YN 이 'Y'/'N' 아닌 행은 M 2컬럼 포함 전 셀 편집 차단(design 03 §3 W7).
  //   S 컬럼(11)은 공용 DataGrid 가 메타 INPUT_TP_CD='S' 로 이미 cancel 한다.
  //   여기 핸들러는 그 뒤에 등록되어, 편집 컬럼(M)이라도 잠금행이면 cancel 을 되살린다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: CellRangeEventArgs) => {
      if (e.panel?.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!EDITABLE.includes(binding)) return; // S 컬럼은 wrapper 가 처리
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (isRowLocked(row)) e.cancel = true;
    };
    g.beginningEdit.addHandler(handler);
    return () => g.beginningEdit?.removeHandler(handler);
  }, [gridRef, rows]);

  // 붙여넣기도 행잠금 차단 — 공용 pastingCell 은 메타(INPUT_TP='M')만 보고 행잠금을 무시하므로, 잠금행
  //   편집 2컬럼에 붙여넣기가 통과한다(refetch 시 조용히 사라짐). beginningEdit 와 동일 게이트를 재지정
  //   (SCP0053 독립 감사 교차 발견 — memory sheet-columns-input-tp-all-search-only-grid-readonly).
  //   실데이터상 SCP_YN 은 Y/N 뿐이라 발화 0 이나 W7 방어 규칙의 붙여넣기 축.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: CellRangeEventArgs) => {
      if (e.panel?.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!EDITABLE.includes(binding)) return; // S 컬럼은 wrapper 가 처리
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (isRowLocked(row)) e.cancel = true;
    };
    g.pastingCell.addHandler(handler);
    return () => g.pastingCell?.removeHandler(handler);
  }, [gridRef, rows]);

  // 잠금행 배경 Gray (design 03 §3 W8, hook #95). DataGrid 는 formatItem prop 을 노출하지 않아
  //   셀 DOM 에 직접 세팅한다(scp-bom 선례). 셀 DOM 재사용 대비 미해당 시 '' 로 해제.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cell.style.backgroundColor = isRowLocked(row) ? ROW_LOCK_BG : '';
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem?.removeHandler(handler);
  }, [gridRef, rows]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      comboParams={comboParams}
      // 세로 계층 병합(위 updatedLayout 로 4컬럼 제한). 다단 병합헤더 없음(라벨클래스 전건 공란 — 단층).
      allowMerging={AllowMerging.Cells}
    />
  );
};
