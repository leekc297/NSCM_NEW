import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { LEVEL_TITLE, MENU_ID, type LevelNo } from '../capa-line-master.constants';
import type { CapaLineRow } from '../capa-line-master.types';
import { canDrillDown, isCellEditable, isInsertRow } from '../utils/capaLineMaster.editLock';
import { buildColumns } from '../utils/capaLineMasterColumns';

import styles from './CapaLineMasterLevelGrid.module.scss';

interface Props {
  level: LevelNo;
  rows: CapaLineRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // EDIT 버튼 권한(hasButton('EDIT')). 수정 모드 토글 미이식(asis_to_tobe.md §11) — 권한 있으면 상시 편집.
  canEdit: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  // 셀 더블클릭 -> 하위 레벨 재조회(L1~L4). L5 는 호출되지 않는다(design 01 §2 L6).
  onDrillDown: (row: Record<string, unknown>) => void;
  onFocus: () => void;
  // 편집 배타(AS-IS 파리티) — 다른 그리드에 미저장이 있으면 true 반환(+안내). 편집/붙여넣기 시작을 막는다.
  guardEditStart: () => boolean;
}

// Wijmo 는 셀 DOM 을 재사용하므로 조건 미해당 시에도 항상 클래스를 해제한다(hook #95 §1-4).
const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

