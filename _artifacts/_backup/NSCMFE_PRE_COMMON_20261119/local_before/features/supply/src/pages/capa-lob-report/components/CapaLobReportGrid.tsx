import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  HEADER_DEPTH,
  HEADER_ROW_HEIGHT,
  type GridSheet,
} from '../capa-lob-report.constants';
import type { CapaLobBottleneckRow, CapaLobRow } from '../capa-lob-report.types';
import { bottleneckKeyOf, isBottleneckCell } from '../utils/capaLobReport.cursors';
import { isPeriodColumn } from '../utils/capaLobReport.dateColumns';

import styles from './CapaLobReportGrid.module.scss';

interface Props {
  sheetName: GridSheet;
  rows: CapaLobRow[];
  staticColumns: RawFlexGridColumnConfig[];
  periodColumns: FlexGridColumnConfig[];
  /** 2번째 커서를 키 조인용 Map 으로 정리한 것(03 R-11) — 행 인덱스 대응이 아니다. */
  bottleneckIndex: Map<string, CapaLobBottleneckRow>;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
}

/**
 * AS-IS `spdMain`(FpSpread, 시트 2개) -> 공용 `DataGrid` 1개 + `sheetName` 스위치(03 R-01).
 * `TabStripPolicy.Never` 라 **탭 UI 를 만들지 않는다**(R-02 / 01 L-35 / V-41).
 *
 * 화면이 직접 담당하는 것 2가지뿐이다(전건 조회전용이라 편집 계열이 전부 없다):
 *  (a) 기간 셀 **음수 빨간색** — AS-IS `NegativeRed=true`(R-08 / V-21)
 *  (b) **Bottleneck 조건부 배경** — 2번째 커서를 키 조인해 (행, 기간컬럼) 셀만 강조(R-09 / V-22)
 *
 * 컬럼 목록·3단 머지헤더·컨텍스트메뉴·엑셀·행헤더 No. 는 공용 DataGrid 소관이다.
 * 만들지 않는 것: `beginningEdit`/`pastingCell` 커스텀 허용 · `cellEditEnded` · `EditTracker` ·
 * `CRUD_TYPE` 마킹 · `frozenColumns` 하드코딩 · 스크롤 시 병합 재계산 핸들러(03 V-27~V-33).
 */
