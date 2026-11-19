import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  COLUMN,
  HEADER_ROW_HEIGHT,
  MEASURE_COLOR,
  MEASURE_COLOR_BY_CODE,
  NUMERIC_STATIC_COLUMNS,
  SCALE_DEFAULT,
  SCALE_ZERO,
  ZERO_SCALE_MEASURES,
  type GridSheet,
} from '../capa-teep-report.constants';
import type { CapaTeepRow } from '../capa-teep-report.types';
import { isPeriodColumn } from '../utils/capaTeepReport.dateColumns';

import styles from './CapaTeepReportGrid.module.scss';

interface Props {
  sheetName: GridSheet;
  rows: CapaTeepRow[];
  staticColumns: RawFlexGridColumnConfig[];
  periodColumns: FlexGridColumnConfig[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
}

/**
 * AS-IS `spdMain`(FpSpread, 시트 2개) -> 공용 `DataGrid` 1개 + `sheetName` 스위치(03 G-01 / V-31).
 * `TabStripPolicy=Never`(cs:1227) 라 **탭 UI 를 만들지 않는다.** 시트 2개를 동시에 만들어 CSS 로 감추는
 * 것도 금지다 — 컬럼셋·기간컬럼이 시트마다 다르다(§1.1/§1.2).
 *
 * 화면이 직접 담당하는 것 2가지뿐이다(조회 전용이라 편집 계열이 전부 없다):
 *  (a) **Measure 행 배경색** — `MEASURE`(코드) 기준 19종 4색, 적용 범위 `MEASURE_NAME` 열 ~ 행 끝(03 §3.3)
 *  (b) **행 단위 소수 자릿수** — `MEASURE ∈ 5종` 이면 0자리, 그 외 1자리(03 §3.2 G-13 / V-19)
 *
 * 만들지 않는 것(자매 SCP0105/0106 에서 복사하면 전부 오답 — 03 §3.1 / §4.4):
 *  - `beginningEdit`/`cellEditEnded`/`pastingCell` 커스텀 · `EditTracker` · `CRUD_TYPE` 마킹
 *  - 화면 고유 `canEdit` 오버라이드 — `INPUT_TP_CD='S'` 50행 전건이라 공용 판정만으로 AS-IS 와 같다(G-08)
 *  - `MergeKeyColumns` 헤더 가로병합(데드 G-02~G-04) · `SetBaseToDateColumns`(데드 G-12) ·
 *    Action 컬럼(G-19 — TO-BE 는 rowHeader 'No.' 가 대체) · `SetColumAutosize`(주석처리 G-14)
 *  - `frozenColumns` 하드코딩 — 아래 주석 참조
 */
export const CapaTeepReportGrid = ({
  sheetName,
  rows,
  staticColumns,
  periodColumns,
  gridRef,
  gridFilterRef,
}: Props) => {
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatItemHandler = (
      sender: FlexGridType,
      event: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (event.panel !== sender.cells) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as CapaTeepRow | undefined;

      // Wijmo 는 셀 DOM 을 재사용한다 — 미해당 시에도 반드시 클래스를 해제한다(hook #95 §1-4 / V-24).
      if (!row) {
        event.cell.classList.remove(
          styles.measureYellow,
          styles.measureSky,
          styles.measureOrange,
          styles.measurePink
        );
        return;
      }

      /**
       * (a) Measure 행 배경색 — 적용 범위는 `(행, MEASURE_NAME 열) ~ 행 끝` 이다
       * (cs:1570 `SetBGColor(i, GetColumnIndex(MEASURE_NAME), i, ColumnCount-1, mColor)`).
       * `DIVISION_ID`~`MEASURE_GROUP_NAME` 는 칠하지 않는다.
       * **`MEASURE_NAME`(영문 표시값) 문자열 비교가 아니라 `MEASURE`(코드) 기준**이다 — AS-IS 는 19문자열
       * 하드코딩이라 다국어 전환 즉시 깨지고 `MC_RT`("Model Change", NBSP) 함정도 있다(03 §3.3 / V-21·V-22).
       * 조회 결과 0건이면 이 핸들러 자체가 호출되지 않아 AS-IS `if (Rows.Count > 0)`(cs:1519)와 등가다(V-37).
       */
      const measureNameIndex = sender.columns.findIndex(
        column => column.binding === COLUMN.MEASURE_NAME
      );
      const inMeasureRange = measureNameIndex >= 0 && event.col >= measureNameIndex;
      const measure = typeof row[COLUMN.MEASURE] === 'string' ? (row[COLUMN.MEASURE] as string) : '';
      const color = inMeasureRange ? MEASURE_COLOR_BY_CODE[measure] : undefined;
      event.cell.classList.toggle(styles.measureYellow, color === MEASURE_COLOR.YELLOW);
      event.cell.classList.toggle(styles.measureSky, color === MEASURE_COLOR.SKY);
      event.cell.classList.toggle(styles.measureOrange, color === MEASURE_COLOR.ORANGE);
      event.cell.classList.toggle(styles.measurePink, color === MEASURE_COLOR.PINK);

      /**
       * (b) 행 단위 소수 자릿수 — `row.MEASURE ∈ 5종` 이면 **0자리**, 그 외 **1자리**(03 §3.2 G-13).
       * 대상은 `BIZ_QTY`·`PRE_QTY`·`PFRSLT_QTY`·`BASE_QTY` + **기간 컬럼 전량**(`_sheetNumericColumns`).
       * 메타 `DATA_SCALE_NUMBER` 가 50행 전건 NULL 이라 컬럼 단위 `format` 으로는 표현 불가하고
       * 행마다 자릿수가 달라 여기서 그린다. 천단위 구분은 유지한다(V-20).
       * 비율 measure 값은 **서버가 이미 ×100** 해서 보낸다 — FE 재계산·`%` 서식 추가 금지(V-26).
       */
      const isNumericTarget =
        NUMERIC_STATIC_COLUMNS.includes(binding) || isPeriodColumn(binding);
      if (!isNumericTarget) return;
      const raw = row[binding];
      if (raw === null || raw === undefined || raw === '') return;
      const numeric = Number(raw);
      if (!Number.isFinite(numeric)) return;
      const scale = ZERO_SCALE_MEASURES.includes(measure) ? SCALE_ZERO : SCALE_DEFAULT;
      event.cell.textContent = numeric.toLocaleString(undefined, {
        minimumFractionDigits: scale,
        maximumFractionDigits: scale,
      });
    };
    grid.formatItem.addHandler(formatItemHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, periodColumns]);

