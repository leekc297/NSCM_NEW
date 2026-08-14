import styles from 'features/demand/src/pages/sales-plan/SalesPlan.module.scss';
import { useEffect, useMemo, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button, Checkbox } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import type { MeasureMeta } from '../../useSalesPlanStore';

interface MeasureOption {
  code: string;
  label: string;
  personalizable: boolean;
  displayByDefault: boolean;
}

interface MeasureSelectModalProps {
  open: boolean;
  modalClose: () => void;
  measures: MeasureMeta[];
  visibleMeasures: string[] | null;
  onApply: (measureCodes: string[] | null) => void;
}

export const MeasureSelectModal = ({
  open,
  modalClose,
  measures,
  visibleMeasures,
  onApply,
}: MeasureSelectModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const options = useMemo<MeasureOption[]>(
    () =>
      measures.map(measure => ({
        code: measure.colNm,
        label: measure.colLblNm || measure.colNm,
        personalizable: measure.personalizable ?? true,
        displayByDefault: measure.display ?? false,
      })),
    [measures]
  );
  const [selectedCodes, setSelectedCodes] = useState<Set<string>>(new Set());

  useEffect(() => {
    if (!open) return;
    const selected = options
      .filter(option => {
        if (!option.personalizable) return option.displayByDefault;
        return visibleMeasures === null
          ? option.displayByDefault
          : visibleMeasures.includes(option.code);
      })
      .map(option => option.code);
    setSelectedCodes(new Set(selected));
  }, [open, options, visibleMeasures]);

  const toggleMeasure = (option: MeasureOption, checked: boolean) => {
    if (!option.personalizable) return;
    setSelectedCodes(previous => {
      const next = new Set(previous);
      if (checked) next.add(option.code);
      else next.delete(option.code);
      return next;
    });
  };

  const handleOk = () => {
    const selected = options
      .filter(option => selectedCodes.has(option.code))
      .map(option => option.code);
    if (selected.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00713', '_Select at least one measure.') });
      return;
    }
    onApply(selected.length === options.length ? null : selected);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={850}
      handleClose={modalClose}
      disableButtonCancel
      title='Measure Select (Measure Show)'
      customContentArea={
        <div className={styles.measureChecklistContainer}>
          <div className={styles.measureChecklistPanel}>
            <div className={styles.measureChecklistHeader}>Measure (표시 선택)</div>
            <div className={styles.measureChecklistBody}>
              {options.map(option => (
                <div className={styles.measureChecklistRow} key={option.code}>
                  <Checkbox
                    labelText={option.label}
                    checked={selectedCodes.has(option.code)}
                    disabled={!option.personalizable}
                    onChange={checked => toggleMeasure(option, checked)}
                  />
                </div>
              ))}
            </div>
          </div>
          <div className={styles.measureChecklistActionBar}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Cancel'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
