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

import { EDITABLE_COLUMNS, MENU_ID, MERGE_COLUMNS, ROW_LOCK_BG } from '../scp-bom.constants';
import type { ScpBomRow } from '../scp-bom.types';
import { isRowLocked } from '../utils/scp-bom.editLock';

interface Props {
  rows: ScpBomRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
}

const EDITABLE = EDITABLE_COLUMNS as readonly string[];

export const ScpBomGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
}: Props) => {
  // SEQ_NUMBER 셀 콤보(@maxNumber) 파라미터 — 메타 ATTRIBUTE1 실측값(SI_ALT_PRIORITY=20) 구동(design 03 §4.4).
  //   상수 이식 금지: 메타에서 읽어 comboParams 로 전달. YesOrNo 는 @maxNumber 토큰이 없어 무해.
  const maxNumber = useMemo(() => {
    const col = staticColumns.find(c => c.cellCboDataTp === 'SEQ_NUMBER');
    return col?.attribute1 ? String(col.attribute1) : '';
  }, [staticColumns]);

  // SEQ_NUMBER 컬럼이 staticColumns 에 존재할 때만 maxNumber 가 채워지므로(그 컬럼의 ATTRIBUTE1),
  //   빈 @maxNumber 로 콤보가 발사되는 일은 없다(컬럼 없으면 콤보 자체가 없음).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'`, maxNumber }), [maxNumber]);

  // 세로 계층 병합 대상 컬럼 제한 — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 true 를
  //   씌우므로, 표시 잠금 컬럼(MERGE_COLUMNS = SORT1~15)만 남기고 편집 3컬럼(M)은 false 로 되돌린다
  //   (design 03 §3.4 — 편집 컬럼 병합 제외, long-term-stock/bod 처방).
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

  // 행 편집잠금 — SCP_PLAN_YN 이 'Y'/'N' 아닌 행은 M 3컬럼 포함 전 셀 편집 차단(design 03 §3 W6).
  //   S 컬럼(SORT1~15)은 공용 DataGrid setEditableColumns 가 메타 INPUT_TP_CD='S' 로 이미 cancel 한다.
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

  // 붙여넣기도 행잠금 차단 — 공용 pastingCell(defaultEditHandler)의 isEditableCell 은 메타(INPUT_TP='M')만
  //   보고 행잠금(isRowLocked)은 무시하므로, 잠금행 M3 셀에 붙여넣기가 통과한다(refetch 시 조용히 사라짐).
  //   beginningEdit 와 동일 게이트를 pastingCell 에 재지정 — AS-IS Rows[i].Locked=true(cs:359) 는 편집·붙여넣기
  //   둘 다 차단(memory sheet-columns-input-tp-all-search-only-grid-readonly — 편집 살리면 붙여넣기가 조용히 샌다).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: CellRangeEventArgs) => {
      if (e.panel?.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!EDITABLE.includes(binding)) return; // S 컬럼은 wrapper 가 메타로 차단
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (isRowLocked(row)) e.cancel = true;
    };
    g.pastingCell.addHandler(handler);
    return () => g.pastingCell?.removeHandler(handler);
  }, [gridRef, rows]);

  // 잠금행 배경 Gray (design 03 §3 W7, hook #95). DataGrid 는 formatItem prop 을 노출하지 않아
  //   셀 DOM 에 직접 세팅한다(long-term-stock 선례). 셀 DOM 재사용 대비 미해당 시 '' 로 해제.
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
      // 다단 병합헤더('Simulator' 그룹·PLANT_ID 상단 'Plant ID')는 메타 LARGE/SMALL_CLASS_LABEL 자동 소비.
      //   세로 계층 병합(전 표시 컬럼 좌측 누적)은 Cells + 위 updatedLayout 제한으로 적용(design 03 §3.4).
      allowMerging={AllowMerging.Cells}
    />
  );
};
