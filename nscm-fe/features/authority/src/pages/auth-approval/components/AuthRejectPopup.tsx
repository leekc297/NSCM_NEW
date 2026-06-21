import { useState } from 'react';

import { CustomDialog } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { useAuthApprovalStore } from '../useAuthApprovalStore';

import styles from './AuthRejectPopup.module.scss';

interface Props {
  onReject: (reason: string) => void;
}

export const AuthRejectPopup = ({ onReject }: Props) => {
  const { t } = useTranslation();
  const open = useAuthApprovalStore(s => s.openRejectPopup);
  const setOpen = useAuthApprovalStore(s => s.setOpenRejectPopup);
  const setAlert = useMessageStore(s => s.setAlert);
  const [reason, setReason] = useState('');

  // AS-IS SCM0002_RejectReasonPopup.GetReason() — Length>0 검증 + Trim 처리 + MSG00181
  const handleSave = () => {
    const trimmed = reason.trim();
    if (trimmed.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00181', '_Reject Reason을 입력하세요.') });
      return;
    }
    onReject(trimmed);
    setReason('');
  };

  const headerTitle = (
    <div className='headerContainer'>
      <div className='headerDot' />
      <h2 className='headerTitle'>{t('LBL00628', 'Reject Reason')}</h2>
    </div>
  );
  return (
    <CustomDialog
      open={open}
      size={600}
      type='modal'
      position='basic'
      handleClose={() => setOpen(false)}
      customHeaderTitle={headerTitle}
      customContentArea={
        <div className={styles.dialogContent}>
          <FormItem
            label={t('LBL00625', 'Reason')}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                type='textarea'
                height={320}
                value={reason}
                onChange={e => setReason(e.target.value)}
              />
            )}
          />
          <div className={styles.actionBar}>
            <button
              type='button'
              className={`${styles.actionButton} ${styles.primary}`}
              onClick={handleSave}
            >
              {t('LBL00626', 'Save')}
            </button>
            <button type='button' className={styles.actionButton} onClick={() => setOpen(false)}>
              {t('LBL00627', 'Close')}
            </button>
          </div>
        </div>
      }
    />
  );
};
