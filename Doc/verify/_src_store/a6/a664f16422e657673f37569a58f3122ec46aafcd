import type { DialogProps, PaperProps } from '@mui/material';
import { Dialog as MuiDialog, Paper, Popover } from '@mui/material';
import { Box } from '@mui/system';
import { memo, type ReactNode, useCallback, useEffect, useId, useRef, useState } from 'react';
import Draggable, { type DraggableData } from 'react-draggable';

import { confirmIfScopeDirty, DialogScopeContext, useDialogStore } from '@shared/stores';

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
  /** 헤더의 최대화 버튼 숨김 (기본 false — 기본 Dialog 는 최대화 가능) */
  disableMaximize?: boolean;
  /** size/height 1.5배 확대 미적용 (기본 false). 메시지(Alert) 등 원본 크기를 유지해야 하는 다이얼로그에서 사용 */
  disableScale?: boolean;
  /** 리사이즈 최소 폭(기본 MIN_WIDTH). 기본 폭보다 작게 여는 소형 팝업에서 첫 드래그 시 크기가 튀지 않게 낮출 때 사용 */
  minWidth?: number;
  /** 리사이즈 최소 높이(기본 MIN_HEIGHT). minWidth 와 같은 용도 */
  minHeight?: number;
} & DialogProps;

/**
 * ⭐ MUI 포커스 트랩 해제가 필요한 경우 (2026-07-30, DMF0082 ExchangeRateModal 실측):
 *   Wijmo 그리드 셀 콤보의 드롭다운 ListBox 는 `MuiDialog-container` **밖**(`MuiDialog-root` 직하)에
 *   append 된다. MUI FocusTrap(enforceFocus)은 트랩 외부로 나간 포커스를 즉시 컨테이너로 되돌리는데,
 *   그 순간 Wijmo 가 포커스 상실로 `finishEditing()` 을 호출해 에디터(`_edt`)를 파괴한다.
 *   이후 리스트 항목을 클릭해도 `finishEditing()` 이 `if (!this._edt || null == this._rng) return`
 *   에 걸려 **선택값이 조용히 버려지고 리스트만 닫힌다**.
 *   ⇒ 그리드 셀 콤보(dataMap)를 쓰는 다이얼로그는 `disableEnforceFocus` 를 켜야 한다.
 */

const DIALOG_SCALE = 1.5;
const MAX_WIDTH = 2000;
// [2026-09-23] 400 → 800 — 조회조건(SearchArea) 팝업을 기본 크기보다 좁게 드래그하면 라벨·
//   Period 날짜박스처럼 폭이 px 로 고정된 조회조건이 옆 칸 위로 겹쳐 보이는 문제(DMF0082 Version
//   Popup 실측). "겹칠 수 있는 폭 자체"에 도달하지 못하도록 리사이즈 최소폭을 기본폭(DEFAULT_WIDTH)
//   과 같은 값으로 올렸다 — 모든 CustomDialog 팝업에 공통 적용.
const MIN_WIDTH = 800;
const MAX_HEIGHT = 1600;
const MIN_HEIGHT = 300;
const DEFAULT_WIDTH = 800;
const DEFAULT_HEIGHT = '50vh';

interface DialogSizeRef {
  draggable: boolean;
  dialogSize: { width: number; height: string | number };
  handleResizeStart: (mouseEvent: React.MouseEvent) => void;
  isMaximized: boolean;
  disableScale: boolean;
}

