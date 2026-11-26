import './immer-setup';
import './dayjs-setup';
import '@foundation/i18n';
import React from 'react';
import ReactDOM from 'react-dom/client';

import { App } from './core/App';
import '@foundation/styles/wijmo/wijmo.scss';
import '@foundation/styles/date-picker.scss';
import '@foundation/styles/input-selection.scss';

// 빌드 환경(.env.* 의 VITE_ENV)을 <html data-env="..."> 로 새긴다.
// 레이어 색 등 환경별 테마 오버라이드(_global.scss 의 [data-env='stg'])의 기준이 된다.
document.documentElement.dataset.env = import.meta.env.VITE_ENV;

const root = document.getElementById('root');
if (root) {
  ReactDOM.createRoot(root).render(<App />);
}

// TODO: remove, non-strict 테스트용
// if (root) {
//   ReactDOM.createRoot(root).render(<App />);
// }
