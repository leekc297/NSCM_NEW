import { useEffect } from 'react';
import { RouterProvider } from 'react-router-dom';

import { Hotkeys } from '@foundation/models';
import { useSessionStore } from '@shared/stores';

import { Providers } from './Providers';
import { router } from './Router';

export const App = () => {
  const fetchSession = useSessionStore(state => state.fetchSession);

  // 앱 로드 시 백엔드 세션(JSESSIONID) 기준으로 로그인 상태를 하이드레이션한다.
  // SSO/dev-login 처럼 login() 액션을 거치지 않고 서버 세션만 생성된 경우에도 isLogin 이 반영된다.
  useEffect(() => {
    void fetchSession();
  }, [fetchSession]);

  globalThis.window.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
    if (keyboardEvent.key in Hotkeys) {
      keyboardEvent.preventDefault();
    }
  });
  return (
    <Providers>
      <RouterProvider router={router} />
    </Providers>
  );
};
