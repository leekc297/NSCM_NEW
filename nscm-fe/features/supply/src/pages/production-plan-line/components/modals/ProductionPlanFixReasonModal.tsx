import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL } from '../../production-plan-line.constants';

interface Props {
  open: boolean;
  onClose: () => void;
  // 사유 확정(OK) 콜백 — 취소(onClose)는 저장을 중단한다(design 01 R6 — 취소 시 return).
  onConfirm: (reason: string) => void;
}

// design 01 R6 / §3.2 — AS-IS SCM0002_RejectReasonPopup("Fix Reason") 등가 화면 전용 모달.
//   Fix 액션 전 사유를 필수 입력받고, OK 시에만 사유와 함께 저장한다. 취소하면 저장하지 않는다.
export const ProductionPlanFixReasonModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [reason, setReason] = useState('');

  // 재오픈 시 이전 입력 초기화(팝업 재오픈 규약 — CommonCheckList 팝업).
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
          {/* Fix Reason — 실측 LBL 코드 조합(Fix=LBL00771, Reason=LBL00625, lbl-dict). */}
        <h2 className='headerTitle'>{`${t(LBL.FIX, '_Fix')} ${t(LBL.REASON, '_Reason')}`}</h2>
        </div>
      }
      customContentArea={
        <div>
          <InputField
            type='textarea'
            fullWidth
            value={reason}
            onChange={e => setReason(e.target.value)}
          />
          <Stack direction='row' spacing={1} justifyContent='flex-end' marginTop={1}>
            {/* 버튼 정렬: 액션(색) 좌측 + Close 최우측 (CommonCheckList 팝업 버튼 정렬). */}
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              disabled={trimmed === ''}
              buttonLabel={t(LBL.OK, '_OK')}
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
