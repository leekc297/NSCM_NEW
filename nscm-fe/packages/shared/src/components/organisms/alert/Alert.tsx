import { Button } from '@shared/lges';
import { CustomDialog } from '@shared/components/molecules';
import { useMessageStore } from '@shared/stores';

/**
 * G6 — Phase 7 보완 A2 (2026-06-04): yesNoCancel 3-button variant 활성화.
 *
 * AS-IS MessageHelper.GMessageBox Button 코드 '0202004' (YesNoCancel) 매핑.
 * 사용 패턴: useConfirmYesNoCancel hook → setConfirmYesNoCancel({content}) → 본 컴포넌트 분기 처리.
 * resolve 결과: 'yes' / 'no' / 'cancel' (YesNoCancelResult).
 */
export const Alert = () => {
  const { isOpenAlert, alertProps, close, resolve } = useMessageStore();

  // G6 — yesNoCancel 3-button variant
  if (alertProps.type === 'yesNoCancel') {
    return (
      <CustomDialog
        open={isOpenAlert}
        customHeaderTitle={alertProps.header}
        customContentArea={
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            <div>{alertProps.content}</div>
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
              <Button
                variant='contained'
                onClick={() => {
                  resolve('yes');
                  close();
                }}
              >
                Yes
              </Button>
              <Button
                variant='outlined'
                onClick={() => {
                  resolve('no');
                  close();
                }}
              >
                No
              </Button>
              <Button
                variant='text'
                onClick={() => {
                  resolve('cancel');
                  alertProps.onClose?.();
                  close();
                }}
              >
                Cancel
              </Button>
            </div>
          </div>
        }
        handleClose={() => {
          // dialog X 닫기 = cancel 동등
          resolve('cancel');
          alertProps.onClose?.();
          close();
        }}
        disableButtonCancel={true}
        position='basic'
        size={400}
        draggable={false}
      />
    );
  }

  // 기존 alert / confirm 2-button (변경 없음 — 사용자 작업물 우선)
  return (
    <CustomDialog
      open={isOpenAlert}
      contentArea={alertProps.content}
      customHeaderTitle={alertProps.header}
      handleSubmit={() => {
        resolve(true);
        alertProps.onConfirm?.();
      }}
      handleClose={() => {
        resolve(false);
        alertProps.onClose?.();
        close();
      }}
      position='basic'
      size={400}
      disableButtonCancel={alertProps.type !== 'confirm'}
      draggable={false}
    />
  );
};
