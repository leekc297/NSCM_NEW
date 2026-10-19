import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';

import { SCREEN_TEXT } from '../../shipment-change-request-plan.constants';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 확인 시 입력 건수를 넘긴다(1 이상). */
  onConfirm: (count: number) => void;
}

const MIN_COUNT = 1;
const MAX_COUNT = 999;

/**
 * SSP0200_ShipmentChangeRequestInsertPopup (design 00 §4f / 03 R-52 #4).
 *   AS-IS 는 건수 하나만 입력받아 `InsertRowMultiple(n)` 을 호출한다(전용 팝업, 149행).
 *   화면 전용 팝업이라 공용 모달을 쓰지 않고 여기에 둔다. open state 는 페이지가 소유한다.
 */
export const InsertMultipleModal = ({ open, modalClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [count, setCount] = useState('1');

  useEffect(() => {
    if (open) setCount('1');
  }, [open]);

  const handleSubmit = () => {
    const parsed = Number(count);
    if (!Number.isInteger(parsed) || parsed < MIN_COUNT || parsed > MAX_COUNT) return;
    onConfirm(parsed);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={420}
      disableScale
      handleClose={modalClose}
      handleSubmit={handleSubmit}
      title={t(SCREEN_TEXT.INSERT_MULTIPLE, { defaultValue: 'Insert Multiple' })}
      customContentArea={
        <FormItem
          className={commonStyles.formItem}
          label={t(SCREEN_TEXT.INSERT_COUNT, { defaultValue: 'Count' })}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={count}
              onChange={e => setCount(e.target.value.replace(/[^0-9]/g, ''))}
              onKeyDown={e => e.key === 'Enter' && handleSubmit()}
            />
          )}
        />
      }
    />
  );
};
