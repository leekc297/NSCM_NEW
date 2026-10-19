import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BUCKET_TYPE, MENU_ID } from '../shipment-plan.constants';
import type { CalendarRow, MainRow } from '../shipment-plan.types';
import { useShipmentPlanStore } from '../useShipmentPlanStore';
import { calcPlanQty, type CalcRow } from '../utils/shipment-plan.calc';
import { isMainCellEditable } from '../utils/shipment-plan.editLock';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // Main 편집 가능 여부 = canEdit(hasButton('EDIT'))·최신Plan(realFlag). 셀 단위 범위는 isMainCellEditable.
  //   AS-IS EditButton 토글 미이식(convert-core §2.4) — 편집 기본 ON, 권한은 마운트 1회 판정.
  editable: boolean;
  curPlanDate: string;
  // Main 셀/BOH_QTY 더블클릭 드릴다운 (03 §3-D) — 페이지가 sheet 전환 + Detail 재조회
  onDrilldown: (row: MainRow, binding: string) => void;
  // 활성 그리드 sticky 전환용 (01 R5 — Main 클릭 시 복귀 핸들러는 배선하지 않는다)
  onCellEdited?: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_') ? 'D' : binding.startsWith('W_') ? 'W' : binding.startsWith('M_') ? 'M' : undefined;

// Bucket/chkSum 표시규칙 (design 03 §2.3 표 그대로)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M'; // Monthly — M_ 항상, D_/W_ 숨김(chkSum 무관)
};

