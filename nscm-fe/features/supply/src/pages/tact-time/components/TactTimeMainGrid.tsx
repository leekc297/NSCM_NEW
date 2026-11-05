import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  MAX_TACT_TIME_FALLBACK,
  MSG,
  OPERATION_GROUP_ELECTRODE,
  PACKER_COLUMNS,
  PLANT_COLUMNS,
  TACT_MODE,
} from '../tact-time.constants';
import type { MainRow } from '../tact-time.types';
import { buildColumns } from '../utils/tactTimeColumns';
import { clampTactTime, deriveJumboMin, deriveTactTimeFromDaily } from '../utils/tactTimeDerive';
import { isPackerCellEditable, isPlantCellEditable } from '../utils/tactTimeEditLock';

interface Props {
  mode: TACT_MODE;
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // Edit(F2) 진입 여부 — false 면 조회직후 전체 readOnly (design 03 §3.2 마지막 문단).
  editMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  onRowDblClick: (row: MainRow) => void;
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// PRIORITY 는 0~99 정수만 (숫자 2자리). numberRules 는 문자/상한을 막지 못해 화면에서 가드한다.
const PRIORITY_PATTERN = /^\d{0,2}$/;

export const TactTimeMainGrid = ({
  mode,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  editMode,
  adminColumns,
  onRowDblClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const isPlant = mode === TACT_MODE.PLANT;
  const setToast = useMessageStore.getState().setToast;

  const columns = useMemo(
    () => buildColumns(isPlant ? PLANT_COLUMNS : PACKER_COLUMNS, adminColumns),
    [isPlant, adminColumns]
  );

  // 최신 editMode/mode 를 stale 없이 참조 (핸들러는 mount 후 등록, deps 최소화).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;
  const isPlantRef = useRef(isPlant);
  isPlantRef.current = isPlant;
  // 부모 리렌더마다 바뀌는 콜백 — deps 에 넣으면 effect 재실행(invalidate)으로 그리드가 깜빡인다.
  const onRowDblClickRef = useRef(onRowDblClick);
  onRowDblClickRef.current = onRowDblClick;

  // 편집잠금(beginningEdit) + 파생 Auto-Sync(cellEditEnded) 핸들러 — SalesFuturePriceGrid 패턴.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전체 readOnly, Edit 진입 시 white-list 로 셀별 해제 (design 03 §3.2).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editModeRef.current) {
        e.cancel = true;
        return;
      }
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      const editable = isPlantRef.current
        ? isPlantCellEditable(binding, row)
        : isPackerCellEditable(binding, row);
      if (!editable) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 파생 Auto-Sync — 전극 JUMBO_MIN / Packer TACT_TIME + TACT_TIME clamp (design 03 §3.3).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      if (isPlantRef.current) {
        // 전극(E): TACT_TIME 또는 LANE_QTY 변경 -> JUMBO_MIN 파생 (cs:2639/2644)
        if (
          (binding === 'TACT_TIME' || binding === 'LANE_QTY') &&
          s(row.OPERATION_GROUP_ID) === OPERATION_GROUP_ELECTRODE
        ) {
          setCell('JUMBO_MIN', deriveJumboMin(row.TACT_TIME, row.LANE_QTY));
        }
      } else if (binding === 'DAILY_CAPACITY') {
        // Packer: DAILY_CAPACITY 변경 -> TACT_TIME 파생 (cs:2717/2722)
        // 기존 로직 주석 보존 (2026-10-27) 시작
        // setCell('TACT_TIME', deriveTactTimeFromDaily(row.DAILY_CAPACITY));
        // 기존 로직 주석 보존 (2026-10-27) 끝
        // DAILY_CAPACITY 0 이면 TACT_TIME 유지(AS-IS 동일).
        const derived = deriveTactTimeFromDaily(row.DAILY_CAPACITY);
        if (derived !== null) setCell('TACT_TIME', derived);
      }

      // TACT_TIME 셀입력 clamp [MIN, MAX] (cs:2895 — MSG00203). Max 실측 SQL 은 asis.py 차단(확인 필요).
      if (binding === 'TACT_TIME') {
        const { value, clamped } = clampTactTime(row.TACT_TIME, MAX_TACT_TIME_FALLBACK);
        if (clamped) {
          setCell('TACT_TIME', value);
          setToast({ type: 'error', message: t(MSG.TACT_MAX_CLAMP, '_Tact Time out of range.') });
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // PRIORITY 입력 가드 — 타이핑은 키 입력 차단, 확정/붙여넣기는 반영 안 함.
    const isPriorityCol = (sender: FlexGridType, col: number) =>
      sender.columns[col]?.binding === 'PRIORITY';
    const prepareCellForEditHandler = (sender: FlexGridType, e: { col: number }) => {
      const editor = sender.activeEditor;
      if (!editor || !isPriorityCol(sender, e.col)) return;
      editor.addEventListener('beforeinput', (ev: InputEvent) => {
        if (ev.data == null) return;
        const { value, selectionStart, selectionEnd } = editor;
        const next =
          value.slice(0, selectionStart ?? value.length) +
          ev.data +
          value.slice(selectionEnd ?? value.length);
        if (!PRIORITY_PATTERN.test(next.replaceAll(',', ''))) ev.preventDefault();
      });
      // beforeinput 으로 못 막는 입력(한글 IME 등)은 즉시 숫자 2자리로 정리
      editor.addEventListener('input', () => {
        const cleaned = editor.value.replace(/\D/g, '').slice(0, 2);
        if (cleaned !== editor.value) editor.value = cleaned;
      });
    };
    // 편집 전 셀에서 바로 타이핑하면 Wijmo 가 첫 글자로 편집을 시작한다 — 숫자 외 키는 여기서 차단
    const hostKeydownHandler = (ev: KeyboardEvent) => {
      if (g.activeEditor || !isPriorityCol(g, g.selection.col)) return;
      if (ev.ctrlKey || ev.metaKey || ev.altKey) return;
      if (ev.key === 'Process' || (ev.key.length === 1 && !/\d/.test(ev.key))) {
        ev.preventDefault();
        ev.stopPropagation();
      }
    };
    g.hostElement.addEventListener('keydown', hostKeydownHandler, true);
    const cellEditEndingHandler = (sender: FlexGridType, e: { col: number; cancel: boolean }) => {
      const editor = sender.activeEditor;
      if (!editor || e.cancel || !isPriorityCol(sender, e.col)) return;
      if (!PRIORITY_PATTERN.test(editor.value.replaceAll(',', '').trim())) e.cancel = true;
    };
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { col: number; cancel: boolean; data?: unknown }
    ) => {
      if (!isPriorityCol(sender, e.col)) return;
      if (!PRIORITY_PATTERN.test(s(e.data).replaceAll(',', '').trim())) e.cancel = true;
    };
    g.prepareCellForEdit.addHandler(prepareCellForEditHandler);
    g.cellEditEnding.addHandler(cellEditEndingHandler);
    g.pastingCell.addHandler(pastingCellHandler);

    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const row = g.rows[ht.row]?.dataItem as MainRow | undefined;
      // if (row) onRowDblClick(row);
      if (row) onRowDblClickRef.current(row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 예외 보유 행(EXCEPT_YN='Y')은 Model 컬럼부터 끝까지 하늘색 (AS-IS setExceptYnColor cs:2588).
    const formatItemHandler = (sender: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const itemCol = sender.columns.indexOf('ITEM_ID');
      const on = s(row?.EXCEPT_YN) === 'Y' && itemCol >= 0 && e.col >= itemCol;
      toggleClass(e.cell, 'tact-except-row', on);
    };
    g.formatItem.addHandler(formatItemHandler);

    // 상단 그리드 셀 병합 — AS-IS siMain.SmartColMerge() 이식(cs:277 등).
    //   공용 CustomMergeManager(DataGrid 자동설치)가 좌측 누적 키로 선행 식별컬럼
    //   (Division/Site/Model/Nick Name)만 계층 병합하고, 신규행(CRUD_TYPE='I')은 병합에서 제외한다.
    //   값/감사 컬럼은 행마다 값이 달라 자연히 묶이지 않는다. AllowMerging.All 은 DataGrid prop 로 지정.
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.prepareCellForEdit?.removeHandler(prepareCellForEditHandler);
        g.cellEditEnding?.removeHandler(cellEditEndingHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.hostElement?.removeEventListener('keydown', hostKeydownHandler, true);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        /* unmount race */
      }
    };
    // }, [columns, onRowDblClick]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
