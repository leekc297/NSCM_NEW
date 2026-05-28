import { CustomDialog } from '@shared/components/molecules';
import { useMessageStore } from '@shared/stores';

export const Alert = () => {
  const { isOpenAlert, alertProps, close, resolve } = useMessageStore();
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
