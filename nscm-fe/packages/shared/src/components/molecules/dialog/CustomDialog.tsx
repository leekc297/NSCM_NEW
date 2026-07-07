import type { DialogProps, PaperProps } from '@mui/material';
import { Dialog as MuiDialog, Paper, Popover } from '@mui/material';
import { Box } from '@mui/system';
import { memo, type ReactNode, useCallback, useEffect, useRef, useState } from 'react';
import Draggable from 'react-draggable';

import _ from '@foundation/lodash';

import DialogContentArea from './components/CustomDialogContent';
import styles from './CustomDialog.module.scss';

export type DialogNavigationType = 'modal' | 'modaless';
export type DialogNavigationPosition = 'basic' | 'overflow';
export type DialogNavigationSize = 1600 | 1400 | 1200 | 1000 | 800 | 600 | 400;

export type DialogNavigationProps = {
  type?: DialogNavigationType;
  position?: DialogNavigationPosition;
  // 표준 프리셋(DialogNavigationSize 참조) + 커스텀 px 폭 허용(런타임은 `Number(size)` 로 처리).
  // number 가 프리셋 리터럴을 모두 포함하므로 union 대신 number 로 축약(no-redundant-type-constituents). 기존 프리셋 값 하위호환.
  size?: number;
  isOutBound?: boolean;
  anchorEl?: HTMLButtonElement | null;
  title?: string;
  subTitle?: string;
  contentArea?: string;
  customHeaderTitle?: ReactNode;
  customHeaderSubTitle?: ReactNode;
  customContentArea?: ReactNode;
  disableButtonCancel?: boolean;
  handleSubmit?: () => void;
  handleClose?: () => void;
  draggable?: boolean;
  /** 초기 다이얼로그 높이 (CSS 값, 예: '75vh' / 700). 미지정 시 기존 기본값 '50vh' 유지. */
  height?: string | number;
} & DialogProps;

const MAX_WIDTH = 2000;
const MIN_WIDTH = 400;
const MAX_HEIGHT = 1600;
const MIN_HEIGHT = 300;
const DEFAULT_WIDTH = 800;
const DEFAULT_HEIGHT = '50vh';

interface DialogSizeRef {
  draggable: boolean;
  dialogSize: { width: number; height: string | number };
  handleResizeStart: (mouseEvent: React.MouseEvent) => void;
}

const DraggablePaper = ({
  sizeRef,
  ...props
}: PaperProps & { sizeRef: React.RefObject<DialogSizeRef | null> }) => {
  const nodeRef = useRef<HTMLDivElement>(null);
  if (!sizeRef.current) return null;
  const { draggable, dialogSize, handleResizeStart } = sizeRef.current;

  const paperElement = (
    <Paper
      {...props}
      ref={nodeRef}
      style={{
        ...props.style,
        width: dialogSize.width,
        ...(draggable && { height: dialogSize.height }),
        position: 'relative',
      }}
    >
      {props.children}
      {draggable && <Box onMouseDown={handleResizeStart} className={styles.resizeHandler} />}
    </Paper>
  );

  if (draggable) {
    return (
      <Draggable
        handle='#draggable-dialog-title'
        cancel='[class*="MuiDialogContent-root"]'
        nodeRef={nodeRef}
      >
        {paperElement}
      </Draggable>
    );
  }

  return paperElement;
};

