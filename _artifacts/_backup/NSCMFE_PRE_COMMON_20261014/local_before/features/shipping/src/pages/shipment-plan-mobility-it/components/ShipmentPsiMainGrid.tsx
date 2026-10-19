import { toggleClass } from '@mescius/wijmo';
import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { BUCKET_TYPE, MENU_ID } from '../shipment-plan-mobility-it.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-mobility-it.types';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { isMainCellEditable } from '../utils/shipment-plan-mobility-it.editLock';
import { ShipmentPsiMergeManager } from '../utils/shipment-plan-mobility-it.merge';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // 편집 가능 = canEdit(hasButton('EDIT')) — AS-IS EditButton 토글 미이식(convert-core §2.4).
  editable: boolean;
  // 확정구간 기준일 yyyymmdd — Plan Date + (Packer 2 / 그 외 20)일 (AS-IS Re_Design confirmDay,
  //   SSP0015.cs L2766/2770). 이 일자 이하 기간 컬럼은 회색(확정구간), 이후 WH_IN D_ 는 편집(Yellow).
  confirmDay: string;
  // 기간셀 더블클릭 드릴다운 (design 03 §3.F) — 페이지가 detail sheet 전환 + 재조회
  onDrilldown: (row: MainRow) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M' | 'B';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_')
    ? 'D'
    : binding.startsWith('W_')
      ? 'W'
      : binding.startsWith('M_')
        ? 'M'
        : binding.startsWith('B_')
          ? 'B'
          : undefined;

// Bucket/chkSum 표시규칙 (design 03 §2 — D_/W_/M_ 토글, B_ 텍스트는 항상 표시)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (kind === 'B') return true;
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M';
};

