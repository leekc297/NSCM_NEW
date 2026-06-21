import './dayjs-setup';
import '@foundation/i18n';
import React from 'react';
import ReactDOM from 'react-dom/client';

import { App } from './core/App';
import '@foundation/styles/wijmo/wijmo.scss';

const root = document.getElementById('root');
if (root) {
  ReactDOM.createRoot(root).render(<App />);
}

// TODO: remove, non-strict 테스트용
// if (root) {
//   ReactDOM.createRoot(root).render(<App />);
// }
