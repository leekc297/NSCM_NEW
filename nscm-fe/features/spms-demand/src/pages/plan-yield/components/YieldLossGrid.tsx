import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, CellType, HeadersVisibility } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  type MutableRefObject,
  type Ref,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';

import { toText } from '../../../lib/call-proc';
import {
  DataGrid,
  isCheckToggleable,
  keepMergeColumnsByMeta,
  nextCheckState,
  refreshLayoutOnHostResize,
  renderCheckboxCell,
} from '../../../lib/grid';
import { MERGE_ATTR, YIELD_UOM_BINDING } from '../plan-yield.constants';
import type { YieldRow } from '../plan-yield.types';
import { formatYieldValue, isGroupRow, isYieldCellEditable } from '../utils/plan-yield.editLock';

import styles from './YieldLossGrid.module.scss';

// ⭐ SDM2020 [2. 수율/Loss 계획 점검] 그리드 — 설계서 GRID RIGHT 시트. admin 메타 100% 주도.
//   - 세로 병합 = 메타 ATTRIBUTE1='MERGE' 컬럼(법인/버전/공정/Level 1/항목 — 계층 병합 CustomMergeManager)
//   - 인자 그룹 헤더행(IS_GROUP='Y') = 회색·편집 불가·값 없음 / 조건행 = 인자 컬럼 들여쓰기(ATTRIBUTE1='FACTOR')
//   - 선택(FPCheckBox) = 서버 문자열 CHECKED/UNCHECKED/NONE 렌더 + 클릭 토글(NONE·그룹행 잠금)
//   - Delta(FPNumber 메타) = 행 UOM 기준 표기('[%]' → 95.0% / 그 외 천단위) — 편집값은 원시값
//   - 편집 = INPUT_TP_CD 메타(Delta (조정)·비고) × 행 축(그룹행 잠금) — 색과 판정은 같은 함수

const FACTOR_ATTR = 'FACTOR';

interface Props {
  rows: YieldRow[];
  gridRef: Ref<FlexGridType<YieldRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  staticColumns?: RawFlexGridColumnConfig[];
  /** 확정 권한(hasButton CONFIRM) — 없으면 전 셀 조회 전용 */
  canEdit: boolean;
}