// AS-IS spdLevel1~5 (FarPoint FpSpread) -> 공용 DataGrid 1개를 레벨 파라미터로 재사용.
//   화면이 직접 담당하는 것은 (a) 행상태 기반 편집잠금(beginningEdit/pastingCell)
//   (b) 편집가능 셀 배경(formatItem, hook #95) (c) 드릴다운 더블클릭 뿐이다.
//   컬럼/셀콤보(VALID_YN=YesOrNo)/좌측 고정열(FIXED_FLAG)은 admin 메타 -> 공용 DataGrid 가 자동 배선한다.
//   AS-IS Freeze(0, GetColumnIndex(앵커)) 는 개수 인자라 앵커 컬럼 자체는 고정 범위 밖이고, 그 앞의
//   숨김 Action 컬럼(AddActionTextBox)만 걸린다 — 5시트 전부 시각적 실효 고정열이 0 이라 admin
//   FIXED_FLAG(전건 '-') 와 이미 일치한다(화면에서 다시 계산할 필요 없음, gap-resolve iter-2 G33).
export const CapaLineMasterLevelGrid = ({
  level,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  canEdit,
  adminColumns,
  onDrillDown,
  onFocus,
  guardEditStart,
}: Props) => {
  const columns = useMemo(() => buildColumns(level, adminColumns), [level, adminColumns]);

  // 셀 콤보 @토큰(@mnuId) 해소 — VALID_YN=YesOrNo. 인용은 getCombo funnel(nscm-patterns §3.3).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 최신 canEdit/rows 를 stale 없이 참조(핸들러는 mount 후 1회 등록, deps 최소화).
  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;
  const rowCountRef = useRef(rows.length);
  rowCountRef.current = rows.length;
  const drillRef = useRef(onDrillDown);
  drillRef.current = onDrillDown;
  const guardEditStartRef = useRef(guardEditStart);
  guardEditStartRef.current = guardEditStart;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // 편집가능 셀 배경(hook #95) — 편집 Yellow, 그 외는 클래스 없음(White). 회색 일괄칠 금지.
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      toggleClass(e.cell, 'wj-cell-editable', isCellEditable(level, binding, row, canEditRef.current));
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    // 편집 게이트(design 03 §3.2 / §5-3) — EDIT 권한 있으면 DUMMY_YN='Y' 행의 자기 NAME(+L5 VALID_YN),
    //   신규행의 자기 ID/NAME(+L5 VALID_YN) 만 해제. 권한 없으면 기존행 전열 읽기전용.
    //   공용 DataGrid 기본 핸들러(INPUT_TP_CD 기반)가 먼저 판정하고 화면이 나중에 최종 재지정한다.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 읽기전용 셀은 조용히 취소한다 — 이 셀 더블클릭은 '드릴 의도'라 배타 안내(MSG01210)를 띄우면 안 된다.
      //   편집가능 판정을 먼저 두어야 배타 가드가 '진짜 편집 시도'(편집가능 셀)에만 걸린다.
      if (!isCellEditable(level, binding, row, canEditRef.current)) {
        e.cancel = true;
        return;
      }
      // 편집 배타(AS-IS 파리티) — 다른 그리드가 미저장이면 편집가능 셀의 편집 시작을 막는다(안내 포함).
      if (guardEditStartRef.current()) {
        e.cancel = true;
        return;
      }
      e.cancel = false;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기도 같은 판정을 통과해야 한다 — AS-IS ClipboardPasted 5건(entryPoints #18~#22)은
    //   LockRange 가 이미 막은 셀에만 작용하지 않으므로, TO-BE 는 pastingCell 에서 동일 게이트를 건다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 읽기전용 셀은 조용히 취소(배타 안내 없이). 붙여넣기도 편집이므로 편집가능 셀에만 배타를 건다.
      if (!isCellEditable(level, binding, row, canEditRef.current)) {
        e.cancel = true;
        return;
      }
      if (guardEditStartRef.current()) e.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    // 드릴다운 — L1~L4 셀 더블클릭 시 하위 레벨 재조회(cs:1743~1814). 가드: L5 제외 / rows 0건.
    //   편집 vs 드릴 구분(AS-IS 재현, 사용자 확정 2026-11-13): AS-IS CellDoubleClick 은 편집모드(Action
    //   컬럼 visible)면 드릴을 억제하고 셀을 편집, 아니면(잠김) 드릴한다(cs:1748~). TO-BE 는 편집모드 토글이
    //   없으니 셀 편집가능 여부로 가른다 — 편집가능 셀(노란 셀) 더블클릭 = 편집(드릴 X, 편집기 유지),
    //   읽기전용 셀 = 드릴. 편집기가 셀을 덮어 hitTest 가 Cell 이 아니면 활성 셀(selection)로 보정해 판정한다.
    const dblClickHandler = (ev: MouseEvent) => {
      if (!canDrillDown(level, rowCountRef.current)) return;
      const hit = grid.hitTest(ev);
      const isCell = hit.cellType === CellType.Cell;
      const rowIndex = isCell ? hit.row : (grid.selection?.row ?? -1);
      const colIndex = isCell ? hit.col : (grid.selection?.col ?? -1);
      if (rowIndex < 0) return;
      const row = GridUtils.getRow(grid, rowIndex) as Record<string, unknown> | undefined;
      if (!row) return;
      // 편집가능 셀 더블클릭 = 편집 의도 → 드릴하지 않는다(편집기는 그대로 둔다). AS-IS 편집모드 셀과 동형.
      const binding = colIndex >= 0 ? (grid.columns[colIndex]?.binding ?? '') : '';
      if (isCellEditable(level, binding, row, canEditRef.current)) return;
      // 신규행('I')은 자기 레벨 ID 가 빈 값이라 드릴다운하면 빈 키로 하위를 조회한다 — 무동작으로 막는다
      //   (신규행 드릴 억제 의도 유지, 사용자 확정 2026-11-06).
      if (isInsertRow(row)) return;
      if (grid.activeEditor) grid.finishEditing(true);
      drillRef.current(row);
    };
    grid.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <div className={styles.levelGrid}>
      {/* AS-IS FpSpread 시트 탭(VisibleTab(true), cs:251/270/290/312/338) 의 레벨 표기 대응 캡션. */}
      <div className={styles.levelCaption}>{LEVEL_TITLE[level]}</div>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={columns}
        comboParams={comboParams}
        gotFocus={onFocus}
      />
    </div>
  );
};
