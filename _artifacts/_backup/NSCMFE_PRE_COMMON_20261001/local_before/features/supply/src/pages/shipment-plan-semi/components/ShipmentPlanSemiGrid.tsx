import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { Button, Checkbox } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { DIVISION_EE_ONLY_COLUMNS, MAIN_COLUMNS, FREEZE_ANCHOR_COLUMN } from '../shipment-plan-semi.columns';
import { BUCKET_TYPE, INVENTORY_MEASURE, MEASURE, MSG, QTY_MAX, QTY_MIN } from '../shipment-plan-semi.constants';
import type { FixInfoRow, MainColumnMeta, MainRow } from '../shipment-plan-semi.types';
import { buildColumns } from '../utils/shipment-plan-semi.buildColumns';
import { distributeWeeklyToDailyBindings } from '../utils/shipment-plan-semi.deptDayDistribute';
import { dynColKindOf, isMainCellEditable, isQtyInRange, type MainEditContext } from '../utils/shipment-plan-semi.editLock';

import styles from './ShipmentPlanSemiGrid.module.scss';

export interface SpreadTitleRow {
  COLUMN_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  COLUMN_LABEL_NAME?: string;
  SORT_ORDER_NO?: number;
  BASIS_START_DATE?: string;
  DAY_CODE?: string;
}

