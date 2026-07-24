import type { Router as RemixRouter } from '@remix-run/router'; // 타입을 가져옵니다.
import { createBrowserRouter } from 'react-router-dom';

import { ROUTE_PATHS } from '@foundation/constants';

import { MainLayout } from '../layout/MainLayout';
import { Templates } from '../pages/Templates';

// 화면 렌더링은 MDI(ViewContainer, keep-alive)가 소유한다.
// 라우터는 앱 셸(MainLayout) 매칭과 URL 미러 용도만 담당하며,
// 실제 탭 ↔ URL(/view/:mnuId/:tabId) 동기화는 mdi/RouterSync 가 처리한다.
// (path → 화면 컴포넌트 매핑은 mdi/viewRegistry 로 이동)
//
// 알 수 없는 경로는 404 로 떨어뜨린다. 따라서 셸이 떠야 하는 경로는 아래에 명시해야 한다.
export const router: RemixRouter = createBrowserRouter([
  {
    path: '/ui',
    element: <Templates />,
  },
  {
    // 루트 · 홈(헤더 로고 링크) → 셸 매칭 후 RouterSync 가 활성 탭 URL 로 보정
    path: '/',
    element: <MainLayout />,
  },
  {
    path: `/${ROUTE_PATHS.HOME}`,
    element: <MainLayout />,
  },
  {
    // MDI 탭 딥링크
    path: '/view/:mnuId/:tabId',
    element: <MainLayout />,
  },
  {
    // 그 외 모든 경로 → 셸은 유지한 채 404 (열린 탭은 마운트 유지)
    path: '*',
    element: <MainLayout notFound />,
  },
]);
