import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  MEASURE_NAME_BG,
  MEASURE_BG,
  PAST_INVENTORY_MEASURES,
  PIVOT_PREFIX,
  UNIT_QTY_SCALE,
} from '../global-psi-report.constants';
import {
  buildFixedColumns,
  buildPivotColumns,
  calendarColsFromRows,
  isPivotBinding,
  toCalendarCols,
  type CalendarCol,
} from '../utils/globalPsiReportColumns';
import { ReportHeaderMergeManager } from '../utils/globalPsiReportMerge';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// measure 색 시작 열 — AS-IS Set_MeasureColor 는 measure_label(Measure Name) 열부터 값 영역까지만 칠하고
//   앞쪽 차원 컬럼(Div/Cell Group/… 세로병합)은 흰색 유지한다. SCP0100 measure_label binding = 'MEASURE_NAME'
//   (SCM_MST_SHEET_COLUMNS 실측). 자매 SCP0031 GlobalPsiGrid 의 MEASURE_LABEL_BINDING 과 동형.
const MEASURE_LABEL_BINDING = 'MEASURE_NAME';

// 헤더 총높이 고정(hook #93, 형제 GlobalPsiElecGrid/DemandPlanWaterfallGrid 동형) — 보이는 tier 수로 나눠
//   전 헤더 row 에 강제한다(아래 applyHeaderHeight). WEEKLY=월>주>Qty 3단→16 / MONTHLY=월>Qty 2단→24.
//   공용 mapRawColumnsToWijmoColumns 가 정적 컬럼을 1단(height:48)으로 박아, pivot 3단이 되면 48×3=144px 로
//   헤더가 벌어지므로 실제 렌더 tier 수로 재분배해 다른 화면과 동일한 48px 총높이를 유지한다.
const HEADER_TOTAL_HEIGHT = 48;

interface Props {
  // 활성 시트 데이터 행 (searchMode/searchLevel 로 선택된 1개 시트 — page 가 결정, design 01 R1~R3).
  rows: Record<string, unknown>[];
  // 활성 시트 admin 고정 컬럼 (SCM_MST_SHEET_COLUMNS, design 03 §1). page 가 시트별로 선택해 전달.
  adminColumns: RawFlexGridColumnConfig[];
  // CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환행 — 동적 pivot 3단 헤더 원천. 0건이면 데이터 union 폴백.
  calendarRows: Record<string, unknown>[] | undefined;
  // BucketType(MONTHLY/WEEKLY) — M_/W_ pivot 가시성 토글(design 03 §2.5). 서버 재조회 없는 클라 전환.
  bucket: string;
  // Plan 시작일(YYYYMMDD) — 헤더 색: 해당 월(M_YYYYMM) Red / 주(W_..A·B) Blue(design 03 §2.4).
  planStartYyyymmdd: string;
  // Unit(Qty) 로컬 표시배율 index (design 02 §2.5). pivot 셀 값 = 원값 / UNIT_QTY_SCALE[index]. 서버 재조회 없음.
  unitScaleIndex: number;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  onFocus: () => void;
}