export const CapaLobReportGrid = ({
  sheetName,
  rows,
  staticColumns,
  periodColumns,
  bottleneckIndex,
  gridRef,
  gridFilterRef,
}: Props) => {
  // 핸들러는 mount 후 1회 등록이라 최신값을 ref 로 본다(stale closure 방지).
  const bottleneckRef = useRef(bottleneckIndex);
  bottleneckRef.current = bottleneckIndex;

  /**
   * 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding -> {cell, text}.
   * 공용 DataGrid 는 colWth/display 만 컬럼에 옮기고 **색은 안 넘기므로**(형제 ShipmentRequestGrid 와 동일)
   * 아래 formatItem 이 고정 컬럼 셀에 직접 칠한다. 저장·조회는 정상이나 렌더 경로가 없던 갭 보완(2026-11-04).
   */
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    staticColumns.forEach(column => {
      if (column.cellColor || column.textColor) {
        m.set(column.colNm, { cell: column.cellColor ?? '', text: column.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatItemHandler = (
      sender: FlexGridType,
      event: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (event.panel !== sender.cells) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as CapaLobRow | undefined;

      // 개인화 셀/글자색(ColumnLayoutModal 저장값) 적용·해제. Wijmo 가 셀 DOM 을 재사용하므로
      //   미해당 시 반드시 해제한다(hook #95 §1-4). 배경은 동적 hex 라 CSS 변수(--clr-cell-bg)로 넘기고
      //   class(.personalCellBg, 선택 셀 제외) 가 칠한다 — inline 색 하드코딩 금지(§2.1 #5). 글자색은
      //   개인화 동적값이라 setProperty 로 직접 적용(형제 ShipmentRequestGrid 선례).
      const color = row ? colorMetaRef.current.get(binding) : undefined;
      if (color?.cell) event.cell.style.setProperty('--clr-cell-bg', color.cell);
      else event.cell.style.removeProperty('--clr-cell-bg');
      event.cell.classList.toggle(styles.personalCellBg, !!color?.cell);
      if (color?.text) event.cell.style.setProperty('color', color.text, 'important');
      else event.cell.style.removeProperty('color');

      // Wijmo 는 셀 DOM 을 재사용한다 — 미해당 시에도 반드시 클래스를 해제한다(hook #95 §1-4).
      //   고정 6컬럼에는 음수·bottleneck 포맷이 걸리지 않는다(AS-IS 루프가 `ELTR_LN_TP_CD` 다음 컬럼부터, R-10).
      if (!row || !isPeriodColumn(binding)) {
        event.cell.classList.remove(styles.negativeValue, styles.bottleneckCell);
        return;
      }

      const raw = row[binding];
      const numeric = typeof raw === 'number' ? raw : Number(raw);
      // `null`/공백은 빈칸이므로 음수 판정 대상이 아니다(`NullDisplay=""`, R-08).
      const isNegative = raw !== null && raw !== undefined && raw !== '' && numeric < 0;
      event.cell.classList.toggle(styles.negativeValue, isNegative);

      const flagRow = bottleneckRef.current.get(bottleneckKeyOf(row));
      event.cell.classList.toggle(styles.bottleneckCell, isBottleneckCell(flagRow, binding));
    };
    grid.formatItem.addHandler(formatItemHandler);

    // 헤더 총높이 고정 — `headerRowHeight` prop 만으로는 정적 컬럼 기본높이가 동적 16·defaultSize 를
    //   이겨 3단 전체가 48×3=144px 로 벌어진다(메모리 multi-tier-dyn-header-height-balloons).
    //   실제 tier 수로 총높이(48)를 균등배분해 각 헤더 행·defaultSize 에 박는다(형제
    //   ShipmentPlanElectrodeMainGrid applyHeaderHeight 정본). 목표값과 같으면 skip → updatedLayout 무한루프 방지.
    const applyHeaderHeight = () => {
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = (HEADER_ROW_HEIGHT * HEADER_DEPTH) / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    grid.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, periodColumns]);

  // Bottleneck 플래그가 늦게 도착(또는 조회로 갱신)하면 배경을 다시 칠한다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [bottleneckIndex]);

  /**
   * 좌측 고정영역 sticky 병합 — AS-IS `SetSheetMerge()`(cs:1422~1431)는 `!IsEditMode` 일 때
   * `RightColMerge2()` 를 호출하고 `IsEditMode` 가 true 가 되는 경로가 없어 **항상 실행**된다(01 L-33).
   * `AllowMerging.All` 을 주면 공용 DataGrid 가 wijmo `CustomMergeManager`(sticky)를 설치한다 —
   * AS-IS 가 `spdMain_TopChange` 마다 머지를 재적용하던 것과 같은 효과를 **스크롤 핸들러 없이** 낸다
   * (hook #69 / 03 R-13 / V-32·V-33). 기간(동적) 컬럼은 `allowMerging:false` 라 수치가 묶이지 않는다.
   */
  const allowMerging = AllowMerging.All;

  /**
   * 좌측 고정(frozen) 경계는 **admin 메타가 원천**이다 — `FIXED_FLAG='Y'` 는 두 시트 모두
   * `ELTR_LN_TP_CD` 단일 행이고(03 §1.1/§1.2) 공용 DataGrid 가 `_fixed` 마지막 인덱스로 계산한다.
   * **`frozenColumns={1}` 로 하드코딩하지 않는다** — `AddSheet(..., 3, 1, 35)` 의 `1` 은 고정열이 아니라
   * `RowHeader.ColumnCount`(좌측 No. 1열)였다(03 §0.4 오독 정정 / C-13 / V-42).
   * 그래서 이 컴포넌트는 `frozenColumns` prop 을 아예 넘기지 않는다(넘기면 메타 산출값을 덮는다).
   */
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      dynamicColumns={periodColumns}
      sheetName={ADMIN_SHEET_NAME[sheetName]}
      // 3단 헤더 총높이 48px — 컬럼 정의의 height 가 아니라 이 prop 이 단일 출처다(hook #93 / V-19).
      headerRowHeight={HEADER_ROW_HEIGHT}
      allowMerging={allowMerging}
      // 전건 조회전용이라 dirty 집계 대상이 아니다(CRUD_TYPE 이 생기는 경로가 없다).
      excludeFromDirtyCheck
      // 조회전용 Report — 셀 편집·행 추가/삭제가 없다(사용자 지시 2026-10-19). isReadOnly 면
      //   CRUD status 행헤더 컬럼도 생기지 않는다(DataGrid L-1618). AS-IS `IsLock` 영구 true 와 등가.
      isReadOnly
    />
  );
};
