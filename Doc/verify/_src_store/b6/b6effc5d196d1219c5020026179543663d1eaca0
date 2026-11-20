import { createPersistedStore } from './createStore';

interface ToastProps {
  message: string;
  duration?: number;
  type?: 'default' | 'success' | 'error' | 'warning';
}

interface AlertProps {
  type?: 'alert' | 'confirm';
  header?: string;
  content: string;
  onClose?: () => void;
  onConfirm?: () => void;
}

interface MessageState {
  isOpenToast: boolean;
  duration: number;
  toastProps: ToastProps;
  isOpenAlert: boolean;
  alertProps: AlertProps;
  resolve: (value: boolean) => void;
}

interface MessageAction {
  reset: () => void;
  // 주의: 토스트와 알림은 각자 닫는다. 예전엔 close() 하나가 둘 다 껐는데, 토스트 자동닫힘(4초)
  //   타이머가 그 사이 뜬 알림창까지 같이 꺼버리는 버그가 있었다. 두 상태의 생명주기는 독립이다.
  closeToast: () => void;
  closeAlert: () => void;
  setToast: (toast: ToastProps) => void;
  setAlert: (alert: AlertProps) => Promise<boolean>; // TODO: refactor; return type: Promise<boolean> - donglee
}

const initMessageState: MessageState = {
  isOpenToast: false,
  duration: 4000,
  toastProps: { message: '' },
  isOpenAlert: false,
  alertProps: { content: '' },
  resolve: () => false,
};

export const useMessageStore = createPersistedStore<MessageState & MessageAction>(
  (set, _get) => ({
    ...initMessageState,
    reset: () => set(initMessageState),
    closeToast: () => {
      set(state => {
        state.isOpenToast = false;
      });
    },
    closeAlert: () => {
      set(state => {
        state.isOpenAlert = false;
      });
    },
    setToast: toastProps => {
      set(state => {
        state.toastProps = toastProps;
        state.isOpenToast = true;
      });
    },
    setAlert: alertProps => {
      return new Promise(resolve => {
        set(state => {
          state.alertProps = alertProps;
          state.isOpenAlert = true;
          state.resolve = resolve;
        });
      });
    },
  }),
  'message-store'
);
