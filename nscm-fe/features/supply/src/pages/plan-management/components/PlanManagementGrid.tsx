import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { ACTION_COLUMNS, FINAL_PLAN_TYPE, type ActionColumn } from '../plan-management.constants';
import type { PlanRow, RevisionCandidateMap } from '../plan-management.types';

import styles from './PlanManagementGrid.module.scss';

const REVISION_BINDING = 'REVISION_NO';
const ACTION_BINDINGS = Object.keys(ACTION_COLUMNS) as ActionColumn[];

const cell = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

// 액션 셀버튼 활성 판정 — 행별 AUTH='Y'. ENGINE_RUN 은 추가로 'Final Plan(FN) 행의 CONFIRM_YN<>Y'
//   (화면설계서: Engine Run 은 Final Plan 의 CONFIRM_YN='N' 일 때만 활성 — 행 자신이 아니라 FN 행 기준 교차 판정).
const isActionEnabled = (
  row: PlanRow,
  col: ActionColumn,
  finalPlanConfirmed: boolean
): boolean => {
  if (cell(row[ACTION_COLUMNS[col].auth]) !== 'Y') return false;
  if (col === 'ENGINE_RUN') return !finalPlanConfirmed;
  return true;
};

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  rows: PlanRow[];
  staticColumns: RawFlexGridColumnConfig[];
  /** PLAN_TYPE(PR/MA/SE/FN)별 REVISION_NO 후보 — 조회 응답 o_rc2~o_rc5 동봉분 */
  candidates: RevisionCandidateMap;
  /** 액션 셀버튼 클릭 — 통합 SAVE(actvCd) 호출 */
  onAction: (row: PlanRow, col: ActionColumn) => void;
  /** 상단 행 더블클릭 선택 — 하단 Detail(Engine) 조회(설계서 "상단 Grid Version 선택에 따른") */
  onRowSelect: (row: PlanRow) => void;
  onRevisionChanged: (row: PlanRow) => void;
}

