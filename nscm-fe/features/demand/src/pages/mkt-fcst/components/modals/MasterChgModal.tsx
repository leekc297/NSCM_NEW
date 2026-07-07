import type { FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef } from 'react';

import { DataGrid, CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import styles from '../../MktFcst.module.scss';

import { MASTER_CHG_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 MasterChgPopup (AS-IS DMF0003_MatsterChgPopup.cs).
//   트리거: SubTitle customButton MASTER_CHG(btnIncotermsChg, .cs L5359~5372) → Incoterms/FCST/Customs
//           일괄 변경 모달.
//   ⚠️ BE/SP 차단: GET SP(DMF0000_GET_MASTER_CHG_POPUP)가 사내 Oracle 에 미존재(ora.py 실측 0행) +
//      SAVE SP(DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE) OUT 커서 부재. 상세 차단 handoff:
//      _artifacts/_apply_corporate/38_dmf0003_masterchg_BLOCKED_handoff.md.
//   → 본 모달은 shell(컬럼/레이아웃)만. SP 적용 전까지 조회/저장 비활성. 진입 시 안내.
export interface MasterChgParams {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  projectCode: string;
}

interface MasterChgModalProps {
  open: boolean;
  modalClose: () => void;
  params: MasterChgParams | null;
}

export const MasterChgModal = ({ open, modalClose, params }: MasterChgModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<WijmoRowItem>>();
  const setAlert = useMessageStore.getState().setAlert;

  void params; // SP 적용 시 GET filters 로 사용 (현재 비활성).

  // SP 부재 안내 (anti-simplification — 미구현 은폐 금지). 사용자에게 SP 작업 필요 명시.
  useEffect(() => {
    if (open) {
      void setAlert({
        type: 'alert',
        content: t(
          'MSG00653',
          '_Master Change requires SP setup (DMF0000_GET_MASTER_CHG_POPUP). Pending corporate DB apply.'
        ),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00701', '_Master Change')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <DataGrid<WijmoRowItem>
              gridRef={gridRef}
              isReadOnly
              staticColumns={MASTER_CHG_COLUMNS}
              itemsSource={[]}
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
