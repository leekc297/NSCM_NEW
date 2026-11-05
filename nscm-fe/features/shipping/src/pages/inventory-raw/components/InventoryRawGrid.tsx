import { Aggregate, Globalize } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  GroupRow,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { AGGREGATE_COLUMNS } from '../inventory-raw.constants';
import type { InventoryRawRow } from '../inventory-raw.types';

interface Props {
  rows: InventoryRawRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
}

// 합계행 라벨 — AS-IS `ColumnFooter.Cells[0,1].Value = "Sum"`(SSP0017_InventoryRaw.cs:218).
//   공용 setAggregationRow 기본값은 'Σ' 라 자매 SSP0021(ShipmentPlanDetailGrid)과 같은 규약으로 덮는다.
const FOOTER_SUM_LABEL = 'Sum';
// 합계 표시 서식 — AS-IS `SetAggregationFormat(0, iCol, "{0:#,##0.###}")`(cs:228).
//   셀(FPNumber) 자체 서식은 DB `DATA_SCALE_NUMBER` 미지정이라 건드리지 않는다 — AS-IS 도
//   SetAggregationFormat 은 ColumnFooter 에만 적용한다(design 03 §3 규칙#3).
const FOOTER_SUM_FORMAT = '#,##0.###';
// 합계 셀 배경 — AS-IS `ColumnFooter.Cells[0,iCol].BackColor = Color.LightGray`(cs:230).
const FOOTER_SUM_BACKGROUND = '#d3d3d3';

