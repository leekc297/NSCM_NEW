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
                path: ROUTE_PATHS.SYS0002,
                element: <UserManagementPageWithTab />,
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
              {
                path: ROUTE_PATHS.SYS0014,
                element: <GroupUserPage />,
              },
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
        path: ROUTE_PATHS.MASTER,
        children: [
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
        ],
      },
      {
        path: ROUTE_PATHS.DEMAND,
        children: [
          {
            path: ROUTE_PATHS.DEMAND_PLAN,
            children: [
              {
                path: ROUTE_PATHS.DMF0082,
                element: <ForecastPricePageWithTab />,
              },
              // T O D O: replace with actual path name
              {
                path: 'dmf0014',
                element: <CustomerFcstUploadPageWithTab />,
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
