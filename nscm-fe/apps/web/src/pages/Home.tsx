import { useState } from 'react';

import { formatDate } from '@foundation/utils';
import { InputField, Button } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

export const HomePage = () => {
  const [id, setId] = useState('minyonglee1');

  const isLogin = useSessionStore(state => state.isLogin);
  const login = useSessionStore(state => state.login);
  const logout = useSessionStore(state => state.logout);
  const session = useSessionStore(state => state.session);

  return (
    <div style={{ padding: '20px' }}>
      <h1>This page must be deprecated!!!!!</h1>
      <p>Today: {formatDate(new Date())}</p>
      {isLogin ? (
        <>
          <p>Welcome, {session.userNm}!</p>
          <Button onClick={() => logout()}>Logout</Button>
        </>
      ) : (
        <form>
          <InputField type='text' value={id} onChange={e => setId(e.target.value)} />
          <Button onClick={() => login(id)}>Login</Button>
        </form>
      )}
    </div>
  );
};
