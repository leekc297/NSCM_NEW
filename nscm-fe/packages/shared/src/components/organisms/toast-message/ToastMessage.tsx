import clsx from 'clsx';
import { useEffect } from 'react';

import { MessageBar } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import styles from './ToastMessage.module.scss';

export const ToastMessage = () => {
  const { closeToast, duration, isOpenToast, toastProps } = useMessageStore();
  useEffect(() => {
    // 자동닫힘은 토스트만 닫는다. 알림(Alert)은 여기서 건드리지 않는다 — 예전엔 이 타이머가
    //   알림창까지 같이 꺼버렸다. 열려 있을 때만 타이머를 건다.
    if (!isOpenToast) return;
    const timer = setTimeout(closeToast, duration);

    return () => clearTimeout(timer);
  }, [isOpenToast, closeToast, duration]);

  return (
    <MessageBar
      usecase={toastProps.type}
      className={clsx(styles.toastContainer, { [styles.open]: isOpenToast })}
    >
      {toastProps.message}
    </MessageBar>
  );
};
