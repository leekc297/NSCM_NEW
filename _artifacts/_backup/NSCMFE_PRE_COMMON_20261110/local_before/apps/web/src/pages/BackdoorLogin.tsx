import { useState } from 'react';

import { InputField, Button } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import styles from './Home.module.scss';

// 운영 백도어 ID 로그인. 운영 홈은 미로그인 시 SSO 로 보내므로 ID 로그인은 이 경로에서만 한다.
// MDI 셸(MainLayout) 밖에 둔다. 셸 안이면 RouterSync 가 URL 을 활성 탭(/view/home)으로 덮어쓴다.
// 주의: 주소만 분리했고 BE /user/login 은 IP 제한 없이 열려 있다. 이 주소를 아는 사람은 누구나 ID 로그인할 수 있다.
export const BackdoorLogin = () => {
  const [id, setId] = useState('');
  const [failed, setFailed] = useState(false);
  const login = useSessionStore(state => state.login);

  const handleLogin = async () => {
    if (!id.trim()) return;
    setFailed(false);
    await login(id.trim());
    if (!useSessionStore.getState().isLogin) {
      setFailed(true);
      return;
    }
    // 셸을 새로 띄워 세션/메뉴를 다시 받는다.
    globalThis.window.location.assign('/');
  };

  return (
    <div className={styles.homeWrapper}>
      <form className={styles.devLogin} onSubmit={e => e.preventDefault()}>
        <InputField type='text' value={id} onChange={e => setId(e.target.value)} />
        <Button onClick={() => void handleLogin()}>Login</Button>
      </form>
      {failed && <div>Login failed.</div>}
    </div>
  );
};
