import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BUCKET_TYPE, MENU_ID } from '../shipment-plan-auto-ess.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-auto-ess.types';
import { useShipmentPlanAutoEssStore, type MeasureMeta } from '../useShipmentPlanAutoEssStore';
import { createSameCellDblClickGuard } from '../utils/shipment-plan-auto-ess.dblClickGuard';
import { isMainCellEditable } from '../utils/shipment-plan-auto-ess.editLock';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // admin SCM_MST_SHEET_MEASURE — measure 세로축 표시/개인화 원천(CLAUDE.md §2 체크3).
  staticMeasures: MeasureMeta[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // **현재는 항상 false** — 이 그리드는 조회전용이다(AS-IS EditButton cs L2370~2375 가 spdMain 을
  //   MSG00109 '읽기 전용입니다' 로 무조건 차단, 2023-10-04 jilee). 페이지가 `mainEditable = false`
  //   를 고정으로 넘긴다. prop·판정 함수(isMainCellEditable)·편집 핸들러는 되살릴 여지를 남겨 둔
  //   방어선으로만 유지한다 — AS-IS 차단이 풀리면 여기만 다시 열면 된다.
  editable: boolean;
  curPlanDate: string;
  // Main 셀/BOH_QTY 더블클릭 드릴다운 (design 03 §3.7) — 페이지가 sheet 전환 + Detail 재조회
  onDrilldown: (row: MainRow, binding: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_')
    ? 'D'
    : binding.startsWith('W_')
      ? 'W'
      : binding.startsWith('M_')
        ? 'M'
        : undefined;

// 3단(월>주/SUM>일) 동적 헤더의 행 높이 — GRID-11: nested columns 에 height 를 안 적으면 Wijmo 기본
//   48px 이 단마다 적용돼 헤더가 48x3=144px 로 부풀고(AS-IS FarPoint 는 20px x3 ~= 60px), base 컬럼의
//   세로 span 도 그 높이에 끌려간다. 공용 컬럼매핑의 depth 별 높이(ONE 48 / TWO 24 / THREE 16)와 같은
//   값을 동적 group·leaf 에 명시해 총 48px(= 정적 ONE_DEPTH 1행 높이)로 맞춘다 — hook #93 표준.
//   자매 SSP0060 과 동일 처방(같은 3단 캘린더 헤더 구조라 같은 결함을 그대로 갖고 있었다).
const DYN_HEADER_ROW_HEIGHT = 16;

// Main 헤더 총높이(px) — 공용 1단 표준(HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH)과 같은 값.
//   정적 base 컬럼이 ONE_DEPTH 라 공용 매핑이 거기에 height:48 을 박고, 그 명시값이 동적 3단의
//   height:16 과 `rows.defaultSize` 를 모두 이긴다 → 조회 후 헤더가 48x3 으로 벌어진다.
//   실제 렌더된 tier 수로 나눠 헤더 row 높이를 직접 강제한다(선례 CustFcstWaterfallGrid).
const MAIN_HEADER_HEIGHT = 48;

// SHIP_PLAN 행 구분색 — AS-IS Re_Design(cs L4778) `Color.FromArgb(80, Color.LightSkyBlue)`.
//   LightSkyBlue = rgb(135,206,250), 알파 80/255 ≈ 0.314 → 흰 배경 위에서 옅은 하늘색.
const SHIP_PLAN_MEASURE = 'SHIP_PLAN';
const SHIP_PLAN_ROW_COLOR = 'rgba(135, 206, 250, 0.314)';

// Bucket/chkSum 표시규칙 (design 03 §2.2 표 그대로)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M'; // Monthly — M_ 항상, D_/W_ 숨김(chkSum 무관)
};

// Main(PSI) 그리드 — base 13컬럼(admin 메타) + D_/W_/M_ 동적(서버 wide pivot + calendar 3단 헤더).
//   **조회전용 그리드**다(DataGrid isReadOnly) — AS-IS EditButton 이 spdMain 편집을 무조건 차단한다.
//   그래서 편집가능 노랑(#FFFDE7)도 칠하지 않는다. 셀 배경은 SHIP_PLAN 행 구분색만 쓴다.
//   design 03 §1.2/§2.3 의 "동적 D_ 셀 편집 + Simulation 재계산" 기술은 2023-10 차단 이전 기준이다.
//   병합 = base 전 컬럼(FPMerge/SmartColMerge) + 동적 D_/W_/M_ 만 병합 제외(design 03 §3.5).
export const ShipmentPlanAutoEssMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  staticMeasures,
  bucketType,
  chkSum,
  editable,
  curPlanDate,
  onDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];

  // measure 세로축 표시 게이트 (design 03 §1.2 — admin SCM_MST_SHEET_MEASURE display 플래그).
  //   서버 순서(item 그룹 유지)는 보존하고 display=false measure 행만 숨긴다 — 전역 재정렬은 item 그룹을
  //   흩뜨리므로 하지 않는다. 메타가 비었거나 measure 가 메타에 없으면 노출(회귀 0 fallback).
  const hiddenMeasures = useMemo(() => {
    const s = new Set<string>();
    staticMeasures.forEach(m => {
      if (m.display === false) s.add(m.colNm);
    });
    return s;
  }, [staticMeasures]);
  const visibleRows = useMemo(
    () => (hiddenMeasures.size === 0 ? rows : rows.filter(r => !hiddenMeasures.has(str(r.MEASURE)))),
    [rows, hiddenMeasures]
  );

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback
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

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (design 03 §2.1)
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

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일)
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<
      string,
      { label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
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
        height: DYN_HEADER_ROW_HEIGHT,
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
        height: DYN_HEADER_ROW_HEIGHT,
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: DYN_HEADER_ROW_HEIGHT,
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

  const setActiveGrid = useShipmentPlanAutoEssStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;

  const editableRef = useRef(editable);
  editableRef.current = editable;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 더블클릭 판정기 — 수명이 아래 click/dblclick 리스너와 같아야 하므로 effect 안에서 만든다.
    const dblClickGuard = createSameCellDblClickGuard();

    // 병합 — base 전 컬럼 허용(FPMerge 등가) / 동적 D_/W_/M_ 만 제외(design 03 §3.5).
    //   주의: 이 플래그는 **셀** 병합만 가른다 — 헤더 병합은 그리드 레벨 allowMerging(=All)이 결정한다.
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !kindOf(binding);
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    // 헤더 총높이 고정 — 정적 ONE_DEPTH 의 명시 height(48)가 동적 16 과 defaultSize 를 모두 이겨
    //   조회 후 48x3 으로 벌어지는 것을 실제 tier 수로 나눠 되돌린다(자매 SSP0060 과 동일 처방,
    //   선례 CustFcstWaterfallGrid). 목표값과 같으면 skip → updatedLayout 무한 루프 방지.
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = MAIN_HEADER_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    // 편집 잠금(방어선) — isReadOnly 로 이미 막히지만 판정 경로를 남겨 둔다.
    //   formatItem 은 헤더 토/일 색 + SHIP_PLAN 행 구분색만 담당한다(편집색 없음).
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
      if (e.panel === sender.columnHeaders) {
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      // 편집가능 노랑(#FFFDE7)은 칠하지 않는다 — 이 그리드는 조회전용이다(AS-IS EditButton
      //   L2370~2375 무조건 차단, 페이지가 editable={false} + DataGrid isReadOnly).
      //   편집 표면이 없는데 편집색을 남기면 "여기는 고칠 수 있다"는 잘못된 어포던스가 된다.
      // SHIP_PLAN 행 구분색 — AS-IS Re_Design(cs L4773~4780):
      //   `range1 = Cells[i, MEASURE+1, i, ColumnCount-1]; range1.BackColor = FromArgb(80, LightSkyBlue);`
      //   = MEASURE 다음 칸부터 끝까지(= 동적 D_/W_/M_ 전부) LightSkyBlue 를 알파 80/255 로 덮는다.
      //   AS-IS 캡처에서도 'Shipment Plan' 행만 옅은 하늘색으로 구분된다(사용자 제공 2026-10-12).
      //   필수: 비해당 셀은 명시적으로 비워야 한다 — Wijmo 가 셀 DOM 을 재사용해 스크롤 시 잔상이 남는다.
      e.cell.style.backgroundColor =
        kindOf(binding) && str(row?.MEASURE) === SHIP_PLAN_MEASURE ? SHIP_PLAN_ROW_COLOR : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 — OPTIONAL 인 동적 셀 전체가 열리므로 편집창 판정으로 verdict 를 덮어쓴다.
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

    // Delete 키 (AS-IS spdMain_KeyUp 등가 — 편집가능 D_ 셀 "0" 세팅 + EditTracker 기록).
    //   재계산은 Simulation 버튼에서만(design 03 §2.3) — 여기서는 값 세팅·마킹만.
    const deleteKeyHandler = (ev: KeyboardEvent) => {
      if (ev.key !== 'Delete' || ev.altKey || ev.ctrlKey || ev.metaKey || ev.shiftKey) return;
      if (g.activeEditor) return;
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      ev.preventDefault();
      ev.stopPropagation();
      const tracker = editTrackerRef.current;
      let touched = 0;
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
          touched += 1;
        }
      }
      if (touched > 0) g.collectionView?.refresh();
    };
    g.hostElement.addEventListener('keydown', deleteKeyHandler, true);

    // 더블클릭 — BOH_QTY(BOH_TYPE 분기) / 데이터 셀(MEASURE 분기) 드릴다운 (design 03 §3.7)
    //   가드: 직전 두 클릭이 **같은 셀**일 때만 더블클릭으로 인정한다(AS-IS FarPoint
    //   CellDoubleClick 등가). 셀을 바꿔 가며 연속 클릭하면 브라우저가 dblclick 을 두 셀의 최근접
    //   공통 조상(= hostElement)에 디스패치해 드릴다운 조회가 나가던 것을 막는다
    //   (utils/shipment-plan-auto-ess.dblClickGuard.ts 주석에 근거).
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if (!dblClickGuard.accepts({ row: ht.row, col: ht.col })) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'BOH_QTY' && !kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row, binding);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 활성 그리드 전환 (AS-IS 프레임워크 클릭 전환 등가) — Main 클릭 시 'main' 복귀
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 필수: early return 보다 먼저 기록한다 — 헤더·빈 영역 클릭을 null 로 남겨야
      //   "헤더 클릭 -> 셀 클릭" 이 같은 셀 2회로 오인되지 않는다.
      const isCell = ht.cellType === CellType.Cell;
      dblClickGuard.track(isCell ? { row: ht.row, col: ht.col } : null);
      if (!isCell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.updatedLayout?.removeHandler(applyHeaderHeight);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
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
      itemsSource={visibleRows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // All = 셀 + 컬럼헤더 병합. Cells 단독이면 공용 매니저의 헤더 병합 분기가 통째로 꺼져
      //   (`_getColumnHeaderMergedRange` 가 All/AllHeaders/ColumnHeaders 일 때만 동작) base 컬럼이
      //   동적 3단 헤더를 세로로 못 덮고 같은 글자가 칸칸이 갈라진다 — AS-IS 는 ColumnHeaderSpan 으로
      //   같은 내용을 한 칸으로 묶는다. Doc/new_rules GRID-11 금지 항목("AllowMerging.Cells 단독으로
      //   헤더 머지 풀림")이고 자매 3단 화면(SSP0060·global-psi-elec 등)은 전부 All 이다.
      //   셀 병합 범위는 위 applyMerge 의 컬럼별 allowMerging 이 그대로 가른다(동적 컬럼 제외 유지).
      allowMerging={AllowMerging.All}
      // 조회전용 — AS-IS EditButton(cs L2370~2375)이 spdMain 편집을 무조건 차단한다(MSG00109).
      //   공용 DataGrid 의 isReadOnly 는 셀 편집 진입을 막고 rowHeaders 의 CRUD 마커 컬럼도 빼
      //   "수정 가능한 그리드" 어포던스를 없앤다(조회전용 자매 화면 공통 규약 — shipment-change-history
      //   ·shipment-change-request-confirm ·delegate 등). Detail 그리드는 편집 가능하므로 대상 아님.
      isReadOnly
    />
  );
};
