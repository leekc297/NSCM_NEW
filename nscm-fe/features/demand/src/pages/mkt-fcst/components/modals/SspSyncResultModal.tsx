import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { attachRowNoHeader } from '@foundation/utils';
import { DataGrid, CustomDialog, ResultArea } from '@shared/components';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, rows]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00695', '_SSP Sync Result')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<SspSyncResultRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={SSP_SYNC_COLUMNS}
                itemsSource={rows}
              />
            </ResultArea>
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
