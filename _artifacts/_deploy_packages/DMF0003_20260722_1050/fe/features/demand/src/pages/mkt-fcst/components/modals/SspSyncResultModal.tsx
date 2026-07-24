import type { FlexGrid } from '@mescius/wijmo.grid';
import { useRef } from 'react';

import { DataGrid, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';

import styles from '../../MktFcst.module.scss';

import { SSP_SYNC_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 SspSyncPopUp (AS-IS DMF0003_SspSyncPopUp.cs).
//   트리거: SAVE 응답에 동기화수량 detail row 존재 시 (AS-IS .cs L1610~1617 — 응답 Tables[1].Rows.Count>0).
//   TO-BE: DMF0003_SAVE_MKT_FCST 의 O_RC1(동기화 detail). 본 모달은 그 rows 를 직접 표시 (read-only,
//          자체 SP 호출 없음). 사용자에게 "동기화수량보다 작게 수정한 건" 내역 안내.
//   SP O_RC1 컬럼: AS-IS InitSpread(L136~145) = MEASURE/PROJECT_CODE/SCM_SITE_ID/ITEM_ID/INCOTERMS/
//                  FCST_TYPE/DOM_EXP/YYYYMMDD/SYNC_QTY/QTY.
// SAVE 응답 O_RC1 동기화 detail row. 컬럼 = SSP_SYNC_COLUMNS(MEASURE/PROJECT_CODE/SCM_SITE_ID/
//   ITEM_ID/INCOTERMS/FCST_TYPE/DOM_EXP/YYYYMMDD/SYNC_QTY/QTY). WijmoRowItem(global) 호환.
export type SspSyncResultRow = WijmoRowItem;

interface SspSyncResultModalProps {
  open: boolean;
  modalClose: () => void;
  rows: SspSyncResultRow[];
}

export const SspSyncResultModal = ({ open, modalClose, rows }: SspSyncResultModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<SspSyncResultRow>>();

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
          <h2 className='headerTitle'>{t('LBL00695', '_SSP Sync Result')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <DataGrid<SspSyncResultRow>
              gridRef={gridRef}
              isReadOnly
              staticColumns={SSP_SYNC_COLUMNS}
              itemsSource={rows}
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
