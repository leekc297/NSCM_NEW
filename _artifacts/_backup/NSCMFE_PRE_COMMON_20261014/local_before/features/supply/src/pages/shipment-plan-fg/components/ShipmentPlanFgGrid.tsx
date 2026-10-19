import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { Button, Checkbox } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { MAIN_COLUMNS, DIVISION_40_ONLY_COLUMNS, DIVISION_EE_ONLY_COLUMNS, FREEZE_ANCHOR_COLUMN } from '../shipment-plan-fg.columns';
import { BUCKET_TYPE, DRILLDOWN_MEASURE, LBL, MSG, QTY_MAX } from '../shipment-plan-fg.constants';
import type { FixInfoRow, MainColumnMeta, MainRow } from '../shipment-plan-fg.types';
import { buildColumns } from '../utils/shipment-plan-fg.buildColumns';
import { dynColKindOf, isMainCellEditable, type MainEditContext } from '../utils/shipment-plan-fg.editLock';

import styles from './ShipmentPlanFgGrid.module.scss';

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
  fromYyyymmdd: string;
  toYyyymmdd: string;
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  chkAll: boolean;
  onChangeBucketType: (v: BUCKET_TYPE) => void;
  onChangeChkSum: (v: boolean) => void;
  onOpenColumnSetup: () => void;
  onOpenMeasureSetup: () => void;
  showColumnButton: boolean;
  showMeasureButton: boolean;
  onCellDoubleClick: (row: MainRow, dueDateYyyymmdd: string) => void;
  onFocus: () => void;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const ShipmentPlanFgGrid = ({
  rows,
  spreadTitle,
  fixInfoRows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  division,
  planStartYyyymmdd,
  fromYyyymmdd,
  toYyyymmdd,
  bucketType,
  chkSum,
  chkAll,
  onChangeBucketType,
  onChangeChkSum,
  onOpenColumnSetup,
  onOpenMeasureSetup,
  showColumnButton,
  showMeasureButton,
  onCellDoubleClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  // 정보컬럼 — admin 메타 우선, division 조건부 hidden 은 런타임 오버레이(design 03 §1.A R-A/R-B)
  const infoColumns = useMemo<MainColumnMeta[]>(() => {
    const isEE = division.startsWith('EE');
    const is40 = division === '40';
    return MAIN_COLUMNS.map(c => {
      if ((DIVISION_40_ONLY_COLUMNS as readonly string[]).includes(c.key)) {
        return { ...c, visible: is40 };
      }
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

  // Bucket x chkSum -> visible 토글(design 03 §2.4) — 재조회 없는 클라 토글
  const isDynVisible = (kind: 'D' | 'W' | 'M'): boolean => {
    if (bucketType === BUCKET_TYPE.DAILY) return kind === 'D' || chkSum;
    if (bucketType === BUCKET_TYPE.WEEKLY) return kind === 'W' || (kind === 'M' && chkSum);
    return kind === 'M'; // Monthly — M_ 만
  };

  // 3-span 헤더(대/소/일) — Wijmo 중첩 columns 가 병합 메커니즘(forecast-price/sales-plan 패턴)
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
                // 소수자리(design 03 §2.2): SHIP_PLAN_ENERGY/_AMEND_ENERGY 행 3자리, 나머지 2자리 —
                //   Wijmo 컬럼 format 은 컬럼 단위라 행(MEASURE)별 전환이 안 된다. 선택 3자리 포맷
                //   '#,##0.###' 하나로 양쪽을 수용(트레일링 0 은 자동 생략되어 2자리 값도 그대로 표시).
                format: '#,##0.###',
              })),
          })),
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, bucketType, chkSum]);

  // Fix 정보(O_RC3) — D_ 컬럼 하이라이트(design 03 §2.5).
  const fixedDayBindings = useMemo(() => {
    const set = new Set<string>();
    fixInfoRows.forEach(r => {
      if (r.YYYYMMDD) set.add(r.YYYYMMDD);
    });
    return set;
  }, [fixInfoRows]);

  // Weekly 시 W_ 헤더까지 확산(design 03 §2.5/R-F) — Fix된 일자가 속한 주의 W_ binding 을
  //   weekOrMonthStart(BASIS_START_DATE) 매칭으로 역추적. calendar SP 가 D_ 행에 BASIS_START_DATE 를
  //   채우지 않으면(확인 필요) 이 Set 은 비어 있어 기존 D_ 전용 하이라이트만 재현된다(안전 degrade).
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
    queryFromYyyymmdd: fromYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    weekOrMonthStart,
  });
  editCtxRef.current = { bucketType, division, planStartYyyymmdd, queryFromYyyymmdd: fromYyyymmdd, queryToYyyymmdd: toYyyymmdd, weekOrMonthStart };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집잠금(§0 정보컬럼 전건 잠금 + R-K SHIP_PLAN_AMEND 판정) — beginningEdit 게이트.
    // 주의(R1 결함 수정, gap-resolve iter-1): 공용 DataGrid wrapper 의 setEditableColumns 가
    //   먼저 등록하는 beginningEdit 핸들러(dataGridUtils.ts)는 admin 메타 INPUT_TP_CD 기준으로
    //   cancel=true 를 세운다(이 화면은 전 정보컬럼 'S', 동적 pivot 컬럼은 메타 자체가 없어 역시 default
    //   분기로 cancel=true). wijmo Event 는 등록 순서대로 같은 EventArgs 를 누적 판정하므로(FIFO),
    //   editable 로 판정된 분기에서도 명시적으로 e.cancel=false 로 되돌리지 않으면 wrapper 의 1차
    //   취소가 그대로 유지되어 편집모드 진입 자체가 막힌다(SalesFuturePriceGrid.tsx L594-616 동일 패턴
    //   참조 — "FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper 보다 우선").
    const beginningEditHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !row || !isMainCellEditable(binding, row, editCtxRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트(R1 수정) — wrapper 의 pastingCell 핸들러(dataGridUtils.ts:385)도 동일하게
    //   admin 메타 기준 cancel=true 만 세우고 화면이 되돌리지 않아 붙여넣기가 항상 차단돼 있었다.
    //   beginningEdit 와 동일 판정 로직을 paste 경로에도 적용한다.
    const pastingCellHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !row || !isMainCellEditable(binding, row, editCtxRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 저장 값 검증(cellEditEnded) — 음수/상한 초과(design 03 §4.3, MSG 코드는 gap-resolve iter-1
    //   NEW8 — 원 AS-IS 코드 MSG00084/MSG00317 는 TO-BE 미등록이라 production-plan-line 이 미러링한
    //   대체 등록코드(MSG.QTY_NEGATIVE=MSG00225/MSG.QTY_MAX=MSG00165)를 그대로 재사용한다).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!binding.startsWith('D_') && !binding.startsWith('W_') && !binding.startsWith('M_')) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const qty = Number(row[binding]);
      if (!Number.isFinite(qty)) return;
      if (qty < 0) {
        setToast({ type: 'error', message: t(MSG.QTY_NEGATIVE, '_Value must not be negative.') });
        row[binding] = 0;
      } else if (qty > QTY_MAX) {
        setToast({ type: 'error', message: t(MSG.QTY_MAX, '_Value exceeds maximum(99999999).') });
        row[binding] = QTY_MAX;
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 더블클릭 5-가드(design 03 §3 R-Q + 발견분, checklist buttonGuards #23) -> Pegging/PlanProblem 드릴다운.
    //   ① chkAll 미체크 시 차단(!chkAll.Checked) ② Bucket-컬럼태그 일치(현재 표시중인 kind 만)
    //   ③ 데이터영역(정보컬럼 제외) ④ D_컬럼만 ⑤ MEASURE==='MKT_FCST' 만(발견분, §3 R-Q).
    const dblclickHandler = (ev: MouseEvent) => {
      if (!chkAll) return; // ① checklist #23 — 전체보기 미체크 시 더블클릭 상세조회 차단
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const kind = dynColKindOf(binding);
      if (!kind || kind !== 'D') return; // ③④ 데이터영역 + D_ 컬럼만
      if (bucketType !== BUCKET_TYPE.DAILY && bucketType !== BUCKET_TYPE.WEEKLY) return; // ② Bucket 태그 일치
      const row = g.rows[ht.row]?.dataItem as MainRow | undefined;
      if (!row) return;
      const rowRec = row as unknown as Record<string, unknown>;
      if (s(rowRec.measure) !== DRILLDOWN_MEASURE) return; // ⑤ MEASURE==='MKT_FCST'
      onCellDoubleClick(row, binding.slice(2));
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // Fix 하이라이트(D_ 매칭, design 03 §2.5) + SHIP_PLAN_AMEND 입력밴드(R-G) — formatItem.
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
      if (dataItem && s(dataItem.measure) === 'SHIP_PLAN_AMEND' && dynColKindOf(binding)) {
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
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.formatItem?.removeHandler(formatItemHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns, bucketType, chkAll, fixedDayBindings, fixedWeekStarts, weekOrMonthStart]);

  return (
    <>
      {/* 영역3 그리드 툴바 — Bucket/Sum/Column/Measure(design 00_checklist §1 area=3 분류) */}
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
        <span>{t(LBL.SUM, '_Sum')}</span>
        {showColumnButton && (
          <Button appearance='outlined' priority='normal' onClick={onOpenColumnSetup}>
            {t(LBL.COLUMN, '_Column')}
          </Button>
        )}
        {showMeasureButton && (
          <Button appearance='outlined' priority='normal' onClick={onOpenMeasureSetup}>
            {t(LBL.MEASURE, '_Measure')}
          </Button>
        )}
      </div>
      <DataGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={staticColumns}
        dynamicColumns={dynamicColumns as unknown as FlexGridColumnConfig[]}
        allowMerging={AllowMerging.All}
        gotFocus={onFocus}
      />
    </>
  );
};
