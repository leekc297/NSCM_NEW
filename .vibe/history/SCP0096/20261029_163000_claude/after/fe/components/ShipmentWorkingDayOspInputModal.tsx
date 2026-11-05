import { useEffect, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  COMBO,
  DAY_WEEK,
  DAY_WEEK_LOOKUP,
  LBL,
} from '../shipment-working-day-osp.constants';

import styles from './ShipmentWorkingDayOspInputModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  // Day of the week + Input Value 로 선택/요일 D_ 셀에 일괄 입력한다. true 를 돌려주면 닫고,
  //   false(가드 실패 등)면 열어 둔다(샘플 capa-mobility-it BulkUpdateModal 동형).
  onConfirm: (dayWeekCode: string, inputValue: string) => boolean;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// AS-IS 조회조건의 Day of the week + Input Value + Input 버튼을 버튼영역 버튼 + 팝업으로 통합한다.
//   (샘플: capa-mobility-it BulkUpdateModal — "AS-IS Input 버튼 통합" 선례와 동형.)
//   Day of the week = lookup WEEK_WORK_TIME(기본 EveryDay) / Input Value = YesOrNo 콤보(기본 Y).
//   재오픈 시 기본값으로 초기화(단발 입력 모달). 실제 셀 write·가드는 부모 onConfirm 이 수행한다.
export const ShipmentWorkingDayOspInputModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();

  const [dayWeekCode, setDayWeekCode] = useState<string>(DAY_WEEK.EVERY_DAY);
  const [inputValue, setInputValue] = useState<string>('Y');

  // Day of the week(lookup WEEK_WORK_TIME) + Input Value(YesOrNo 콤보). 조회조건 Form 에서 이관.
  const [dayWeeks] = useTabLookupQueries({ filters: [DAY_WEEK_LOOKUP] });
  const [inputValues] = useTabComboQueries({ filters: [COMBO.INPUT_VALUE] });

  const dayWeekOptions: Option[] = (dayWeeks ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });
  const inputValueOptions = toOptions(inputValues);

  // 열 때만 기본값(EveryDay / Y)으로 초기화 — 열려 있는 동안 입력 중인 값을 덮지 않는다.
  useEffect(() => {
    if (!open) return;
    setDayWeekCode(DAY_WEEK.EVERY_DAY);
    setInputValue('Y');
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
          <h2 className='headerTitle'>{t(LBL.INPUT, '_Input')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          <Grid container rowSpacing={1}>
            {/* Day of the week (lookup WEEK_WORK_TIME, 기본 EveryDay) — 일괄입력 분기 키. */}
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DAY_OF_THE_WEEK, '_Day of the week')}
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
            {/* Input Value (YesOrNo) — 선택/요일 D_ 셀에 써넣을 Y/N. Day of the week 값이 없으면 비활성(§2 #4). */}
            <Grid size={12}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.INPUT_VALUE, '_Input Value')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={!dayWeekCode}
                    value={inputValue}
                    options={inputValueOptions}
                    onChange={(_, picked) => setInputValue(String(picked ?? ''))}
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