export const YieldLossGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  canEdit,
}: Props) => {
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );

  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));
  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  // ⭐ RequestPlantPanel 과 동일 처방 — gridRef.current 직접 참조 effect 는 그리드 미준비 시 조용히 bail 해
  //   핸들러가 등록되지 않는다. initialized 를 state 로 받아 등록 effect 를 그 뒤에 태운다.
  const [gridControl, setGridControl] = useState<FlexGridType<YieldRow> | null>(null);
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    setGridControl(grid as FlexGridType<YieldRow>);
  }, []);

  // ⭐ 레이아웃 재계산 옵저버 — 그리드 인스턴스당 1회만 붙인다 (deps 는 gridControl 뿐).
  //   메타/콤보 변경 effect 에 얹으면 옵저버가 재생성되면서 그 순간의 크기 변화를 놓쳐,
  //   "어떤 때는 클릭이 되고 어떤 때는 안 되는" 경쟁 조건이 된다 (2026-09-04).
  useEffect(() => {
    const g = gridControl;
    if (!g?.hostElement?.isConnected) return;
    return refreshLayoutOnHostResize(g as FlexGridType);
  }, [gridControl]);

  useEffect(() => {
    const g = gridControl;
    if (!g || !g.hostElement?.isConnected || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 0) g.alternatingRowStep = 0; // 병합 그리드 — zebra 충돌 방지
    const detachMerge = keepMergeColumnsByMeta(
      g as FlexGridType,
      binding => colMetaRef.current.get(binding)?.attribute1 === MERGE_ATTR
    );

    const formatHandler = (_s: FlexGridType<YieldRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      const rowItem = g.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!meta || !rowItem) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      const groupRow = isGroupRow(rowItem);
      e.cell.classList.toggle(styles.groupRow, groupRow);
      e.cell.classList.toggle(styles.factorIndent, !groupRow && meta.attribute1 === FACTOR_ATTR);

      const isEditing = g.editRange?.contains(e.row, e.col) ?? false;
      if (isEditing) return; // 편집기 <input> 보호 (DMF0044 계보)

      if (ctrlType === 'FPCheckBox') {
        if (groupRow) {
          e.cell.textContent = '';
          e.cell.classList.remove('wj-cell-editable');
          return;
        }
        const v = toText(rowItem[binding]);
        const enabled = canEditRef.current && isCheckToggleable(v);
        if (isCheckToggleable(v)) {
          renderCheckboxCell(e.cell, v, { className: styles.checkbox, enabled });
        } else {
          e.cell.textContent = ''; // NONE — 체크 없음 (목업: 선택 칸 빈 행)
        }
        e.cell.classList.toggle('wj-cell-editable', enabled);
        return;
      }

      // Delta 표기 — 행 UOM 기준 (FPNumber 메타 컬럼)
      if (ctrlType === 'FPNumber') {
        const text = formatYieldValue(rowItem[binding], rowItem[YIELD_UOM_BINDING]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
      }

      // ⭐ 편집 색 — 편집 게이트와 같은 함수 (isYieldCellEditable)
      const editable = canEditRef.current && isYieldCellEditable(meta.inputTpCd, ctrlType, rowItem);
      e.cell.classList.toggle('wj-cell-editable', editable);
    };
    g.formatItem.addHandler(formatHandler);

    const beginningEditHandler = (
      s: FlexGridType<YieldRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta) return;
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      const row = s.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !(canEditRef.current && isYieldCellEditable(meta.inputTpCd, ctrlType, row));
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 클릭 — 선택 체크 토글 (행 단건 — CHECKED/UNCHECKED 2값만, 그룹행·NONE 잠금) + 'M' 마킹
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if (!meta || (meta.cellCtrlObjTpCd as unknown as string) !== 'FPCheckBox') return;
      if (!canEditRef.current) return;
      const row = g.rows[ht.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || isGroupRow(row)) return;
      const current = toText(row[binding]);
      if (!isCheckToggleable(current)) return;
      const next = nextCheckState(current);
      editTrackerRef?.current?.storeChange(row as never, binding, current as never, next as never);
      row[binding] = next;
      g.invalidate();
    };
    g.hostElement.addEventListener('click', clickHandler);

    const cornerHandler = (_s: FlexGridType<YieldRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.TopLeft) return;
      e.cell.style.textAlign = 'center';
    };
    g.formatItem.addHandler(cornerHandler);

    g.invalidate(true);

    return () => {
      try {
        detachMerge();
        g.formatItem?.removeHandler(formatHandler);
        g.formatItem?.removeHandler(cornerHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridControl, visibleColumns]);

  // ⭐ 컬럼 메타가 온 뒤에 그리드를 만든다 — 0 컬럼으로 먼저 만들면 메타 도착 시 key 가 바뀌며
  //   그 그리드가 폐기되는데, 폐기 시점에 예약돼 있던 wijmo refresh 가 뒤늦게 돌아 `finishEditing`
  //   널 참조로 터진다. 이 예외가 wijmo 공용 refresh 큐를 끊어 같은 큐에 있던 다른 그리드의 레이아웃
  //   계산까지 중단시키고, 그 그리드는 hitTest 가 cellType=None/row=-1 을 돌려 셀 클릭이 죽는다
  //   (SDM2020 요청법인 그리드에서 실측 — RequestPlantPanel 같은 처방, 2026-09-04).
  if (visibleColumns.length === 0) return null;

  return (
    <DataGrid
      key={visibleColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      initialized={handleGridInitialized}
      staticColumns={visibleColumns}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowSorting={false}
      allowMerging={AllowMerging.All}
      headersVisibility={HeadersVisibility.Column} // No./상태(I·M·D) rowHeader 숨김 (요청법인 패널 동일)
    />
  );
};
