import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

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
 */
export const CopySelectModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [dayType, setDayType] = useState<string>('WEEK');

  useEffect(() => {
    if (open) setDayType('WEEK');
  }, [open]);

  return (
    <CustomDialog
      size={360}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL01184', { defaultValue: 'Copy Data' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          <Grid container>
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL01185', { defaultValue: 'Copy Type' })}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={dayType}
                    options={COPY_TYPE_OPTIONS.map(o => ({ label: o.label, value: o.value }))}
                    onChange={(_, picked) => setDayType(String(picked ?? 'WEEK'))}
                  />
                )}
              />
            </Grid>
          </Grid>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              onClick={() => {
                onConfirm(dayType);
                onClose();
              }}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
