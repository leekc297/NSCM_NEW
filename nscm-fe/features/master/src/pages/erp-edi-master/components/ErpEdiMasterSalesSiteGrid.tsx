import { toggleClass } from '@mescius/wijmo';
import {
  CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { CustomerModal, TeamModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterSalesSiteGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>[];
}

// AS-IS .cs L1227~1236 노란색 = 수정 가능 컬럼. 수정 모드 잠금 규칙(.cs L598~603 —
//   DIVISION_ID / SCM_SITE_ID / REP_SOLDTO_CODE / REP_SHIPTO_CODE / LAST_UPDATE*)의 여집합과 같다.
//   Yellow(wj-cell-editable) 표시와 편집 허용 판정을 이 한 집합으로 함께 쓴다.
const EDITABLE_COLUMNS = new Set([
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

// 필수 입력 컬럼(헤더 빨간 점)은 여기서 정하지 않는다 — 공용 formatEditableColumns 가
//   컬럼 메타 inputTpCd(M / IM)로 그리고, 저장 시 빈 값 차단도 같은 메타를 본다.

export const ErpEdiMasterSalesSiteGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: ErpEdiMasterSalesSiteGridProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.salesSite);

  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openTeamModal, setOpenTeamModal] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || typeof binding !== 'string' || !binding) return;

    setClickedRow(ht.row);

    // 팝업(키 컬럼)은 신규행 전용 — AS-IS 수정 모드에서도 잠긴다(.cs L600~601).
    //   COUNTRY_NAME / CITY_NAME 은 팝업이 아니라 텍스트 입력이라 여기서 다루지 않는다.
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;
    if (binding === 'REP_SOLDTO_CODE' || binding === 'REP_SHIPTO_CODE') {
      setOpenCustomerModal(true);
    } else if (binding === 'TEAM_NAME') {
      setOpenTeamModal(true);
    }
  };

  // 편집 허용 범위 — 공용 DataGrid 의 setEditableColumns 는 컬럼 메타(_inputEditType) 기준으로
  //   판정하므로, 화면 기준(AS-IS 노란색 집합)을 mount 후에 등록해 덮어쓴다.
  //   Wijmo Event 는 등록 순서대로 호출 → 마지막 등록이 최종 결정 (표준 패턴: CustomerModelMappingGrid).
  // deps 에 data/staticColumns 를 두는 이유: 공용 DataGrid 는 wijmo react 의 initialized(setTimeout)
  //   에서 gridRef 를 채우므로 첫 useEffect 시점엔 grid 가 아직 없다. 조회/컬럼메타 도착 시 다시 걸린다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handleBeginningEdit = (
      sender: FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>,
      e: CellRangeEventArgs
    ) => {
      const binding = GridUtils.getBinding(sender, e.col);
      e.cancel = typeof binding !== 'string' || !EDITABLE_COLUMNS.has(binding);
    };
    grid.beginningEdit.addHandler(handleBeginningEdit);
    // 붙여넣기도 같은 기준 — 안 걸면 타이핑은 되는데 Ctrl+V 만 막히는 상태가 된다.
    grid.pastingCell.addHandler(handleBeginningEdit);
    return () => {
      grid.beginningEdit?.removeHandler(handleBeginningEdit);
      grid.pastingCell?.removeHandler(handleBeginningEdit);
    };
  }, [gridRef, data, staticColumns]);

  // 노란색 셀 시각 (조회 모드 — 모든 행)
  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>,
    args: FormatItemEventArgs
  ) => {
    // 헤더는 손대지 않는다 — 필수 빨간 점은 공용 formatEditableColumns 가 메타로 그린다.
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string') return;
    // 편집 가능 컬럼 = 표준 Yellow(`wj-cell-editable`). 그 외 = White+zebra (클래스 없음). hook #95.
    toggleClass(args.cell, 'wj-cell-editable', EDITABLE_COLUMNS.has(binding));
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
  //   셀을 직접 편집(SOLDTO/COUNTRY/CITY/COUNTRY_NAME/CITY_NAME)할 때 자동 발동.
  //   이름 클리어 연쇄(c/d)는 조회 행에도 적용 — AS-IS 도 신규행 조건이 없다.
  //   Sales Site 자동조합(a/b)만 신규행 한정 — 조회행의 SSCM_SITE_ID 는 저장 키라 바꾸지 않는다
  //   (AS-IS 수정 모드에서도 sSCM_SITE_ID 는 잠금, .cs L599).
  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SALES_SITE, 'o_rc1'>>,
    e: CellRangeEventArgs
  ) => {
    const dataItem = GridUtils.getRow(grid, e.row);
    const binding = GridUtils.getBinding(grid, e.col);
    if (!dataItem || !binding) return;

    // cascade 안 cascade 방지 (deferUpdate 로 batch — 룰 07 §2.10.8)
    grid.deferUpdate(() => {
      if (binding === 'SOLDTO_CUSTOMER' || binding === 'COUNTRY' || binding === 'CITY') {
        // Branch (a)+(b): 자동 조합 + 중복 검증
        if (dataItem.CRUD_TYPE === CRUD_TYPE.INSERT) applyAutoScmSiteId(dataItem);
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
        isReadOnly={false}
      />
      {openCustomerModal && (
        <CustomerModal
          open={openCustomerModal}
          modalClose={() => setOpenCustomerModal(false)}
          setSelectedValue={setCustomer}
          divisionId={GridUtils.getRow(gridRef.current, clickedRow)?.DIVISION_ID}
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
