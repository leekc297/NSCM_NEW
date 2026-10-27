import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { DAY_WEEK, DAY_WEEK_LOOKUP, LBL } from '../working-time.constants';

import styles from './WorkingTimeInputModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  // Day of the week + Input Value 로 선택/요일 D_ 셀에 일괄 입력한다. true 를 돌려주면 닫고,
  //   false(가드 실패 등)면 열어 둔다(자매 shipment-working-day-osp InputModal / capa-mobility-it BulkUpdateModal 동형).
  onConfirm: (dayWeekCode: string, inputValue: string) => boolean;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS 조회조건의 Day of the week + Input Value + Input 버튼을 버튼영역 '입력' 버튼 + 팝업으로 통합한다
//   (자매 SCP0096 shipment-working-day-osp 선례 동형, 2026-10-15 사용자 지시). SCP0019 델타: Input Value 는
//   YesOrNo 콤보가 아니라 숫자 입력(txtInpuValue, MaxLength 4) — AS-IS SCP0019_WorkingTime 과 동일.
//   Day of the week = lookup WEEK_WORK_TIME(기본 EveryDay). 재오픈 시 기본값으로 초기화(단발 입력 모달).
//   실제 셀 write·가드는 부모 onConfirm 이 수행한다(EditTracker 단일 출처).
export const WorkingTimeInputModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();

  const [dayWeekCode, setDayWeekCode] = useState<string>(DAY_WEEK.EVERY_DAY);
  const [inputValue, setInputValue] = useState<string>('');

  // Day of the week(lookup WEEK_WORK_TIME) — 조회조건 Form 에서 이관. CODE/NAME 정규화.
  const [dayWeeks] = useTabLookupQueries({ filters: [DAY_WEEK_LOOKUP] });
  const dayWeekOptions: Option[] = (dayWeeks ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // 열 때만 기본값(EveryDay / 빈 값)으로 초기화 — 열려 있는 동안 입력 중인 값을 덮지 않는다.
  useEffect(() => {
    if (!open) return;
    setDayWeekCode(DAY_WEEK.EVERY_DAY);
    setInputValue('');
  }, [open]);

  const handleOk = () => {
    if (onConfirm(dayWeekCode, inputValue)) onClose();
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
            {/* Day of the week (lookup WEEK_WORK_TIME, 기본 EveryDay) — 일괄입력 분기 키. */}
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DAY_OF_WEEK, '_Day of the week')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={dayWeekCode}
                    options={dayWeekOptions}
                    onChange={(_, picked) =>
                      setDayWeekCode(String(picked ?? DAY_WEEK.EVERY_DAY))
                    }
                  />
                )}
              />
            </Grid>
            {/* Input Value(txtInpuValue MaxLength 4) — 선택/요일 D_ 셀에 써넣을 숫자. 범위검사는 없다
                (AS-IS BtnInput_Click 은 int.Parse 형식검사만, 빈 값은 공란 write). */}
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.INPUT_VALUE, '_Input Value')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={inputValue}
                    inputProps={{ maxLength: 4 }}
                    onChange={e => setInputValue(e.target.value.replace(/[^\d]/g, ''))}
                    onKeyDown={e => e.key === 'Enter' && handleOk()}
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
              onClick={handleOk}
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
