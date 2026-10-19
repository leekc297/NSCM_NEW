import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS } from '../plant-site.constants';
import { MSG, SHEET_INDEX } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { isCustomerCellRowLocked, str } from '../utils/plant-site.util';

import { CustomerModal } from './modals/CustomerModal';

type CustomerRow = ResponseData<MENU_ID, SHEETS.CUSTOMER, 'o_rc1'>;

interface PlantSiteCustomerGridProps {
  gridRef: MutableRefObject<FlexGrid<CustomerRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: CustomerRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  isMainDirty: () => boolean;
}

export const PlantSiteCustomerGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
  isMainDirty,
}: PlantSiteCustomerGridProps) => {
  const { t } = useTranslation();
  const editTrackerRef = useRef<EditTracker<CustomerRow> | undefined>();

  const staticColumns = usePlantSiteStore(state => state.staticColumns);
  const selectedSite = usePlantSiteStore(state => state.selectedSite);
  const { setAlert } = useMessageStore.getState();

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [openCustomer, setOpenCustomer] = useState<boolean>(false);

  const handleFocus = () => setActiveTab(SHEET_INDEX.CUSTOMER);

  const rows = (): CustomerRow[] =>
    gridRef.current?.collectionView?.sourceCollection ?? [];

  // R-27 + R-28: Customer 팝업 6필드 반영 후, 동일 (SOLDTO,SHIPTO) 조합 중복이면 전부 클리어 + 경고.
  const setCustomer = (
    soldToCode: string,
    soldToDesc: string,
    shipToCode: string,
    shipToDesc: string,
    shipToRegion: string,
    shipToCity: string
  ) => {
    const row = GridUtils.getRow(gridRef.current, clickedRow);
    if (!row) return;
    const duplicate = rows().some(
      r => r !== row && str(r.SOLDTO_CODE) === soldToCode && str(r.SHIPTO_CODE) === shipToCode
    );
    const tracker = editTrackerRef.current;
    tracker?.storeChange(row, 'SOLDTO_CODE', row.SOLDTO_CODE, duplicate ? '' : soldToCode);
    if (duplicate) {
      row.SOLDTO_CODE = '';
      row.SOLDTO_DESCRIPTION = '';
      row.SHIPTO_CODE = '';
      row.SHIPTO_DESCRIPTION = '';
      row.SHIPTO_REGION_NAME = '';
      row.SHIPTO_CITY_NAME = '';
      void setAlert({ type: 'alert', content: t(MSG.DUPLICATE_KEY, '_중복된 키가 존재합니다.') });
    } else {
      row.SOLDTO_CODE = soldToCode;
      row.SOLDTO_DESCRIPTION = soldToDesc;
      row.SHIPTO_CODE = shipToCode;
      row.SHIPTO_DESCRIPTION = shipToDesc;
      row.SHIPTO_REGION_NAME = shipToRegion;
      row.SHIPTO_CITY_NAME = shipToCity;
    }
    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  // 편집 가드 — R-06①(main dirty 배타) + EDIT_FLAG='N' 행 차단(hook #128 행 게이트, §1.3).
  //   행 잠금 판정(isCustomerCellRowLocked)은 beginningEdit·pastingCell·formatItem 3곳 공통 적용
  //   (grid-behavior-parity §2, hook #95 — 붙여넣기 우회·편집색 불일치 방지).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const editHandler = (s: FlexGrid<CustomerRow>, e: CellRangeEventArgs) => {
      // R-06①(G6): 상단 site 그리드에 미저장 변경이 있으면 하단 편집 차단(AS-IS cs:556-560).
      if (isMainDirty()) {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.MAIN_SUB_EDIT_NOTICE, '_상단 그리드의 변경사항을 먼저 저장하세요.'),
        });
        return;
      }
      const row = GridUtils.getRow(s, e.row);
      if (row && isCustomerCellRowLocked(row)) e.cancel = true;
    };
    // 붙여넣기는 alert 없이 동일 게이트만 통과시킨다(다중 셀 paste 의 알림 반복 방지).
    const pasteHandler = (s: FlexGrid<CustomerRow>, e: CellRangeEventArgs) => {
      const row = GridUtils.getRow(s, e.row);
      if (isMainDirty() || (row && isCustomerCellRowLocked(row))) e.cancel = true;
    };
    const formatHandler = (s: FlexGrid<CustomerRow>, e: FormatItemEventArgs) => {
      if (e.panel !== s.cells) return;
      const row = GridUtils.getRow(s, e.row);
      if (row && isCustomerCellRowLocked(row)) e.cell.classList.remove('wj-cell-editable');
    };
    grid.beginningEdit.addHandler(editHandler);
    grid.pastingCell.addHandler(pasteHandler);
    grid.formatItem.addHandler(formatHandler);
    return () => {
      grid.beginningEdit.removeHandler(editHandler);
      grid.pastingCell.removeHandler(pasteHandler);
      grid.formatItem.removeHandler(formatHandler);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data]);

  // R-26 REP 단일성 — 'Y' 로 바꿨을 때 같은 site 에 이미 'Y' 가 있으면 되돌림 + 경고(FE 1차 방어).
  const handleCellEdit = (grid: FlexGrid<CustomerRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const row = GridUtils.getRow(grid, e.row);
    if (!binding || !row) return;
    if (binding === 'REP_YN' && str(row.REP_YN) === 'Y') {
      const others = rows().some(r => r !== row && str(r.REP_YN) === 'Y' && str(r.VALID_YN) !== 'N');
      if (others) {
        row.REP_YN = 'N';
        void setAlert({ type: 'alert', content: t(MSG.REP_SINGLE, '_대표는 하나만 지정할 수 있습니다.') });
        GridUtils.refreshRow(grid, e.row);
      }
    }
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!row || !binding) return;
    if (binding === 'SOLDTO_CODE' || binding === 'SHIPTO_CODE') {
      setClickedRow(ht.row);
      setOpenCustomer(true);
    }
  };

  const clicked = GridUtils.getRow(gridRef.current, clickedRow);

  return (
    <>
      <DataGrid<CustomerRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns.customer}
        comboParams={{ mnuId: 'SCP0001' }}
        gotFocus={handleFocus}
        cellEditEnded={handleCellEdit}
        dblClick={handleDblClick}
      />
      <CustomerModal
        open={openCustomer}
        modalClose={() => setOpenCustomer(false)}
        setSelectedValue={setCustomer}
        divisionId={selectedSite?.divisionId}
        soldTo={clicked?.SOLDTO_CODE}
        shipTo={clicked?.SHIPTO_CODE}
      />
    </>
  );
};
