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
  close: () => void;
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
    close: () => {
      set(state => {
        state.isOpenToast = false;
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
