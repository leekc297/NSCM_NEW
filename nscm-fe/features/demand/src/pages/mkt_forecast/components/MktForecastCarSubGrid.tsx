import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { FlexGridFilter } from '@mescius/wijmo.react.grid.filter';

import { useTabProcQuery } from '@shared/hooks';

import { MENU_ID, SHEETS } from '../mkt-forecast-master.constants';

interface Props {
  divisionId: string;
  carMaker?: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
}

// AS-IS DMF0003_1_MktFcst.cs L6401 btnCalculation_Click + Sub-Grid 2 (Car Fcst)
//   - 20 컬럼 read-only
//   - SP: DMF0003_GET_DM_ANL_CAR_REF (4 IN + 2 OUT) + CAR_PROPERTY
//   - cmbCarMaker_SelectedIndexChanged 시 CAR_PROPERTY 호출
//
// Phase 4 적용:
//   - Tab 전환 시 useTabProcQuery 로 Car 데이터 fetch
//   - cellEditEnded 미제공 (read-only)

interface CarRow {
  CAR_MAKER: string;
  CAR_MODEL: string;
  YYYYMMDD: string;
  PRODUCTION_QTY: number;
  CAR_BATTERY_QTY: number;
  MARKET_SHARE: number;
  [key: string]: string | number;
}

export const MktForecastCarSubGrid = ({
  divisionId,
  carMaker,
  fromYyyymmdd,
  toYyyymmdd,
}: Props) => {
  const filters = {
    divisionId,
    carMaker: carMaker ?? 'ALL',
    fromYyyymmdd,
    toYyyymmdd,
  } as never;

  const { data, isLoading } = useTabProcQuery<MENU_ID, SHEETS.CAR_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.CAR_FCST,
    tabId: 'carFcst',
    filters,
    enabled: !!carMaker,
  });

  const rows: CarRow[] = (((data as { o_rc1?: CarRow[] })?.o_rc1 ?? []) as unknown as CarRow[]);

  if (isLoading) {
    return <div style={{ padding: 16, color: '#1976d2' }}>⏳ Car Fcst 데이터 조회 중...</div>;
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
      <FlexGridColumn binding='CAR_MAKER' header='Car Maker' width={120} align='center' />
      <FlexGridColumn binding='CAR_MODEL' header='Car Model' width={140} align='left' />
      <FlexGridColumn binding='YYYYMMDD' header='Date' width={100} align='center' />
      <FlexGridColumn binding='PRODUCTION_QTY' header='Production Qty' width={130} align='right' />
      <FlexGridColumn binding='CAR_BATTERY_QTY' header='Car Battery Qty' width={130} align='right' />
      <FlexGridColumn binding='MARKET_SHARE' header='Market Share %' width={120} align='right' format='n2' />
    </FlexGrid>
  );
};
