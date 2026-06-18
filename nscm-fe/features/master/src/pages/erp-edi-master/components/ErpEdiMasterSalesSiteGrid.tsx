import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { CustomerModal, RegionModal, TeamModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterSalesSiteGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>[];
}

const YELLOW_HIGHLIGHT_COLUMNS = new Set([
  'END_CUSTOMER',
  'SOLDTO_CUSTOMER',
  'COMPANY_ID',
  'VMI_YN',
  'SITE_VALID_YN',
  'CUSTOMER_VALID_YN',
  'REP_YN',
  'COUNTRY_NAME',
  'CITY_NAME',
  'SHIP_PLAN_AUTO',
]);

export const ErpEdiMasterSalesSiteGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: ErpEdiMasterSalesSiteGridProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.salesSite);

  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openRegionModal, setOpenRegionModal] = useState(false);
  const [openTeamModal, setOpenTeamModal] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    setClickedRow(ht.row);

    if (binding === 'REP_SOLDTO_CODE' || binding === 'REP_SHIPTO_CODE') {
      setOpenCustomerModal(true);
    } else if (binding === 'COUNTRY_NAME' || binding === 'CITY_NAME') {
      setOpenRegionModal(true);
    } else if (binding === 'TEAM_NAME') {
      setOpenTeamModal(true);
    }
  };

  // 노란색 셀 시각 (조회 모드 — 모든 행)
  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>,
    args: FormatItemEventArgs
  ) => {
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string' || !YELLOW_HIGHLIGHT_COLUMNS.has(binding)) return;
    args.cell.style.backgroundColor = 'rgba(255, 212, 0, 1)';
  };

  const setCustomer = (
    soldTo: string,
    _soldToDesc: string,
    shipTo: string,
    _shipToDesc: string
  ) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.REP_SOLDTO_CODE = soldTo;
    dataItem.REP_SHIPTO_CODE = shipTo;
    gridRef.current?.refresh();
  };

  const setRegion = (
    countryCode: string,
    countryName: string,
    cityCode: string,
    cityName: string
  ) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.COUNTRY = countryCode;
    dataItem.COUNTRY_NAME = countryName;
    dataItem.CITY = cityCode;
    dataItem.CITY_NAME = cityName;
    // F12a [IMMEDIATE] ✅: SCM_SITE_ID 자동 조합 (SOLDTO_CUSTOMER + "_" + CITY[0:2] + "_" + CITY[2:5])
    if (dataItem.SOLDTO_CUSTOMER && cityCode.length >= 5) {
      const composed = `${dataItem.SOLDTO_CUSTOMER}_${cityCode.slice(0, 2)}_${cityCode.slice(2, 5)}`;
      // F12b [IMMEDIATE] ✅ V14: 동일 SSCM_SITE_ID 중복 검증 (자기 자신 제외)
      const isDuplicate = data.some(
        (row, idx) => idx !== clickedRow && row?.SSCM_SITE_ID === composed
      );
      if (isDuplicate) {
        void setAlert({
          type: 'alert',
          content: t('MSG00060', '_필수 입력사항입니다.'),
        });
        dataItem.SSCM_SITE_ID = '';
      } else {
        dataItem.SSCM_SITE_ID = composed;
      }
    }
    gridRef.current?.refresh();
  };

  const setTeam = (teamId: string, teamName?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.TEAM_ID = teamId;
    dataItem.TEAM_NAME = teamName ?? '';
    gridRef.current?.refresh();
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
        formatItem={handleFormatItem}
      />
      {openCustomerModal && (
        <CustomerModal
          open={openCustomerModal}
          modalClose={() => setOpenCustomerModal(false)}
          setSelectedValue={setCustomer}
          divisionId={GridUtils.getRow(gridRef.current, clickedRow)?.DIVISION_ID}
        />
      )}
      {openRegionModal && (
        <RegionModal
          open={openRegionModal}
          modalClose={() => setOpenRegionModal(false)}
          setSelectedValue={setRegion}
        />
      )}
      {openTeamModal && (
        <TeamModal
          open={openTeamModal}
          modalClose={() => setOpenTeamModal(false)}
          setSelectedValue={setTeam}
        />
      )}
    </>
  );
};
