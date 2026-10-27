import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';

import { LBL } from '../../capa-mobility-it.constants';

import styles from './CopySelectModal.module.scss';

/** 복사 유형 — AS-IS SCP0098_CopySelect_Popup 반환값. SP P_DAY_TYPE 로 전달. */
const COPY_TYPE_OPTIONS = [
  { label: 'Week', value: 'WEEK' },
  { label: 'Month', value: 'MONTH' },
] as const;

interface Props {
  open: boolean;
  onClose: () => void;
  onConfirm: (dayType: string) => void;
}

/**
 * 복사유형 선택 모달 (AS-IS SCP0098_CopySelect_Popup) — Week/Month 택1 → P_COPY_MONTH_WEEK.
 *   재오픈 시 기본값(WEEK)으로 초기화(단발 선택 모달이라 조건 유지 불필요).
 *
 * 제목과 안내 문구는 AS-IS 원문을 그대로 쓰는 하드코딩이다(다국어 키 미사용, 사용자 결정 2026-10-13).
 * 공용 RadioGroup 이 없어 네이티브 radio 로 구성한다(shipment-plan-electrode Form 과 동일 방식).
 */
export const CopySelectModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [dayType, setDayType] = useState<string>('WEEK');

  useEffect(() => {
    if (open) setDayType('WEEK');
  }, [open]);

  return (
    <CustomDialog
      // 폭 360, 높이 200 은 프리셋 밖 값이다. AS-IS 는 내용만 담는 작은 창이라 기본 50vh 를 쓰지 않는다.
      size={360}
      height={200}
      // 리사이즈 최소값을 초기 크기와 같게 둔다. 기본 최소값(800x300)이 더 커서 첫 드래그에 팝업이 튀는 것을 막는다.
      minWidth={360}
      minHeight={200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Copy Type</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          <div className={styles.radioBox}>
            {COPY_TYPE_OPTIONS.map(o => (
              <label key={o.value} className={styles.radioOption}>
                <input
                  type='radio'
                  name='scp0098-copy-type'
                  value={o.value}
                  checked={dayType === o.value}
                  onChange={() => setDayType(o.value)}
                />
                <span>{o.label}</span>
              </label>
            ))}
          </div>
          <div className={styles.hint}>
            <div>Week : 전 주 데이터를 금 주로 복사</div>
            <div>Month : 전 월 데이터를 금 월로 복사</div>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, 'OK')}
              onClick={() => {
                onConfirm(dayType);
                onClose();
              }}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, 'Close')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
