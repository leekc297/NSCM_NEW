import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../customer-fcst-upload.constant';

interface CustomerModelMappingProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST_UPLOAD>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST_UPLOAD>[];
}

export const CustomerFcstUploadGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: CustomerModelMappingProps) => {
  // const staticColumn = useCustomerFcstUploadStore(state => state.staticColumn);

  // const initGrid = (grid: FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST_UPLOAD>>) => {
  //   grid.hostElement.addEventListener('dblclick', (mouseEvent: MouseEvent) => {
  //     const ht = grid.hitTest(mouseEvent);
  //     const binding = grid.columns[ht.col]?.binding;
  //     const { modelDivisionModal, prjDivisionModal } = handleDoubleClick;

  //     // TODO: mock project code and model binding because the interface of the grid data's response
  //     // does not have project code by now
  //     if (binding === 'PROJECT_CODE') {
  //       prjDivisionModal();
  //     } else if (binding === 'MODEL') {
  //       modelDivisionModal();
  //     }
  //   });
  // };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_FCST_UPLOAD>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      // initialized={initGrid}
      // staticColumns={staticColumn ?? []}
      staticColumns={[
        {
          colNm: 'NO',
          colLblNm: 'No',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'DIV',
          colLblNm: 'Div',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'SALES_SITE',
          colLblNm: 'Sales site',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'PLANT_SITE',
          colLblNm: 'Plant site',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'CUSTOMER_PROJECT',
          colLblNm: 'Customer project',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'CUSTOMER_MODEL',
          colLblNm: 'Customer model',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'INCOTERMS',
          colLblNm: 'Incoterms',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'FCST_TYPE',
          colLblNm: 'Fcst type',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'CUSTOMS_HANDBOOK',
          colLblNm: 'Customs handbook',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'MEASURE_GROUP',
          colLblNm: 'Measure group',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'MEASURE',
          colLblNm: 'Measure',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'UPLOAD_UOM',
          colLblNm: 'Upload UOM',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
        {
          colNm: 'PROJECT',
          colLblNm: 'Project',
          horzAlgnCd: 'L',
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
          cellCboDataTp: 'string',
          inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY,
          colWth: 200,
          fixed: false,
          uppercase: true,
          visible: true,
          display: true,
        },
      ]}
    />
  );
};
