import { toggleClass } from '@mescius/wijmo';
import { CellRange, CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import {
  CONVERT_QTY_BINDINGS,
  getConvertQtyEditable,
  MODEL_TYPE_BINDING,
  type MENU_ID,
  type SHEETS,
} from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

type CustomerModelMappingRow = ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>;

/** Convert Qty 3개 컬럼 바인딩 → editable 키 매핑 (Model Type 조건부 편집제어 대상). */
const CONVERT_QTY_EDITABLE_KEY: Record<string, 'pack' | 'module' | 'cell'> = {
  [CONVERT_QTY_BINDINGS.PACK]: 'pack',
  [CONVERT_QTY_BINDINGS.MODULE]: 'module',
  [CONVERT_QTY_BINDINGS.CELL]: 'cell',
};

interface CustomerModelMappingProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>[];
}

export const CustomerModelMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: CustomerModelMappingProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >();

  const staticColumn = useCustomerModelMappingStore(state => state.staticColumn);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  // ⭐ Model Type(ITEM_CLASS_NAME) 별 Convert Qty(Pack/Module/Cell) 조건부 편집제어.
  //   AS-IS DM0006_CustomerModelMapping.cs L289~307 / L1075~1089 재현. 공용 DataGrid wrapper 는
  //   컬럼 메타(_inputEditType)로만 편집여부를 결정하므로 행별(Model Type) 제어는 feature 에서
  //   beginningEdit(lock) + formatItem(gray) 핸들러로 추가한다. (DMF0020 SalesFuturePriceGrid 표준 패턴)
  //   FIFO 마지막 등록 → wrapper setEditableColumns / formatEditableColumns 보다 우선(#70 P7).
  //   Type 변경 시 수량 값은 유지(AS-IS LockRange = 잠금만, 값 초기화 없음).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 시작 시 — Model Type 상 잠긴 Convert Qty 셀이면 편집 차단.
    const beginningEditHandler = (
      s: FlexGrid<CustomerModelMappingRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const key = CONVERT_QTY_EDITABLE_KEY[binding];
      if (!key) return;
      const row = s.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      const editable = getConvertQtyEditable(row?.[MODEL_TYPE_BINDING]);
      if (!editable[key]) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 셀 배경 — 잠긴 Convert Qty 셀 = Gray(wj-cell-non-editable) + wrapper 의 Yellow(wj-cell-editable) 제거.
    //   편집가능 셀의 Yellow 는 wrapper(formatEditableColumns)의 메타 판정에 위임(과잉 채색 방지) → non-editable 만 해제.
    //   backcolor 3색 표준(hook #95): Gray 는 "편집가능하나 조건부 잠금" 특수셀에만. 두 클래스 상호배타 toggle(재활용 잔존 방지).
    const formatHandler = (_s: FlexGrid<CustomerModelMappingRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const key = CONVERT_QTY_EDITABLE_KEY[binding];
      if (!key) return;
      const row = e.panel.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      const editable = getConvertQtyEditable(row?.[MODEL_TYPE_BINDING]);
      const locked = !editable[key];
      toggleClass(e.cell, 'wj-cell-non-editable', locked);
      if (locked) toggleClass(e.cell, 'wj-cell-editable', false); // wrapper 가 부여한 Yellow 제거
    };
    g.formatItem.addHandler(formatHandler);

    return () => {
      g.beginningEdit?.removeHandler(beginningEditHandler);
      g.formatItem?.removeHandler(formatHandler);
    };
  }, [gridRef, data]);

  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;

    const projectCode = projects?.split(',')[0] ?? '';
    const projectsName = projectsNames?.split(',')[0] ?? '';

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_CODE',
      clickedDataItem.PROJECT_CODE,
      projectCode
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_NAME',
      clickedDataItem.PROJECT_NAME,
      projectsName
    );

    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectsName;

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleItemSelected = (itemCode: string, itemName?: string, itemType?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_CLASS_NAME',
      clickedDataItem.ITEM_CLASS_NAME,
      itemType ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_NAME',
      clickedDataItem.ITEM_NAME,
      itemName ?? ''
    );

    clickedDataItem.ITEM_ID = itemCode;
    clickedDataItem.ITEM_CLASS_NAME = itemType ?? '';
    clickedDataItem.ITEM_NAME = itemName ?? '';

    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleGridDblclick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    const editable = GridUtils.isEditableCell(grid, ht.row, ht.col);
    if (!editable) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    const dataItem = GridUtils.getRow(grid, ht.row);

    if (!dataItem) return;

    if (binding === 'PROJECT_CODE') {
      setClickedRow(ht.row);
      setOpenPrjByDivisionModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'ITEM_CLASS_NAME') {
      setClickedRow(ht.row);
      setOpenModelByDivisionModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumn ?? []}
        dblClick={handleGridDblclick}
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={(projects, projectsNames) => {
          handleProjectSelected(projects, projectsNames);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE,
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={(items, itemName, itemType) => {
          handleItemSelected(items, itemName, itemType);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE || 'ALL',
          activeFlag: clickedDataItem?.VALID_YN || 'ALL',
          itemId: clickedDataItem?.ITEM_ID || '',
        }}
        callFromCell={false}
      />
    </>
  );
};
