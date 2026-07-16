import { type FlexGrid, AllowMerging, CellType, SelectionMode } from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { EditTracker, isNonEditableDateColumn } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { AUTH_MEASURES } from '../forecast-price.constants';
import type { ForecastPriceRow, SpreadTitleRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';

import {
  allocateLoc,
  divideByDate,
  divideByMonth,
  divideByWeek,
  isNonEditableCell,
  toNumber,
} from './ForecastPriceGridUtils';

interface ForecastPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<ForecastPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ForecastPriceRow[];
  spreadTitle: SpreadTitleRow[];
  editTrackerRef: MutableRefObject<EditTracker | null>;
}

interface DynColMeta {
  binding: string;
  kind: 'M' | 'W' | 'D';
  large: string; // 1단 = 년월 (LARGE_CLASS_LABEL_NAME)
  small: string; // 2단 = 주차 (SMALL_CLASS_LABEL_NAME)
  leaf: string; // 3단 = 일자 (COLUMN_LABEL_NAME)
  sort: number;
}

const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;

// 표시 rank (M=0 상위 합계 … D=2 하위 상세). 활성 bucket = 데이터에 존재하는 최정밀 kind(max rank).
//   상위(rank<활성) = SUM 합계 컬럼 → chkSum(sumYn) 으로 표시 토글 (AS-IS chkSum / mkt-fcst 패턴 #92).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// ⭐ DMF0082 메인 그리드 — AS-IS spdMain(FCST 행 + PRICE 행 병렬 단일 시트) 1:1.
//   동적 시간축 = DMF0082_GET_SPREAD_TITLE (월>주>일 3단, mkt-fcst 패턴 이식) /
//   편집 = 권한 4분기(measureAuth, GET drop3) × 행 EDIT_FLAG × bucket × 기준주차 이전 잠금 /
//   배분 = 월간→주간→일별 자동 (ForecastPriceGridUtils — AS-IS EditChange 분배 로직).
export const ForecastPriceGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
  editTrackerRef,
}: ForecastPriceGridProps) => {
  const monthMap = useRef<Map<string, Set<string>>>(new Map());
  const weekMap = useRef<Map<string, Set<string>>>(new Map());
  const bucketRef = useRef<string>('W');

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const measureAuthRef = useRef(measureAuth);
  measureAuthRef.current = measureAuth;

  // ── 동적 컬럼 메타 (SPREAD_TITLE 우선 / 0건 시 data row 키 union fallback — mkt-fcst 패턴) ──
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => !!kindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: kindOf(String(r.COLUMN_NAME)) as DynColMeta['kind'],
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!data || data.length === 0) return [];
    const set = new Set<string>();
    for (const r of data) {
      for (const k of Object.keys(r)) {
        if (kindOf(k)) set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      kind: kindOf(b) as DynColMeta['kind'],
      large: `${b.slice(2, 6)}-${b.slice(6, 8)}`,
      small: '',
      leaf: b.slice(8),
      sort: 0,
    }));
  }, [spreadTitle, data]);

  // ── 활성 bucket / 요약(상위 합계) / 드릴(하위 상세) 분류 (#93 height / #92 sum + 드릴다운, mkt-fcst 패턴) ──
  //   활성 = 조회 bucketType (데이터 최정밀 아님 — Weekly 조회 시 D_ 존재해도 활성=W).
  //   상위(rank<활성) = SUM 합계 → chkSum(sumYn) 토글 / 하위(rank>활성) = 기본 숨김 → 헤더 더블클릭 드릴.
  //   tierH = 3단(D 존재)16 / 2단 24 (총 48px 고정, #93).
  const bucketPrefix = (searchParams.bucketType || 'W').trim().charAt(0).toUpperCase() as 'M' | 'W' | 'D';
  const { hasDaily, tierH, summaryBindings, drillBindings, dynBindings } = useMemo(() => {
    const daily = dynColMetas.some(m => m.kind === 'D');
    const active = DYN_RANK[bucketPrefix] ?? DYN_RANK.W;
    return {
      hasDaily: daily,
      tierH: daily ? 16 : 24,
      summaryBindings: dynColMetas.filter(m => DYN_RANK[m.kind] < active).map(m => m.binding),
      drillBindings: dynColMetas.filter(m => DYN_RANK[m.kind] > active).map(m => m.binding),
      dynBindings: dynColMetas.map(m => m.binding),
    };
  }, [dynColMetas, bucketPrefix]);
  // 드릴 오버라이드(binding→visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // ── monthMap(M_→W_ set) / weekMap(W_→D_ set) — 배분 로직 입력 (SPREAD_TITLE 관계 기반) ──
  useEffect(() => {
    const mm = new Map<string, Set<string>>();
    const wm = new Map<string, Set<string>>();
    // 주차 키: 같은 (large, small) 조합의 W_ binding. D_ 는 자신의 (large, small) 주차에 소속.
    const weekBySub = new Map<string, string>(); // `${large}|${small}` → W_ binding
    dynColMetas.forEach(m => {
      if (m.kind === 'W') weekBySub.set(`${m.large}|${m.small}`, m.binding);
    });
    dynColMetas.forEach(m => {
      if (m.kind === 'D') {
        const wk = weekBySub.get(`${m.large}|${m.small}`);
        if (wk) {
          if (!wm.has(wk)) wm.set(wk, new Set());
          wm.get(wk)?.add(m.binding);
        }
      } else if (m.kind === 'W') {
        const month = `M_${m.binding.slice(2, 8)}`;
        if (!mm.has(month)) mm.set(month, new Set());
        mm.get(month)?.add(m.binding);
      }
    });
    monthMap.current = mm;
    weekMap.current = wm;
  }, [dynColMetas]);

  // ── 동적 컬럼 3단 nested (mkt-fcst 패턴 — 년월 → 주차/SUM → 일자. #93 height 명시) ──
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    // ⭐ 헤더 단수 동적 (#93 캐노니컬 + Figma DMF0082 Table 실측 정합):
    //   D_ 존재(Daily 조회) = 3단(년월>주차>일, 각 16px) / D_ 부재(W/M 조회) = 2단(년월>주차, 각 24px
    //   — Figma Table 프레임 실측 24+24=48 과 일치). hasDaily/tierH = 컴포넌트 스코프 파생.
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank = { M: 0, W: 1, D: 2 } as const;
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
        // 3단 leaf = 일자('06') / 2단 leaf = 주차 라벨('W28') 또는 월 'SUM'
        header: hasDaily ? (m.kind === 'D' ? m.leaf || 'SUM' : 'SUM') : subKey,
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: tierH,
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): 'M' | 'W' | 'D' => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: tierH,
        allowSorting: false,
        allowMerging: false,
        columns: hasDaily
          ? [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .map(([subLabel, leafCols]) => ({
                header: subLabel,
                align: 'center',
                height: tierH,
                allowSorting: false,
                allowMerging: false,
                columns: leafCols.sort(
                  (a, b) =>
                    kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                    a.binding.localeCompare(b.binding)
                ),
              }))
          : // 2단 — 주차/SUM 컬럼을 직접 leaf 로 (Figma Table 실측 구조)
            [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .flatMap(([, leafCols]) =>
                leafCols.sort((a, b) => a.binding.localeCompare(b.binding))
              ),
      }));
  }, [dynColMetas, hasDaily, tierH]);

  const staticBindingSet = useMemo(
    () => new Set(staticColumns.map(c => c.colNm)),
    [staticColumns]
  );

  useEffect(() => {
    bucketRef.current = searchParams.bucketType;
  }, [searchParams.bucketType]);

  // ── grid 핸들러 등록 (useEffect + gridRef, deps=[staticColumns, dynamicColumns], cleanup 의무) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    editTrackerRef.current = new EditTracker(g as FlexGrid);
    if (!gridFilterRef.current) {
      // 동적(M_/W_/D_) 컬럼은 필터 제외 — 정적 컬럼만 필터 대상.
      gridFilterRef.current = new FlexGridFilter(g as FlexGrid, {
        filterColumns: staticColumns.map(c => c.colNm ?? '').filter(Boolean),
      });
    }

    // 편집 가능 판정 — AS-IS 권한 4분기(bEDIT_AUTH_*, GET drop3) + GridUtils 공통 판정.
    const canEditCell = (binding: string, dataItem: WijmoRowItem): boolean => {
      const measure = dataItem['MEASURE'];
      if (typeof measure !== 'string') return false;
      // 권한 대상 measure(4종) 외 = 항상 read-only / 대상인데 그룹권한 N = 차단.
      if (!(AUTH_MEASURES as readonly string[]).includes(measure)) return false;
      if (measureAuthRef.current[measure] === false) return false;
      const bucketName =
        bucketRef.current === 'M' ? 'Monthly' : bucketRef.current === 'D' ? 'Daily' : 'Weekly';
      return !isNonEditableCell(g as FlexGrid, binding, dataItem, weekMap.current, bucketName);
    };

    const cellEditableHandler = (
      sender: FlexGrid,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) {
        e.cancel = true;
        return;
      }
      if (staticBindingSet.has(binding)) {
        // 정적 컬럼: Insert 행(CRUD_TYPE 존재)만 편집 (AS-IS: 기존 행 키 컬럼 잠금)
        if (dataItem['CRUD_TYPE'] === undefined || dataItem['CRUD_TYPE'] === null) e.cancel = true;
        return;
      }
      if (kindOf(binding) && !canEditCell(binding, dataItem)) e.cancel = true;
    };

    // 편집 종료 — 월/주/일 배분 (AS-IS spdMain_EditChange 분배 로직 1:1, GridUtils 재사용).
    const cellEditHandler = (sender: FlexGrid, e: { row: number; col: number; data?: unknown }) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem || !kindOf(binding)) return;
      const val = sender.getCellData(e.row, e.col, false) as WijmoPrimitive;
      const oldVal = (e.data ?? null) as WijmoPrimitive;
      if ((oldVal === undefined || oldVal === null) && (val === undefined || val === null || val === ''))
        return;
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      const measure = dataItem['MEASURE'];
      // 배분 대상 = MKT_FCST/SCM_FCST 만 (AS-IS L498 실측). LOC=일괄할당. VMI_In_Req=단일 셀(배분 없음).
      if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
        if (binding.startsWith('M_'))
          divideByMonth(binding, dataItem, val, monthMap.current, weekMap.current, tracker);
        else if (binding.startsWith('W_'))
          divideByWeek(binding, dataItem, val, oldVal, weekMap.current, tracker);
        else if (binding.startsWith('D_')) divideByDate(binding, dataItem, val, oldVal, tracker);
      } else if (measure === 'LOC') {
        allocateLoc(binding, dataItem, val, monthMap.current, weekMap.current, tracker);
      } else {
        tracker.storeChange(dataItem, binding, oldVal, val);
      }
      sender.invalidate();
    };

    // 셀 표시 (#95 3색 표준 — 편집가능 Yellow / 기준주차 이전 잠금 Gray / 기본 White+zebra)
    //   + #108 No. 코너 헤더 (TopLeft 전체 단일 머지 + 'No.' 라벨, 재귀 가드).
    const formatHandler = (sender: FlexGrid, e: {
      panel: { cellType: CellType; rows: unknown };
      row: number;
      col: number;
      cell: HTMLElement;
    }) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.cell.textContent !== 'No.') e.cell.textContent = 'No.';
        e.cell.style.textAlign = 'center';
        e.cell.style.verticalAlign = 'middle';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;

      if (kindOf(binding)) {
        const editable = canEditCell(binding, dataItem);
        e.cell.classList.toggle('wj-cell-editable', editable);
        // 기준주차 이전 = 잠금 Gray (특수셀 한정 — 전체 회색 금지)
        e.cell.classList.toggle(
          'wj-cell-non-editable',
          isNonEditableDateColumn(binding, weekMap.current)
        );
        // 숫자 표시 — 0/null 은 빈칸 (AS-IS 표시 규칙)
        if (!sender.editRange?.contains(e.row, e.col)) {
          const v = dataItem[binding];
          e.cell.innerText =
            v === undefined || v === null || v === 0 || v === ''
              ? ''
              : toNumber(v as WijmoPrimitive).toLocaleString();
        }
        return;
      }
      // 정적 컬럼: Insert 행만 Yellow
      const isInsert = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
      e.cell.classList.toggle('wj-cell-editable', isInsert);
    };

    // Delete 키 — 선택 범위 일괄 clear + 배분 재계산 (AS-IS KeyUp Delete 1:1)
    const keydownHandler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key !== 'Delete') return;
      keyboardEvent.preventDefault();
      keyboardEvent.stopPropagation();
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      g.selectedRanges.forEach(range => {
        for (let row = range.topRow; row <= range.bottomRow; row++) {
          for (let col = range.leftCol; col <= range.rightCol; col++) {
            const dataItem = g.rows[row]?.dataItem as WijmoRowItem | undefined;
            const binding = g.columns[col]?.binding;
            if (!binding || !dataItem || g.columns[col]?.isReadOnly) continue;
            if (staticBindingSet.has(binding)) {
              if (dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null)
                dataItem[binding] = null;
              continue;
            }
            if (!kindOf(binding) || !canEditCell(binding, dataItem) || !dataItem[binding]) continue;
            const oldValue = dataItem[binding];
            tracker.storeChange(dataItem, binding, oldValue, 0);
            dataItem[binding] = 0;
            const measure = dataItem['MEASURE'];
            if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
              if (binding.startsWith('M_'))
                divideByMonth(binding, dataItem, 0, monthMap.current, weekMap.current, tracker);
              else if (binding.startsWith('W_'))
                divideByWeek(binding, dataItem, 0, oldValue, weekMap.current, tracker);
              else if (binding.startsWith('D_'))
                divideByDate(binding, dataItem, 0, oldValue, tracker);
            } else if (measure === 'LOC') {
              allocateLoc(binding, dataItem, 0, monthMap.current, weekMap.current, tracker);
            }
          }
        }
      });
      g.invalidate();
    };

    // 헤더 더블클릭 드릴다운 (AS-IS spdMain_CellDoubleClick 헤더 분기 / mkt-fcst 1:1) —
    //   W_ 헤더('SUM' leaf) 더블클릭 = 해당 주(다음 W_/M_ 전까지) D_ 토글 → 일자별 컬럼 표시/접기.
    //   M_ 헤더 더블클릭 = 해당 월(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기.
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = kindOf(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const idx = dynBindings.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M_ 드릴: 보이는 D_ 만 접기
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dynBindings.length; i++) {
        const t = dynBindings[i];
        const tk = kindOf(t);
        if (hk === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyDynVisibilityRef.current?.();
    };

    g.beginningEdit.addHandler(cellEditableHandler);
    g.pastingCell.addHandler(cellEditableHandler);
    g.cellEditEnded.addHandler(cellEditHandler);
    g.pastedCell.addHandler(cellEditHandler);
    g.formatItem.addHandler(formatHandler);
    g.hostElement.addEventListener('keydown', keydownHandler);
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      g.beginningEdit.removeHandler(cellEditableHandler);
      g.pastingCell.removeHandler(cellEditableHandler);
      g.cellEditEnded.removeHandler(cellEditHandler);
      g.pastedCell.removeHandler(cellEditHandler);
      g.formatItem.removeHandler(formatHandler);
      g.hostElement.removeEventListener('keydown', keydownHandler);
      g.hostElement.removeEventListener('dblclick', dblclickHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns]);

  // ⭐ 다단 헤더 높이 48px 고정 (#93) — 실헤더 행 수로 나눠 각 행 height 명시 설정 (mkt-fcst 방식).
  //   wrapper 의 defaultSize 만으로는 동적 config height 가 만든 explicit row height 에 덮여 무효 →
  //   각 헤더행 height 를 직접 세팅. updatedLayout 마다 재적용(columnGroups rebuild 후 리셋 대응).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynamicColumns, gridRef]);

  // ⭐ 동적 컬럼 표시 통합 (chkSum + 헤더 드릴다운, mkt-fcst 패턴 1:1) —
  //   활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 → 셋 다 드릴 오버라이드(drillVisRef) 우선.
  //   wrapper 의 columnGroups 재적용이 visible 을 덮으므로 updatedLayout 마다 재적용. 조회 없이 즉시 반영.
  const sumYn = searchParams.sumYn;
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    drillVisRef.current.clear(); // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행 → 드릴 리셋
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, drillBindings, dynBindings, dynamicColumns, gridRef]);

  return (
    <DataGrid<ForecastPriceRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useResultColumns
      useHotkey
    />
  );
};
