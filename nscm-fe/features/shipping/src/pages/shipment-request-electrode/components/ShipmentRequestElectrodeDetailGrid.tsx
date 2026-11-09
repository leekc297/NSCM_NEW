import type {
  CellRangeEventArgs,
  FlexGrid as FlexGridType,
  FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  COMBO,
  REQUEST_DETAIL_AGGREGATE_COLUMNS,
  SHEETS,
} from '../shipment-request-electrode.constants';
import type { RequestDetailRow } from '../shipment-request-electrode.types';
import { isRequestDetailCellEditable } from '../utils/shipment-request-electrode.editLock';
import { useFooterSum } from '../utils/shipment-request-electrode.footerSum';

interface Props {
  rows: RequestDetailRow[];
  gridRef: MutableRefObject<FlexGridType<RequestDetailRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<RequestDetailRow> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  // 신규행 FROM_SITE/TO_SITE 셀콤보 필터(@segment5=division, @segment4=company). 페이지가 조회조건 기준으로 넘긴다.
  comboParams?: Record<string, string>;
  onFocus: () => void;
  onItemCellDoubleClick?: (row: RequestDetailRow) => void;
}

/**
 * spdDetail.shtRequestDetail — 요청상세, 유일한 편집 대상 시트(design 03 §1.2).
 *
 * 편집 가능 범위는 3중 소스로 결정된다(AS-IS InsertRow cs:1466-1470 + EditButton spdDetail cs:1703-1718, 실측):
 * 1. 신규행(CRUD_TYPE='I') — Insert 직후 5컬럼만 lock(MODEL_ID/NICK_NAME/DIVISION_ID/REQUESTOR/REQUEST_DATE), 나머지 편집가능.
 * 2. 기존행 + 편집모드(canEdit) — EDIT_FLAG='N' 은 행 전체 잠금(편집 없음) / 그 외는 SHIPMENT_QTY·INCOTERMS·TRANSPORT_MODE 만
 *    편집가능(REQUEST_DATE·REQUESTOR·SHIPMENT_DATE 등은 잠김). LockRange2(...,true)=Lock 실측 기준.
 * 3. 편집모드 아님 — 전체 lock(조회 직후 기본상태, design 03 §3 규칙#18).
 *
 * ITEM_ID 셀은 더블클릭 시 BOD/Item 팝업(SSP0022_BodItemPopup)을 열어야 한다(design 01 §2 R6 연계,
 * 03 §1.2) — 이번 회차는 팝업 자체를 미착수(04 미완 항목)해 onItemCellDoubleClick 훅만 배선해 둔다.
 */
export const ShipmentRequestElectrodeDetailGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  isEditMode,
  comboParams,
  onFocus,
  onItemCellDoubleClick,
}: Props) => {
  // 하단 합계(Sum)행 — AS-IS InitSpreadFooterSum(cs:3597-3636, Request Detail = SHIPMENT_QTY 단일). 데이터 있을 때만 표시.
  useFooterSum(gridRef, staticColumns, rows, REQUEST_DETAIL_AGGREGATE_COLUMNS);

  // 편집 게이트·행 변경 시 재판정을 위해 최신 isEditMode 를 ref 로 참조(핸들러 재등록 없이 반영).
  const isEditModeRef = useRef(isEditMode);
  isEditModeRef.current = isEditMode;

  // 신규행 FROM_SITE/TO_SITE 셀콤보 주입 — admin 메타에 CELL_COMBO_DATA_TYPE 가 없어(실측) 공용 DataGrid 가 콤보를
  //   못 붙인다. AS-IS InsertRow 의 SetCellTypeCombo(cs:1459-1460, PlantByElectordeShipFromSite/ToSite) 등가로 이 두
  //   컬럼에 COMBO 셀타입 + cellCboDataTp 를 주입한다(design 03 §1.6 옵션(b) FE 직접 배선). @segment5=division
  //   @segment4=company 필터는 comboParams 로 넘어간다. INCOTERMS/TRANSPORT_MODE 는 메타에 cellCboDataTp 가 이미
  //   있어(Incoterms/TransportMode) 추가 주입 불요 — 편집만 열리면 드롭다운이 뜬다.
  const columns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const comboByCol: Record<string, string> = {
      FROM_SITE: COMBO.CELL_FROM_SITE,
      TO_SITE: COMBO.CELL_TO_SITE,
    };
    return staticColumns.map(column => {
      const sql = comboByCol[column.colNm ?? ''];
      if (!sql) return column;
      return {
        ...column,
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
        cellCboDataTp: sql,
        inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      };
    });
  }, [staticColumns]);

  // 편집 게이트(beginningEdit/pastingCell) + 편집셀 노랑(formatItem) — isRequestDetailCellEditable 1벌을 공유한다.
  //   필수: beginningEdit 는 **useEffect 의 addHandler** 로 건다. 공용 DataGrid 에는 beginningEdit prop 자체가 없어
  //   (props = initialized/dblClick/click/gotFocus) prop 으로 넘기면 실행조차 안 됐다(사용자 신고 "수정 안 됨"의 원인).
  //   또한 공용 setEditableColumns(INPUT_TP_CD='S'→cancel=true)보다 **뒤에** 등록돼야 편집가능 셀의 e.cancel=false 가
  //   최종 반영된다 — 자식(DataGrid) init effect 가 부모 effect 보다 먼저 도므로 순서가 보장된다(메인그리드 동형).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const judge = (
      binding: string | null | undefined,
      dataItem: RequestDetailRow | undefined
    ): boolean => {
      if (!binding || !dataItem) return false;
      return isRequestDetailCellEditable({
        columnBinding: binding,
        crudType: dataItem.CRUD_TYPE,
        editFlag: dataItem.EDIT_FLAG,
        isNewRow: dataItem.CRUD_TYPE === 'I',
        isEditMode: isEditModeRef.current,
      });
    };
    const beginningEdit = (sender: FlexGridType<RequestDetailRow>, e: CellRangeEventArgs) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = GridUtils.getRow(sender, e.row) as RequestDetailRow | undefined;
      // 양방향 재지정 — 공용이 'S' 로 막은 편집가능 셀을 false 로 되돌려야 실제 편집이 열린다.
      e.cancel = !judge(binding, dataItem);
    };
    const paint = (_s: FlexGridType<RequestDetailRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding;
      const dataItem = e.panel.rows[e.row]?.dataItem as RequestDetailRow | undefined;
      e.cell.classList.toggle('wj-cell-editable', judge(binding, dataItem));
    };
    g.beginningEdit.addHandler(beginningEdit);
    g.pastingCell.addHandler(beginningEdit as never);
    g.formatItem.addHandler(paint);
    g.invalidate();
    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEdit);
        g.pastingCell?.removeHandler(beginningEdit as never);
        g.formatItem?.removeHandler(paint);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  // isEditMode/행 변경 시 재판정·재도색(핸들러는 ref 로 최신값 사용). 신규행 추가는 addRowSet 의 invalidate 가 처리한다.
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEditMode, rows]);

  // ITEM_ID 더블클릭 = BOD/Item 팝업 트리거(design 03 §1.2, 03_grid-columns.md 규칙#13) — 인라인
  //   편집으로 먼저 빠지지 않도록 beginningEdit 에서 이미 취소되므로(위 handleBeginningEdit),
  //   dblClick 에서 팝업만 연다(nscm-patterns.md §5-16 팝업 셀 편집취소 원칙).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const column = grid.columns[ht.col];
    if (column?.binding !== 'ITEM_ID') return;
    const dataItem = GridUtils.getRow(grid, ht.row) as RequestDetailRow | undefined;
    if (dataItem) onItemCellDoubleClick?.(dataItem);
  };

  return (
    <DataGrid<RequestDetailRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={columns}
      comboParams={comboParams}
      sheetName={ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL]}
      gotFocus={onFocus}
      dblClick={handleDblClick}
    />
  );
};