const CustomDialogComponent = ({
  open,
  type = 'modal',
  position = 'basic',
  size,
  isOutBound = false,
  anchorEl = null,
  title = '',
  subTitle,
  contentArea,
  customHeaderTitle,
  customHeaderSubTitle,
  customContentArea,
  disableButtonCancel,
  handleClose = () => _.noop(),
  handleSubmit = () => _.noop(),
  draggable = true,
  height,
}: DialogNavigationProps) => {
  // TODO: 최소, 최대 크기 미정.. 일단 400x300, 2000x1600 - 강민재
  const [dialogSize, setDialogSize] = useState<{ width: number; height: string | number }>({
    width: Number(size ?? DEFAULT_WIDTH),
    height: height ?? DEFAULT_HEIGHT,
  });
  const isResizing = useRef(false);
  const startPos = useRef({ x: 0, y: 0 });
  const startSize = useRef<{ width: number; height: number }>({ width: 0, height: 0 });
  const sizeRef = useRef<DialogSizeRef | null>(null);

  const handleMouseMove = useCallback((mouseEvent: MouseEvent) => {
    if (!isResizing.current) return;
    const newWidth = Math.min(
      MAX_WIDTH,
      Math.max(MIN_WIDTH, startSize.current.width + (mouseEvent.clientX - startPos.current.x))
    );
    const newHeight = Math.min(
      MAX_HEIGHT,
      Math.max(MIN_HEIGHT, startSize.current.height + (mouseEvent.clientY - startPos.current.y))
    );
    setDialogSize({ width: newWidth, height: newHeight });
  }, []);

  const handleMouseUp = useCallback(() => {
    isResizing.current = false;
    document.body.style.cursor = '';
    document.body.style.userSelect = '';
  }, []);

  const handleResizeStart = (mouseEvent: React.MouseEvent) => {
    mouseEvent.preventDefault();
    mouseEvent.stopPropagation();
    isResizing.current = true;
    startPos.current = { x: mouseEvent.clientX, y: mouseEvent.clientY };
    const currentHeight =
      typeof dialogSize.height === 'string'
        ? ((mouseEvent.currentTarget as HTMLElement)
            .closest('.MuiPaper-root')
            ?.getBoundingClientRect().height ?? 0)
        : dialogSize.height;
    startSize.current = { width: dialogSize.width, height: currentHeight };
    document.body.style.cursor = 'se-resize';
    document.body.style.userSelect = 'none';
  };

  const handleDialogSubmit = () => {
    handleSubmit();
    handleClose();
  };

  sizeRef.current = { draggable, dialogSize, handleResizeStart };
  const PaperComponent = useCallback(
    (paperProps: PaperProps) => <DraggablePaper {...paperProps} sizeRef={sizeRef} />,
    []
  );

  useEffect(() => {
    document.addEventListener('mousemove', handleMouseMove);
    document.addEventListener('mouseup', handleMouseUp);
    return () => {
      document.removeEventListener('mousemove', handleMouseMove);
      document.removeEventListener('mouseup', handleMouseUp);
    };
  }, [handleMouseMove, handleMouseUp]);

  useEffect(() => {
    if (!open) setDialogSize({ width: Number(size ?? DEFAULT_WIDTH), height: height ?? DEFAULT_HEIGHT });
  }, [open]);

  return (
    <div>
      {position === 'basic' ? (
        <MuiDialog
          open={open}
          hideBackdrop={type === 'modaless'}
          PaperComponent={PaperComponent}
          className={styles.defaultDialog}
        >
          <DialogContentArea
            title={title}
            subTitle={subTitle}
            contentArea={contentArea}
            customContentArea={customContentArea}
            customHeaderTitle={customHeaderTitle}
            customHeaderSubTitle={customHeaderSubTitle}
            disableButtonCancel={disableButtonCancel}
            handleSubmit={handleDialogSubmit}
            handleClose={handleClose}
            draggable={draggable}
          />
        </MuiDialog>
      ) : (
        <Popover
          open={open}
          anchorEl={anchorEl}
          onClose={handleClose}
          anchorOrigin={{
            vertical: isOutBound ? 'top' : 'bottom',
            horizontal: 'left',
          }}
          transformOrigin={{
            vertical: isOutBound ? 'bottom' : 'top',
            horizontal: 'left',
          }}
          slotProps={{
            paper: {
              sx: {
                ...(isOutBound ? { mt: '-1rem' } : { mt: '1rem' }),
              },
            },
          }}
          className={styles.popoverBase}
          sx={{
            width: `${size}px`,
            '.MuiPaper-root': {
              minWidth: `${size}px`,
            },
          }}
        >
          <DialogContentArea
            title={title}
            subTitle={subTitle}
            contentArea={contentArea}
            customContentArea={customContentArea}
            customHeaderTitle={customHeaderTitle}
            customHeaderSubTitle={customHeaderSubTitle}
            disableButtonCancel={disableButtonCancel}
            handleSubmit={handleDialogSubmit}
            handleClose={handleClose}
          />
        </Popover>
      )}
    </div>
  );
};

export const CustomDialog = memo(CustomDialogComponent) as typeof CustomDialogComponent;
