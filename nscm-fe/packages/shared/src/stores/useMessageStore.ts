import { createPersistedStore } from './createStore';

interface ToastProps {
  message: string;
  duration?: number;
  type?: 'default' | 'success' | 'error' | 'warning';
}

/**
 * G6 (Phase 5, 2026-06-03) — AlertProps 의 type 에 'yesNoCancel' 3옵션 추가.
 * AS-IS MessageHelper.GMessageBox Button 코드 '0202004' (YesNoCancel) 매핑.
 */
interface AlertProps {
  type?: 'alert' | 'confirm' | 'yesNoCancel';
  header?: string;
  content: string;
  onClose?: () => void;
  onConfirm?: () => void;
}

/**
 * G6 — yesNoCancel 의 3-state 결과 type.
 * - 'yes' = Yes 클릭
 * - 'no' = No 클릭
 * - 'cancel' = Cancel 클릭 또는 닫기
 */
export type YesNoCancelResult = 'yes' | 'no' | 'cancel';

interface MessageState {
  isOpenToast: boolean;
  duration: number;
  toastProps: ToastProps;
  isOpenAlert: boolean;
  alertProps: AlertProps;
  resolve: (value: boolean | YesNoCancelResult) => void;
}

interface MessageAction {
  reset: () => void;
  close: () => void;
  setToast: (toast: ToastProps) => void;
  setAlert: (alert: AlertProps) => Promise<boolean>; // TODO: refactor; return type: Promise<boolean> - donglee
  /** G6 — YesNoCancel 3옵션 confirm (Phase 5 신규) */
  setConfirmYesNoCancel: (alert: Omit<AlertProps, 'type'>) => Promise<YesNoCancelResult>;
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
          state.resolve = resolve as (value: boolean | YesNoCancelResult) => void;
        });
      });
    },
    setConfirmYesNoCancel: alertProps => {
      return new Promise<YesNoCancelResult>(resolve => {
        set(state => {
          state.alertProps = { ...alertProps, type: 'yesNoCancel' };
          state.isOpenAlert = true;
          state.resolve = resolve as (value: boolean | YesNoCancelResult) => void;
        });
      });
    },
  }),
  'message-store'
);