// master PSI 그리드 — base 프레임 17열(admin 메타) + D_/W_/M_/B_ 동적(서버 wide + calendar 3단 헤더).
//   편집 표면 = WH_IN 측정치 행의 D_ 기간셀만(design 03 §3.A). W_/M_ Sum·B_ 텍스트는 잠금.
export const ShipmentPsiMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  chkSum,
  editable,
  confirmDay,
  onDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];

  // Sum 토글은 컬럼 재생성 없이 imperative 로 반영(스크롤/폭 보존, 헤더 SUM 병합 유지) —
  //   빌드 시점 초기 visible 계산만 최신값을 참조하고, 토글 자체는 아래 applyDynVisibility 가 flip.
  //   (MktFcstGrid sumYnRef 동일 패턴 — chkSum 을 dynamicColumns dep 에 두면 매 토글 전 컬럼 재생성.)
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;

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

  // 토(Blue)/일(Red) 헤더색 (design 03 §3.C)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      if (meta.kind !== 'D') return;
      const code = meta.dayCode.toUpperCase();
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2, B: 3 };
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
        header: m.kind === 'D' ? m.leaf || 'SUM' : m.kind === 'B' ? m.leaf : 'SUM',
        align: m.kind === 'B' ? 'left' : 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSumRef.current),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? Number.NEGATIVE_INFINITY : Number(k.replace(/\D/g, '') || 0));
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
    // chkSum 은 의도적으로 제외(chkSumRef 로 초기값만 참조) — Sum 토글은 applyDynVisibility 가 재생성 없이 flip.
  }, [dynColMetas, bucketType]);

  // 동적 컬럼 binding 순서(드릴다운 span 보행 기준 — SP 수신/정렬 순서 그대로, M/W/D interleave).
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // 헤더 더블클릭 드릴 오버라이드(binding → visible). bucket/chkSum 변경 시 리셋(AS-IS SetSpreadColumn 재실행).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);
  // 동적 헤더 SUM 병합 매니저 설치 표식 — grid 인스턴스당 1회만 래핑(체인 무한 증식 방지).
  const mergeWrappedRef = useRef<FlexGridType | null>(null);

  const setActiveGrid = useShipmentPlanMobilityItStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;
  const editableRef = useRef(editable);
  editableRef.current = editable;
  // 확정구간(회색) binding 집합 — AS-IS Re_Design SetBGColor2(startIdx~D_confirmDay) 밴드 재현.
  //   SP 컬럼순(dynBindings, = AS-IS 스프레드순)에서 confirmDay 이하 마지막 D_ 위치까지를 회색으로 본다.
  //   그 밴드 안의 W_/M_ Sum·B_ 텍스트 컬럼도 함께 회색이 된다(SUM 포함 — 사용자 지시 2026-09-30).
  const greyBindings = useMemo<Set<string>>(() => {
    const set = new Set<string>();
    if (!confirmDay || dynBindings.length === 0) return set;
    let endIdx = -1;
    dynBindings.forEach((b, i) => {
      if (b.startsWith('D_') && b.slice(2) <= confirmDay) endIdx = i;
    });
    for (let i = 0; i <= endIdx; i++) set.add(dynBindings[i]);
    return set;
  }, [dynBindings, confirmDay]);
  const greyRef = useRef(greyBindings);
  greyRef.current = greyBindings;
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 병합 매니저 — DataGrid 공용 매니저를 감싸 (a) 선행 식별 컬럼 데이터셀 계층 세로병합
    //   (b) 동적 M_/W_/D_ 헤더 병합(년월/주차 가로 · M_ SUM 세로) 전담. 정적 헤더·그 외는 delegate.
    //   (DM MktFcst HierarchicalMergeManager 1:1 — 사용자 요구 "DM 화면과 동일" 2026-09-30). grid 인스턴스당 1회 래핑.
    if (mergeWrappedRef.current !== g) {
      g.mergeManager = new ShipmentPsiMergeManager(g.mergeManager);
      mergeWrappedRef.current = g;
    }
    const mergeManager = g.mergeManager as ShipmentPsiMergeManager;

    // 병합 대상 컬럼(allowMerging) + 계층 키(fixedBindings) 갱신 — 동적(M_/W_/D_/B_)·MEASURE(측정치 행라벨)를
    //   제외한 선행 식별 컬럼(Div/From Site/Model/Nick Name/BOH/TYPE …)을 값이 같은 연속 행끼리 세로병합한다.
    //   updatedLayout 마다 재적용(컬럼 재구성·division 전환 대응).
    const applyMerge = () => {
      const fixed: string[] = [];
      g.columns.forEach(col => {
        const b = col.binding ?? '';
        const mergeable = !!b && !/^[MWDB]_/.test(b) && b !== 'MEASURE';
        col.allowMerging = mergeable;
        if (mergeable) fixed.push(b);
      });
      mergeManager.fixedBindings = fixed;
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기도 동일 게이트 — 공용 pastingCell(setEditableColumns)은 _inputEditType=OPTIONAL 이라
    //   W_/M_ 합계·과거 셀까지 허용한다. 편집 불가 셀에 값이 덮이는 것을 막는다(편집 게이트와 세트).
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current)) {
        e.cancel = true;
      }
    };
    g.pastingCell.addHandler(pastingCellHandler);

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
      // 동적 기간 컬럼(D_/W_/M_/B_)만 편집표시/회색을 관리한다 — 정적 17열은 공용 formatEditableColumns
      //   (INPUT_TP_CD 기준)에 맡긴다(정적 편집컬럼의 표시를 덮어쓰지 않도록).
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const isGrey = greyRef.current.has(binding);
      const cellEditable = isMainCellEditable(row, binding, editableRef.current);
      // 편집 가능 = Yellow(wj-cell-editable) 우선 — WH_IN 행 D_ 는 과거(확정구간)여도 편집 가능하므로 노란색
      //   (AS-IS WH_IN 행 전 기간 unlock, 사용자 요구 2026-09-30 "회색말고 노란색"). 회색(wj-cell-non-editable,
      //   확정구간+SUM)은 편집 불가 셀에만. 공용 formatEditableColumns 가 전 동적셀에 붙인 editable 클래스를 재지정.
      toggleClass(e.cell, 'wj-cell-editable', cellEditable);
      toggleClass(e.cell, 'wj-cell-non-editable', isGrey && !cellEditable);
      // PROD_DATE/LOT 측정치 행 특수 셀표시 (design 03 §2·§3.C L2670/2674/2678 — gap-resolve I14).
      //   PROD_DATE = 날짜텍스트(center), LOT = 텍스트(center)이며 빈값/"0" 은 공백표시.
      const measure = str(row?.MEASURE);
      if (measure === 'LOT') {
        e.cell.style.textAlign = 'center';
        const txt = (e.cell.textContent ?? '').trim();
        if (txt === '' || txt === '0') e.cell.textContent = '';
      } else if (measure === 'PROD_DATE') {
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // 더블클릭 — (1) 컬럼 헤더: 기간 드릴다운 / (2) 데이터 셀: detail 드릴다운.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);

      // (1) 헤더 더블클릭 → 기간 드릴다운 (AS-IS SetDblClickColumnShowHide, SpreadInfo.cs L10838~10885 1:1):
      //   M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기 / W_ 헤더 = 그 주 구간 D_ 토글.
      //   Monthly bucket 에서 M_ 헤더를 더블클릭하면 해당 월의 주(W_)가 펼쳐진다.
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = kindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const col = g.getColumn(target);
          if (!col) return;
          if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
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
        return;
      }

      // (2) 기간셀 더블클릭 → detail 드릴다운 (design 03 §3.F). 동적 기간셀만.
      if (g.rows.length === 0) return;
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      onDrilldownRef.current(row);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

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
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns]);

  // 드릴 상태 리셋 — bucket 변경(= AS-IS SetSpreadColumn 재실행)에만. Sum 토글은 드릴을 보존한다
  //   (Monthly 에서 드릴 펼친 뒤 Sum 체크하면 Monthly 로 접히던 문제 교정 — 2026-09-29).
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucketType, dynBindings]);

  // Sum 체크박스 + 헤더 드릴다운 통합 적용 (AS-IS SetSpreadColumn + SetDblClickColumnShowHide 1:1).
  //   규칙: isDynVisible(base) 위에 드릴 오버라이드(drillVisRef) 우선. 컬럼 재생성 없이 imperative flip
  //   이라 스크롤/컬럼폭 보존. DataGrid 의 columnGroups 재적용이 visible 을 덮을 수 있어 updatedLayout
  //   마다 재적용하고, 바뀐 게 있으면 invalidate 로 헤더 SUM 병합까지 다시 그린다(MktFcstGrid 동일 패턴).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const base = isDynVisible(kindOf(b) as DynKind, bucketType, chkSum);
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
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        // unmount race
      }
    };
  }, [bucketType, chkSum, dynBindings, gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // Cells 만 주면 컬럼 헤더 병합이 꺼져(CustomMergeManager 는 grid.allowMerging 정확일치로 판정)
      //   self-label 그룹(Div/Div…)이 부모·자식 2행으로 중복되고 BOH 그룹이 갈라진다. All 이어야
      //   헤더 병합(그룹 셀 span) + 셀 병합(TYPE/PSI_NAME 세로병합, col.allowMerging) 둘 다 동작.
      allowMerging={AllowMerging.All}
    />
  );
};
