import { CellType, Row } from '@mescius/wijmo.grid';
import type {
  CellRangeEventArgs,
  FlexGrid as FlexGridType,
  FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, paintNegativeText, toGridNumber, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS } from '../shipment-request-pack.constants';
import type { RequestDetailRow, ResultDetailRow } from '../shipment-request-pack.types';
import { isRequestDetailCellEditable } from '../utils/shipment-request-pack.editLock';

interface Props<Row extends RequestDetailRow | ResultDetailRow> {
  sheet: SHEETS.REQUEST_DETAIL | SHEETS.RESULT_DETAIL;
  rows: Row[];
  gridRef: MutableRefObject<FlexGridType<Row> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<Row> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  onFocus: () => void;
  // 셀 콤보(@divisionId/@mnuId) 바인드 해소용 — 공용 DataGrid 가 콤보 SQL @키 치환에 쓴다.
  //   미전달 시 @divisionId 콤보(FromSite/ToSite/ShipToCode)가 빈 결과가 된다.
  comboParams?: Record<string, string>;
  // MODEL_ID(FPTextModal) 셀 더블클릭 → 검색조건과 동일한 Model 팝업(행 FROM_SITE 기준). Request Detail 전용.
  //   AS-IS SSP0026_ItembyDivisionPopup. 편집 가능(신규행) MODEL_ID 셀에서만 발동.
  onModelCellDblClick?: (row: Row) => void;
  // TR_MODE/INCOTERMS 셀 변경 시 BOD 재조회(AS-IS FindData_BOD) — 행 Div/From/To/Model 로 GET_BOD_ITEM 조회해
  //   BOD_ID 를 세팅/클리어한다. 실제 조회·반영은 화면(onBodCellChange) 소관. Request Detail 전용.
  onBodCellChange?: (row: Row) => void;
}

/**
 * spdDetail — Request Detail(편집 대상) / Result Detail(항상 읽기전용) 공용 그리드(design 03 §1.3/§1.4).
 * Result Detail 은 Edit 버튼 클릭 자체가 MSG00109로 차단되므로(design 01 R8) 이 컴포넌트는 항상
 * `isReadOnly` 를 강제한다. Request Detail 은 신규행(CRUD_TYPE='I') 은 편집모드 전체 unlock,
 * 기존행은 `EDIT_FLAG=='Y'` 인 행만 [Qty..REMARK] 컬럼만 unlock 된다(R6/R8,
 * `shipment-request-pack.editLock.isRequestDetailCellEditable`).
 *
 * 미완(04_react-gap.md): 신규행(R10)의 Division+1~2/ShipToCode+2~3/NickName+1/Requestor~EditFlag/
 * FromSite+1/Remark+1~끝 오프셋 잠금은 실 컬럼 바인딩 매핑이 design 문서에 확정되지 않아(확인 필요)
 * 이번 회차는 임의 추정 없이 전체 unlock 으로 남긴다(회귀 방지 우선).
 */
