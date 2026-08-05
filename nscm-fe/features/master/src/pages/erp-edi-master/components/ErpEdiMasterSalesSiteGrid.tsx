import { toggleClass } from '@mescius/wijmo';
import {
  CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
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
  const setAlert = useMessageStore(s => s.setAlert);
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
    if (typeof binding !== 'string') return;
    // 편집 가능 컬럼 = 표준 Yellow(`wj-cell-editable`). 그 외 = White+zebra (클래스 없음). hook #95.
    toggleClass(args.cell, 'wj-cell-editable', YELLOW_HIGHLIGHT_COLUMNS.has(binding));
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

  const applyAutoScmSiteId = (
    dataItem: ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>
  ): void => {
    const soldTo = dataItem.SOLDTO_CUSTOMER ?? '';
    const country = dataItem.COUNTRY ?? '';
    const city = dataItem.CITY ?? '';
    // (a) 3개 모두 입력된 경우에만 조합 (AS-IS: 하나라도 "" 이면 skip)
    if (!soldTo || !country || !city) return;

    const composed = `${soldTo}_${city.slice(0, 2)}_${city.slice(2, 5)}`;
    // (b) 중복 검증 — grid 라이브 items(서버+신규 전체) 순회, 자기 자신은 객체 참조로 제외.
    //   (index 대신 참조로 제외 — 정렬/필터 시 grid row index 와 view 순서가 어긋날 수 있음)
    const items = gridRef.current?.collectionView?.items ?? data;
    const isDuplicate = items.some(row => row !== dataItem && row?.SSCM_SITE_ID === composed);
    if (isDuplicate) {
      void setAlert({
        type: 'alert',
        content: t('MSG00060', '_동일 Sales Site 가 이미 존재합니다.'),
      });
      dataItem.SSCM_SITE_ID = '';
      return;
    }
    dataItem.SSCM_SITE_ID = composed;
  };

  // AS-IS shtSALES_SITEDataModel_Changed(.cs L2511) 4-branch 를 Wijmo cellEditEnded 로 이관.
  //   행 추가 후 셀을 직접 편집(SOLDTO/COUNTRY/CITY/COUNTRY_NAME/CITY_NAME)할 때 자동 발동.
  //   신규 행(CRUD_TYPE='I')에만 적용 — 기존 조회 행은 편집 대상 아님.
  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>,
    e: CellRangeEventArgs
  ) => {
    const dataItem = GridUtils.getRow(grid, e.row);
    const binding = GridUtils.getBinding(grid, e.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    // cascade 안 cascade 방지 (deferUpdate 로 batch — 룰 07 §2.10.8)
    grid.deferUpdate(() => {
      if (binding === 'SOLDTO_CUSTOMER' || binding === 'COUNTRY' || binding === 'CITY') {
        // Branch (a)+(b): 자동 조합 + 중복 검증
        applyAutoScmSiteId(dataItem);
      } else if (binding === 'COUNTRY_NAME') {
        // Branch (c): CountryName 이 비면 COUNTRY + CITY + CITY_NAME 연쇄 클리어
        if (!(dataItem.COUNTRY_NAME ?? '')) {
          dataItem.COUNTRY = '';
          dataItem.CITY = '';
          dataItem.CITY_NAME = '';
        }
      } else if (binding === 'CITY_NAME') {
        // Branch (d): CityName 이 비면 CITY 클리어
        if (!(dataItem.CITY_NAME ?? '')) {
          dataItem.CITY = '';
        }
      }
    });
    grid.refreshRange(new CellRange(e.row, 0, e.row, -1));
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
    applyAutoScmSiteId(dataItem);
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
        cellEditEnded={handleCellEditEnded}
        isReadOnly={true}
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
