import './dayjs-setup';
import '@foundation/i18n';
import React from 'react';
import ReactDOM from 'react-dom/client';

import { App } from './core/App';
import '@foundation/styles/wijmo/wijmo.scss';
// Filter Modal 디자인 표준 보완 — 벤더 wijmo 테마 다음에 로드(override 우선) (2026-06-28)
import '@foundation/styles/filter-modal.scss';
// 공통 DatePicker date-range 구분자 '-' 정렬(세로·가로 가운데) 전역 보완 (2026-07-06)
import '@foundation/styles/date-picker.scss';

const root = document.getElementById('root');
if (root) {
  ReactDOM.createRoot(root).render(<App />);
}

// TODO: remove, non-strict 테스트용
// if (root) {
//   ReactDOM.createRoot(root).render(<App />);
// }
