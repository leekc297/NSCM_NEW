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

import type { PlanRow, RevisionCandidateMap } from '../plan-management.types';
import {
  isConfirmLocked,
  isRunLocked,
  type PlanLockContext,
} from '../utils/planManagementLock';
import { DivisionNameMergeManager } from '../utils/planManagementMerge';

import styles from './PlanManagementGrid.module.scss';

// 버튼컬럼 바인딩 — AS-IS AddButtonColumn(RUN/CONFIRM, L268-269). SP 응답엔 없는 컬럼이라 셀 값은
//   항상 공백이고, 렌더는 아래 formatItem 이 버튼으로 그린다(공통 그리드에 FPButton 렌더링이 없어
//   화면에서 직접 그리는 mail-setup MailCategoryGrid 선례).
const RUN_BINDING = 'RUN';
const CONFIRM_BINDING = 'CONFIRM';
const REVISION_BINDING = 'REVISION_NO';
const MERGE_BINDING = 'DIVISION_NAME'; // AS-IS SetColumnMerge(DIVISION_NAME, Always) L723 — R4

const cell = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

interface Props {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  rows: PlanRow[];
  staticColumns: RawFlexGridColumnConfig[];
  /** PLAN_TYPE(TE/TM/PR/MA/SE/FN/SU)별 REVISION_NO 후보 — 조회 응답 동봉분(design 03 §1.4) */
  candidates: RevisionCandidateMap;
  lockCtx: PlanLockContext;
  onRunClick: (row: PlanRow) => void;
  onConfirmClick: (row: PlanRow) => void;
  onRowDoubleClick: (row: PlanRow) => void;
  onRevisionChanged: (row: PlanRow) => void;
}

