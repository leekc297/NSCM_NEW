import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL } from '../../shipment-plan-fg.constants';

// DB `T_SCP0009_ROW.P_FIX_REASON` 은 VARCHAR2(100) 이다.
const MAX_REASON_LENGTH = 100;

interface Props {
  open: boolean;
  onClose: () => void;
  // 사유 확정(OK) 콜백 — 취소(onClose)는 저장을 중단한다(AS-IS SaveData_FixInfo 4286-4288행).
  onConfirm: (reason: string) => void;
}

// AS-IS SCM0002_RejectReasonPopup("Fix Reason") 대응 모달. 사유가 비면 OK 를 비활성으로 두어
//   AS-IS 팝업의 빈 값 차단(MSG00181)을 대신한다. 저장 요청이 JSON(`data` 배열)이라 `^` 구분자 충돌은
//   없지만, 확정 전까지 AS-IS 와 같게 `^` 를 입력 단계에서 계속 제거한다(허용 여부는 사용자 확인 필요).
export const FixReasonModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [reason, setReason] = useState('');

  // 재오픈 시 이전 입력 초기화.
  useEffect(() => {
    if (open) setReason('');
  }, [open]);

  const trimmed = reason.trim();

  return (
    <CustomDialog
      open={open}
      size={600}
      height={230}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{`${t(LBL.FIX, '_Fix')} Reason`}</h2>
        </div>
      }
      customContentArea={
        <div>
          <InputField
            type='textarea'
            fullWidth
            value={reason}
            onChange={e => setReason(e.target.value.replace(/\^/g, '').slice(0, MAX_REASON_LENGTH))}
          />
          <Stack direction='row' spacing={1} justifyContent='flex-end' marginTop={1}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              disabled={trimmed === ''}
              buttonLabel='OK'
              onClick={() => onConfirm(trimmed)}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={onClose}
            />
          </Stack>
        </div>
      }
    />
  );
};
