import { CustomDialog } from '@shared/components/molecules';
import { useMessageStore } from '@shared/stores';

export const Alert = () => {
  const { isOpenAlert, alertProps, closeAlert, resolve } = useMessageStore();
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
        closeAlert();
      }}
      position='basic'
      size={400}
      disableButtonCancel={alertProps.type !== 'confirm'}
      draggable={false}
      disableScale
    />
  );
};
