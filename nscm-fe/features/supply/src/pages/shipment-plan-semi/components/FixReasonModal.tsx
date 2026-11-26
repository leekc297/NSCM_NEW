import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL } from '../shipment-plan-semi.constants';

// DB GT_SCP0010_FIX.P_FIX_REASON / SCP_ANL_SHIPMENT_PLAN_FIX.FIX_REASON 은 VARCHAR2(400 byte) 다.
//   한글(3 byte) 기준으로도 넘지 않도록 자매 FG 와 같은 100자로 제한한다.
const MAX_REASON_LENGTH = 100;

interface Props {
  open: boolean;
  onClose: () => void;
  // 사유 확정(OK) 콜백 — 취소(onClose)는 저장을 중단한다(AS-IS SaveData_FixInfo .cs:3970-3980).
  onConfirm: (reason: string) => void;
}

// AS-IS SCM0002_RejectReasonPopup("Fix Reason") 대응 모달(자매 shipment-plan-fg FixReasonModal 과 동일).
//   사유가 비면 OK 를 비활성으로 두어 AS-IS 팝업의 빈 값 차단을 대신한다.
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
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={onClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              disabled={trimmed === ''}
              buttonLabel='OK'
              onClick={() => onConfirm(trimmed)}
            />
          </Stack>
        </div>
      }
    />
  );
};
