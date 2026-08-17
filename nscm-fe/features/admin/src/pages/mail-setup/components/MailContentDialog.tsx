import { CustomDialog } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MAIL_CONTENT_MAX_BYTES } from '../mail-setup.constants';
import { isOverMailContentLimit } from '../mail-setup.util';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailDialog.module.scss';

interface MailContentDialogProps {
  onApply: (content: string) => void;
}

export const MailContentDialog = ({ onApply }: MailContentDialogProps) => {
  const { t } = useTranslation();

  const isOpen = useMailSetupStore(state => state.isContentDialogOpen);
  const readOnly = useMailSetupStore(state => state.contentDialogReadOnly);
  const contentDraft = useMailSetupStore(state => state.contentDraft);
  const setContentDraft = useMailSetupStore(state => state.setContentDraft);
  const closeContentDialog = useMailSetupStore(state => state.closeContentDialog);
  const setAlert = useMessageStore(state => state.setAlert);

  if (!isOpen) return null;

  const handleChange = (value: string) => {
    // AS-IS: 초과 입력 시 경고 후 직전 내용 유지 (TO-BE 단일 기준 4,000바이트 — 설계서 격차 G1)
    if (isOverMailContentLimit(value)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00698', '_You have exceeded the number of digits you can enter.'),
      });
      return;
    }
    setContentDraft(value);
  };

  return (
    <CustomDialog
      open={isOpen}
      size={800}
      height='55vh'
      title={t('LBL00782', '_Mail Content *')}
      disableButtonCancel={readOnly}
      handleClose={closeContentDialog}
      handleSubmit={readOnly ? undefined : () => onApply(contentDraft)}
      customContentArea={
        <div className={styles.contentArea}>
          <textarea
            className={styles.textArea}
            value={contentDraft}
            readOnly={readOnly}
            maxLength={MAIL_CONTENT_MAX_BYTES}
            onChange={event => handleChange(event.target.value)}
          />
        </div>
      }
    />
  );
};
