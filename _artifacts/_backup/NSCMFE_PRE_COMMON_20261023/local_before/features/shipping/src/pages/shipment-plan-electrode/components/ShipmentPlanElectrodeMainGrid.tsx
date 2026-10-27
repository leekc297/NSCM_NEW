import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type {
  BUCKET_TYPE} from '../shipment-plan-electrode.constants';
import {
  BOH_COLUMNS,
  BOH_RADIO,
  MAIN_CONFIRM_MEASURE,
  MAIN_EDITABLE_MEASURE,
  MENU_ID,
} from '../shipment-plan-electrode.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-electrode.types';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';
import {
  activeSpanOf,
  isDynVisible,
  isMainCellEditable,
  parseDynTag,
  type DynSpan,
} from '../utils/shipment-plan-electrode.editLock';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  bohRadio: BOH_RADIO;
  chkSum: boolean;
  chkPastPeriod: boolean;
  // Main 편집 가능 여부 = canEdit(편집계 권한 INSERT||SAVE)·최신Plan(realFlag). 셀 단위 범위는 isMainCellEditable.
  //   AS-IS EditButton SwitchLock 미이식(convert-core §2.4) — 편집 기본 ON, 권한은 마운트 1회 판정.
  editable: boolean;
  curPlanDate: string;
  onCellEdited?: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

