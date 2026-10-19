import { AllowMerging, type CellRangeEventArgs, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS } from '../sales-site.constants';
import { RESPONSE_SET, SHEET_INDEX } from '../sales-site.constants';
import { useSalesSiteStore } from '../useSalesSiteStore';
import {
  BUCKET_DUPLICATE_KEYS,
  DUPLICATE_KEY_MSG,
  DUPLICATE_KEY_MSG_ID,
  formatDuplicateKeyMessage,
  hasDuplicateKey,
} from '../utils/sales-site.util';

type BucketRow = ResponseData<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>;

interface SalesSiteBucketGridProps {
  gridRef: MutableRefObject<FlexGrid<BucketRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: BucketRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteBucketGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: SalesSiteBucketGridProps) => {
  const editTrackerRef = useRef<EditTracker<BucketRow> | undefined>();

  const { t } = useTranslation();

  const staticColumns = useSalesSiteStore(state => state.staticColumns);
  const setAlert = useMessageStore(state => state.setAlert);

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.BUCKET);
  };

  // Incoterms 를 입력했는데 같은 Division·Sales Site 에 같은 Incoterms 행이 이미 있으면
  //   MSG00060 알림 후 입력값을 비운다 — AS-IS shtSubBucketDataModel_Changed(.cs:2395~2423) 1:1.
  //   저장 SP 는 같은 키 두 행을 받으면 뒤 행 값으로 앞 행을 덮어쓰므로 여기서 막아야 한다.
  //   비교 대상 행은 grid 에서 직접 읽는다 (Customer 그리드 Rep 검사와 같은 이유).
  const handleIncotermsChange = (grid: FlexGrid<BucketRow>, cellRangeEventArgs: CellRangeEventArgs) => {
    const row = cellRangeEventArgs.row;
    const binding = GridUtils.getBinding(grid, cellRangeEventArgs.col);
    const dataItem = GridUtils.getRow(grid, row);

    if (binding !== 'INCOTERMS' || !dataItem) return;

    const rows = (grid.collectionView?.sourceCollection ?? []);
    if (!hasDuplicateKey(rows, dataItem, BUCKET_DUPLICATE_KEYS)) return;

    void setAlert({
      type: 'alert',
      content: formatDuplicateKeyMessage(
        t(DUPLICATE_KEY_MSG_ID, DUPLICATE_KEY_MSG),
        BUCKET_DUPLICATE_KEYS,
        key => grid.columns.getColumn(key)?.header
      ),
    });

    editTrackerRef.current?.storeChange(dataItem, 'INCOTERMS', dataItem.INCOTERMS, '');
    dataItem.INCOTERMS = '' as typeof dataItem.INCOTERMS;
    GridUtils.refreshRow(grid, row);
  };

  return (
    <DataGrid<BucketRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns[RESPONSE_SET.BUCKET] ?? []}
      allowMerging={AllowMerging.ColumnHeaders}
      gotFocus={handleFocus}
      cellEditEnded={handleIncotermsChange}
    />
  );
};