export const PlanManagementGrid = ({
  gridRef,
  gridFilterRef,
  rows,
  staticColumns,
  candidates,
  lockCtx,
  onRunClick,
  onConfirmClick,
  onRowDoubleClick,
  onRevisionChanged,
}: Props) => {
  // 이벤트 핸들러가 렌더 시점 값을 참조하도록 ref 로 최신화(그리드 핸들러는 1회 등록)
  const candidatesRef = useRef(candidates);
  candidatesRef.current = candidates;
  const lockCtxRef = useRef(lockCtx);
  lockCtxRef.current = lockCtx;
  const onRunRef = useRef(onRunClick);
  onRunRef.current = onRunClick;
  const onConfirmRef = useRef(onConfirmClick);
  onConfirmRef.current = onConfirmClick;
  const onRowDblRef = useRef(onRowDoubleClick);
  onRowDblRef.current = onRowDoubleClick;
  const onRevisionRef = useRef(onRevisionChanged);
  onRevisionRef.current = onRevisionChanged;

  // 행의 PLAN_TYPE 후보 배열(design 03 §1.4 — 행 단위 정적 매핑)
  const candidatesOf = (row: PlanRow | undefined) =>
    candidatesRef.current[cell(row?.PLAN_TYPE)] ?? [];

  // 편집 진입 시점 값 — cellEditEnded 의 "실제로 바뀌었는가" 판정용(같은 값 재선택 무시)
  const editStartValueRef = useRef('');

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // RUN/CONFIRM 버튼 렌더 + 행별 잠금(R7~R10) + REVISION_NO CODE→NAME 표시.
    //   DataGrid 공용 formatItem 뒤에 등록되어 클래스 토글은 이쪽이 최종 승자다(MailCategoryGrid 규약).
    const handleFormatItem = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const column = sender.columns[e.col];
      const binding = column?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as PlanRow | undefined;
      if (!row) return;

      if (binding === RUN_BINDING || binding === CONFIRM_BINDING) {
        const locked =
          binding === RUN_BINDING
            ? isRunLocked(row, lockCtxRef.current)
            : isConfirmLocked(row, lockCtxRef.current);
        toggleClass(e.cell, 'wj-cell-editable', false);
        const button = globalThis.document.createElement('button');
        button.type = 'button';
        button.className = locked ? `${styles.cellButton} ${styles.cellButtonLocked}` : styles.cellButton;
        button.disabled = locked;
        button.dataset.planAction = binding === RUN_BINDING ? 'run' : 'confirm';
        // 버튼 라벨 = admin 컬럼 메타 헤더 그대로(하드코딩 회피 — Engine Run / Confirm)
        button.textContent = column?.header ?? binding;
        e.cell.replaceChildren(button);
        return;
      }

      if (binding === REVISION_BINDING) {
        // 편집 중인 셀은 건드리지 않는다(편집기 텍스트 보존 — mkt-fcst formatItem 규약)
        if (sender.activeEditor && sender.selection.row === e.row && sender.selection.col === e.col)
          return;
        const code = cell(row.REVISION_NO);
        if (!code) return;
        const matched = candidatesOf(row).find(c => cell(c.CODE) === code);
        if (matched) e.cell.textContent = cell(matched.NAME) || code;
      }
    };
    grid.formatItem.addHandler(handleFormatItem);

    // REVISION_NO 편집 진입 — 그 행의 PLAN_TYPE 후보로 콤보 dataMap 스왑(AS-IS SetCellTypeCombo
    //   L741-756, R14). 후보 0건이어도 빈 DataMap(자유 입력 차단 — mkt-fcst buildEditDataMap 규약).
    //   dataMap 은 행마다 편집 진입 시 재스왑되므로 원복하지 않는다(표시는 위 formatItem 이 담당).
    const handleBeginningEdit = (sender: FlexGrid, e: { row: number; col: number; cancel?: boolean }) => {
      const column = sender.columns[e.col];
      if (column?.binding !== REVISION_BINDING) return;
      const row = sender.rows[e.row]?.dataItem as PlanRow | undefined;
      editStartValueRef.current = cell(row?.REVISION_NO);
      column.dataMap = new DataMap(candidatesOf(row), 'CODE', 'NAME');
    };
    grid.beginningEdit.addHandler(handleBeginningEdit as never);

    // REVISION_NO 값 변경 — 연쇄 4단계(로컬 파생/planConfirm 재조회/lock 재계산/engine 재조회)는
    //   페이지 onRevisionChanged 가 수행(design 03 §4.3). 같은 값 재선택은 무시.
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

  // DIVISION_NAME 값 단독 키 병합 매니저(R4) — 공용 CustomMergeManager 는 col0(MODELING_ID,
  //   행 유일키)부터 누적 키라 이 화면에선 병합이 실효 0 이었다(iter-1 gap-audit G2).
  //   인스턴스 참조를 고정해야 wijmo 가 재대입하지 않는다(재대입되면 공용 TopLeft 데코레이터가 풀림).
  const mergeManager = useMemo(() => new DivisionNameMergeManager(MERGE_BINDING), []);

  // DIVISION_NAME 만 세로 병합(R4) — 공용 DataGrid 는 allowMerging prop 이 켜지면 전 컬럼에 일괄
  //   true 를 씌우므로 대상 외 컬럼은 도로 false(grid-behavior-parity §1.3, integration-psi 선례)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    for (let i = 0; i < grid.columns.length; i++) {
      grid.columns[i].allowMerging = grid.columns[i].binding === MERGE_BINDING;
    }
    grid.invalidate(true);
  }, [gridRef, staticColumns, rows]);

  // 버튼을 직접 눌렀을 때만 액션 — 셀 여백 클릭은 행 선택으로 남긴다(AS-IS CellClick 버튼컬럼 분기 L1336)
  const handleClick = (mouseEvent: MouseEvent) => {
    const target = mouseEvent.target;
    if (!(target instanceof Element)) return;
    const button = target.closest<HTMLButtonElement>('button[data-plan-action]');
    if (!button || button.disabled) return;
    const grid = gridRef.current;
    if (!grid) return;
    const hit = grid.hitTest(mouseEvent);
    if (hit.cellType !== CellType.Cell) return;
    const row = grid.rows[hit.row]?.dataItem as PlanRow | undefined;
    if (!row) return;
    mouseEvent.preventDefault();
    mouseEvent.stopPropagation();
    if (button.dataset.planAction === 'run') onRunRef.current(row);
    else onConfirmRef.current(row);
  };

  // 행 더블클릭 → Engine 재조회(AS-IS SpdPlan_CellDoubleClick L1362, 빈 그리드 가드 = dataItem 부재)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const target = mouseEvent.target;
    if (target instanceof Element && target.closest('button[data-plan-action]')) return;
    const grid = gridRef.current;
    if (!grid) return;
    const hit = grid.hitTest(mouseEvent);
    if (hit.cellType !== CellType.Cell) return;
    const row = grid.rows[hit.row]?.dataItem as PlanRow | undefined;
    if (!row) return;
    onRowDblRef.current(row);
  };

  // itemsSource 참조 안정화(nscm-patterns §5-4)
  const itemsSource = useMemo(() => rows, [rows]);

  return (
    <DataGrid<PlanRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={itemsSource}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.Cells}
      mergeManager={mergeManager}
      click={handleClick}
      dblClick={handleDoubleClick}
    />
  );
};
