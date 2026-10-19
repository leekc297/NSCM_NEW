import { CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { OwnerModal } from '../../../components';
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';
import type { MENU_ID, RESPONSE_SET } from '../sales-site-project-model.constants';
import { SHEETS, SHEET_INDEX, SINGLE_OWNER_DIVISIONS } from '../sales-site-project-model.constants';
import { useEditBaseline } from '../sales-site-project-model.editBaseline';
import { useSalesSiteProjectModelStore } from '../useSalesSiteProjectModelStore';

interface SalesSiteProjectModelPurchaseGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.PURCHASE, RESPONSE_SET.PURCHASE>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PURCHASE, RESPONSE_SET.PURCHASE>[];
  setActiveTab: (sheetIndex: SHEET_INDEX) => void;
}

export const SalesSiteProjectModelPurchaseGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteProjectModelPurchaseGridProps) => {
  const editTrackerRef =
    useRef<EditTracker<ResponseData<MENU_ID, SHEETS.PURCHASE, RESPONSE_SET.PURCHASE>>>();

  const filters = useSalesSiteProjectModelStore(state => state.filters);
  const staticColumns = useSalesSiteProjectModelStore(state => state.staticColumns);

  const [openOwnerModal, setOpenOwnerModal] = useState<boolean>(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  // 조회 원본 기준선으로 수정상태(M)를 재판정 — 사유는 sales-site-project-model.editBaseline 참조.
  const resyncRow = useEditBaseline({ gridRef, editTrackerRef, data });

  const handleOwnerSelected = (selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]) => {
    const owners = selectedUsers.map(item => item.USER_ID).join(',');
    const ownersNames = selectedUsers.map(item => item.USER_NAME_EN).join(',');

    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;

    editTrackerRef.current?.storeChange(dataItem, 'OWNER', dataItem.OWNER, owners);
    editTrackerRef.current?.storeChange(dataItem, 'OWNER_NAME', dataItem.OWNER_NAME, ownersNames);

    dataItem.OWNER = owners;
    dataItem.OWNER_NAME = ownersNames;

    resyncRow(dataItem);
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.PURCHASE);
  };

  const handleUserIdCellClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (binding === 'OWNER') {
      setClickedRow(ht.row);
      setOpenOwnerModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.PURCHASE, RESPONSE_SET.PURCHASE>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[SHEETS.PURCHASE]}
        gotFocus={handleFocus}
        dblClick={handleUserIdCellClick}
      />
      {openOwnerModal && (
        <OwnerModal
          open={openOwnerModal}
          modalClose={() => setOpenOwnerModal(false)}
          setSelectedValue={handleOwnerSelected}
          divisionId={filters.purchase?.divisionId ?? '40'}
          ownerId={clickedDataItem?.OWNER}
          // 신규 행은 DIVISION_ID 가 비어있을 수 있어 조회 조건으로 폴백.
          singleSelect={SINGLE_OWNER_DIVISIONS[SHEETS.PURCHASE].includes(
            clickedDataItem?.DIVISION_ID || filters.purchase?.divisionId || ''
          )}
        />
      )}
    </>
  );
};