// Main(PSI) 그리드 — base 18컬럼(admin 메타) + D_/W_/M_ 동적(서버 wide pivot + calendar 3단 헤더).
//   편집 표면은 동적 D_ 셀만(Edit 모드 + SHIP_PLAN_DETAIL 행 + curPlanDate~CONFIRM_DAY 창 — 03 §3-F).
//   W_/M_(Sum) 컬럼은 항상 잠금(03 §2.3). 병합 = base 전 컬럼(AS-IS 메타 구동 FPMerge.Restricted,
//   framework SpreadInfo.cs:1295 + SmartColMerge) + Always 6컬럼(L651~656)은 그 부분집합 — 동적
//   D_/W_/M_ 만 병합 제외(FPMerge.None 재현, gap-audit I4).
export const ShipmentPlanMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  chkSum,
  editable,
  curPlanDate,
  onDrilldown,
  onCellEdited,
}: Props) => {
  const columns = adminColumns ?? [];

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback (forecast-price 패턴)
  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!kindOf(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => ({
          binding: str(r.COLUMN_NAME),
          kind: kindOf(str(r.COLUMN_NAME)) as DynKind,
          large: str(r.LARGE_CLASS_LABEL_NAME),
          small: str(r.SMALL_CLASS_LABEL_NAME),
          leaf: str(r.COLUMN_LABEL_NAME),
          dayCode: str(r.DAY_CODE),
          sort: str(r.SORT_ORDER_NO),
        }))
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (kindOf(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => ({
      binding: b,
      kind: kindOf(b) as DynKind,
      large: b.slice(2, 8),
      small: '',
      leaf: b.slice(8),
      dayCode: '',
      sort: b,
    }));
  }, [calendar, rows]);

  // D_ 일자 binding 오름차순 — CalcPlanQty 전파/저장 diff 의 축
  const dayBindings = useMemo(
    () => dynColMetas.filter(m => m.kind === 'D').map(m => m.binding).sort(),
    [dynColMetas]
  );
  const dayBindingsRef = useRef(dayBindings);
  dayBindingsRef.current = dayBindings;

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (03 §2.2)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      const code = meta.dayCode.toUpperCase();
      if (meta.kind !== 'D') return;
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일 — forecast-price dynamicColumns 패턴 축약)
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2 };
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf || 'SUM' : 'SUM',
        align: 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSum),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
    const leafKind = (b: string): DynKind => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            allowSorting: false,
            allowMerging: false,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas, bucketType, chkSum]);

  // 활성 그리드 전환 — 프레임워크 parity(BaseForm.FpSpread_CellClick 무조건 전환) 배선용
  const setActiveGrid = useShipmentPlanStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;

  const editableRef = useRef(editable);
  editableRef.current = editable;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const rowsRef = useRef(rows);
  rowsRef.current = rows;
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;
  const onCellEditedRef = useRef(onCellEdited);
  onCellEditedRef.current = onCellEdited;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 병합 — base 전 컬럼 허용(FPMerge.Restricted 등가, I4) / 동적 D_/W_/M_ 만 제외(FPMerge.None).
    //   wrapper 는 allowMerging prop 이 켜지면 전 컬럼 true 를 씌우므로 동적 컬럼만 도로 false.
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !kindOf(binding);
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    // 편집 잠금 — beginningEdit(e.cancel) + formatItem(편집가능 Yellow, hook #95)
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      // 헤더 토/일 색 (03 §2.2)
      if (e.panel === sender.columnHeaders) {
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const editable = isMainCellEditable(
        row,
        binding,
        editableRef.current,
        curPlanDateRef.current
      );
      e.cell.style.backgroundColor = editable ? '#FFFDE7' : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 (I1 — memory datagrid-paste-editability-pastingcell-gap):
    //   wrapper 의 pastingCell 은 _inputEditType 만 보므로 OPTIONAL 인 동적 셀 전체가 열린다.
    //   동적(D_/W_/M_) 컬럼은 편집창 판정으로 verdict 를 덮어쓴다(wijmo Event 는 등록 순서 호출 —
    //   화면 핸들러가 wrapper 뒤에 실행되어 최종 판정이 된다). base 컬럼은 wrapper 판정('S' 차단) 유지.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집/붙여넣기 반영 — CalcPlanQty 5산식 전파 (03 §3-A. EditTracker 'M' 마킹은 wrapper 가 수행.
    //   붙여넣기도 AS-IS SpdMain_ClipboardPasted(L994~1029)가 EditByChange 로 동일 재계산)
    const recalcCell = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!binding.startsWith('D_')) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const changes = calcPlanQty(
        rowsRef.current as unknown as CalcRow[],
        dayBindingsRef.current,
        row as CalcRow,
        binding
      );
      if (changes.length > 0) sender.collectionView?.refresh();
      onCellEditedRef.current?.();
    };
    g.cellEditEnded.addHandler(recalcCell);
    g.pastedCell.addHandler(recalcCell);

    // Delete 키 (I1 — AS-IS spdMain_KeyUp L2462~2521: 선택 범위의 D_ 셀 "0" 세팅 + EditByChange).
    //   wijmo 기본 Delete(_deleteRange)는 isRequired 만 보고 편집게이트를 안 타므로 캡처 단계에서
    //   가로채 편집가능(isMainCellEditable) D_ 셀만 0 세팅 + EditTracker 기록 + 재계산으로 재현한다.
    //   주의: AS-IS KeyUp 은 잠금 여부를 안 보지만(락 무시 SetValue) 저장 게이트(IsLock)와 결합하면
    //   편집모드 셀만 저장에 도달 — TO-BE 는 gap-audit I1 expect 대로 편집가능 셀 한정으로 재현.
    const deleteKeyHandler = (ev: KeyboardEvent) => {
      if (ev.key !== 'Delete' || ev.altKey || ev.ctrlKey || ev.metaKey || ev.shiftKey) return;
      if (g.activeEditor) return; // 셀 편집기 열림 — 문자 삭제 기본 동작 유지
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      ev.preventDefault();
      ev.stopPropagation();
      const tracker = editTrackerRef.current;
      const touched: { row: Record<string, unknown>; binding: string }[] = [];
      for (let r = sel.topRow; r <= sel.bottomRow; r += 1) {
        const row = GridUtils.getRow(g, r) as Record<string, unknown> | undefined;
        if (!row) continue;
        for (let c = sel.leftCol; c <= sel.rightCol; c += 1) {
          const binding = g.columns[c]?.binding ?? '';
          if (!binding.startsWith('D_')) continue;
          if (!isMainCellEditable(row, binding, editableRef.current, curPlanDateRef.current))
            continue;
          const original = row[binding] as WijmoPrimitive;
          if (Number(original ?? 0) === 0) continue;
          row[binding] = 0;
          tracker?.storeChange(row as WijmoRowItem, binding, original, 0);
          touched.push({ row, binding });
        }
      }
      if (touched.length > 0) {
        // AS-IS 는 셀마다 EditByChange → CalcPlanQty — 셀 단위로 동일 재현(그룹 다수 선택 대응)
        touched.forEach(({ row, binding }) =>
          calcPlanQty(
            rowsRef.current as unknown as CalcRow[],
            dayBindingsRef.current,
            row as CalcRow,
            binding
          )
        );
        g.collectionView?.refresh();
      }
    };
    g.hostElement.addEventListener('keydown', deleteKeyHandler, true);

    // 더블클릭 — BOH_QTY(BOH_TYPE 분기) / 데이터 셀(MEASURE 분기, AS-IS e.Column>=FCST_TYPE+1 이라
    //   D_ 뿐 아니라 W_/M_ Sum 셀도 대상 — gap-audit I10) 드릴다운 (03 §3-D)
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'BOH_QTY' && !kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row, binding);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 활성 그리드 전환 — AS-IS 프레임워크 BaseForm.FpSpread_CellClick(L2303~2305)이 모든 스프레드
    //   클릭에서 fps 를 무조건 전환한다(설계 01 R5 의 "sticky·복귀 없음"은 화면 코드만 본 판정 —
    //   iter-2 프레임워크 실측으로 정정, __asis-mapping__ 참조). Main 클릭 시 'main' 복귀 배선.
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(recalcCell);
        g.pastedCell?.removeHandler(recalcCell);
        g.hostElement?.removeEventListener('keydown', deleteKeyHandler, true);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      allowMerging={AllowMerging.Cells}
    />
  );
};
