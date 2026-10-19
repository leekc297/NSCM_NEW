import './immer-setup';
import './dayjs-setup';
import '@foundation/i18n';
import React from 'react';
import ReactDOM from 'react-dom/client';

import { App } from './core/App';
import '@foundation/styles/wijmo/wijmo.scss';
import '@foundation/styles/date-picker.scss';
import '@foundation/styles/input-selection.scss';

const root = document.getElementById('root');
if (root) {
  ReactDOM.createRoot(root).render(<App />);
}

// TODO: remove, non-strict 테스트용
// if (root) {
//   ReactDOM.createRoot(root).render(<App />);
// }