interface Props {
  rows: MainRow[];
  spreadTitle: SpreadTitleRow[];
  fixInfoRows: FixInfoRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  division: string;
  planStartYyyymmdd: string;
  toYyyymmdd: string;
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  onChangeBucketType: (v: BUCKET_TYPE) => void;
  onChangeChkSum: (v: boolean) => void;
  onOpenMeasureSetup: () => void;
  showMeasureButton: boolean;
  onFocus: () => void;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const ShipmentPlanSemiGrid = ({
  rows,
  spreadTitle,
  fixInfoRows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  division,
  planStartYyyymmdd,
  toYyyymmdd,
  bucketType,
  chkSum,
  onChangeBucketType,
  onChangeChkSum,
  onOpenMeasureSetup,
  showMeasureButton,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  // 정보컬럼 — admin 메타 우선, division 조건부 hidden 은 런타임 오버레이(design 03 §1 R-A)
  const infoColumns = useMemo<MainColumnMeta[]>(() => {
    const isEE = division.startsWith('EE');
    return MAIN_COLUMNS.map(c => {
      if ((DIVISION_EE_ONLY_COLUMNS as readonly string[]).includes(c.key)) {
        return { ...c, visible: isEE };
      }
      return c;
    });
  }, [division]);
  const staticColumns = useMemo(() => buildColumns(infoColumns, adminColumns), [infoColumns, adminColumns]);

  // 동적 D_/W_/M_ pivot 컬럼 — 헤더구조는 spreadTitle(calendar SP, Bucket 무관 항상 전체) 기준(design 03 §2.1~§2.3)
  const dynColMetas = useMemo(
    () =>
      spreadTitle
        .map(r => {
          const binding = s(r.COLUMN_NAME);
          const kind = dynColKindOf(binding);
          if (!kind) return null;
          return {
            binding,
            kind,
            large: s(r.LARGE_CLASS_LABEL_NAME),
            small: s(r.SMALL_CLASS_LABEL_NAME),
            leaf: s(r.COLUMN_LABEL_NAME) || binding,
            sort: Number(r.SORT_ORDER_NO ?? 0),
            weekStart: s(r.BASIS_START_DATE),
          };
        })
        .filter((m): m is NonNullable<typeof m> => m !== null),
    [spreadTitle]
  );

  const weekOrMonthStart = useMemo(() => {
    const map = new Map<string, string>();
    dynColMetas.forEach(m => {
      if (m.weekStart) map.set(m.binding, m.weekStart);
    });
    return map;
  }, [dynColMetas]);

  // W_ binding -> 그 주에 속한 7개 D_ binding 목록(design 03 §3.3 R-DeptDist 분배용) — weekStart 매칭.
  const weekToDayBindings = useMemo(() => {
    const map = new Map<string, string[]>();
    const dBindings = dynColMetas.filter(m => m.kind === 'D');
    dynColMetas
      .filter(m => m.kind === 'W')
      .forEach(w => {
        const days = dBindings.filter(d => weekOrMonthStart.get(d.binding) === w.weekStart).map(d => d.binding);
        if (days.length > 0) map.set(w.binding, days);
      });
    return map;
  }, [dynColMetas, weekOrMonthStart]);

  // W_ binding 오름차순 목록(design 03 §3.1 Weekly 동일주차 반복 방어, R-K §6#7) — calendar SP 가
  //   이미 SORT_ORDER_NO(BASIS_START_DATE 기준) 오름차순으로 내려주므로 dynColMetas 필터만으로 충분.
  const weekBindingsAsc = useMemo(
    () => dynColMetas.filter(m => m.kind === 'W').map(m => m.binding),
    [dynColMetas]
  );

  // Bucket x chkSum -> visible 토글(design 03 §2.4) — SCP0009 와 달리 chkAll 예외 없음(§0.2, 죽은 코드).
  const isDynVisible = (kind: 'D' | 'W' | 'M'): boolean => {
    if (bucketType === BUCKET_TYPE.DAILY) return kind === 'D' || (kind === 'M' && chkSum);
    if (bucketType === BUCKET_TYPE.WEEKLY) return kind === 'W' || (kind === 'M' && chkSum);
    return kind === 'M'; // Monthly — M_ 만
  };

  // 3-span 헤더(대/소/일) — Wijmo 중첩 columns 가 병합 메커니즘(shipment-plan-fg 동일 패턴, 공용 SP 공유)
  const dynamicColumns = useMemo(() => {
    type LeafCol = { binding: string; header: string; sort: number; visible: boolean };
    type LargeBucket = { label: string; order: number; subs: Map<string, LeafCol[]> };
    const largeMap = new Map<string, LargeBucket>();
    dynColMetas.forEach(m => {
      const largeKey = m.binding.slice(0, m.kind === 'M' ? 8 : 6);
      const bucket: LargeBucket = largeMap.get(largeKey) ?? {
        label: m.large,
        order: m.sort,
        subs: new Map<string, LeafCol[]>(),
      };
      largeMap.set(largeKey, bucket);
      const subKey = m.kind === 'M' ? 'SUM' : m.small || 'SUM';
      const leafCols: LeafCol[] = bucket.subs.get(subKey) ?? [];
      bucket.subs.set(subKey, leafCols);
      leafCols.push({
        binding: m.binding,
        header: m.leaf,
        sort: m.sort,
        visible: isDynVisible(m.kind),
      });
    });
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort((a, b) => (a[1][0]?.sort ?? 0) - (b[1][0]?.sort ?? 0))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            columns: leafCols
              .sort((a, b) => a.sort - b.sort)
              .map(l => ({
                binding: l.binding,
                header: l.header,
                align: 'right',
                width: 90,
                allowDragging: false,
                allowMerging: false,
                allowSorting: false,
                visible: l.visible,
                format: '#,##0.##',
              })),
          })),
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, bucketType, chkSum]);

  // INVENTORY 행 후처리(design 03 §2.5) — 초기 로드 시 W_/M_ 값을 그 주/월의 마지막 D_ 값으로 덮어쓴다.
  const displayRows = useMemo<MainRow[]>(() => {
    if (rows.length === 0) return rows;
    const dBindings = dynColMetas.filter(m => m.kind === 'D').sort((a, b) => a.binding.localeCompare(b.binding));
    if (dBindings.length === 0) return rows;
    return rows.map(row => {
      const r = row as unknown as Record<string, unknown>;
      if (s(r.measure) !== INVENTORY_MEASURE) return row;
      const next = { ...r };
      weekToDayBindings.forEach((dayBindings, wBinding) => {
        const sorted = [...dayBindings].sort();
        const lastDay = sorted[sorted.length - 1];
        if (lastDay) next[wBinding] = r[lastDay];
      });
      // M_ — 그 달의 마지막 D_ 값(월별 그룹은 binding 앞 8자리 M_YYYYMM 로 근사 매칭)
      const monthGroups = new Map<string, string[]>();
      dBindings.forEach(d => {
        const monthKey = `M_${d.binding.slice(2, 8)}`;
        const list = monthGroups.get(monthKey) ?? [];
        list.push(d.binding);
        monthGroups.set(monthKey, list);
      });
      monthGroups.forEach((days, mBinding) => {
        const sorted = [...days].sort();
        const lastDay = sorted[sorted.length - 1];
        if (lastDay) next[mBinding] = r[lastDay];
      });
      return next as unknown as MainRow;
    });
  }, [rows, dynColMetas, weekToDayBindings]);

  // Fix 정보(O_RC3) — D_ 컬럼 하이라이트(design 03 §4.2, R-F Weekly 는 W_ 헤더까지 확산)
  const fixedDayBindings = useMemo(() => {
    const set = new Set<string>();
    fixInfoRows.forEach(r => {
      if (r.YYYYMMDD) set.add(r.YYYYMMDD);
    });
    return set;
  }, [fixInfoRows]);
  const fixedWeekStarts = useMemo(() => {
    const set = new Set<string>();
    fixedDayBindings.forEach(day => {
      const weekStart = weekOrMonthStart.get(`D_${day}`);
      if (weekStart) set.add(weekStart);
    });
    return set;
  }, [fixedDayBindings, weekOrMonthStart]);

  const editCtxRef = useRef<MainEditContext>({
    bucketType,
    division,
    planStartYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    weekOrMonthStart,
    weekBindingsAsc,
  });
  editCtxRef.current = {
    bucketType,
    division,
    planStartYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    weekOrMonthStart,
    weekBindingsAsc,
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집잠금(정보컬럼 전건 잠금 + R-K SHIP_PLAN_AMEND 판정) — beginningEdit 게이트.
    const beginningEditHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row || !isMainCellEditable(binding, row, editCtxRef.current)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Weekly 셀(W_) 입력 시 Dept Day 요일 자동분배(design 03 §3.3 R-DeptDist, 이 화면 고유) +
    //   저장 값 검증(cellEditEnded) — 음수/상한 초과(design 03 §4.3 MSG00084/MSG00317).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const kind = dynColKindOf(binding);
      if (!kind) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const qty = Number(row[binding]);
      if (!Number.isFinite(qty)) return;
      let clamped = qty;
      if (!isQtyInRange(qty, QTY_MIN, QTY_MAX)) {
        if (qty < QTY_MIN) {
          setToast({ type: 'error', message: t(MSG.QTY_NEGATIVE, '_Value must not be negative.') });
          clamped = QTY_MIN;
        } else {
          setToast({ type: 'error', message: t(MSG.QTY_MAX, '_Value exceeds maximum(99999999).') });
          clamped = QTY_MAX;
        }
        row[binding] = clamped;
      }
      if (kind === 'W') {
        const dayBindings = weekToDayBindings.get(binding);
        const deptDay = typeof row.Dept_Day === 'string' ? row.Dept_Day : 'X';
        if (dayBindings) {
          const distributed = distributeWeeklyToDailyBindings(dayBindings, deptDay, clamped);
          Object.entries(distributed).forEach(([dBinding, value]) => {
            row[dBinding] = value;
          });
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // Fix 하이라이트(D_ 매칭 + Weekly 는 W_ 헤더까지 확산, design 03 §4.2) + SHIP_PLAN_AMEND 입력밴드(R-G) — formatItem.
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: { columns: { binding: string }[]; rows: { dataItem: unknown }[] }; col: number; row: number; cell: HTMLElement }
    ) => {
      const binding = e.panel?.columns?.[e.col]?.binding ?? '';
      if (binding.startsWith('D_') && fixedDayBindings.has(binding.slice(2))) {
        e.cell.style.backgroundColor = 'rgb(188,229,92)';
        return;
      }
      if (binding.startsWith('W_') && fixedWeekStarts.has(weekOrMonthStart.get(binding) ?? '')) {
        e.cell.style.backgroundColor = 'rgb(188,229,92)';
        return;
      }
      const dataItem = e.panel?.rows?.[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (dataItem && s(dataItem.measure) === MEASURE.SHIP_PLAN_AMEND && dynColKindOf(binding)) {
        e.cell.style.backgroundColor = 'rgb(234,234,234)';
      }
    };
    g.formatItem.addHandler(formatItemHandler as never);

    // 인접 정보컬럼 세로 병합(SmartColMerge, R-I) — Freeze 경계(measure_label) 이전까지만.
    g.columns.forEach(col => {
      const binding = col.binding ?? '';
      col.allowMerging = binding !== '' && binding !== FREEZE_ANCHOR_COLUMN && !dynColKindOf(binding);
    });
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatItemHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns, bucketType, fixedDayBindings, fixedWeekStarts, weekOrMonthStart, weekToDayBindings]);

  return (
    <>
      {/* 영역3 그리드 툴바 — Bucket/Sum/Measure(design 00_checklist §1 area=3 분류). 이 화면은
          btnColumn 이 없다(design 03 §0.1 — Measure 만 존재). chkAll 은 렌더하지 않음(AS-IS §0.2 죽은 코드). */}
      <div className={styles.gridToolbar}>
        {[BUCKET_TYPE.DAILY, BUCKET_TYPE.WEEKLY, BUCKET_TYPE.MONTHLY].map(b => (
          <Button
            key={b}
            appearance='outlined'
            priority='normal'
            className={bucketType === b ? styles.bucketActive : undefined}
            onClick={() => onChangeBucketType(b)}
          >
            {b}
          </Button>
        ))}
        <Checkbox checked={chkSum} onChange={checked => onChangeChkSum(checked)} />
        <span>{t('LBL00687', { defaultValue: 'Sum' })}</span>
        {showMeasureButton && (
          <Button appearance='outlined' priority='normal' onClick={onOpenMeasureSetup}>
            {t('LBL00310', { defaultValue: 'Measure' })}
          </Button>
        )}
      </div>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={displayRows as unknown as WijmoRowItem[]}
        staticColumns={staticColumns}
        dynamicColumns={dynamicColumns as unknown as FlexGridColumnConfig[]}
        allowMerging={AllowMerging.All}
        gotFocus={onFocus}
      />
    </>
  );
};
