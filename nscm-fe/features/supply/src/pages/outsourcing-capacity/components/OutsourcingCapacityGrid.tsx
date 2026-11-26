import { type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../outsourcing-capacity.constants';
import type { MainRow } from '../outsourcing-capacity.types';
import { buildColumns, MAIN_COLUMNS } from '../utils/outsourcingCapacityColumns';
import { coerceDailyCapa, isCellEditable } from '../utils/outsourcingCapacityEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

export const OutsourcingCapacityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 시작 시점 값 — 값이 실제로 바뀐 경우에만 보정하기 위한 비교 기준.
    let editStartValue: { row: number; col: number; value: unknown } | null = null;
    const cellText = (v: unknown) => (typeof v === 'string' || typeof v === 'number' ? String(v).trim() : '');

    // 편집 화이트리스트 — daily_capa_qty 만 개방(design 03 §1/§3). 그 외 전부 잠금.
    //   metadata INPUT_TP_CD 정비(05_register.sql)와 별개로 셀 잠금을 코드에서도 결정적으로 보장한다
    //   (design 03 §1.1 함정 방어 — 공용 gate 가 'S' 로 취소해도 daily_capa_qty 는 개방).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(binding);
      if (!e.cancel) editStartValue = { row: e.row, col: e.col, value: row[binding] };
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Daily Capacity 하한/상한 보정 — 정수·최소 1(+MSG00085)·최대 8자리(알림 없음) (design 03 §3 #6).
    //   binding 은 DB SHEET_COLUMNS COLUMN_NAME 그대로 대문자 'DAILY_CAPA_QTY'(2026-10-14 ora.py 실측).
    //   종전 lowercase 비교/필드 접근은 실제 바인딩과 불일치해 이 핸들러가 전혀 발동하지 않던 버그.
    //   AS-IS 는 SpdMain_Changed(값 변경 시)에서만 CheckDigitValueEntered 를 탄다(cs:431) — 셀에 들어갔다
    //   값을 바꾸지 않고 나가면 보정하지 않는다. 붙여넣기는 변경으로 보고 항상 검사한다.
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }, pasted = false) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'DAILY_CAPA_QTY') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      if (!pasted) {
        const start = editStartValue;
        editStartValue = null;
        if (start?.row === e.row && start.col === e.col && cellText(start.value) === cellText(row.DAILY_CAPA_QTY))
          return;
      }
      const { value, coerced, reason } = coerceDailyCapa(row.DAILY_CAPA_QTY);
      if (coerced) {
        const tracker = editTrackerRef.current;
        tracker?.storeChange(row as never, 'DAILY_CAPA_QTY', row.DAILY_CAPA_QTY as never, value as never);
        row.DAILY_CAPA_QTY = value;
        if (reason === 'min') {
          void setAlert({
            type: 'alert',
            content: t(MSG.DAILY_CAPA_MIN, '_Only values greater than or equal to {0} are allowed.').replace(
              '{0}',
              '1'
            ),
          });
        }
        sender.invalidate();
      }
    };
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) =>
      cellEditEndedHandler(sender, e, true);
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(pastedCellHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(pastedCellHandler);
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
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      gotFocus={onFocus}
    />
  );
};
