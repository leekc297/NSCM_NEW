import type { Router as RemixRouter } from '@remix-run/router'; // 타입을 가져옵니다.
import { createBrowserRouter, Navigate } from 'react-router-dom';

import { ROUTE_PATHS } from '@foundation/constants';

import { MainLayout } from '../layout/MainLayout';
import { HomePage } from '../pages/Home';
import { NotFoundPage } from '../pages/NotFound';
import { Templates } from '../pages/Templates';

import { LazyLoader } from './LazyLoader';

// @admin
const UICategorySetupWithTab = LazyLoader(() =>
  import('@admin/ui-catrgory-setup').then(m => ({ default: m.UICategorySetup }))
);
const MessageManagementPageWithTab = LazyLoader(() =>
  import('@admin/message-management').then(m => ({ default: m.MessageManagement }))
);
const MenuManagementPageWithTab = LazyLoader(() =>
  import('@admin/menu-management').then(m => ({ default: m.MenuManagement }))
);
const GroupManagementPageWithTab = LazyLoader(() =>
  import('@admin/group-management').then(m => ({ default: m.GroupManagement }))
);
const ProcedureManagementPageWithTab = LazyLoader(() =>
  import('@admin/procedure-management').then(m => ({ default: m.ProcedureManagement }))
);
const ApiManagementPageWithTab = LazyLoader(() =>
  import('@admin/api-management').then(m => ({ default: m.ApiManagement }))
);
const UserManagementPageWithTab = LazyLoader(() =>
  import('@admin/user-management').then(m => ({ default: m.UserManagement }))
);
const MenuBtnManagementPageWithTab = LazyLoader(() =>
  import('@admin/menu-button-management').then(m => ({ default: m.MenuButtonManagement }))
);
const GroupUserPage = LazyLoader(() =>
  import('@admin/group-user').then(m => ({ default: m.GroupUser }))
);
const ProgramPage = LazyLoader(() => import('@admin/program').then(m => ({ default: m.Program })));
const GroupMenuPageWithTab = LazyLoader(() =>
  import('@admin/group-menu').then(m => ({ default: m.GroupMenu }))
);
const LookupPageWithTab = LazyLoader(() =>
  import('@admin/lookup').then(m => ({ default: m.Lookup }))
);
const DynamicQueryListPageWithTab = LazyLoader(() =>
  import('@admin/dynamic-query').then(m => ({ default: m.DynamicQuery }))
);

// ⚠️ dynamic-query-new(SYS0013_01) — 로컬 repo 에 features/admin/src/pages/dynamic-query-new 폴더 부재
//   (클라우드 신규 화면 — Router 만 선행 이관됨). 폴더 이관 후 본 블록 + 아래 라우트 블록 주석 해제. (2026-07-21)
// const DynamicQueryNewListPageWithTab = LazyLoader(() =>
//   import('@admin/dynamic-query-new').then(m => ({ default: m.DynamicQuery }))
// );

// @authority
const AuthRequestPageWithTab = LazyLoader(() =>
  import('@authority/auth-request').then(m => ({ default: m.AuthRequest }))
);
const AuthApprovalPageWithTab = LazyLoader(() =>
  import('@authority/auth-approval').then(m => ({ default: m.AuthApproval }))
);

// @master
const SalesSiteWithTab = LazyLoader(() =>
  import('@master/sales-site').then(m => ({ default: m.SalesSite }))
);
const CustomerModelMappingWithTab = LazyLoader(() =>
  import('@master/customer-model-mapping').then(m => ({ default: m.CustomerModelMapping }))
);
const SalesSiteProjectModelWithTab = LazyLoader(() =>
  import('@master/sales-site-project-model').then(m => ({ default: m.SalesSiteProjectModel }))
);
const CustomerFcstMasterWithTab = LazyLoader(() =>
  import('@master/customer-forecast-master').then(m => ({ default: m.CustomerFcstMaster }))
);
const ErpEdiMasterWithTab = LazyLoader(() =>
  import('@master/erp-edi-master').then(m => ({ default: m.ErpEdiMaster }))
);
const SalesFuturePriceWithTab = LazyLoader(() =>
  import('@master/sales-future-price').then(m => ({ default: m.SalesFuturePrice }))
);
const ContributeMainWithTab = LazyLoader(() =>
  import('@master/contribute-main').then(m => ({ default: m.ContributeMain }))
);
const ContributeViewWithTab = LazyLoader(() =>
  import('@master/contribute-view').then(m => ({ default: m.ContributeView }))
);
const NnMasterMappingWithTab = LazyLoader(() =>
  import('@master/nn-master-mapping').then(m => ({ default: m.NnMasterMapping }))
);

// @demand
const ForecastPricePageWithTab = LazyLoader(() =>
  import('@demand/forecast-price').then(m => ({ default: m.ForecastPrice }))
);
const CustomerFcstUploadPageWithTab = LazyLoader(() =>
  import('@demand/customer-fcst-upload').then(m => ({ default: m.CustomerFcstUpload }))
);
const SalesMonitoringPageWithTab = LazyLoader(() =>
  import('@demand/sales-monitoring').then(m => ({ default: m.SalesMonitoring }))
);
const MetalLinkPricePageWithTab = LazyLoader(() =>
  import('@demand/metal-link-price').then(m => ({ default: m.MetalLinkPrice }))
);
// ⭐ DMF0003 / DMF0021 — 로컬 개발 화면 라우트 재등록 (클라우드 Router 유지 + 3화면 메뉴 연동, 2026-07-21)
const MktFcstPageWithTab = LazyLoader(() =>
  import('@demand/mkt-fcst').then(m => ({ default: m.MktFcst }))
);
const SalesPlanPageWithTab = LazyLoader(() =>
  import('@demand/sales-plan').then(m => ({ default: m.SalesPlan }))
);