  /**
   * 병합 — AS-IS `SetSheetMerge()`(cs:1577~1584)는 `!IsEditMode` 일 때만 `ToggleMerge`+`SmartColMerge`
   * 를 돌리는데 이 화면은 `IsEditMode` 를 켜는 코드가 0건이라 **상시 ON** 이다(03 §3.4 / V-27).
   * `AllowMerging.All` 을 주면 공용 DataGrid 가 wijmo `CustomMergeManager`(sticky)를 설치해
   * AS-IS 가 스크롤마다 머지를 재적용하던 것과 같은 효과를 **스크롤 핸들러 없이** 낸다(hook #69).
   * 기간(동적) 컬럼은 `buildPeriodColumns` 에서 `allowMerging:false` 라 수치가 묶이지 않는다.
   */
  const allowMerging = AllowMerging.All;

  /**
   * 좌측 고정(frozen) 경계는 **admin 메타가 원천**이다 — 공용 DataGrid 가
   * `flatStaticColumns.findLastIndex(_fixed) + 1` 로 계산하며, 이것이 곧 AS-IS 알고리즘
   * (`FIXED_FLAG='Y'` **마지막** 행 기준 `Freeze(FPFrozen.Col, idx+…)`, si:3293~3306)과 같다.
   * **`FIXED_FLAG='Y'` 개수로 계산하면 틀린다**(TO-BE 메타는 `MEASURE`+`BASE_QTY` 2건, AS-IS 는 1건 —
   * 03 §1.1 ※ / §6-1 드리프트). `MEASURE` 는 폭 0 이라 store 에서 `display:false` 로 내려가 컬럼 목록에서
   * 제외되므로 마지막 `_fixed` 는 `BASE_QTY` 이고 고정 영역 = **보이는 정적 컬럼 12/11개 전체**가 된다(V-07).
   * 그래서 이 컴포넌트는 `frozenColumns` 를 **넘기지 않는다** — 넘기면 메타 산출값을 덮어쓴다.
   */
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      dynamicColumns={periodColumns}
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      // 3단 헤더 총높이 48px — 컬럼 정의의 height 가 아니라 이 prop 이 단일 출처다(hook #93 / V-18c).
      headerRowHeight={HEADER_ROW_HEIGHT}
      allowMerging={allowMerging}
      // 조회 전용이라 dirty 집계 대상이 아니다(`CRUD_TYPE` 이 생기는 경로가 없다).
      excludeFromDirtyCheck
    />
  );
};