export const ShipmentRequestPackDetailGrid = <Row extends RequestDetailRow | ResultDetailRow>({
  sheet,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  isEditMode,
  onFocus,
  comboParams,
  onModelCellDblClick,
  onBodCellChange,
}: Props<Row>) => {
  const isResultDetail = sheet === SHEETS.RESULT_DETAIL;

  // 하단 그리드 QTY 합계 푸터(AS-IS InitSpreadFooterSum_Detail, cs:458-495) — 데이터 있을 때만
  //   ColumnFooter 1줄에 "Sum" 라벨 + QTY 컬럼 합계(Request/Result Detail 공통, QTY 컬럼만 집계).
  //   데이터 0건이면 푸터 미표시. DMF0045 ColumnFooter 패턴 동일.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const footer = g.columnFooters;
    footer.rows.clear();
    if (rows.length === 0) {
      g.invalidate();
      return;
    }
    footer.rows.push(new Row());
    g.bottomLeftCells.setCellData(0, 0, 'Sum');
    const qtyCol = g.columns.findIndex(c => c.binding === 'QTY');
    if (qtyCol >= 0) {
      let sum = 0;
      for (const r of rows) {
        const v = (r as Record<string, unknown>).QTY;
        const n = typeof v === 'number' ? v : Number(String(v ?? '').replace(/,/g, ''));
        if (Number.isFinite(n)) sum += n;
      }
      footer.setCellData(0, qtyCol, sum === 0 ? null : sum);
    }
    g.invalidate();
    // staticColumns 로드 후 컬럼이 생겨야 QTY 인덱스를 찾는다 — deps 포함.
  }, [rows, staticColumns, gridRef]);

  // 음수 = 빨간 글자(공용 paintNegativeText) — QTY 수량 셀 + Sum 푸터. 데이터/푸터 패널 공통.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fmt = (s: FlexGridType<Row>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell && e.panel.cellType !== CellType.ColumnFooter) return;
      if ((s.columns[e.col]?.binding ?? '') !== 'QTY') return;
      const raw =
        e.panel.cellType === CellType.ColumnFooter
          ? e.panel.getCellData(e.row, e.col, false)
          : (s.rows[e.row]?.dataItem as Record<string, unknown> | undefined)?.QTY;
      paintNegativeText(e.cell, toGridNumber(raw));
    };
    g.formatItem.addHandler(fmt);
    g.invalidate();
    return () => {
      try {
        g.formatItem?.removeHandler(fmt);
      } catch {
        /* unmount race */
      }
    };
  }, [rows, staticColumns, gridRef]);

  // Shipment Date(FPDate 달력) 셀 표시 형식 — 공용 getFormat 은 날짜 컬럼을 'yyyy.MM.dd' 로 준다.
  //   달력에서 날짜를 고르면 셀 값이 Date 객체가 되어 그 점(.) 형식으로 표시되는데, 편집기(InputDate)는
  //   'yyyy-MM-dd' 라 표시/편집이 불일치한다. 공용 변경은 다른 화면 영향이 있어(사용자 지시 2026-10-23)
  //   이 화면 SHIPMENT_DATE 컬럼만 편집기와 동일한 대시 형식으로 덮어쓴다. 컬럼 재생성(updatedLayout)
  //   때마다 재적용하되, 이미 목표면 skip 해 무한 루프를 막는다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyDashFormat = () => {
      const col = g.columns.getColumn('SHIPMENT_DATE');
      if (col && col.format !== 'yyyy-MM-dd') col.format = 'yyyy-MM-dd';
    };
    applyDashFormat();
    g.updatedLayout.addHandler(applyDashFormat);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDashFormat);
      } catch {
        /* unmount race */
      }
    };
  }, [staticColumns, gridRef]);

  // MODEL_ID(FPTextModal) 셀 더블클릭 → Model 팝업(AS-IS SSP0026_ItembyDivisionPopup, DMF0045 hitTest 패턴).
  //   편집 가능(신규행) MODEL_ID 셀에서만. 모달 오픈·행 반영은 화면(onModelCellDblClick) 소관.
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !onModelCellDblClick) return;
    const handler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if ((g.columns[ht.col]?.binding ?? '') !== 'MODEL_ID') return;
      const row = g.rows[ht.row]?.dataItem as
        | (Row & { CRUD_TYPE?: string; EDIT_FLAG?: string })
        | undefined;
      if (!row) return;
      const editable = isRequestDetailCellEditable({
        columnBinding: 'MODEL_ID',
        crudType: row.CRUD_TYPE,
        editFlag: row.EDIT_FLAG,
        isEditMode,
      });
      if (!editable) return;
      onModelCellDblClick(row);
    };
    g.hostElement.addEventListener('dblclick', handler);
    return () => g.hostElement?.removeEventListener('dblclick', handler);
  }, [gridRef, onModelCellDblClick, isEditMode]);

  // TR_MODE/INCOTERMS 셀 변경 → BOD 재조회(AS-IS SpdDetail 콤보 변경 핸들러의 FindData_BOD). 편집 종료
  //   시 그 행을 화면에 넘겨 GET_BOD_ITEM 조회·BOD_ID 세팅/클리어를 맡긴다(실제 조회는 onBodCellChange 소관).
  //   EditTracker 뒤 실행이 필요한 공용 가드와 달리 부가 조회라 여기서 직접 cellEditEnded 에 붙인다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !onBodCellChange) return;
    const handler = (_s: FlexGridType<Row>, e: CellRangeEventArgs) => {
      const binding = g.columns[e.col]?.binding ?? '';
      if (binding !== 'TR_MODE' && binding !== 'INCOTERMS') return;
      const row = g.rows[e.row]?.dataItem as Row | undefined;
      if (row) onBodCellChange(row);
    };
    g.cellEditEnded.addHandler(handler);
    return () => {
      try {
        g.cellEditEnded?.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, onBodCellChange]);

  const handleBeginningEdit = (grid: FlexGridType<Row>, e: CellRangeEventArgs) => {
    const column = grid.columns[e.col];
    const dataItem = GridUtils.getRow(grid, e.row) as
      | (Row & { CRUD_TYPE?: string; EDIT_FLAG?: string })
      | undefined;
    if (!column?.binding || !dataItem) return;
    const editable = isRequestDetailCellEditable({
      columnBinding: column.binding,
      crudType: dataItem.CRUD_TYPE,
      editFlag: dataItem.EDIT_FLAG,
      isEditMode,
    });
    if (!editable) e.cancel = true;
  };

  return (
    <DataGrid<Row>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      comboParams={comboParams}
      isReadOnly={isResultDetail}
      beginningEdit={isResultDetail ? undefined : handleBeginningEdit}
      gotFocus={onFocus}
    />
  );
};
