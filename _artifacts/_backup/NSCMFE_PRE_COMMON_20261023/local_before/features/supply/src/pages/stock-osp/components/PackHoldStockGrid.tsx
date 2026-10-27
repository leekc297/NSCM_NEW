import {
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

import {
  DATE_FINISH_COLUMN,
  DATE_START_COLUMN,
  EDITABLE_COLUMNS,
  MENU_ID,
  VALIDATION_ERROR_BG,
} from '../stock-osp.constants';
import type { PackHoldStockRow } from '../stock-osp.types';
import { isHoldRow } from '../utils/stock-osp.editLock';

interface Props {
  rows: PackHoldStockRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  // R3 — 셀 편집 종료 시 날짜역전 판정(true=역전, 호출부는 값 원복 없이 alert 만; 원복은 여기서 수행).
  isReversed: (row: Record<string, unknown>) => boolean;
  onReversed: (row: Record<string, unknown>) => void;
}

const EDITABLE = EDITABLE_COLUMNS as readonly string[];
const DATE_COLS = [DATE_START_COLUMN, DATE_FINISH_COLUMN];

// SCP0041 Pack Hold Stock 시트 — 15컬럼(design 03 §1-B). DIR='HOLD' 행만 편집(R2),
//   편집 컬럼은 QTY/DATE_FORECAST_START/DATE_FORECAST_FINISH 로 한정. 날짜역전 검증+원복(R3),
//   저장검증 실패행 LightPink(R4)는 페이지가 넘기는 색상 셋으로 표기.
export const PackHoldStockGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  isReversed,
  onReversed,
}: Props) => {
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // R2 — 행 편집잠금(design 03 §3 R2). 편집 3컬럼(QTY/START/FINISH)은 DIR='HOLD' 행만 개방.
  //   DB 메타는 전 컬럼 INPUT_TP_CD='S' 라, 공용 DataGrid setEditableColumns 가 beginningEdit 에서
  //   editable 3컬럼도 e.cancel=true 로 막는다(무조건 대입). 이 핸들러는 그 뒤에 등록되므로,
  //   HOLD 행 + 편집컬럼이면 반드시 e.cancel=false 로 되살려야 한다 — 여기서 return 만 하면 공용의
  //   cancel=true 가 남아 편집 자체가 불가능(메타 리터럴 오버라이드 금지, hook #130 — 코드게이트로 개방).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: CellRangeEventArgs) => {
      if (e.panel?.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!EDITABLE.includes(binding)) return; // S 컬럼은 공용 wrapper 가 처리(그대로 잠금)
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // HOLD 행이면 공용이 건 cancel 을 해제해 편집 개방, 비HOLD 행이면 잠금 유지.
      e.cancel = !isHoldRow(row);
    };
    g.beginningEdit.addHandler(handler);
    return () => g.beginningEdit?.removeHandler(handler);
  }, [gridRef, rows]);

  // R3 — 날짜역전 검증+원복. 예측 시작/종료 편집 종료 시 start>finish 면 편집 전 값으로 되돌리고 alert.
  //   cellEditEnded 시점엔 이미 새 값이 반영되므로, 편집 진입값을 cellEditEnding 에서 보관해 원복한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    let prevValue: unknown;
    const onEnding = (sender: FlexGrid, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!DATE_COLS.includes(binding)) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      prevValue = row ? row[binding] : undefined;
    };
    const onEnded = (sender: FlexGrid, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!DATE_COLS.includes(binding)) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (isReversed(row)) {
        row[binding] = prevValue; // 편집 전 값으로 원복
        sender.invalidate();
        onReversed(row);
      }
    };
    g.cellEditEnding.addHandler(onEnding);
    g.cellEditEnded.addHandler(onEnded);
    return () => {
      g.cellEditEnding?.removeHandler(onEnding);
      g.cellEditEnded?.removeHandler(onEnded);
    };
  }, [gridRef, rows, isReversed, onReversed]);

  // R4 표기 보조 — 저장 재검증 실패행 LightPink. AS-IS BackColor(cs BackColor=LightPink).
  //   DataGrid 는 formatItem prop 미노출이라 셀 DOM 에 직접 세팅(scp-bom/long-term-stock 선례).
  //   판정은 현재 행 데이터의 역전 여부로 재계산 — 저장 실패 후에도 사용자가 고치면 자동 해제.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      // 역전 위반 행의 날짜 2컬럼만 강조(전 행 도배 방지). 정상 시 '' 로 해제.
      const mark = isReversed(row) && DATE_COLS.includes(binding);
      e.cell.style.backgroundColor = mark ? VALIDATION_ERROR_BG : '';
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem?.removeHandler(handler);
  }, [gridRef, rows, isReversed]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      comboParams={comboParams}
    />
  );
};
