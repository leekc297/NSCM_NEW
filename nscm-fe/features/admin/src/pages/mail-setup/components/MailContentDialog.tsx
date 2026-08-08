import { CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
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
      handleClose={closeContentDialog}
      // customContentArea 사용 시 공통 하단 버튼이 렌더되지 않음 — 자체 footer 필수
      //   (정본 forecast-price ExchangeRateModal buttonWrapper. 조회 모드는 OK 숨김 — AS-IS E11)
      customContentArea={
        <div className={styles.contentArea}>
          <textarea
            className={styles.textArea}
            value={contentDraft}
            readOnly={readOnly}
            maxLength={MAIL_CONTENT_MAX_BYTES}
            onChange={event => handleChange(event.target.value)}
          />
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00107', '_Cancel')}
              onClick={closeContentDialog}
            />
            {!readOnly && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00359', '_Confirm')}
                onClick={() => onApply(contentDraft)}
              />
            )}
          </div>
        </div>
      }
    />
  );
};
