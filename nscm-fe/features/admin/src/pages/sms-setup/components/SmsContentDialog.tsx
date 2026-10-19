import { CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { SMS_CONTENT_MAX_BYTES } from '../sms-setup.constants';
import { isOverSmsContentLimit } from '../sms-setup.util';
import { useSmsSetupStore } from '../useSmsSetupStore';

import styles from './SmsDialog.module.scss';

interface SmsContentDialogProps {
  onApply: (content: string) => void;
}

// AS-IS SCM0007_PopContent 는 rtxtContent(RichTextBox) 외에 btnButtonList(UsrButtonList)를 갖고
// 있으나, Roslyn 추출은 클릭 이벤트 존재만 확인될 뿐 버튼 목록 항목(예: 치환 변수 삽입)의 실제 내용을
// 캡쳐하지 못했다. 근거 없이 버튼 구성을 추정하지 않고, 본문 편집 textarea 만 우선 구현한다.
// TODO(확인필요): btnButtonList(UsrButtonList_Click_Detected, 원본 line 197)의 실제 버튼 항목 —
// AS-IS .cs 원문 직접 확인 필요.
export const SmsContentDialog = ({ onApply }: SmsContentDialogProps) => {
  const { t } = useTranslation();

  const isOpen = useSmsSetupStore(state => state.isContentDialogOpen);
  const readOnly = useSmsSetupStore(state => state.contentDialogReadOnly);
  const contentDraft = useSmsSetupStore(state => state.contentDraft);
  const setContentDraft = useSmsSetupStore(state => state.setContentDraft);
  const closeContentDialog = useSmsSetupStore(state => state.closeContentDialog);
  const setAlert = useMessageStore(state => state.setAlert);

  if (!isOpen) return null;

  const handleChange = (value: string) => {
    // AS-IS PopContent 는 MSG00165 를 초과 입력 검증에 사용(line 123/134/146) — 정확한 임계값 문구는
    // TODO(확인필요) 항목이며, 우선 SMS_CONTENT_MAX_BYTES 단일 기준으로 차단한다.
    if (isOverSmsContentLimit(value)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00165', '_You have exceeded the number of digits you can enter.'),
      });
      return;
    }
    setContentDraft(value);
  };

  const handleOk = () => {
    onApply(contentDraft);
  };

  return (
    <CustomDialog
      open={isOpen}
      size={800}
      height='55vh'
      // LBL00782 는 "Mail Content *" 로 고정 등록돼 있어 재사용 시 SMS 화면에 "Mail" 문구가 노출된다
      // (AS-IS SCM0007_SMS_Setup.cs:1101/1120 팝업 타이틀과 동일 워딩으로 LBL01049 신규 채번, 2026-09-11).
      title={t('LBL01049', '_SMS Content *')}
      handleClose={closeContentDialog}
      customContentArea={
        <div className={styles.contentArea}>
          <textarea
            className={styles.textArea}
            value={contentDraft}
            readOnly={readOnly}
            maxLength={SMS_CONTENT_MAX_BYTES}
            onChange={event => handleChange(event.target.value)}
          />
          {/* CustomDialog 는 customContentArea 지정 시 기본 하단 OK/Cancel 버튼을 렌더링하지 않는다
              (CustomDialogContent.tsx lowerButtonGroup 분기) — AS-IS PopContent 의 OK/Cancel 대응.
              버튼 스타일은 같은 customContentArea 패턴인 ItemByDivisionModal 과 통일(contained+아이콘
              OK / outlined Close). */}
          <div className={styles.buttonWrapper}>
            {!readOnly && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                iconComponent={<ControlConfirmIcon size='small' />}
                iconPosition='leading'
                buttonLabel={t('LBL00359', '_확인')}
                onClick={handleOk}
              />
            )}
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00107', '_취소')}
              onClick={closeContentDialog}
            />
          </div>
        </div>
      }
    />
  );
};
