import { Typography, useTheme } from '@mui/material';
import type { ReactNode } from 'react';

import { Button } from '@shared/lges';
import { ControlCloseIcon } from '@shared/lges-icons';

import styles from './CustomDialogContent.module.scss';

type ContentAreaProps = {
  title: string | null;
  subTitle?: string;
  contentArea?: string;
  customHeaderTitle?: ReactNode;
  customHeaderSubTitle?: ReactNode;
  customContentArea?: ReactNode;
  disableButtonCancel?: boolean;
  handleSubmit?: () => void;
  handleClose?: () => void;
  draggable?: boolean;
  isMaximized?: boolean;
  onToggleMaximize?: () => void;
};

const CustomContentArea = ({
  title,
  subTitle,
  contentArea,
  customHeaderTitle,
  customHeaderSubTitle,
  customContentArea,
  disableButtonCancel,
  handleSubmit,
  handleClose,
  draggable = true,
  isMaximized,
  onToggleMaximize,
}: ContentAreaProps) => {
  const { palette } = useTheme();
  const { t } = useTranslation();
  const { commonTextPrimaryExtreme, commonTextLight } = palette.semantic.color;
  return (
    <div className={styles.dialogWrapper}>
      <div
        id='draggable-dialog-title'
        className={`${styles.dialogHeaderTitle} ${draggable ? '' : styles.undraggable}`}
      >
        {customHeaderTitle ?? (
          <div className={styles.dialogDefaultHeaderTitleWrapper}>
            <div className={styles.dialogDefaultHeaderCircle} />
            <Typography variant='h2' color={commonTextPrimaryExtreme}>
              {title}
            </Typography>
          </div>
        )}
        <div className={styles.dialogHeaderActions}>
          {/* {onToggleMaximize &&
            (isMaximized ? (
              <ControlMinimizeIcon
                size='default'
                iconSize={20}
                onClick={onToggleMaximize}
                cursor='pointer'
                sx={{ color: commonTextLight }}
              />
            ) : (
              <ControlMaximizeIcon
                size='default'
                iconSize={20}
                onClick={onToggleMaximize}
                cursor='pointer'
                sx={{ color: commonTextLight }}
              />
            ))} */}
          <ControlCloseIcon
            size='default'
            iconSize={20}
            onClick={handleClose}
            cursor='pointer'
            sx={{
              color: commonTextLight,
            }}
          />
        </div>
      </div>
      {customHeaderSubTitle ??
        (subTitle && (
          <div className={styles.dialogSubTitle}>
            <Typography variant='h5'>{subTitle}</Typography>
          </div>
        ))}
      {customContentArea ? (
        <div className={styles.dialogCustomContentAreaWrapper}>{customContentArea}</div>
      ) : (
        <>
          <div className={styles.dialogDefaultContentAreaWrapper}>{contentArea}</div>
          <div className={styles.lowerButtonGroup}>
            {!disableButtonCancel && (
              <Button
                appearance='unfilled'
                priority='normal'
                size='medium'
                className={styles.lowerButton}
                onClick={handleClose}
              >
                {t('LBL00107', '_취소')}
              </Button>
            )}
            <Button
              appearance='unfilled'
              priority='primary'
              size='medium'
              className={styles.lowerButton}
              onClick={handleSubmit}
              autoFocus
            >
              {t('LBL00359', '_확인')}
            </Button>
          </div>
        </>
      )}
    </div>
  );
};

export default CustomContentArea;
