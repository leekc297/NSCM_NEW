import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { BUCKET_TYPE } from '../production-plan-line.constants';
import { LINE_TOTAL_MEASURE_PREFIX } from '../production-plan-line.constants';
import type { MainRow } from '../production-plan-line.types';
import { buildFixedColumns, buildPivotColumns } from '../utils/productionPlanLineColumns';
import { distributeWeeklyToDaily, isoWeek, sumValues, toNum } from '../utils/productionPlanLineDerive';
import {
  type EditContext,
  isPivotCellEditable,
  pivotKind,
  thisWeekMonday,
  type VisibilityContext,
} from '../utils/productionPlanLineEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  editContext: EditContext;
  visibilityCtx: VisibilityContext;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// D_ 셀 키 → yyyymmdd. W_/M_ 키 → yyyymm(앞 6자리). pivot tag 파싱.
const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// 같은 주(ISO)의 하위 D_ 키 (design 03 §3 #8 — W_ → D_ 분배 대상).
//   W_ tag 는 BASIS_YYYYMM + ISO_WEEK(design 03 §2.1). 주차/연도로 D_ 를 매칭한다.
//   주의: TO-BE RC1 동적 컬럼 명명은 런타임 확정(design 03 §6 확인필요) — isoWeek 매칭으로 근사.
const dailyKeysOfWeek = (rowKeys: string[], weekBinding: string): string[] => {
  const tag = pivotTag(weekBinding);
  const year = tag.slice(0, 4);
  const weekNum = Number(tag.slice(6)) || Number(tag.slice(4, 6));
  return rowKeys.filter(k => {
    if (pivotKind(k) !== 'D') return false;
    const d = pivotTag(k);
    return d.slice(0, 4) === year && isoWeek(d) === weekNum;
  });
};

// 같은 월의 하위 D_ 키 (design 03 §2.4 CalculateSum M_ 재집계).
const dailyKeysOfMonth = (rowKeys: string[], ym: string): string[] =>
  rowKeys.filter(k => pivotKind(k) === 'D' && pivotTag(k).slice(0, 6) === ym);

// AS-IS GSCM.SCP.Analysis.UIL SCP0013 spdMain — 27 고정 + D_/W_/M_ 동적 pivot(3단 헤더).
//   설계: design 03. 편집은 PROD_PLAN_AMEND 행의 bucket 편집 kind 셀만(productionPlanLineEditLock).
//   저장/조회 실행체인은 SCM_ADM_MNU_BTN_MPG_M 미배선(design 03 §6) — SP 배포는 완료(PKG_SCP0013 VALID).
export const ProductionPlanLineGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  bucket,
  chkSum,
  editContext,
  visibilityCtx,
  adminColumns,
  onFocus,
}: Props) => {
  const cutoff = useMemo(() => thisWeekMonday(), []);

  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, visibilityCtx),
    [adminColumns, visibilityCtx]
  );
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSum),
    [rows, bucket, chkSum]
  );

  // 최신 값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const bucketRef = useRef(bucket);
  bucketRef.current = bucket;
  const ctxRef = useRef(editContext);
  ctxRef.current = editContext;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전 컬럼 읽기전용 + pivot 편집셀만 해제 (design 01 G2 / 03 §3 #10, #4).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      if (!isPivotCellEditable(binding, row, bucketRef.current, ctxRef.current, cutoff)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // pivot Auto-Sync (design 03 §3 #7~#9) — W_ 편집 시 하위 D_ 균등분배(+나머지) / 음수는 일합계 원복,
    //   D_ 편집 시 상위 W_·M_ 재집계. LINE_TOTAL% measure 는 평균이라 재분배 제외(단순 표시).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const kind = pivotKind(binding);
      if (kind === null || kind === 'B') return;
      if (s(row.MEASURE).startsWith(LINE_TOTAL_MEASURE_PREFIX)) return; // % measure 는 재분배 안 함

      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };
      const rowKeys = Object.keys(row);

      if (kind === 'W') {
        const dayKeys = dailyKeysOfWeek(rowKeys, binding);
        const weekVal = toNum(row[binding]) ?? 0;
        if (weekVal < 0) {
          // 음수 입력 → 하위 일합계로 원복 (design 03 §3 #7).
          setCell(binding, sumValues(dayKeys.map(k => row[k])));
        } else if (dayKeys.length > 0) {
          // 균등분배 + 나머지 마지막 셀 (design 03 §3 #8/#9).
          const dist = distributeWeeklyToDaily(weekVal, dayKeys.length);
          dayKeys.forEach((k, i) => setCell(k, dist[i]));
        }
      } else if (kind === 'D') {
        // 상위 W_·M_ 재집계 (design 03 §2.4 CalculateSum).
        const dTag = pivotTag(binding);
        const ym = dTag.slice(0, 6);
        const weekNum = isoWeek(dTag);
        const weekKey = rowKeys.find(
          k => pivotKind(k) === 'W' && pivotTag(k).slice(0, 4) === dTag.slice(0, 4) && (Number(pivotTag(k).slice(6)) || Number(pivotTag(k).slice(4, 6))) === weekNum
        );
        if (weekKey) setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        const monthKey = rowKeys.find(k => pivotKind(k) === 'M' && pivotTag(k).slice(0, 6) === ym);
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, ym).map(k => row[k])));
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 주말 헤더 색 (design 03 §2.2 — 토 Blue / 일 Red, DAY_CODE). D_ leaf 헤더의 요일 판정.
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      if (ev.panel.cellType !== CellType.ColumnHeader) return;
      const col = ev.panel.columns[ev.col];
      const binding = col?.binding ?? '';
      if (pivotKind(binding) !== 'D') return;
      const d = pivotTag(binding);
      if (d.length < 8) return;
      const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
      const dow = date.getUTCDay();
      if (dow === 6) ev.cell.style.color = '#1976d2'; // 토 Blue
      else if (dow === 0) ev.cell.style.color = '#d32f2f'; // 일 Red
    };
    g.formatItem.addHandler(formatHandler);

    // 고정 식별 컬럼 셀 병합 — AS-IS siMain.SmartColMerge (design 03 §3 #1/#2/#11).
    //   공용 CustomMergeManager 가 좌측 누적 키로 선행 식별컬럼만 계층 병합(신규행 CRUD_TYPE='I' 제외).
    //   pivot 컬럼은 병합 대상 아님(buildPivotColumns 에서 allowMerging=false).
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = pivotKind(b) === null;
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns, cutoff]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
