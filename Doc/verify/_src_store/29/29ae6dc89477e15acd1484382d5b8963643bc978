import { useEffect, useMemo, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, DEFAULT_DAY_WEEK, LBL } from '../shipment-working-day.constants';

import styles from './ShipmentWorkingDayBulkModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  /** true 를 돌려주면 닫고, false(검증 실패 등)면 열어 둔다. */
  onConfirm: (dayWeekCode: string, value: string) => Promise<boolean> | boolean;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

/**
 * Bulk Update 팝업 — AS-IS 조회조건의 Day of the week 와 Input Value 를 받아 일괄 입력한다
 *   (AS-IS Input 버튼 통합, SCP0098 BulkUpdateModal 과 동형).
 *   재오픈 시 Day of the week 는 EveryDay(DEFAULT_DAY_WEEK), Input Value 는 비움으로 초기화한다.
 *   모달리스로 띄운다 — SelectDay 모드는 팝업이 열린 채로 그리드에서 셀 범위를 드래그 선택해야 하므로
 *   그리드 포커스를 가로채면 안 된다(disableEnforceFocus).
 */
export const ShipmentWorkingDayBulkModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();

  // Day of the week 는 AS-IS Data.Common(LookupCommon,"WEEK_WORK_TIME") 그대로 이관한 콤보로
  //   DISPLAY_SEQ 순(EveryDay/SelectDay/Mon~Sun)이고, Input Value 는 YesOrNo(Y/N)다.
  //   useTabComboQueries 는 queryKey 로 중복 제거하므로 조회조건 Form 과 같은 콤보여도 추가 호출이 아니다.
  const [dayWeeks, inputValues] = useTabComboQueries({
    filters: [COMBO.DAY_WEEK, COMBO.INPUT_VALUE],
  });
  const dayWeekOptions = useMemo(() => toOptions(dayWeeks), [dayWeeks]);
  const inputValueOptions = useMemo(() => toOptions(inputValues), [inputValues]);

  const [dayWeekCode, setDayWeekCode] = useState<string>(DEFAULT_DAY_WEEK);
  const [value, setValue] = useState('');

  useEffect(() => {
    if (!open) return;
    setDayWeekCode(DEFAULT_DAY_WEEK);
    setValue('');
    // 열 때만 초기화 — 열려 있는 동안 입력 중인 값을 덮지 않는다.
  }, [open]);

  const handleOk = async () => {
    if (await onConfirm(dayWeekCode, value)) onClose();
  };

  return (
    <CustomDialog
      size={520}
      height={280}
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
                label={t(LBL.DAY_OF_WEEK, '_Day of the week')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    useClearIcon={false}
                    value={dayWeekCode}
                    options={dayWeekOptions}
                    onChange={(_, picked) => setDayWeekCode(str(picked) || DEFAULT_DAY_WEEK)}
                  />
                )}
              />
            </Grid>
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.INPUT_VALUE, '_Input Value')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={value}
                    options={inputValueOptions}
                    onChange={(_, picked) => setValue(str(picked))}
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
              buttonLabel={t(LBL.OK, '_OK')}
              onClick={() => void handleOk()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t(LBL.CLOSE, '_Close')}
              onClick={onClose}
            />
          </div>
        </div>
      }
    />
  );
};
