import {
  AllowMerging,
  type CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, type EditTracker, ensureTopLeftMergeManager } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { BUCKET_TYPE } from '../production-plan-line.constants';
import {
  CELL_COLOR,
  EDITABLE_MEASURE,
  LINE_TOTAL_DECIMALS,
  LINE_TOTAL_MEASURE_PREFIX,
  LINE_TOTAL_WARN_THRESHOLD,
} from '../production-plan-line.constants';
import type { MainRow } from '../production-plan-line.types';
import { buildFixedColumns, buildPivotColumns } from '../utils/productionPlanLineColumns';
import { distributeWeeklyToDaily, isoWeek, sumValues, toNum } from '../utils/productionPlanLineDerive';
import {
  type DrilldownState,
  EMPTY_DRILLDOWN,
  toggleDrilldown,
} from '../utils/productionPlanLineDrilldown';
import {
  buildFixKey,
  type EditContext,
  type EditInfoMap,
  isPastPivot,
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
  // chkAll(전체보기) — 드릴다운 가드: !chkAll 이고 현재 버킷 leaf(Monthly M_/Weekly W_) 더블클릭은 무시.
  chkAll: boolean;
  editContext: EditContext;
  visibilityCtx: VisibilityContext;
  adminColumns?: RawFlexGridColumnConfig[];
  // 행별 편집판정 서버원천 (M4c — CP_KEY→EDIT_INFO 엔트리). beginningEdit/pastingCell 가 소비.
  editInfoMap: EditInfoMap;
  // fix 확정 셀 키 집합 (M4a/M2 — `${FIX_KEY}|${D_/W_ 컬럼키}`). formatHandler 가 녹색 판정.
  fixCellSet: Set<string>;
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// D_ 셀 키 → yyyymmdd. W_/M_ 키 → yyyymm(앞 6자리). pivot tag 파싱.
const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// 헤더 총높이 48px — DMF0082(ForecastPriceGrid) 와 동일 로직. 실헤더 행 수로 나눠 각 행에 강제
//   (정적/1단=48 · 2단=24 · 3단=16). 빈 그리드(1단)가 DMF0082 처럼 48px 로 넉넉해진다.
const HEADER_TOTAL_HEIGHT = 48;

// leaf(최하단) 헤더 row 의 동적(pivot) 컬럼은 가로 병합하지 않는다 — leaf 가 전부 'SUM' 이라 기본
//   CustomMergeManager(값 기준)에 맡기면 주/월 경계를 넘어 한 칸으로 합쳐진다(AS-IS 는 주마다 SUM 분리).
//   월/주(상위 row 라벨 병합)·좌측 고정컬럼 세로 스팬·데이터 셀 병합은 super 에 위임해 그대로 둔다.
class ProductionPlanLineMergeManager extends CustomMergeManager {
  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    if (
      panel.cellType === CellType.ColumnHeader &&
      currentRow === panel.rows.length - 1 &&
      pivotKind(panel.columns[currentCol]?.binding ?? '') !== null
    ) {
      return null;
    }
    return super.getMergedRange(panel, currentRow, currentCol);
  }
}

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
//   저장/조회 실행체인 배선: SCM_ADM_MNU_BTN_MPG_M 3행(main/SEARCH·main/SAVE·load/SEARCH) 등록됨
//   (ora.py 2026-09-18). SP 배포 완료(PKG_SCP0013 VALID). design 03 §6 / 05_register.sql.
export const ProductionPlanLineGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  bucket,
  chkSum,
  chkAll,
  editContext,
  visibilityCtx,
  adminColumns,
  editInfoMap,
  fixCellSet,
  onFocus,
}: Props) => {
  const cutoff = useMemo(() => thisWeekMonday(), []);

  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, visibilityCtx),
    [adminColumns, visibilityCtx]
  );
  // 드릴다운(월→주→일 전개) 상태 — 헤더 더블클릭으로 토글. 조회/버킷/Sum 변경 시 리셋(아래 effect).
  //   AS-IS SpdInfo.SetDblClickColumnShowHide 의 컬럼 Visible 토글을 React 상태로 옮긴 것(design 03 §2.4).
  const [drilldown, setDrilldown] = useState<DrilldownState>(EMPTY_DRILLDOWN);
  useEffect(() => {
    setDrilldown(EMPTY_DRILLDOWN);
  }, [rows, bucket, chkSum]);

  // 데이터에 존재하는 전 pivot 바인딩(D_/W_/M_) — 드릴다운 토글이 형제 컬럼(같은 월/주)을 찾는 근거.
  const allPivotBindings = useMemo(() => {
    const set = new Set<string>();
    for (const r of rows as unknown as Record<string, unknown>[]) {
      for (const k of Object.keys(r)) {
        const pk = pivotKind(k);
        if (pk !== null && pk !== 'B') set.add(k);
      }
    }
    return [...set];
  }, [rows]);

  // 동적 pivot 셀 숫자 입력 제한(양수·정수) — numberRules prop(binding 키)으로 전달. positiveOnly/integerOnly 를
  //   컬럼 객체에 직접 실으면 Wijmo ColumnGroup 파싱이 "Unknown property" assert 로 그리드를 깨뜨린다
  //   (다단 헤더 — Daily 등, productionPlanLineColumns 주석 참조). 그래서 binding→rule 맵으로 넘긴다.
  const pivotNumberRules = useMemo(
    () => Object.fromEntries(allPivotBindings.map(b => [b, { positiveOnly: true, integerOnly: true }])),
    [allPivotBindings]
  );

  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSum, drilldown),
    [rows, bucket, chkSum, drilldown]
  );
  // 그리드 초기화 1회(공용 DataGrid 가 init 끝에서 호출) — effect 로 하면 DataGrid init 순서와 경쟁해
  //   헤더가 리셋되는 레이스가 나므로, 둘 다 전달받은 grid 로 여기서 처리한다.
  //   ① leaf SUM 가로병합 방지 전용 머지매니저(기본 CustomMergeManager 교체 후 TopLeft 보강).
  //   ② 헤더 행 높이 DMF0082 동일(총 48/tier) 강제 — 공용 매핑이 명시 height:48 을 박아 defaultSize 가
  //      무시되므로 각 헤더 row 에 직접 쓴다. 컬럼그룹 재대입마다 되돌아가 updatedLayout 에 재적용한다.
  const handleGridInitialized = useCallback((grid: FlexGridType) => {
    // DataGrid 가 넘겨준 자기 그리드라 캐스팅 안전(CustomMergeManager<WijmoRowItem> 기대 타입과 동일 인스턴스).
    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    grid.mergeManager = new ProductionPlanLineMergeManager(grid);
    ensureTopLeftMergeManager(grid);
    const applyHeaderHeight = () => {
      const hdrRows = grid.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      const targetHeight = Math.round(HEADER_TOTAL_HEIGHT / hdrRows.length);
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== targetHeight) {
          hdrRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== targetHeight) {
        hdrRows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    applyHeaderHeight();
    grid.updatedLayout.addHandler(applyHeaderHeight);
  }, []);

  // 최신 값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const bucketRef = useRef(bucket);
  bucketRef.current = bucket;
  const ctxRef = useRef(editContext);
  ctxRef.current = editContext;
  const editInfoRef = useRef(editInfoMap);
  editInfoRef.current = editInfoMap;
  const fixSetRef = useRef(fixCellSet);
  fixSetRef.current = fixCellSet;
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;
  const chkAllRef = useRef(chkAll);
  chkAllRef.current = chkAll;
  const allBindingsRef = useRef(allPivotBindings);
  allBindingsRef.current = allPivotBindings;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 조회직후 전 컬럼 읽기전용 + pivot 편집셀만 해제 (design 01 G2 / 03 §3 #10, #4).
    //   주의: 공용 DataGrid setEditableColumns 가 beginningEdit/pastingCell 에 cancel=!isEditableCell 을
    //   먼저 건다. 고정 27컬럼과 pivot 컬럼은 모두 _inputEditType='S'(SEARCH_ONLY)라 isEditableCell 이
    //   전건 false → 공용 가드가 cancel=true 로 막는다(SCM_MST_SHEET_COLUMNS 전열 'S' 함정). 이 핸들러는
    //   자식 grid init(setEditableColumns) 뒤에 등록되므로(부모 useEffect, FIFO-last) 편집 가능한 pivot
    //   셀은 반드시 cancel=false 로 되돌려야 편집이 열린다 — true 만 세우면 공용 cancel 이 남아 전 셀
    //   편집불가(edit-dead)가 된다(BusinessPlanGrid 동일 패턴).
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
      e.cancel = !isPivotCellEditable(
        binding,
        row,
        bucketRef.current,
        ctxRef.current,
        cutoff,
        editInfoRef.current
      );
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기 게이트 — 공용 pastingCell(cancel=!isEditableCell)도 편집가능 pivot 셀을 막으므로 동일 판정으로 되돌린다.
    g.pastingCell.addHandler(beginningEditHandler);

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

    // 주말 헤더 색(design 03 §2.2 — 토 Blue / 일 Red) + LINE_TOTAL% measure 행 소수 2자리(design 03 §1 #6/#7).
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (ev.panel.cellType === CellType.ColumnHeader) {
        // D_ leaf 헤더의 요일 판정.
        if (pivotKind(binding) !== 'D') return;
        const d = pivotTag(binding);
        if (d.length < 8) return;
        const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        const dow = date.getUTCDay();
        if (dow === 6) ev.cell.style.color = '#1976d2'; // 토 Blue
        else if (dow === 0) ev.cell.style.color = '#d32f2f'; // 일 Red
        return;
      }
      if (ev.panel.cellType === CellType.Cell) {
        if (pivotKind(binding) === null) return; // 고정 컬럼은 색상/스케일 대상 아님
        const dataItem = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
        if (!dataItem) return;
        const isLineTotal = s(dataItem.MEASURE).startsWith(LINE_TOTAL_MEASURE_PREFIX);

        // 실적/과거(편집불가) 구간 회색 (design 03 §3.8 #34/#61 — SetCellBackColor 회색).
        //   cutoff(이번 주 월요일) 이전 pivot 셀은 실적 확정 구간이라 회색 배경으로 재현.
        if (isPastPivot(binding, cutoff)) ev.cell.style.backgroundColor = CELL_COLOR.PAST_GRAY;

        // fix 확정 셀 녹색 (M4a/M2 — design 03 §3.8 #62~64 / AS-IS Set_FixCellColor cs:3621~3653).
        //   O_RC2(dtFix) FIX_KEY 8필드 + 기간키 매칭. PROD_PLAN_AMEND 행만(cs:3606). 과거회색보다 우선.
        //   Daily=D_·W_, Weekly=W_ 셀(fixCellSet 이 두 키를 모두 담음 — 보이는 버킷 셀만 매칭됨).
        if (s(dataItem.MEASURE) === EDITABLE_MEASURE) {
          const fixKey = buildFixKey(dataItem);
          if (fixSetRef.current.has(`${fixKey}|${binding}`)) {
            ev.cell.style.backgroundColor = CELL_COLOR.FIX_GREEN;
          }
        }

        if (isLineTotal) {
          // LINE_TOTAL(%) measure 행의 pivot 셀만 소수 2자리로 재렌더 — 나머지 QTY 는 컬럼 format 'n0'(정수).
          //   Wijmo 컬럼 format 은 컬럼단위라 행별 스케일 불가 → 이 행에서만 텍스트를 소수 표기로 덮어쓴다.
          const raw = toNum(dataItem[binding]);
          if (raw !== null) {
            ev.cell.textContent = raw.toFixed(LINE_TOTAL_DECIMALS);
            // 부하율 100% 미만 강조 (design 03 §3.8 #65 — LINE_TOTAL<100 SetCellForeColor).
            if (raw < LINE_TOTAL_WARN_THRESHOLD) {
              ev.cell.style.color = CELL_COLOR.UNDER_100;
              ev.cell.style.fontWeight = 'bold';
            }
          }
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 드릴다운 — 헤더 leaf(최하단 tier) 더블클릭으로 월→주→일 전개/접기 (design 03 §2.4 / AS-IS
    //   SpdMain_CellDoubleClick cs:4029~4052 → SetDblClickColumnShowHide). leaf tier 만 처리해
    //   AS-IS 'SUM' 셀 더블클릭(월/주 합계)과 등가로 맞춘다 — 상위 월 span 헤더 클릭은 무시.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hdrRows = g.columnHeaders?.rows;
      if (!hdrRows || ht.row !== hdrRows.length - 1) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      setDrilldown(prev =>
        toggleDrilldown(
          prev,
          binding,
          allBindingsRef.current,
          bucketRef.current,
          chkSumRef.current,
          chkAllRef.current
        )
      );
    };
    g.hostElement?.addEventListener('dblclick', dblClickHandler);

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
        g.pastingCell?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
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
      numberRules={pivotNumberRules}
      allowMerging={AllowMerging.All}
      initialized={handleGridInitialized}
      gotFocus={onFocus}
    />
  );
};