// AS-IS GSCM.SCP.Forms.UIL/Report/SCP0100_Global_PSI_Report spdDetail/spdSearchLevel/spdSearchLevelDetail —
//   고정 차원 컬럼(SCM_MST_SHEET_COLUMNS 메타) + 서버측 동적 M_/W_ PIVOT(GET_SHEET_CALENDAR_3SPAN 3단 헤더).
//   read-only 리포트라 편집/셀콤보/병합관리자 없음 — 색(measure BG 8그룹·plan_start 헤더색·과거구간 회색)만
//   formatItem 으로 재현(design 03 §3-B/§2.4). Unit(Qty) 로컬 배율은 pivot 셀 표시값 나눗셈(design 02 §2.5).
export const GlobalPsiReportGrid = ({
  rows,
  adminColumns,
  calendarRows,
  bucket,
  planStartYyyymmdd,
  unitScaleIndex,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(() => buildFixedColumns(adminColumns), [adminColumns]);

  // CALENDAR 메타 우선, 0건이면 데이터 행 union 폴백(design 03 §2 mkt-fcst 폴백 규약).
  //   calendarCols 는 pivot 컬럼 '구조'(binding/label/정렬/dayCode)만 쓴다 — 셀 값과 무관하다. 그래서
  //   조회/재조회처럼 값만 바뀌고 구조가 같을 때 rows 참조가 새로 와도 재생성하지 않도록, 구조
  //   시그니처가 바뀔 때만 새 배열을 만든다(자매 SCP0098 CapaMobilityItGrid dynBindingSig 선례).
  //   재생성하면 columnGroups 가 새 배열이 되어 wijmo 가 컬럼을 통째로 다시 만들고, 그때 다단 헤더가
  //   기본 높이(48×tier)로 부풀었다가 48px(아래 applyHeaderHeight)로 줄어 '헤더가 커졌다 줄어드는'
  //   깜빡임이 조회마다 생긴다(사용자 신고 2026-10-22).
  const calendarSig = useMemo(() => {
    const fromSp = toCalendarCols(calendarRows);
    const cols = fromSp.length > 0 ? fromSp : calendarColsFromRows(rows);
    return cols
      .map(c => `${c.columnName}|${c.largeLabel}|${c.smallLabel}|${c.sortOrder}|${c.dayCode}`)
      .join(',');
  }, [calendarRows, rows]);
  const calendarCols = useMemo<CalendarCol[]>(
    () => {
      const fromSp = toCalendarCols(calendarRows);
      return fromSp.length > 0 ? fromSp : calendarColsFromRows(rows);
    },
    // 구조 시그니처로 대표 — 행 데이터 값만 바뀌면 참조를 그대로 유지한다(헤더 깜빡임 제거).
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [calendarSig]
  );

  const pivotColumns = useMemo(
    () => buildPivotColumns(calendarCols, bucket),
    [calendarCols, bucket]
  );

  // 색 핸들러가 최신값을 stale 없이 참조 (핸들러는 mount 후 등록).
  const planStartMonth = planStartYyyymmdd ? planStartYyyymmdd.slice(0, 6) : '';
  const planStartMonthRef = useRef(planStartMonth);
  planStartMonthRef.current = planStartMonth;

  // Unit(Qty) 배율 — AS-IS SetCalculating(cs:1620~1649)처럼 데이터 값 자체를 배율로 나눠(소수 2자리 반올림,
  //   cs:1635 Math.Round(v/dbDivide,2)) 바꾼다. 표시 전용 DOM 가공이 아니라 데이터에 반영해야 Excel 내려받기
  //   (FlexGridXlsxConverter 가 그리드 데이터값을 읽음 — DOM textContent 는 무시)에도 배율이 실린다.
  //   원본 rows 는 불변 — 배율 변경 시 pristine rows 에서 매번 재계산(QTY/1 복귀 시 원값 복원). pivot(M_/W_/B_)
  //   숫자 셀만 나눈다(차원 컬럼·문자 셀 불변). 표시 소수는 pivot 컬럼 format '#,##0.##', Excel 은 _excelFormat 정수.
  const scaledRows = useMemo(() => {
    const scale = UNIT_QTY_SCALE[unitScaleIndex] ?? 1;
    if (scale <= 1) return rows;
    return rows.map(row => {
      const next: Record<string, unknown> = { ...row };
      for (const key of Object.keys(next)) {
        if (!isPivotBinding(key)) continue;
        const v = next[key];
        if (typeof v === 'number' && Number.isFinite(v)) {
          next[key] = Math.round((v / scale) * 100) / 100;
        }
      }
      return next;
    });
  }, [rows, unitScaleIndex]);

  // 과거구간(plan_start 이전) pivot 바인딩 집합 — AS-IS SetBackColor 과거 회색(MONTHLY cs:993 / WEEKLY cs:1023).
  //   M_: 월(YYYYMM) < plan_start 월. W_: 주 시작일(DAY_CODE) < plan_start 포함 주의 시작일(그 주는 제외 — AS-IS
  //   colEnd = plan_start 주 index-1). plan_start 포함 주의 시작일 = DAY_CODE <= plan_start 중 최대값(폴백 ''는 skip).
  const pastBindings = useMemo(() => {
    const set = new Set<string>();
    const ps = planStartYyyymmdd;
    if (!ps) return set;
    const psMonth = ps.slice(0, 6);
    let planWeekStart = '';
    for (const c of calendarCols) {
      if (
        c.columnName.startsWith(PIVOT_PREFIX.WEEKLY) &&
        c.dayCode &&
        c.dayCode <= ps &&
        c.dayCode > planWeekStart
      ) {
        planWeekStart = c.dayCode;
      }
    }
    for (const c of calendarCols) {
      if (c.columnName.startsWith(PIVOT_PREFIX.MONTHLY)) {
        if (c.columnName.slice(2, 8) < psMonth) set.add(c.columnName);
      } else if (c.columnName.startsWith(PIVOT_PREFIX.WEEKLY)) {
        if (planWeekStart && c.dayCode && c.dayCode < planWeekStart) set.add(c.columnName);
      }
    }
    return set;
  }, [calendarCols, planStartYyyymmdd]);
  const pastBindingsRef = useRef(pastBindings);
  pastBindingsRef.current = pastBindings;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';

      // 헤더 색(design 03 §2.4) — 월(M_YYYYMM)이 plan_start 월이면 Red / 주(W_..A·B) 헤더면 Blue.
      //   ColumnHeader 패널의 어느 단(row)이든 자기 binding 접두로 판정한다(그룹 헤더도 leaf binding 상속).
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (!isPivotBinding(binding)) return;
        // leaf(Qty) 행은 색칠 안 함 — AS-IS 는 월/주 라벨만 색(plan_start 월 Red·주 A/B Blue)이고 Qty 는 검정.
        //   leaf = 최하단 헤더 행(월>주>Qty 의 Qty). 월(row0)·주(row1) 라벨 행만 대상. (사용자 신고 2026-10-14)
        if (ev.row === ev.panel.rows.length - 1) return;
        const month = planStartMonthRef.current;
        // AS-IS: 월 Red 는 ColumnHeader.Cells[0](row0=월 그룹행, cs:767), 주 Blue 는 Cells[1](row1=주행, cs:774/778).
        //   WEEKLY 3단(월>주>Qty)에서 월 그룹헤더(row0)도 W_ binding 을 상속하므로, 행을 구분하지 않으면 월 라벨까지
        //   파랑이 된다 → AS-IS 처럼 Red=row0 / Blue=row1 로 행을 한정한다.
        if (
          ev.row === 0 &&
          month &&
          binding.startsWith(PIVOT_PREFIX.MONTHLY) &&
          binding.slice(2, 8) === month
        ) {
          ev.cell.style.color = '#d32f2f'; // plan_start 월 헤더 Red (AS-IS Cells[0])
          ev.cell.style.fontWeight = 'bold';
        } else if (ev.row === 1 && binding.startsWith(PIVOT_PREFIX.WEEKLY)) {
          const tail = binding.slice(-1); // W_...A / W_...B
          if (tail === 'A' || tail === 'B') {
            ev.cell.style.color = '#1565c0'; // 주 A/B 헤더 Blue (AS-IS Cells[1])
            ev.cell.style.fontWeight = 'bold';
          }
        }
        return;
      }

      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;

      // measure 그룹 경계 구분선 — AS-IS SetBackColor(cs:877~953): MEASURE_GROUP 이 직전 행과 다르면 그 행
      //   상단에 DarkGray(169,169,169) 테두리(그룹 구분선). rowArrayBlack(검정)은 AS-IS cs:955 Clear 로 미사용
      //   → DarkGray 만 유효. 전열(고정 차원 + pivot)에 그린다(AS-IS Cells[iRow,0,iRow,colMax]) — pivot-only
      //   early return 보다 먼저 처리한다.
      if (ev.row > 0) {
        const prevItem = ev.panel.rows[ev.row - 1]?.dataItem as Record<string, unknown> | undefined;
        if (prevItem && s(row.MEASURE_GROUP) !== s(prevItem.MEASURE_GROUP)) {
          ev.cell.style.borderTop = '2px solid rgb(169, 169, 169)';
        }
      }

      // measure 행 배경색 8그룹 (design 03 §3-B) — MEASURE_NAME 정확 일치 스위치.
      //   AS-IS Set_MeasureColor 처럼 measure_label(MEASURE_NAME) 열 + 값(pivot) 영역에만 칠하고
      //   앞쪽 차원 컬럼(Div/Cell Group/Operation/Measure Group/Product Level …)은 흰색 유지한다
      //   (세로병합 시각 보존, 자매 SCP0031 GlobalPsiGrid 동형). 전 컬럼 칠하기 → 좌측 회색화 버그 교정.
      const bg = MEASURE_NAME_BG[s(row.MEASURE_NAME)];
      if (bg && (binding === MEASURE_LABEL_BINDING || isPivotBinding(binding))) {
        ev.cell.style.backgroundColor = bg;
      }

      // pivot 기간셀만 — 과거구간 회색 + Unit(Qty) 로컬 배율 + 음수 빨강(design 03 §3-B / design 02 §2.5).
      if (!isPivotBinding(binding)) return;

      // 과거구간 음영(design 03 §3-B) — plan_start 이전 기간칼럼 회색. AS-IS 는 MONTHLY(cs:993)·WEEKLY(cs:1023)
      //   양쪽 과거구간을 PAST 회색으로 칠한다(M_ 월·W_ 주 전부). pastBindings 가 M_(월<planStart월)·
      //   W_(주 시작일<planStart 포함 주 시작일)를 한 집합으로 판정한다. WEEKLY 재고성 measure × 과거 W_..A 는
      //   은색(cs:1066)으로 회색 위에 덮어쓴다. 은색 대상은 AS-IS switch(cs:1055~1061)의 7개 measure 로 한정한다
      //   (PAST_INVENTORY_MEASURES) — INVENTORY 배경 전체(9개)로 걸면 'Cell Inventory(Pack)'·'AS Inventory' 가
      //   AS-IS 와 달리 과잉 은색이 됨.
      const isPast = pastBindingsRef.current.has(binding);
      if (
        isPast &&
        binding.startsWith(PIVOT_PREFIX.WEEKLY) &&
        binding.slice(-1) === 'A' &&
        PAST_INVENTORY_MEASURES.has(s(row.MEASURE_NAME))
      ) {
        ev.cell.style.backgroundColor = MEASURE_BG.PAST_INVENTORY;
      } else if (isPast) {
        ev.cell.style.backgroundColor = MEASURE_BG.PAST;
      }

      // Unit(Qty) 배율은 데이터(scaledRows)에서 이미 적용됨 — 여기서는 표시 가공 안 함(design 02 §2.5).
      //   표시 소수 2자리는 pivot 컬럼 format '#,##0.##' 가, Excel 정수는 _excelFormat 이 담당(화면 상단 scaledRows 주석).

      // 음수 = 빨간 글자 — AS-IS NumberCellType.NegativeRed(SpreadInfo SetReNumerCellType, design 03 §3-B).
      //   자매 SCP0031 GlobalPsiGrid 동형. measure 배경색과 공존(글자색만 설정, 비음수면 color 해제).
      //   원값 기준 — 배율(>0)로 나눠도 부호 불변이라 raw 로 판정. 공용 gridNegativeText 헬퍼.
      paintNegativeText(ev.cell, toGridNumber(row[binding]));
    };
    g.formatItem.addHandler(formatHandler);

    // pivot leaf(Qty) 가로병합 차단 — 공용 CustomMergeManager 를 감싼다. 그리드 인스턴스당 정확히 1회만 설치한다.
    //   필수(무한재귀 방지): DataGrid 는 updatedLayout 마다 ensureTopLeftMergeManager 로 TopLeftMergeManager 를
    //   바깥에 덧씌운다. 그래서 "바깥이 RH 아니면 감싸기"(instanceof 가드)로 재설치하면, 조회마다 이 effect 가
    //   재실행(deps=pivot/fixedColumns 변동)되어 바깥을 차지한 TopLeft 위에 RH 를 또 감싸고 → 다음 updatedLayout 이
    //   그 위에 TopLeft 를 또 감싸 delegate 체인이 끝없이 자란다. getMergedRange 가 체인을 재귀로 타다 Maximum
    //   call stack size exceeded 로 그리드가 통째로 안 그려졌다(사용자 신고 2026-10-15). 그리드에 설치 플래그를 박아
    //   1회만 감싸면 TopLeft 가 바깥을 차지해도 RH 는 체인 안에 남아 pivot leaf 병합 차단이 유지된다(DataGrid 는
    //   init 에서만 mergeManager 를 CMM 으로 재설정하고 updatedLayout 에선 재설정하지 않으므로 1회 설치로 충분).
    const gm = g as typeof g & { __reportHeaderMergeInstalled?: boolean };
    if (g.mergeManager && !gm.__reportHeaderMergeInstalled) {
      g.mergeManager = new ReportHeaderMergeManager(g.mergeManager);
      gm.__reportHeaderMergeInstalled = true;
    }
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns, unitScaleIndex, planStartMonth, planStartYyyymmdd]);

  // 헤더 높이 자급(hook #93 총 48px) — 형제 GlobalPsiElecGrid 동형. 예측값이 아니라 실제 렌더된 tier 수
  //   (columnHeaders.rows.length)로 48 을 나눠 전 헤더 row 에 강제한다(WEEKLY 3단 16 / MONTHLY 2단 24).
  //   updatedLayout 마다 재적용해 bucket·조회 전이 중의 잔여 tier 도 흡수한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const hdrRows = g.columnHeaders?.rows;
      if (!hdrRows || hdrRows.length === 0) return;
      // 필수(무한 렌더 루프 방지): target 을 정수로 반올림한다. 48/헤더단수가 정수로 안 떨어지면
      //   (예: 단수 5 → 9.6) 아래 `Math.round(height) !== target` 가 영원히 true 가 되어 — height 는
      //   9.6 으로 설정되는데 비교는 Math.round(9.6)=10 과 하므로 — 매 updatedLayout 마다 changed=true
      //   → g.invalidate(true) 재발사 → refresh 가 중첩돼 셀 DOM 이 정리 전에 쌓이고(DOM 노드 폭증)
      //   CPU 가 100% 로 치솟아 스크롤 중 브라우저가 멈춘다(사용자 신고 2026-11-18, SCP0100 대형 피벗).
      //   반올림하면 설정값(정수)과 비교값(Math.round=동일 정수)이 일치해 1~2회 내 수렴한다.
      const target = Math.round(HEADER_TOTAL_HEIGHT / hdrRows.length);
      let changed = false;
      for (let i = 0; i < hdrRows.length; i += 1) {
        if (Math.round(hdrRows[i].height ?? hdrRows.defaultSize) !== target) {
          hdrRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(hdrRows.defaultSize) !== target) {
        hdrRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={scaledRows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      // headerRowHeight 를 넘기지 않는다(사용자 신고 2026-11-18 조회만 해도 CPU 100%·DOM 폭증·멈춤 교정).
      //   공용 DataGrid 는 updatedLayout 마다 이 정적 prop 값으로 headerRows.defaultSize 를 되돌리는데,
      //   아래 applyHeaderHeight 는 '실제 렌더된 tier 수'(48/hdrRows.length)로 설정한다. 실제 헤더가 3단이
      //   아니면(예: MONTHLY 2단=24) 정적 prop(48/3=16)과 서로 달라, 매 updatedLayout 마다 defaultSize 를
      //   16 ↔ 24 로 번갈아 엎어쓰며 g.invalidate 가 끝없이 재발사되는 무한 렌더 루프가 된다(헤더셀 재생성으로
      //   DOM 노드 폭증 + CPU 100%). 동적 tier 보정은 applyHeaderHeight 가 단독으로 맡아 수렴시키므로,
      //   정적 headerRowHeight 는 넘기지 않아 충돌 자체를 없앤다(공용 핸들러는 h==null 이면 건너뛴다).
      gotFocus={onFocus}
    />
  );
};
