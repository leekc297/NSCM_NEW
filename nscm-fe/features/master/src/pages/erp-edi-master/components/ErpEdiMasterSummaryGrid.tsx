import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, SHEETS } from '../erp-edi-master.constants';
import { applyReadOnlyColoring } from '../erp-edi-master.utils';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterSummaryGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SUMMARY>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SUMMARY>[];
  onDblClick: (sFlag: string, division: string, senderName: string) => void;
}

export const ErpEdiMasterSummaryGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onDblClick,
}: ErpEdiMasterSummaryGridProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.summary);

  // Summary 셀 더블클릭 (V12, V17)
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    // C# 의 sFlag 는 ActiveColumnIndex (4=GSCM Master Data, 5=정상, 6=예외처리).
    // 동적 컬럼이므로 binding 으로 매칭하여 flag 결정.
    const binding = GridUtils.getBinding(grid, ht.col);
    let sFlag: string;
    if (binding === 'GSCM_MASTER_DATA') sFlag = '4';
    else if (binding === 'SUCCESS') sFlag = '5';
    else if (binding === 'EXCEPTION_DATA') sFlag = '6';
    else return;

    // V17: GSCM_MASTER_DATA 더블클릭이고 값이 0 이면 정비할 데이터 없음
    if (sFlag === '4' && dataItem.GSCM_MASTER_DATA === '0') {
      void setAlert({
        type: 'alert',
        content: t('MSG00605', '_정비할 데이터가 없습니다.'),
      });
      return;
    }

    onDblClick(sFlag, dataItem.DIVISION_ID, dataItem.EDI_SENDER_NAME);
  };

  return (
    <DataGrid<ResponseData<MENU_ID, SHEETS.SUMMARY>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dblClick={handleDblClick}
      formatItem={applyReadOnlyColoring}
    />
  );
};
