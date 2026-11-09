import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { LEVEL_TITLE, MENU_ID, type LevelNo } from '../capa-line-master.constants';
import type { CapaLineRow } from '../capa-line-master.types';
import { canDrillDown, isCellEditable } from '../utils/capaLineMaster.editLock';
import { buildColumns } from '../utils/capaLineMasterColumns';

import styles from './CapaLineMasterLevelGrid.module.scss';

interface Props {
  level: LevelNo;
  rows: CapaLineRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  // 현재 편집모드인 레벨(없으면 null). 5그리드 중 동시 1개만 — design 01 §2.1.
  editingLevel: LevelNo | null;
  adminColumns?: RawFlexGridColumnConfig[];
  // 셀 더블클릭 -> 하위 레벨 재조회(L1~L4). L5 는 호출되지 않는다(design 01 §2 L6).
  onDrillDown: (row: Record<string, unknown>) => void;
  onFocus: () => void;
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
  editingLevel,
  adminColumns,
  onDrillDown,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(level, adminColumns), [level, adminColumns]);

  // 셀 콤보 @토큰(@mnuId) 해소 — VALID_YN=YesOrNo. 인용은 getCombo funnel(nscm-patterns §3.3).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 최신 editingLevel/rows 를 stale 없이 참조(핸들러는 mount 후 1회 등록, deps 최소화).
  const editingLevelRef = useRef(editingLevel);
  editingLevelRef.current = editingLevel;
  const rowCountRef = useRef(rows.length);
  rowCountRef.current = rows.length;
  const drillRef = useRef(onDrillDown);
  drillRef.current = onDrillDown;

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
      toggleClass(
        e.cell,
        'wj-cell-editable',
        isCellEditable(level, binding, row, editingLevelRef.current)
      );
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    // 편집 게이트(design 03 §3.2 / §5-3) — 조회 직후 전열 읽기전용, 편집모드 + DUMMY_YN='Y' 행의
    //   자기 NAME(+L5 VALID_YN), 신규행의 자기 ID/NAME(+L5 VALID_YN) 만 해제.
    //   공용 DataGrid 기본 핸들러(INPUT_TP_CD 기반)가 먼저 판정하고 화면이 나중에 최종 재지정한다.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !isCellEditable(level, binding, row, editingLevelRef.current);
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
      if (!isCellEditable(level, binding, row, editingLevelRef.current)) e.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    // 드릴다운 — L1~L4 셀 더블클릭 시 하위 레벨 재조회(cs:1743~1814).
    //   가드: L5 제외 / rows 0건 / 해당 레벨 편집중(AS-IS Action 컬럼 visible 판정).
    const dblClickHandler = (ev: MouseEvent) => {
      const hit = grid.hitTest(ev);
      if (hit.cellType !== CellType.Cell) return;
      if (!canDrillDown(level, rowCountRef.current, editingLevelRef.current)) return;
      const row = GridUtils.getRow(grid, hit.row) as Record<string, unknown> | undefined;
      if (!row) return;
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
