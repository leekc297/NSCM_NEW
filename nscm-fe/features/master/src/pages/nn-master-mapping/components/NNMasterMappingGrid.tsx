/**
 * DMF0072 NNMasterMapping — Wijmo FlexGrid (22 cols, hidden 1)
 * AS-IS: spdMain (DMF0072_NNMasterMapping.cs) — NNMasterMapping sheet, SetLockRow
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid as FlexGridReact, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter as FlexGridFilterReact } from '@mescius/wijmo.react.grid.filter';
import type { MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';

import type { NNMasterMappingRow } from '../nn-master-mapping.types';

interface NNMasterMappingGridProps {
  gridRef: MutableRefObject<FlexGrid<NNMasterMappingRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<NNMasterMappingRow> | undefined>;
  data: NNMasterMappingRow[];
}

export const NNMasterMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: NNMasterMappingGridProps) => {
  return (
    <FlexGridReact
      itemsSource={data}
      initialized={(g: FlexGrid<NNMasterMappingRow>) => {
        gridRef.current = g;
      }}
      allowAddNew={true}
      allowDelete={true}
      style={{ height: 'calc(100vh - 320px)' }}
    >
      <FlexGridFilterReact
        initialized={(f: FlexGridFilter) => {
          gridFilterRef.current = f;
        }}
      />
      {/* 22 cols (hidden 1 포함) — web_components.md §4 와 1:1 일치 */}
      <FlexGridColumn header='Excel/RPA' binding='DATA_TYPE_CODE' width={80} dataType='String' />
      <FlexGridColumn header='Division' binding='DIVISION_ID' width={60} isReadOnly />
      <FlexGridColumn header='Company' binding='COMPANY_ID' width={80} dataType='String' />
      <FlexGridColumn header='SOLDTO' binding='SOLDTO_CODE' width={100} />
      <FlexGridColumn header='SHIPTO' binding='SHIPTO_CODE' width={100} />
      <FlexGridColumn header='CUST_UNLOAD' binding='UNLOADING_POINT' width={100} maxLength={35} />
      <FlexGridColumn header='CUST_PLANT' binding='CUSTOMER_PLANT' width={80} maxLength={10} />
      <FlexGridColumn header='CUST_ITEM_ID' binding='CUSTOMER_ITEM_ID' width={120} maxLength={50} />
      <FlexGridColumn header='End Customer' binding='END_CUSTOMER' width={100} />
      <FlexGridColumn header='SCM Site' binding='SCM_SITE_ID' width={100} />
      <FlexGridColumn header='Project' binding='PROJECT_CODE' width={100} />
      <FlexGridColumn header='FCST Type' binding='FCST_TYPE' width={80} />
      <FlexGridColumn header='Incoterms' binding='INCOTERMS' width={80} />
      <FlexGridColumn header='Dom/Exp' binding='DOM_EXP' width={80} />
      <FlexGridColumn header='MDM Code' binding='ITEM_ID' width={120} />
      <FlexGridColumn header='Mapping' binding='MAPPING_ITEM_ID' width={120} />
      {/* hidden UPDATE 키 */}
      <FlexGridColumn binding='MAPPING_ITEM_ID_ORIGINAL' width={0} visible={false} />
      <FlexGridColumn header='Valid Start' binding='VALID_START_DATE' width={100} />
      <FlexGridColumn header='Valid End' binding='VALID_END_DATE' width={100} />
      <FlexGridColumn header='ACTIVE_FLAG' binding='ACTIVE_YN' width={60} dataType='Boolean' />
      <FlexGridColumn header='Updated By' binding='LAST_UPDATED_BY' width={80} isReadOnly />
      <FlexGridColumn header='Update Date' binding='LAST_UPDATE_DATE' width={100} isReadOnly />
    </FlexGridReact>
  );
};