// @report
const SalesPlanWaterfallWithTab = LazyLoader(() =>
  import('@report/sales-plan-waterfall').then(m => ({ default: m.SalesPlanWaterfall }))
);

// etc.

export const router: RemixRouter = createBrowserRouter([
  {
    path: '/',
    element: <MainLayout />,
    // TODO: 500 Error handle page
    // errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <Navigate to={ROUTE_PATHS.HOME} replace />,
      },
      {
        path: 'ui',
        element: <Templates />,
      },
      {
        path: ROUTE_PATHS.HOME,
        element: <HomePage />,
      },
      {
        path: ROUTE_PATHS.ADMIN,
        children: [
          {
            path: ROUTE_PATHS.ADMIN_MENU,
            children: [
              {
                path: ROUTE_PATHS.SYS0010,
                element: <LookupPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0013,
                element: <DynamicQueryListPageWithTab />,
              },
              // ⚠️ dynamic-query-new(SYS0013_01) — 폴더 부재로 임시 비활성 (위 import 블록 참조). 폴더 이관 후 복구.
              // {
              //   path: ROUTE_PATHS.SYS0013_01,
              //   element: <DynamicQueryNewListPageWithTab />,
              // },
              // SYS0002(User), SYS0014(Group User): 부모가 System → Admin_Menu 로 변경됨
              {
                path: ROUTE_PATHS.SYS0002,
                element: <UserManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0014,
                element: <GroupUserPage />,
              },
            ],
          },
          {
            path: ROUTE_PATHS.SYSTEM,
            children: [
              {
                path: ROUTE_PATHS.SYS0001,
                element: <MessageManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0003,
                element: <MenuManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0004,
                element: <UICategorySetupWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0005,
                element: <ProcedureManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0006,
                element: <ApiManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0007,
                element: <GroupManagementPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0008,
                element: <GroupMenuPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0009,
                element: <MenuBtnManagementPageWithTab />,
              },
              // SYS0015(Program): USE_YN=N(메뉴 비활성) — 직접 URL 접근 대비 라우트는 유지
              {
                path: ROUTE_PATHS.SYS0015,
                element: <ProgramPage />,
              },
            ],
          },
        ],
      },
      {
        path: ROUTE_PATHS.AUTHORITY,
        children: [
          {
            path: ROUTE_PATHS.AUTH_MGMT,
            children: [
              {
                path: ROUTE_PATHS.SYS0011,
                element: <AuthRequestPageWithTab />,
              },
              {
                path: ROUTE_PATHS.SYS0012,
                element: <AuthApprovalPageWithTab />,
              },
            ],
          },
        ],
      },
      {
        path: ROUTE_PATHS.DEMAND,
        children: [
          // Demand_Master: 부모가 Master → Demand 로 변경 (Master 메뉴는 USE_YN=N 비활성)
          {
            path: ROUTE_PATHS.DEMAND_MASTER,
            children: [
              {
                path: ROUTE_PATHS.DMF0004,
                element: <SalesSiteWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0006,
                element: <CustomerModelMappingWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0005,
                element: <SalesSiteProjectModelWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0007,
                element: <CustomerFcstMasterWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0008,
                element: <ErpEdiMasterWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0020,
                element: <SalesFuturePriceWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0043,
                element: <ContributeMainWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0043_01,
                element: <ContributeViewWithTab />,
              },
              {
                path: ROUTE_PATHS.DMF0072,
                element: <NnMasterMappingWithTab />,
              },
            ],
          },
          {
            path: ROUTE_PATHS.DEMAND_PLAN,
            children: [
              {
                path: ROUTE_PATHS.DMF0082,
                element: <ForecastPricePageWithTab />,
              },
              // DMF0048 — Sales Monitoring (판매 모니터링).
              {
                path: ROUTE_PATHS.DMF0048, // ★ DMF0048
                element: <SalesMonitoringPageWithTab />,
              },
              // DMF0014 — Customer FCST Upload. slug = 'dmf0014'
              {
                path: ROUTE_PATHS.DMF0014, // ★ DMF0014
                element: <CustomerFcstUploadPageWithTab />,
              },
              // DMF0074 — Metal Link Price (메탈 판가 연동). ROUTE_PATHS.DMF0074='metal-link-price' = MNU_URL 정합(필수).
              {
                path: ROUTE_PATHS.DMF0074,
                element: <MetalLinkPricePageWithTab />,
              },
              // DMF0003 — MKT FCST (시장예측). slug 'mkt_forecast' = SCM_ADM_MNU_M.MNU_URL 정합(라우트 3-SET, 리터럴).
              {
                path: 'mkt_forecast',
                element: <MktFcstPageWithTab />,
              },
              // DMF0021 — Sales Plan (판매계획). ROUTE_PATHS.DMF0021='sales-plan' = MNU_URL 정합(라우트 3-SET).
              {
                path: ROUTE_PATHS.DMF0021,
                element: <SalesPlanPageWithTab />,
              },
            ],
          },
        ],
      },
      {
        path: ROUTE_PATHS.REPORT,
        children: [
          {
            path: ROUTE_PATHS.WATERFALL,
            children: [
              {
                path: ROUTE_PATHS.DMF0022,
                element: <SalesPlanWaterfallWithTab />,
              },
            ],
          },
        ],
      },
      {
        path: '*',
        element: <NotFoundPage />, // errorPage
      },
      // ...session.menus.map(menu => ({ path: menu.path, element: <></> })),
    ],
  },
]);
