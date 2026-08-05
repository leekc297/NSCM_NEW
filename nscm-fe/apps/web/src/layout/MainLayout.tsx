import { clsx } from '@shared/clsx';

import { MDIContainer } from '../mdi/MDIContainer';
import { NotFoundPage } from '../pages/NotFound';

import { Header } from './header/Header';
import styles from './MainLayout.module.scss';
import { Sidebar } from './sidebar/Sidebar';
import { useGuestNotice } from './useGuestNotice';

interface MainLayoutProps {
  /** 알 수 없는 경로 — 앱 셸(헤더/사이드바)은 유지한 채 컨텐츠 영역에 404 를 표시한다 */
  notFound?: boolean;
}

export const MainLayout = ({ notFound = false }: MainLayoutProps) => {
  useGuestNotice(); // 게스트 로그인 시 "권한 없음 → 권한신청" 안내
  return (
    <>
      <Header />
      <div className={clsx(styles.layoutContent, { [styles.showMenu]: true })}>
        <Sidebar />
        <main className={styles.pageContent}>
          {/*
            404 중에도 열린 탭은 마운트를 유지한다(keep-alive) — 표시만 감춘다.
            언마운트하면 그리드 스크롤·입력 등 탭 상태가 날아가 MDI 설계 취지에 어긋난다.
            display:contents 는 평상시 레이아웃에 영향을 주지 않는다.
          */}
          <div style={{ display: notFound ? 'none' : 'contents' }}>
            <MDIContainer mirrorRouteOnMount={!notFound} />
          </div>
          {notFound && <NotFoundPage />}
        </main>
      </div>
    </>
  );
};
