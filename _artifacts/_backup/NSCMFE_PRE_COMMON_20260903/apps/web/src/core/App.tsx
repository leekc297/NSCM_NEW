import { RouterProvider } from 'react-router-dom';

import { Hotkeys } from '@foundation/models';

import { Providers } from './Providers';
import { router } from './Router';

export const App = () => {
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
