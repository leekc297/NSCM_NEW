import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../mkt-forecast-master.constants';

interface Props {
  divisionId: string;
  projectCode?: string;
  itemId?: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
}

// AS-IS DMF0003_1_MktFcst.cs L6179 spdSub1_CellClick + Sub-Grid 1 (PSI 분석)
//   - 3 sub-sheets: Mkt Fcst / PSI / Car Fcst
//   - 25 컬럼 read-only
//   - SP: DMF0003_GET_DM_ANL_MKT_PSI_DATA (6 IN + 2 OUT) + AN_LOGIC
//
// Phase 4 적용:
//   - Tab 전환 시 useTabProcQuery 로 PSI 데이터 fetch
//   - cellEditEnded 미제공 (read-only)

interface PsiRow {
  PROJECT_CODE: string;
  ITEM_ID: string;
  ITEM_NAME: string;
  YYYYMMDD: string;
  MKT_FCST_QTY: number;
  PSI_QTY: number;
  GAP_QTY: number;
  [key: string]: string | number;
}

export const MktForecastPsiSubGrid = ({
  divisionId,
  projectCode,
  itemId,
  fromYyyymmdd,
  toYyyymmdd,
}: Props) => {
  const filters = {
    divisionId,
    projectCode: projectCode ?? 'ALL',
    itemId: itemId ?? 'ALL',
    fromYyyymmdd,
    toYyyymmdd,
  } as never;

  const { data, isLoading } = useTabProcQuery<MENU_ID, SHEETS.PSI>({
    menuId: MENU_ID,
    sheetName: SHEETS.PSI,
    tabId: 'psi',
    filters,
    enabled: !!projectCode && !!itemId,
  });

  const rows: PsiRow[] = (((data as { o_rc1?: PsiRow[] })?.o_rc1 ?? []) as unknown as PsiRow[]);

  if (isLoading) {
    return <div style={{ padding: 16, color: '#1976d2' }}>⏳ PSI 분석 데이터 조회 중...</div>;
  }

  return (
    <FlexGrid
      style={{ height: '100%', width: '100%' }}
      itemsSource={rows}
      isReadOnly={true}
      allowSorting={true}
      autoGenerateColumns={false}
      headersVisibility='Column'
      selectionMode='Row'
    >
      <FlexGridFilter />
      <FlexGridColumn binding='PROJECT_CODE' header='Project' width={120} align='left' />
      <FlexGridColumn binding='ITEM_ID' header='Item' width={140} align='left' />
      <FlexGridColumn binding='ITEM_NAME' header='Item Name' width={160} align='left' />
      <FlexGridColumn binding='YYYYMMDD' header='Date' width={100} align='center' />
      <FlexGridColumn binding='MKT_FCST_QTY' header='MKT FCST Qty' width={120} align='right' />
      <FlexGridColumn binding='PSI_QTY' header='PSI Qty' width={120} align='right' />
      <FlexGridColumn binding='GAP_QTY' header='GAP' width={100} align='right' />
    </FlexGrid>
  );
};