export const PlanManagementGrid = ({
  gridRef,
  gridFilterRef,
  rows,
  staticColumns,
  candidates,
  onAction,
  onRowSelect,
  onRevisionChanged,
}: Props) => {
  // 핸들러가 최신 상태를 참조하도록 ref 미러(그리드 핸들러는 1회 등록)
  const candidatesRef = useRef(candidates);
  candidatesRef.current = candidates;
  const onActionRef = useRef(onAction);
  onActionRef.current = onAction;
  const onRowSelectRef = useRef(onRowSelect);
  onRowSelectRef.current = onRowSelect;
  const onRevisionRef = useRef(onRevisionChanged);
  onRevisionRef.current = onRevisionChanged;

  const candidatesOf = (row: PlanRow | undefined) =>
    candidatesRef.current[cell(row?.PLAN_TYPE)] ?? [];

  // Engine Run 활성 교차판정 입력 — Final Plan(FN) 행의 CONFIRM_YN='Y' 면 Engine Run 전행 잠금(화면설계서)
  const finalConfirmedRef = useRef(false);
  finalConfirmedRef.current = rows.some(
    r => cell(r.PLAN_TYPE) === FINAL_PLAN_TYPE && cell(r.CONFIRM_YN) === 'Y'
  );

  const editStartValueRef = useRef('');

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // 액션 셀버튼(ENGINE_RUN/VER_CREATE/VER_CANCEL/SHIP_REQ_CREATE) 렌더 + 행별 활성, REVISION_NO 표시.
    const handleFormatItem = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const column = sender.columns[e.col];
      const binding = (column?.binding ?? '');
      const row = sender.rows[e.row]?.dataItem as PlanRow | undefined;
      if (!row) return;

      if (ACTION_BINDINGS.includes(binding as ActionColumn)) {
        const col = binding as ActionColumn;
        const enabled = isActionEnabled(row, col, finalConfirmedRef.current);
        toggleClass(e.cell, 'wj-cell-editable', false);
        const button = globalThis.document.createElement('button');
        button.type = 'button';
        button.className = enabled ? styles.cellButton : `${styles.cellButton} ${styles.cellButtonLocked}`;
        button.disabled = !enabled;
        button.dataset.actionCol = col;
        button.textContent = ACTION_COLUMNS[col].label; // 짧은 액션명(Run/Create/Cancel/Run)
        // 고정 높이 버튼을 셀 안에서 세로 가운데 정렬(scss .cellButton height 와 함께)
        e.cell.style.padding = '0 4px';
        e.cell.style.display = 'flex';
        e.cell.style.alignItems = 'center';
        e.cell.style.justifyContent = 'center';
        e.cell.replaceChildren(button);
        return;
      }

      if (binding === REVISION_BINDING) {
        if (sender.activeEditor && sender.selection.row === e.row && sender.selection.col === e.col)
          return;
        const code = cell(row.REVISION_NO);
        if (!code) return;
        const matched = candidatesOf(row).find(c => cell(c.CODE) === code);
        if (matched) e.cell.textContent = cell(matched.NAME) || code;
      }
    };
    grid.formatItem.addHandler(handleFormatItem);

    // REVISION_NO 편집 진입 — 그 행 PLAN_TYPE 후보로 콤보 dataMap 스왑(후보 0건이면 빈 DataMap)
    const handleBeginningEdit = (sender: FlexGrid, e: { row: number; col: number; cancel?: boolean }) => {
      const column = sender.columns[e.col];
      if (column?.binding !== REVISION_BINDING) return;
      const row = sender.rows[e.row]?.dataItem as PlanRow | undefined;
      editStartValueRef.current = cell(row?.REVISION_NO);
      column.dataMap = new DataMap(candidatesOf(row), 'CODE', 'NAME');
    };
    grid.beginningEdit.addHandler(handleBeginningEdit as never);

    // REVISION_NO 값 변경 — 페이지가 Detail 재조회/선택 갱신(같은 값 재선택은 무시)
    const handleCellEditEnded = (sender: FlexGrid, e: { row: number; col: number }) => {
      if (sender.columns[e.col]?.binding !== REVISION_BINDING) return;
      const row = sender.rows[e.row]?.dataItem as PlanRow | undefined;
      if (!row) return;
      if (cell(row.REVISION_NO) === editStartValueRef.current) return;
      onRevisionRef.current(row);
    };
    grid.cellEditEnded.addHandler(handleCellEditEnded as never);

    return () => {
      try {
        grid.formatItem?.removeHandler(handleFormatItem);
        grid.beginningEdit?.removeHandler(handleBeginningEdit as never);
        grid.cellEditEnded?.removeHandler(handleCellEditEnded as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // 단일 클릭은 액션 셀버튼에서만 동작 — 일반 셀 클릭은 행 선택으로 남긴다(하단 조회는 더블클릭, 사용자 2026-10-14)
  const handleClick = (mouseEvent: MouseEvent) => {
    const target = mouseEvent.target;
    if (!(target instanceof Element)) return;
    const button = target.closest<HTMLButtonElement>('button[data-action-col]');
    if (!button || button.disabled) return;
    const grid = gridRef.current;
    if (!grid) return;
    const hit = grid.hitTest(mouseEvent);
    if (hit.cellType !== CellType.Cell) return;
    const row = grid.rows[hit.row]?.dataItem as PlanRow | undefined;
    if (!row) return;
    mouseEvent.preventDefault();
    mouseEvent.stopPropagation();
    onActionRef.current(row, button.dataset.actionCol as ActionColumn);
  };

  // 행 더블클릭 → 선택 → 하단 Detail(Engine) 조회(AS-IS SpdPlan_CellDoubleClick 방식)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const target = mouseEvent.target;
    if (target instanceof Element && target.closest('button[data-action-col]')) return;
    const grid = gridRef.current;
    if (!grid) return;
    const hit = grid.hitTest(mouseEvent);
    if (hit.cellType !== CellType.Cell) return;
    const row = grid.rows[hit.row]?.dataItem as PlanRow | undefined;
    if (!row) return;
    onRowSelectRef.current(row);
  };

  const itemsSource = useMemo(() => rows, [rows]);

  return (
    <DataGrid<PlanRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.All}
      hideStatusColumn

      click={handleClick}
      dblClick={handleDoubleClick}
    />
  );
};
