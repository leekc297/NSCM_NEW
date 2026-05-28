import clsx from 'clsx';
import { useEffect } from 'react';

import { MessageBar } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import styles from './ToastMessage.module.scss';

export const ToastMessage = () => {
  const { close, duration, isOpenToast, toastProps } = useMessageStore();
  useEffect(() => {
    const timer = setTimeout(close, duration);
    return () => clearTimeout(timer);
  }, [isOpenToast]);
  return (
    <MessageBar
      usecase={toastProps.type}
      className={clsx(styles.toastContainer, { [styles.open]: isOpenToast })}
    >
      {toastProps.message}
    </MessageBar>
  );
};