const DraggablePaper = ({
  sizeRef,
  ...props
}: PaperProps & { sizeRef: React.RefObject<DialogSizeRef | null> }) => {
  const nodeRef = useRef<HTMLDivElement>(null);
  if (!sizeRef.current) return null;
  const { draggable, dialogSize, handleResizeStart, isMaximized, disableScale } = sizeRef.current;
  const scale = disableScale ? 1 : DIALOG_SCALE;

  const paperElement = (
    <Paper
      {...props}
      ref={nodeRef}
      style={{
        ...props.style,
        position: 'relative',
        // 최대화 시에는 인라인 크기를 주지 않아 MUI fullScreen 이 뷰포트를 채우도록 둔다.
        ...(isMaximized
          ? {}
          : {
              width:
                typeof dialogSize.width === 'number'
                  ? dialogSize.width * scale
                  : `calc(${String(dialogSize.width)} * ${scale})`,
              // scale(1.5) 적용 폭이 뷰포트보다 넓으면 가로로 화면을 넘어간다. MUI Dialog 기본
              //   여백(상하좌우 32px)을 뺀 뷰포트 폭으로 함께 상한을 걸어 넘침을 막는다.
              maxWidth: `min(${MAX_WIDTH}px, calc(100vw - 64px))`,
              // 높이도 같은 이유로 뷰포트 높이(여백 제외)로 상한을 건다. draggable 이 아닌
              //   팝업(인라인 height 없음)도 긴 콘텐츠로 세로를 넘길 수 있어 maxHeight 는 공통 적용.
              maxHeight: `min(${MAX_HEIGHT}px, calc(100vh - 64px))`,
              ...(draggable && {
                height:
                  typeof dialogSize.height === 'number'
                    ? dialogSize.height * scale
                    : `calc(${String(dialogSize.height)} * ${scale})`,
              }),
            }),
      }}
    >
      {props.children}
      {draggable && !isMaximized && (
        <Box onMouseDown={handleResizeStart} className={styles.resizeHandler} />
      )}
    </Paper>
  );

  // 드래그가 팝업을 브라우저 밖으로 끌어내지 못하게 막는다. react-draggable 의 bounds 는
  //   MUI 가 Paper 를 flex 로 중앙 배치해 원점이 가변이라 정확히 맞지 않는다. 대신 onDrag 에서
  //   이번 프레임의 증분(deltaX/Y)을 적용한 뒤 Paper 가 뷰포트를 벗어나면 false 를 돌려 그
  //   프레임을 취소한다(rect 은 이동 적용 직전 위치).
  const handleDrag = (_e: unknown, data: DraggableData) => {
    const rect = data.node.getBoundingClientRect();
    const nextLeft = rect.left + data.deltaX;
    const nextTop = rect.top + data.deltaY;
    if (
      nextLeft < 0 ||
      nextTop < 0 ||
      nextLeft + rect.width > window.innerWidth ||
      nextTop + rect.height > window.innerHeight
    ) {
      return false;
    }
  };

  // 최대화 상태에서는 드래그 비활성(위치 고정)
  if (draggable && !isMaximized) {
    return (
      <Draggable
        handle='#draggable-dialog-title'
        cancel='[class*="MuiDialogContent-root"]'
        nodeRef={nodeRef}
        onDrag={handleDrag}
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
  handleClose = () => {},
  handleSubmit = () => {},
  draggable = true,
  height,
  disableMaximize = false,
  disableScale = false,
  minWidth = MIN_WIDTH,
  minHeight = MIN_HEIGHT,
  // ⚠️ 이 컴포넌트는 나머지 props 를 MuiDialog 로 spread 하지 않는다 → 전달할 prop 은 명시 선언 필수.
  disableEnforceFocus,
}: DialogNavigationProps) => {
  // 이 다이얼로그의 단축키 스코프 id. 열려 있는 동안 스택 최상위면 이 스코프의 SubTitle 단축키만 동작한다.
  const scopeId = useId();

  // TODO: 최소, 최대 크기 미정.. 일단 400x300, 2000x1600 - 강민재
  const [dialogSize, setDialogSize] = useState<{ width: number; height: string | number }>({
    width: Number(size ?? DEFAULT_WIDTH),
    height: height ?? DEFAULT_HEIGHT,
  });
  const [isMaximized, setIsMaximized] = useState(false);
  const isResizing = useRef(false);
  const startPos = useRef({ x: 0, y: 0 });
  const startSize = useRef<{ width: number; height: number }>({ width: 0, height: 0 });
  const sizeRef = useRef<DialogSizeRef | null>(null);

  const handleMouseMove = useCallback(
    (mouseEvent: MouseEvent) => {
      if (!isResizing.current) return;
      const newWidth = Math.min(
        MAX_WIDTH,
        Math.max(minWidth, startSize.current.width + (mouseEvent.clientX - startPos.current.x))
      );
      const newHeight = Math.min(
        MAX_HEIGHT,
        Math.max(minHeight, startSize.current.height + (mouseEvent.clientY - startPos.current.y))
      );
      setDialogSize({ width: newWidth, height: newHeight });
    },
    [minWidth, minHeight]
  );

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
    // height 가 '50vh' 같은 CSS 값이면 실제 화면 높이(scale 적용 후 px)를 재므로, dialogSize 와
    //   같은 논리값 단위로 맞추려면 /scale 해서 저장한다(width 는 이미 논리값이라 그대로).
    const scale = disableScale ? 1 : DIALOG_SCALE;
    const currentHeight =
      typeof dialogSize.height === 'string'
        ? ((mouseEvent.currentTarget as HTMLElement)
            .closest('.MuiPaper-root')
            ?.getBoundingClientRect().height ?? 0) / scale
        : dialogSize.height;
    startSize.current = { width: dialogSize.width, height: currentHeight };
    document.body.style.cursor = 'se-resize';
    document.body.style.userSelect = 'none';
  };

  const handleDialogSubmit = () => {
    handleSubmit();
    handleClose();
  };

  // ⭐ 닫기(X/Cancel) 미저장 변경 가드 — 이 다이얼로그 스코프의 그리드에 저장 안 한 변경이 있으면
  //   confirm 후 닫는다. 확인(submit) 경로는 화면 로직이 변경분을 처리하므로 가드하지 않는다.
  const handleGuardedClose = () => {
    void confirmIfScopeDirty(scopeId).then(ok => {
      if (ok) handleClose();
    });
  };

  sizeRef.current = { draggable, dialogSize, handleResizeStart, isMaximized, disableScale };
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
    if (!open) {
      setDialogSize({ width: Number(size ?? DEFAULT_WIDTH), height: height ?? DEFAULT_HEIGHT });
      setIsMaximized(false);
    }
  }, [open]);

  // 열려 있는 동안만 단축키 스코프 스택에 등록. 닫히거나 언마운트되면 해제.
  useEffect(() => {
    if (!open) return;
    const { pushScope, popScope } = useDialogStore.getState();
    pushScope(scopeId);
    return () => popScope(scopeId);
  }, [open, scopeId]);

  return (
    <DialogScopeContext.Provider value={scopeId}>
      {position === 'basic' ? (
        <MuiDialog
          open={open}
          fullScreen={isMaximized}
          hideBackdrop={type === 'modaless'}
          PaperComponent={PaperComponent}
          className={styles.defaultDialog}
          // 미지정 시 MUI 기본(false) 유지 — 기존 다이얼로그 동작 무변경. 상단 주석 참조.
          disableEnforceFocus={disableEnforceFocus}
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
            handleClose={handleGuardedClose}
            draggable={draggable}
            isMaximized={isMaximized}
            onToggleMaximize={disableMaximize ? undefined : () => setIsMaximized(v => !v)}
          />
        </MuiDialog>
      ) : (
        <Popover
          open={open}
          anchorEl={anchorEl}
          onClose={handleGuardedClose}
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
            handleClose={handleGuardedClose}
          />
        </Popover>
      )}
    </DialogScopeContext.Provider>
  );
};

export const CustomDialog = memo(CustomDialogComponent) as typeof CustomDialogComponent;