// AS-IS gridSignals(design 03 §3): 전 컬럼 조회직후 편집잠금(LockColumn) — admin 메타
//   INPUT_TP_CD 가 31컬럼 전부 'S'(ora.py 실측, 2026-09-26)라 공용 DataGrid isEditableCell 이
//   이미 전 셀을 읽기전용으로 판정한다(화면단 별도 lock 로직 불필요).
// SmartColMerge(§3 규칙#6/#10) = AllowMerging.Cells(인접 동일값 셀 병합, MdmClassMaster 표준).
export const InventoryRawGrid = ({ rows, gridRef, gridFilterRef, staticColumns }: Props) => {
  // Footer 합계 5컬럼(STOCK_QTY/AVAILABLE_QTY/HOLD_QTY/LONG_QTY/EXPIRATION_QTY, design 03 §3 규칙#9).
  //   필수: 집계는 **wijmo Column 인스턴스**에 직접 얹어야 한다. RawFlexGridColumnConfig(= admin
  //   컬럼메타 타입)에는 `aggregate` 필드 자체가 없고, 공용 `mapRawColumnsToWijmoColumns` 의
  //   `toLeafColumn` 이 메타를 **새 객체로 다시 조립**하므로 raw 컬럼에 얹은 `aggregate`/`format` 은
  //   그대로 버려진다 — 종전 구현이 합계가 한 건도 안 나오던 원인이다(사용자 신고 2026-10-15).
  //   게다가 wijmo `set columnGroups` 는 Column 을 통째로 재생성해 `col.aggregate` 를 None 으로
  //   되돌리므로 1회 대입으로는 남지 않는다 → `updatedLayout` 마다 재적용한다(자매 SSP0021
  //   ShipmentPlanDetailGrid 와 동일 처방).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || staticColumns.length === 0) return;

    const sumSet = new Set<string>(AGGREGATE_COLUMNS);

    const applyAggregates = () => {
      // 데이터가 없으면 합계(Sum)행을 표시하지 않는다(사용자 지시 2026-10-22).
      //   판정은 라이브 `grid.rows`(바인딩 결과) — updatedLayout 핸들러는 최초 클로저라 `rows` prop 이
      //   스테일이기 때문. 공용 useAggregationRow 가 init 때 넣은 footer 행도 여기서 제거한다.
      if (grid.rows.length === 0) {
        if (grid.columnFooters.rows.length > 0) grid.columnFooters.rows.clear();
        return;
      }
      // 합계행(wijmo columnFooters GroupRow)은 공용 `useAggregationRow` prop 이 그리드 초기화 때
      //   넣지만, 그 1회가 비어 있으면 Sum 행 자체가 안 보인다 — 여기서 한 번 더 보장한다(있으면 no-op).
      //   AS-IS `ColumnFooter.Visible = true`(cs:217)와 같은 자리다.
      if (grid.columnFooters.rows.length === 0) grid.columnFooters.rows.push(new GroupRow());
      if (grid.bottomLeftCells.getCellData(0, 0, false) !== FOOTER_SUM_LABEL) {
        grid.bottomLeftCells.setCellData(0, 0, FOOTER_SUM_LABEL);
      }
      grid.columns.forEach(column => {
        // AS-IS SumIgnoreHidden 등가 — wijmo Aggregate 는 visible 무관 소스 집계라 hidden
        //   LONG_QTY 도 합산되나, 그 컬럼 자체가 안 보이므로 표시 결과는 같다(design 03 §6 #2).
        const want = sumSet.has(column.binding ?? '') ? Aggregate.Sum : Aggregate.None;
        if (column.aggregate !== want) column.aggregate = want;
      });
    };

    // 합계 셀 서식·배경 — AS-IS 는 `BackColor=LightGray` 를 **집계 대상 범위 컬럼(STOCK_QTY~EXPIRATION_QTY)
    //   에만** 적용한다(design 03 §3 #5, cs:230 "범위 컬럼"). 전체 footer 행이 아니라 집계 컬럼 footer 셀만
    //   회색이므로 배경 대입을 sumSet 통과 뒤로 둔다 — 비집계 컬럼·"Sum" 라벨 셀은 기본색(AS-IS 패리티,
    //   사용자 결정 2026-10-30. 공용 표준엔 footer 배경 규칙 없음 → AS-IS 우선). 데이터 셀(ColumnFooter 아님)은 미변경.
    const formatFooter = (sender: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.ColumnFooter) return;
      if (!sumSet.has(sender.columns[e.col]?.binding ?? '')) return;
      e.cell.style.backgroundColor = FOOTER_SUM_BACKGROUND;
      const value = e.panel.getCellData(e.row, e.col, false) as unknown;
      if (typeof value === 'number') e.cell.textContent = Globalize.format(value, FOOTER_SUM_FORMAT);
    };

    applyAggregates();
    grid.updatedLayout.addHandler(applyAggregates);
    grid.formatItem.addHandler(formatFooter);
    // GRID-06: 등록한 핸들러는 cleanup 에서 해제한다 — 언마운트·deps 변경·그리드 재생성 시 누수/중복
    //   방지. 종전엔 footerHookedRef 로 1회만 등록해 그리드 인스턴스가 새로 만들어지면 재부착되지
    //   않았다(핸들러는 live grid.rows 를 읽는 안정 클로저라 재등록해도 동작 동일, 자매
    //   ShipmentPlanDetailGrid 의 removeHandler cleanup 규약과 동일).
    return () => {
      grid.updatedLayout.removeHandler(applyAggregates);
      grid.formatItem.removeHandler(formatFooter);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, rows]);

  return (
    <DataGrid<InventoryRawRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      allowMerging={AllowMerging.Cells}
      useAggregationRow
      // 조회 전용 그리드(AS-IS LockColumn, 전 컬럼 INPUT_TP_CD='S'). isReadOnly 를 줘 수정상태(CRUD)
      //   rowHeader status 컬럼을 노출하지 않는다(DataGrid.tsx:1664 — 읽기전용이면 status 컬럼 미생성).
      //   자매 조회전용 그리드(ShipmentRequestElectrodeMainGrid 등 "표시전용 isReadOnly")와 동일 규약.
      isReadOnly
    />
  );
};
