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

import { BUCKET_TYPE } from '../production-plan-line.constants';
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
  // 회색(실적) 음영 기준 = 선택 Plan Date(AS-IS Set_ProductResult: D_(plan_start-1)까지 회색). 이 값 이전 날짜 셀만 회색.
  planStartYyyymmdd: string;
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

// leaf(최하단) 헤더 row 의 동적(pivot) 컬럼은 '가로' 병합만 막는다 — leaf 가 전부 'SUM' 이라 기본
//   CustomMergeManager(값 기준)에 맡기면 주/월 경계를 넘어 한 칸으로 합쳐질 수 있다(AS-IS 는 주마다 SUM 분리).
//   단 '세로' 병합(월 SUM 컬럼의 2단='SUM' + 3단 leaf='SUM' → 한 칸)은 유지한다(사용자 지시 2026-11-11) —
//   베이스가 이 월 SUM 2×1 세로 스팬을 이미 계산하므로(mergeManager _isSameHorizontalRange 주석), 세로
//   범위는 그대로 돌려주고 가로 범위(여러 컬럼)일 때만 차단한다. 월/주 라벨 가로병합·좌측 고정컬럼 세로
//   스팬·데이터 셀 병합은 super 에 위임해 그대로 둔다.
class ProductionPlanLineMergeManager extends CustomMergeManager {
  getMergedRange(panel: GridPanel, currentRow: number, currentCol: number): CellRange | null {
    const range = super.getMergedRange(panel, currentRow, currentCol);
    if (
      range &&
      range.col !== range.col2 && // 가로(여러 컬럼) 범위만 차단 — 세로(월 SUM 2×1)는 유지
      panel.cellType === CellType.ColumnHeader &&
      currentRow === panel.rows.length - 1 &&
      pivotKind(panel.columns[currentCol]?.binding ?? '') !== null
    ) {
      return null;
    }
    return range;
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
  planStartYyyymmdd,
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
    const applyHeaderHeight = (canInvalidate: boolean) => {
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
      if (changed && canInvalidate) grid.invalidate(true);
    };
    applyHeaderHeight(true);
    // refreshing(렌더 전)에도 맞춘다 — Weekly/Monthly Sum 토글로 pivot 컬럼이 재생성될 때, updatedLayout
    //   (레이아웃 계산 후)에서만 줄이면 재생성된 다단 헤더가 '기본(큰) 높이'로 한 프레임 먼저 그려졌다
    //   48/tier 로 줄어드는 깜빡임이 난다. refreshing 은 진행 중 refresh 라 invalidate 하면 재진입 루프가
    //   되므로 여기선 크기만 세팅(canInvalidate=false)해 같은 refresh 가 처음부터 48/tier 로 그리게 한다.
    grid.refreshing.addHandler(() => applyHeaderHeight(false));
    grid.updatedLayout.addHandler(() => applyHeaderHeight(true));
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
  const planStartRef = useRef(planStartYyyymmdd);
  planStartRef.current = planStartYyyymmdd;
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

        // 실적/과거 구간 회색 (AS-IS Set_ProductResult cs:1130~1143) — '선택 Plan Date 이전' 날짜
        //   (D_(plan_start-1)까지)를 실적으로 회색 처리한다. 편집잠금(cutoff=이번 주 월요일)과는 별개 기준이라
        //   회색만 plan_start 로 맞춘다(사용자 지시 2026-11-11, 종전 cutoff 기준 오류 교정). Period from>=plan_start
        //   면 이전 날짜 셀이 없어 자연히 회색 없음(AS-IS from<plan_start 게이트 + chkAll 상시 등가).
        if (isPastPivot(binding, planStartRef.current))
          ev.cell.style.backgroundColor = CELL_COLOR.PAST_GRAY;

        // 편집가능 pivot 셀 노란색 (수정가능 표시 — AS-IS Set_FPOperationColor 편집밴드의 TO-BE 치환).
        //   전건 INPUT_TP_CD='S' 라 공용 formatEditableColumns(wj-cell-editable) 이 안 걸리므로 여기서
        //   직접 칠한다. isPivotCellEditable 이 measure(AMEND)·bucket 편집kind·미래·행편집가능(new_edit_mode
        //   포함)을 이미 종합하므로 참이면 진짜 편집셀이다. 과거회색을 덮고, fix 녹색엔 덮인다(아래 우선).
        if (
          isPivotCellEditable(
            binding,
            dataItem,
            bucketRef.current,
            ctxRef.current,
            cutoff,
            editInfoRef.current
          )
        ) {
          ev.cell.style.backgroundColor = CELL_COLOR.EDIT_YELLOW;
        }

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
            // 부하율 100% 미만 빨간 강조 (design 03 §3.8 #65 — LINE_TOTAL<100 SetCellForeColor).
            //   Bucket=Daily 일 때만 표시한다(사용자 지시 2026-11-11) — Weekly/Monthly 버킷에서는 강조 안 함.
            //   소수 표기(toFixed)는 버킷 무관 유지.
            if (raw < LINE_TOTAL_WARN_THRESHOLD && bucketRef.current === BUCKET_TYPE.DAILY) {
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
