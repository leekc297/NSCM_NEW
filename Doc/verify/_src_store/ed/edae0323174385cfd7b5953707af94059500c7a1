import { createContext } from 'react';

import { createStandardStore } from './createStore';

/**
 * 현재 서브트리가 속한 다이얼로그 스코프 id.
 * 페이지 최상위(다이얼로그 밖)는 root 스코프로 취급하며 null.
 * CustomDialog가 자신의 스코프 id로 Provider를 씌운다.
 */
export const DialogScopeContext = createContext<string | null>(null);

interface DialogState {
  /**
   * 열려 있는 다이얼로그 스코프 id 스택.
   * 마지막(top)이 현재 활성(포커스) 스코프이며, 그 스코프의 단축키만 동작해야 한다.
   */
  scopeStack: string[];
}

interface DialogAction {
  /** 다이얼로그가 열릴 때 자신의 스코프 id를 스택에 push */
  pushScope: (scopeId: string) => void;
  /** 다이얼로그가 닫히거나 언마운트될 때 자신의 스코프 id를 스택에서 제거 */
  popScope: (scopeId: string) => void;
  /**
   * 주어진 스코프가 현재 활성(최상위) 스코프인지 여부.
   * 스택이 비어 있으면 root(null)가 활성이다.
   */
  isActiveScope: (scopeId: string | null) => boolean;
}

const initDialogState: DialogState = {
  scopeStack: [],
};

/**
 * 열려 있는 CustomDialog 스코프 스택을 추적하는 비영속 스토어.
 * 부모 화면과 팝업 각각의 SubTitle 단축키가 "현재 활성 스코프"에서만 동작하도록 게이트하는 데 사용한다.
 * 포커스/모달리스 여부와 무관하게 스택의 top이 활성 스코프를 결정한다.
 */
export const useDialogStore = createStandardStore<DialogState & DialogAction>(
  (set, get) => ({
    ...initDialogState,
    pushScope: scopeId => {
      set(state => {
        state.scopeStack.push(scopeId);
      });
    },
    popScope: scopeId => {
      set(state => {
        state.scopeStack = state.scopeStack.filter(id => id !== scopeId);
      });
    },
    isActiveScope: scopeId => {
      const stack = get().scopeStack;
      const top = stack.length > 0 ? stack[stack.length - 1] : null;
      return top === scopeId;
    },
  }),
  'dialog-store'
);