// Main(PSI) 그리드 — base 26컬럼(admin 메타) + 동적 기간(X_/Y_/Z_ × D_/W_/M_, GET_SHEET_CALENDAR_3SPAN).
//   활성 span(rdButton1→X_ / rdButton2→Y_ / rdButton3→Z_)만 노출, bucket 표시규칙(§2.2)·주말색·과거일 회색·
//   Plan-Confirm 불일치 LightPink 재현. 편집표면 = 활성 span D_ 셀(P_SHIP_PLAN_SIMU_ETD 행 + plan_start~confirm_day).
export const ShipmentPlanElectrodeMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  bohRadio,
  chkSum,
  chkPastPeriod,
  editable,
  curPlanDate,
  onCellEdited,
}: Props) => {
  const columns = adminColumns ?? [];
  const activeSpan = activeSpanOf(bohRadio);

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback (forecast-price 패턴)
  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!parseDynTag(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => {
          const tag = parseDynTag(str(r.COLUMN_NAME));
          return {
            binding: str(r.COLUMN_NAME),
            span: tag?.span as DynSpan,
            bucket: tag?.bucket ?? 'D',
            ymd: tag?.ymd ?? '',
            large: str(r.LARGE_CLASS_LABEL_NAME),
            small: str(r.SMALL_CLASS_LABEL_NAME),
            leaf: str(r.COLUMN_LABEL_NAME),
            dayCode: str(r.DAY_CODE),
            sort: str(r.SORT_ORDER_NO),
          };
        })
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (parseDynTag(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => {
      const tag = parseDynTag(b);
      return {
        binding: b,
        span: tag?.span as DynSpan,
        bucket: tag?.bucket ?? 'D',
        ymd: tag?.ymd ?? '',
        large: tag?.ymd.slice(0, 6) ?? '',
        small: '',
        leaf: tag?.ymd.slice(6) ?? '',
        dayCode: '',
        sort: b,
      };
    });
  }, [calendar, rows]);

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (03 §3.3, 활성 span D_ 한정)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      if (meta.bucket !== 'D' || meta.span !== activeSpan) return;
      const code = meta.dayCode.toUpperCase();
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas, activeSpan]);

  // 표시 여부 판정 — 활성 span + bucket 표시규칙 + chkPastPeriod(과거 D_/W_ 숨김, SUM/M_ 제외).
  const isVisible = (meta: (typeof dynColMetas)[number]): boolean => {
    const tag = parseDynTag(meta.binding);
    if (!tag) return false;
    if (!isDynVisible(tag, activeSpan, bucketType, chkSum)) return false;
    if (chkPastPeriod && curPlanDate && tag.bucket !== 'M' && tag.ymd < curPlanDate) return false;
    return true;
  };

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일) — 활성 span 만
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const active = dynColMetas.filter(m => m.span === activeSpan);
    if (active.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<string, number> = { M: 0, W: 1, D: 2 };
    active.forEach((m, idx) => {
      const ymKey = m.ymd.slice(0, 6);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.bucket === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.bucket === 'D' ? m.leaf || 'SUM' : 'SUM',
        align: 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isVisible(m),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
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
                (kindRank[parseDynTag(a.binding)?.bucket ?? 'D'] ?? 2) -
                  (kindRank[parseDynTag(b.binding)?.bucket ?? 'D'] ?? 2) ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, activeSpan, bucketType, chkSum, chkPastPeriod, curPlanDate]);

  // BOH 3칸 표시 토글 — 활성 radio 3칸만 노출(03 §2.1). base 컬럼(admin 메타)에 대한 visible override.
  const bohVisibleSet = useMemo(() => new Set<string>(BOH_COLUMNS[bohRadio]), [bohRadio]);
  const bohAllSet = useMemo(
    () =>
      new Set<string>([
        ...BOH_COLUMNS[BOH_RADIO.GENERAL],
        ...BOH_COLUMNS[BOH_RADIO.CELL],
        ...BOH_COLUMNS[BOH_RADIO.PCM],
      ]),
    []
  );

  const setActiveGrid = useShipmentPlanElectrodeStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;

  const editableRef = useRef(editable);
  editableRef.current = editable;
  const activeSpanRef = useRef(activeSpan);
  activeSpanRef.current = activeSpan;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const onCellEditedRef = useRef(onCellEdited);
  onCellEditedRef.current = onCellEdited;
  const bohVisibleRef = useRef(bohVisibleSet);
  bohVisibleRef.current = bohVisibleSet;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 병합 — base 전 컬럼 허용 / 동적(X_/Y_/Z_) 만 제외(FPMerge.None 재현)
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !parseDynTag(binding);
        // BOH 3칸 visible override — 활성 radio 3칸만(비활성 6칸 숨김)
        if (bohAllSet.has(binding)) col.visible = bohVisibleRef.current.has(binding);
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    // 편집 잠금 — beginningEdit(e.cancel) (활성 span D_ + SIMU 측정치 행 + plan_start~confirm_day)
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (
        !isMainCellEditable(row, binding, editableRef.current, activeSpanRef.current, curPlanDateRef.current)
      ) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 색상 — 헤더 주말색 / 편집기간 BACK_COLOR RGB / 과거일 회색 / Plan-Confirm 불일치 LightPink (03 §3.3)
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
      const tag = parseDynTag(binding);
      if (!tag || tag.span !== activeSpanRef.current) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;

      const cellEditable = isMainCellEditable(
        row,
        binding,
        editableRef.current,
        activeSpanRef.current,
        curPlanDateRef.current
      );
      // 과거일(오늘 이전 = plan_start 이전) 회색 (03 §3.3 RGB(230,230,230))
      const isPast = !!curPlanDateRef.current && tag.bucket === 'D' && tag.ymd < curPlanDateRef.current;
      if (isPast) {
        e.cell.style.backgroundColor = 'rgb(230,230,230)';
        return;
      }
      // Plan-Confirm 불일치 — SIMU 행에서 동일 기간열 CONFIRM 측정치 값과 다르면 LightPink (03 §3.3)
      if (str(row.MEASURE) === MAIN_EDITABLE_MEASURE) {
        const confirmRow = (sender.collectionView?.sourceCollection ?? []).find(
          (r: Record<string, unknown>) =>
            str(r.MEASURE) === MAIN_CONFIRM_MEASURE &&
            str(r.FROM_SITE) === str(row.FROM_SITE) &&
            str(r.ITEM_ID) === str(row.ITEM_ID) &&
            str(r.TO_SITE) === str(row.TO_SITE)
        ) as Record<string, unknown> | undefined;
        if (confirmRow && num(row[binding]) !== num(confirmRow[binding])) {
          e.cell.style.backgroundColor = '#FFB6C1'; // LightPink
          return;
        }
      }
      // 편집기간 배경 — BACK_COLOR 필드 RGB(있으면), 없으면 연노랑
      if (cellEditable) {
        const rgb = str(row.BACK_COLOR).trim();
        e.cell.style.backgroundColor = rgb ? rgb : '#FFFDE7';
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 — 동적 셀은 편집창 판정으로 wrapper 판정을 덮어씀(등록 순서 호출)
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!parseDynTag(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isMainCellEditable(
        row,
        binding,
        editableRef.current,
        activeSpanRef.current,
        curPlanDateRef.current
      );
    };
    g.pastingCell.addHandler(pastingCellHandler);

    const onEdited = () => {
      onCellEditedRef.current?.();
    };
    g.cellEditEnded.addHandler(onEdited);
    g.pastedCell.addHandler(onEdited);

    // 활성 그리드 전환 — 프레임워크 parity(BaseForm.FpSpread_CellClick 무조건 전환)
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
        g.cellEditEnded?.removeHandler(onEdited);
        g.pastedCell?.removeHandler(onEdited);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns, bohRadio]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져(CustomMergeManager 는 grid.allowMerging 정확일치 판정)
      //   정적 컬럼(allowMerging=true, applyMerge L234)의 단일 라벨이 그룹 헤더행+leaf행에 각각 찍혀 "같은 라벨 2줄".
      //   .All 이어야 헤더 병합(정적 컬럼 세로 span)과 셀 병합이 둘 다 동작(Mobility&IT 선례).
      allowMerging={AllowMerging.All}
    />
  );
};
