import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LBL } from '../../capa-mobility-it.constants';
import { BULK_TYPE, BULK_TYPE_OPTIONS, type BulkType } from '../../utils/capa-mobility-it.bulkInput';

import styles from './BulkUpdateModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  /** true 를 돌려주면 닫고, false(검증 실패 등)면 열어 둔다. */
  onConfirm: (type: BulkType, value: string) => Promise<boolean> | boolean;
}

/**
 * Bulk Update 팝업 — AS-IS 조회조건의 Day Type 과 Input Value 를 받아 일괄 입력한다(AS-IS Input 버튼 통합).
 *   재오픈 시 Type 은 EveryDay, Value 는 비움으로 초기화(단발 입력 모달).
 */
export const BulkUpdateModal = ({
  open,
  onClose,
  onConfirm,
}: Props) => {
  const { t } = useTranslation();
  const [type, setType] = useState<BulkType>(BULK_TYPE.EVERY_DAY);
  const [value, setValue] = useState('');

  useEffect(() => {
    if (!open) return;
    setType(BULK_TYPE.EVERY_DAY);
    setValue('');
    // 열 때만 초기화 — 열려 있는 동안 입력 중인 값을 덮지 않는다.
  }, [open]);

  const handleOk = async () => {
    if (await onConfirm(type, value)) onClose();
  };

  return (
    <CustomDialog
      size={520}
      // 기본 높이(50vh x 배율 1.5)는 입력 2칸 + 버튼 내용에 비해 커서 내용에 맞춘다(배율 적용 후 약 420px).
      height={280}
      // 리사이즈 최소값을 초기 크기와 같게 둔다. 기본 최소값(800x300)이 더 커서 첫 드래그에 팝업이 튀는 것을 막는다.
      minWidth={520}
      minHeight={280}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Bulk Update</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          <Grid container rowSpacing={1}>
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DAY_TYPE, 'Day Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={type}
                    options={BULK_TYPE_OPTIONS}
                    onChange={(_, picked) => setType(String(picked ?? BULK_TYPE.EVERY_DAY) as BulkType)}
                  />
                )}
              />
            </Grid>
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALUE, 'Input Value')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={value}
                    onChange={event => setValue(event.target.value)}
                    onKeyDown={event => event.key === 'Enter' && void handleOk()}
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
              buttonLabel={t(LBL.OK, 'OK')}
              onClick={() => void handleOk()}
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
