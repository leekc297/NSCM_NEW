import type { FlexGrid } from '@mescius/wijmo.grid';
import { useRef } from 'react';

import { DataGrid, CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';

import { MENU_ID, SHEETS } from '../../mkt-fcst.constants';
import styles from '../../MktFcst.module.scss';

import { SSP_COMPARE_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 SspSyncComparePopUp (AS-IS DMF0003_SspSyncComparePopUp.cs).
//   트리거: 메인 grid CellDblClick (Div40 & MEASURE='MKT_FCST_RP' & 셀 동기화색[ATTR1 A/P], .cs L2628~2683)
//           → DMF0003_GET_MKT_FCST_COMPARE_POPUP 조회 → SSP↔MKT 비교 (read-only).
//   SP: sspCompare sheet SEARCH → DMF0003_GET_MKT_FCST_COMPARE_POPUP (8 IN + O_RC1).
export interface SspSyncCompareParams {
  divisionId: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  yyyymmdd: string;
}

interface SspSyncCompareModalProps {
  open: boolean;
  modalClose: () => void;
  params: SspSyncCompareParams | null;
}

export const SspSyncCompareModal = ({ open, modalClose, params }: SspSyncCompareModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SSP_COMPARE>>>();

  const filters = params ?? {
    divisionId: '',
    scmSiteId: '',
    projectCode: '',
    itemId: '',
    domExp: '',
    fcstType: '',
    incoterms: '',
    yyyymmdd: '',
  };

  const { data } = useTabProcQuery<MENU_ID, SHEETS.SSP_COMPARE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SSP_COMPARE,
    tabId: 'SspSyncCompareModal',
    filters,
    enabled: open && !!params,
  });

  const itemsSource = data?.o_rc1 ?? [];

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00694', '_SSP Sync Compare')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <DataGrid<ResponseData<MENU_ID, SHEETS.SSP_COMPARE>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={SSP_COMPARE_COLUMNS}
              itemsSource={itemsSource}
            />
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
