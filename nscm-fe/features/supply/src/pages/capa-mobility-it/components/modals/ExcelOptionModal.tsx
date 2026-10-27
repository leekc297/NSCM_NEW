import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { Button } from '@shared/lges';

import { LBL } from '../../capa-mobility-it.constants';
import type { ExcelExportOptions } from '../../utils/capa-mobility-it.excel';

import styles from './ExcelOptionModal.module.scss';

interface Props {
  open: boolean;
  onClose: () => void;
  onConfirm: (opt: ExcelExportOptions) => void;
}

/** 모달 UI 상태 — AS-IS FPC0109 팝업 그대로(Merge 라디오 / Border 라디오 / Hide 0 체크). 기본 = 이미지 선택값. */
interface UiState {
  merge: boolean; // true=Merged Column / false=Seperated Column
  border: boolean; // true=Show Cell Border / false=Hide Cell Border
  hideZero: boolean; // true=Hide 0 (0 값 숨김)
}

const DEFAULTS: UiState = { merge: true, border: true, hideZero: true };

/**
 * Excel Export 옵션 모달 (AS-IS SCP0098 ExcelButton → FPC0109_ExcelSelect_Popup).
 *   공통 엑셀 대신 이 화면만 사용한다(사용자 결정 2026-10-16). 라벨·레이아웃은 AS-IS 원문 영문 그대로(다국어 아님).
 *   'Hide 0' 체크 = 0 값 숨김 → export opt.zero = !hideZero(zero 는 '0 표시' 의미).
 */
export const ExcelOptionModal = ({ open, onClose, onConfirm }: Props) => {
  const { t } = useTranslation();
  const [ui, setUi] = useState<UiState>(DEFAULTS);

  useEffect(() => {
    if (open) setUi(DEFAULTS);
  }, [open]);

  return (
    <CustomDialog
      size={420}
      height={260}
      minWidth={420}
      minHeight={260}
      type='modaless'
      position='basic'
      open={open}
      handleClose={onClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>SELECT Excel Export Option</h2>
        </div>
      }
      customContentArea={
        <div className={styles.content}>
          <div className={styles.optionBox}>
            <label className={styles.option}>
              <input
                type='radio'
                name='scp0098-excel-merge'
                checked={ui.merge}
                onChange={() => setUi(prev => ({ ...prev, merge: true }))}
              />
              <span>Merged Column</span>
            </label>
            <label className={styles.option}>
              <input
                type='radio'
                name='scp0098-excel-merge'
                checked={!ui.merge}
                onChange={() => setUi(prev => ({ ...prev, merge: false }))}
              />
              <span>Seperated Column</span>
            </label>
          </div>

          <div className={styles.optionBox}>
            <label className={styles.option}>
              <input
                type='radio'
                name='scp0098-excel-border'
                checked={ui.border}
                onChange={() => setUi(prev => ({ ...prev, border: true }))}
              />
              <span>Show Cell Border</span>
            </label>
            <label className={styles.option}>
              <input
                type='radio'
                name='scp0098-excel-border'
                checked={!ui.border}
                onChange={() => setUi(prev => ({ ...prev, border: false }))}
              />
              <span>Hide Cell Border</span>
            </label>
          </div>

          <div className={styles.optionBox}>
            <label className={styles.option}>
              <input
                type='checkbox'
                checked={ui.hideZero}
                onChange={e => setUi(prev => ({ ...prev, hideZero: e.target.checked }))}
              />
              <span>Hide 0</span>
            </label>
          </div>

          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t(LBL.OK, 'OK')}
              onClick={() => {
                onConfirm({ merge: ui.merge, border: ui.border, zero: !ui.hideZero });
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
